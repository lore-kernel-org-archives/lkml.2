Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2HUTWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:22:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45229 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2HUTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:22:13 -0400
Date: Tue, 21 Aug 2012 12:21:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: lockdep warning on rt_mutex_lock()
Message-ID: <20120821192149.GM2456@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120817100635.GA30765@localhost>
 <20120817134328.GB2872@linux.vnet.ibm.com>
 <20120817140240.GB539@localhost>
 <20120817144437.GC2872@linux.vnet.ibm.com>
 <20120818045908.GA7503@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120818045908.GA7503@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082119-7606-0000-0000-000002FC076E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 12:59:08PM +0800, Fengguang Wu wrote:
> On Fri, Aug 17, 2012 at 07:44:37AM -0700, Paul E. McKenney wrote:
> > On Fri, Aug 17, 2012 at 10:02:40PM +0800, Fengguang Wu wrote:
> > > On Fri, Aug 17, 2012 at 06:43:28AM -0700, Paul E. McKenney wrote:
> > > > On Fri, Aug 17, 2012 at 06:06:35PM +0800, Fengguang Wu wrote:
> > > > > Greetings,
> > > > > 
> > > > > FYI, a lockdep warning:
> > > > 
> > > > Certainly looks problematic!
> > > > 
> > > > Any hint as to what version of the kernel produced this splat?
> > > > (Yes, lazy of me to ask, I know, but I am not seeing it in my testing.)
> > > 
> > > It happens on both 3.5.0 and 3.6-rc1. Will bisect (try older kernels) help?
> > > Bisect is handy for me :)
> > 
> > Bisection would be very welcome!!!  ;-)
> 
> The bisect result is...

Hmmm...  This patch is a bit of a blast from the past.

> commit 9e571a82f0cb205a65a0ea41657f19f22b7fabb8
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Thu Sep 30 21:26:52 2010 -0700
> 
>     rcu: add tracing for TINY_RCU and TINY_PREEMPT_RCU
>     
>     Add tracing for the tiny RCU implementations, including statistics on
>     boosting in the case of TINY_PREEMPT_RCU and RCU_BOOST.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

So the lockdep complaint indicates that lockdep and the actual hardware
had different opinions about whether or not interrupts were enabled.
One way that can happen is through use of raw_local_irq_save().  And this
commit did add a raw_local_irq_save().

So maybe converting to local_irq_save() will make things work better.

Fengguang, could you please try out the following patch?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Move TINY_PREEMPT_RCU away from raw_local_irq_save()

The use of raw_local_irq_save() is unnecessary, given that local_irq_save()
really does disable interrupts.  Also, it appears to interfere with lockdep.
Therefore, this commit moves to local_irq_save().

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 918fd1e..3d01902 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -278,7 +278,7 @@ static int rcu_boost(void)
 	    rcu_preempt_ctrlblk.exp_tasks == NULL)
 		return 0;  /* Nothing to boost. */
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 
 	/*
 	 * Recheck with irqs disabled: all tasks in need of boosting
@@ -287,7 +287,7 @@ static int rcu_boost(void)
 	 */
 	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
 	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
-		raw_local_irq_restore(flags);
+		local_irq_restore(flags);
 		return 0;
 	}
 
@@ -317,7 +317,7 @@ static int rcu_boost(void)
 	t = container_of(tb, struct task_struct, rcu_node_entry);
 	rt_mutex_init_proxy_locked(&mtx, t);
 	t->rcu_boost_mutex = &mtx;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 	rt_mutex_lock(&mtx);
 	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
 
@@ -991,9 +991,9 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
 {
 	unsigned long flags;
 
-	raw_local_irq_save(flags);
+	local_irq_save(flags);
 	rcp->qlen -= n;
-	raw_local_irq_restore(flags);
+	local_irq_restore(flags);
 }
 
 /*

