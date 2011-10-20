Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1JTPsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:48:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53283 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab1JTPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:47:59 -0400
Subject: Re: sig->cputimer.lock/rq->lock lockdep report
From: Paul Bolle <pebolle@tiscali.nl>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20111006155537.GA27563@redhat.com>
References: <20111006155537.GA27563@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 17:47:50 +0200
Message-ID: <1319125670.8405.36.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 11:55 -0400, Dave Jones wrote:
> [   35.630234] [ INFO: possible circular locking dependency detected ]
> [   35.630234] 3.1.0-rc8+ #16
> [   35.630234] -------------------------------------------------------
> [   35.630234] modprobe/1036 is trying to acquire lock:
> [   35.630234]  (&(&sig->cputimer.lock)->rlock){-.....}, at: [<ffffffff8104935e>] account_group_exec_runtime+0x32/0x49
> [   35.630234] 
> [   35.630234] but task is already holding lock:
> [   35.630234]  (&rq->lock){-.-.-.}, at: [<ffffffff81058638>] scheduler_tick+0x3d/0x238
> [   35.630234] 
> [   35.630234] which lock already depends on the new lock.

I ran into a rather similar lockdep warning in v3.0.7, so it doesn't
seem to be a regression:

[   30.389966] =======================================================
[   30.389970] [ INFO: possible circular locking dependency detected ]
[   30.389974] 3.0.7-local0.fc14.x86_64 #1
[   30.389976] -------------------------------------------------------
[   30.389979] modprobe/809 is trying to acquire lock:
[   30.389982]  (&(&sig->cputimer.lock)->rlock){......}, at: [<ffffffff8104b730>] account_group_exec_runtime+0x34/0x4b
[   30.389994] 
[   30.389994] but task is already holding lock:
[   30.389997]  (&rq->lock){-.-.-.}, at: [<ffffffff810548d5>] try_to_wake_up+0x18f/0x1d7
[   30.390005] 
[   30.390005] which lock already depends on the new lock.
[   30.390007] 
[   30.390009] 
[   30.390010] the existing dependency chain (in reverse order) is:
[   30.390012] 
[   30.390013] -> #2 (&rq->lock){-.-.-.}:
[   30.390018]        [<ffffffff8108f9c2>] lock_acquire+0xb7/0xfb
[   30.390020]        [<ffffffff814ef2cb>] _raw_spin_lock+0x36/0x69
[   30.390020]        [<ffffffff8104bc86>] __task_rq_lock+0x60/0x8f
[   30.390020]        [<ffffffff81054ccd>] wake_up_new_task+0x46/0xd2
[   30.390020]        [<ffffffff8105c227>] do_fork+0x201/0x2ce
[   30.390020]        [<ffffffff81010db1>] kernel_thread+0x75/0x77
[   30.390020]        [<ffffffff814d6382>] rest_init+0x26/0xbe
[   30.390020]        [<ffffffff81d47bc3>] start_kernel+0x3ee/0x3f9
[   30.390020]        [<ffffffff81d472cb>] x86_64_start_reservations+0xb6/0xba
[   30.390020]        [<ffffffff81d473d0>] x86_64_start_kernel+0x101/0x110
[   30.390020] 
[   30.390020] -> #1 (&p->pi_lock){-.-.-.}:
[   30.390020]        [<ffffffff8108f9c2>] lock_acquire+0xb7/0xfb
[   30.390020]        [<ffffffff814ef43b>] _raw_spin_lock_irqsave+0x45/0x7f
[   30.390020]        [<ffffffff8107c179>] thread_group_cputimer+0x32/0xbd
[   30.390020]        [<ffffffff8107c22f>] cpu_timer_sample_group+0x2b/0x76
[   30.390020]        [<ffffffff8107d28a>] set_process_cpu_timer+0x36/0xdd
[   30.390020]        [<ffffffff8107d370>] update_rlimit_cpu+0x3f/0x5b
[   30.390020]        [<ffffffff8120a054>] selinux_bprm_committing_creds+0xc9/0xce
[   30.390020]        [<ffffffff812016fc>] security_bprm_committing_creds+0x13/0x15
[   30.390020]        [<ffffffff81147ee1>] install_exec_creds+0x16/0x55
[   30.390020]        [<ffffffff811861b8>] load_elf_binary+0xf65/0x178d
[   30.390020]        [<ffffffff81147d28>] search_binary_handler+0x8f/0x232
[   30.390020]        [<ffffffff81149738>] do_execve_common.clone.21+0x195/0x292
[   30.390020]        [<ffffffff81149850>] do_execve+0x1b/0x1d
[   30.390020]        [<ffffffff810116d2>] sys_execve+0x43/0x5a
[   30.390020]        [<ffffffff814f6c1c>] stub_execve+0x6c/0xc0
[   30.390020] 
[   30.390020] -> #0 (&(&sig->cputimer.lock)->rlock){......}:
[   30.390020]        [<ffffffff8108f1fa>] __lock_acquire+0xadc/0xdd8
[   30.390020]        [<ffffffff8108f9c2>] lock_acquire+0xb7/0xfb
[   30.390020]        [<ffffffff814ef2cb>] _raw_spin_lock+0x36/0x69
[   30.390020]        [<ffffffff8104b730>] account_group_exec_runtime+0x34/0x4b
[   30.390020]        [<ffffffff8104b819>] update_curr+0xd2/0xf0
[   30.390020]        [<ffffffff8104f405>] check_preempt_wakeup+0xd0/0x1d9
[   30.390020]        [<ffffffff8104a817>] check_preempt_curr+0x34/0x74
[   30.390020]        [<ffffffff8104a997>] ttwu_do_wakeup+0x4d/0xe0
[   30.390020]        [<ffffffff810507a8>] ttwu_do_activate.clone.98+0x5c/0x61
[   30.390020]        [<ffffffff810548e1>] try_to_wake_up+0x19b/0x1d7
[   30.390020]        [<ffffffff8105492f>] default_wake_function+0x12/0x14
[   30.390020]        [<ffffffff81047526>] __wake_up_common+0x4e/0x84
[   30.390020]        [<ffffffff8104d547>] __wake_up+0x39/0x4d
[   30.390020]        [<ffffffff810af184>] audit_log_end+0x71/0x8f
[   30.390020]        [<ffffffff810b3404>] audit_log_exit+0x2d6/0xf63
[   30.390020]        [<ffffffff810b4a95>] audit_syscall_exit+0x4b/0x14b
[   30.390020]        [<ffffffff810146fc>] syscall_trace_leave+0x3d/0x101
[   30.390020]        [<ffffffff814f6a78>] int_check_syscall_exit_work+0x34/0x3d
[   30.390020] 
[   30.390020] other info that might help us debug this:
[   30.390020] 
[   30.390020] Chain exists of:
[   30.390020]   &(&sig->cputimer.lock)->rlock --> &p->pi_lock --> &rq->lock
[   30.390020] 
[   30.390020]  Possible unsafe locking scenario:
[   30.390020] 
[   30.390020]        CPU0                    CPU1
[   30.390020]        ----                    ----
[   30.390020]   lock(&rq->lock);
[   30.390020]                                lock(&p->pi_lock);
[   30.390020]                                lock(&rq->lock);
[   30.390020]   lock(&(&sig->cputimer.lock)->rlock);
[   30.390020] 
[   30.390020]  *** DEADLOCK ***
[   30.390020] 
[   30.390020] 3 locks held by modprobe/809:
[   30.390020]  #0:  (kauditd_wait.lock){......}, at: [<ffffffff8104d530>] __wake_up+0x22/0x4d
[   30.390020]  #1:  (&p->pi_lock){-.-.-.}, at: [<ffffffff81054774>] try_to_wake_up+0x2e/0x1d7
[   30.390020]  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff810548d5>] try_to_wake_up+0x18f/0x1d7
[   30.390020] 
[   30.390020] stack backtrace:
[   30.390020] Pid: 809, comm: modprobe Not tainted 3.0.7-local0.fc14.x86_64 #1
[   30.390020] Call Trace:
[   30.390020]  [<ffffffff8108d967>] print_circular_bug+0x1f8/0x209
[   30.390020]  [<ffffffff8108f1fa>] __lock_acquire+0xadc/0xdd8
[   30.390020]  [<ffffffff8104b730>] ? account_group_exec_runtime+0x34/0x4b
[   30.390020]  [<ffffffff8108f9c2>] lock_acquire+0xb7/0xfb
[   30.390020]  [<ffffffff8104b730>] ? account_group_exec_runtime+0x34/0x4b
[   30.390020]  [<ffffffff814ef2cb>] _raw_spin_lock+0x36/0x69
[   30.390020]  [<ffffffff8104b730>] ? account_group_exec_runtime+0x34/0x4b
[   30.390020]  [<ffffffff8104b730>] account_group_exec_runtime+0x34/0x4b
[   30.390020]  [<ffffffff8104b819>] update_curr+0xd2/0xf0
[   30.390020]  [<ffffffff8104f405>] check_preempt_wakeup+0xd0/0x1d9
[   30.390020]  [<ffffffff8104a817>] check_preempt_curr+0x34/0x74
[   30.390020]  [<ffffffff8104a997>] ttwu_do_wakeup+0x4d/0xe0
[   30.390020]  [<ffffffff810507a8>] ttwu_do_activate.clone.98+0x5c/0x61
[   30.390020]  [<ffffffff810548e1>] try_to_wake_up+0x19b/0x1d7
[   30.390020]  [<ffffffff8108d31f>] ? lock_acquired+0x1ea/0x215
[   30.390020]  [<ffffffff8105492f>] default_wake_function+0x12/0x14
[   30.390020]  [<ffffffff81047526>] __wake_up_common+0x4e/0x84
[   30.390020]  [<ffffffff8104d530>] ? __wake_up+0x22/0x4d
[   30.390020]  [<ffffffff8104d547>] __wake_up+0x39/0x4d
[   30.390020]  [<ffffffff810af184>] audit_log_end+0x71/0x8f
[   30.390020]  [<ffffffff810b3404>] audit_log_exit+0x2d6/0xf63
[   30.390020]  [<ffffffff8108f8e3>] ? lock_release+0x18a/0x1b2
[   30.390020]  [<ffffffff810b2592>] ? rcu_read_unlock+0x21/0x23
[   30.390020]  [<ffffffff810b462c>] ? audit_filter_inodes+0x11b/0x12a
[   30.390020]  [<ffffffff810b4a95>] audit_syscall_exit+0x4b/0x14b
[   30.390020]  [<ffffffff814f6a3c>] ? int_very_careful+0x5/0xd
[   30.390020]  [<ffffffff810146fc>] syscall_trace_leave+0x3d/0x101
[   30.390020]  [<ffffffff814f6a78>] int_check_syscall_exit_work+0x34/0x3d


Paul Bolle

