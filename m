Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1KSAuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:50:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55315 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1KSAuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:50:09 -0500
Date: Fri, 18 Nov 2011 16:50:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] nohz: Remove tick_nohz_idle_enter_norcu() /
 tick_nohz_idle_exit_norcu()
Message-ID: <20111119005003.GA1791@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1321552094-20237-1-git-send-email-fweisbec@gmail.com>
 <20111117201134.GB1865@leaf>
 <20111118010344.GI2429@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118010344.GI2429@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111900-3534-0000-0000-0000023689ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 05:03:44PM -0800, Paul E. McKenney wrote:
> On Thu, Nov 17, 2011 at 12:11:34PM -0800, Josh Triplett wrote:
> > On Thu, Nov 17, 2011 at 06:48:14PM +0100, Frederic Weisbecker wrote:
> > > Those two APIs were provided to optimize the calls of
> > > tick_nohz_idle_enter() and rcu_idle_enter() into a single
> > > irq disabled section. This way no interrupt happening in-between would
> > > needlessly process any RCU job.
> > > 
> > > Now we are talking about an optimization for which benefits
> > > have yet to be measured. Let's start simple and completely decouple
> > > idle rcu and dyntick idle logics to simplify.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Merged, thank you both!

And here is a patch on top of yours to allow nesting of rcu_idle_enter()
and rcu_idle_exit().  Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Allow nesting of rcu_idle_enter() and rcu_idle_exit()

Running user tasks in dyntick-idle mode requires RCU to undergo
an idle-to-non-idle transition on each entry into the kernel, and
vice versa on each exit from the kernel.  However, situations where
user tasks cannot run in dyntick-idle mode (for example, when there
is more than one runnable task on the CPU in question) also require
RCU to undergo an idle-to-non-idle transition when coming out of the
idle loop (and vice versa when entering the idle loop).  In this case,
RCU would see one idle-to-non-idle transition when the task became
runnable, and another when the task executed a system call.

Therefore, rcu_idle_enter() and rcu_idle_exit() must handle nested
calls, which this commit provides for.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu.h b/kernel/rcu.h
index aa88baa..8a76a5b 100644
--- a/kernel/rcu.h
+++ b/kernel/rcu.h
@@ -33,8 +33,24 @@
  * Process-level increment to ->dynticks_nesting field.  This allows for
  * architectures that use half-interrupts and half-exceptions from
  * process context.
+ *
+ * DYNTICK_TASK_NESTING_MASK is a three-bit field that counts the number
+ * of process-based reasons why RCU cannot consider the corresponding CPU
+ * to be idle, and DYNTICK_TASK_NESTING_VALUE is the value used to increment
+ * or decrement this three-bit field.  The rest of the bits could in
+ * principle be used to count interrupts, but this would mean that a
+ * negative-one value in the interrupt field could incorrectly zero out
+ * the DYNTICK_TASK_NESTING_MASK field.  We therefore provide a two-bit
+ * guard field defined by DYNTICK_TASK_MASK that is set to DYNTICK_TASK_FLAG
+ * upon initial exit from idle.  The DYNTICK_TASK_EXIT_IDLE value is
+ * thus the combined value used upon initial exit from idle.
  */
-#define DYNTICK_TASK_NESTING (LLONG_MAX / 2 - 1)
+#define DYNTICK_TASK_NESTING_VALUE (LLONG_MAX / 8 + 1)
+#define DYNTICK_TASK_NESTING_MASK  (LLONG_MAX - DYNTICK_TASK_NESTING_VALUE + 1)
+#define DYNTICK_TASK_FLAG	   ((DYNTICK_TASK_NESTING_VALUE / 8) * 2)
+#define DYNTICK_TASK_MASK	   ((DYNTICK_TASK_NESTING_VALUE / 8) * 3)
+#define DYNTICK_TASK_EXIT_IDLE	   (DYNTICK_TASK_NESTING_VALUE + \
+				    DYNTICK_TASK_FLAG)
 
 /*
  * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index e5bd949..10523d6 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -53,7 +53,7 @@ static void __call_rcu(struct rcu_head *head,
 
 #include "rcutiny_plugin.h"
 
-static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+static long long rcu_dynticks_nesting = DYNTICK_TASK_NESTING_VALUE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
 static void rcu_idle_enter_common(long long oldval)
@@ -88,7 +88,12 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting = 0;
+	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK) == 0);
+	if ((rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK) ==
+	    DYNTICK_TASK_NESTING_VALUE)
+		rcu_dynticks_nesting = 0;
+	else
+		rcu_dynticks_nesting  -= DYNTICK_TASK_NESTING_VALUE;
 	rcu_idle_enter_common(oldval);
 	local_irq_restore(flags);
 }
@@ -140,8 +145,11 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	oldval = rcu_dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rcu_dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
+	if (rcu_dynticks_nesting & DYNTICK_TASK_NESTING_MASK)
+		rcu_dynticks_nesting += DYNTICK_TASK_NESTING_VALUE;
+	else
+		rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(oldval);
 	local_irq_restore(flags);
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7fb8b0e..f1a3379 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -196,7 +196,7 @@ void rcu_note_context_switch(int cpu)
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-	.dynticks_nesting = DYNTICK_TASK_NESTING,
+	.dynticks_nesting = DYNTICK_TASK_NESTING_VALUE,
 	.dynticks = ATOMIC_INIT(1),
 };
 
@@ -394,7 +394,11 @@ void rcu_idle_enter(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	rdtp->dynticks_nesting = 0;
+	WARN_ON_ONCE((oldval & DYNTICK_TASK_NESTING_MASK) == 0);
+	if ((oldval & DYNTICK_TASK_NESTING_MASK) == DYNTICK_TASK_NESTING_VALUE)
+		rdtp->dynticks_nesting = 0;
+	else
+		rdtp->dynticks_nesting -= DYNTICK_TASK_NESTING_VALUE;
 	rcu_idle_enter_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
@@ -481,8 +485,11 @@ void rcu_idle_exit(void)
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	oldval = rdtp->dynticks_nesting;
-	WARN_ON_ONCE(oldval != 0);
-	rdtp->dynticks_nesting = DYNTICK_TASK_NESTING;
+	WARN_ON_ONCE(oldval < 0);
+	if (oldval & DYNTICK_TASK_NESTING_MASK)
+		rdtp->dynticks_nesting += DYNTICK_TASK_NESTING_VALUE;
+	else
+		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_idle_exit_common(rdtp, oldval);
 	local_irq_restore(flags);
 }
@@ -2028,7 +2035,8 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rdp->qlen = 0;
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
+	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting !=
+		     DYNTICK_TASK_NESTING_VALUE);
 	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
 	rdp->cpu = cpu;
 	rdp->rsp = rsp;
@@ -2056,8 +2064,10 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_NESTING);
+	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_NESTING_VALUE;
 	WARN_ON_ONCE((atomic_read(&rdp->dynticks->dynticks) & 0x1) != 1);
+	atomic_set(&rdp->dynticks->dynticks,
+		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*

