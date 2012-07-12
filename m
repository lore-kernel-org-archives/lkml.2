Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100Ab2GLQnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:43:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38224 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab2GLQnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:43:45 -0400
Date: Thu, 12 Jul 2012 09:43:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120712164308.GA31584@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120711074924.GD3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071216-5518-0000-0000-000005FC0968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > Hi Paul,
> > 
> > Fortunately this bug is bisectable and the first bad commit is:
> > 
> >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > 
> >             rcu: Track idleness independent of idle tasks
> 
> OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> traces while in idle.  The confusion on my part was that in TREE_RCU,
> the nesting and dyntick-idle indication are different, while in
> TINY_RCU they are one and the same.
> 
> Does the following patch help?

This one failed in my testing.  Please see the end for the fixed
version, with on small but important change.

							Thanx, Paul

> ------------------------------------------------------------------------
> 
> rcu: Pull TINY_RCU dyntick-idle tracing into non-idle region
> 
> Because TINY_RCU's idle detection keys directly off of the nesting
> level, rather than from a separate variable as in TREE_RCU, the
> TINY_RCU dyntick-idle tracing on transition to idle must happen
> before the change to the nesting level.  This commit therefore makes
> this change by passing the desired new value (rather than the old value)
> of the nesting level in to rcu_idle_enter_common().
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
> index 547b1fe..ca3741d 100644
> --- a/kernel/rcutiny.c
> +++ b/kernel/rcutiny.c
> @@ -56,24 +56,26 @@ static void __call_rcu(struct rcu_head *head,
>  static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
>  
>  /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
> -static void rcu_idle_enter_common(long long oldval)
> +static void rcu_idle_enter_common(long long newval)
>  {
>  	if (rcu_dynticks_nesting) {
>  		RCU_TRACE(trace_rcu_dyntick("--=",
> -					    oldval, rcu_dynticks_nesting));
> +					    rcu_dynticks_nesting, newval));
>  		return;
>  	}
> -	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
> +	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
>  	if (!is_idle_task(current)) {
>  		struct task_struct *idle = idle_task(smp_processor_id());
>  
>  		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
> -					    oldval, rcu_dynticks_nesting));
> +					    rcu_dynticks_nesting, newval));
>  		ftrace_dump(DUMP_ALL);
>  		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
>  			  current->pid, current->comm,
>  			  idle->pid, idle->comm); /* must be idle task! */
>  	}
> +	barrier();
> +	rcu_dynticks_nesting = newval;
>  	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
>  }
>  
> @@ -84,17 +86,16 @@ static void rcu_idle_enter_common(long long oldval)
>  void rcu_idle_enter(void)
>  {
>  	unsigned long flags;
> -	long long oldval;
> +	long long newval;
>  
>  	local_irq_save(flags);
> -	oldval = rcu_dynticks_nesting;
>  	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
>  	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
>  	    DYNTICK_TASK_NEST_VALUE)
> -		rcu_dynticks_nesting = 0;
> +		newval = 0;
>  	else
> -		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
> -	rcu_idle_enter_common(oldval);
> +		newval = rcu_dynticks_nesting - DYNTICK_TASK_NEST_VALUE;
> +	rcu_idle_enter_common(newval);
>  	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> @@ -105,13 +106,12 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
>  void rcu_irq_exit(void)
>  {
>  	unsigned long flags;
> -	long long oldval;
> +	long long newval;
>  
>  	local_irq_save(flags);
> -	oldval = rcu_dynticks_nesting;
> -	rcu_dynticks_nesting--;
> -	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
> -	rcu_idle_enter_common(oldval);
> +	newval = rcu_dynticks_nesting - 1;
> +	WARN_ON_ONCE(newval < 0);
> +	rcu_idle_enter_common(newval);
>  	local_irq_restore(flags);
>  }

------------------------------------------------------------------------

rcu: Pull TINY_RCU dyntick-idle tracing into non-idle region

Because TINY_RCU's idle detection keys directly off of the nesting
level, rather than from a separate variable as in TREE_RCU, the
TINY_RCU dyntick-idle tracing on transition to idle must happen
before the change to the nesting level.  This commit therefore makes
this change by passing the desired new value (rather than the old value)
of the nesting level in to rcu_idle_enter_common().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 547b1fe..31a10f9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -56,24 +56,27 @@ static void __call_rcu(struct rcu_head *head,
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
-static void rcu_idle_enter_common(long long oldval)
+static void rcu_idle_enter_common(long long newval)
 {
 	if (rcu_dynticks_nesting) {
 		RCU_TRACE(trace_rcu_dyntick("--=",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
+		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	barrier();
+	rcu_dynticks_nesting = newval;
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
 
@@ -84,17 +87,16 @@ static void rcu_idle_enter_common(long long oldval)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
 	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
 	    DYNTICK_TASK_NEST_VALUE)
-		rcu_dynticks_nesting = 0;
+		newval = 0;
 	else
-		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(oldval);
+		newval = rcu_dynticks_nesting - DYNTICK_TASK_NEST_VALUE;
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -105,13 +107,12 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting--;
-	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
-	rcu_idle_enter_common(oldval);
+	newval = rcu_dynticks_nesting - 1;
+	WARN_ON_ONCE(newval < 0);
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 

