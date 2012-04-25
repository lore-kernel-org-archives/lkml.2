Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2DYHfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 03:35:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26627 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2DYHfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 03:35:51 -0400
Message-ID: <1335339396.16988.80.camel@lappy>
Subject: blkcg: INFO: possible irq lock inversion dependency detected
From: Sasha Levin <sasha.levin@oracle.com>
To: tj@kernel.org, axboe@kernel.dk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        paulmck@linux.vnet.ibm.com
Date: Wed, 25 Apr 2012 09:36:36 +0200
Organization: Oracle
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got the following warning when booting the latest -next kernel:

[   14.019666] =========================================================
[   14.020011] [ INFO: possible irq lock inversion dependency detected ]
[   14.020011] 3.4.0-rc4-next-20120424-sasha #89 Tainted: G        W   
[   14.020011] ---------------------------------------------------------
[   14.020011] rcuc/0/7 just changed the state of lock:
[   14.020011]  (tg_stats_alloc_lock){+.....}, at: [<ffffffff818611ab>] throtl_pd_exit+0x3b/0x70
[   14.020011] but this lock was taken by another, HARDIRQ-safe lock in the past:
[   14.020011]  (&(&q->__queue_lock)->rlock){-.-...}
[   14.020011] 
[   14.020011] and interrupts could create inverse lock ordering between them.
[   14.020011] 
[   14.020011] 
[   14.020011] other info that might help us debug this:
[   14.020011] Chain exists of:
[   14.020011]   &(&q->__queue_lock)->rlock --> &(&blkcg->lock)->rlock --> tg_stats_alloc_lock
[   14.020011] 
[   14.020011]  Possible interrupt unsafe locking scenario:
[   14.020011] 
[   14.020011]        CPU0                    CPU1
[   14.020011]        ----                    ----
[   14.020011]   lock(tg_stats_alloc_lock);
[   14.020011]                                local_irq_disable();
[   14.020011]                                lock(&(&q->__queue_lock)->rlock);
[   14.020011]                                lock(&(&blkcg->lock)->rlock);
[   14.020011]   <Interrupt>
[   14.020011]     lock(&(&q->__queue_lock)->rlock);
[   14.020011] 
[   14.020011]  *** DEADLOCK ***
[   14.020011] 
[   14.020011] no locks held by rcuc/0/7.
[   14.020011] 
[   14.020011] the shortest dependencies between 2nd lock and 1st lock:
[   14.020011]   -> (&(&q->__queue_lock)->rlock){-.-...} ops: 260 {
[   14.020011]      IN-HARDIRQ-W at:
[   14.020011]                                            [<ffffffff8111696b>] mark_irqflags+0x6b/0x170
[   14.020011]                                            [<ffffffff8111837b>] __lock_acquire+0x2bb/0x4c0
[   14.020011]                                            [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.020011]                                            [<ffffffff8288f791>] _raw_spin_lock_irqsave+0x81/0xc0
[   14.020011]                                            [<ffffffff81c43bea>] ata_qc_schedule_eh+0x6a/0xa0
[   14.020011]                                            [<ffffffff81c37f39>] ata_qc_complete+0xa9/0x210
[   14.020011]                                            [<ffffffff81c4a4d8>] ata_hsm_qc_complete+0xf8/0x130
[   14.020011]                                            [<ffffffff81c4ae57>] ata_sff_hsm_move+0x547/0x570
[   14.020011]                                            [<ffffffff81c4b0bc>] __ata_sff_port_intr+0xcc/0xe0
[   14.020011]                                            [<ffffffff81c4b190>] ata_bmdma_port_intr+0xc0/0x120
[   14.020011]                                            [<ffffffff81c4b56f>] ata_bmdma_interrupt+0xaf/0x210
[   14.020011]                                            [<ffffffff8114e189>] handle_irq_event_percpu+0x39/0x190
[   14.020011]                                            [<ffffffff8114e323>] handle_irq_event+0x43/0x70
[   14.020011]                                            [<ffffffff811519b8>] handle_edge_irq+0xe8/0x120
[   14.020011]                                            [<ffffffff81050444>] handle_irq+0x164/0x180
[   14.020011]                                            [<ffffffff8104f638>] do_IRQ+0x58/0xd0
[   14.020011]                                            [<ffffffff828906af>] ret_from_intr+0x0/0x1a
[   14.020011]                                            [<ffffffff81c4aba3>] ata_sff_hsm_move+0x293/0x570
[   14.020011]                                            [<ffffffff81c4afde>] ata_sff_pio_task+0x15e/0x170
[   14.020011]                                            [<ffffffff810ce4d1>] process_one_work+0x291/0x440
[   14.020011]                                            [<ffffffff810d19b1>] worker_thread+0x211/0x3a0
[   14.020011]                                            [<ffffffff810d6c32>] kthread+0xb2/0xc0
[   14.020011]                                            [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.020011]      IN-SOFTIRQ-W at:
[   14.020011]                                            [<ffffffff81116995>] mark_irqflags+0x95/0x170
[   14.020011]                                            [<ffffffff8111837b>] __lock_acquire+0x2bb/0x4c0
[   14.020011]                                            [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.020011]                                            [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.020011]                                            [<ffffffff81bd5c3d>] scsi_device_unbusy+0x9d/0xd0
[   14.020011]                                            [<ffffffff81bcd929>] scsi_finish_command+0x39/0x120
[   14.106037]                                            [<ffffffff81bd645d>] scsi_softirq_done+0x13d/0x160
[   14.106037]                                            [<ffffffff8184f5d2>] blk_done_softirq+0xc2/0xe0
[   14.106037]                                            [<ffffffff810ba388>] __do_softirq+0xc8/0x1c0
[   14.106037]                                            [<ffffffff8289256c>] call_softirq+0x1c/0x30
[   14.106037]                                            [<ffffffff81050235>] do_softirq+0x75/0x120
[   14.106037]                                            [<ffffffff810ba04b>] irq_exit+0x5b/0xf0
[   14.106037]                                            [<ffffffff8104f68d>] do_IRQ+0xad/0xd0
[   14.106037]                                            [<ffffffff828906af>] ret_from_intr+0x0/0x1a
[   14.106037]                                            [<ffffffff81c4aba3>] ata_sff_hsm_move+0x293/0x570
[   14.106037]                                            [<ffffffff81c4afde>] ata_sff_pio_task+0x15e/0x170
[   14.106037]                                            [<ffffffff810ce4d1>] process_one_work+0x291/0x440
[   14.106037]                                            [<ffffffff810d19b1>] worker_thread+0x211/0x3a0
[   14.106037]                                            [<ffffffff810d6c32>] kthread+0xb2/0xc0
[   14.106037]                                            [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]      INITIAL USE at:
[   14.106037]                                           [<ffffffff811183a5>] __lock_acquire+0x2e5/0x4c0
[   14.106037]                                           [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]                                           [<ffffffff8288f831>] _raw_spin_lock_irq+0x61/0xa0
[   14.106037]                                           [<ffffffff81847f56>] blk_queue_bypass_start+0x16/0x90
[   14.106037]                                           [<ffffffff818603fb>] blkcg_activate_policy+0x3b/0x330
[   14.106037]                                           [<ffffffff818614dd>] blk_throtl_init+0xdd/0x100
[   14.106037]                                           [<ffffffff8185faa7>] blkcg_init_queue+0x27/0x30
[   14.106037]                                           [<ffffffff81847014>] blk_alloc_queue_node+0x254/0x290
[   14.106037]                                           [<ffffffff81848416>] blk_init_queue_node+0x26/0x70
[   14.106037]                                           [<ffffffff8184846e>] blk_init_queue+0xe/0x10
[   14.106037]                                           [<ffffffff83bbc267>] floppy_init+0x82/0x662
[   14.106037]                                           [<ffffffff83b77629>] do_one_initcall+0x7a/0x155
[   14.106037]                                           [<ffffffff83b777cb>] do_basic_setup+0x9c/0xba
[   14.106037]                                           [<ffffffff83b77a42>] kernel_init+0x1fe/0x280
[   14.106037]                                           [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]    }
[   14.106037]    ... key      at: [<ffffffff847e2ec0>] __key.43131+0x0/0x8
[   14.106037]    ... acquired at:
[   14.106037]    [<ffffffff81117fce>] validate_chain+0x69e/0x790
[   14.106037]    [<ffffffff811184e3>] __lock_acquire+0x423/0x4c0
[   14.106037]    [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]    [<ffffffff8288f791>] _raw_spin_lock_irqsave+0x81/0xc0
[   14.106037]    [<ffffffff818931d0>] __debug_check_no_obj_freed+0x70/0x1f0
[   14.106037]    [<ffffffff81893365>] debug_check_no_obj_freed+0x15/0x20
[   14.106037]    [<ffffffff811c87cf>] kmem_cache_free+0x12f/0x1f0
[   14.106037]    [<ffffffff8186de96>] ida_get_new_above+0x1e6/0x220
[   14.106037]    [<ffffffff8186e65c>] ida_simple_get+0xac/0x120
[   14.106037]    [<ffffffff81846e09>] blk_alloc_queue_node+0x49/0x290
[   14.106037]    [<ffffffff81848416>] blk_init_queue_node+0x26/0x70
[   14.106037]    [<ffffffff8184846e>] blk_init_queue+0xe/0x10
[   14.106037]    [<ffffffff83bbc267>] floppy_init+0x82/0x662
[   14.106037]    [<ffffffff83b77629>] do_one_initcall+0x7a/0x155
[   14.106037]    [<ffffffff83b777cb>] do_basic_setup+0x9c/0xba
[   14.106037]    [<ffffffff83b77a42>] kernel_init+0x1fe/0x280
[   14.106037]    [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037] 
[   14.106037]  -> (&(&blkcg->lock)->rlock){......} ops: 107 {
[   14.106037]     INITIAL USE at:
[   14.106037]                                         [<ffffffff811183a5>] __lock_acquire+0x2e5/0x4c0
[   14.106037]                                         [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]                                         [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]                                         [<ffffffff818602e2>] __blkg_lookup_create+0x132/0x210
[   14.106037]                                         [<ffffffff8186047f>] blkcg_activate_policy+0xbf/0x330
[   14.106037]                                         [<ffffffff818614dd>] blk_throtl_init+0xdd/0x100
[   14.106037]                                         [<ffffffff8185faa7>] blkcg_init_queue+0x27/0x30
[   14.106037]                                         [<ffffffff81847014>] blk_alloc_queue_node+0x254/0x290
[   14.106037]                                         [<ffffffff81848416>] blk_init_queue_node+0x26/0x70
[   14.106037]                                         [<ffffffff8184846e>] blk_init_queue+0xe/0x10
[   14.106037]                                         [<ffffffff83bbc267>] floppy_init+0x82/0x662
[   14.106037]                                         [<ffffffff83b77629>] do_one_initcall+0x7a/0x155
[   14.106037]                                         [<ffffffff83b777cb>] do_basic_setup+0x9c/0xba
[   14.106037]                                         [<ffffffff83b77a42>] kernel_init+0x1fe/0x280
[   14.106037]                                         [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]   }
[   14.106037]   ... key      at: [<ffffffff847e38d0>] __key.39904+0x0/0x8
[   14.106037]   ... acquired at:
[   14.106037]    [<ffffffff81117fce>] validate_chain+0x69e/0x790
[   14.106037]    [<ffffffff811184e3>] __lock_acquire+0x423/0x4c0
[   14.106037]    [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]    [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]    [<ffffffff8186135e>] throtl_pd_init+0x8e/0xd0
[   14.106037]    [<ffffffff81860643>] blkcg_activate_policy+0x283/0x330
[   14.106037]    [<ffffffff818614dd>] blk_throtl_init+0xdd/0x100
[   14.106037]    [<ffffffff8185faa7>] blkcg_init_queue+0x27/0x30
[   14.106037]    [<ffffffff81847014>] blk_alloc_queue_node+0x254/0x290
[   14.106037]    [<ffffffff81848416>] blk_init_queue_node+0x26/0x70
[   14.106037]    [<ffffffff8184846e>] blk_init_queue+0xe/0x10
[   14.106037]    [<ffffffff83bbc267>] floppy_init+0x82/0x662
[   14.106037]    [<ffffffff83b77629>] do_one_initcall+0x7a/0x155
[   14.106037]    [<ffffffff83b777cb>] do_basic_setup+0x9c/0xba
[   14.106037]    [<ffffffff83b77a42>] kernel_init+0x1fe/0x280
[   14.106037]    [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037] 
[   14.106037] -> (tg_stats_alloc_lock){+.....} ops: 107 {
[   14.106037]    HARDIRQ-ON-W at:
[   14.106037]                                        [<ffffffff811169f0>] mark_irqflags+0xf0/0x170
[   14.106037]                                        [<ffffffff8111837b>] __lock_acquire+0x2bb/0x4c0
[   14.106037]                                        [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]                                        [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]                                        [<ffffffff818611ab>] throtl_pd_exit+0x3b/0x70
[   14.106037]                                        [<ffffffff8185f6da>] blkg_free+0x4a/0x90
[   14.106037]                                        [<ffffffff8185f72d>] blkg_rcu_free+0xd/0x10
[   14.106037]                                        [<ffffffff81157d75>] rcu_do_batch+0x285/0x4e0
[   14.106037]                                        [<ffffffff811584f0>] rcu_cpu_kthread+0x250/0x290
[   14.106037]                                        [<ffffffff810d6c32>] kthread+0xb2/0xc0
[   14.106037]                                        [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]    INITIAL USE at:
[   14.106037]                                       [<ffffffff811183a5>] __lock_acquire+0x2e5/0x4c0
[   14.106037]                                       [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]                                       [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]                                       [<ffffffff8186135e>] throtl_pd_init+0x8e/0xd0
[   14.106037]                                       [<ffffffff81860643>] blkcg_activate_policy+0x283/0x330
[   14.106037]                                       [<ffffffff818614dd>] blk_throtl_init+0xdd/0x100
[   14.106037]                                       [<ffffffff8185faa7>] blkcg_init_queue+0x27/0x30
[   14.106037]                                       [<ffffffff81847014>] blk_alloc_queue_node+0x254/0x290
[   14.106037]                                       [<ffffffff81848416>] blk_init_queue_node+0x26/0x70
[   14.106037]                                       [<ffffffff8184846e>] blk_init_queue+0xe/0x10
[   14.106037]                                       [<ffffffff83bbc267>] floppy_init+0x82/0x662
[   14.106037]                                       [<ffffffff83b77629>] do_one_initcall+0x7a/0x155
[   14.106037]                                       [<ffffffff83b777cb>] do_basic_setup+0x9c/0xba
[   14.106037]                                       [<ffffffff83b77a42>] kernel_init+0x1fe/0x280
[   14.106037]                                       [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]  }
[   14.106037]  ... key      at: [<ffffffff83793a78>] tg_stats_alloc_lock+0x18/0x50
[   14.106037]  ... acquired at:
[   14.106037]    [<ffffffff81115a75>] check_usage_backwards+0xd5/0xf0
[   14.106037]    [<ffffffff81116583>] mark_lock_irq+0xf3/0x270
[   14.106037]    [<ffffffff8111681d>] mark_lock+0x11d/0x200
[   14.106037]    [<ffffffff811169f0>] mark_irqflags+0xf0/0x170
[   14.106037]    [<ffffffff8111837b>] __lock_acquire+0x2bb/0x4c0
[   14.106037]    [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]    [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]    [<ffffffff818611ab>] throtl_pd_exit+0x3b/0x70
[   14.106037]    [<ffffffff8185f6da>] blkg_free+0x4a/0x90
[   14.106037]    [<ffffffff8185f72d>] blkg_rcu_free+0xd/0x10
[   14.106037]    [<ffffffff81157d75>] rcu_do_batch+0x285/0x4e0
[   14.106037]    [<ffffffff811584f0>] rcu_cpu_kthread+0x250/0x290
[   14.106037]    [<ffffffff810d6c32>] kthread+0xb2/0xc0
[   14.106037]    [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037] 
[   14.106037] 
[   14.106037] stack backtrace:
[   14.106037] Pid: 7, comm: rcuc/0 Tainted: G        W    3.4.0-rc4-next-20120424-sasha #89
[   14.106037] Call Trace:
[   14.106037]  [<ffffffff81115583>] print_irq_inversion_bug+0x203/0x220
[   14.106037]  [<ffffffff81115a75>] check_usage_backwards+0xd5/0xf0
[   14.106037]  [<ffffffff8107e4a8>] ? pvclock_clocksource_read+0x58/0xd0
[   14.106037]  [<ffffffff811159a0>] ? check_usage_forwards+0xf0/0xf0
[   14.106037]  [<ffffffff81116583>] mark_lock_irq+0xf3/0x270
[   14.106037]  [<ffffffff8111681d>] mark_lock+0x11d/0x200
[   14.106037]  [<ffffffff811169f0>] mark_irqflags+0xf0/0x170
[   14.106037]  [<ffffffff8111837b>] __lock_acquire+0x2bb/0x4c0
[   14.106037]  [<ffffffff8111865c>] lock_acquire+0xdc/0x120
[   14.106037]  [<ffffffff818611ab>] ? throtl_pd_exit+0x3b/0x70
[   14.106037]  [<ffffffff8288f5fb>] _raw_spin_lock+0x3b/0x70
[   14.106037]  [<ffffffff818611ab>] ? throtl_pd_exit+0x3b/0x70
[   14.106037]  [<ffffffff81892e6f>] ? debug_object_deactivate+0xdf/0x140
[   14.106037]  [<ffffffff818611ab>] throtl_pd_exit+0x3b/0x70
[   14.106037]  [<ffffffff8185f6da>] blkg_free+0x4a/0x90
[   14.106037]  [<ffffffff8185f72d>] blkg_rcu_free+0xd/0x10
[   14.106037]  [<ffffffff81157d75>] rcu_do_batch+0x285/0x4e0
[   14.106037]  [<ffffffff811584f0>] rcu_cpu_kthread+0x250/0x290
[   14.106037]  [<ffffffff811582a0>] ? rcu_process_callbacks+0x80/0x80
[   14.106037]  [<ffffffff810d6c32>] kthread+0xb2/0xc0
[   14.106037]  [<ffffffff82892474>] kernel_thread_helper+0x4/0x10
[   14.106037]  [<ffffffff810e409d>] ? finish_task_switch+0x8d/0x110
[   14.106037]  [<ffffffff82890774>] ? retint_restore_args+0x13/0x13
[   14.106037]  [<ffffffff810d6b80>] ? __init_kthread_worker+0x70/0x70
[   14.106037]  [<ffffffff82892470>] ? gs_change+0x13/0x13

