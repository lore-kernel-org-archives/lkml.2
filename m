Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258Ab2EYWWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:22:34 -0400
Received: from static-96-231-53-14.washdc.fios.verizon.net ([96.231.53.14]:60201
	"EHLO www.bluelavalamp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab2EYWWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:22:32 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2012 18:22:32 EDT
Date: Fri, 25 May 2012 18:16:13 -0400
From: Kevin <kevin@bluelavalamp.net>
To: linux-kernel@vger.kernel.org
Subject: btrfs: kernel BUG at fs/btrfs/volumes.c:3653
Message-ID: <20120525181613.180b3659@zee.bluelavalamp.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I have a btrfs volume that's made up of 10 devices, only one
filesystem on the volume.  Have been running this for probably over a
year.  Recently noticed kernel oops, in syslog there's this:

May 25 17:22:42 www kernel: ------------[ cut here ]------------
May 25 17:22:42 www kernel: kernel BUG at fs/btrfs/volumes.c:3653!
May 25 17:22:42 www kernel: invalid opcode: 0000 [#1] SMP 
May 25 17:22:42 www kernel: Modules linked in: i2c_i801 i2c_core evdev
May 25 17:22:42 www kernel: 
May 25 17:22:42 www kernel: Pid: 1777, comm: btrfs-transacti Not tainted 3.3.7 #1 Gigabyte Technology Co., Ltd. 965P-DS3/965P-DS3
May 25 17:22:42 www kernel: EIP: 0060:[<c1229c77>] EFLAGS: 00010282 CPU: 1
May 25 17:22:42 www kernel: EIP is at __btrfs_map_block+0x9e7/0xa10
May 25 17:22:42 www kernel: EAX: 00000033 EBX: ee205cac ECX: 00004948 EDX: 00000046
May 25 17:22:42 www kernel: ESI: ed512108 EDI: ee205cac EBP: ee205c68 ESP: ee205be4
May 25 17:22:42 www kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May 25 17:22:42 www kernel: Process btrfs-transacti (pid: 1777, ti=ee204000 task=f4d86bd0 task.ti=ee204000)
May 25 17:22:42 www kernel: Stack:
May 25 17:22:42 www kernel:  c15950c0 b2400000 0000002b 00001000 00000000 c104dee0 acf6461a 00000000
May 25 17:22:42 www kernel:  acf6461a 00000019 00000000 00000202 0015380c 00011220 f5675cc0 f4d86bd0
May 25 17:22:42 www kernel:  ee205c2c c1083ebe ee205c64 c108411b ee205c3c c1083ebe 00000010 00011270
May 25 17:22:42 www kernel: Call Trace:
May 25 17:22:42 www kernel:  [<c104dee0>] ? sched_clock_local+0xf0/0x1f0
May 25 17:22:42 www kernel:  [<c1083ebe>] ? mempool_alloc_slab+0xe/0x10
May 25 17:22:42 www kernel:  [<c108411b>] ? mempool_alloc+0x3b/0x100
May 25 17:22:42 www kernel:  [<c1083ebe>] ? mempool_alloc_slab+0xe/0x10
May 25 17:22:42 www kernel:  [<c122d4de>] btrfs_map_block+0x2e/0x40
May 25 17:22:42 www kernel:  [<c1205b2a>] btrfs_merge_bio_hook+0x8a/0xc0
May 25 17:22:42 www kernel:  [<c1205aa0>] ? btrfs_set_page_dirty+0x10/0x10
May 25 17:22:42 www kernel:  [<c12232d7>] submit_extent_page.isra.26+0xb7/0x1d0
May 25 17:22:42 www kernel:  [<c1205aa0>] ? btrfs_set_page_dirty+0x10/0x10
May 25 17:22:42 www kernel:  [<c122447c>] __extent_writepage+0x8cc/0x920
May 25 17:22:42 www kernel:  [<c12230a0>] ? end_extent_writepage+0x130/0x130
May 25 17:22:42 www kernel:  [<c11fc2c0>] ? btrfs_end_buffer_write_sync+0x60/0x60
May 25 17:22:42 www kernel:  [<c1224945>] extent_writepages+0x255/0x340
May 25 17:22:42 www kernel:  [<c11fbf10>] ? verify_parent_transid+0x1b0/0x1b0
May 25 17:22:42 www kernel:  [<c11fc5d5>] btree_writepages+0x65/0x70
May 25 17:22:42 www kernel:  [<c108a396>] do_writepages+0x16/0x40
May 25 17:22:42 www kernel:  [<c1082824>] __filemap_fdatawrite_range+0x54/0x60
May 25 17:22:42 www kernel:  [<c1083806>] filemap_fdatawrite_range+0x26/0x30
May 25 17:22:42 www kernel:  [<c120327a>] btrfs_write_marked_extents+0x8a/0xe0
May 25 17:22:42 www kernel:  [<c12033bb>] btrfs_write_and_wait_marked_extents+0x1b/0x40
May 25 17:22:42 www kernel:  [<c1203400>] btrfs_write_and_wait_transaction+0x20/0x40
May 25 17:22:42 www kernel:  [<c1203ab2>] btrfs_commit_transaction+0x592/0x790
May 25 17:22:42 www kernel:  [<c10417b0>] ? __init_waitqueue_head+0x30/0x30
May 25 17:22:42 www kernel:  [<c11fc8bd>] transaction_kthread+0x1ed/0x250
May 25 17:22:42 www kernel:  [<c1048b79>] ? complete+0x49/0x60
May 25 17:22:42 www kernel:  [<c11fc6d0>] ? btrfs_alloc_root+0x30/0x30
May 25 17:22:42 www kernel:  [<c104115d>] kthread+0x6d/0x80
May 25 17:22:42 www kernel:  [<c1040000>] ? posix_clock_realtime_get+0x10/0x10
May 25 17:22:42 www kernel:  [<c10410f0>] ? __init_kthread_worker+0x30/0x30
May 25 17:22:42 www kernel:  [<c14c13b6>] kernel_thread_helper+0x6/0xd
May 25 17:22:42 www kernel: Code: 98 8b 5d 10 8b 03 8b 53 04 c7 04 24 c0 50 59 c1 89 44 24 0c 8b 45 08 89 54 24 10 8b 55 0c 89 44 24 04 89 54 24 08 e8 42 f6 28 00 <0f> 0b 0f 0b c7 45 18 01 00 00 00 c7 45 e4 00 00 00 00 e9 ce fa 
May 25 17:22:42 www kernel: EIP: [<c1229c77>] __btrfs_map_block+0x9e7/0xa10 SS:ESP 0068:ee205be4
May 25 17:22:42 www kernel: ---[ end trace d849ee5ca409ca44 ]---


As soon as the filesystem is mounted this happens, also get this at the console:

Message from syslogd@www at Fri May 25 17:15:11 2012 ...
www kernel: Stack:

Message from syslogd@www at Fri May 25 17:15:11 2012 ...
www kernel: Process flush-btrfs-3 (pid: 4548, ti=ee178000 task=f08d7870 task.ti=ee178000)

Message from syslogd@www at Fri May 25 17:15:11 2012 ...
www kernel: Call Trace:

Message from syslogd@www at Fri May 25 17:15:11 2012 ...
www kernel: Code: 98 8b 5d 10 8b 03 8b 53 04 c7 04 24 c0 50 59 c1 89 44 24 0c 8b 45 08 89 54 24 10 8b 55 0c 89 44 24 04 89 54 24 08 e8 42 f6 28 00 <0f> 0b 0f 0b c7 45 18 01 00 00 00 c7 45 e4 00 00 00 00 e9 ce fa 

Message from syslogd@www at Fri May 25 17:15:11 2012 ...
www kernel: EIP: [<c1229c77>] __btrfs_map_block+0x9e7/0xa10 SS:ESP
0068:ee179bf8


	I can read the files and copy them to other drives.  I can't do a software reboot, using the reboot command the machine just hangs and waits forever so I have to do a hard reset.  Sometimes I can delete files, but after the hard reboot they are back.  Other times I'll try to delete a file and the rm command just hangs.  I can still use the machine and all other filesystems work fine.  Thought it was maybe being low on space, this is what btrfs-show reports:


Label: btrfslvm  uuid: f5361a96-1470-4c3a-9247-e9a1636cdd1b
        Total devices 10 FS bytes used 5.64TB
        devid    1 size 1.82TB used 1.70TB path /dev/sdd1
        devid    4 size 1.82TB used 1.70TB path /dev/sdg1
        devid    2 size 1.82TB used 1.70TB path /dev/sdj1
        devid    5 size 1.36TB used 1.25TB path /dev/sdh1
        devid    3 size 1.82TB used 1.70TB path /dev/sdf1
        devid   10 size 1.82TB used 1.03TB path /dev/sdc1
        devid    9 size 232.88GB used 111.25GB path /dev/sdl1
        devid    6 size 372.61GB used 250.50GB path /dev/sdk1
        devid    7 size 1.82TB used 1.70TB path /dev/sde1
        devid    8 size 819.51GB used 697.25GB path /dev/sda3

Btrfs Btrfs v0.19


	Tried adding a drive but get an error back:

www:# btrfs device add /dev/sdh1 /videos
ERROR: error adding the device '/dev/sdh1'


	Not sure what to try next, any suggestions?


	Thank you in advance,
	Kevin


