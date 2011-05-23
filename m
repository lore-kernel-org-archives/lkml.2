Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030953Ab1EWVZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:25:37 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37077 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030705Ab1EWVZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:25:34 -0400
Date: Mon, 23 May 2011 14:25:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110523212530.GF7428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD6D746.6070107@kernel.org>
 <20110520224250.GL2366@linux.vnet.ibm.com>
 <4DD6F4A2.1070401@kernel.org>
 <20110520231428.GN2366@linux.vnet.ibm.com>
 <4DD6F64C.3030402@kernel.org>
 <20110520234923.GQ2366@linux.vnet.ibm.com>
 <4DD70120.9090801@kernel.org>
 <20110521131844.GE2271@linux.vnet.ibm.com>
 <20110521140845.GA12157@linux.vnet.ibm.com>
 <4DDAC01E.7050602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDAC01E.7050602@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:14:22PM -0700, Yinghai Lu wrote:
> On 05/21/2011 07:08 AM, Paul E. McKenney wrote:
> > On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
> >> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
> >>> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> >>>> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
> >>> ...
> >>>>>
> >>>>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> >>>>
> >>>> OK, just to make sure I understand...  You are compiling exactly the
> >>>> same kernel source tree with exactly the same .config, just with two
> >>>> different versions of gcc, correct?
> >>> yes.
> >>>>
> >>>> If so, it is quite possible that the slow one is the correct one.  :-/
> >>> yeah, new version always have problem.
> >>>
> >>> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
> >>
> >> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
> >> one (4.5.0), correct?
> > 
> > And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
> > tidied up RCU kthreads' scheduler interactions.  The patch is below,
> > though it is probably more convenient to pull it from the rcu/next
> > branch of:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > 

Thank you for testing this!

This is with the same config that you emailed out on May 12th?

In particular, CONFIG_TREE_RCU=y?

> [  337.132517] INFO: task rcun0:8 blocked for more than 120 seconds.
> [  337.133238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  337.160396] rcun0           D 0000000000000000     0     8      2 0x00000000
> [  337.161232]  ffff882070d3fe90 0000000000000046 ffff882070d3e000 0000000000004000
> [  337.161291]  00000000001d1f80 ffff882070d3ffd8 00000000001d1f80 ffff882070d3ffd8
> [  337.161348]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff882070d422b0
> [  337.161404] Call Trace:
> [  337.161433]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
> [  337.161459]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> [  337.161486]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  337.161512]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
> [  337.161533]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> [  337.161558]  [<ffffffff81099e41>] kthread+0x8c/0xa8
> [  337.161584]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
> [  337.161606]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
> [  337.161627]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
> [  337.161645]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
> [  337.161651] no locks held by rcun0/8.

This is quite surprising.  The "rcun" kthreads invoke rcu_node_kthread(),
which does not call rcu_cpu_kthread_should_stop().

But perhaps the stack backtrace got confused.

Could you please try the following diagnostic patch to help me work out
where the rcun threads are getting stuck?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2868ea..50883dd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1675,11 +1675,15 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
+		printk(KERN_INFO "rcun %p starting wait for work.\n", rnp);
 		rcu_wait(atomic_read(&rnp->wakemask) != 0);
+		printk(KERN_INFO "rcun %p completed wait for work.\n", rnp);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = atomic_xchg(&rnp->wakemask, 0);
+		printk(KERN_INFO "rcun %p initiating boost.\n", rnp);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+		printk(KERN_INFO "rcun %p completed boost.\n", rnp);
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
 				continue;
@@ -1689,10 +1693,12 @@ static int rcu_node_kthread(void *arg)
 				preempt_enable();
 				continue;
 			}
+			printk(KERN_INFO "rcun %p awaking rcuc%d.\n", rnp, cpu);
 			per_cpu(rcu_cpu_has_work, cpu) = 1;
 			sp.sched_priority = RCU_KTHREAD_PRIO;
 			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 			preempt_enable();
+			printk(KERN_INFO "rcun %p awakened rcuc%d.\n", rnp, cpu);
 		}
 	}
 	/* NOTREACHED */
