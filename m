Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab2FHFp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:45:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab2FHFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:45:54 -0400
Message-ID: <4FD1918A.2060908@gmail.com>
Date: Fri, 08 Jun 2012 15:45:46 +1000
From: Jason Stubbs <jasonbstubbs@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: PROBLEM: Possible race between  xen, md, dm and/or xfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

To quickly summarize, on a Xen domU instance with a disk structure of XFS on
LVM2 on RAID10 on 8x virtual disks, all tasks performing I/O to said XFS
partition hung and I cannot prove or disprove it to be dom0 issue.

And now the long(er) version:

On an Amazon EC2 (xen) instance, I had I/O to one of the EBS (Elastic Block
Store virtual disk) devices block with iostat showing one single request
pending. Kernel logs showed hung tasks so after grabbing those I reset the
instance but - while I'm told that Amazon's logs don't show any problems
with the EBS - Amazon want the opportunity to exclude an EBS problem by
examining things from the dom0 side while the problem is occurring before
delving into the kernel.

So what I'm really hoping for is for somebody to take a look at the call
stacks of the hung tasks and rule in/out a race condition. The kernel is
linux-2.6.35.14-106.53.amzn1 but I've resolved the call stack to the source
using gdb "list *(...)" as described in http://ds9a.nl/symoops.html. If it's
needed, I'll send the relevant parts (or all of it) in a separate mail as
it'll make this one too big.

I'm sending to xen-devel as I'd think XFS on LVM2 on RAID10 would be not so
uncommon, so I'd say Xen has something to do with it if there is in fact a
race condition.

I think that covers everything. Thanks in advance to anybody who takes the
time to glance at this. Please ensure my mail address is included in replies
as I am not subscribed.


Firstly, the hung task information:

INFO: task md127_raid10:967 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
md127_raid10  D ffff88000ab98200     0   967      2 0x00000000
 ffff880882801c40 0000000000000246 0000000000000000 0000000000014200
 ffff880882801fd8 0000000000014200 ffff880882801fd8 ffff8808828b1690
 0000000000014200 0000000000014200 ffff880882801fd8 0000000000014200
Call Trace:
 [<ffffffff8124f211>] md_super_wait+0xd1/0xf0
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8124f7c8>] md_update_sb+0x268/0x3e0
 [<ffffffff813192b9>] ? _raw_spin_unlock_irqrestore+0x19/0x20
 [<ffffffff81253cca>] md_check_recovery+0x21a/0x540
 [<ffffffffa0014a57>] raid10d+0x47/0x920 [raid10]
 [<ffffffff81006f1d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffff8100766f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff813192b9>] ? _raw_spin_unlock_irqrestore+0x19/0x20
 [<ffffffff8124ef56>] md_thread+0x116/0x150
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8124ee40>] ? md_thread+0x0/0x150
 [<ffffffff8106816e>] kthread+0x8e/0xa0
 [<ffffffff8100bc64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8100b063>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8131975d>] ? retint_restore_args+0x5/0x6
 [<ffffffff8100bc60>] ? kernel_thread_helper+0x0/0x10

INFO: task kdmflush:1004 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kdmflush      D ffff88000abd0200     0  1004      2 0x00000000
 ffff880882ff5d30 0000000000000246 0000000000000000 0000000000014200
 ffff880882ff5fd8 0000000000014200 ffff880882ff5fd8 ffff8808828b43b0
 0000000000014200 0000000000014200 ffff880882ff5fd8 0000000000014200
Call Trace:
 [<ffffffff8131738e>] io_schedule+0x6e/0xb0
 [<ffffffffa0002052>] dm_wait_for_completion+0xc2/0x150 [dm_mod]
 [<ffffffff81049650>] ? default_wake_function+0x0/0x10
 [<ffffffffa0002de0>] ? dm_wq_work+0x0/0x1d0 [dm_mod]
 [<ffffffffa0002d8e>] dm_flush+0x1e/0x70 [dm_mod]
 [<ffffffffa0002e22>] dm_wq_work+0x42/0x1d0 [dm_mod]
 [<ffffffffa0002de0>] ? dm_wq_work+0x0/0x1d0 [dm_mod]
 [<ffffffff81064130>] worker_thread+0x160/0x250
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff81063fd0>] ? worker_thread+0x0/0x250
 [<ffffffff8106816e>] kthread+0x8e/0xa0
 [<ffffffff8100bc64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8100b063>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8131975d>] ? retint_restore_args+0x5/0x6
 [<ffffffff8100bc60>] ? kernel_thread_helper+0x0/0x10

INFO: task xfsbufd/dm-0:1470 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfsbufd/dm-0  D ffff88000abd0200     0  1470      2 0x00000000
 ffff88088518fb70 0000000000000246 0000000000000000 0000000000014200
 ffff88088518ffd8 0000000000014200 ffff88088518ffd8 ffff8808853b9690
 0000000000014200 0000000000014200 ffff88088518ffd8 0000000000014200
Call Trace:
 [<ffffffff8124d95d>] md_write_start+0xad/0x1d0
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa00162b0>] make_request+0x70/0x530 [raid10]
 [<ffffffff8124dbc1>] md_make_request+0xc1/0x220
 [<ffffffffa00030a1>] ? dm_request+0xf1/0x230 [dm_mod]
 [<ffffffff81198bf3>] generic_make_request+0x1f3/0x3c0
 [<ffffffffa0001e26>] ? dm_get_live_table+0x46/0x60 [dm_mod]
 [<ffffffffa00032fc>] ? dm_merge_bvec+0xbc/0x140 [dm_mod]
 [<ffffffff81198e3f>] submit_bio+0x7f/0x110
 [<ffffffffa0119abc>] _xfs_buf_ioapply+0x18c/0x2c0 [xfs]
 [<ffffffffa011ab51>] xfs_buf_iorequest+0x31/0x80 [xfs]
 [<ffffffffa011b96d>] xfs_bdstrat_cb+0x2d/0x50 [xfs]
 [<ffffffffa011afc2>] xfsbufd+0xe2/0x1a0 [xfs]
 [<ffffffffa011aee0>] ? xfsbufd+0x0/0x1a0 [xfs]
 [<ffffffff8106816e>] kthread+0x8e/0xa0
 [<ffffffff8100bc64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8100b063>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8131975d>] ? retint_restore_args+0x5/0x6
 [<ffffffff8100bc60>] ? kernel_thread_helper+0x0/0x10

INFO: task mysqld:5207 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mysqld        D ffff88000abec200     0  5207   4991 0x00000000
 ffff8808836098b8 0000000000000286 0000000000000000 0000000000014200
 ffff880883609fd8 0000000000014200 ffff880883609fd8 ffff880883ae8000
 0000000000014200 0000000000014200 ffff880883609fd8 0000000000014200
Call Trace:
 [<ffffffff813192b9>] ? _raw_spin_unlock_irqrestore+0x19/0x20
 [<ffffffff8124d95d>] md_write_start+0xad/0x1d0
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa00162b0>] make_request+0x70/0x530 [raid10]
 [<ffffffff8124dbc1>] md_make_request+0xc1/0x220
 [<ffffffff81006f1d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffffa00030a1>] ? dm_request+0xf1/0x230 [dm_mod]
 [<ffffffff81006f1d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffff81198bf3>] generic_make_request+0x1f3/0x3c0
 [<ffffffffa0001e26>] ? dm_get_live_table+0x46/0x60 [dm_mod]
 [<ffffffffa0005aad>] ? linear_merge+0x4d/0x60 [dm_mod]
 [<ffffffffa00032fc>] ? dm_merge_bvec+0xbc/0x140 [dm_mod]
 [<ffffffff81198e3f>] submit_bio+0x7f/0x110
 [<ffffffffa0117732>] xfs_submit_ioend_bio+0x52/0x90 [xfs]
 [<ffffffffa0117821>] xfs_submit_ioend+0xb1/0x110 [xfs]
 [<ffffffffa0118880>] xfs_page_state_convert+0x330/0x6a0 [xfs]
 [<ffffffffa0118d46>] xfs_vm_writepage+0x76/0x110 [xfs]
 [<ffffffff810bfc22>] __writepage+0x12/0x40
 [<ffffffff810c0ccf>] write_cache_pages+0x1cf/0x3f0
 [<ffffffff810bfc10>] ? __writepage+0x0/0x40
 [<ffffffff81007521>] ? xen_clocksource_read+0x21/0x30
 [<ffffffff810c0f0f>] generic_writepages+0x1f/0x30
 [<ffffffffa0117cb8>] xfs_vm_writepages+0x58/0x70 [xfs]
 [<ffffffff810c0f3c>] do_writepages+0x1c/0x30
 [<ffffffff810b8b83>] __filemap_fdatawrite_range+0x53/0x60
 [<ffffffff810b8bea>] filemap_write_and_wait_range+0x5a/0x80
 [<ffffffff8111c9b2>] vfs_fsync_range+0x52/0x90
 [<ffffffff8111ca57>] vfs_fsync+0x17/0x20
 [<ffffffff8111ca95>] do_fsync+0x35/0x60
 [<ffffffff8111caeb>] sys_fsync+0xb/0x10
 [<ffffffff8100ae42>] system_call_fastpath+0x16/0x1b

INFO: task flush-253:0:14617 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-253:0   D ffff88000abd0200     0 14617      2 0x00000000
 ffff880882b07620 0000000000000246 0000000000000000 0000000000014200
 ffff880882b07fd8 0000000000014200 ffff880882b07fd8 ffff8808055643b0
 0000000000014200 0000000000014200 ffff880882b07fd8 0000000000014200
Call Trace:
 [<ffffffff8124d95d>] md_write_start+0xad/0x1d0
 [<ffffffff81068630>] ? autoremove_wake_function+0x0/0x40
 [<ffffffffa00162b0>] make_request+0x70/0x530 [raid10]
 [<ffffffff8124dbc1>] md_make_request+0xc1/0x220
 [<ffffffff81006f1d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffffa00030a1>] ? dm_request+0xf1/0x230 [dm_mod]
 [<ffffffff81006f1d>] ? xen_force_evtchn_callback+0xd/0x10
 [<ffffffff81198bf3>] generic_make_request+0x1f3/0x3c0
 [<ffffffff81007521>] ? xen_clocksource_read+0x21/0x30
 [<ffffffff81198e3f>] submit_bio+0x7f/0x110
 [<ffffffff811189a2>] ? __mark_inode_dirty+0x92/0x170
 [<ffffffffa0117732>] xfs_submit_ioend_bio+0x52/0x90 [xfs]
 [<ffffffffa0117866>] xfs_submit_ioend+0xf6/0x110 [xfs]
 [<ffffffffa0118880>] xfs_page_state_convert+0x330/0x6a0 [xfs]
 [<ffffffffa0118d46>] xfs_vm_writepage+0x76/0x110 [xfs]
 [<ffffffff810bfc22>] __writepage+0x12/0x40
 [<ffffffff810c0ccf>] write_cache_pages+0x1cf/0x3f0
 [<ffffffff810bfc10>] ? __writepage+0x0/0x40
 [<ffffffff810c0f0f>] generic_writepages+0x1f/0x30
 [<ffffffffa0117cb8>] xfs_vm_writepages+0x58/0x70 [xfs]
 [<ffffffff810c0f3c>] do_writepages+0x1c/0x30
 [<ffffffff81117c5a>] writeback_single_inode+0xea/0x3f0
 [<ffffffff811183ad>] writeback_sb_inodes+0x18d/0x270
 [<ffffffff81007521>] ? xen_clocksource_read+0x21/0x30
 [<ffffffff81118c94>] writeback_inodes_wb+0xa4/0x1b0
 [<ffffffff81118feb>] wb_writeback+0x24b/0x2b0
 [<ffffffff8102e568>] ? pvclock_clocksource_read+0x58/0xd0
 [<ffffffff810084f5>] ? xen_spin_lock+0xa5/0x110
 [<ffffffff811191af>] wb_do_writeback+0x15f/0x170
 [<ffffffff8105c6a0>] ? process_timeout+0x0/0x10
 [<ffffffff8111920f>] bdi_writeback_task+0x4f/0x160
 [<ffffffff81068512>] ? bit_waitqueue+0x12/0xc0
 [<ffffffff810cda21>] bdi_start_fn+0x81/0x100
 [<ffffffff810cd9a0>] ? bdi_start_fn+0x0/0x100
 [<ffffffff8106816e>] kthread+0x8e/0xa0
 [<ffffffff8100bc64>] kernel_thread_helper+0x4/0x10
 [<ffffffff8100b063>] ? int_ret_from_sys_call+0x7/0x1b
 [<ffffffff8131975d>] ? retint_restore_args+0x5/0x6
 [<ffffffff8100bc60>] ? kernel_thread_helper+0x0/0x10


And then dmesg output:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35.14-106.53.amzn1.x86_64 (mockbuild@build-31006.build) (gcc version 4.4.5 20110214 (Red Hat 4.4.5-6) (GCC) ) #1 SMP Fri Jan 6 16:20:10 UTC 2012
[    0.000000] Command line: root=LABEL=/ console=hvc0 LANG=en_US.UTF-8 KEYTABLE=us
[    0.000000] Marking TSC unstable due to Xen domain
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] released 0 pages of unused memory
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  Xen: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  Xen: 00000000000a0000 - 0000000000100000 (reserved)
[    0.000000]  Xen: 0000000000100000 - 000000088b800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x88b800 max_arch_pfn = 0x400000000
[    0.000000] last_pfn = 0x100000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-0000000100000000
[    0.000000]  0000000000 - 0100000000 page 4k
[    0.000000] kernel direct mapping tables up to 100000000 @ 100000-905000
[    0.000000] init_memory_mapping: 0000000100000000-000000088b800000
[    0.000000]  0100000000 - 088b800000 page 4k
[    0.000000] kernel direct mapping tables up to 88b800000 @ 6ed9000-b359000
[    0.000000] RAMDISK: 0185a000 - 02a3f000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000088b800000
[    0.000000] Initmem setup node 0 0000000000000000-000000088b800000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] early_res array is doubled to 128 at [7800 - 87ff]
[    0.000000] early_res array is doubled to 256 at [8800 - a7ff]
[    0.000000] early_res array is doubled to 512 at [a800 - e7ff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0088b800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0088b800
[    0.000000] On node 0 totalpages: 8959903
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3943 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 1030200 pages, LIFO batch:31
[    0.000000]   Normal zone: 108164 pages used for memmap
[    0.000000]   Normal zone: 7803260 pages, LIFO batch:31
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] No local APIC present
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PCI: Warning: Cannot find a gap in the 32bit address range
[    0.000000] PCI: Unassigned devices with 32bit resource registers may break!
[    0.000000] Allocating PCI resources starting at 88b900000 (gap: 88b900000:400000)
[    0.000000] Booting paravirtualized kernel on Xen
[    0.000000] Xen version: 3.4.3-2.6.18 (preserve-AD)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88000ab84000 s85568 r8192 d20928 u114688
[    0.000000] pcpu-alloc: s85568 r8192 d20928 u114688 alloc=28*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] trying to map vcpu_info 0 at ffff88000ab8f020, mfn e1df7f, offset 32
[    0.000000] cpu 0 using vcpu_info at ffff88000ab8f020
[    0.000000] trying to map vcpu_info 1 at ffff88000abab020, mfn e1df63, offset 32
[    0.000000] cpu 1 using vcpu_info at ffff88000abab020
[    0.000000] trying to map vcpu_info 2 at ffff88000abc7020, mfn e1df47, offset 32
[    0.000000] cpu 2 using vcpu_info at ffff88000abc7020
[    0.000000] trying to map vcpu_info 3 at ffff88000abe3020, mfn e1df2b, offset 32
[    0.000000] cpu 3 using vcpu_info at ffff88000abe3020
[    0.000000] Xen: using vcpu_info placement
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8837403
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=LABEL=/ console=hvc0 LANG=en_US.UTF-8 KEYTABLE=us
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (281 early reservations)
[    0.000000]   #1 [0006e9e000 - 0006ed9000]  XEN PAGETABLES
[    0.000000]   #2 [0001000000 - 00018389d0]   TEXT DATA BSS
[    0.000000]   #3 [000185a000 - 0002a3f000]         RAMDISK
[    0.000000]   #4 [0002a3f000 - 0006e9e000]  XEN START INFO
[    0.000000]   #5 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #6 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #7 [0000100000 - 00008c7000]         PGTABLE
[    0.000000]   #8 [0006ed9000 - 000ab54000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [0001838a00 - 0001839a00]         BOOTMEM
[    0.000000]   #11 [0001839a00 - 000183aa00]         BOOTMEM
[    0.000000]   #12 [000183aa00 - 000183bb20]         BOOTMEM
[    0.000000]   #13 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #14 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #15 [0100007000 - 0100008000]         BOOTMEM
[    0.000000]   #16 [0100008000 - 0100009000]         BOOTMEM
[    0.000000]   #17 [0100009000 - 010000a000]         BOOTMEM
[    0.000000]   #18 [010000a000 - 010000b000]         BOOTMEM
[    0.000000]   #19 [010000b000 - 010000c000]         BOOTMEM
[    0.000000]   #20 [010000c000 - 010000d000]         BOOTMEM
[    0.000000]   #21 [010000d000 - 010000e000]         BOOTMEM
[    0.000000]   #22 [010000e000 - 010000f000]         BOOTMEM
[    0.000000]   #23 [010000f000 - 0100010000]         BOOTMEM
[    0.000000]   #24 [0100010000 - 0100011000]         BOOTMEM
[    0.000000]   #25 [0100011000 - 0100012000]         BOOTMEM
[    0.000000]   #26 [0100012000 - 0100013000]         BOOTMEM
[    0.000000]   #27 [0100013000 - 0100014000]         BOOTMEM
[    0.000000]   #28 [0100014000 - 0100015000]         BOOTMEM
[    0.000000]   #29 [0100015000 - 0100016000]         BOOTMEM
[    0.000000]   #30 [0100016000 - 0100017000]         BOOTMEM
[    0.000000]   #31 [0100017000 - 0100018000]         BOOTMEM
[    0.000000]   #32 [0100018000 - 0100019000]         BOOTMEM
[    0.000000]   #33 [0100019000 - 010001a000]         BOOTMEM
[    0.000000]   #34 [010001a000 - 010001b000]         BOOTMEM
[    0.000000]   #35 [010001b000 - 010001c000]         BOOTMEM
[    0.000000]   #36 [010001c000 - 010001d000]         BOOTMEM
[    0.000000]   #37 [010001d000 - 010001e000]         BOOTMEM
[    0.000000]   #38 [010001e000 - 010001f000]         BOOTMEM
[    0.000000]   #39 [010001f000 - 0100020000]         BOOTMEM
[    0.000000]   #40 [0100020000 - 0100021000]         BOOTMEM
[    0.000000]   #41 [0100021000 - 0100022000]         BOOTMEM
[    0.000000]   #42 [0100022000 - 0100023000]         BOOTMEM
[    0.000000]   #43 [0100023000 - 0100024000]         BOOTMEM
[    0.000000]   #44 [0100024000 - 0100025000]         BOOTMEM
[    0.000000]   #45 [0100025000 - 0100026000]         BOOTMEM
[    0.000000]   #46 [0100026000 - 0100027000]         BOOTMEM
[    0.000000]   #47 [0100027000 - 0100028000]         BOOTMEM
[    0.000000]   #48 [0100028000 - 0100029000]         BOOTMEM
[    0.000000]   #49 [0100029000 - 010002a000]         BOOTMEM
[    0.000000]   #50 [010002a000 - 010002b000]         BOOTMEM
[    0.000000]   #51 [010002b000 - 010002c000]         BOOTMEM
[    0.000000]   #52 [010002c000 - 010002d000]         BOOTMEM
[    0.000000]   #53 [010002d000 - 010002e000]         BOOTMEM
[    0.000000]   #54 [010002e000 - 010002f000]         BOOTMEM
[    0.000000]   #55 [010002f000 - 0100030000]         BOOTMEM
[    0.000000]   #56 [0100030000 - 0100031000]         BOOTMEM
[    0.000000]   #57 [0100031000 - 0100032000]         BOOTMEM
[    0.000000]   #58 [0100032000 - 0100033000]         BOOTMEM
[    0.000000]   #59 [0100033000 - 0100034000]         BOOTMEM
[    0.000000]   #60 [0100034000 - 0100035000]         BOOTMEM
[    0.000000]   #61 [0100035000 - 0100036000]         BOOTMEM
[    0.000000]   #62 [0100036000 - 0100037000]         BOOTMEM
[    0.000000]   #63 [0100037000 - 0100038000]         BOOTMEM
[    0.000000]   #64 [0100038000 - 0100039000]         BOOTMEM
[    0.000000]   #65 [0100039000 - 010003a000]         BOOTMEM
[    0.000000]   #66 [010003a000 - 010003b000]         BOOTMEM
[    0.000000]   #67 [010003b000 - 010003c000]         BOOTMEM
[    0.000000]   #68 [010003c000 - 010003d000]         BOOTMEM
[    0.000000]   #69 [010003d000 - 010003e000]         BOOTMEM
[    0.000000]   #70 [010003e000 - 010003f000]         BOOTMEM
[    0.000000]   #71 [010003f000 - 0100040000]         BOOTMEM
[    0.000000]   #72 [0100040000 - 0100041000]         BOOTMEM
[    0.000000]   #73 [0100041000 - 0100042000]         BOOTMEM
[    0.000000]   #74 [0100042000 - 0100043000]         BOOTMEM
[    0.000000]   #75 [0100043000 - 0100044000]         BOOTMEM
[    0.000000]   #76 [0100044000 - 0100045000]         BOOTMEM
[    0.000000]   #77 [0100045000 - 0100046000]         BOOTMEM
[    0.000000]   #78 [0100046000 - 0100047000]         BOOTMEM
[    0.000000]   #79 [0100047000 - 0100048000]         BOOTMEM
[    0.000000]   #80 [0100048000 - 0100049000]         BOOTMEM
[    0.000000]   #81 [0100049000 - 010004a000]         BOOTMEM
[    0.000000]   #82 [010004a000 - 010004b000]         BOOTMEM
[    0.000000]   #83 [010004b000 - 010004c000]         BOOTMEM
[    0.000000]   #84 [010004c000 - 010004d000]         BOOTMEM
[    0.000000]   #85 [010004d000 - 010004e000]         BOOTMEM
[    0.000000]   #86 [010004e000 - 010004f000]         BOOTMEM
[    0.000000]   #87 [010004f000 - 0100050000]         BOOTMEM
[    0.000000]   #88 [0100050000 - 0100051000]         BOOTMEM
[    0.000000]   #89 [0100051000 - 0100052000]         BOOTMEM
[    0.000000]   #90 [0100052000 - 0100053000]         BOOTMEM
[    0.000000]   #91 [0100053000 - 0100054000]         BOOTMEM
[    0.000000]   #92 [0100054000 - 0100055000]         BOOTMEM
[    0.000000]   #93 [0100055000 - 0100056000]         BOOTMEM
[    0.000000]   #94 [0100056000 - 0100057000]         BOOTMEM
[    0.000000]   #95 [0100057000 - 0100058000]         BOOTMEM
[    0.000000]   #96 [0100058000 - 0100059000]         BOOTMEM
[    0.000000]   #97 [0100059000 - 010005a000]         BOOTMEM
[    0.000000]   #98 [010005a000 - 010005b000]         BOOTMEM
[    0.000000]   #99 [010005b000 - 010005c000]         BOOTMEM
[    0.000000]   #100 [010005c000 - 010005d000]         BOOTMEM
[    0.000000]   #101 [010005d000 - 010005e000]         BOOTMEM
[    0.000000]   #102 [010005e000 - 010005f000]         BOOTMEM
[    0.000000]   #103 [010005f000 - 0100060000]         BOOTMEM
[    0.000000]   #104 [0100060000 - 0100061000]         BOOTMEM
[    0.000000]   #105 [0100061000 - 0100062000]         BOOTMEM
[    0.000000]   #106 [0100062000 - 0100063000]         BOOTMEM
[    0.000000]   #107 [0100063000 - 0100064000]         BOOTMEM
[    0.000000]   #108 [0100064000 - 0100065000]         BOOTMEM
[    0.000000]   #109 [0100065000 - 0100066000]         BOOTMEM
[    0.000000]   #110 [0100066000 - 0100067000]         BOOTMEM
[    0.000000]   #111 [0100067000 - 0100068000]         BOOTMEM
[    0.000000]   #112 [0100068000 - 0100069000]         BOOTMEM
[    0.000000]   #113 [0100069000 - 010006a000]         BOOTMEM
[    0.000000]   #114 [010006a000 - 010006b000]         BOOTMEM
[    0.000000]   #115 [010006b000 - 010006c000]         BOOTMEM
[    0.000000]   #116 [010006c000 - 010006d000]         BOOTMEM
[    0.000000]   #117 [010006d000 - 010006e000]         BOOTMEM
[    0.000000]   #118 [010006e000 - 010006f000]         BOOTMEM
[    0.000000]   #119 [010006f000 - 0100070000]         BOOTMEM
[    0.000000]   #120 [0100070000 - 0100071000]         BOOTMEM
[    0.000000]   #121 [0100071000 - 0100072000]         BOOTMEM
[    0.000000]   #122 [0100072000 - 0100073000]         BOOTMEM
[    0.000000]   #123 [0100073000 - 0100074000]         BOOTMEM
[    0.000000]   #124 [0100074000 - 0100075000]         BOOTMEM
[    0.000000]   #125 [0100075000 - 0100076000]         BOOTMEM
[    0.000000]   #126 [0100076000 - 0100077000]         BOOTMEM
[    0.000000]   #127 [0100077000 - 0100078000]         BOOTMEM
[    0.000000]   #128 [0100078000 - 0100079000]         BOOTMEM
[    0.000000]   #129 [0100079000 - 010007a000]         BOOTMEM
[    0.000000]   #130 [010007a000 - 010007b000]         BOOTMEM
[    0.000000]   #131 [010007b000 - 010007c000]         BOOTMEM
[    0.000000]   #132 [010007c000 - 010007d000]         BOOTMEM
[    0.000000]   #133 [010007d000 - 010007e000]         BOOTMEM
[    0.000000]   #134 [010007e000 - 010007f000]         BOOTMEM
[    0.000000]   #135 [010007f000 - 0100080000]         BOOTMEM
[    0.000000]   #136 [0100080000 - 0100081000]         BOOTMEM
[    0.000000]   #137 [0100081000 - 0100082000]         BOOTMEM
[    0.000000]   #138 [0100082000 - 0100083000]         BOOTMEM
[    0.000000]   #139 [0100083000 - 0100084000]         BOOTMEM
[    0.000000]   #140 [0100084000 - 0100085000]         BOOTMEM
[    0.000000]   #141 [0100085000 - 0100086000]         BOOTMEM
[    0.000000]   #142 [0100086000 - 0100087000]         BOOTMEM
[    0.000000]   #143 [0100087000 - 0100088000]         BOOTMEM
[    0.000000]   #144 [0100088000 - 0100089000]         BOOTMEM
[    0.000000]   #145 [0100089000 - 010008a000]         BOOTMEM
[    0.000000]   #146 [010008a000 - 010008b000]         BOOTMEM
[    0.000000]   #147 [010008b000 - 010008c000]         BOOTMEM
[    0.000000]   #148 [010008c000 - 010008d000]         BOOTMEM
[    0.000000]   #149 [010008d000 - 010008e000]         BOOTMEM
[    0.000000]   #150 [010008e000 - 010008f000]         BOOTMEM
[    0.000000]   #151 [010008f000 - 0100090000]         BOOTMEM
[    0.000000]   #152 [0100090000 - 0100091000]         BOOTMEM
[    0.000000]   #153 [0100091000 - 0100092000]         BOOTMEM
[    0.000000]   #154 [0100092000 - 0100093000]         BOOTMEM
[    0.000000]   #155 [0100093000 - 0100094000]         BOOTMEM
[    0.000000]   #156 [0100094000 - 0100095000]         BOOTMEM
[    0.000000]   #157 [0100095000 - 0100096000]         BOOTMEM
[    0.000000]   #158 [0100096000 - 0100097000]         BOOTMEM
[    0.000000]   #159 [0100097000 - 0100098000]         BOOTMEM
[    0.000000]   #160 [0100098000 - 0100099000]         BOOTMEM
[    0.000000]   #161 [0100099000 - 010009a000]         BOOTMEM
[    0.000000]   #162 [010009a000 - 010009b000]         BOOTMEM
[    0.000000]   #163 [010009b000 - 010009c000]         BOOTMEM
[    0.000000]   #164 [010009c000 - 010009d000]         BOOTMEM
[    0.000000]   #165 [010009d000 - 010009e000]         BOOTMEM
[    0.000000]   #166 [010009e000 - 010009f000]         BOOTMEM
[    0.000000]   #167 [010009f000 - 01000a0000]         BOOTMEM
[    0.000000]   #168 [01000a0000 - 01000a1000]         BOOTMEM
[    0.000000]   #169 [01000a1000 - 01000a2000]         BOOTMEM
[    0.000000]   #170 [01000a2000 - 01000a3000]         BOOTMEM
[    0.000000]   #171 [01000a3000 - 01000a4000]         BOOTMEM
[    0.000000]   #172 [01000a4000 - 01000a5000]         BOOTMEM
[    0.000000]   #173 [01000a5000 - 01000a6000]         BOOTMEM
[    0.000000]   #174 [01000a6000 - 01000a7000]         BOOTMEM
[    0.000000]   #175 [01000a7000 - 01000a8000]         BOOTMEM
[    0.000000]   #176 [01000a8000 - 01000a9000]         BOOTMEM
[    0.000000]   #177 [01000a9000 - 01000aa000]         BOOTMEM
[    0.000000]   #178 [01000aa000 - 01000ab000]         BOOTMEM
[    0.000000]   #179 [01000ab000 - 01000ac000]         BOOTMEM
[    0.000000]   #180 [01000ac000 - 01000ad000]         BOOTMEM
[    0.000000]   #181 [01000ad000 - 01000ae000]         BOOTMEM
[    0.000000]   #182 [01000ae000 - 01000af000]         BOOTMEM
[    0.000000]   #183 [01000af000 - 01000b0000]         BOOTMEM
[    0.000000]   #184 [01000b0000 - 01000b1000]         BOOTMEM
[    0.000000]   #185 [01000b1000 - 01000b2000]         BOOTMEM
[    0.000000]   #186 [01000b2000 - 01000b3000]         BOOTMEM
[    0.000000]   #187 [01000b3000 - 01000b4000]         BOOTMEM
[    0.000000]   #188 [01000b4000 - 01000b5000]         BOOTMEM
[    0.000000]   #189 [01000b5000 - 01000b6000]         BOOTMEM
[    0.000000]   #190 [01000b6000 - 01000b7000]         BOOTMEM
[    0.000000]   #191 [01000b7000 - 01000b8000]         BOOTMEM
[    0.000000]   #192 [01000b8000 - 01000b9000]         BOOTMEM
[    0.000000]   #193 [01000b9000 - 01000ba000]         BOOTMEM
[    0.000000]   #194 [01000ba000 - 01000bb000]         BOOTMEM
[    0.000000]   #195 [01000bb000 - 01000bc000]         BOOTMEM
[    0.000000]   #196 [01000bc000 - 01000bd000]         BOOTMEM
[    0.000000]   #197 [01000bd000 - 01000be000]         BOOTMEM
[    0.000000]   #198 [01000be000 - 01000bf000]         BOOTMEM
[    0.000000]   #199 [01000bf000 - 01000c0000]         BOOTMEM
[    0.000000]   #200 [01000c0000 - 01000c1000]         BOOTMEM
[    0.000000]   #201 [01000c1000 - 01000c2000]         BOOTMEM
[    0.000000]   #202 [01000c2000 - 01000c3000]         BOOTMEM
[    0.000000]   #203 [01000c3000 - 01000c4000]         BOOTMEM
[    0.000000]   #204 [01000c4000 - 01000c5000]         BOOTMEM
[    0.000000]   #205 [01000c5000 - 01000c6000]         BOOTMEM
[    0.000000]   #206 [01000c6000 - 01000c7000]         BOOTMEM
[    0.000000]   #207 [01000c7000 - 01000c8000]         BOOTMEM
[    0.000000]   #208 [01000c8000 - 01000c9000]         BOOTMEM
[    0.000000]   #209 [01000c9000 - 01000ca000]         BOOTMEM
[    0.000000]   #210 [01000ca000 - 01000cb000]         BOOTMEM
[    0.000000]   #211 [01000cb000 - 01000cc000]         BOOTMEM
[    0.000000]   #212 [01000cc000 - 01000cd000]         BOOTMEM
[    0.000000]   #213 [01000cd000 - 01000ce000]         BOOTMEM
[    0.000000]   #214 [01000ce000 - 01000cf000]         BOOTMEM
[    0.000000]   #215 [01000cf000 - 01000d0000]         BOOTMEM
[    0.000000]   #216 [01000d0000 - 01000d1000]         BOOTMEM
[    0.000000]   #217 [01000d1000 - 01000d2000]         BOOTMEM
[    0.000000]   #218 [01000d2000 - 01000d3000]         BOOTMEM
[    0.000000]   #219 [01000d3000 - 01000d4000]         BOOTMEM
[    0.000000]   #220 [01000d4000 - 01000d5000]         BOOTMEM
[    0.000000]   #221 [01000d5000 - 01000d6000]         BOOTMEM
[    0.000000]   #222 [01000d6000 - 01000d7000]         BOOTMEM
[    0.000000]   #223 [01000d7000 - 01000d8000]         BOOTMEM
[    0.000000]   #224 [01000d8000 - 01000d9000]         BOOTMEM
[    0.000000]   #225 [01000d9000 - 01000da000]         BOOTMEM
[    0.000000]   #226 [01000da000 - 01000db000]         BOOTMEM
[    0.000000]   #227 [01000db000 - 01000dc000]         BOOTMEM
[    0.000000]   #228 [01000dc000 - 01000dd000]         BOOTMEM
[    0.000000]   #229 [01000dd000 - 01000de000]         BOOTMEM
[    0.000000]   #230 [01000de000 - 01000df000]         BOOTMEM
[    0.000000]   #231 [01000df000 - 01000e0000]         BOOTMEM
[    0.000000]   #232 [01000e0000 - 01000e1000]         BOOTMEM
[    0.000000]   #233 [01000e1000 - 01000e2000]         BOOTMEM
[    0.000000]   #234 [01000e2000 - 01000e3000]         BOOTMEM
[    0.000000]   #235 [01000e3000 - 01000e4000]         BOOTMEM
[    0.000000]   #236 [01000e4000 - 01000e5000]         BOOTMEM
[    0.000000]   #237 [01000e5000 - 01000e6000]         BOOTMEM
[    0.000000]   #238 [01000e6000 - 01000e7000]         BOOTMEM
[    0.000000]   #239 [01000e7000 - 01000e8000]         BOOTMEM
[    0.000000]   #240 [01000e8000 - 01000e9000]         BOOTMEM
[    0.000000]   #241 [01000e9000 - 01000ea000]         BOOTMEM
[    0.000000]   #242 [01000ea000 - 01000eb000]         BOOTMEM
[    0.000000]   #243 [01000eb000 - 01000ec000]         BOOTMEM
[    0.000000]   #244 [01000ec000 - 01000ed000]         BOOTMEM
[    0.000000]   #245 [01000ed000 - 01000ee000]         BOOTMEM
[    0.000000]   #246 [01000ee000 - 01000ef000]         BOOTMEM
[    0.000000]   #247 [01000ef000 - 01000f0000]         BOOTMEM
[    0.000000]   #248 [01000f0000 - 01000f1000]         BOOTMEM
[    0.000000]   #249 [01000f1000 - 01000f2000]         BOOTMEM
[    0.000000]   #250 [01000f2000 - 01000f3000]         BOOTMEM
[    0.000000]   #251 [01000f3000 - 01000f4000]         BOOTMEM
[    0.000000]   #252 [01000f4000 - 01000f5000]         BOOTMEM
[    0.000000]   #253 [01000f5000 - 01000f6000]         BOOTMEM
[    0.000000]   #254 [01000f6000 - 01000f7000]         BOOTMEM
[    0.000000]   #255 [0100200000 - 011e180000]        MEMMAP 0
[    0.000000]   #256 [000183bb40 - 0001853b40]         BOOTMEM
[    0.000000]   #257 [000ab54000 - 000ab6c000]         BOOTMEM
[    0.000000]   #258 [000ab6c000 - 000ab84000]         BOOTMEM
[    0.000000]   #259 [0001854000 - 0001855000]         BOOTMEM
[    0.000000]   #260 [0001855000 - 0001856000]         BOOTMEM
[    0.000000]   #261 [0001856000 - 0001857000]         BOOTMEM
[    0.000000]   #262 [0001853b40 - 0001853c20]         BOOTMEM
[    0.000000]   #263 [0001853c40 - 0001853ca8]         BOOTMEM
[    0.000000]   #264 [0001853cc0 - 0001853d28]         BOOTMEM
[    0.000000]   #265 [0001853d40 - 0001853da8]         BOOTMEM
[    0.000000]   #266 [0001853dc0 - 0001853df7]         BOOTMEM
[    0.000000]   #267 [0001853e00 - 0001853e37]         BOOTMEM
[    0.000000]   #268 [000ab84000 - 000abf4000]         BOOTMEM
[    0.000000]   #269 [0001853e40 - 0001853e48]         BOOTMEM
[    0.000000]   #270 [0001853e80 - 0001853e88]         BOOTMEM
[    0.000000]   #271 [0001853ec0 - 0001853ed0]         BOOTMEM
[    0.000000]   #272 [0001853f00 - 0001853f20]         BOOTMEM
[    0.000000]   #273 [0001859000 - 0001859100]         BOOTMEM
[    0.000000]   #274 [0001853f40 - 0001853f88]         BOOTMEM
[    0.000000]   #275 [0001859100 - 0001859148]         BOOTMEM
[    0.000000]   #276 [000abf4000 - 000abfc000]         BOOTMEM
[    0.000000]   #277 [000abfc000 - 000ebfc000]         BOOTMEM
[    0.000000]   #278 [000ebfc000 - 000ec1c000]         BOOTMEM
[    0.000000]   #279 [000ec1c000 - 000ec5c000]         BOOTMEM
[    0.000000]   #280 [000000e800 - 0000016800]         BOOTMEM
[    0.000000] Memory: 35113952k/35840000k available (3206k kernel code, 388k absent, 725660k reserved, 3713k data, 500k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:304
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [hvc0] enabled
[    0.000000] Xen: using vcpuop timer interface
[    0.000000] installing Xen timer for CPU 0
[    0.000000] Detected 2666.760 MHz processor.
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 5333.52 BogoMIPS (lpj=2666760)
[    0.000999] pid_max: default: 32768 minimum: 301
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Disabled at boot.
[    0.005404] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.020712] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.028351] Mount-cache hash table entries: 256
[    0.028548] Initializing cgroup subsys ns
[    0.028556] Initializing cgroup subsys cpuacct
[    0.028564] Initializing cgroup subsys devices
[    0.028571] Initializing cgroup subsys freezer
[    0.028618] CPU: Unsupported number of siblings 16
[    0.028624] Performance Events: unsupported p6 CPU model 26 no PMU driver, software events only.
[    0.028704] SMP alternatives: switching to UP code
[    0.029073] cpu 0 spinlock event irq 1
[    0.029261] installing Xen timer for CPU 1
[    0.029274] cpu 1 spinlock event irq 7
[    0.029299] SMP alternatives: switching to SMP code
[    0.000999] CPU: Unsupported number of siblings 16
[    0.030203] installing Xen timer for CPU 2
[    0.030224] cpu 2 spinlock event irq 13
[    0.030254]   alloc irq_desc for 16 on node 0
[    0.030257]   alloc kstat_irqs on node 0
[    0.030264]   alloc irq_desc for 17 on node 0
[    0.030267]   alloc kstat_irqs on node 0
[    0.000999] CPU: Unsupported number of siblings 16
[    0.030449] installing Xen timer for CPU 3
[    0.030459]   alloc irq_desc for 18 on node 0
[    0.030462]   alloc kstat_irqs on node 0
[    0.030468]   alloc irq_desc for 19 on node 0
[    0.030471]   alloc kstat_irqs on node 0
[    0.030477] cpu 3 spinlock event irq 19
[    0.030496]   alloc irq_desc for 20 on node 0
[    0.030498]   alloc kstat_irqs on node 0
[    0.030505]   alloc irq_desc for 21 on node 0
[    0.030507]   alloc kstat_irqs on node 0
[    0.030514]   alloc irq_desc for 22 on node 0
[    0.030516]   alloc kstat_irqs on node 0
[    0.030522]   alloc irq_desc for 23 on node 0
[    0.030524]   alloc kstat_irqs on node 0
[    0.000999] CPU: Unsupported number of siblings 16
[    0.030604] Brought up 4 CPUs
[    0.030612] sizeof(vma)=184 bytes
[    0.030614] sizeof(page)=56 bytes
[    0.030617] sizeof(inode)=616 bytes
[    0.030619] sizeof(dentry)=192 bytes
[    0.030622] sizeof(ext3inode)=832 bytes
[    0.030625] sizeof(buffer_head)=104 bytes
[    0.030627] sizeof(skbuff)=232 bytes
[    0.030630] sizeof(task_struct)=5776 bytes
[    0.030705] devtmpfs: initialized
[    0.049732] Grant table initialized
[    0.049732] NET: Registered protocol family 16
[    0.050023]   alloc irq_desc for 24 on node 0
[    0.050023]   alloc kstat_irqs on node 0
[    0.050055] PCI: Fatal: No config space access function found
[    0.056041] bio: create slab <bio-0> at 0
[    0.056056] ACPI: Interpreter disabled.
[    0.056056] xen_balloon: Initialising balloon driver.
[    0.057206] vgaarb: loaded
[    0.057206] PCI: System does not support PCI
[    0.057206] PCI: System does not support PCI
[    0.058024] NetLabel: Initializing
[    0.058028] NetLabel:  domain hash size = 128
[    0.058032] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.058050] NetLabel:  unlabeled traffic allowed by default
[    0.058231] Switching to clocksource xen
[    0.058242] pnp: PnP ACPI: disabled
[    0.064983] NET: Registered protocol family 2
[    0.065724] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.067725] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.069338] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.069527] TCP: Hash tables configured (established 524288 bind 65536)
[    0.069534] TCP reno registered
[    0.069735] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.070086] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    0.070377] NET: Registered protocol family 1
[    0.070391] PCI: CLS 0 bytes, default 64
[    0.070452] Unpacking initramfs...
[    0.093561] Freeing initrd memory: 18324k freed
[    0.098828] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.098844] Placing 64MB software IO TLB between ffff88000abfc000 - ffff88000ebfc000
[    0.098850] software IO TLB at phys 0xabfc000 - 0xebfc000
[    0.099483] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.102533] audit: initializing netlink socket (disabled)
[    0.102554] type=2000 audit(1338184539.000:1): initialized
[    0.119492] VFS: Disk quotas dquot_6.5.2
[    0.119601] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.119671] msgmni has been set to 32768
[    0.120289] alg: No test for stdrng (krng)
[    0.120461] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.121449] io scheduler noop registered (default)
[    0.153417]   alloc irq_desc for 25 on node 0
[    0.153420]   alloc kstat_irqs on node 0
[    0.154172] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.156832] loop: module loaded
[    0.157217]   alloc irq_desc for 26 on node 0
[    0.157221]   alloc kstat_irqs on node 0
[    0.158591]   alloc irq_desc for 27 on node 0
[    0.158594]   alloc kstat_irqs on node 0
[    0.160859]   alloc irq_desc for 28 on node 0
[    0.160862]   alloc kstat_irqs on node 0
[    0.164045]   alloc irq_desc for 29 on node 0
[    0.164049]   alloc kstat_irqs on node 0
[    0.167433]   alloc irq_desc for 30 on node 0
[    0.167437]   alloc kstat_irqs on node 0
[    0.170735]   alloc irq_desc for 31 on node 0
[    0.170738]   alloc kstat_irqs on node 0
[    0.175135]   alloc irq_desc for 32 on node 0
[    0.175139]   alloc kstat_irqs on node 0
[    0.178564]   alloc irq_desc for 33 on node 0
[    0.178569]   alloc kstat_irqs on node 0
[    0.182198]   alloc irq_desc for 34 on node 0
[    0.182203]   alloc kstat_irqs on node 0
[    0.184058] Initialising Xen virtual ethernet driver.
[    0.185857] blkfront: regular deviceid=0x801 major,minor=8,1, assuming parts/disk=16
[    0.188580] blkfront: regular deviceid=0x855 major,minor=8,85, assuming parts/disk=16
[    0.189479] PNP: No PS/2 controller found. Probing ports directly.
[    0.190535] mice: PS/2 mouse device common for all mice
[    0.190634] cpuidle: using governor ladder
[    0.190640] cpuidle: using governor menu
[    0.190715] TCP cubic registered
[    0.190722] NET: Registered protocol family 17
[    0.190842] blkfront: regular deviceid=0x856 major,minor=8,86, assuming parts/disk=16
[    0.191095] registered taskstats version 1
[    0.191761] blkfront: regular deviceid=0x857 major,minor=8,87, assuming parts/disk=16
[    0.192561] blkfront: regular deviceid=0x858 major,minor=8,88, assuming parts/disk=16
[    0.193397] blkfront: regular deviceid=0x851 major,minor=8,81, assuming parts/disk=16
[    0.194274] blkfront: regular deviceid=0x852 major,minor=8,82, assuming parts/disk=16
[    0.195039] blkfront: regular deviceid=0x853 major,minor=8,83, assuming parts/disk=16
[    0.195888] blkfront: regular deviceid=0x854 major,minor=8,84, assuming parts/disk=16
[    0.196588]   alloc irq_desc for 35 on node 0
[    0.196591]   alloc kstat_irqs on node 0
[    0.291074] XENBUS: Device with no driver: device/console/0
[    0.291315] Freeing unused kernel memory: 500k freed
[    0.291457] Write protecting the kernel read-only data: 6144k
[    0.294260] Freeing unused kernel memory: 872k freed
[    0.294770] Freeing unused kernel memory: 772k freed
[    0.338850] device-mapper: uevent: version 1.0.3
[    0.339070] device-mapper: ioctl: 4.19.1-ioctl (2010-10-12) initialised: dm-devel@redhat.com
[    0.347400] udev: starting version 147
[    0.464874] md: bind<xvdf8>
[    0.474746] md: bind<xvdf7>
[    0.482043] md: bind<xvdf4>
[    0.540137] md: bind<xvdf3>
[    0.548545] md: bind<xvdf5>
[    0.558959] md: bind<xvdf2>
[    0.590210] md: bind<xvdf6>
[    0.605807] md: bind<xvdf1>
[    0.617615] md: raid10 personality registered for level 10
[    0.617973] md/raid10:md127: active with 8 out of 8 devices
[    0.618052] md127: detected capacity change from 0 to 42944430080
[    0.619764]  md127: unknown partition table
[    0.853476] dracut: Scanning devices md127  for LVM volume groups 
[    0.952821] dracut: Reading all physical volumes. This may take a while...
[    0.952917] dracut: Found volume group "lvm" using metadata type lvm2
[    1.001982] dracut: /dev/mapper/lvm-mysql not set up by udev: Falling back to direct node creation.
[    1.002490] dracut: The link /dev/lvm/mysql should had been created by udev but it was not found. Falling back to direct link creation.
[    1.002901] dracut: 1 logical volume(s) in volume group "lvm" now active
[    1.009194] dracut: Assembling MD RAID arrays
[    1.522720] EXT4-fs (xvda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.714045] dracut: Remounting /dev/disk/by-label/\x2f with -o noatime,ro
[    1.724168] EXT4-fs (xvda1): mounted filesystem with ordered data mode. Opts: (null)
[    1.731079] dracut: Mounted root filesystem /dev/xvda1
[    2.074312] dracut: Loading SELinux policy
[    4.435236] dracut: /sbin/load_policy: Can't load policy: No such device
[    4.497683] dracut: Switching root
[    7.536918] usbcore: registered new interface driver usbfs
[    7.537147] usbcore: registered new interface driver hub
[    7.537356] usbcore: registered new device driver usb
[    9.689524] udev: starting version 147
[   10.573499] rtc_cmos: probe of rtc_cmos failed with error -16
[   15.475706] EXT4-fs (xvda1): re-mounted. Opts: (null)
[   15.887250] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   15.889278] SGI XFS Quota Management subsystem
[   15.893832] XFS mounting filesystem dm-0
[   16.415440] Ending clean XFS mount for filesystem: dm-0
[   16.927608] Adding 1048572k swap on /.swapfile.  Priority:-1 extents:4 across:1073148k SS


--
Regards,
Jason Stubbs
