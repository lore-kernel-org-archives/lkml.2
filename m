Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab1GSOem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:34:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35955 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1GSOel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:34:41 -0400
Date: Tue, 19 Jul 2011 07:28:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ben Greear <greearb@candelatech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: crash in active_task, 3.0-rc6+
Message-ID: <20110719142825.GA2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4E1B3A70.40600@candelatech.com>
 <1311073701.13765.194.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311073701.13765.194.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 01:08:21PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-07-11 at 11:01 -0700, Ben Greear wrote:
> > This is from a lightly patched kernel (nfs related patches)
> > Same system sees lockdep warnings related to scheduling that
> > I've been posting as well...
> > 
> > I haven't seen anything similar in older kernels, so this may
> > be a regression.  We tested .38 in this setup without seeing it,
> > but havn't tested .39.
> > 
> > [root@simech2 ~]# BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> > IP: [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
> > PGD 127082067 PUD 127081067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > CPU 2
> > Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit ip]
> > 
> > Pid: 2203, comm: gnuserver Not tainted 3.0.0-rc6+ #20 Supermicro X7DBU/X7DBU
> > RIP: 0010:[<ffffffff81231bf8>]  [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
> > RSP: 0018:ffff8801104e3628  EFLAGS: 00010096
> > RAX: ffff880126b9e7e0 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: ffff8801104e3668 R08: 0000000000000002 R09: 0000000000000001
> > R10: 000002bf7b96a212 R11: ffff880107481e30 R12: 0000000000000003
> > R13: 0000000000000000 R14: 0000000000000046 R15: 0000000000000002
> > FS:  00007f213f07c720(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000004 CR3: 0000000110519000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process gnuserver (pid: 2203, threadinfo ffff8801104e2000, task ffff880126b9e7e0)
> > Stack:
> >   0000000000000018 0000000000000046 00000000bf3d0800 0000000000000000
> >   0000000000000003 0000000000000000 0000000000000046 0000000000000002
> >   ffff8801104e3698 ffffffff8147e459 ffffffff810a7f25 ffffffff8103d2f7
> > Call Trace:
> >   [<ffffffff8147e459>] _raw_spin_lock+0x3e/0x45
> >   [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
> >   [<ffffffff8103d2f7>] ? activate_task+0x30/0x30
> >   [<ffffffff810a7f25>] __rcu_read_unlock+0xdc/0x24e
> >   [<ffffffff8103d34d>] rcu_read_unlock+0x21/0x23
> >   [<ffffffff8103efd7>] select_task_rq_fair+0x8cc/0x8e1
> >   [<ffffffff81042b59>] ? finish_task_switch+0x78/0xf1
> >   [<ffffffff81042b1b>] ? finish_task_switch+0x3a/0xf1
> >   [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
> >   [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
> >   [<ffffffff81040c52>] select_task_rq+0x13/0x44
> >   [<ffffffff8104697f>] try_to_wake_up+0xd8/0x1a0
> >   [<ffffffff8103c783>] ? __wake_up+0x1d/0x48
> >   [<ffffffff81046a54>] default_wake_function+0xd/0xf
> >   [<ffffffff8106751a>] autoremove_wake_function+0x13/0x38
> >   [<ffffffff810395d0>] __wake_up_common+0x49/0x7f
> >   [<ffffffff8103c79a>] __wake_up+0x34/0x48
> >   [<ffffffff810a74a9>] rcu_report_exp_rnp+0x50/0x89
> >   [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
> >   [<ffffffff810a8032>] __rcu_read_unlock+0x1e9/0x24e
> >   [<ffffffff813fce40>] rcu_read_unlock+0x21/0x23
> >   [<ffffffff813fd52d>] ip_queue_xmit+0x35e/0x3b1
> >   [<ffffffff813fd1cf>] ? ip_send_reply+0x247/0x247
> >   [<ffffffff8140f5f3>] tcp_transmit_skb+0x785/0x7c3
> >   [<ffffffff81411e23>] tcp_write_xmit+0x806/0x8f5
> >   [<ffffffff810e646f>] ? might_fault+0x4e/0x9e
> >   [<ffffffff81403e25>] ? copy_from_user+0x2a/0x2c
> >   [<ffffffff81411f63>] __tcp_push_pending_frames+0x20/0x4d
> >   [<ffffffff8140411f>] tcp_push+0x84/0x86
> >   [<ffffffff81406577>] tcp_sendmsg+0x674/0x775
> >   [<ffffffff81423d68>] inet_sendmsg+0x61/0x6a
> >   [<ffffffff813af67a>] __sock_sendmsg_nosec+0x58/0x61
> >   [<ffffffff813b0db5>] __sock_sendmsg+0x3d/0x48
> >   [<ffffffff813b1631>] sock_sendmsg+0xa3/0xbc
> >   [<ffffffff810ea6ae>] ? handle_pte_fault+0x7fc/0x84d
> >   [<ffffffff81110b14>] ? mem_cgroup_get_limit+0x45/0x45
> >   [<ffffffff8111a4e9>] ? fget_light+0x35/0xac
> >   [<ffffffff813b16b2>] ? sockfd_lookup_light+0x1b/0x53
> >   [<ffffffff813b1bf5>] sys_sendto+0xfa/0x11f
> >   [<ffffffff8147f0d8>] ? retint_restore_args+0x13/0x13
> >   [<ffffffff8109f0a1>] ? audit_syscall_entry+0x119/0x145
> >   [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b
> 
> 
> Fun, that's a recursion we've been poking at for the past few days, but
> I haven't seen it do a NULL-ptr deref like this yet.
> 
> I'm also not quite sure the below patches will catch this particular
> recursion, it might be you need the patch from
> lkml.kernel.org/r/20110718151524.GA4236@linux.vnet.ibm.com as well,
> since this is RCU recursing on itself without the aid of interrupts.
> 
> How reproducable is this? And if so, what's your .config and recipe for
> making it go bang?

Yow!

I bet that the .config includes CONFIG_RCU_BOOST=y.  If so, the following
patch will be needed.  Otherwise, I have no idea how the above sequence
of events happened -- all of the ->rcu_read_unlock_special bits should
be cleared by the time that rcu_report_exp_rnp() is invoked.  Though
the patch that Peter pointed you at on lkml.kernel.org above would likely
make it go away in conjunction with the patch below.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix RCU_BOOST race handling current->rcu_read_unlock_special

The RCU_BOOST commits for TREE_PREEMPT_RCU introduced an other-task
write to a new RCU_READ_UNLOCK_BOOSTED bit in the task_struct structure's
->rcu_read_unlock_special field, but, as noted by Steven Rostedt, without
correctly synchronizing all accesses to ->rcu_read_unlock_special.
This could result in bits in ->rcu_read_unlock_special being spuriously
set and cleared due to conflicting accesses, which in turn could result
in deadlocks between the rcu_node structure's ->lock and the scheduler's
rq and pi locks.  These deadlocks would result from RCU incorrectly
believing that the just-ended RCU read-side critical section had been
preempted and/or boosted.  If that RCU read-side critical section was
executed with either rq or pi locks held, RCU's ensuing (incorrect)
calls to the scheduler would cause the scheduler to attempt to once
again acquire the rq and pi locks, resulting in deadlock.  More complex
deadlock cycles are also possible, involving multiple rq and pi locks
as well as locks from multiple rcu_node structures.

This commit fixes synchronization by creating ->rcu_boosted field in
task_struct that is accessed and modified only when holding the ->lock
in the rcu_node structure on which the task is queued (on that rcu_node
structure's ->blkd_tasks list).  This results in tasks accessing only
their own current->rcu_read_unlock_special fields, making unsynchronized
access once again legal, and keeping the rcu_read_unlock() fastpath free
of atomic instructions and memory barriers.

The reason that the rcu_read_unlock() fastpath does not need to access
the new current->rcu_boosted field is that this new field cannot
be non-zero unless the RCU_READ_UNLOCK_BLOCKED bit is set in the
current->rcu_read_unlock_special field.  Therefore, rcu_read_unlock()
need only test current->rcu_read_unlock_special: if that is zero, then
current->rcu_boosted must also be zero.

This bug does not affect TINY_PREEMPT_RCU because this implementation
of RCU accesses current->rcu_read_unlock_special with irqs disabled,
thus preventing races on the !SMP systems that TINY_PREEMPT_RCU runs on.

Maybe-reported-by: Dave Jones <davej@redhat.com>
Maybe-reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 496770a..76676a4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1254,6 +1254,9 @@ struct task_struct {
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
 	char rcu_read_unlock_special;
+#if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU)
+	int rcu_boosted;
+#endif /* #if defined(CONFIG_RCU_BOOST) && defined(CONFIG_TREE_PREEMPT_RCU) */
 	struct list_head rcu_node_entry;
 #endif /* #ifdef CONFIG_PREEMPT_RCU */
 #ifdef CONFIG_TREE_PREEMPT_RCU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 94a674e..82b3c58 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -342,6 +342,11 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		if (&t->rcu_node_entry == rnp->boost_tasks)
 			rnp->boost_tasks = np;
+		/* Snapshot and clear ->rcu_boosted with rcu_node lock held. */
+		if (t->rcu_boosted) {
+			special |= RCU_READ_UNLOCK_BOOSTED;
+			t->rcu_boosted = 0;
+		}
 #endif /* #ifdef CONFIG_RCU_BOOST */
 		t->rcu_blocked_node = NULL;
 
@@ -358,7 +363,6 @@ static void rcu_read_unlock_special(struct task_struct *t)
 #ifdef CONFIG_RCU_BOOST
 		/* Unboost if we were boosted. */
 		if (special & RCU_READ_UNLOCK_BOOSTED) {
-			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BOOSTED;
 			rt_mutex_unlock(t->rcu_boost_mutex);
 			t->rcu_boost_mutex = NULL;
 		}
@@ -1175,7 +1179,7 @@ static int rcu_boost(struct rcu_node *rnp)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
+	t->rcu_boosted = 1;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
