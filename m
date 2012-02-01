Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab2BATps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:45:48 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56194 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab2BATpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:45:45 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 39/41] rcu: Wait at least a jiffy before declaring a CPU to be offline
Date: Wed,  1 Feb 2012 11:41:57 -0800
Message-Id: <1328125319-5205-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F304EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The force_quiescent_state() function uses a state machine to help
force grace periods to completion.  One of its responsibilities is to
detect offline CPUs, and to report quiescent states on their behalf.
However, the CPU hotplug process is not atomic, in fact, there is
significant uncertainty as to exactly when a given CPU came online or
went offline.  For example, once a CPU has marked itself offline and
executed the CPU_DYING notifiers, it continues executing, entering
the scheduler and perhaps also the idle loop.

In the old days, force_quiescent_state() was guaranteed to wait for
several jiffies before declaring a given CPU offline.  This is no
longer the case, due to some of the more aggressive rcutorture tests
and the CONFIG_RCU_FAST_NO_HZ idle-entry code.  Therefore, this commit
makes force_quiescent_state() explicitly wait for at least a jiffy
before declaring a CPU to be offline.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   36 ++++++++++++++++--------------------
 kernel/rcutree.c            |   21 +++++++--------------
 kernel/rcutree.h            |    1 -
 kernel/rcutree_trace.c      |    6 +++---
 4 files changed, 26 insertions(+), 38 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 49587ab..f6f15ce 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -33,23 +33,23 @@ rcu/rcuboost:
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
-  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
-  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
-  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
-  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
-  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
-  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
-  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
+  0 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=545/1/0 df=50 of=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=967/1/0 df=58 of=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1081/1/0 df=175 of=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pgp=20942 qp=1 dt=1846/0/0 df=404 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=369/1/0 df=83 of=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=381/1/0 df=64 of=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pgp=20973 qp=0 dt=1037/1/0 df=183 of=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pgp=20896 qp=0 dt=1572/0/0 df=382 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
-  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
-  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
-  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
-  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
-  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
-  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
-  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=545/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=967/1/0 df=3 of=0 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1081/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1846/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=369/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=381/1/0 df=4 of=0 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pgp=1480 qp=0 dt=1037/1/0 df=6 of=0 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pgp=1473 qp=0 dt=1572/0/0 df=8 of=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -119,10 +119,6 @@ o	"of" is the number of times that some other CPU has forced a
 	CPU is offline when it is really alive and kicking) is a fatal
 	error, so it makes sense to err conservatively.
 
-o	"ri" is the number of times that RCU has seen fit to send a
-	reschedule IPI to this CPU in order to get it to report a
-	quiescent state.
-
 o	"ql" is the number of RCU callbacks currently residing on
 	this CPU.  This is the total number of callbacks, regardless
 	of what state they are in (new, waiting for grace period to
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ce39431..5f71cd1 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -320,25 +320,18 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 {
 	/*
-	 * If the CPU is offline, it is in a quiescent state.  We can
-	 * trust its state not to change because interrupts are disabled.
+	 * If the CPU is offline for more than a jiffy, it is in a quiescent
+	 * state.  We can trust its state not to change because interrupts
+	 * are disabled.  The reason for the jiffy's worth of slack is to
+	 * handle CPUs initializing on the way up and finding their way
+	 * to the idle loop on the way down.
 	 */
-	if (cpu_is_offline(rdp->cpu)) {
+	if (cpu_is_offline(rdp->cpu) &&
+	    ULONG_CMP_LT(rdp->rsp->gp_start + 2, jiffies)) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
 		rdp->offline_fqs++;
 		return 1;
 	}
-
-	/*
-	 * The CPU is online, so send it a reschedule IPI.  This forces
-	 * it through the scheduler, and (inefficiently) also handles cases
-	 * where idle loops fail to inform RCU about the CPU being idle.
-	 */
-	if (rdp->cpu != smp_processor_id())
-		smp_send_reschedule(rdp->cpu);
-	else
-		set_need_resched();
-	rdp->resched_ipi++;
 	return 0;
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index e2ac8ee..cdd1be0 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -289,7 +289,6 @@ struct rcu_data {
 	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
 	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
 	unsigned long offline_fqs;	/* Kicked due to being offline. */
-	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
 	/* 5) __rcu_pending() statistics. */
 	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index db0987c..ed459ed 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -72,7 +72,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, " of=%lu", rdp->offline_fqs);
 	seq_printf(m, " ql=%ld/%ld qs=%c%c%c%c",
 		   rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
@@ -144,7 +144,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks->dynticks_nesting,
 		   rdp->dynticks->dynticks_nmi_nesting,
 		   rdp->dynticks_fqs);
-	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, ",%lu", rdp->offline_fqs);
 	seq_printf(m, ",%ld,%ld,\"%c%c%c%c\"", rdp->qlen_lazy, rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -168,7 +168,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 {
 	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
-	seq_puts(m, "\"of\",\"ri\",\"qll\",\"ql\",\"qs\"");
+	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
 #ifdef CONFIG_RCU_BOOST
 	seq_puts(m, "\"kt\",\"ktl\"");
 #endif /* #ifdef CONFIG_RCU_BOOST */
-- 
1.7.8

