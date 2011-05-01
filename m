Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846Ab1EANiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:38:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44542 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab1EANWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/86] rcu: Add forward-progress diagnostic for per-CPU kthreads
Date: Sun,  1 May 2011 06:20:59 -0700
Message-Id: <1304256126-26015-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Increment a per-CPU counter on each pass through rcu_cpu_kthread()'s
service loop, and add it to the rcudata trace output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/trace.txt |   39 ++++++++++++++++++++++-----------------
 kernel/rcutree.c            |    2 ++
 kernel/rcutree_trace.c      |    4 +++-
 3 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 77f5bda..26d9ee3 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -24,23 +24,23 @@ boosting statistics).
 The output of "cat rcu/rcudata" looks as follows:
 
 rcu_sched:
-  0!c=423090 g=423091 pq=1 pqc=423090 qp=1 dt=86475/1/0 df=16319 of=163 ri=1519 ql=0 qs=.... kt=0/W b=10 ci=1460693 co=1648 ca=6448
-  1!c=423329 g=423330 pq=1 pqc=423329 qp=1 dt=90875/1/0 df=16231 of=157 ri=1249 ql=0 qs=.... kt=0/W b=10 ci=1459002 co=1614 ca=3310
-  2!c=423370 g=423371 pq=1 pqc=423370 qp=1 dt=69661/1/0 df=16125 of=163 ri=1469 ql=0 qs=.... kt=0/W b=10 ci=1610701 co=2015 ca=2378
-  3!c=422967 g=422968 pq=1 pqc=422967 qp=1 dt=70349/1/0 df=12528 of=163 ri=1450 ql=0 qs=.... kt=0/W b=10 ci=1427543 co=1430 ca=897
-  4!c=423196 g=423197 pq=1 pqc=423196 qp=0 dt=38935/1/0 df=10959 of=177 ri=1657 ql=0 qs=.... kt=0/W b=10 ci=1562249 co=1896 ca=533
-  5!c=422950 g=422951 pq=1 pqc=422950 qp=0 dt=25127/1/0 df=5895 of=167 ri=1549 ql=0 qs=.... kt=0/W b=10 ci=1777260 co=2137 ca=274
-  6!c=423396 g=423397 pq=1 pqc=423396 qp=1 dt=22639/1/0 df=4590 of=149 ri=1572 ql=0 qs=.... kt=0/W b=10 ci=1471186 co=1530 ca=243
-  7 c=460203 g=460203 pq=1 pqc=460202 qp=0 dt=937087/1/0 df=3298 of=149 ri=1584 ql=6 qs=N.W. kt=0/W b=10 ci=4026154 co=1948 ca=135
+  0 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=545/1/0 df=50 of=0 ri=0 ql=163 qs=NRW. kt=0/W/0 ktl=ebc3 b=10 ci=153737 co=0 ca=0
+  1 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=967/1/0 df=58 of=0 ri=0 ql=634 qs=NRW. kt=0/W/1 ktl=58c b=10 ci=191037 co=0 ca=0
+  2 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1081/1/0 df=175 of=0 ri=0 ql=74 qs=N.W. kt=0/W/2 ktl=da94 b=10 ci=75991 co=0 ca=0
+  3 c=20942 g=20943 pq=1 pqc=20942 qp=1 dt=1846/0/0 df=404 of=0 ri=0 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=72261 co=0 ca=0
+  4 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=369/1/0 df=83 of=0 ri=0 ql=48 qs=N.W. kt=0/W/4 ktl=e0e7 b=10 ci=128365 co=0 ca=0
+  5 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=381/1/0 df=64 of=0 ri=0 ql=169 qs=NRW. kt=0/W/5 ktl=fb2f b=10 ci=164360 co=0 ca=0
+  6 c=20972 g=20973 pq=1 pqc=20972 qp=0 dt=1037/1/0 df=183 of=0 ri=0 ql=62 qs=N.W. kt=0/W/6 ktl=d2ad b=10 ci=65663 co=0 ca=0
+  7 c=20897 g=20897 pq=1 pqc=20896 qp=0 dt=1572/0/0 df=382 of=0 ri=0 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=75006 co=0 ca=0
 rcu_bh:
-  0!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=86475/1/0 df=11 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=112 co=0 ca=0
-  1!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=90875/1/0 df=15 of=0 ri=0 ql=0 qs=.... kt=0/W b=10 ci=143 co=0 ca=0
-  2!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=69661/1/0 df=21 of=0 ri=1 ql=0 qs=.... kt=0/W b=10 ci=88 co=0 ca=0
-  3!c=18446744073709551494 g=18446744073709551494 pq=1 pqc=18446744073709551493 qp=0 dt=70349/1/0 df=13 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=100 co=0 ca=0
-  4!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=38935/1/0 df=17 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=36 co=0 ca=0
-  5!c=18446744073709551494 g=18446744073709551494 pq=0 pqc=18446744073709551493 qp=1 dt=25127/1/0 df=7 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=32 co=0 ca=0
-  6!c=18446744073709551496 g=18446744073709551496 pq=1 pqc=18446744073709551495 qp=0 dt=22639/1/0 df=9 of=0 ri=0 ql=0 qs=....  kt=0/W b=10 ci=44 co=0 ca=0
-  7 c=182 g=182 pq=1 pqc=181 qp=0 dt=937087/1/0 df=14 of=0 ri=1 ql=0 qs=....  kt=0/W b=10 ci=627 co=0 ca=0
+  0 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=545/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/0 ktl=ebc3 b=10 ci=0 co=0 ca=0
+  1 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=967/1/0 df=3 of=0 ri=1 ql=0 qs=.... kt=0/W/1 ktl=58c b=10 ci=151 co=0 ca=0
+  2 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1081/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/2 ktl=da94 b=10 ci=0 co=0 ca=0
+  3 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1846/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/3 ktl=d1cd b=10 ci=0 co=0 ca=0
+  4 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=369/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/4 ktl=e0e7 b=10 ci=0 co=0 ca=0
+  5 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=381/1/0 df=4 of=0 ri=1 ql=0 qs=.... kt=0/W/5 ktl=fb2f b=10 ci=0 co=0 ca=0
+  6 c=1480 g=1480 pq=1 pqc=1479 qp=0 dt=1037/1/0 df=6 of=0 ri=1 ql=0 qs=.... kt=0/W/6 ktl=d2ad b=10 ci=0 co=0 ca=0
+  7 c=1474 g=1474 pq=1 pqc=1473 qp=0 dt=1572/0/0 df=8 of=0 ri=1 ql=0 qs=.... kt=0/W/7 ktl=cf15 b=10 ci=0 co=0 ca=0
 
 The first section lists the rcu_data structures for rcu_sched, the second
 for rcu_bh.  Note that CONFIG_TREE_PREEMPT_RCU kernels will have an
@@ -151,7 +151,8 @@ o	"qs" gives an indication of the state of the callback queue
 
 o	"kt" is the per-CPU kernel-thread state.  The digit preceding
 	the first slash is zero if there is no work pending and 1
-	otherwise.  The character between the slashes is as follows:
+	otherwise.  The character between the first pair of slashes is
+	as follows:
 
 	"S"	The kernel thread is stopped, in other words, all
 		CPUs corresponding to this rcu_node structure are
@@ -174,6 +175,10 @@ o	"kt" is the per-CPU kernel-thread state.  The digit preceding
 	The number after the final slash is the CPU that the kthread
 	is actually running on.
 
+o	"ktl" is the low-order 16 bits (in hexadecimal) of the count of
+	the number of times that this CPU's per-CPU kthread has gone
+	through its loop servicing invoke_rcu_cpu_kthread() requests.
+
 o	"b" is the batch limit for this CPU.  If more than this number
 	of RCU callbacks is ready to invoke, then the remainder will
 	be deferred.
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8cf0307..ee8442d 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -93,6 +93,7 @@ EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 static DEFINE_PER_CPU(struct task_struct *, rcu_cpu_kthread_task);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(int, rcu_cpu_kthread_cpu);
+DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 static DEFINE_PER_CPU(wait_queue_head_t, rcu_cpu_wq);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 static char rcu_kthreads_spawnable;
@@ -1625,6 +1626,7 @@ static int rcu_cpu_kthread(void *arg)
 			break;
 		}
 		*statusp = RCU_KTHREAD_RUNNING;
+		per_cpu(rcu_cpu_kthread_loops, cpu)++;
 		local_irq_save(flags);
 		work = *workp;
 		*workp = 0;
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 564b8fe..9678cc3 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -48,6 +48,7 @@
 
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_cpu);
+DECLARE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DECLARE_PER_CPU(char, rcu_cpu_has_work);
 
 static char convert_kthread_status(unsigned int kthread_status)
@@ -75,7 +76,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   rdp->dynticks_fqs);
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
-	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d b=%ld",
+	seq_printf(m, " ql=%ld qs=%c%c%c%c kt=%d/%c/%d ktl=%x b=%ld",
 		   rdp->qlen,
 		   ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
 			rdp->nxttail[RCU_NEXT_TAIL]],
@@ -88,6 +89,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   convert_kthread_status(per_cpu(rcu_cpu_kthread_status,
 					  rdp->cpu)),
 		   per_cpu(rcu_cpu_kthread_cpu, rdp->cpu),
+		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff,
 		   rdp->blimit);
 	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
 		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
-- 
1.7.3.2

