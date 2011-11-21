Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1KUOVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:21:03 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41264 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab1KUOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:21:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALhcyk55LGY5/2dsb2JhbABDqjmBBoIzHA8UGF0lAysJvB4SiSJjBJQ7iQOJFw
Date: Tue, 22 Nov 2011 01:20:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [3.2-rc2] loop device balance_dirty_pages_nr throttling hang
Message-ID: <20111121142056.GF2386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

I just found a way of hanging a system and taking it down. I haven't
tried to narrow down the test case - it's pretty simple - because it
time for sleep here.

$ uname -a
Linux test-2 3.2.0-rc2-dgc+ #89 SMP Thu Nov 17 15:25:19 EST 2011 x86_64 GNU/Linux

Create a 20TB sparse loop device on 11GB XFS filesystem:

$ sudo xfs_io -f -c "truncate 20T" /mnt/scratch/scratch.img
$ sudo losetup /dev/loop0 /mnt/scratch/scratch.img

Make an ext4 filesystem on the loop device:

$ sudo mkfs.ext4 /dev/loop0
mke2fs 1.42-WIP (16-Oct-2011)
Discarding device blocks: done
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
335544320 inodes, 5368709120 blocks
268435456 blocks (5.00%) reserved for the super user
.....

Mount the filesystem:

$ sudo mount /dev/loop0 /mnt/scratch/scratch

Try to preallocate a 15TB file:

$ sudo time xfs_io -f -F -c "truncate 15T " -c "falloc 0 15T" /mnt/scratch/scratch/foo

The command hangs very soon after this, with these hung processes:

[  283.437409] SysRq : Show Blocked State
[  283.438563]   task                        PC stack   pid father
[  283.439837] rsyslogd        D ffff88007691ea48     0  1633      1 0x00000000
[  283.440038]  ffff880076a71bf8 0000000000000082 0000000000009f1c ffffffffb135a68d
[  283.440038]  ffff88007691e6c0 ffff880076a71fd8 ffff880076a71fd8 ffff880076a71fd8
[  283.440038]  ffff880031402540 ffff88007691e6c0 ffff880076a71bf8 ffffffff810b59ed
[  283.440038] Call Trace:
[  283.440038]  [<ffffffff810b59ed>] ? ktime_get_ts+0xad/0xe0
[  283.440038]  [<ffffffff81117650>] ? sleep_on_page+0x20/0x20
[  283.440038]  [<ffffffff81aab3af>] schedule+0x3f/0x60
[  283.440038]  [<ffffffff81aab45f>] io_schedule+0x8f/0xd0
[  283.440038]  [<ffffffff8111765e>] sleep_on_page_killable+0xe/0x40
[  283.440038]  [<ffffffff81aabc2f>] __wait_on_bit+0x5f/0x90
[  283.440038]  [<ffffffff8114c0ff>] ? read_swap_cache_async+0x4f/0x160
[  283.440038]  [<ffffffff81119d60>] wait_on_page_bit_killable+0x80/0x90
[  283.440038]  [<ffffffff810ac360>] ? autoremove_wake_function+0x40/0x40
[  283.440038]  [<ffffffff81119e16>] __lock_page_or_retry+0xa6/0xd0
[  283.440038]  [<ffffffff8113bba7>] handle_pte_fault+0x887/0x8b0
[  283.440038]  [<ffffffff8169ee6d>] ? copy_user_generic_string+0x2d/0x40
[  283.440038]  [<ffffffff8113bee5>] handle_mm_fault+0x155/0x250
[  283.440038]  [<ffffffff81ab0a62>] do_page_fault+0x142/0x4f0
[  283.440038]  [<ffffffff81ab0565>] do_async_page_fault+0x35/0x80
[  283.440038]  [<ffffffff81aad935>] async_page_fault+0x25/0x30
[  283.440038] loop0           D ffff8800775fe4c8     0  2658      2 0x00000000
[  283.440038]  ffff88007b6b7810 0000000000000046 ffff88007b6b77f0 ffff88007fd12580
[  283.440038]  ffff8800775fe140 ffff88007b6b7fd8 ffff88007b6b7fd8 ffff88007b6b7fd8
[  283.440038]  ffff88007b1ea740 ffff8800775fe140 ffff88007b6b77f0 ffffffff81aad47e
[  283.440038] Call Trace:
[  283.440038]  [<ffffffff81aad47e>] ? _raw_spin_lock_irqsave+0x2e/0x40
[  283.440038]  [<ffffffff81aab3af>] schedule+0x3f/0x60
[  283.440038]  [<ffffffff81aab894>] schedule_timeout+0x144/0x2d0
[  283.440038]  [<ffffffff810985d0>] ? usleep_range+0x50/0x50
[  283.440038]  [<ffffffff81aab6c2>] io_schedule_timeout+0xa2/0x100
[  283.440038]  [<ffffffff81121b21>] ? bdi_dirty_limit+0x31/0xc0
[  283.440038]  [<ffffffff811221f8>] balance_dirty_pages_ratelimited_nr+0x298/0x6d0
[  283.440038]  [<ffffffff81190d94>] ? block_write_end+0x44/0x80
[  283.440038]  [<ffffffff81117bc8>] generic_file_buffered_write+0x1a8/0x250
[  283.440038]  [<ffffffff8142262c>] xfs_file_buffered_aio_write+0xec/0x1b0
[  283.440038]  [<ffffffff8142285a>] xfs_file_aio_write+0x16a/0x2a0
[  283.440038]  [<ffffffff8115f682>] do_sync_write+0xd2/0x110
[  283.440038]  [<ffffffff81081856>] ? load_balance+0xb6/0x8e0
[  283.440038]  [<ffffffff8184a074>] __do_lo_send_write+0x54/0xa0
[  283.440038]  [<ffffffff8184a3b1>] do_lo_send_direct_write+0x81/0xa0
[  283.440038]  [<ffffffff8184af77>] do_bio_filebacked+0x227/0x2e0
[  283.440038]  [<ffffffff8184a330>] ? transfer_xor+0xf0/0xf0
[  283.440038]  [<ffffffff8119401d>] ? bio_free+0x4d/0x60
[  283.440038]  [<ffffffff81194045>] ? bio_fs_destructor+0x15/0x20
[  283.440038]  [<ffffffff8119346b>] ? bio_put+0x2b/0x30
[  283.440038]  [<ffffffff8184bf42>] loop_thread+0xc2/0x250
[  283.440038]  [<ffffffff810ac320>] ? add_wait_queue+0x60/0x60
[  283.440038]  [<ffffffff8184be80>] ? loop_set_status_old+0x1e0/0x1e0
[  283.440038]  [<ffffffff810ab87c>] kthread+0x8c/0xa0
[  283.440038]  [<ffffffff81ab7174>] kernel_thread_helper+0x4/0x10
[  283.440038]  [<ffffffff810ab7f0>] ? flush_kthread_worker+0xa0/0xa0
[  283.440038]  [<ffffffff81ab7170>] ? gs_change+0x13/0x13
[  283.440038] jbd2/loop0-8    D ffff88000ca08748     0  2813      2 0x00000000
[  283.440038]  ffff88000c9f7bc0 0000000000000046 0000000000000000 ffffffffb135a68d
[  283.440038]  ffff88000ca083c0 ffff88000c9f7fd8 ffff88000c9f7fd8 ffff88000c9f7fd8
[  283.440038]  ffff88007c8602c0 ffff88000ca083c0 ffff88000c9f7bc0 00000001810b59ed
[  283.440038] Call Trace:
[  283.440038]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[  283.440038]  [<ffffffff81aab3af>] schedule+0x3f/0x60
[  283.440038]  [<ffffffff81aab45f>] io_schedule+0x8f/0xd0
[  283.440038]  [<ffffffff8118eece>] sleep_on_buffer+0xe/0x20
[  283.440038]  [<ffffffff81aabc2f>] __wait_on_bit+0x5f/0x90
[  283.440038]  [<ffffffff8167e177>] ? generic_make_request+0xc7/0x100
[  283.440038]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[  283.440038]  [<ffffffff81aabcdc>] out_of_line_wait_on_bit+0x7c/0x90
[  283.440038]  [<ffffffff810ac360>] ? autoremove_wake_function+0x40/0x40
[  283.440038]  [<ffffffff8118eebe>] __wait_on_buffer+0x2e/0x30
[  283.440038]  [<ffffffff8129d2ef>] jbd2_journal_commit_transaction+0xb0f/0x15d0
[  283.440038]  [<ffffffff810998da>] ? try_to_del_timer_sync+0x8a/0x110
[  283.440038]  [<ffffffff812a15db>] kjournald2+0xbb/0x220
[  283.440038]  [<ffffffff810ac320>] ? add_wait_queue+0x60/0x60
[  283.440038]  [<ffffffff812a1520>] ? commit_timeout+0x10/0x10
[  283.440038]  [<ffffffff810ab87c>] kthread+0x8c/0xa0
[  283.440038]  [<ffffffff81ab7174>] kernel_thread_helper+0x4/0x10
[  283.440038]  [<ffffffff810ab7f0>] ? flush_kthread_worker+0xa0/0xa0
[  283.440038]  [<ffffffff81ab7170>] ? gs_change+0x13/0x13
[  283.440038] xfs_io          D ffff880044fcca88     0  2817   2816 0x00000000
[  283.440038]  ffff880012b77ac8 0000000000000086 0000000000000000 ffffffffb135a68d
[  283.440038]  ffff880044fcc700 ffff880012b77fd8 ffff880012b77fd8 ffff880012b77fd8
[  283.440038]  ffff88007c8602c0 ffff880044fcc700 ffff880012b77ac8 00000001810b59ed
[  283.440038] Call Trace:
[  283.440038]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[  283.440038]  [<ffffffff81aab3af>] schedule+0x3f/0x60
[  283.440038]  [<ffffffff81aab45f>] io_schedule+0x8f/0xd0
[  283.440038]  [<ffffffff8118eece>] sleep_on_buffer+0xe/0x20
[  283.440038]  [<ffffffff81aabc2f>] __wait_on_bit+0x5f/0x90
[  283.440038]  [<ffffffff8118eec0>] ? __wait_on_buffer+0x30/0x30
[  283.440038]  [<ffffffff81aabcdc>] out_of_line_wait_on_bit+0x7c/0x90
[  283.440038]  [<ffffffff810ac360>] ? autoremove_wake_function+0x40/0x40
[  283.440038]  [<ffffffff8118eebe>] __wait_on_buffer+0x2e/0x30
[  283.440038]  [<ffffffff8129f531>] jbd2_log_do_checkpoint+0x4c1/0x4e0
[  283.440038]  [<ffffffff8129f5ed>] __jbd2_log_wait_for_space+0x9d/0x1b0
[  283.440038]  [<ffffffff8129a4e0>] start_this_handle.isra.9+0x390/0x490
[  283.440038]  [<ffffffff810ac320>] ? add_wait_queue+0x60/0x60
[  283.440038]  [<ffffffff8129a6aa>] jbd2__journal_start+0xca/0x110
[  283.440038]  [<ffffffff8129a703>] jbd2_journal_start+0x13/0x20
[  283.440038]  [<ffffffff8127189f>] ext4_journal_start_sb+0x7f/0x1d0
[  283.440038]  [<ffffffff8127ddd4>] ? ext4_fallocate+0x1a4/0x530
[  283.440038]  [<ffffffff8127ddd4>] ext4_fallocate+0x1a4/0x530
[  283.440038]  [<ffffffff8115e992>] do_fallocate+0xf2/0x160
[  283.440038]  [<ffffffff8115ea4b>] sys_fallocate+0x4b/0x70
[  283.440038]  [<ffffffff81ab5082>] system_call_fastpath+0x16/0x1b
[  283.440038] Sched Debug Version: v0.10, 3.2.0-rc2-dgc+ #89

Looks like the prealloc created lots of dirty pages:

$ cat /proc/meminfo
MemTotal:        2050356 kB
MemFree:           17676 kB
Buffers:          518888 kB
Cached:          1367132 kB
SwapCached:         1448 kB
Active:           423444 kB
Inactive:        1476300 kB
Active(anon):       8948 kB
Inactive(anon):     4796 kB
Active(file):     414496 kB
Inactive(file):  1471504 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:        497976 kB
SwapFree:         491956 kB
Dirty:            392664 kB
Writeback:             0 kB
AnonPages:         12416 kB
Mapped:             6896 kB
Shmem:                24 kB
Slab:             105844 kB
SReclaimable:      92252 kB
SUnreclaim:        13592 kB
KernelStack:         848 kB
PageTables:         2508 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     1523152 kB
Committed_AS:      61012 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       15260 kB
VmallocChunk:   34359723095 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        6132 kB
DirectMap2M:     2091008 kB
$
$
$ cat /proc/vmstat 
nr_free_pages 4378
nr_inactive_anon 1199
nr_active_anon 2232
nr_inactive_file 367877
nr_active_file 103629
nr_unevictable 0
nr_mlock 0
nr_anon_pages 3125
nr_mapped 1724
nr_file_pages 471873
nr_dirty 98166
nr_writeback 0
nr_slab_reclaimable 23064
nr_slab_unreclaimable 3416
nr_page_table_pages 628
nr_kernel_stack 106
nr_unstable 0
nr_bounce 0
nr_vmscan_write 1597
nr_vmscan_immediate_reclaim 1752
nr_writeback_temp 0
nr_isolated_anon 0
nr_isolated_file 0
nr_shmem 6
nr_dirtied 548796
nr_written 406231
numa_hit 1086286
numa_miss 0
numa_foreign 0
numa_interleave 20982
numa_local 1086286
numa_other 0
nr_anon_transparent_hugepages 0
nr_dirty_threshold 95863
nr_dirty_background_threshold 47931
pgpgin 181756
pgpgout 2417611
pswpin 437
pswpout 1597
pgalloc_dma 7445
pgalloc_dma32 1083448
pgalloc_normal 0
pgalloc_movable 0
pgfree 1095515
pgactivate 104582
pgdeactivate 3069
pgfault 677067
pgmajfault 460
pgrefill_dma 771
pgrefill_dma32 2298
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 5415
pgsteal_dma32 90506
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 8719
pgscan_kswapd_dma32 89764
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 2969
pgscan_direct_normal 0
pgscan_direct_movable 0
zone_reclaim_failed 0
pginodesteal 0
slabs_scanned 1024
kswapd_steal 92952
kswapd_inodesteal 0
kswapd_low_wmark_hit_quickly 187
kswapd_high_wmark_hit_quickly 0
kswapd_skip_congestion_wait 0
pageoutrun 1083
allocstall 38
pgrotated 1623
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 0
unevictable_pgs_scanned 0
unevictable_pgs_rescued 0
unevictable_pgs_mlocked 0
unevictable_pgs_munlocked 0
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

And the loop device writeback is stalled in
balance_dirty_pages_nr(). Any further writes to the system result in
those processes also hanging in balance_dirty_pages_nr().

I thought this might be a one-off, but I rebooted the machine and
from a clean boot, ran the above commands and it entered the same
state where I pulled out the above traces via sysrq-w. I'm not sure
what is going on yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
