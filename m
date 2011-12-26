Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab1LZQb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 11:31:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55531 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab1LZQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 11:31:55 -0500
Date: Mon, 26 Dec 2011 08:31:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: INFO: task rcuc/0:7 blocked for more than 120 seconds.
Message-ID: <20111226163148.GC2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1324901803.31721.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324901803.31721.4.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11122616-5518-0000-0000-00000133B9BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 26, 2011 at 02:16:43PM +0200, Sasha Levin wrote:
> Hi Paul,
> 
> I've recently got the following panic which was caused by khungtask:
> 
> [ 1921.589512] INFO: task rcuc/0:7 blocked for more than 120 seconds.
> [ 1921.590370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1921.597103] rcuc/0          D ffff880012f61630  4400     7      2 0x00000000
> [ 1921.598646]  ffff880012f6b980 0000000000000086 ffff880012f6bfd8 00000000001d4740
> [ 1921.600289]  ffff880012f6bfd8 ffff880012f61630 ffff880012f6bfd8 ffff880012f6a000
> [ 1921.601707]  00000000001d4800 ffff880012f6a000 ffff880012f6bfd8 00000000001d4800
> [ 1921.603258] Call Trace:
> [ 1921.603703]  [<ffffffff8255eefa>] schedule+0x3a/0x50
> [ 1921.605462]  [<ffffffff8255cd65>] schedule_timeout+0x255/0x4d0
> [ 1921.606540]  [<ffffffff8112a25e>] ? mark_held_locks+0x6e/0x130
> [ 1921.607633]  [<ffffffff811277b2>] ? lock_release_holdtime+0xb2/0x160
> [ 1921.608798]  [<ffffffff825602bb>] ? _raw_spin_unlock_irq+0x2b/0x70
> [ 1921.610154]  [<ffffffff8255f630>] wait_for_common+0x120/0x170
> [ 1921.617878]  [<ffffffff81104f30>] ? try_to_wake_up+0x2f0/0x2f0
> [ 1921.618949]  [<ffffffff811754d0>] ? __call_rcu+0x3c0/0x3c0
> [ 1921.621405]  [<ffffffff8255f728>] wait_for_completion+0x18/0x20
> [ 1921.623622]  [<ffffffff810ee0b9>] wait_rcu_gp+0x59/0x80
> [ 1921.626789]  [<ffffffff810ec0c0>] ? perf_trace_rcu_batch_end+0x120/0x120
> [ 1921.629440]  [<ffffffff8255f554>] ? wait_for_common+0x44/0x170
> [ 1921.632445]  [<ffffffff81179d3c>] synchronize_rcu+0x1c/0x20
> [ 1921.635455]  [<ffffffff810f8980>] atomic_notifier_chain_unregister+0x60/0x80

This called synchronize_rcu().

> [ 1921.638550]  [<ffffffff8111bab3>] task_handoff_unregister+0x13/0x20
> [ 1921.641271]  [<ffffffff8211342f>] task_notify_func+0x2f/0x40
> [ 1921.643894]  [<ffffffff810f8817>] notifier_call_chain+0x67/0x110
> [ 1921.646580]  [<ffffffff810f8a14>] __atomic_notifier_call_chain+0x74/0x110

This called rcu_read_lock().

Now, calling synchronize_rcu() from within an RCU read-side critical
section is grossly illegal.  This will result in either deadlock (for
preemptible RCU) or premature grace-period end and memory corruption
(for non-preemptible RCU).  So let's take a look at task_notify_func().

Except that when I try looking for task_notify_func() in current mainline,
I get nothing.

Where is task_notify_func() coming from?

Regardless, my advice is to change task_notify_func() as follows:

1.	Make a flag (either global or per-CPU, depending on the logic)
	that tracks whether task_notify_func() is trying to unregister
	itself.  Initialize the flag to zero (in other words, don't bother
	explicitly initializing it).

2.	One entry to task_notify_func(), check the flag.  If set, return
	immediately -- in other words, pretend it never got called.

3.	At the point where task_notify_func() currently calls
	task_handoff_unregister(), set the flag and hand off to a
	work queue (or some similar mechanism).

4.	When the work queue finally does invoke task_handoff_unregister(),
	clear the flag.

5.	If you need to invoke task_handoff_unregister() when the flag
	is set, block until the flag clears.  Perhaps use wait_event()
	on the flag, in which case wake_up() should be used after
	invoking task_handoff_unregister().

Make sense?

							Thanx, Paul

> [ 1921.654064]  [<ffffffff810f89d9>] ? __atomic_notifier_call_chain+0x39/0x110
> [ 1921.656034]  [<ffffffff810c1a30>] ? __put_task_struct+0xc0/0x120
> [ 1921.658625]  [<ffffffff810c71a0>] ? will_become_orphaned_pgrp+0x100/0x100
> [ 1921.661527]  [<ffffffff810f8ac1>] atomic_notifier_call_chain+0x11/0x20
> [ 1921.664295]  [<ffffffff8111ba55>] profile_handoff_task+0x15/0x20
> [ 1921.666885]  [<ffffffff810c19eb>] __put_task_struct+0x7b/0x120
> [ 1921.669492]  [<ffffffff810c71d5>] delayed_put_task_struct+0x35/0x140
> [ 1921.672129]  [<ffffffff81175994>] rcu_do_batch.clone.12+0x224/0xab0
> [ 1921.674697]  [<ffffffff8255ea62>] ? __schedule+0x432/0x890
> [ 1921.677028]  [<ffffffff811783fa>] rcu_cpu_kthread+0x48a/0xa40
> [ 1921.682719]  [<ffffffff82560245>] ? _raw_spin_unlock_irqrestore+0x55/0xa0
> [ 1921.684913]  [<ffffffff81177f70>] ? rcu_idle_enter+0xb0/0xb0
> [ 1921.686641]  [<ffffffff810f11f6>] kthread+0xb6/0xc0
> [ 1921.689956]  [<ffffffff82562cf4>] kernel_thread_helper+0x4/0x10
> [ 1921.692815]  [<ffffffff810fe170>] ? finish_task_switch+0x80/0x110
> [ 1921.695613]  [<ffffffff82561038>] ? retint_restore_args+0x13/0x13
> [ 1921.698409]  [<ffffffff810f1140>] ? kthread_flush_work_fn+0x10/0x10
> [ 1921.701199]  [<ffffffff82562cf0>] ? gs_change+0x13/0x13
> [ 1921.703680] 1 lock held by rcuc/0/7:
> [ 1921.705325]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff810f89d9>] __atomic_notifier_call_chain+0x39/0x110
> [ 1921.710297] Kernel panic - not syncing: hung_task: blocked tasks
> [ 1921.715383] Rebooting in 1 seconds..
> 
> This is the RCU related .config:
> 
> # cat .config | grep RCU
> # RCU Subsystem
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_TRACE=y
> CONFIG_RCU_FANOUT=64
> # CONFIG_RCU_FANOUT_EXACT is not set
> CONFIG_RCU_FAST_NO_HZ=y
> CONFIG_TREE_RCU_TRACE=y
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=1
> CONFIG_RCU_BOOST_DELAY=500
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_PROVE_RCU=y
> CONFIG_PROVE_RCU_REPEATEDLY=y
> CONFIG_SPARSE_RCU_POINTER=y
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> 
> Please let me know if I can help with anything else.
> 
> -- 
> 
> Sasha.
> 

