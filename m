Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab2JCJXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 05:23:35 -0400
Received: from www84.your-server.de ([213.133.104.84]:41750 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2JCJXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 05:23:33 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2012 05:23:32 EDT
Message-ID: <1349254268.16946.35.camel@wall-e>
Subject: losetup kernel crash in drivers/block/loop.c kernel 3.4.11
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Dave Young <dyoung@redhat.com>,
        JeffMoyer <jmoyer@redhat.com>
Date: Wed, 03 Oct 2012 10:51:08 +0200
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i am faced with a strange kernel crash while removing a loopback device
with losetup, during a software update of my embedded device, which was
introduced between 3.0 and 3.4. All other used kernels 2.6.39, 2.6.35,
2.6.33, 2.6.29, 2.6.27 and 2.6.20 works well.

BUG: unable to handle kernel NULL pointer derference at 00000041
IP: [<c019faef>] invalidate_bdev+0x4/0x26
*pde = 00000000
Ooops: 0000 I#11 PREEMNT SMP
Modules linked in: vfat fat i915 drm_kms_helper drm intel_agp i2c_algo_bit intel_gtt agpgart video backlight e1000e usb_storage

Pid: 869, comm: losetup Tainted G            8.3.4
EIP: 0060:[<c0194aef>] EFLAGS: 00010282 CPU: 1
EIP is at invalidate_bdev+0x4/0x26
EAX: 00000029 EBX: f63c1c00 ECX: 00000000 EDX: f63c1e20
ESI: f5c6bc80 EDI: f63c1c60 EBP: f596e500 ESP: f5053e54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 00000041 CR3: 324ae000 CR4: 000407d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process losetup (pid: 869, ti=f5052000 task=f616c0c0 task.ti=f5052000)
Stack:
 f63c1c00 c0277449 000200da f63c1c00 ffffffe7 00004c01 f5c39900 c02784d0
 f5d750a4 00000000 f5053efc f5d750a4 f5269900 c017dda6 0000001d 00008000
 f63c1cfc c027897b ffffffe7 00004c01 f5053f10 c0202021 00000000 f5c39900
Call Trace:
 [<c0277449>] ? loop_clr_fd+0x11/0x1d6
 [<c02784d0>] ? lo_ioctl+0x455/0x62b
 [<c017dda6>] ? do_last.clone.32+0x55b/0x5d5
 [<c027807b>] ? loop_switch.clone.13+0x67/0x67
 [<c0202021>] ? __blkdev_driver_ioctl+0x1d/0x25
 [<c0202905>] ? blkdev_ioctl+0x6a3/0x6c2
 [<c016800d>] ? handle_pte_fault+0x21d/0x7ad
 [<c017e19b>] ? do_file_open+0x21/0x5d
 [<c019425b>] ? block_ioctl+0x2f/0x34
 [<c019425b>] ? block_ioctl+0x2f/0x34
 [<c019422c>] ? bd_set_size+0x60/0x60
 [<c017fe00>] ? do_vfs_ioctl+0x455/0x492
 [<c01181d3>] ? do_page_fault+0x30f/0x32c
 [<c017293a>] ? fd_install+0x1e/0x3d
 [<c0173865>] ? do_sys_open+0x17e/0x188
 [<c017feea>] ? sys_ioctl+0x2d/0x47
 [<c033f7c1>] ? syscall+0x7/0xb
Code: 00 89 f0 5b 5e 5f c3 53 8b 40 08 8b 58 18 83 7b 3c 00 74 11 e8 3f b9 ff ff 89 d8 31 d2 31 c9 5b e9 ba 8e fc ff 5b c3 53 8b 40 08 (8b) 58 18 83 7b 3c 00 74 17 e8  1f b9 ff ff e8 4e 88 fc ff 89 d8
EIP: [<c019eaef>] invalidate_bdev+0x4/0x26 SS:ESP 0068:f5053e54
CR2: 0000000000000041

This dump was copied by hand from a smart phone screenshot, i hope there
are no typos.

It is not possible to write a demo program which reproduce this bug due
the complexity, so i will explain what going on.

First mount a kernel which include a initramfs doing the following:

/bin/mount -t proc none /proc
/bin/mount -o rw,data=journal,barrier=1,errors=remount-ro /dev/sda3 /mnt
/bin/mount -o loop /mnt/rootfs.squashfs /rootfs
/bin/mount -o loop modules.squashfs /rootfs/lib/modules
/bin/mount -o move /mnt /rootfs/rw
/bin/umount /proc
exec /rootfs/bin/sh -c 'exec /sbin/switch_root -c /dev/console /rootfs /sbin/init'
exec /bin/sh

The Squashfs-Image will be mounted and will be the new root filesystem,
the file system of /dev/sda3 will be then mounted under /rw.

The reason to do this is, that is is very easy to exchange the root
filesystem, since it it only a plain image file. And there is no extra
partition necessary which can be to small in the future.

Also the kernel modules will be a squashfs image as a part of the
initramfs. This make it safe to exchange the kernel, because it will
change togehter with the modules.

After starting the new init process of the rootfs.squashfs the firmware
image opfs.squashfs will be mounted also via loopback block device
at /opt.

When the user decide to do an update, a new rootfs.squashf will be
copied into a ramdisk and the following script (snippet) will be
executed:

cat <<EOF >/tmp/init
#!/bin/sh
exec </dev/console
exec >/dev/console
exec 2>/dev/console
umount /init/opt
umount -l -r /init/rw
umount -l -r /init
umount /etc 
rm -rf /tmp/etc
sync
for i in /dev/loop*
do
	losetup -d $i 2>/dev/null
done
rm \$0
exec /tmp/update.sh "$1" "$2"
reboot -f
EOF
	chmod a+x /tmp/init
	
	echo "::restart:/tmp/init" >/tmp/etc/inittab

	mount -o ro /dev/ramdisk /mnt
	cd /mnt
	/sbin/pivot_root . init

	mount -o move /init/tmp /tmp
	mount -o move /init/proc /proc
	mount -o move /init/sys /sys
	mount -o move /init/dev/pts /dev/pts
	mount -o move /init/dev/shm /dev/shm
	mount -o bind /tmp/etc /etc

	init -q	
	sleep 1
	kill -SIGQUIT 1
	exit

Now the update.sh script has the control over the system, no more
application or daemons will running and all mass storages should be
unmounted.

Till this everything is working fine, than the update.sh will execute
the following code:

rm -f /rw/optfs.squashfs

for i in /dev/loop*
do
	losetup -d $i 2>/dev/null
done

This will remove the old firmware and all possible loopback devices.
Executing the losetup will crash the kernel and will produce the Oops
above.

This is independent to the underlying file system or the processor
architecture, it will happen on x86 or ppc and ext3fs and yaffs2 as
well.

Any idea?

- Stefani


