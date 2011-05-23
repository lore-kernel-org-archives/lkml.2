Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1EWKpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:45:06 -0400
Received: from smtpo11.poczta.onet.pl ([213.180.142.142]:39759 "EHLO
	smtpo11.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1EWKpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:45:04 -0400
X-Greylist: delayed 815 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 May 2011 06:45:04 EDT
Message-ID: <4DDA376C.8010503@onet.eu>
Date: Mon, 23 May 2011 12:31:08 +0200
From: sdrb <sdrb@onet.eu>
User-Agent: Mozilla/1.0 (X10; U; *nix; en-US; rv:1.0.0.0) Gecko/19700101
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Issue with dm snapshots
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I encountered some problems using LVM and snapshots on linux 2.6.35.
The problem is that when there are several snapshots and some of them 
reached theirs maximum space and disks are under heavy load - it causes 
that the tasks that rely somehow on device mapper - just hung.
I use following script for testing this:



----code begin----
#!/bin/bash
set -x
DISK="/dev/sda"

# clean old stuff
killall -9 dd

umount /mnt/tmp2
for ((j = 0; j < 20; j++)) ; do
     echo -n "Remove $j "
     date
     umount /mnt/m$j
     lvremove -s -f /dev/VG/sn_$j
done
vgchange -a n VG
vgremove -f VG

# initialization
pvcreate  $DISK 2> /dev/null
vgcreate VG $DISK 2> /dev/null
vgchange -a y VG
lvcreate -L40G -n lv VG
mkdir -p /mnt/tmp2
mkfs.xfs /dev/VG/lv
for ((j = 0; j < 20; j++)) do
     lvcreate -L512M -n /dev/VG/sn_${j} VG
     mkdir -p /mnt/m$j
done

# test
nloops=10
for ((loop = 0; loop < $nloops; loop++)) ;  do
     echo "loop $loop start ... "
     mount /dev/VG/lv /mnt/tmp2

     dd if=/dev/urandom of=/mnt/tmp2/file_tmp1 bs=1024  &
     load_pid1=$!
     dd if=/dev/urandom of=/mnt/tmp2/file_tmp2 bs=1024  &
     load_pid2=$!

     for ((j = 0; j < 20; j++)) ; do
         echo -n "Convert $j "
         date
         lvconvert -s -c512 /dev/VG/lv /dev/VG/sn_$j
         sleep 10
         mount -t xfs -o nouuid,noatime /dev/VG/sn_$j /mnt/m$j
         sync
     done

     for ((j = 0; j < 20; j++)) ; do
         echo -n "Remove $j "
         date
         umount /mnt/m$j
         lvremove -s -f /dev/VG/sn_$j
     done

     kill $load_pid1
     wait $load_pid1
     kill $load_pid2
     wait $load_pid2

     umount /mnt/tmp2
     echo "done"
done
----code end----




Logs from the system when the problem occured:


---- logs begin----
May 13 11:15:56 fe8 kernel: XFS mounting filesystem dm-27
May 13 11:15:56 fe8 kernel: Starting XFS recovery on filesystem: dm-27 
(logdev: internal)
May 13 11:15:57 fe8 kernel: Ending XFS recovery on filesystem: dm-27 
(logdev: internal)
May 13 11:15:57 fe8 kernel: device-mapper: snapshots: Invalidating 
snapshot: Unable to allocate exception.
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: 
=======================================================
May 13 11:15:57 fe8 kernel: [ INFO: possible circular locking dependency 
detected ]
May 13 11:15:57 fe8 kernel: 2.6.35 #1
May 13 11:15:57 fe8 kernel: 
-------------------------------------------------------
May 13 11:15:57 fe8 kernel: flush-253:0/5811 is trying to acquire lock:
May 13 11:15:57 fe8 kernel:  (ksnaphd){+.+...}, at: [<c043e569>] 
flush_workqueue+0x0/0x8f
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: but task is already holding lock:
May 13 11:15:57 fe8 kernel:  (&s->lock){++++..}, at: [<c06c376f>] 
__origin_write+0xda/0x1d1
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: which lock already depends on the new lock.
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: the existing dependency chain (in reverse 
order) is:
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: -> #3 (&s->lock){++++..}:
May 13 11:15:57 fe8 kernel:        [<c0451e2c>] __lock_acquire+0x74f/0x7b5
May 13 11:15:57 fe8 kernel:        [<c0451eee>] lock_acquire+0x5c/0x73
May 13 11:15:57 fe8 kernel:        [<c0779495>] down_write+0x3a/0x76
May 13 11:15:57 fe8 kernel:        [<c06c496a>] snapshot_map+0x70/0x1f2
May 13 11:15:57 fe8 kernel:        [<c06b98c8>] __map_bio+0x27/0x81
May 13 11:15:57 fe8 kernel:        [<c06ba4a5>] 
__split_and_process_bio+0x287/0x4f2
May 13 11:15:57 fe8 kernel:        [<c06ba935>] dm_request+0x1d8/0x1e9
May 13 11:15:57 fe8 kernel:        [<c05dd8be>] 
generic_make_request+0x1a6/0x24e
May 13 11:15:57 fe8 kernel:        [<c05dedd9>] submit_bio+0xb6/0xbd
May 13 11:15:57 fe8 kernel:        [<c04c258b>] dio_bio_submit+0x61/0x84
May 13 11:15:57 fe8 kernel:        [<c04c31b3>] 
__blockdev_direct_IO_newtrunc+0x867/0xa37
May 13 11:15:57 fe8 kernel:        [<c04c1eb9>] blkdev_direct_IO+0x32/0x37
May 13 11:15:57 fe8 kernel:        [<c047c575>] 
generic_file_aio_read+0xeb/0x59b
May 13 11:15:57 fe8 kernel:        [<c04a0911>] do_sync_read+0x8c/0xca
May 13 11:15:57 fe8 kernel:        [<c04a1080>] vfs_read+0x8a/0x13f
May 13 11:15:57 fe8 kernel:        [<c04a142e>] sys_read+0x3b/0x60
May 13 11:15:57 fe8 kernel:        [<c040274c>] sysenter_do_call+0x12/0x32
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: -> #2 (&md->io_lock){++++..}:
May 13 11:15:57 fe8 kernel:        [<c0451e2c>] __lock_acquire+0x74f/0x7b5
May 13 11:15:57 fe8 kernel:        [<c0451eee>] lock_acquire+0x5c/0x73
May 13 11:15:57 fe8 kernel:        [<c077941e>] down_read+0x34/0x71
May 13 11:15:57 fe8 kernel:        [<c06ba794>] dm_request+0x37/0x1e9
May 13 11:15:57 fe8 kernel:        [<c05dd8be>] 
generic_make_request+0x1a6/0x24e
May 13 11:15:57 fe8 kernel:        [<c05dedd9>] submit_bio+0xb6/0xbd
May 13 11:15:57 fe8 kernel:        [<c06bec3d>] dispatch_io+0x17c/0x1ad
May 13 11:15:57 fe8 kernel:        [<c06beda6>] dm_io+0xf6/0x204
May 13 11:15:57 fe8 kernel:        [<c06c57d4>] do_metadata+0x1c/0x27
May 13 11:15:57 fe8 kernel:        [<c043e820>] worker_thread+0x12e/0x1fa
May 13 11:15:57 fe8 kernel:        [<c0440c35>] kthread+0x61/0x66
May 13 11:15:57 fe8 kernel:        [<c0402cfa>] 
kernel_thread_helper+0x6/0x1a
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: -> #1 ((&req.work)){+.+...}:
May 13 11:15:57 fe8 kernel:        [<c0451e2c>] __lock_acquire+0x74f/0x7b5
May 13 11:15:57 fe8 kernel:        [<c0451eee>] lock_acquire+0x5c/0x73
May 13 11:15:57 fe8 kernel:        [<c043e81b>] worker_thread+0x129/0x1fa
May 13 11:15:57 fe8 kernel:        [<c0440c35>] kthread+0x61/0x66
May 13 11:15:57 fe8 kernel:        [<c0402cfa>] 
kernel_thread_helper+0x6/0x1a
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: -> #0 (ksnaphd){+.+...}:
May 13 11:15:57 fe8 kernel:        [<c0451134>] validate_chain+0x678/0xc21
May 13 11:15:57 fe8 kernel:        [<c0451e2c>] __lock_acquire+0x74f/0x7b5
May 13 11:15:57 fe8 kernel:        [<c0451eee>] lock_acquire+0x5c/0x73
May 13 11:15:57 fe8 kernel:        [<c043e5b0>] flush_workqueue+0x47/0x8f
May 13 11:15:57 fe8 kernel:        [<c06c58c2>] chunk_io+0xe3/0xef
May 13 11:15:57 fe8 kernel:        [<c06c5916>] write_header+0x48/0x4f
May 13 11:15:57 fe8 kernel:        [<c06c5c39>] 
persistent_drop_snapshot+0x12/0x23
May 13 11:15:57 fe8 kernel:        [<c06c367f>] 
__invalidate_snapshot+0x3b/0x51
May 13 11:15:57 fe8 kernel:        [<c06c37ad>] __origin_write+0x118/0x1d1
May 13 11:15:57 fe8 kernel:        [<c06c3897>] do_origin+0x31/0x47
May 13 11:15:57 fe8 kernel:        [<c06c4742>] origin_map+0x2e/0x37
May 13 11:15:57 fe8 kernel:        [<c06b98c8>] __map_bio+0x27/0x81
May 13 11:15:57 fe8 kernel:        [<c06ba4a5>] 
__split_and_process_bio+0x287/0x4f2
May 13 11:15:57 fe8 kernel:        [<c06ba935>] dm_request+0x1d8/0x1e9
May 13 11:15:57 fe8 kernel:        [<c05dd8be>] 
generic_make_request+0x1a6/0x24e
May 13 11:15:57 fe8 kernel:        [<c05dedd9>] submit_bio+0xb6/0xbd
May 13 11:15:57 fe8 kernel:        [<c05a378d>] 
xfs_submit_ioend_bio+0x4b/0x57
May 13 11:15:57 fe8 kernel:        [<c05a3eee>] xfs_submit_ioend+0xb7/0xd3
May 13 11:15:57 fe8 kernel:        [<c05a4950>] 
xfs_page_state_convert+0x4c7/0x502
May 13 11:15:57 fe8 kernel:        [<c05a4ac8>] xfs_vm_writepage+0xa2/0xd6
May 13 11:15:57 fe8 kernel:        [<c04805a4>] __writepage+0xb/0x23
May 13 11:15:57 fe8 kernel:        [<c0480897>] 
write_cache_pages+0x1ca/0x28a
May 13 11:15:57 fe8 kernel:        [<c0480974>] generic_writepages+0x1d/0x27
May 13 11:15:57 fe8 kernel:        [<c05a3a2e>] xfs_vm_writepages+0x3c/0x42
May 13 11:15:57 fe8 kernel:        [<c048099a>] do_writepages+0x1c/0x28
May 13 11:15:57 fe8 kernel:        [<c04b7bb0>] 
writeback_single_inode+0x96/0x1e6
May 13 11:15:57 fe8 kernel:        [<c04b8079>] 
writeback_sb_inodes+0x99/0x111
May 13 11:15:57 fe8 kernel:        [<c04b8266>] 
writeback_inodes_wb+0xd5/0xe5
May 13 11:15:57 fe8 kernel:        [<c04b83ce>] wb_writeback+0x158/0x1c1
May 13 11:15:57 fe8 kernel:        [<c04b8469>] wb_do_writeback+0x32/0x11c
May 13 11:15:57 fe8 kernel:        [<c04b8575>] bdi_writeback_task+0x22/0xda
May 13 11:15:57 fe8 kernel:        [<c0489709>] bdi_start_fn+0x5e/0xaa
May 13 11:15:57 fe8 kernel:        [<c0440c35>] kthread+0x61/0x66
May 13 11:15:57 fe8 kernel:        [<c0402cfa>] 
kernel_thread_helper+0x6/0x1a
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: other info that might help us debug this:
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: 4 locks held by flush-253:0/5811:
May 13 11:15:57 fe8 kernel:  #0:  (&type->s_umount_key#25){++++++}, at: 
[<c04b821e>] writeback_inodes_wb+0x8d/0xe5
May 13 11:15:57 fe8 kernel:  #1:  (&md->io_lock){++++..}, at: 
[<c06ba794>] dm_request+0x37/0x1e9
May 13 11:15:57 fe8 kernel:  #2:  (&_origins_lock){++++..}, at: 
[<c06c3879>] do_origin+0x13/0x47
May 13 11:15:57 fe8 kernel:  #3:  (&s->lock){++++..}, at: [<c06c376f>] 
__origin_write+0xda/0x1d1
May 13 11:15:57 fe8 kernel:
May 13 11:15:57 fe8 kernel: stack backtrace:
May 13 11:15:57 fe8 kernel: Pid: 5811, comm: flush-253:0 Not tainted 
2.6.35 #1
May 13 11:15:57 fe8 kernel: Call Trace:
May 13 11:15:57 fe8 kernel:  [<c04505b0>] print_circular_bug+0x90/0x9c
May 13 11:15:57 fe8 kernel:  [<c0451134>] validate_chain+0x678/0xc21
May 13 11:15:57 fe8 kernel:  [<c0451e2c>] __lock_acquire+0x74f/0x7b5
May 13 11:15:57 fe8 kernel:  [<c0451eee>] lock_acquire+0x5c/0x73
May 13 11:15:57 fe8 kernel:  [<c043e569>] ? flush_workqueue+0x0/0x8f
May 13 11:15:57 fe8 kernel:  [<c043e5b0>] flush_workqueue+0x47/0x8f
May 13 11:15:57 fe8 kernel:  [<c043e569>] ? flush_workqueue+0x0/0x8f
May 13 11:15:57 fe8 kernel:  [<c06c58c2>] chunk_io+0xe3/0xef
May 13 11:15:57 fe8 kernel:  [<c06c57b8>] ? do_metadata+0x0/0x27
May 13 11:15:57 fe8 kernel:  [<c06c5916>] write_header+0x48/0x4f
May 13 11:15:57 fe8 kernel:  [<c06c5c39>] persistent_drop_snapshot+0x12/0x23
May 13 11:15:57 fe8 kernel:  [<c06c367f>] __invalidate_snapshot+0x3b/0x51
May 13 11:15:57 fe8 kernel:  [<c06c37ad>] __origin_write+0x118/0x1d1
May 13 11:15:57 fe8 kernel:  [<c06c3897>] do_origin+0x31/0x47
May 13 11:15:57 fe8 kernel:  [<c06c4742>] origin_map+0x2e/0x37
May 13 11:15:57 fe8 kernel:  [<c06b98c8>] __map_bio+0x27/0x81
May 13 11:15:57 fe8 kernel:  [<c06ba4a5>] 
__split_and_process_bio+0x287/0x4f2
May 13 11:15:57 fe8 kernel:  [<c04454e3>] ? sched_clock_cpu+0x12d/0x141
May 13 11:15:57 fe8 kernel:  [<c044e1bc>] ? trace_hardirqs_off+0xb/0xd
May 13 11:15:57 fe8 kernel:  [<c0445626>] ? cpu_clock+0x2e/0x44
May 13 11:15:57 fe8 kernel:  [<c06ba935>] dm_request+0x1d8/0x1e9
May 13 11:15:57 fe8 kernel:  [<c05dd8be>] generic_make_request+0x1a6/0x24e
May 13 11:15:57 fe8 kernel:  [<c06ba1f1>] ? dm_merge_bvec+0xa9/0xd6
May 13 11:15:57 fe8 kernel:  [<c05dedd9>] submit_bio+0xb6/0xbd
May 13 11:15:57 fe8 kernel:  [<c04b879a>] ? __mark_inode_dirty+0x23/0x10b
May 13 11:15:57 fe8 kernel:  [<c05a378d>] xfs_submit_ioend_bio+0x4b/0x57
May 13 11:15:57 fe8 kernel:  [<c05a3eee>] xfs_submit_ioend+0xb7/0xd3
May 13 11:15:57 fe8 kernel:  [<c05a4950>] xfs_page_state_convert+0x4c7/0x502
May 13 11:15:57 fe8 kernel:  [<c05a4ac8>] xfs_vm_writepage+0xa2/0xd6
May 13 11:15:57 fe8 kernel:  [<c04805a4>] __writepage+0xb/0x23
May 13 11:15:57 fe8 kernel:  [<c0480897>] write_cache_pages+0x1ca/0x28a
May 13 11:15:57 fe8 kernel:  [<c0480599>] ? __writepage+0x0/0x23
May 13 11:15:57 fe8 kernel:  [<c0480974>] generic_writepages+0x1d/0x27
May 13 11:15:57 fe8 kernel:  [<c05a3a2e>] xfs_vm_writepages+0x3c/0x42
May 13 11:15:57 fe8 kernel:  [<c05a39f2>] ? xfs_vm_writepages+0x0/0x42
May 13 11:15:57 fe8 kernel:  [<c048099a>] do_writepages+0x1c/0x28
May 13 11:15:57 fe8 kernel:  [<c04b7bb0>] writeback_single_inode+0x96/0x1e6
May 13 11:15:57 fe8 kernel:  [<c04b8079>] writeback_sb_inodes+0x99/0x111
May 13 11:15:57 fe8 kernel:  [<c04b8266>] writeback_inodes_wb+0xd5/0xe5
May 13 11:15:57 fe8 kernel:  [<c04b83ce>] wb_writeback+0x158/0x1c1
May 13 11:15:57 fe8 kernel:  [<c04b8469>] wb_do_writeback+0x32/0x11c
May 13 11:15:57 fe8 kernel:  [<c04b8575>] bdi_writeback_task+0x22/0xda
May 13 11:15:57 fe8 kernel:  [<c0489709>] bdi_start_fn+0x5e/0xaa
May 13 11:15:57 fe8 kernel:  [<c04896ab>] ? bdi_start_fn+0x0/0xaa
May 13 11:15:57 fe8 kernel:  [<c0440c35>] kthread+0x61/0x66
May 13 11:15:57 fe8 kernel:  [<c0440bd4>] ? kthread+0x0/0x66
May 13 11:15:57 fe8 kernel:  [<c0402cfa>] kernel_thread_helper+0x6/0x1a
May 13 11:16:07 fe8 kernel: device-mapper: snapshots: Invalidating 
snapshot: Unable to allocate exception.
May 13 11:16:12 fe8 kernel: Device dm-23, XFS metadata write error block 
0x40 in dm-23
May 13 11:16:12 fe8 kernel: Device dm-22, XFS metadata write error block 
0x40 in dm-22
May 13 11:16:15 fe8 kernel: device-mapper: snapshots: Invalidating 
snapshot: Unable to allocate exception.
May 13 11:16:17 fe8 kernel: I/O error in filesystem ("dm-22") meta-data 
dev dm-22 block 0x2800052       ("xlog_iodone") error 5 buf count 1024
May 13 11:16:17 fe8 kernel: xfs_force_shutdown(dm-22,0x2) called from 
line 944 of file fs/xfs/xfs_log.c.  Return address = 0xc05917fa
May 13 11:16:17 fe8 kernel: Filesystem "dm-22": Log I/O Error Detected. 
  Shutting down filesystem: dm-22
May 13 11:16:17 fe8 kernel: Please umount the filesystem, and rectify 
the problem(s)
May 13 11:16:17 fe8 kernel: I/O error in filesystem ("dm-24") meta-data 
dev dm-24 block 0x28000ad       ("xlog_iodone") error 5 buf count 1024
May 13 11:16:17 fe8 kernel: xfs_force_shutdown(dm-24,0x2) called from 
line 944 of file fs/xfs/xfs_log.c.  Return address = 0xc05917fa
May 13 11:16:17 fe8 kernel: Filesystem "dm-24": Log I/O Error Detected. 
  Shutting down filesystem: dm-24
May 13 11:16:17 fe8 kernel: Please umount the filesystem, and rectify 
the problem(s)
May 13 11:16:21 fe8 kernel: xfs_force_shutdown(dm-22,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:21 fe8 kernel: xfs_force_shutdown(dm-23,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:21 fe8 kernel: Filesystem "dm-23": I/O Error Detected. 
Shutting down filesystem: dm-23
May 13 11:16:21 fe8 kernel: Please umount the filesystem, and rectify 
the problem(s)
May 13 11:16:21 fe8 kernel: xfs_force_shutdown(dm-24,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:22 fe8 kernel: xfs_force_shutdown(dm-22,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:22 fe8 kernel: VFS:Filesystem freeze failed
May 13 11:16:22 fe8 kernel: xfs_force_shutdown(dm-23,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:22 fe8 kernel: VFS:Filesystem freeze failed
May 13 11:16:22 fe8 kernel: xfs_force_shutdown(dm-24,0x1) called from 
line 1031 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0xc05a6613
May 13 11:16:22 fe8 kernel: VFS:Filesystem freeze failed
May 13 11:16:31 fe8 kernel: Filesystem "dm-23": xfs_log_force: error 5 
returned.
May 13 11:16:47 fe8 kernel: Filesystem "dm-22": xfs_log_force: error 5 
returned.
May 13 11:16:47 fe8 kernel: Filesystem "dm-24": xfs_log_force: error 5 
returned.
May 13 11:17:01 fe8 kernel: Filesystem "dm-23": xfs_log_force: error 5 
returned.
May 13 11:17:17 fe8 kernel: Filesystem "dm-22": xfs_log_force: error 5 
returned.
---- logs end----



Here there are more information I gathered while the problem occured:

# lvs
   /dev/VG/sn_0: read failed after 0 of 512 at 42949607424: Input/output 
error
   /dev/VG/sn_0: read failed after 0 of 512 at 42949664768: Input/output 
error
   /dev/VG/sn_0: read failed after 0 of 512 at 0: Input/output error
   /dev/VG/sn_0: read failed after 0 of 512 at 4096: Input/output error
   /dev/VG/sn_0: read failed after 0 of 2048 at 0: Input/output error
   LV    VG   Attr   LSize   Origin Snap%  Move Log Copy%  Convert
   lv    VG   owi-ao  40.00G
   sn_0  VG   Swi-Io 512.00M lv     100.00
   sn_1  VG   swi-ao 512.00M lv      93.65
   sn_10 VG   -wi-a- 512.00M
   sn_11 VG   -wi-a- 512.00M
   sn_12 VG   -wi-a- 512.00M
   sn_13 VG   -wi-a- 512.00M
   sn_14 VG   -wi-a- 512.00M
   sn_15 VG   -wi-a- 512.00M
   sn_16 VG   -wi-a- 512.00M
   sn_17 VG   -wi-a- 512.00M
   sn_18 VG   -wi-a- 512.00M
   sn_19 VG   -wi-a- 512.00M
   sn_2  VG   swi-ao 512.00M lv      77.93
   sn_3  VG   swi-ao 512.00M lv      62.21
   sn_4  VG   swi-ao 512.00M lv      36.23
   sn_5  VG   swi-ao 512.00M lv      11.91
   sn_6  VG   -wi-a- 512.00M
   sn_7  VG   -wi-a- 512.00M
   sn_8  VG   -wi-a- 512.00M
   sn_9  VG   -wi-a- 512.00M



# ls -al /dev/mapper/

brw------- 1 root root 253,  0 2011-05-13 11:14 /dev/mapper/VG-lv
brw------- 1 root root 253,  1 2011-05-13 11:14 /dev/mapper/VG-lv-real
brw------- 1 root root 253, 22 2011-05-13 11:14 /dev/mapper/VG-sn_0
brw------- 1 root root 253, 21 2011-05-13 11:14 /dev/mapper/VG-sn_0-cow
brw------- 1 root root 253, 23 2011-05-13 11:14 /dev/mapper/VG-sn_1
brw------- 1 root root 253, 11 2011-05-13 11:14 /dev/mapper/VG-sn_10
brw------- 1 root root 253, 12 2011-05-13 11:14 /dev/mapper/VG-sn_11
brw------- 1 root root 253, 13 2011-05-13 11:14 /dev/mapper/VG-sn_12
brw------- 1 root root 253, 14 2011-05-13 11:14 /dev/mapper/VG-sn_13
brw------- 1 root root 253, 15 2011-05-13 11:14 /dev/mapper/VG-sn_14
brw------- 1 root root 253, 16 2011-05-13 11:14 /dev/mapper/VG-sn_15
brw------- 1 root root 253, 17 2011-05-13 11:14 /dev/mapper/VG-sn_16
brw------- 1 root root 253, 18 2011-05-13 11:14 /dev/mapper/VG-sn_17
brw------- 1 root root 253, 19 2011-05-13 11:14 /dev/mapper/VG-sn_18
brw------- 1 root root 253, 20 2011-05-13 11:14 /dev/mapper/VG-sn_19
brw------- 1 root root 253,  2 2011-05-13 11:14 /dev/mapper/VG-sn_1-cow
brw------- 1 root root 253, 24 2011-05-13 11:14 /dev/mapper/VG-sn_2
brw------- 1 root root 253,  3 2011-05-13 11:14 /dev/mapper/VG-sn_2-cow
brw------- 1 root root 253, 25 2011-05-13 11:14 /dev/mapper/VG-sn_3
brw------- 1 root root 253,  4 2011-05-13 11:14 /dev/mapper/VG-sn_3-cow
brw------- 1 root root 253, 26 2011-05-13 11:15 /dev/mapper/VG-sn_4
brw------- 1 root root 253,  5 2011-05-13 11:15 /dev/mapper/VG-sn_4-cow
brw------- 1 root root 253, 27 2011-05-13 11:15 /dev/mapper/VG-sn_5
brw------- 1 root root 253,  6 2011-05-13 11:15 /dev/mapper/VG-sn_5-cow
brw------- 1 root root 253, 28 2011-05-13 11:16 /dev/mapper/VG-sn_6
brw------- 1 root root 253,  7 2011-05-13 11:16 /dev/mapper/VG-sn_6-cow
brw------- 1 root root 253,  8 2011-05-13 11:14 /dev/mapper/VG-sn_7
brw------- 1 root root 253,  9 2011-05-13 11:14 /dev/mapper/VG-sn_8
brw------- 1 root root 253, 10 2011-05-13 11:14 /dev/mapper/VG-sn_9



I tested several kernels and I noticed that the problem occurs only on 
kernels >= 2.6.29.
I tested even the newest 2.6.39-rc7 (git commit 
9f381a61f58bb6487c93ce2233bb9992f8ea9211) and this script and
other tasks which rely on DM hungs (they are in uninterruptible sleep 
state).

On older kernels (2.6.28, 2.6.27) this script works fine - it doesn't 
hung neither itself nor any other applications.

To check where there is the problem I also used EXT3 instead of XFS, but 
no difference.

I tried to find out which is the last git commit after 2.6.28 which with 
this script works good. I used git bisect to do this and here is what 
I've got:


# git bisect good
fcccf502540e3d752d33b2d8e976034dee81f9f7 is first bad commit
commit fcccf502540e3d752d33b2d8e976034dee81f9f7
Author: Takashi Sato <t-sato@yk.jp.nec.com>
Date:   Fri Jan 9 16:40:59 2009 -0800

     filesystem freeze: implement generic freeze feature

     The ioctls for the generic freeze feature are below.
     o Freeze the filesystem
       int ioctl(int fd, int FIFREEZE, arg)
         fd: The file descriptor of the mountpoint
         FIFREEZE: request code for the freeze
         arg: Ignored
         Return value: 0 if the operation succeeds. Otherwise, -1

     o Unfreeze the filesystem
       int ioctl(int fd, int FITHAW, arg)
         fd: The file descriptor of the mountpoint
         FITHAW: request code for unfreeze
         arg: Ignored
         Return value: 0 if the operation succeeds. Otherwise, -1
         Error number: If the filesystem has already been unfrozen,
                       errno is set to EINVAL.

     [akpm@linux-foundation.org: fix CONFIG_BLOCK=n]
     Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
     Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
     Cc: <xfs-masters@oss.sgi.com>
     Cc: <linux-ext4@vger.kernel.org>
     Cc: Christoph Hellwig <hch@lst.de>
     Cc: Dave Kleikamp <shaggy@austin.ibm.com>
     Cc: Dave Chinner <david@fromorbit.com>
     Cc: Alasdair G Kergon <agk@redhat.com>
     Cc: Al Viro <viro@zeniv.linux.org.uk>
     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 23e26d18d2b4d6be7fb25e9093531e34450e3067 
ae47c7559a4f9ff5a98dbaf812d003b9fcd5f46d M      fs
:040000 040000 1ca8e10e69d2d4c124b43f2a46c208a96e6c6c82 
21d3f4d7ca305612510eb5e3552c3751ebd75644 M      include
---------------------



Seems like the last "good" commit was 
c4be0c1dc4cdc37b175579be1460f15ac6495e9a - and the first bad is 
fcccf502540e3d752d33b2d8e976034dee81f9f7.


Is it known issue?

