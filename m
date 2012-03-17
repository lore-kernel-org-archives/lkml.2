Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031094Ab2CQQ5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:57:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36827 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754152Ab2CQQ5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:57:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18VTQMfFGkVQUcxSsUW4SXZWc6NfvS3vvj+zt6Ejq
	RNRRUKIRM8zrDG
Message-ID: <1332003451.8147.77.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] rcu: Permit limiting of force_quiescent_state()
 latency
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sivanich@sgi.com
Date: Sat, 17 Mar 2012 17:57:31 +0100
In-Reply-To: <20120316160328.GA7207@linux.vnet.ibm.com>
References: <20120316160328.GA7207@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 09:03 -0700, Paul E. McKenney wrote: 
> Hello, Dimitri and Mike,
> 
> This one is a first step in limiting RCU-induced latencies for systems
> that have not just NR_CPUS=4096, but also a lot of CPUs.  I have tested
> this using my big-system-simulation setup, but of course testing on
> systems that really are big would be quite valuable.

This didn't work for me.

On a 48 core DL785, with your GP initialization patch applied, and
tracing with irqsoff tracer with box idling along, tracer reports >
200us latencies (tracer overhead alert) from force_qs_rnp() banging on
254 locks.. iow it didn't stop traversing, did a good imitation of a
latency spike.

So I bent it up a little, see below.  I haven't instrumented it yet, and
might have busted it all to pieces, so RFC back.


> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 7247fa8..e99b405 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1685,47 +1685,66 @@ void rcu_check_callbacks(int cpu, int user)
>   * have not yet encountered a quiescent state, using the function specified.
>   * Also initiate boosting for any threads blocked on the root rcu_node.
>   *
> + * Returns 0 if the scan could not be completed, 1 otherwise.
>   * The caller must have suppressed start of new grace periods.
>   */

But it fibs, always returns 1.

> -static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
> +static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  {
>  	unsigned long bit;
>  	int cpu;
> +	int cpusvisited = 0;
>  	unsigned long flags;
>  	unsigned long mask;
>  	struct rcu_node *rnp;
>  
>  	rcu_for_each_leaf_node(rsp, rnp) {
..... 
> 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> -			if ((rnp->qsmask & bit) != 0 &&
> -			    f(per_cpu_ptr(rsp->rda, cpu)))
> +			if ((rnp->qsmask & bit) == 0)
> +				continue;
> +			if (cpu > rcu_get_max_cpu())
> +				goto done;

No unlock.

.... 
> +done:
> +	rsp->fqs_next_cpu = 0;
> +	return 1;
>  }

rsp->fqs_next_cpu = 0 means we start over, no?

WRT FQS_MAX_CPU_VISIT, maybe a read_mostly tweakable instead?  (Like we
don't have enough tweakables lying about)


Anyway, this is what I did.  Setting ARCH_RCU_FQS_LIMIT to 64 on a 48
core box didn't test sip vs gulp logic particularly well, but that
doesn't matter ATM.  The only test done was to boot it and see if it
stopped banging on oodles of locks.

Ok, box has been running rcutorture for ten whole minutes now without
deadlocking or exploding.. ship it, and go have part of a weekend.

<poof>


rcu: Permit limiting of force_quiescent_state() latency

Systems whose cache-miss penalties are large compared to the permitted
per-CPU force_quiescent_state() latency can limit these latencies by
defining CONFIG_ARCH_RCU_FQS_LIMIT to be the maximum number of CPUs
that force_quiescent_state() is permitted to visit per invocation.
If this limit is exceeded, the next CPU to scan is stored into a new
->fqs_next_cpu field in the rcu_state structure, and the existing
->jiffies_force_qs field is set so that the next CPU will re-invoke
force_quiescent_state() rather than waiting a few jiffies.

<snip SOB>
---
 arch/x86/Kconfig |    4 ++++
 kernel/rcutree.c |   48 +++++++++++++++++++++++++++++++++++++++---------
 kernel/rcutree.h |   16 ++++++++++++++++
 3 files changed, 59 insertions(+), 9 deletions(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -254,6 +254,10 @@ config ARCH_CPU_PROBE_RELEASE
 	def_bool y
 	depends on HOTPLUG_CPU && !XEN
 
+config ARCH_RCU_FQS_LIMIT
+	int
+	default 64
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1316,47 +1316,72 @@ void rcu_check_callbacks(int cpu, int us
  * have not yet encountered a quiescent state, using the function specified.
  * Also initiate boosting for any threads blocked on the root rcu_node.
  *
+ * Returns 0 if the scan could not be completed, 1 otherwise.
  * The caller must have suppressed start of new grace periods.
  */
-static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
+static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
+	int cpusvisited = 0, done = 1;
 	unsigned long flags;
 	unsigned long mask;
 	struct rcu_node *rnp;
 
 	rcu_for_each_leaf_node(rsp, rnp) {
+		if (rnp->grphi < rsp->fqs_next_cpu)
+			continue;
+		if (rnp->grplo > rcu_get_max_cpu())
+			continue;
 		mask = 0;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		if (!rcu_gp_in_progress(rsp)) {
 			raw_spin_unlock_irqrestore(&rnp->lock, flags);
-			return;
+			return done;
 		}
 		if (rnp->qsmask == 0) {
 			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
 			continue;
 		}
 		cpu = rnp->grplo;
+		if (cpu < rsp->fqs_next_cpu)
+			cpu = rsp->fqs_next_cpu;
 		bit = 1;
 		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
-			if ((rnp->qsmask & bit) != 0 &&
-			    f(per_cpu_ptr(rsp->rda, cpu)))
+			if ((rnp->qsmask & bit) == 0)
+				continue;
+			if (f(per_cpu_ptr(rsp->rda, cpu)))
 				mask |= bit;
+			rsp->fqs_next_cpu = cpu + 1;
+			if (cpu >= rcu_get_max_cpu())
+				break;
+			if (++cpusvisited >= FQS_MAX_CPU_VISIT) {
+				if (FQS_MAX_CPU_VISIT != NR_CPUS)
+					done = 0;
+				break;
+			}
 		}
 		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
-			continue;
+			if (cpusvisited < FQS_MAX_CPU_VISIT)
+				continue;
 		}
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		if (cpusvisited >= FQS_MAX_CPU_VISIT)
+			break;
 	}
 	rnp = rcu_get_root(rsp);
 	if (rnp->qsmask == 0) {
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
 	}
+
+	if (done)
+		rsp->fqs_next_cpu = 0;
+
+	return done;
 }
 
 /*
@@ -1366,6 +1391,7 @@ static void force_qs_rnp(struct rcu_stat
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
+	int retval;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	if (!rcu_gp_in_progress(rsp))
@@ -1398,21 +1424,25 @@ static void force_quiescent_state(struct
 		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 
 		/* Record dyntick-idle state. */
-		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		retval = force_qs_rnp(rsp, dyntick_save_progress_counter);
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
-		if (rcu_gp_in_progress(rsp))
+		if (rcu_gp_in_progress(rsp) && retval) {
 			rsp->signaled = RCU_FORCE_QS;
+			rsp->fqs_next_cpu = 0;
+		} else if (rcu_gp_in_progress(rsp))
+			rsp->jiffies_force_qs = jiffies - 1;
 		break;
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
 		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
-		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
+		retval = force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
-
 		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
+		if (rcu_gp_in_progress(rsp) && !retval)
+			rsp->jiffies_force_qs = jiffies - 1;
 		break;
 	}
 	rsp->fqs_active = 0;
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -354,6 +354,21 @@ do {									\
 } while (0)
 
 /*
+ * Large latency-sensitive configurations can limit force_quiescent_state()
+ * latencies by defining an CONFIG_ARCH_RCU_FQS_LIMIT.  This should be
+ * sized based on that architecture's cache-miss latency and the maximum
+ * desired force_quiescent_state latency.  For example, if the cache-miss
+ * latency was 100 nanoseconds, and the maximum force_quiescent_state()
+ * latency contribution was 5 microseconds, then that architecture should
+ * define CONFIG_ARCH_RCU_FQS_LIMIT to be 50.
+ */
+#ifdef CONFIG_ARCH_RCU_FQS_LIMIT
+#define FQS_MAX_CPU_VISIT CONFIG_ARCH_RCU_FQS_LIMIT
+#else /* #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
+#define FQS_MAX_CPU_VISIT NR_CPUS
+#endif /* #else #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
+
+/*
  * RCU global state, including node hierarchy.  This hierarchy is
  * represented in "heap" form in a dense array.  The root (first level)
  * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
@@ -391,6 +406,7 @@ struct rcu_state {
 						/*  starting new GP. */
 	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
+	int fqs_next_cpu;			/* Next CPU for fqs to scan. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */


