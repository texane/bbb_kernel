#!/usr/bin/env sh

[ -d /mnt/bootfs ] || mkdir /mnt/bootfs
[ -d /mnt/rootfs ] || mkdir /mnt/rootfs

sudo mount /dev/sdb1 /mnt/bootfs
sudo mount /dev/sdb2 /mnt/rootfs

PATH=`pwd`/../../../uboot/u-boot-2013.07/tools/:$PATH make \
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage dtbs -j4 LOADADDR=0x80200000

PATH=`pwd`/../../../uboot/u-boot-2013.07/tools/:$PATH make \
ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- uImage-dtb.am335x-boneblack -j4 LOADADDR=0x80200000

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- modules -j4

sudo make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- INSTALL_MOD_PATH=/mnt/rootfs/ modules_install

sudo cp ./arch/arm/boot/dts/am335x-boneblack.dtb /mnt/bootfs/dtbs/am335x-boneblack.dtb
sudo cp arch/arm/boot/zImage /mnt/bootfs/zImage
sudo ../../../uboot/u-boot-2013.07/tools/mkimage -A arm -O linux -T ramdisk -C gzip \
-a 0x81000000 -n initramfs -d /mnt/bootfs/initrd.img /mnt/bootfs/uInitrd

sudo umount /mnt/rootfs
sudo umount /mnt/bootfs
