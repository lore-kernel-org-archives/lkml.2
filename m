Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1GPTmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 15:42:43 -0400
Received: from mail001.aei.ca ([206.123.6.130]:46460 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754286Ab1GPTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 15:42:41 -0400
From: Ed Tomlinson <edt@aei.ca>
To: paulmck@linux.vnet.ibm.com
Subject: Re: INFO: possible circular locking dependency detected
Date: Sat, 16 Jul 2011 15:42:30 -0400
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-crc+; KDE/4.6.5; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
References: <1310665613.27864.50.camel@gandalf.stny.rr.com> <201107151748.07109.edt@aei.ca> <20110715220447.GJ2327@linux.vnet.ibm.com>
In-Reply-To: <20110715220447.GJ2327@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107161542.31755.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 July 2011 18:04:47 Paul E. McKenney wrote:
> On Fri, Jul 15, 2011 at 05:48:06PM -0400, Ed Tomlinson wrote:
> > On Friday 15 July 2011 12:56:13 Paul E. McKenney wrote:
> 
> [ . . . ]
> 
> > > OK.  Ed, would you be willing to try the patch out?
> > 
> > I am booted at the same git commit with a bluetooth and the disable local_bh around softirq()
> > patch from this thread.  So far so good.  Not sure how 'easy' this one is to trigger a second time -
> > I've been running with threadirq enabled since .39 came out.  Last night was the first deadlock...
> > If nothing happened post rc6 to make it more likely it could be a while before it triggers again.
> 
> Thank you for trying it out, Ed!  And I know that you will not be shy
> should the problem recur.  ;-)

Found this in dmesg this afternoon.  This time, though X was dead, I was able to cancel and restart
it.  This is with Peter's patch to call softirq() with local_bh disabled.

[34962.637491] chrome_sandbox (4031): /proc/4029/oom_adj is deprecated, please use /proc/4029/oom_score_adj instead.
[39066.186558] 
[39066.186561] =======================================================
[39066.193875] [ INFO: possible circular locking dependency detected ]
[39066.195274] 3.0.0-rc7-crc+ #336
[39066.195274] -------------------------------------------------------
[39066.195274] chrome/3961 is trying to acquire lock:
[39066.195274]  (&p->pi_lock){-.-.-.}, at: [<ffffffff810461ee>] try_to_wake_up+0x2e/0x360
[39066.195274] 
[39066.195274] but task is already holding lock:
[39066.195274]  (sync_rcu_preempt_exp_wq.lock){......}, at: [<ffffffff8103667a>] __wake_up+0x2a/0x60
[39066.195274] 
[39066.195274] which lock already depends on the new lock.
[39066.195274] 
[39066.195274] 
[39066.195274] the existing dependency chain (in reverse order) is:
[39066.195274] 
[39066.195274] -> #3 (sync_rcu_preempt_exp_wq.lock){......}:
[39066.195274]        [<ffffffff8108b805>] lock_acquire+0x95/0x140
[39066.195274]        [<ffffffff81578206>] _raw_spin_lock_irqsave+0x46/0x60
[39066.195274]        [<ffffffff8103667a>] __wake_up+0x2a/0x60
[39066.195274]        [<ffffffff810b96c1>] rcu_report_exp_rnp+0xa1/0xb0
[39066.195274]        [<ffffffff810bc337>] synchronize_rcu_expedited+0x157/0x210
[39066.195274]        [<ffffffff814cfb95>] synchronize_net+0x45/0x50
[39066.195274]        [<ffffffffa034b613>] ipip6_tunnel_ioctl+0x5f3/0x800 [sit]
[39066.195274]        [<ffffffff814d35ca>] dev_ifsioc+0x11a/0x2c0
[39066.195274]        [<ffffffff814d599a>] dev_ioctl+0x35a/0x810
[39066.195274]        [<ffffffff814baa4a>] sock_ioctl+0xea/0x2b0
[39066.195274]        [<ffffffff81161704>] do_vfs_ioctl+0xa4/0x5a0
[39066.195274]        [<ffffffff81161c99>] sys_ioctl+0x99/0xa0
[39066.195274]        [<ffffffff815802eb>] system_call_fastpath+0x16/0x1b
[39066.195274] 
[39066.195274] -> #2 (rcu_node_level_0){..-.-.}:
[39066.195274]        [<ffffffff8108b805>] lock_acquire+0x95/0x140
[39066.195274]        [<ffffffff815780fb>] _raw_spin_lock+0x3b/0x50
[39066.195274]        [<ffffffff810ba7bf>] __rcu_read_unlock+0x19f/0x2d0
[39066.195274]        [<ffffffff8103ffc8>] cpuacct_charge+0xc8/0xe0
[39066.195274]        [<ffffffff81040ee5>] update_curr+0x1a5/0x210
[39066.195274]        [<ffffffff81043f8a>] enqueue_task_fair+0x7a/0x650
[39066.195274]        [<ffffffff81035369>] enqueue_task+0x79/0x90
[39066.195274]        [<ffffffff810353ad>] activate_task+0x2d/0x40
[39066.195274]        [<ffffffff81036921>] ttwu_activate+0x21/0x50
[39066.195274]        [<ffffffff810424cc>] T.2447+0x3c/0x60
[39066.195274]        [<ffffffff81042534>] sched_ttwu_pending+0x44/0x60
[39066.195274]        [<ffffffff8104255e>] scheduler_ipi+0xe/0x10
[39066.195274]        [<ffffffff8101e6aa>] smp_reschedule_interrupt+0x2a/0x30
[39066.195274]        [<ffffffff81580eb3>] reschedule_interrupt+0x13/0x20
[39066.195274]        [<ffffffff814c2144>] sock_def_readable+0x94/0xc0
[39066.195274]        [<ffffffffa00022d8>] unix_stream_sendmsg+0x2a8/0x410 [unix]
[39066.195274]        [<ffffffff814bc139>] sock_sendmsg+0xe9/0x120
[39066.195274]        [<ffffffff814bc309>] sys_sendto+0x139/0x190
[39066.195274]        [<ffffffff815802eb>] system_call_fastpath+0x16/0x1b
[39066.195274] 
[39066.195274] -> #1 (&rq->lock){-.-.-.}:
[39066.195274]        [<ffffffff8108b805>] lock_acquire+0x95/0x140
[39066.195274]        [<ffffffff815780fb>] _raw_spin_lock+0x3b/0x50
[39066.195274]        [<ffffffff81046648>] wake_up_new_task+0xc8/0x280
[39066.195274]        [<ffffffff8104a41a>] do_fork+0x23a/0x450
[39066.195274]        [<ffffffff8100a551>] kernel_thread+0x71/0x80
[39066.195274]        [<ffffffff81560276>] rest_init+0x26/0xe0
[39066.195274]        [<ffffffff81b0bb8f>] start_kernel+0x32f/0x33a
[39066.195274]        [<ffffffff81b0b2eb>] x86_64_start_reservations+0xfb/0xff
[39066.195274]        [<ffffffff81b0b3dc>] x86_64_start_kernel+0xed/0xf4
[39066.195274] 
[39066.195274] -> #0 (&p->pi_lock){-.-.-.}:
[39066.195274]        [<ffffffff8108b0f8>] __lock_acquire+0x1588/0x16a0
[39066.195274]        [<ffffffff8108b805>] lock_acquire+0x95/0x140
[39066.195274]        [<ffffffff81578206>] _raw_spin_lock_irqsave+0x46/0x60
[39066.195274]        [<ffffffff810461ee>] try_to_wake_up+0x2e/0x360
[39066.195274]        [<ffffffff81046532>] default_wake_function+0x12/0x20
[39066.195274]        [<ffffffff810717b6>] autoremove_wake_function+0x16/0x40
[39066.195274]        [<ffffffff810318c9>] __wake_up_common+0x59/0x90
[39066.195274]        [<ffffffff81036690>] __wake_up+0x40/0x60
[39066.195274]        [<ffffffff810b96c1>] rcu_report_exp_rnp+0xa1/0xb0
[39066.195274]        [<ffffffff810ba878>] __rcu_read_unlock+0x258/0x2d0
[39066.195274]        [<ffffffff814c1fc0>] sock_def_wakeup+0x80/0x90
[39066.195274]        [<ffffffffa0002659>] unix_release_sock+0x219/0x260 [unix]
[39066.195274]        [<ffffffffa00026c6>] unix_release+0x26/0x30 [unix]
[39066.195274]        [<ffffffff814bb1a9>] sock_release+0x29/0x90
[39066.195274]        [<ffffffff814bb227>] sock_close+0x17/0x30
[39066.195274]        [<ffffffff8114f8ba>] fput+0x12a/0x2a0
[39066.195274]        [<ffffffff8114b57b>] filp_close+0x7b/0xd0
[39066.195274]        [<ffffffff8104e128>] put_files_struct+0x178/0x1b0
[39066.195274]        [<ffffffff8104e1b2>] exit_files+0x52/0x60
[39066.195274]        [<ffffffff8104e761>] do_exit+0x391/0xa60
[39066.195274]        [<ffffffff8104ee9a>] do_group_exit+0x6a/0xd0
[39066.195274]        [<ffffffff81063b4b>] get_signal_to_deliver+0x4bb/0x5e0
[39066.195274]        [<ffffffff81001c75>] do_signal+0x75/0x8b0
[39066.195274]        [<ffffffff81002515>] do_notify_resume+0x65/0x80
[39066.195274]        [<ffffffff81580608>] int_signal+0x12/0x17
[39066.195274] 
[39066.195274] other info that might help us debug this:
[39066.195274] 
[39066.195274] Chain exists of:
[39066.195274]   &p->pi_lock --> rcu_node_level_0 --> sync_rcu_preempt_exp_wq.lock
[39066.195274] 
[39066.195274]  Possible unsafe locking scenario:
[39066.195274] 
[39066.195274]        CPU0                    CPU1
[39066.195274]        ----                    ----
[39066.195274]   lock(sync_rcu_preempt_exp_wq.lock);
[39066.195274]                                lock(rcu_node_level_0);
[39066.195274]                                lock(sync_rcu_preempt_exp_wq.lock);
[39066.195274]   lock(&p->pi_lock);
[39066.195274] 
[39066.195274]  *** DEADLOCK ***
[39066.195274] 
[39066.195274] 2 locks held by chrome/3961:
[39066.195274]  #0:  (rcu_node_level_0){..-.-.}, at: [<ffffffff810b963d>] rcu_report_exp_rnp+0x1d/0xb0
[39066.195274]  #1:  (sync_rcu_preempt_exp_wq.lock){......}, at: [<ffffffff8103667a>] __wake_up+0x2a/0x60
[39066.195274] 
[39066.195274] stack backtrace:
[39066.195274] Pid: 3961, comm: chrome Not tainted 3.0.0-rc7-crc+ #336
[39066.195274] Call Trace:
[39066.195274]  [<ffffffff8108846e>] print_circular_bug+0x20e/0x2f0
[39066.195274]  [<ffffffff8108b0f8>] __lock_acquire+0x1588/0x16a0
[39066.195274]  [<ffffffff810461ee>] ? try_to_wake_up+0x2e/0x360
[39066.195274]  [<ffffffff8108b805>] lock_acquire+0x95/0x140
[39066.195274]  [<ffffffff810461ee>] ? try_to_wake_up+0x2e/0x360
[39066.195274]  [<ffffffff815781dc>] ? _raw_spin_lock_irqsave+0x1c/0x60
[39066.195274]  [<ffffffff81578206>] _raw_spin_lock_irqsave+0x46/0x60
[39066.195274]  [<ffffffff810461ee>] ? try_to_wake_up+0x2e/0x360
[39066.195274]  [<ffffffff810461ee>] try_to_wake_up+0x2e/0x360
[39066.195274]  [<ffffffff8103667a>] ? __wake_up+0x2a/0x60
[39066.195274]  [<ffffffff81046532>] default_wake_function+0x12/0x20
[39066.195274]  [<ffffffff810717b6>] autoremove_wake_function+0x16/0x40
[39066.195274]  [<ffffffff810318c9>] __wake_up_common+0x59/0x90
[39066.195274]  [<ffffffff81036690>] __wake_up+0x40/0x60
[39066.195274]  [<ffffffff810b963d>] ? rcu_report_exp_rnp+0x1d/0xb0
[39066.195274]  [<ffffffff810b96c1>] rcu_report_exp_rnp+0xa1/0xb0
[39066.195274]  [<ffffffff810ba878>] __rcu_read_unlock+0x258/0x2d0
[39066.195274]  [<ffffffff814c1fc0>] sock_def_wakeup+0x80/0x90
[39066.195274]  [<ffffffff814c1f40>] ? sock_def_error_report+0xc0/0xc0
[39066.195274]  [<ffffffff8157882c>] ? _raw_spin_unlock+0x5c/0x70
[39066.195274]  [<ffffffffa0002659>] unix_release_sock+0x219/0x260 [unix]
[39066.195274]  [<ffffffffa00026c6>] unix_release+0x26/0x30 [unix]
[39066.195274]  [<ffffffff814bb1a9>] sock_release+0x29/0x90
[39066.195274]  [<ffffffff814bb227>] sock_close+0x17/0x30
[39066.195274]  [<ffffffff8114f8ba>] fput+0x12a/0x2a0
[39066.195274]  [<ffffffff8114b57b>] filp_close+0x7b/0xd0
[39066.195274]  [<ffffffff8104e128>] put_files_struct+0x178/0x1b0
[39066.195274]  [<ffffffff8104dfe8>] ? put_files_struct+0x38/0x1b0
[39066.195274]  [<ffffffff8104e1b2>] exit_files+0x52/0x60
[39066.195274]  [<ffffffff8104e761>] do_exit+0x391/0xa60
[39066.195274]  [<ffffffff8106372f>] ? get_signal_to_deliver+0x9f/0x5e0
[39066.195274]  [<ffffffff8104ee9a>] do_group_exit+0x6a/0xd0
[39066.195274]  [<ffffffff81063b4b>] get_signal_to_deliver+0x4bb/0x5e0
[39066.195274]  [<ffffffff81001c75>] do_signal+0x75/0x8b0
[39066.195274]  [<ffffffff81252deb>] ? security_file_permission+0x8b/0x90
[39066.195274]  [<ffffffff8114d8dc>] ? rw_verify_area+0xec/0x190
[39066.195274]  [<ffffffff81002515>] do_notify_resume+0x65/0x80
[39066.195274]  [<ffffffff8128b3de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[39066.195274]  [<ffffffff81580608>] int_signal+0x12/0x17

System is booted with threadirqs.

Hope this helps,
Ed
