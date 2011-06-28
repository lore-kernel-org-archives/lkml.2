Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1F1Tzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:55:39 -0400
Received: from mail.candelatech.com ([208.74.158.172]:55901 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab1F1Tze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:55:34 -0400
Message-ID: <4E0A31B5.409@candelatech.com>
Date: Tue, 28 Jun 2011 12:55:33 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep splat in patched 3.0.0-rc5+ kernel.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this has anything to do with the NFS patches I'm testing,
but it's always possible....

=======================================================
[ INFO: possible circular locking dependency detected ]
3.0.0-rc5+ #9
-------------------------------------------------------
btserver/22102 is trying to acquire lock:
  (rcu_node_level_0){..-...}, at: [<ffffffff810a72ad>] rcu_report_unblock_qs_rnp+0x52/0x72

but task is already holding lock:
  (&rq->lock){-.-.-.}, at: [<ffffffff81045da5>] sched_ttwu_pending+0x34/0x58

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&rq->lock){-.-.-.}:
        [<ffffffff8107b349>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e141>] _raw_spin_lock+0x36/0x45
        [<ffffffff8103da13>] __task_rq_lock+0x5b/0x89
        [<ffffffff81046ab6>] wake_up_new_task+0x41/0x116
        [<ffffffff810496d5>] do_fork+0x207/0x2f1
        [<ffffffff81010d25>] kernel_thread+0x70/0x72
        [<ffffffff8146567d>] rest_init+0x21/0xd7
        [<ffffffff81aa9c76>] start_kernel+0x3bd/0x3c8
        [<ffffffff81aa92cd>] x86_64_start_reservations+0xb8/0xbc
        [<ffffffff81aa93d2>] x86_64_start_kernel+0x101/0x110

-> #2 (&p->pi_lock){-.-.-.}:
        [<ffffffff8107b349>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e255>] _raw_spin_lock_irqsave+0x4e/0x60
        [<ffffffff810468d0>] try_to_wake_up+0x29/0x1a0
        [<ffffffff81046a54>] default_wake_function+0xd/0xf
        [<ffffffff8106738e>] autoremove_wake_function+0x13/0x38
        [<ffffffff810395d0>] __wake_up_common+0x49/0x7f
        [<ffffffff8103c79a>] __wake_up+0x34/0x48
        [<ffffffff810a731d>] rcu_report_exp_rnp+0x50/0x89
        [<ffffffff810a7ea6>] __rcu_read_unlock+0x1e9/0x24e
        [<ffffffff813d2b1b>] sk_filter+0x102/0x113
        [<ffffffff813e3334>] netlink_dump+0x79/0x19b
        [<ffffffff813e3685>] netlink_recvmsg+0x1c7/0x2f8
        [<ffffffff813af348>] __sock_recvmsg_nosec+0x65/0x6e
        [<ffffffff813b0b6a>] __sock_recvmsg+0x49/0x54
        [<ffffffff813b10d8>] sock_recvmsg+0xa6/0xbf
        [<ffffffff813b0e53>] __sys_recvmsg+0x147/0x21e
        [<ffffffff813b162f>] sys_recvmsg+0x3d/0x5b
        [<ffffffff81484a52>] system_call_fastpath+0x16/0x1b

-> #1 (sync_rcu_preempt_exp_wq.lock){......}:
        [<ffffffff8107b349>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e255>] _raw_spin_lock_irqsave+0x4e/0x60
        [<ffffffff8103c783>] __wake_up+0x1d/0x48
        [<ffffffff810a731d>] rcu_report_exp_rnp+0x50/0x89
        [<ffffffff810a8aa0>] sync_rcu_preempt_exp_init.clone.0+0x3e/0x53
        [<ffffffff810a8b90>] synchronize_rcu_expedited+0xdb/0x1c3
        [<ffffffff813c0a13>] synchronize_net+0x25/0x2e
        [<ffffffff813c2fe2>] rollback_registered_many+0xee/0x1e1
        [<ffffffff813c30e9>] unregister_netdevice_many+0x14/0x55
        [<ffffffffa0379118>] 0xffffffffa0379118
        [<ffffffff813bd59d>] ops_exit_list+0x25/0x4e
        [<ffffffff813bd7e9>] unregister_pernet_operations+0x5c/0x8e
        [<ffffffff813bd882>] unregister_pernet_subsys+0x22/0x32
        [<ffffffffa0381dac>] 0xffffffffa0381dac
        [<ffffffff81083bba>] sys_delete_module+0x1aa/0x20e
        [<ffffffff81484a52>] system_call_fastpath+0x16/0x1b

-> #0 (rcu_node_level_0){..-...}:
        [<ffffffff8107ab56>] __lock_acquire+0xae6/0xdd5
        [<ffffffff8107b349>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e141>] _raw_spin_lock+0x36/0x45
        [<ffffffff810a72ad>] rcu_report_unblock_qs_rnp+0x52/0x72
        [<ffffffff810a7e64>] __rcu_read_unlock+0x1a7/0x24e
        [<ffffffff8103d34d>] rcu_read_unlock+0x21/0x23
        [<ffffffff8103d3a2>] cpuacct_charge+0x53/0x5b
        [<ffffffff81044d04>] update_curr+0x11f/0x15a
        [<ffffffff81045a37>] enqueue_task_fair+0x46/0x22a
        [<ffffffff8103d2c0>] enqueue_task+0x61/0x68
        [<ffffffff8103d2ef>] activate_task+0x28/0x30
        [<ffffffff81040b3b>] ttwu_activate+0x12/0x34
        [<ffffffff81045d5f>] ttwu_do_activate.clone.4+0x2d/0x3f
        [<ffffffff81045db4>] sched_ttwu_pending+0x43/0x58
        [<ffffffff81045dd2>] scheduler_ipi+0x9/0xb
        [<ffffffff81021e10>] smp_reschedule_interrupt+0x25/0x27
        [<ffffffff81485973>] reschedule_interrupt+0x13/0x20
        [<ffffffff813fcabe>] rcu_read_unlock+0x21/0x23
        [<ffffffff813fd1ab>] ip_queue_xmit+0x35e/0x3b1
        [<ffffffff8140f26f>] tcp_transmit_skb+0x785/0x7c3
        [<ffffffff81410e21>] tcp_connect+0x418/0x47a
        [<ffffffff8141561f>] tcp_v4_connect+0x3c6/0x419
        [<ffffffff81423cc5>] inet_stream_connect+0xa4/0x25f
        [<ffffffff813b1f6d>] sys_connect+0x75/0x98
        [<ffffffff81484a52>] system_call_fastpath+0x16/0x1b

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

2 locks held by btserver/22102:
  #0:  (sk_lock-AF_INET){+.+.+.}, at: [<ffffffff81423c5b>] inet_stream_connect+0x3a/0x25f
  #1:  (&rq->lock){-.-.-.}, at: [<ffffffff81045da5>] sched_ttwu_pending+0x34/0x58

stack backtrace:
Pid: 22102, comm: btserver Not tainted 3.0.0-rc5+ #9
Call Trace:
  <IRQ>  [<ffffffff8147e7a3>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff81079fb1>] print_circular_bug+0x1fe/0x20f
  [<ffffffff8107ab56>] __lock_acquire+0xae6/0xdd5
  [<ffffffff810a72ad>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8107b349>] lock_acquire+0xf4/0x14b
  [<ffffffff810a72ad>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8147e141>] _raw_spin_lock+0x36/0x45
  [<ffffffff810a72ad>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8147e72b>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810a72ad>] rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff810a7d99>] ? __rcu_read_unlock+0xdc/0x24e
  [<ffffffff810a7e64>] __rcu_read_unlock+0x1a7/0x24e
  [<ffffffff8103d34d>] rcu_read_unlock+0x21/0x23
  [<ffffffff8103d3a2>] cpuacct_charge+0x53/0x5b
  [<ffffffff81044d04>] update_curr+0x11f/0x15a
  [<ffffffff81045a37>] enqueue_task_fair+0x46/0x22a
  [<ffffffff8103d2c0>] enqueue_task+0x61/0x68
  [<ffffffff8103d2ef>] activate_task+0x28/0x30
  [<ffffffff81040b3b>] ttwu_activate+0x12/0x34
  [<ffffffff81045d5f>] ttwu_do_activate.clone.4+0x2d/0x3f
  [<ffffffff81045db4>] sched_ttwu_pending+0x43/0x58
  [<ffffffff81045dd2>] scheduler_ipi+0x9/0xb
  [<ffffffff81021e10>] smp_reschedule_interrupt+0x25/0x27
  [<ffffffff81485973>] reschedule_interrupt+0x13/0x20
  <EOI>  [<ffffffff810a7cdd>] ? __rcu_read_unlock+0x20/0x24e
  [<ffffffff813fda17>] ? ip_output+0xa6/0xaf
  [<ffffffff813fcabe>] rcu_read_unlock+0x21/0x23
  [<ffffffff813fd1ab>] ip_queue_xmit+0x35e/0x3b1
  [<ffffffff813fce4d>] ? ip_send_reply+0x247/0x247
  [<ffffffff8140f26f>] tcp_transmit_skb+0x785/0x7c3
  [<ffffffff81410e21>] tcp_connect+0x418/0x47a
  [<ffffffff812d9905>] ? secure_tcp_sequence_number+0x55/0x6f
  [<ffffffff8141561f>] tcp_v4_connect+0x3c6/0x419
  [<ffffffff81423c5b>] ? inet_stream_connect+0x3a/0x25f
  [<ffffffff81423cc5>] inet_stream_connect+0xa4/0x25f
  [<ffffffff810e62e3>] ? might_fault+0x4e/0x9e
  [<ffffffff813af7f8>] ? copy_from_user+0x2a/0x2c
  [<ffffffff813b1f6d>] sys_connect+0x75/0x98
  [<ffffffff81484a8a>] ? sysret_check+0x2e/0x69
  [<ffffffff810792be>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff8109ef15>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff8122d2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81484a52>] system_call_fastpath+0x16/0x1b

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

