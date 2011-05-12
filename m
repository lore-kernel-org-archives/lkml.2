Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1ELH1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:27:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21139 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1ELH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:27:50 -0400
Message-ID: <4DCB8BCD.1080607@kernel.org>
Date: Thu, 12 May 2011 00:27:09 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
References: <20110510085623.GG2258@linux.vnet.ibm.com> <4DC97E49.7040401@kernel.org> <20110510193216.GN2258@linux.vnet.ibm.com> <4DC9A5A4.1050308@kernel.org> <20110511045443.GS2258@linux.vnet.ibm.com> <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com> <20110511201852.GC2258@linux.vnet.ibm.com> <4DCAF894.7030707@kernel.org> <4DCAFFD8.2080605@kernel.org> <4DCB157F.20202@kernel.org> <20110512060344.GB3191@elte.hu>
In-Reply-To: <20110512060344.GB3191@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DCB8BE1.00C7,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 11:03 PM, Ingo Molnar wrote:
> 
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
>> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
>> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Date:   Tue Sep 7 10:38:22 2010 -0700
>>
>>     rcu: Decrease memory-barrier usage based on semi-formal proof
> 
> Find below an (untested!) attempt at reverting it for debugging purposes: could 
> you please try it, does your system now boot up fine?
> 
> Thanks,
> 
> 	Ingo
> 

yes, reverted manually that commit fix the problem.

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..ed59987 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -162,7 +162,7 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = 1,
-	.dynticks = ATOMIC_INIT(1),
+	.dynticks = 1,
 };
 #endif /* #ifdef CONFIG_NO_HZ */
 
@@ -321,25 +321,13 @@ void rcu_enter_nohz(void)
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (--rdtp->dynticks_nesting) {
-		local_irq_restore(flags);
-		return;
-	}
-	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting--;
+	WARN_ON_ONCE(rdtp->dynticks & 0x1);
 	local_irq_restore(flags);
-
-	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (in_irq() &&
-	    (__get_cpu_var(rcu_sched_data).nxtlist ||
-	     __get_cpu_var(rcu_bh_data).nxtlist ||
-	     rcu_preempt_needs_cpu(smp_processor_id())))
-		set_need_resched();
 }
 
 /*
@@ -355,16 +343,11 @@ void rcu_exit_nohz(void)
 
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
-	if (rdtp->dynticks_nesting++) {
-		local_irq_restore(flags);
-		return;
-	}
-	smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
-	atomic_inc(&rdtp->dynticks);
-	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting++;
+	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
 	local_irq_restore(flags);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
 /**
@@ -378,15 +361,11 @@ void rcu_nmi_enter(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks_nmi_nesting == 0 &&
-	    (atomic_read(&rdtp->dynticks) & 0x1))
+	if (rdtp->dynticks & 0x1)
 		return;
-	rdtp->dynticks_nmi_nesting++;
-	smp_mb__before_atomic_inc();  /* Force delay from prior write. */
-	atomic_inc(&rdtp->dynticks);
-	/* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
-	smp_mb__after_atomic_inc();  /* See above. */
-	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
+	rdtp->dynticks_nmi++;
+	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
 /**
@@ -400,14 +379,11 @@ void rcu_nmi_exit(void)
 {
 	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
 
-	if (rdtp->dynticks_nmi_nesting == 0 ||
-	    --rdtp->dynticks_nmi_nesting != 0)
+	if (rdtp->dynticks & 0x1)
 		return;
-	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
-	smp_mb__before_atomic_inc();  /* See above. */
-	atomic_inc(&rdtp->dynticks);
-	smp_mb__after_atomic_inc();  /* Force delay to next write. */
-	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks_nmi++;
+	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
 }
 
 /**
@@ -418,7 +394,13 @@ void rcu_nmi_exit(void)
  */
 void rcu_irq_enter(void)
 {
-	rcu_exit_nohz();
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks_nesting++)
+		return;
+	rdtp->dynticks++;
+	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
 /**
@@ -430,7 +412,18 @@ void rcu_irq_enter(void)
  */
 void rcu_irq_exit(void)
 {
-	rcu_enter_nohz();
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (--rdtp->dynticks_nesting)
+		return;
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks++;
+	WARN_ON_ONCE(rdtp->dynticks & 0x1);
+
+	/* If the interrupt queued a callback, get out of dyntick mode. */
+	if (__this_cpu_read(rcu_sched_data.nxtlist) ||
+	    __this_cpu_read(rcu_bh_data.nxtlist))
+		set_need_resched();
 }
 
 #ifdef CONFIG_SMP
@@ -442,8 +435,19 @@ void rcu_irq_exit(void)
  */
 static int dyntick_save_progress_counter(struct rcu_data *rdp)
 {
-	rdp->dynticks_snap = atomic_add_return(0, &rdp->dynticks->dynticks);
-	return 0;
+	int ret;
+	int snap;
+	int snap_nmi;
+
+	snap = rdp->dynticks->dynticks;
+	snap_nmi = rdp->dynticks->dynticks_nmi;
+	smp_mb();	/* Order sampling of snap with end of grace period. */
+	rdp->dynticks_snap = snap;
+	rdp->dynticks_nmi_snap = snap_nmi;
+	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
+	if (ret)
+		rdp->dynticks_fqs++;
+	return ret;
 }
 
 /*
@@ -454,11 +458,16 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
-	unsigned long curr;
-	unsigned long snap;
+	long curr;
+	long curr_nmi;
+	long snap;
+	long snap_nmi;
 
-	curr = (unsigned long)atomic_add_return(0, &rdp->dynticks->dynticks);
-	snap = (unsigned long)rdp->dynticks_snap;
+	curr = rdp->dynticks->dynticks;
+	snap = rdp->dynticks_snap;
+	curr_nmi = rdp->dynticks->dynticks_nmi;
+	snap_nmi = rdp->dynticks_nmi_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
 
 	/*
 	 * If the CPU passed through or entered a dynticks idle phase with
@@ -468,7 +477,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
+	if ((curr != snap || (curr & 0x1) == 0) &&
+	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
 		rdp->dynticks_fqs++;
 		return 1;
 	}
@@ -898,11 +908,6 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
 
-	/*
-	 * Ensure that all grace-period and pre-grace-period activity
-	 * is seen before the assignment to rsp->completed.
-	 */
-	smp_mb(); /* See above block comment. */
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1450,11 +1455,25 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
  */
 static void rcu_process_callbacks(void)
 {
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be seen before any RCU
+	 * grace-period manipulations below.
+	 */
+	smp_mb(); /* See above block comment. */
+
 	__rcu_process_callbacks(&rcu_sched_state,
 				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
 	rcu_preempt_process_callbacks();
 
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be seen after any RCU
+	 * grace-period manipulations above.
+	 */
+	smp_mb(); /* See above block comment. */
+
 	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
 	rcu_needs_cpu_flush();
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 93d4a1c..2576648 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -84,9 +84,11 @@
  * Dynticks per-CPU state.
  */
 struct rcu_dynticks {
-	int dynticks_nesting;	/* Track irq/process nesting level. */
-	int dynticks_nmi_nesting; /* Track NMI nesting level. */
-	atomic_t dynticks;	/* Even value for dynticks-idle, else odd. */
+	int dynticks_nesting;	/* Track nesting level, sort of. */
+	int dynticks;		/* Even value for dynticks-idle, else odd. */
+	int dynticks_nmi;	/* Even value for either dynticks-idle or */
+				/*  not in nmi handler, else odd.  So this */
+				/*  remains even for nmi from irq handler. */
 };
 
 /* RCU's kthread states for tracing. */
@@ -282,6 +284,7 @@ struct rcu_data {
 	/* 3) dynticks interface. */
 	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
 	int dynticks_snap;		/* Per-GP tracking for dynticks. */
+	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
 #endif /* #ifdef CONFIG_NO_HZ */
 
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ed33970..3f6559a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1520,6 +1520,7 @@ int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
 	int snap;
+	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1530,10 +1531,10 @@ int rcu_needs_cpu(int cpu)
 	for_each_online_cpu(thatcpu) {
 		if (thatcpu == cpu)
 			continue;
-		snap = atomic_add_return(0, &per_cpu(rcu_dynticks,
-						     thatcpu).dynticks);
+		snap = per_cpu(rcu_dynticks, thatcpu).dynticks;
+		snap_nmi = per_cpu(rcu_dynticks, thatcpu).dynticks_nmi;
 		smp_mb(); /* Order sampling of snap with end of grace period. */
-		if ((snap & 0x1) != 0) {
+		if (((snap & 0x1) != 0) || ((snap_nmi & 0x1) != 0)) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9678cc3..aa0fd72 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -69,10 +69,10 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
-	seq_printf(m, " dt=%d/%d/%d df=%lu",
-		   atomic_read(&rdp->dynticks->dynticks),
+	seq_printf(m, " dt=%d/%d dn=%d df=%lu",
+		   rdp->dynticks->dynticks,
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi_nesting,
+		   rdp->dynticks->dynticks_nmi,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
@@ -141,9 +141,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->qs_pending);
 #ifdef CONFIG_NO_HZ
 	seq_printf(m, ",%d,%d,%d,%lu",
-		   atomic_read(&rdp->dynticks->dynticks),
+		   rdp->dynticks->dynticks,
 		   rdp->dynticks->dynticks_nesting,
-		   rdp->dynticks->dynticks_nmi_nesting,
+		   rdp->dynticks->dynticks_nmi,
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
@@ -167,7 +167,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",");
 #ifdef CONFIG_NO_HZ
-	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
+	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\",\"ci\",\"co\",\"ca\"\n");
 #ifdef CONFIG_TREE_PREEMPT_RCU
