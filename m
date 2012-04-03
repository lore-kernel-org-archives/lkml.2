Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2DBWyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:54:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50008 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2DBWym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:54:42 -0400
Message-ID: <1333414472.11455.7.camel@lappy>
Subject: kvm: RCU warning in async pf
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Mon, 02 Apr 2012 20:54:32 -0400
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got the spew at the bottom of the mail in a KVM guest using the KVM tools and running trinity.

I'm not quite sure how default_idle managed to trigger a pagefault, so that part looks odd to me.

[12140.220507] ===============================
[12140.220507] [ INFO: suspicious RCU usage. ]
[12140.220507] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.220507] -------------------------------
[12140.220507] include/linux/rcupdate.h:729 rcu_read_lock() used illegally while idle!
[12140.220507] 
[12140.220507] other info that might help us debug this:
[12140.220507] 
[12140.220507] 
[12140.220507] RCU used illegally from idle CPU!
[12140.220507] rcu_scheduler_active = 1, debug_locks = 1
[12140.220507] RCU used illegally from extended quiescent state!
[12140.220507] 4 locks held by swapper/1/0:
[12140.253991]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.253991]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.253991]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.253991]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f3c80>] select_task_rq_fair+0xb0/0x5c0
[12140.253991] 
[12140.253991] stack backtrace:
[12140.253991] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.253991] Call Trace:
[12140.253991]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.253991]  [<ffffffff810f3ce5>] select_task_rq_fair+0x115/0x5c0
[12140.253991]  [<ffffffff810f3c80>] ? select_task_rq_fair+0xb0/0x5c0
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec561>] try_to_wake_up+0x191/0x290
[12140.253991]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.253991]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.253991]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.253991]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.253991]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.253991]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.253991]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.253991]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.253991]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.253991]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.253991]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.253991]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.253991]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.253991]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.253991]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.253991]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.253991] 
[12140.253991] ===============================
[12140.253991] [ INFO: suspicious RCU usage. ]
[12140.253991] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.253991] -------------------------------
[12140.253991] kernel/sched/fair.c:2716 suspicious rcu_dereference_check() usage!
[12140.253991] 
[12140.253991] other info that might help us debug this:
[12140.253991] 
[12140.253991] 
[12140.253991] RCU used illegally from idle CPU!
[12140.253991] rcu_scheduler_active = 1, debug_locks = 1
[12140.253991] RCU used illegally from extended quiescent state!
[12140.253991] 4 locks held by swapper/1/0:
[12140.253991]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.253991]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.253991]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.253991]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f3c80>] select_task_rq_fair+0xb0/0x5c0
[12140.253991] 
[12140.253991] stack backtrace:
[12140.253991] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.253991] Call Trace:
[12140.253991]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.253991]  [<ffffffff810f3d4c>] select_task_rq_fair+0x17c/0x5c0
[12140.253991]  [<ffffffff810f3c80>] ? select_task_rq_fair+0xb0/0x5c0
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec561>] try_to_wake_up+0x191/0x290
[12140.253991]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.253991]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.253991]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.253991]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.253991]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.253991]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.253991]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.253991]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.253991]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.253991]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.253991]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.253991]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.253991]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.253991]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.253991]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.253991]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.253991] 
[12140.253991] ===============================
[12140.253991] [ INFO: suspicious RCU usage. ]
[12140.253991] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.253991] -------------------------------
[12140.253991] kernel/sched/fair.c:2660 suspicious rcu_dereference_check() usage!
[12140.253991] 
[12140.253991] other info that might help us debug this:
[12140.253991] 
[12140.253991] 
[12140.253991] RCU used illegally from idle CPU!
[12140.253991] rcu_scheduler_active = 1, debug_locks = 1
[12140.253991] RCU used illegally from extended quiescent state!
[12140.253991] 4 locks held by swapper/1/0:
[12140.253991]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.253991]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.253991]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.253991]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f3c80>] select_task_rq_fair+0xb0/0x5c0
[12140.253991] 
[12140.253991] stack backtrace:
[12140.253991] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.253991] Call Trace:
[12140.253991]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.253991]  [<ffffffff810f062f>] select_idle_sibling+0xaf/0x1c0
[12140.253991]  [<ffffffff810f3f51>] select_task_rq_fair+0x381/0x5c0
[12140.253991]  [<ffffffff810f3c80>] ? select_task_rq_fair+0xb0/0x5c0
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec561>] try_to_wake_up+0x191/0x290
[12140.253991]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.253991]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.253991]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.253991]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.253991]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.253991]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.253991]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.253991]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.253991]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.253991]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.253991]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.253991]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.253991]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.253991]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.253991]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.253991]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.253991] 
[12140.253991] ===============================
[12140.253991] [ INFO: suspicious RCU usage. ]
[12140.253991] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.253991] -------------------------------
[12140.253991] include/linux/rcupdate.h:750 rcu_read_unlock() used illegally while idle!
[12140.253991] 
[12140.253991] other info that might help us debug this:
[12140.253991] 
[12140.253991] 
[12140.253991] RCU used illegally from idle CPU!
[12140.253991] rcu_scheduler_active = 1, debug_locks = 1
[12140.253991] RCU used illegally from extended quiescent state!
[12140.253991] 4 locks held by swapper/1/0:
[12140.253991]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.253991]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.253991]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.253991]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f3c80>] select_task_rq_fair+0xb0/0x5c0
[12140.253991] 
[12140.253991] stack backtrace:
[12140.253991] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.253991] Call Trace:
[12140.253991]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.253991]  [<ffffffff810f412a>] select_task_rq_fair+0x55a/0x5c0
[12140.253991]  [<ffffffff810f3c80>] ? select_task_rq_fair+0xb0/0x5c0
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.253991]  [<ffffffff810ec561>] try_to_wake_up+0x191/0x290
[12140.253991]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.253991]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.253991]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.253991]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.253991]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.253991]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.253991]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.253991]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.253991]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.253991]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.253991]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.253991]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.253991]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.253991]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.253991]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.253991]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.623131] 
[12140.623131] ===============================
[12140.623131] [ INFO: suspicious RCU usage. ]
[12140.623131] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.623131] -------------------------------
[12140.623131] include/linux/rcupdate.h:729 rcu_read_lock() used illegally while idle!
[12140.623131] 
[12140.623131] other info that might help us debug this:
[12140.623131] 
[12140.623131] 
[12140.623131] RCU used illegally from idle CPU!
[12140.623131] rcu_scheduler_active = 1, debug_locks = 1
[12140.623131] RCU used illegally from extended quiescent state!
[12140.623131] 4 locks held by swapper/1/0:
[12140.623131]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.623131]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.623131]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.623131]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810ea4c0>] ttwu_stat+0x50/0x230
[12140.623131] 
[12140.623131] stack backtrace:
[12140.623131] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.623131] Call Trace:
[12140.623131]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.623131]  [<ffffffff810ea537>] ttwu_stat+0xc7/0x230
[12140.623131]  [<ffffffff810ea4c0>] ? ttwu_stat+0x50/0x230
[12140.623131]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.623131]  [<ffffffff810ec62a>] try_to_wake_up+0x25a/0x290
[12140.623131]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.623131]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.623131]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.623131]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.623131]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.623131]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.623131]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.623131]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.623131]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.623131]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.623131]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.623131]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.623131]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.623131]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.623131]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.623131]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.623131] 
[12140.623131] ===============================
[12140.623131] [ INFO: suspicious RCU usage. ]
[12140.623131] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.623131] -------------------------------
[12140.623131] kernel/sched/core.c:1375 suspicious rcu_dereference_check() usage!
[12140.623131] 
[12140.623131] other info that might help us debug this:
[12140.623131] 
[12140.623131] 
[12140.623131] RCU used illegally from idle CPU!
[12140.623131] rcu_scheduler_active = 1, debug_locks = 1
[12140.623131] RCU used illegally from extended quiescent state!
[12140.623131] 4 locks held by swapper/1/0:
[12140.623131]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.623131]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.623131]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.623131]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810ea4c0>] ttwu_stat+0x50/0x230
[12140.623131] 
[12140.623131] stack backtrace:
[12140.623131] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.623131] Call Trace:
[12140.623131]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.623131]  [<ffffffff810ea5a8>] ttwu_stat+0x138/0x230
[12140.623131]  [<ffffffff810ea4c0>] ? ttwu_stat+0x50/0x230
[12140.623131]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.623131]  [<ffffffff810ec62a>] try_to_wake_up+0x25a/0x290
[12140.623131]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.623131]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.623131]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.623131]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.623131]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.623131]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.623131]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.623131]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.623131]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.623131]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.623131]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.623131]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.623131]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.623131]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.623131]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.623131]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8
[12140.623131] 
[12140.623131] ===============================
[12140.623131] [ INFO: suspicious RCU usage. ]
[12140.623131] 3.4.0-rc1-next-20120402-sasha #46 Tainted: G        W   
[12140.623131] -------------------------------
[12140.623131] include/linux/rcupdate.h:750 rcu_read_unlock() used illegally while idle!
[12140.623131] 
[12140.623131] other info that might help us debug this:
[12140.623131] 
[12140.623131] 
[12140.623131] RCU used illegally from idle CPU!
[12140.623131] rcu_scheduler_active = 1, debug_locks = 1
[12140.623131] RCU used illegally from extended quiescent state!
[12140.623131] 4 locks held by swapper/1/0:
[12140.623131]  #0:  (&(&async_pf_sleepers[i].lock)->rlock){..-...}, at: [<ffffffff8107cdc8>] kvm_async_pf_task_wake+0x48/0x130
[12140.623131]  #1:  (&n.wq){......}, at: [<ffffffff810e200d>] __wake_up+0x2d/0x70
[12140.623131]  #2:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810ec404>] try_to_wake_up+0x34/0x290
[12140.623131]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff810ea4c0>] ttwu_stat+0x50/0x230
[12140.623131] 
[12140.623131] stack backtrace:
[12140.623131] Pid: 0, comm: swapper/1 Tainted: G        W    3.4.0-rc1-next-20120402-sasha #46
[12140.623131] Call Trace:
[12140.623131]  [<ffffffff81114173>] lockdep_rcu_suspicious+0x113/0x130
[12140.623131]  [<ffffffff810ea643>] ttwu_stat+0x1d3/0x230
[12140.623131]  [<ffffffff810ea4c0>] ? ttwu_stat+0x50/0x230
[12140.623131]  [<ffffffff810ec404>] ? try_to_wake_up+0x34/0x290
[12140.623131]  [<ffffffff810ec62a>] try_to_wake_up+0x25a/0x290
[12140.623131]  [<ffffffff81114850>] ? __lock_acquired+0x1c0/0x210
[12140.623131]  [<ffffffff810ec66d>] default_wake_function+0xd/0x10
[12140.623131]  [<ffffffff810d7208>] autoremove_wake_function+0x18/0x40
[12140.623131]  [<ffffffff810e11e2>] __wake_up_common+0x52/0x90
[12140.623131]  [<ffffffff810e200d>] ? __wake_up+0x2d/0x70
[12140.623131]  [<ffffffff810e2023>] __wake_up+0x43/0x70
[12140.623131]  [<ffffffff8107cb07>] apf_task_wake_one+0x87/0x90
[12140.623131]  [<ffffffff8107cdf5>] kvm_async_pf_task_wake+0x75/0x130
[12140.623131]  [<ffffffff8107d1e6>] do_async_page_fault+0x86/0xa0
[12140.623131]  [<ffffffff82657a55>] async_page_fault+0x25/0x30
[12140.623131]  [<ffffffff8107d626>] ? native_safe_halt+0x6/0x10
[12140.623131]  [<ffffffff81116fed>] ? trace_hardirqs_on+0xd/0x10
[12140.623131]  [<ffffffff8105857d>] default_idle+0x4d/0xa0
[12140.623131]  [<ffffffff810582af>] cpu_idle+0x11f/0x180
[12140.623131]  [<ffffffff8264b9e0>] ? setup_APIC_timer+0x88/0x8c
[12140.623131]  [<ffffffff8264b004>] start_secondary+0xe1/0xe8

-- 

Sasha.

