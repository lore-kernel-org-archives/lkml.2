Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab1GKXTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:19:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1GKXTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:19:34 -0400
Date: Mon, 11 Jul 2011 19:19:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: lockdep circular locking error (rcu_node_level_0 vs rq->lock)
Message-ID: <20110711231932.GB20367@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was doing an install in a kvm guest, which wedged itself at the end.
This was in the host dmesg.


[ INFO: possible circular locking dependency detected ]
3.0.0-rc6+ #91
-------------------------------------------------------
libvirtd/5720 is trying to acquire lock:
 (rcu_node_level_0){..-.-.}, at: [<ffffffff814c6c12>] rcu_report_unblock_qs_rnp.part.5+0x3f/0x60

but task is already holding lock:
 (&rq->lock){-.-.-.}, at: [<ffffffff8105408e>] sched_ttwu_pending+0x39/0x5b

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&rq->lock){-.-.-.}:
       [<ffffffff8108dfc5>] lock_acquire+0xf3/0x13e
       [<ffffffff814cf0ab>] _raw_spin_lock+0x40/0x73
       [<ffffffff8104663a>] __task_rq_lock+0x5e/0x8b
       [<ffffffff8105506d>] wake_up_new_task+0x46/0x10d
       [<ffffffff8105a1c9>] do_fork+0x231/0x331
       [<ffffffff81010c80>] kernel_thread+0x75/0x77
       [<ffffffff814abe82>] rest_init+0x26/0xdc
       [<ffffffff81d3dbc2>] start_kernel+0x401/0x40c
       [<ffffffff81d3d2c4>] x86_64_start_reservations+0xaf/0xb3
       [<ffffffff81d3d3ca>] x86_64_start_kernel+0x102/0x111

-> #2 (&p->pi_lock){-.-.-.}:
       [<ffffffff8108dfc5>] lock_acquire+0xf3/0x13e
       [<ffffffff814cf238>] _raw_spin_lock_irqsave+0x4f/0x89
       [<ffffffff81054e3d>] try_to_wake_up+0x2e/0x1db
       [<ffffffff81054ffc>] default_wake_function+0x12/0x14
       [<ffffffff81079008>] autoremove_wake_function+0x18/0x3d
       [<ffffffff81045010>] __wake_up_common+0x4d/0x83
       [<ffffffff8104634e>] __wake_up+0x39/0x4d
       [<ffffffff810c3cd6>] rcu_report_exp_rnp+0x52/0x8b
       [<ffffffff810c4f18>] __rcu_read_unlock+0x1d0/0x231
       [<ffffffff8115202a>] rcu_read_unlock+0x26/0x28
       [<ffffffff8115465d>] __d_lookup+0x103/0x115
       [<ffffffff8114b9eb>] walk_component+0x1b1/0x3af
       [<ffffffff8114bd8a>] link_path_walk+0x1a1/0x43b
       [<ffffffff8114c148>] path_lookupat+0x5a/0x2af
       [<ffffffff8114d222>] do_path_lookup+0x28/0x97
       [<ffffffff8114d658>] user_path_at+0x59/0x96
       [<ffffffff81145214>] sys_readlinkat+0x33/0x95
       [<ffffffff81145291>] sys_readlink+0x1b/0x1d
       [<ffffffff814d5c02>] system_call_fastpath+0x16/0x1b

-> #1 (sync_rcu_preempt_exp_wq.lock){......}:
       [<ffffffff8108dfc5>] lock_acquire+0xf3/0x13e
       [<ffffffff814cf238>] _raw_spin_lock_irqsave+0x4f/0x89
       [<ffffffff81046337>] __wake_up+0x22/0x4d
       [<ffffffff810c3cd6>] rcu_report_exp_rnp+0x52/0x8b
       [<ffffffff810c4f18>] __rcu_read_unlock+0x1d0/0x231
       [<ffffffff8115202a>] rcu_read_unlock+0x26/0x28
       [<ffffffff8115465d>] __d_lookup+0x103/0x115
       [<ffffffff8114b9eb>] walk_component+0x1b1/0x3af
       [<ffffffff8114bd8a>] link_path_walk+0x1a1/0x43b
       [<ffffffff8114c148>] path_lookupat+0x5a/0x2af
       [<ffffffff8114d222>] do_path_lookup+0x28/0x97
       [<ffffffff8114d658>] user_path_at+0x59/0x96
       [<ffffffff81145214>] sys_readlinkat+0x33/0x95
       [<ffffffff81145291>] sys_readlink+0x1b/0x1d
       [<ffffffff814d5c02>] system_call_fastpath+0x16/0x1b

-> #0 (rcu_node_level_0){..-.-.}:
       [<ffffffff8108d7e5>] __lock_acquire+0xa2f/0xd0c
       [<ffffffff8108dfc5>] lock_acquire+0xf3/0x13e
       [<ffffffff814cf0ab>] _raw_spin_lock+0x40/0x73
       [<ffffffff814c6c12>] rcu_report_unblock_qs_rnp.part.5+0x3f/0x60
       [<ffffffff810c4ed6>] __rcu_read_unlock+0x18e/0x231
       [<ffffffff810463f4>] rcu_read_unlock+0x26/0x28
       [<ffffffff8104b6db>] cpuacct_charge+0x58/0x61
       [<ffffffff81052f18>] update_curr+0x107/0x134
       [<ffffffff8105349b>] check_preempt_wakeup+0xc9/0x1d0
       [<ffffffff81049775>] check_preempt_curr+0x2f/0x6e
       [<ffffffff81053f5e>] ttwu_do_wakeup+0x7b/0x111
       [<ffffffff81054050>] ttwu_do_activate.constprop.76+0x5c/0x61
       [<ffffffff8105409e>] sched_ttwu_pending+0x49/0x5b
       [<ffffffff810540be>] scheduler_ipi+0xe/0x10
       [<ffffffff810224f6>] smp_reschedule_interrupt+0x1b/0x1d
       [<ffffffff814d6b33>] reschedule_interrupt+0x13/0x20
       [<ffffffff813fcc18>] rcu_read_unlock+0x26/0x28
       [<ffffffff813fe308>] sock_def_readable+0x88/0x8d
       [<ffffffff81497760>] unix_stream_sendmsg+0x264/0x2ff
       [<ffffffff813f83c4>] sock_aio_write+0x112/0x126
       [<ffffffff8114093b>] do_sync_write+0xbf/0xff
       [<ffffffff81141012>] vfs_write+0xb6/0xf6
       [<ffffffff81141206>] sys_write+0x4d/0x74
       [<ffffffff814d5c02>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

Chain exists of:
  rcu_node_level_0 --> &p->pi_lock --> &rq->lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rq->lock);
                               lock(&p->pi_lock);
                               lock(&rq->lock);
  lock(rcu_node_level_0);

 *** DEADLOCK ***

1 lock held by libvirtd/5720:
 #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8105408e>] sched_ttwu_pending+0x39/0x5b

stack backtrace:
Pid: 5720, comm: libvirtd Not tainted 3.0.0-rc6+ #91
Call Trace:
 <IRQ>  [<ffffffff814c51cf>] print_circular_bug+0x1f8/0x209
 [<ffffffff8108d7e5>] __lock_acquire+0xa2f/0xd0c
 [<ffffffff8107e905>] ? sched_clock_local+0x12/0x75
 [<ffffffff814c6c12>] ? rcu_report_unblock_qs_rnp.part.5+0x3f/0x60
 [<ffffffff8108dfc5>] lock_acquire+0xf3/0x13e
 [<ffffffff814c6c12>] ? rcu_report_unblock_qs_rnp.part.5+0x3f/0x60
 [<ffffffff8108adab>] ? lock_release_holdtime.part.10+0x59/0x62
 [<ffffffff814cf0ab>] _raw_spin_lock+0x40/0x73
 [<ffffffff814c6c12>] ? rcu_report_unblock_qs_rnp.part.5+0x3f/0x60
 [<ffffffff814cf855>] ? _raw_spin_unlock+0x47/0x54
 [<ffffffff814c6c12>] rcu_report_unblock_qs_rnp.part.5+0x3f/0x60
 [<ffffffff810c4e00>] ? __rcu_read_unlock+0xb8/0x231
 [<ffffffff810c4ed6>] __rcu_read_unlock+0x18e/0x231
 [<ffffffff810463f4>] rcu_read_unlock+0x26/0x28
 [<ffffffff8104b6db>] cpuacct_charge+0x58/0x61
 [<ffffffff81052f18>] update_curr+0x107/0x134
 [<ffffffff8105349b>] check_preempt_wakeup+0xc9/0x1d0
 [<ffffffff81049775>] check_preempt_curr+0x2f/0x6e
 [<ffffffff81053f5e>] ttwu_do_wakeup+0x7b/0x111
 [<ffffffff81054050>] ttwu_do_activate.constprop.76+0x5c/0x61
 [<ffffffff8105409e>] sched_ttwu_pending+0x49/0x5b
 [<ffffffff810540be>] scheduler_ipi+0xe/0x10
 [<ffffffff810224f6>] smp_reschedule_interrupt+0x1b/0x1d
 [<ffffffff814d6b33>] reschedule_interrupt+0x13/0x20
 <EOI>  [<ffffffff8107e905>] ? sched_clock_local+0x12/0x75
 [<ffffffff810c4d91>] ? __rcu_read_unlock+0x49/0x231
 [<ffffffff8108dea5>] ? lock_release+0x1b1/0x1de
 [<ffffffff813fcc18>] rcu_read_unlock+0x26/0x28
 [<ffffffff813fe308>] sock_def_readable+0x88/0x8d
 [<ffffffff81497760>] unix_stream_sendmsg+0x264/0x2ff
 [<ffffffff813f83c4>] sock_aio_write+0x112/0x126
 [<ffffffff8121cd95>] ? inode_has_perm+0x6a/0x77
 [<ffffffff8114093b>] do_sync_write+0xbf/0xff
 [<ffffffff81219562>] ? security_file_permission+0x2e/0x33
 [<ffffffff81140d71>] ? rw_verify_area+0xb6/0xd3
 [<ffffffff81141012>] vfs_write+0xb6/0xf6
 [<ffffffff811426a0>] ? fget_light+0x97/0xa2
 [<ffffffff81141206>] sys_write+0x4d/0x74
 [<ffffffff81078f85>] ? remove_wait_queue+0x1a/0x3a
 [<ffffffff814d5c02>] system_call_fastpath+0x16/0x1b

