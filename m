Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026Ab1JFPzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab1JFPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:55:40 -0400
Date: Thu, 6 Oct 2011 11:55:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: sig->cputimer.lock/rq->lock lockdep report
Message-ID: <20111006155537.GA27563@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just started happening the last few days during boot.

[   35.629250] =======================================================
[   35.630234] [ INFO: possible circular locking dependency detected ]
[   35.630234] 3.1.0-rc8+ #16
[   35.630234] -------------------------------------------------------
[   35.630234] modprobe/1036 is trying to acquire lock:
[   35.630234]  (&(&sig->cputimer.lock)->rlock){-.....}, at: [<ffffffff8104935e>] account_group_exec_runtime+0x32/0x49
[   35.630234] 
[   35.630234] but task is already holding lock:
[   35.630234]  (&rq->lock){-.-.-.}, at: [<ffffffff81058638>] scheduler_tick+0x3d/0x238
[   35.630234] 
[   35.630234] which lock already depends on the new lock.
[   35.630234] 
[   35.630234] 
[   35.630234] the existing dependency chain (in reverse order) is:
[   35.630234] 
[   35.630234] -> #2 (&rq->lock){-.-.-.}:
[   35.630234]        [<ffffffff81091209>] lock_acquire+0xf3/0x13e
[   35.630234]        [<ffffffff814e98e3>] _raw_spin_lock+0x40/0x73
[   35.630234]        [<ffffffff81049570>] __task_rq_lock+0x5e/0x8b
[   35.630234]        [<ffffffff81058029>] wake_up_new_task+0x46/0x10d
[   35.630234]        [<ffffffff8105d401>] do_fork+0x201/0x2cd
[   35.630234]        [<ffffffff81016f94>] kernel_thread+0x75/0x77
[   35.630234]        [<ffffffff814c6102>] rest_init+0x26/0xdc
[   35.630234]        [<ffffffff81d48bbe>] start_kernel+0x3ec/0x3f7
[   35.630234]        [<ffffffff81d482c4>] x86_64_start_reservations+0xaf/0xb3
[   35.630234]        [<ffffffff81d483ca>] x86_64_start_kernel+0x102/0x111
[   35.630234] 
[   35.630234] -> #1 (&p->pi_lock){-.-.-.}:
[   35.630234]        [<ffffffff81091209>] lock_acquire+0xf3/0x13e
[   35.630234]        [<ffffffff814e9a70>] _raw_spin_lock_irqsave+0x4f/0x89
[   35.630234]        [<ffffffff8107df4c>] thread_group_cputimer+0x32/0xbd
[   35.630234]        [<ffffffff8107e002>] cpu_timer_sample_group+0x2b/0x75
[   35.630234]        [<ffffffff8107efc4>] set_process_cpu_timer+0x36/0xe0
[   35.630234]        [<ffffffff8107f0ad>] update_rlimit_cpu+0x3f/0x5a
[   35.630234]        [<ffffffff8123096a>] selinux_bprm_committing_creds+0xc6/0xcb
[   35.630234]        [<ffffffff812280b9>] security_bprm_committing_creds+0x13/0x15
[   35.630234]        [<ffffffff8114a324>] install_exec_creds+0x13/0x52
[   35.630234]        [<ffffffff81189415>] load_elf_binary+0xf3b/0x1762
[   35.630234]        [<ffffffff8114b21b>] search_binary_handler+0xbf/0x263
[   35.630234]        [<ffffffff8114c211>] do_execve_common+0x1e6/0x2dd
[   35.630234]        [<ffffffff8114c34b>] do_execve+0x43/0x45
[   35.630234]        [<ffffffff81017bba>] sys_execve+0x43/0x5a
[   35.630234]        [<ffffffff814f091c>] stub_execve+0x6c/0xc0
[   35.630234] 
[   35.630234] -> #0 (&(&sig->cputimer.lock)->rlock){-.....}:
[   35.630234]        [<ffffffff81090a29>] __lock_acquire+0xa2f/0xd0c
[   35.630234]        [<ffffffff81091209>] lock_acquire+0xf3/0x13e
[   35.630234]        [<ffffffff814e98e3>] _raw_spin_lock+0x40/0x73
[   35.630234]        [<ffffffff8104935e>] account_group_exec_runtime+0x32/0x49
[   35.630234]        [<ffffffff81055ec2>] update_curr+0x112/0x134
[   35.630234]        [<ffffffff810561fc>] task_tick_fair+0x2f/0x120
[   35.630234]        [<ffffffff810586c1>] scheduler_tick+0xc6/0x238
[   35.630234]        [<ffffffff8106cc1c>] update_process_times+0x65/0x75
[   35.630234]        [<ffffffff8108b96b>] tick_sched_timer+0x72/0x9b
[   35.630234]        [<ffffffff8107f9d4>] __run_hrtimer+0xed/0x1db
[   35.630234]        [<ffffffff81080224>] hrtimer_interrupt+0xea/0x1b4
[   35.630234]        [<ffffffff814f30ca>] smp_apic_timer_interrupt+0x76/0x89
[   35.630234]        [<ffffffff814f0fb3>] apic_timer_interrupt+0x73/0x80
[   35.630234]        [<ffffffff814ea146>] _raw_spin_unlock_irq+0x32/0x5e
[   35.630234]        [<ffffffff8107f0c0>] update_rlimit_cpu+0x52/0x5a
[   35.630234]        [<ffffffff8123096a>] selinux_bprm_committing_creds+0xc6/0xcb
[   35.630234]        [<ffffffff812280b9>] security_bprm_committing_creds+0x13/0x15
[   35.630234]        [<ffffffff8114a324>] install_exec_creds+0x13/0x52
[   35.630234]        [<ffffffff81189415>] load_elf_binary+0xf3b/0x1762
[   35.630234]        [<ffffffff8114b21b>] search_binary_handler+0xbf/0x263
[   35.630234]        [<ffffffff8114c211>] do_execve_common+0x1e6/0x2dd
[   35.630234]        [<ffffffff8114c34b>] do_execve+0x43/0x45
[   35.630234]        [<ffffffff81017bba>] sys_execve+0x43/0x5a
[   35.630234]        [<ffffffff814f091c>] stub_execve+0x6c/0xc0
[   35.630234] 
[   35.630234] other info that might help us debug this:
[   35.630234] 
[   35.630234] Chain exists of:
[   35.630234]   &(&sig->cputimer.lock)->rlock --> &p->pi_lock --> &rq->lock
[   35.630234] 
[   35.630234]  Possible unsafe locking scenario:
[   35.630234] 
[   35.630234]        CPU0                    CPU1
[   35.630234]        ----                    ----
[   35.630234]   lock(&rq->lock);
[   35.630234]                                lock(&p->pi_lock);
[   35.630234]                                lock(&rq->lock);
[   35.630234]   lock(&(&sig->cputimer.lock)->rlock);
[   35.630234] 
[   35.630234]  *** DEADLOCK ***
[   35.630234] 
[   35.630234] 2 locks held by modprobe/1036:
[   35.630234]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff8114bed0>] prepare_bprm_creds+0x2d/0x69
[   35.630234]  #1:  (&rq->lock){-.-.-.}, at: [<ffffffff81058638>] scheduler_tick+0x3d/0x238
[   35.630234] 
[   35.630234] stack backtrace:
[   35.630234] Pid: 1036, comm: modprobe Not tainted 3.1.0-rc8+ #16
[   35.630234] Call Trace:
[   35.630234]  <IRQ>  [<ffffffff81081179>] ? up+0x39/0x3e
[   35.630234]  [<ffffffff814df59a>] print_circular_bug+0x1f8/0x209
[   35.630234]  [<ffffffff81090a29>] __lock_acquire+0xa2f/0xd0c
[   35.630234]  [<ffffffff81016228>] ? __cycles_2_ns+0xe/0x3a
[   35.630234]  [<ffffffff81082176>] ? local_clock+0x14/0x4c
[   35.630234]  [<ffffffff810164e9>] ? sched_clock+0x9/0xd
[   35.630234]  [<ffffffff8104935e>] ? account_group_exec_runtime+0x32/0x49
[   35.630234]  [<ffffffff81091209>] lock_acquire+0xf3/0x13e
[   35.630234]  [<ffffffff8104935e>] ? account_group_exec_runtime+0x32/0x49
[   35.630234]  [<ffffffff8108d972>] ? put_lock_stats+0xe/0x29
[   35.630234]  [<ffffffff8108b8f9>] ? tick_nohz_handler+0xe4/0xe4
[   35.630234]  [<ffffffff814e98e3>] _raw_spin_lock+0x40/0x73
[   35.630234]  [<ffffffff8104935e>] ? account_group_exec_runtime+0x32/0x49
[   35.630234]  [<ffffffff8104935e>] account_group_exec_runtime+0x32/0x49
[   35.630234]  [<ffffffff81055ec2>] update_curr+0x112/0x134
[   35.630234]  [<ffffffff810561fc>] task_tick_fair+0x2f/0x120
[   35.630234]  [<ffffffff810586c1>] scheduler_tick+0xc6/0x238
[   35.630234]  [<ffffffff8106cc1c>] update_process_times+0x65/0x75
[   35.630234]  [<ffffffff8108b96b>] tick_sched_timer+0x72/0x9b
[   35.630234]  [<ffffffff8107f9d4>] __run_hrtimer+0xed/0x1db
[   35.630234]  [<ffffffff81080224>] hrtimer_interrupt+0xea/0x1b4
[   35.630234]  [<ffffffff814f30ca>] smp_apic_timer_interrupt+0x76/0x89
[   35.630234]  [<ffffffff814f0fb3>] apic_timer_interrupt+0x73/0x80
[   35.630234]  <EOI>  [<ffffffff81097ad6>] ? arch_local_irq_enable+0x8/0xd
[   35.630234]  [<ffffffff810916a1>] ? trace_hardirqs_on+0xd/0xf
[   35.630234]  [<ffffffff814ea146>] _raw_spin_unlock_irq+0x32/0x5e
[   35.630234]  [<ffffffff8107f0c0>] update_rlimit_cpu+0x52/0x5a
[   35.630234]  [<ffffffff8123096a>] selinux_bprm_committing_creds+0xc6/0xcb
[   35.630234]  [<ffffffff812280b9>] security_bprm_committing_creds+0x13/0x15
[   35.630234]  [<ffffffff8114a324>] install_exec_creds+0x13/0x52
[   35.630234]  [<ffffffff81189415>] load_elf_binary+0xf3b/0x1762
[   35.630234]  [<ffffffff810164e9>] ? sched_clock+0x9/0xd
[   35.630234]  [<ffffffff8114b212>] ? search_binary_handler+0xb6/0x263
[   35.630234]  [<ffffffff814ea22b>] ? _raw_read_unlock+0x32/0x54
[   35.630234]  [<ffffffff8114b21b>] search_binary_handler+0xbf/0x263
[   35.630234]  [<ffffffff811884da>] ? load_elf_library+0x23b/0x23b
[   35.630234]  [<ffffffff8114c211>] do_execve_common+0x1e6/0x2dd
[   35.630234]  [<ffffffff8114c34b>] do_execve+0x43/0x45
[   35.630234]  [<ffffffff81017bba>] sys_execve+0x43/0x5a
[   35.630234]  [<ffffffff814f091c>] stub_execve+0x6c/0xc0

