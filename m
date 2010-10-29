Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab0J2Pws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:52:48 -0400
Received: from tamade.ascient.net ([65.99.219.195]:54745 "EHLO
	tamade.ascient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0J2Pwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:52:47 -0400
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 11:52:46 EDT
Message-ID: <4CCAEB23.9040207@cmu.edu>
Date: Fri, 29 Oct 2010 11:41:23 -0400
From: Michael Stroucken <mxs@cmu.edu>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Deadlock on 2.6.32.22 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We have a cluster of nodes with dual E5450s, 16 GB RAM, 4 Seagate 
Barracuda ES2 SATA disks, XFS file system, MPTSAS chip, 2.6.32.22. They 
are used as Hadoop compute nodes.

One of our researchers was sequentially going through the machines and 
executing the command
echo 3 >/proc/sys/vm/drop_caches;sync
to flush the caches, and two-thirds of the machines were deadlocked on 
the CPU that executed the command.

I managed to pull data from magic sysrq, a cutout follows. From my view 
it looks like CPU1 ran the cache flush command and was trying to obtain 
a lock within xfs_inode_ag_walk, while a Hadoop java process apparently 
held the lock from within an xfs_read.

I wasn't able to trigger this through a generated workload, so I suspect 
the system must have been rather active for this situation to develop. I 
would be grateful for helpful comments and fixes, and I can provide the 
full sysrq dumps if needed.

Greetings,
Michael.

[1516326.770009] NMI backtrace for cpu 1
[1516326.770009] CPU 1:
[1516326.770009] Modules linked in: xfs exportfs w83627hf_wdt nfs lockd 
nfs_acl auth_rpcgss sunrpc fuse coretemp w83627ehf w83793 hwmon_vid 
i5k_amb serio_raw tpm_tis tpm_infineon netxen_nic i5400_edac pcspkr tpm 
i2c_i801 edac_core tpm_bios mptsas mptscsih mptbase ehci_hcd uhci_hcd 
scsi_transport_sas e1000e floppy [last unloaded: scsi_wait_scan]
[1516326.770009] Pid: 12262, comm: bash Tainted: G        W  
2.6.32.22-stroucki #1 empty
[1516326.770009] RIP: 0010:[<ffffffff8125fa1b>]  [<ffffffff8125fa1b>] 
_raw_write_trylock+0xb/0x40
[1516326.770009] RSP: 0018:ffff8800257d7cd8  EFLAGS: 00000246
[1516326.770009] RAX: 0000000000000001 RBX: ffff880428887e48 RCX: 
00056317565ac527
[1516326.770009] RDX: 0000000000000003 RSI: 00056317565ac527 RDI: 
ffff880428887e48
[1516326.770009] RBP: ffff8800257d7cd8 R08: 0000000000000000 R09: 
0000000000000000
[1516326.770009] R10: 0000000000000002 R11: 0000000000000002 R12: 
ffff880428887e60
[1516326.770009] R13: ffff880428887e48 R14: 0000000000000001 R15: 
0000000000000000
[1516326.770009] FS:  00007f8ae874e6e0(0000) GS:ffff880042800000(0000) 
knlGS:0000000000000000
[1516326.770009] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[1516326.770009] CR2: 0000000040a35f98 CR3: 00000002ccdca000 CR4: 
00000000000406e0
[1516326.770009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[1516326.770009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[1516326.770009] Call Trace:
[1516326.770009]  <#DB[1]>  <<EOE>> Pid: 12262, comm: bash Tainted: 
G        W  2.6.32.22-stroucki #1
[1516326.770009] Call Trace:
[1516326.770009]  <NMI>  [<ffffffff810110b4>] ? show_regs+0x44/0x50
[1516326.770009]  [<ffffffff81450b35>] nmi_watchdog_tick+0x1e5/0x210
[1516326.770009]  [<ffffffff81450061>] do_nmi+0x191/0x2c0
[1516326.770009]  [<ffffffff8144f930>] nmi+0x20/0x30
[1516326.770009]  [<ffffffff8125fa1b>] ? _raw_write_trylock+0xb/0x40
[1516326.770009]  <<EOE>>  [<ffffffff8144efa9>] _write_lock+0x39/0x70
[1516326.770009]  [<ffffffffa0268368>] ? xfs_inode_ag_walk+0x58/0x140 [xfs]
[1516326.770009]  [<ffffffff8144e9c6>] ? _write_unlock+0x26/0x30
[1516326.770009]  [<ffffffffa0268368>] xfs_inode_ag_walk+0x58/0x140 [xfs]
[1516326.770009]  [<ffffffffa02676f0>] ? xfs_reclaim_inode+0x0/0x130 [xfs]
[1516326.770009]  [<ffffffffa02684df>] xfs_inode_ag_iterator+0x8f/0xd0 [xfs]
[1516326.770009]  [<ffffffffa02676f0>] ? xfs_reclaim_inode+0x0/0x130 [xfs]
[1516326.770009]  [<ffffffffa0268616>] 
xfs_reclaim_inode_shrink+0xf6/0x140 [xfs]
[1516326.770009]  [<ffffffff810f1bfa>] shrink_slab+0x13a/0x190
[1516326.770009]  [<ffffffff81149664>] drop_caches_sysctl_handler+0x44/0x1d0
[1516326.770009]  [<ffffffff81185e48>] proc_sys_call_handler+0xb8/0xd0
[1516326.770009]  [<ffffffff81185e6f>] proc_sys_write+0xf/0x20
[1516326.770009]  [<ffffffff8112602b>] vfs_write+0xcb/0x1a0
[1516326.770009]  [<ffffffff811261f0>] sys_write+0x50/0x90
[1516326.770009]  [<ffffffff81012042>] system_call_fastpath+0x16/0x1b
[1516379.970194] SysRq : Show Blocked State
[1516379.980026]   task                        PC stack   pid father
[1516379.980026] java          D 0000000000000000     0   302      1 
0x00000000
[1516379.980026]  ffff880147313b98 0000000000000046 0000000000000000 
ffffffff810900dd
[1516379.980026]  000000000000fa08 ffff880147313fd8 ffff880400cea300 
ffff88043f910000
[1516379.980026]  ffff880400cea6b0 0000000109095ac0 ffff880428f92280 
ffff88004300fa08
[1516379.980026] Call Trace:
[1516379.980026]  [<ffffffff810900dd>] ? lock_release_holdtime+0x3d/0x1b0
[1516379.980026]  [<ffffffff8144eb36>] ? _spin_unlock_irq+0x26/0x40
[1516379.980026]  [<ffffffff8144c01d>] io_schedule+0x4d/0x70
[1516379.980026]  [<ffffffff810e421d>] sync_page+0x3d/0x70
[1516379.980026]  [<ffffffff810e4259>] sync_page_killable+0x9/0x40
[1516379.980026]  [<ffffffff8144c4b2>] __wait_on_bit_lock+0x52/0xb0
[1516379.980026]  [<ffffffff810e4250>] ? sync_page_killable+0x0/0x40
[1516379.980026]  [<ffffffff810e4154>] __lock_page_killable+0x64/0x70
[1516379.980026]  [<ffffffff8107c380>] ? wake_bit_function+0x0/0x40
[1516379.980026]  [<ffffffff810e5388>] generic_file_aio_read+0x3d8/0x6b0
[1516379.980026]  [<ffffffffa023b105>] ? xfs_ilock+0x75/0xb0 [xfs]
[1516379.980026]  [<ffffffffa0264f47>] xfs_read+0x127/0x2a0 [xfs]
[1516379.980026]  [<ffffffffa026057b>] xfs_file_aio_read+0x5b/0x70 [xfs]
[1516379.980026]  [<ffffffff81125ac1>] do_sync_read+0xf1/0x140
[1516381.450638]  [<ffffffff81081ba5>] ? sched_clock_local+0x25/0x90
[1516381.450638]  [<ffffffff8107c340>] ? autoremove_wake_function+0x0/0x40
[1516381.450638]  [<ffffffff81081cd8>] ? sched_clock_cpu+0xc8/0x110
[1516381.450638]  [<ffffffff810900dd>] ? lock_release_holdtime+0x3d/0x1b0
[1516381.450638]  [<ffffffff81217df1>] ? security_file_permission+0x11/0x20
[1516381.450638]  [<ffffffff811262f8>] vfs_read+0xc8/0x1a0
[1516381.450638]  [<ffffffff811264c0>] sys_read+0x50/0x90
[1516381.450638]  [<ffffffff81012042>] system_call_fastpath+0x16/0x1b
[1516381.450638] Sched Debug Version: v0.09, 2.6.32.22-stroucki #1
[1516381.450638] now at 1516382061.544529 msecs
[1516381.450638]   .jiffies                                 : 4446575514
[1516381.450638]   .sysctl_sched_latency                    : 20.000000
[1516381.450638]   .sysctl_sched_min_granularity            : 4.000000
[1516381.450638]   .sysctl_sched_wakeup_granularity         : 4.000000
[1516381.450638]   .sysctl_sched_child_runs_first           : 0.000000
[1516381.450638]   .sysctl_sched_features                   : 15834235
[1516381.450638]
[1516381.450638] cpu#0, 2991.861 MHz
[1516381.450638]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_switches                   : 186607309
[1516382.750262]   .nr_load_updates               : 99638117
[1516382.750262]   .nr_uninterruptible            : 0
[1516382.750262]   .next_balance                  : 4446.575596
[1516382.750262]   .curr->pid                     : 0
[1516382.750262]   .clock                         : 1516383100.041665
[1516382.750262]   .cpu_load[0]                   : 655
[1516382.750262]   .cpu_load[1]                   : 407
[1516382.750262]   .cpu_load[2]                   : 394
[1516382.750262]   .cpu_load[3]                   : 438
[1516382.750262]   .cpu_load[4]                   : 392
[1516382.750262]   .yld_count                     : 666899837
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 823697096
[1516382.750262]   .sched_goidle                  : 74119568
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 80377304
[1516382.750262]   .ttwu_local                    : 52007187
[1516382.750262]   .bkl_count                     : 113
[1516382.750262]
[1516382.750262] cfs_rq[0]:/
[1516382.750262]   .exec_clock                    : 80138366.446624
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 102913639.043871
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : 0.000000
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_spread_over                : 254
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[0]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262]
[1516382.750262] cpu#1, 2991.861 MHz
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_switches                   : 185629264
[1516382.750262]   .nr_load_updates               : 90579411
[1516382.750262]   .nr_uninterruptible            : 0
[1516382.750262]   .next_balance                  : 4446.575885
[1516382.750262]   .curr->pid                     : 12262
[1516382.750262]   .clock                         : 1516385790.003542
[1516382.750262]   .cpu_load[0]                   : 1024
[1516382.750262]   .cpu_load[1]                   : 1024
[1516382.750262]   .cpu_load[2]                   : 1024
[1516382.750262]   .cpu_load[3]                   : 1024
[1516382.750262]   .cpu_load[4]                   : 1024
[1516382.750262]   .yld_count                     : 709304662
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 860931436
[1516382.750262]   .sched_goidle                  : 71217984
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 78223050
[1516382.750262]   .ttwu_local                    : 49210025
[1516382.750262]   .bkl_count                     : 88
[1516382.750262]
[1516382.750262] cfs_rq[1]:/
[1516382.750262]   .exec_clock                    : 82291207.016571
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 109810987.303988
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : 6897348.260117
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_spread_over                : 345
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[1]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262] R           bash 12262 109812197.295213     92300   120 
109812257.292769  61174639.738334     31135.096456 /
[1516382.750262]
[1516382.750262] cpu#2, 2991.861 MHz
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 655
[1516382.750262]   .nr_switches                   : 161056880
[1516382.750262]   .nr_load_updates               : 76985334
[1516382.750262]   .nr_uninterruptible            : 1
[1516382.750262]   .next_balance                  : 4446.575979
[1516382.750262]   .curr->pid                     : 29232
[1516382.750262]   .clock                         : 1516386820.549235
[1516382.750262]   .cpu_load[0]                   : 655
[1516382.750262]   .cpu_load[1]                   : 539
[1516382.750262]   .cpu_load[2]                   : 423
[1516382.750262]   .cpu_load[3]                   : 317
[1516382.750262]   .cpu_load[4]                   : 249
[1516382.750262]   .yld_count                     : 650761988
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 777667231
[1516382.750262]   .sched_goidle                  : 59146983
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 63221061
[1516382.750262]   .ttwu_local                    : 34839792
[1516382.750262]   .bkl_count                     : 16
[1516382.750262]
[1516382.750262] cfs_rq[2]:/
[1516382.750262]   .exec_clock                    : 79854326.759390
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 131883605.062434
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : 28969966.018563
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 655
[1516382.750262]   .nr_spread_over                : 147
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[2]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262] R           java 29232 131883605.062434         7   122 
131883605.062434         0.529675     10009.216962 /
[1516382.750262]
[1516382.750262] cpu#3, 2991.861 MHz
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_switches                   : 168118464
[1516382.750262]   .nr_load_updates               : 76390561
[1516382.750262]   .nr_uninterruptible            : 0
[1516382.750262]   .next_balance                  : 4446.576426
[1516382.750262]   .curr->pid                     : 0
[1516382.750262]   .clock                         : 1516391410.004689
[1516382.750262]   .cpu_load[0]                   : 0
[1516382.750262]   .cpu_load[1]                   : 0
[1516382.750262]   .cpu_load[2]                   : 0
[1516382.750262]   .cpu_load[3]                   : 0
[1516382.750262]   .cpu_load[4]                   : 0
[1516382.750262]   .yld_count                     : 696919182
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 828916938
[1516382.750262]   .sched_goidle                  : 61643137
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 65809371
[1516382.750262]   .ttwu_local                    : 36675810
[1516382.750262]   .bkl_count                     : 25
[1516382.750262]
[1516382.750262] cfs_rq[3]:/
[1516382.750262]   .exec_clock                    : 63056200.070034
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 114499303.327543
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : 11585664.283672
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_spread_over                : 187
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[3]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262]
[1516382.750262] cpu#4, 2991.861 MHz
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_switches                   : 194777471
[1516382.750262]   .nr_load_updates               : 104619506
[1516382.750262]   .nr_uninterruptible            : 0
[1516382.750262]   .next_balance                  : 4446.575293
[1516382.750262]   .curr->pid                     : 28691
[1516382.750262]   .clock                         : 1516382750.262090
[1516382.750262]   .cpu_load[0]                   : 1024
[1516382.750262]   .cpu_load[1]                   : 620
[1516382.750262]   .cpu_load[2]                   : 448
[1516382.750262]   .cpu_load[3]                   : 352
[1516382.750262]   .cpu_load[4]                   : 297
[1516382.750262]   .yld_count                     : 664119533
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 828355292
[1516382.750262]   .sched_goidle                  : 77311701
[1516382.750262]   .avg_idle                      : 875872
[1516382.750262]   .ttwu_count                    : 84830000
[1516382.750262]   .ttwu_local                    : 56321519
[1516382.750262]   .bkl_count                     : 34
[1516382.750262]
[1516382.750262] cfs_rq[4]:/
[1516382.750262]   .exec_clock                    : 45215074.563758
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 55511814.658518
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : -47401824.385353
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_spread_over                : 194
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[4]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262] R           bash 28691  55511814.658518       215   
120  55511814.658518     16874.426555     86172.353505 /
[1516382.750262]
[1516382.750262] cpu#5, 2991.861 MHz
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_switches                   : 195773027
[1516382.750262]   .nr_load_updates               : 99867760
[1516382.750262]   .nr_uninterruptible            : 1
[1516382.750262]   .next_balance                  : 4446.575442
[1516382.750262]   .curr->pid                     : 3140
[1516382.750262]   .clock                         : 1516386820.045969
[1516382.750262]   .cpu_load[0]                   : 0
[1516382.750262]   .cpu_load[1]                   : 22
[1516382.750262]   .cpu_load[2]                   : 99
[1516382.750262]   .cpu_load[3]                   : 214
[1516382.750262]   .cpu_load[4]                   : 323
[1516382.750262]   .yld_count                     : 706800176
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 868529449
[1516382.750262]   .sched_goidle                  : 76104494
[1516382.750262]   .avg_idle                      : 345519
[1516382.750262]   .ttwu_count                    : 83638850
[1516382.750262]   .ttwu_local                    : 54668276
[1516382.750262]   .bkl_count                     : 98
[1516382.750262]
[1516382.750262] cfs_rq[5]:/
[1516382.750262]   .exec_clock                    : 71717173.001946
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 95048111.511591
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : -7865527.532280
[1516382.750262]   .nr_running                    : 1
[1516382.750262]   .load                          : 1024
[1516382.750262]   .nr_spread_over                : 272
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[5]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262] R         python  3140  95048111.511591   8118157   
120  95048111.511591   2941194.325021 1513336175.027081 /
[1516382.750262]
[1516382.750262] cpu#6, 2991.861 MHz
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_switches                   : 174295130
[1516382.750262]   .nr_load_updates               : 95731019
[1516382.750262]   .nr_uninterruptible            : 0
[1516382.750262]   .next_balance                  : 4446.577254
[1516382.750262]   .curr->pid                     : 0
[1516382.750262]   .clock                         : 1516399690.003762
[1516382.750262]   .cpu_load[0]                   : 0
[1516382.750262]   .cpu_load[1]                   : 41
[1516382.750262]   .cpu_load[2]                   : 83
[1516382.750262]   .cpu_load[3]                   : 97
[1516382.750262]   .cpu_load[4]                   : 100
[1516382.750262]   .yld_count                     : 646603624
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 789057762
[1516382.750262]   .sched_goidle                  : 66548847
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 71206934
[1516382.750262]   .ttwu_local                    : 43550028
[1516382.750262]   .bkl_count                     : 14
[1516382.750262]
[1516382.750262] cfs_rq[6]:/
[1516382.750262]   .exec_clock                    : 54421217.387678
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 101993512.182643
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : -920126.861228
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_spread_over                : 138
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[6]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262]
[1516382.750262] cpu#7, 2991.861 MHz
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_switches                   : 188638606
[1516382.750262]   .nr_load_updates               : 95225995
[1516382.750262]   .nr_uninterruptible            : 3
[1516382.750262]   .next_balance                  : 4446.577520
[1516382.750262]   .curr->pid                     : 0
[1516382.750262]   .clock                         : 1516402350.002834
[1516382.750262]   .cpu_load[0]                   : 0
[1516382.750262]   .cpu_load[1]                   : 0
[1516382.750262]   .cpu_load[2]                   : 0
[1516382.750262]   .cpu_load[3]                   : 0
[1516382.750262]   .cpu_load[4]                   : 0
[1516382.750262]   .yld_count                     : 698668026
[1516382.750262]   .sched_switch                  : 0
[1516382.750262]   .sched_count                   : 850356210
[1516382.750262]   .sched_goidle                  : 71044561
[1516382.750262]   .avg_idle                      : 1000000
[1516382.750262]   .ttwu_count                    : 75989616
[1516382.750262]   .ttwu_local                    : 46567083
[1516382.750262]   .bkl_count                     : 54
[1516382.750262]
[1516382.750262] cfs_rq[7]:/
[1516382.750262]   .exec_clock                    : 39411091.207655
[1516382.750262]   .MIN_vruntime                  : 0.000001
[1516382.750262]   .min_vruntime                  : 80422949.840868
[1516382.750262]   .max_vruntime                  : 0.000001
[1516382.750262]   .spread                        : 0.000000
[1516382.750262]   .spread0                       : -22490689.203003
[1516382.750262]   .nr_running                    : 0
[1516382.750262]   .load                          : 0
[1516382.750262]   .nr_spread_over                : 131
[1516382.750262]   .shares                        : 0
[1516382.750262]
[1516382.750262] rt_rq[7]:/
[1516382.750262]   .rt_nr_running                 : 0
[1516382.750262]   .rt_throttled                  : 0
[1516382.750262]   .rt_time                       : 0.000000
[1516382.750262]   .rt_runtime                    : 950.000000
[1516382.750262]
[1516382.750262] runnable tasks:
[1516382.750262]             task   PID         tree-key  switches  
prio     exec-runtime         sum-exec        sum-sleep
[1516382.750262] 
----------------------------------------------------------------------------------------------------------
[1516382.750262]
