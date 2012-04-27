Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2D0PXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:23:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39095 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2D0PXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:23:45 -0400
Date: Fri, 27 Apr 2012 08:23:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: Re: async pf: INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order
 detected
Message-ID: <20120427152323.GB2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcPSCA+iNdMETZMhXpmGaVkC2ACCJZAt4CSBkaoVwVvGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042715-5806-0000-0000-000014AD924A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:50:35PM +0200, Sasha Levin wrote:
> Hi all.
> 
> I got a "INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected" warning
> while running LTP inside a KVM guest using the recent -next kernel.
> 
> It seems that it was initially originated from rcu_torture_rea(), but I
> don't think that it's a problem with RCU itself (I'll cc. Paul just in
> case). RCU torture was indeed configured to run during the testing.

I might be missing something, but I don't see how RCU is involved in
this one.

							Thanx, Paul

> The output is attached since it's a bit long.
> 
> Thanks.

> [ 4248.579019] ======================================================
> [ 4248.579019] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> [ 4248.579019] 3.4.0-rc4-next-20120424-sasha #94 Tainted: G        W   
> [ 4248.579019] ------------------------------------------------------
> [ 4248.579019] rcu_torture_rea/1615 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [ 4248.579019]  (pgd_lock){+.+...}, at: [<ffffffff81089476>] pgd_free+0x26/0xa0
> [ 4248.579019] 
> [ 4248.579019] and this task is already holding:
> [ 4248.579019]  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
> [ 4248.579019] which would create a new lock dependency:
> [ 4248.579019]  (&(&async_pf_sleepers[i].lock)->rlock){..-...} -> (pgd_lock){+.+...}
> [ 4248.579019] 
> [ 4248.579019] but this new dependency connects a SOFTIRQ-irq-safe lock:
> [ 4248.579019]  (&(&async_pf_sleepers[i].lock)->rlock){..-...}
> [ 4248.579019] ... which became SOFTIRQ-irq-safe at:
> [ 4248.579019]   [<ffffffff8111ab85>] mark_irqflags+0x95/0x170
> [ 4248.579019]   [<ffffffff8111c56b>] __lock_acquire+0x2bb/0x4c0
> [ 4248.579019]   [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]   [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]   [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
> [ 4248.579019]   [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]   [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]   [<ffffffff8289b1ac>] call_softirq+0x1c/0x30
> [ 4248.579019]   [<ffffffff81050235>] do_softirq+0x75/0x120
> [ 4248.579019]   [<ffffffff810be1cb>] irq_exit+0x5b/0xf0
> [ 4248.579019]   [<ffffffff8107361a>] smp_apic_timer_interrupt+0x8a/0xa0
> [ 4248.579019]   [<ffffffff8289a7af>] apic_timer_interrupt+0x6f/0x80
> [ 4248.579019]   [<ffffffff8107d1be>] do_async_page_fault+0x5e/0xb0
> [ 4248.579019]   [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]   [<ffffffff811d7de8>] do_huge_pmd_wp_page+0x308/0x520
> [ 4248.579019]   [<ffffffff811a4e0c>] handle_mm_fault+0x25c/0x350
> [ 4248.579019]   [<ffffffff81085031>] do_page_fault+0x421/0x450
> [ 4248.579019]   [<ffffffff8107d191>] do_async_page_fault+0x31/0xb0
> [ 4248.579019]   [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019] 
> [ 4248.579019] to a SOFTIRQ-irq-unsafe lock:
> [ 4248.579019]  (pgd_lock){+.+...}
> [ 4248.579019] ... which became SOFTIRQ-irq-unsafe at:
> [ 4248.579019] ...  [<ffffffff8111ac00>] mark_irqflags+0x110/0x170
> [ 4248.579019]   [<ffffffff8111c56b>] __lock_acquire+0x2bb/0x4c0
> [ 4248.579019]   [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]   [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]   [<ffffffff81083061>] sync_global_pgds+0x61/0x1b0
> [ 4248.579019]   [<ffffffff81083d5d>] vmalloc_sync_all+0x1d/0x20
> [ 4248.579019]   [<ffffffff810e1a71>] register_die_notifier+0x11/0x30
> [ 4248.579019]   [<ffffffff83b93537>] init_uprobes+0x75/0x79
> [ 4248.579019]   [<ffffffff83b71629>] do_one_initcall+0x7a/0x155
> [ 4248.579019]   [<ffffffff83b717cb>] do_basic_setup+0x9c/0xba
> [ 4248.579019]   [<ffffffff83b71a42>] kernel_init+0x1fe/0x280
> [ 4248.579019]   [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019] 
> [ 4248.579019] other info that might help us debug this:
> [ 4248.579019] 
> [ 4248.579019]  Possible interrupt unsafe locking scenario:
> [ 4248.579019] 
> [ 4248.579019]        CPU0                    CPU1
> [ 4248.579019]        ----                    ----
> [ 4248.579019]   lock(pgd_lock);
> [ 4248.579019]                                local_irq_disable();
> [ 4248.579019]                                lock(&(&async_pf_sleepers[i].lock)->rlock);
> [ 4248.579019]                                lock(pgd_lock);
> [ 4248.579019]   <Interrupt>
> [ 4248.579019]     lock(&(&async_pf_sleepers[i].lock)->rlock);
> [ 4248.579019] 
> [ 4248.579019]  *** DEADLOCK ***
> [ 4248.579019] 
> [ 4248.579019] 1 lock held by rcu_torture_rea/1615:
> [ 4248.579019]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
> [ 4248.579019] 
> [ 4248.579019] the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
> [ 4248.579019] -> (&(&async_pf_sleepers[i].lock)->rlock){..-...} ops: 1556 {
> [ 4248.579019]    IN-SOFTIRQ-W at:
> [ 4248.579019]                                        [<ffffffff8111ab85>] mark_irqflags+0x95/0x170
> [ 4248.579019]                                        [<ffffffff8111c56b>] __lock_acquire+0x2bb/0x4c0
> [ 4248.579019]                                        [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]                                        [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]                                        [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
> [ 4248.579019]                                        [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]                                        [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]                                        [<ffffffff8289b1ac>] call_softirq+0x1c/0x30
> [ 4248.579019]                                        [<ffffffff81050235>] do_softirq+0x75/0x120
> [ 4248.579019]                                        [<ffffffff810be1cb>] irq_exit+0x5b/0xf0
> [ 4248.579019]                                        [<ffffffff8107361a>] smp_apic_timer_interrupt+0x8a/0xa0
> [ 4248.579019]                                        [<ffffffff8289a7af>] apic_timer_interrupt+0x6f/0x80
> [ 4248.579019]                                        [<ffffffff8107d1be>] do_async_page_fault+0x5e/0xb0
> [ 4248.579019]                                        [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]                                        [<ffffffff811d7de8>] do_huge_pmd_wp_page+0x308/0x520
> [ 4248.579019]                                        [<ffffffff811a4e0c>] handle_mm_fault+0x25c/0x350
> [ 4248.579019]                                        [<ffffffff81085031>] do_page_fault+0x421/0x450
> [ 4248.579019]                                        [<ffffffff8107d191>] do_async_page_fault+0x31/0xb0
> [ 4248.579019]                                        [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]    INITIAL USE at:
> [ 4248.579019]                                       [<ffffffff8111c595>] __lock_acquire+0x2e5/0x4c0
> [ 4248.579019]                                       [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]                                       [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]                                       [<ffffffff8107cb30>] apf_task_wake_all+0x20/0x80
> [ 4248.579019]                                       [<ffffffff8107cdb2>] kvm_async_pf_task_wake+0x32/0x130
> [ 4248.579019]                                       [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]                                       [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]                                       [<ffffffff83bb1f7a>] con_init+0x1b/0x23f
> [ 4248.579019]                                       [<ffffffff83bb168d>] console_init+0x19/0x2a
> [ 4248.579019]                                       [<ffffffff83b71fa2>] start_kernel+0x30c/0x3f8
> [ 4248.579019]                                       [<ffffffff83b71314>] x86_64_start_reservations+0xff/0x104
> [ 4248.579019]                                       [<ffffffff83b7146e>] x86_64_start_kernel+0x155/0x164
> [ 4248.579019]  }
> [ 4248.579019]  ... key      at: [<ffffffff83d3fc84>] __key.35787+0x0/0x8
> [ 4248.579019]  ... acquired at:
> [ 4248.579019]    [<ffffffff8111a43c>] check_usage+0x1ac/0x1d0
> [ 4248.579019]    [<ffffffff8111a4d1>] check_irq_usage+0x71/0xf0
> [ 4248.579019]    [<ffffffff8111b7bb>] check_prev_add+0x16b/0x4d0
> [ 4248.579019]    [<ffffffff8111c1be>] validate_chain+0x69e/0x790
> [ 4248.579019]    [<ffffffff8111c6d3>] __lock_acquire+0x423/0x4c0
> [ 4248.579019]    [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]    [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]    [<ffffffff81089476>] pgd_free+0x26/0xa0
> [ 4248.579019]    [<ffffffff810b4d81>] __mmdrop+0x31/0xf0
> [ 4248.579019]    [<ffffffff8107cacc>] apf_task_wake_one+0x4c/0x90
> [ 4248.579019]    [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
> [ 4248.579019]    [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]    [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]    [<ffffffff8289695e>] __schedule+0xce/0x880
> [ 4248.579019]    [<ffffffff82897275>] schedule+0x55/0x60
> [ 4248.579019]    [<ffffffff8115a3e2>] rcu_torture_reader+0x2a2/0x380
> [ 4248.579019]    [<ffffffff810dada2>] kthread+0xb2/0xc0
> [ 4248.579019]    [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019] 
> [ 4248.579019] 
> [ 4248.579019] the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
> [ 4248.579019] -> (pgd_lock){+.+...} ops: 2112935 {
> [ 4248.579019]    HARDIRQ-ON-W at:
> [ 4248.579019]                                        [<ffffffff8111abe0>] mark_irqflags+0xf0/0x170
> [ 4248.579019]                                        [<ffffffff8111c56b>] __lock_acquire+0x2bb/0x4c0
> [ 4248.579019]                                        [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]                                        [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]                                        [<ffffffff81083061>] sync_global_pgds+0x61/0x1b0
> [ 4248.579019]                                        [<ffffffff81083d5d>] vmalloc_sync_all+0x1d/0x20
> [ 4248.579019]                                        [<ffffffff810e1a71>] register_die_notifier+0x11/0x30
> [ 4248.579019]                                        [<ffffffff83b93537>] init_uprobes+0x75/0x79
> [ 4248.579019]                                        [<ffffffff83b71629>] do_one_initcall+0x7a/0x155
> [ 4248.579019]                                        [<ffffffff83b717cb>] do_basic_setup+0x9c/0xba
> [ 4248.579019]                                        [<ffffffff83b71a42>] kernel_init+0x1fe/0x280
> [ 4248.579019]                                        [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019]    SOFTIRQ-ON-W at:
> [ 4248.579019]                                        [<ffffffff8111ac00>] mark_irqflags+0x110/0x170
> [ 4248.579019]                                        [<ffffffff8111c56b>] __lock_acquire+0x2bb/0x4c0
> [ 4248.579019]                                        [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]                                        [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]                                        [<ffffffff81083061>] sync_global_pgds+0x61/0x1b0
> [ 4248.579019]                                        [<ffffffff81083d5d>] vmalloc_sync_all+0x1d/0x20
> [ 4248.579019]                                        [<ffffffff810e1a71>] register_die_notifier+0x11/0x30
> [ 4248.579019]                                        [<ffffffff83b93537>] init_uprobes+0x75/0x79
> [ 4248.579019]                                        [<ffffffff83b71629>] do_one_initcall+0x7a/0x155
> [ 4248.579019]                                        [<ffffffff83b717cb>] do_basic_setup+0x9c/0xba
> [ 4248.579019]                                        [<ffffffff83b71a42>] kernel_init+0x1fe/0x280
> [ 4248.579019]                                        [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019]    INITIAL USE at:
> [ 4248.579019]                                       [<ffffffff8111c595>] __lock_acquire+0x2e5/0x4c0
> [ 4248.579019]                                       [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]                                       [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]                                       [<ffffffff81085c15>] update_page_count+0x25/0x50
> [ 4248.579019]                                       [<ffffffff8289161c>] phys_pte_init+0x16d/0x180
> [ 4248.579019]                                       [<ffffffff82891b16>] phys_pmd_init+0x250/0x337
> [ 4248.579019]                                       [<ffffffff82891d5e>] phys_pud_init+0x161/0x3a4
> [ 4248.579019]                                       [<ffffffff8289208e>] kernel_physical_mapping_init+0xed/0x1d9
> [ 4248.579019]                                       [<ffffffff8284853b>] init_memory_mapping+0x38b/0x460
> [ 4248.579019]                                       [<ffffffff83b77d66>] setup_arch+0x691/0x815
> [ 4248.579019]                                       [<ffffffff83b71d8b>] start_kernel+0xf5/0x3f8
> [ 4248.579019]                                       [<ffffffff83b71314>] x86_64_start_reservations+0xff/0x104
> [ 4248.579019]                                       [<ffffffff83b7146e>] x86_64_start_kernel+0x155/0x164
> [ 4248.579019]  }
> [ 4248.579019]  ... key      at: [<ffffffff834356b8>] pgd_lock+0x18/0x50
> [ 4248.579019]  ... acquired at:
> [ 4248.579019]    [<ffffffff8111a43c>] check_usage+0x1ac/0x1d0
> [ 4248.579019]    [<ffffffff8111a4d1>] check_irq_usage+0x71/0xf0
> [ 4248.579019]    [<ffffffff8111b7bb>] check_prev_add+0x16b/0x4d0
> [ 4248.579019]    [<ffffffff8111c1be>] validate_chain+0x69e/0x790
> [ 4248.579019]    [<ffffffff8111c6d3>] __lock_acquire+0x423/0x4c0
> [ 4248.579019]    [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]    [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]    [<ffffffff81089476>] pgd_free+0x26/0xa0
> [ 4248.579019]    [<ffffffff810b4d81>] __mmdrop+0x31/0xf0
> [ 4248.579019]    [<ffffffff8107cacc>] apf_task_wake_one+0x4c/0x90
> [ 4248.579019]    [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
> [ 4248.579019]    [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]    [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]    [<ffffffff8289695e>] __schedule+0xce/0x880
> [ 4248.579019]    [<ffffffff82897275>] schedule+0x55/0x60
> [ 4248.579019]    [<ffffffff8115a3e2>] rcu_torture_reader+0x2a2/0x380
> [ 4248.579019]    [<ffffffff810dada2>] kthread+0xb2/0xc0
> [ 4248.579019]    [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019] 
> [ 4248.579019] 
> [ 4248.579019] stack backtrace:
> [ 4248.579019] Pid: 1615, comm: rcu_torture_rea Tainted: G        W    3.4.0-rc4-next-20120424-sasha #94
> [ 4248.579019] Call Trace:
> [ 4248.579019]  [<ffffffff81119a82>] print_bad_irq_dependency+0x2f2/0x310
> [ 4248.579019]  [<ffffffff8111a43c>] check_usage+0x1ac/0x1d0
> [ 4248.579019]  [<ffffffff8107e4a8>] ? pvclock_clocksource_read+0x58/0xd0
> [ 4248.579019]  [<ffffffff8111a4d1>] check_irq_usage+0x71/0xf0
> [ 4248.579019]  [<ffffffff8111b7bb>] check_prev_add+0x16b/0x4d0
> [ 4248.579019]  [<ffffffff8107d4d6>] ? kvm_clock_read+0x46/0x80
> [ 4248.579019]  [<ffffffff8111c1be>] validate_chain+0x69e/0x790
> [ 4248.579019]  [<ffffffff810f10a8>] ? sched_clock_cpu+0x108/0x120
> [ 4248.579019]  [<ffffffff8111c6d3>] __lock_acquire+0x423/0x4c0
> [ 4248.579019]  [<ffffffff8111c84c>] lock_acquire+0xdc/0x120
> [ 4248.579019]  [<ffffffff81089476>] ? pgd_free+0x26/0xa0
> [ 4248.579019]  [<ffffffff8289823b>] _raw_spin_lock+0x3b/0x70
> [ 4248.579019]  [<ffffffff81089476>] ? pgd_free+0x26/0xa0
> [ 4248.579019]  [<ffffffff81089476>] pgd_free+0x26/0xa0
> [ 4248.579019]  [<ffffffff810b4d81>] __mmdrop+0x31/0xf0
> [ 4248.579019]  [<ffffffff8107cacc>] apf_task_wake_one+0x4c/0x90
> [ 4248.579019]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
> [ 4248.579019]  [<ffffffff8107d1f6>] do_async_page_fault+0x96/0xb0
> [ 4248.579019]  [<ffffffff82899695>] async_page_fault+0x25/0x30
> [ 4248.579019]  [<ffffffff8111714d>] ? lock_is_held+0xfd/0x110
> [ 4248.579019]  [<ffffffff8289695e>] __schedule+0xce/0x880
> [ 4248.579019]  [<ffffffff82897275>] schedule+0x55/0x60
> [ 4248.579019]  [<ffffffff8115a3e2>] rcu_torture_reader+0x2a2/0x380
> [ 4248.579019]  [<ffffffff81158f20>] ? T.842+0x50/0x50
> [ 4248.579019]  [<ffffffff8115a140>] ? rcu_torture_read_unlock+0x60/0x60
> [ 4248.579019]  [<ffffffff810dada2>] kthread+0xb2/0xc0
> [ 4248.579019]  [<ffffffff8289b0b4>] kernel_thread_helper+0x4/0x10
> [ 4248.579019]  [<ffffffff810e820d>] ? finish_task_switch+0x8d/0x110
> [ 4248.579019]  [<ffffffff828993b4>] ? retint_restore_args+0x13/0x13
> [ 4248.579019]  [<ffffffff810dacf0>] ? __init_kthread_worker+0x70/0x70
> [ 4248.579019]  [<ffffffff8289b0b0>] ? gs_change+0x13/0x13

