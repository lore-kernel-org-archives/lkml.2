Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2D1VvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:51:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46554 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2D1VvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:51:19 -0400
Message-ID: <4F9C6653.9030407@gmail.com>
Date: Sat, 28 Apr 2012 14:51:15 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NEXT: INFO: possible irq lock inversion dependency detected
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is showing up with the current linux-next over here:

[    6.633932]
[    6.634261] =========================================================
[    6.634263] [ INFO: possible irq lock inversion dependency detected ]
[    6.634265] 3.4.0-rc4-next-20120427 #1 Not tainted
[    6.634266] ---------------------------------------------------------
[    6.634268] swapper/1/0 just changed the state of lock:
[    6.634270]  (tg_stats_alloc_lock){+.-...}, at: [<c1286da3>] 
throtl_pd_exit+0x23/0x60
[    6.634278] but this lock was taken by another, HARDIRQ-safe lock in 
the past:
[    6.634279]  (&(&q->__queue_lock)->rlock){-.-...}
[    6.634281]
[    6.634281] and interrupts could create inverse lock ordering between 
them.
[    6.634282]
[    6.634283]
[    6.634283] other info that might help us debug this:
[    6.634284] Chain exists of:
[    6.634285]   &(&q->__queue_lock)->rlock --> &(&blkcg->lock)->rlock 
--> tg_stats_alloc_lock
[    6.634287]
[    6.634288]  Possible interrupt unsafe locking scenario:
[    6.634288]
[    6.634289]        CPU0                    CPU1
[    6.634289]        ----                    ----
[    6.634290]   lock(tg_stats_alloc_lock);
[    6.634291]                                local_irq_disable();
[    6.634292] 
lock(&(&q->__queue_lock)->rlock);
[    6.634294]                                lock(&(&blkcg->lock)->rlock);
[    6.634295]   <Interrupt>
[    6.634296]     lock(&(&q->__queue_lock)->rlock);
[    6.634297]
[    6.634297]  *** DEADLOCK ***
[    6.634297]
[    6.634298] no locks held by swapper/1/0.
[    6.634299]
[    6.634300] the shortest dependencies between 2nd lock and 1st lock:
[    6.634306]   -> (&(&q->__queue_lock)->rlock){-.-...} ops: 7758 {
[    6.634308]      IN-HARDIRQ-W at:
[    6.634310]                                            [<c1098b6f>] 
__lock_acquire+0x90f/0x1660
[    6.634315]                                            [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634318]                                            [<c15180a7>] 
_raw_spin_lock_irqsave+0x57/0x70
[    6.634325]                                            [<c13a8b28>] 
ata_qc_schedule_eh+0x48/0x80
[    6.634332]                                            [<c139e9b0>] 
ata_qc_complete+0x180/0x1f0
[    6.634335]                                            [<c13a8293>] 
ata_do_link_abort+0x83/0xc0
[    6.634338]                                            [<c13a8b9f>] 
ata_port_abort+0xf/0x20
[    6.634341]                                            [<c13b70e5>] 
ahci_interrupt+0x425/0x640
[    6.634346]                                            [<c10be6cc>] 
handle_irq_event_percpu+0x4c/0x240
[    6.634351]                                            [<c10be8fa>] 
handle_irq_event+0x3a/0x60
[    6.634353]                                            [<c10c12e6>] 
handle_edge_irq+0x66/0xf0
[    6.634356]      IN-SOFTIRQ-W at:
[    6.634357]                                            [<c109875d>] 
__lock_acquire+0x4fd/0x1660
[    6.634359]                                            [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634361]                                            [<c15176d3>] 
_raw_spin_lock+0x43/0x50
[    6.634364]                                            [<c1379bb9>] 
scsi_device_unbusy+0x89/0xb0
[    6.634370]                                            [<c1370f5a>] 
scsi_finish_command+0x2a/0x100
[    6.634372]                                            [<c1379e28>] 
scsi_softirq_done+0x118/0x140
[    6.634374]                                            [<c1277d2b>] 
blk_done_softirq+0x6b/0x80
[    6.634378]                                            [<c1047599>] 
__do_softirq+0x99/0x1f0
[    6.634383]                                            [<c10477e7>] 
run_ksoftirqd+0xf7/0x1a0
[    6.634386]                                            [<c1060ccd>] 
kthread+0x7d/0x90
[    6.634390]                                            [<c151f7c2>] 
kernel_thread_helper+0x6/0x10
[    6.634394]      INITIAL USE at:
[    6.634395]                                           [<c10984c5>] 
__lock_acquire+0x265/0x1660
[    6.634398]                                           [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634401]                                           [<c1517eee>] 
_raw_spin_lock_irq+0x4e/0x60
[    6.634404]                                           [<c1272807>] 
blk_queue_bypass_start+0x17/0x80
[    6.634410]                                           [<c12864a0>] 
blkcg_activate_policy+0x40/0x260
[    6.634416]                                           [<c1288c27>] 
blk_throtl_init+0xb7/0xe0
[    6.634419]                                           [<c1286878>] 
blkcg_init_queue+0x28/0x30
[    6.634422]                                           [<c126e438>] 
blk_alloc_queue_node+0x1f8/0x240
[    6.634425]                                           [<c126e492>] 
blk_alloc_queue+0x12/0x20
[    6.634428]                                           [<c1368909>] 
brd_alloc+0x69/0x180
[    6.634434]                                           [<c17c59c2>] 
brd_init+0xb0/0x185
[    6.634440]                                           [<c1003034>] 
do_one_initcall+0x34/0x170
[    6.634443]                                           [<c1796b37>] 
kernel_init+0x111/0x1a6
[    6.634447]                                           [<c151f7c2>] 
kernel_thread_helper+0x6/0x10
[    6.634450]    }
[    6.634451]    ... key      at: [<c1d943ec>] __key.34385+0x0/0x8
[    6.634457]    ... acquired at:
[    6.634458]    [<c1099de0>] lock_acquire+0x80/0x120
[    6.634460]    [<c15180a7>] _raw_spin_lock_irqsave+0x57/0x70
[    6.634463]    [<c12912ab>] get_from_free_list+0x1b/0x50
[    6.634468]    [<c12916ad>] idr_get_empty_slot+0x26d/0x290
[    6.634471]    [<c1291739>] ida_get_new_above+0x69/0x230
[    6.634473]    [<c1292048>] ida_simple_get+0x58/0xe0
[    6.634476]    [<c126e27c>] blk_alloc_queue_node+0x3c/0x240
[    6.634478]    [<c126e492>] blk_alloc_queue+0x12/0x20
[    6.634481]    [<c1368909>] brd_alloc+0x69/0x180
[    6.634484]    [<c17c59c2>] brd_init+0xb0/0x185
[    6.634486]    [<c1003034>] do_one_initcall+0x34/0x170
[    6.634489]    [<c1796b37>] kernel_init+0x111/0x1a6
[    6.634491]    [<c151f7c2>] kernel_thread_helper+0x6/0x10
[    6.634494]
[    6.634495]  -> (&(&blkcg->lock)->rlock){......} ops: 89 {
[    6.634498]     INITIAL USE at:
[    6.634499]                                         [<c10984c5>] 
__lock_acquire+0x265/0x1660
[    6.634503]                                         [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634505]                                         [<c15176d3>] 
_raw_spin_lock+0x43/0x50
[    6.634508]                                         [<c128618c>] 
__blkg_lookup_create+0x17c/0x2a0
[    6.634512]                                         [<c12864f3>] 
blkcg_activate_policy+0x93/0x260
[    6.634515]                                         [<c1288c27>] 
blk_throtl_init+0xb7/0xe0
[    6.634517]                                         [<c1286878>] 
blkcg_init_queue+0x28/0x30
[    6.634520]                                         [<c126e438>] 
blk_alloc_queue_node+0x1f8/0x240
[    6.634523]                                         [<c126e492>] 
blk_alloc_queue+0x12/0x20
[    6.634526]                                         [<c1368909>] 
brd_alloc+0x69/0x180
[    6.634529]                                         [<c17c59c2>] 
brd_init+0xb0/0x185
[    6.634532]                                         [<c1003034>] 
do_one_initcall+0x34/0x170
[    6.634535]                                         [<c1796b37>] 
kernel_init+0x111/0x1a6
[    6.634538]                                         [<c151f7c2>] 
kernel_thread_helper+0x6/0x10
[    6.634540]   }
[    6.634541]   ... key      at: [<c1d949e8>] __key.29231+0x0/0x8
[    6.634543]   ... acquired at:
[    6.634544]    [<c1099de0>] lock_acquire+0x80/0x120
[    6.634546]    [<c15176d3>] _raw_spin_lock+0x43/0x50
[    6.634548]    [<c1286e5e>] throtl_pd_init+0x7e/0xc0
[    6.634550]    [<c128666b>] blkcg_activate_policy+0x20b/0x260
[    6.634552]    [<c1288c27>] blk_throtl_init+0xb7/0xe0
[    6.634553]    [<c1286878>] blkcg_init_queue+0x28/0x30
[    6.634555]    [<c126e438>] blk_alloc_queue_node+0x1f8/0x240
[    6.634557]    [<c126e492>] blk_alloc_queue+0x12/0x20
[    6.634559]    [<c1368909>] brd_alloc+0x69/0x180
[    6.634561]    [<c17c59c2>] brd_init+0xb0/0x185
[    6.634562]    [<c1003034>] do_one_initcall+0x34/0x170
[    6.634564]    [<c1796b37>] kernel_init+0x111/0x1a6
[    6.634565]    [<c151f7c2>] kernel_thread_helper+0x6/0x10
[    6.634567]
[    6.634568] -> (tg_stats_alloc_lock){+.-...} ops: 71 {
[    6.634570]    HARDIRQ-ON-W at:
[    6.634571]                                        [<c1098781>] 
__lock_acquire+0x521/0x1660
[    6.634573]                                        [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634575]                                        [<c15176d3>] 
_raw_spin_lock+0x43/0x50
[    6.634577]                                        [<c1286da3>] 
throtl_pd_exit+0x23/0x60
[    6.634579]                                        [<c128568b>] 
blkg_free+0x2b/0x60
[    6.634581]                                        [<c12856d0>] 
blkg_rcu_free+0x10/0x20
[    6.634583]                                        [<c10c4996>] 
__rcu_process_callbacks+0x1c6/0x430
[    6.634586]                                        [<c10c4c26>] 
rcu_process_callbacks+0x26/0xe0
[    6.634588]                                        [<c1047599>] 
__do_softirq+0x99/0x1f0
[    6.634591]    IN-SOFTIRQ-W at:
[    6.634592]                                        [<c109875d>] 
__lock_acquire+0x4fd/0x1660
[    6.634594]                                        [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634596]                                        [<c15176d3>] 
_raw_spin_lock+0x43/0x50
[    6.634598]                                        [<c1286da3>] 
throtl_pd_exit+0x23/0x60
[    6.634600]                                        [<c128568b>] 
blkg_free+0x2b/0x60
[    6.634602]                                        [<c12856d0>] 
blkg_rcu_free+0x10/0x20
[    6.634604]                                        [<c10c4996>] 
__rcu_process_callbacks+0x1c6/0x430
[    6.634606]                                        [<c10c4c26>] 
rcu_process_callbacks+0x26/0xe0
[    6.634608]                                        [<c1047599>] 
__do_softirq+0x99/0x1f0
[    6.634611]    INITIAL USE at:
[    6.634612]                                       [<c10984c5>] 
__lock_acquire+0x265/0x1660
[    6.634614]                                       [<c1099de0>] 
lock_acquire+0x80/0x120
[    6.634616]                                       [<c15176d3>] 
_raw_spin_lock+0x43/0x50
[    6.634618]                                       [<c1286e5e>] 
throtl_pd_init+0x7e/0xc0
[    6.634619]                                       [<c128666b>] 
blkcg_activate_policy+0x20b/0x260
[    6.634622]                                       [<c1288c27>] 
blk_throtl_init+0xb7/0xe0
[    6.634624]                                       [<c1286878>] 
blkcg_init_queue+0x28/0x30
[    6.634626]                                       [<c126e438>] 
blk_alloc_queue_node+0x1f8/0x240
[    6.634628]                                       [<c126e492>] 
blk_alloc_queue+0x12/0x20
[    6.634630]                                       [<c1368909>] 
brd_alloc+0x69/0x180
[    6.634632]                                       [<c17c59c2>] 
brd_init+0xb0/0x185
[    6.634634]                                       [<c1003034>] 
do_one_initcall+0x34/0x170
[    6.634636]                                       [<c1796b37>] 
kernel_init+0x111/0x1a6
[    6.634637]                                       [<c151f7c2>] 
kernel_thread_helper+0x6/0x10
[    6.634639]  }
[    6.634640]  ... key      at: [<c1762010>] tg_stats_alloc_lock+0x10/0x20
[    6.634644]  ... acquired at:
[    6.634645]    [<c10979b0>] check_usage_backwards+0xf0/0x130
[    6.634647]    [<c1098110>] mark_lock+0x130/0x280
[    6.634649]    [<c1098781>] __lock_acquire+0x521/0x1660
[    6.634651]    [<c1099de0>] lock_acquire+0x80/0x120
[    6.634653]    [<c15176d3>] _raw_spin_lock+0x43/0x50
[    6.634655]    [<c1286da3>] throtl_pd_exit+0x23/0x60
[    6.634657]    [<c128568b>] blkg_free+0x2b/0x60
[    6.634659]    [<c12856d0>] blkg_rcu_free+0x10/0x20
[    6.634661]    [<c10c4996>] __rcu_process_callbacks+0x1c6/0x430
[    6.634663]    [<c10c4c26>] rcu_process_callbacks+0x26/0xe0
[    6.634665]    [<c1047599>] __do_softirq+0x99/0x1f0
[    6.634666]
[    6.634667]
[    6.634667] stack backtrace:
[    6.634669] Pid: 0, comm: swapper/1 Not tainted 
3.4.0-rc4-next-20120427 #1
[    6.634671] Call Trace:
[    6.634674]  [<c150e0b4>] ? printk+0x1d/0x1f
[    6.634676]  [<c1097784>] print_irq_inversion_bug.part.36+0x1a4/0x1b0
[    6.634679]  [<c10979b0>] check_usage_backwards+0xf0/0x130
[    6.634681]  [<c1098110>] mark_lock+0x130/0x280
[    6.634682]  [<c10978c0>] ? check_usage_forwards+0x130/0x130
[    6.634685]  [<c1098781>] __lock_acquire+0x521/0x1660
[    6.634686]  [<c10984c5>] ? __lock_acquire+0x265/0x1660
[    6.634688]  [<c10984c5>] ? __lock_acquire+0x265/0x1660
[    6.634691]  [<c1099de0>] lock_acquire+0x80/0x120
[    6.634692]  [<c1286da3>] ? throtl_pd_exit+0x23/0x60
[    6.634695]  [<c15176d3>] _raw_spin_lock+0x43/0x50
[    6.634696]  [<c1286da3>] ? throtl_pd_exit+0x23/0x60
[    6.634698]  [<c1286da3>] throtl_pd_exit+0x23/0x60
[    6.634700]  [<c128568b>] blkg_free+0x2b/0x60
[    6.634702]  [<c12856d0>] blkg_rcu_free+0x10/0x20
[    6.634704]  [<c10c4996>] __rcu_process_callbacks+0x1c6/0x430
[    6.634706]  [<c1047500>] ? local_bh_enable_ip+0xd0/0xd0
[    6.634708]  [<c10c4c26>] rcu_process_callbacks+0x26/0xe0
[    6.634710]  [<c1047500>] ? local_bh_enable_ip+0xd0/0xd0
[    6.634712]  [<c1047599>] __do_softirq+0x99/0x1f0
[    6.634714]  [<c1047500>] ? local_bh_enable_ip+0xd0/0xd0
[    6.634715]  <IRQ>  [<c1047996>] ? irq_exit+0x86/0xb0
[    6.634718]  [<c151fa39>] ? smp_apic_timer_interrupt+0x59/0x88
[    6.634722]  [<c129c808>] ? trace_hardirqs_off_thunk+0xc/0x14
[    6.634724]  [<c15186b2>] ? apic_timer_interrupt+0x36/0x3c
[    6.634728]  [<c109007b>] ? timer_list_show+0x99b/0xec0
[    6.634733]  [<c12e3097>] ? intel_idle+0xc7/0x120
[    6.634736]  [<c1429545>] ? cpuidle_enter+0x15/0x20
[    6.634738]  [<c1429ada>] ? cpuidle_idle_call+0x8a/0x1e0
[    6.634741]  [<c10199bf>] ? cpu_idle+0xaf/0x100
[    6.634743]  [<c15073c0>] ? start_secondary+0x1f4/0x1fa
[   13.057885] EXT4-fs (sda6): mounted filesystem with ordered data 
mode. Opts: (null)

full dmesg here:
http://fpaste.org/IDFW/

Justin P. Mattock
