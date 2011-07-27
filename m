Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1G0Gyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:54:46 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:40633 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab1G0Gyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:54:43 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 12:24:41 +0530
Message-ID: <CAKVu3COpNuFnBzHLwvVPmDOA2XNwHmwDLv6gjvquw6UJ7vU5Mw@mail.gmail.com>
Subject: PROBLEM: kernel panic in do_direct_IO
From: Gangadhar Mylapuram <gangadhar.m@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not sure whom to contact with respect to this panic. Sending it
to linux-kernel@vger.kernel.org. Please cc me in all your
communication.


Here are the problem details:

[1.] One line summary of the problem:

The following panic message is seen with below script.


 [<ffffffff800e3e35>] blkdev_direct_IO+0x32/0x37
 [<ffffffff800e3d6d>] blkdev_get_blocks+0x0/0x96
 [<ffffffff800c4c91>] generic_file_direct_IO+0xff/0x119
 [<ffffffff8001edd1>] generic_file_direct_write+0x60/0xf2
 [<ffffffff8001646e>] __generic_file_aio_write_nolock+0x2b8/0x3b6
 [<ffffffff800e3e35>] blkdev_direct_IO+0x32/0x37
 [<ffffffff800e3d6d>] blkdev_get_blocks+0x0/0x96
 [<ffffffff800c4e16>] generic_file_aio_write_nolock+0x20/0x6c
 [<ffffffff800c51ed>] generic_file_write_nolock+0x8f/0xa8
 [<ffffffff800c5145>] generic_file_read+0xac/0xc5
 [<ffffffff8009f6c1>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80062fc8>] thread_return+0x62/0xfe
 [<ffffffff800e2c34>] blkdev_file_write+0x1a/0x1f
 [<ffffffff80016927>] vfs_write+0xce/0x174
 [<ffffffff80043e1d>] sys_pwrite64+0x50/0x70
 [<ffffffff8005d229>] tracesys+0x71/0xe0
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0
------------------------------------------------
#!/bin/bash

device="/dev/hdc"
rwmix=100
no_of_threads=128
 /usr/local/bin/fio --name=job --filename=$device  --end_fsync=0
--norandommap --randrepeat=0 --time_based --invalidate=1
--group_reporting --eta=never --bsrange="512-2M"
--rw=randrw --rwmixwrite=$rwmix --ioengine=psync --iodepth=1 --thread
--numjobs=$no_of_threads --direct=1 --runtime=3600 &
 /usr/local/bin/fio --name=job --filename=$device --end_fsync=0
--norandommap --randrepeat=0 --time_based --invalidate=1
--group_reporting --eta=never --bsrange="512-2M"
--rw=randrw --rwmixwrite=$rwmix --ioengine=psync --iodepth=1 --thread
--numjobs=$no_of_threads --direct=1 --runtime=3600 &
sleep 10
echo "mkfs on $device"
! mkfs -t ext3 $device &&  echo "mkfs failed" && exit 1
echo "mount on $device"
! mount -t ext3 $device /mnt -o rw &&  echo "mount failed" && exit 1
exit 0
------------------------------------
[2.] Full description of the problem/report:
[3.] Keywords (i.e., modules, networking, kernel): direct IO, blk_dev_direct_IO
[4.] Kernel version (from /proc/version):

# uname -r
2.6.18-128.el5

]# cat /etc/redhat-release
CentOS release 5.3 (Final)


[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)

Kernel BUG at fs/direct-io.c:914
invalid opcode: 0000 [1] SMP
last sysfs file: /block/vgca0/stat
CPU 3

Pid: 28959, comm: fio Tainted: P      2.6.18-164.el5 #1
RIP: 0010:[<ffffffff800f2600>]  [<ffffffff800f2600>]
__blockdev_direct_IO+0x6a1/0xa35
RSP: 0018:ffff8101a7805bc8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff810171dbb409
RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff8101bcb02c40
RBP: ffff810171dbb400 R08: 0000000000000003 R09: ffff810171dbb488
R10: ffff810001000000 R11: ffff810001000000 R12: ffff810105bf2248
R13: 0000000000000600 R14: 0000000000000000 R15: 0000000000000003
FS:  00000000537ce940(0063) GS:ffff81010631fdc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002b32dd2a70d0 CR3: 000000010d7e3000 CR4: 00000000000006e0
Process fio (pid: 28959, threadinfo ffff8101a7804000, task ffff810161d13080)
Stack:  0000000004ade4d0 0000000260d36e00 ffff8101a7805ef8 ffff8101bcb02d28
 0000000900000011 0000000000000000 ffff8101a7805ef8 ffff810171dbb488
 ffff810100000008 ffff810101461290 ffff8101014612c8 0000000000000009
Call Trace:
 [<ffffffff800e3e35>] blkdev_direct_IO+0x32/0x37
 [<ffffffff800e3d6d>] blkdev_get_blocks+0x0/0x96
 [<ffffffff800c4c91>] generic_file_direct_IO+0xff/0x119
 [<ffffffff8001edd1>] generic_file_direct_write+0x60/0xf2
 [<ffffffff8001646e>] __generic_file_aio_write_nolock+0x2b8/0x3b6
 [<ffffffff800e3e35>] blkdev_direct_IO+0x32/0x37
 [<ffffffff800e3d6d>] blkdev_get_blocks+0x0/0x96
 [<ffffffff800c4e16>] generic_file_aio_write_nolock+0x20/0x6c
 [<ffffffff800c51ed>] generic_file_write_nolock+0x8f/0xa8
 [<ffffffff800c5145>] generic_file_read+0xac/0xc5
 [<ffffffff8009f6c1>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80062fc8>] thread_return+0x62/0xfe
 [<ffffffff800e2c34>] blkdev_file_write+0x1a/0x1f
 [<ffffffff80016927>] vfs_write+0xce/0x174
 [<ffffffff80043e1d>] sys_pwrite64+0x50/0x70
 [<ffffffff8005d229>] tracesys+0x71/0xe0
 [<ffffffff8005d28d>] tracesys+0xd5/0xe0

Code: 0f 0b 68 e9 b3 2a 80 c2 92 03 48 8b 54 24 38 4c 8b 85 80 00
RIP  [<ffffffff800f2600>] __blockdev_direct_IO+0x6a1/0xa35
 RSP <ffff8101a7805bc8>

direct-io.c: do_direct_IO

    908                         if (this_chunk_blocks > u)
    909                                 this_chunk_blocks = u;
    910                         u = dio->final_block_in_request -
dio->block_in_file;
    911                         if (this_chunk_blocks > u)
    912                                 this_chunk_blocks = u;
    913                         this_chunk_bytes = this_chunk_blocks << blkbits;
    914                         BUG_ON(this_chunk_bytes == 0);
    915
    916                         dio->boundary = buffer_boundary(map_bh);
    917                         ret = submit_page_section(dio, page,
offset_in_page,
    918                                 this_chunk_bytes,
dio->next_block_for_io);


[6.] A small shell script or example program which triggers the
     problem (if possible)


------------------------------------------------
#!/bin/bash

device="/dev/hdc"
rwmix=100
no_of_threads=128
 /usr/local/bin/fio --name=job --filename=$device  --end_fsync=0
--norandommap --randrepeat=0 --time_based --invalidate=1
--group_reporting --eta=never --bsrange="512-2M"
--rw=randrw --rwmixwrite=$rwmix --ioengine=psync --iodepth=1 --thread
--numjobs=$no_of_threads --direct=1 --runtime=3600 &
 /usr/local/bin/fio --name=job --filename=$device --end_fsync=0
--norandommap --randrepeat=0 --time_based --invalidate=1
--group_reporting --eta=never --bsrange="512-2M"
--rw=randrw --rwmixwrite=$rwmix --ioengine=psync --iodepth=1 --thread
--numjobs=$no_of_threads --direct=1 --runtime=3600 &
sleep 10
echo "mkfs on $device"
! mkfs -t ext3 $device &&  echo "mkfs failed" && exit 1
echo "mount on $device"
! mount -t ext3 $device /mnt -o rw &&  echo "mount failed" && exit 1
exit 0
------------------------------------


Thanks,
Gangadhar
