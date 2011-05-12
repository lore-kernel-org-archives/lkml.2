Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1ELGD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:03:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39060 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab1ELGD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:03:58 -0400
Date: Thu, 12 May 2011 08:03:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110512060344.GB3191@elte.hu>
References: <20110510085623.GG2258@linux.vnet.ibm.com>
 <4DC97E49.7040401@kernel.org>
 <20110510193216.GN2258@linux.vnet.ibm.com>
 <4DC9A5A4.1050308@kernel.org>
 <20110511045443.GS2258@linux.vnet.ibm.com>
 <BANLkTi=r707A9yy5-7+dw3Hozt=G1HBQ-Q@mail.gmail.com>
 <20110511201852.GC2258@linux.vnet.ibm.com>
 <4DCAF894.7030707@kernel.org>
 <4DCAFFD8.2080605@kernel.org>
 <4DCB157F.20202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCB157F.20202@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> e59fb3120becfb36b22ddb8bd27d065d3cdca499 is the first bad commit
> commit e59fb3120becfb36b22ddb8bd27d065d3cdca499
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Tue Sep 7 10:38:22 2010 -0700
> 
>     rcu: Decrease memory-barrier usage based on semi-formal proof

Find below an (untested!) attempt at reverting it for debugging purposes: could 
you please try it, does your system now boot up fine?

Thanks,

	Ingo

----------------------------->
>From bce6fbbda040d4b0783cf59b5a9b7601bdf011bd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 12 May 2011 08:02:05 +0200
Subject: [PATCH] Revert "rcu: Decrease memory-barrier usage based on semi-formal proof"

This reverts commit e59fb3120becfb36b22ddb8bd27d065d3cdca499.

Conflicts:

	Documentation/RCU/trace.txt
	kernel/rcutree.c
---
 Documentation/RCU/trace.txt |   78 ++++++++++++--------------
 kernel/rcutree.c            |  130 ++++++++++++++++++++++++------------------
 kernel/rcutree.h            |    9 ++-
 kernel/rcutree_plugin.h     |    7 +-
 kernel/rcutree_trace.c      |   12 ++--
 5 files changed, 126 insertions(+), 110 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 8173cec..2b4d887 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -10,46 +10,34 @@ for rcutree and next for rcutiny.
 
 CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU debugfs Files and Formats
 
-These implementations of RCU provides several debugfs files under the
-top-level directory "rcu":
-
-rcu/rcudata:
-	Displays fields in struct rcu_data.
-rcu/rcudata.csv:
-	Comma-separated values spreadsheet version of rcudata.
-rcu/rcugp:
-	Displays grace-period counters.
-rcu/rcuhier:
-	Displays the struct rcu_node hierarchy.
-rcu/rcu_pending:
-	Displays counts of the reasons rcu_pending() decided that RCU had
-	work to do.
-rcu/rcutorture:
-	Displays rcutorture test progress.
-rcu/rcuboost:
-	Displays RCU boosting statistics.  Only present if
-	CONFIG_RCU_BOOST=y.
+These implementations of RCU provides five debugfs files under the
+top-level directory RCU: rcu/rcudata (which displays fields in struct
+rcu_data), rcu/rcudata.csv (which is a .csv spreadsheet version of
+rcu/rcudata), rcu/rcugp (which displays grace-period counters),
+rcu/rcuhier (which displays the struct rcu_node hierarchy), and
+rcu/rcu_pending (which displays counts of the reasons that the
+rcu_pending() function decided that there was core RCU work to do).
 
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pqc=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pqc=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
+  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
+  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
+  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
+  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
+  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
+  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
+  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pqc=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
+  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
+  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
+  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -94,16 +82,22 @@ o	"pqc" indicates which grace period the last-observed quiescent
 	the next grace period!
 
 o	"qp" indicates that RCU still expects a quiescent state from
-	this CPU.  Offlined CPUs and CPUs in dyntick idle mode might
-	well have qp=1, which is OK: RCU is still ignoring them.
+	this CPU.
 
 o	"dt" is the current value of the dyntick counter that is incremented
 	when entering or leaving dynticks idle state, either by the
-	scheduler or by irq.  This number is even if the CPU is in
-	dyntick idle mode and odd otherwise.  The number after the first
-	"/" is the interrupt nesting depth when in dyntick-idle state,
-	or one greater than the interrupt-nesting depth otherwise.
-	The number after the second "/" is the NMI nesting depth.
+	scheduler or by irq.  The number after the "/" is the interrupt
+	nesting depth when in dyntick-idle state, or one greater than
+	the interrupt-nesting depth otherwise.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"dn" is the current value of the dyntick counter that is incremented
+	when entering or leaving dynticks idle state via NMI.  If both
+	the "dt" and "dn" values are even, then this CPU is in dynticks
+	idle mode and may be ignored by RCU.  If either of these two
+	counters is odd, then RCU must be alert to the possibility of
+	an RCU read-side critical section running on this CPU.
 
 	This field is displayed only for CONFIG_NO_HZ kernels.
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..e486f7c 100644
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
@@ -897,12 +907,6 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	unsigned long gp_duration;
 
 	WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
-
-	/*
-	 * Ensure that all grace-period and pre-grace-period activity
-	 * is seen before the assignment to rsp->completed.
-	 */
-	smp_mb(); /* See above block comment. */
 	gp_duration = jiffies - rsp->gp_start;
 	if (gp_duration > rsp->gp_max)
 		rsp->gp_max = gp_duration;
@@ -1450,11 +1454,25 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
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
index ed339702..3f6559a 100644
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
