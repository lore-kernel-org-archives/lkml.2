Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0KGCGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 22:06:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38305 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0KGCFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 22:05:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/12] rcu: add priority-inversion testing to rcutorture
Date: Sat,  6 Nov 2010 19:05:21 -0700
Message-Id: <1289095532-5398-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20101107020507.GA4974@linux.vnet.ibm.com>
References: <20101107020507.GA4974@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional test to force long-term preemption of RCU read-side
critical sections, controlled by new test_boost, test_boost_interval,
and test_boost_duration module parameters.  This is to be used to
test RCU priority boosting.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |  270 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 259 insertions(+), 11 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9d8e8fb..89613f9 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -47,6 +47,7 @@
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
+#include <linux/sched.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
@@ -64,6 +65,9 @@ static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff = 0;	/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
+static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
+static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -88,6 +92,12 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(test_boost, int, 0444);
+MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
+module_param(test_boost_interval, int, 0444);
+MODULE_PARM_DESC(test_boost_interval, "Interval between boost tests, seconds.");
+module_param(test_boost_duration, int, 0444);
+MODULE_PARM_DESC(test_boost_duration, "Duration of each boost test, seconds.");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -109,6 +119,7 @@ static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
+static struct task_struct *boost_tasks[NR_CPUS];
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -134,6 +145,12 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
+static long n_rcu_torture_boost_ktrerror;
+static long n_rcu_torture_boost_rterror;
+static long n_rcu_torture_boost_allocerror;
+static long n_rcu_torture_boost_afferror;
+static long n_rcu_torture_boost_failure;
+static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
@@ -147,6 +164,16 @@ static int stutter_pause_test;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
+#ifdef CONFIG_RCU_BOOST
+#define rcu_can_boost() 1
+#else /* #ifdef CONFIG_RCU_BOOST */
+#define rcu_can_boost() 0
+#endif /* #else #ifdef CONFIG_RCU_BOOST */
+
+static unsigned long boost_starttime;	/* jiffies of next boost test start. */
+DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
+					/*  and boost task create/destroy. */
+
 /* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
 
 #define FULLSTOP_DONTSTOP 0	/* Normal operation. */
@@ -277,6 +304,7 @@ struct rcu_torture_ops {
 	void (*fqs)(void);
 	int (*stats)(char *page);
 	int irq_capable;
+	int can_boost;
 	char *name;
 };
 
@@ -366,6 +394,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu"
 };
 
@@ -408,6 +437,7 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu_sync"
 };
 
@@ -424,6 +454,7 @@ static struct rcu_torture_ops rcu_expedited_ops = {
 	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
+	.can_boost	= rcu_can_boost(),
 	.name		= "rcu_expedited"
 };
 
@@ -684,6 +715,110 @@ static struct rcu_torture_ops sched_expedited_ops = {
 };
 
 /*
+ * RCU torture priority-boost testing.  Runs one real-time thread per
+ * CPU for moderate bursts, repeatedly registering RCU callbacks and
+ * spinning waiting for them to be invoked.  If a given callback takes
+ * too long to be invoked, we assume that priority inversion has occurred.
+ */
+
+struct rcu_boost_inflight {
+	struct rcu_head rcu;
+	int inflight;
+};
+
+static void rcu_torture_boost_cb(struct rcu_head *head)
+{
+	struct rcu_boost_inflight *rbip =
+		container_of(head, struct rcu_boost_inflight, rcu);
+
+	smp_mb(); /* Ensure RCU-core accesses precede clearing ->inflight */
+	rbip->inflight = 0;
+}
+
+static int rcu_torture_boost(void *arg)
+{
+	unsigned long call_rcu_time;
+	unsigned long endtime;
+	unsigned long oldstarttime;
+	struct rcu_boost_inflight rbi = { .inflight = 0 };
+	struct sched_param sp;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_boost started");
+
+	/* Set real-time priority. */
+	sp.sched_priority = 1;
+	if (sched_setscheduler(current, SCHED_FIFO, &sp) < 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_boost RT prio failed!");
+		n_rcu_torture_boost_rterror++;
+	}
+
+	/* Each pass through the following loop does one boost-test cycle. */
+	do {
+		/* Wait for the next test interval. */
+		oldstarttime = boost_starttime;
+		while (jiffies - oldstarttime > ULONG_MAX / 2) {
+			schedule_timeout_uninterruptible(1);
+			rcu_stutter_wait("rcu_torture_boost");
+			if (kthread_should_stop() ||
+			    fullstop != FULLSTOP_DONTSTOP)
+				goto checkwait;
+		}
+
+		/* Do one boost-test interval. */
+		endtime = oldstarttime + test_boost_duration * HZ;
+		call_rcu_time = jiffies;
+		while (jiffies - endtime > ULONG_MAX / 2) {
+			/* If we don't have a callback in flight, post one. */
+			if (!rbi.inflight) {
+				smp_mb(); /* RCU core before ->inflight = 1. */
+				rbi.inflight = 1;
+				call_rcu(&rbi.rcu, rcu_torture_boost_cb);
+				if (jiffies - call_rcu_time >
+					 test_boost_duration * HZ - HZ / 2) {
+					VERBOSE_PRINTK_STRING("rcu_torture_boost boosting failed");
+					n_rcu_torture_boost_failure++;
+				}
+				call_rcu_time = jiffies;
+			}
+			cond_resched();
+			rcu_stutter_wait("rcu_torture_boost");
+			if (kthread_should_stop() ||
+			    fullstop != FULLSTOP_DONTSTOP)
+				goto checkwait;
+		}
+
+		/*
+		 * Set the start time of the next test interval.
+		 * Yes, this is vulnerable to long delays, but such
+		 * delays simply cause a false negative for the next
+		 * interval.  Besides, we are running at RT priority,
+		 * so delays should be relatively rare.
+		 */
+		while (oldstarttime == boost_starttime) {
+			if (mutex_trylock(&boost_mutex)) {
+				boost_starttime = jiffies +
+						  test_boost_interval * HZ;
+				n_rcu_torture_boosts++;
+				mutex_unlock(&boost_mutex);
+				break;
+			}
+			schedule_timeout_uninterruptible(1);
+		}
+
+		/* Go do the stutter. */
+checkwait:	rcu_stutter_wait("rcu_torture_boost");
+	} while (!kthread_should_stop() && fullstop  == FULLSTOP_DONTSTOP);
+
+	/* Clean up and exit. */
+	VERBOSE_PRINTK_STRING("rcu_torture_boost task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_boost");
+	while (!kthread_should_stop() || rbi.inflight)
+		schedule_timeout_uninterruptible(1);
+	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
+	return 0;
+}
+
+/*
  * RCU torture force-quiescent-state kthread.  Repeatedly induces
  * bursts of calls to force_quiescent_state(), increasing the probability
  * of occurrence of some important types of race conditions.
@@ -933,7 +1068,8 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d nt: %ld",
+		       "rtmbe: %d rtbke: %ld rtbre: %ld rtbae: %ld rtbafe: %ld "
+		       "rtbf: %ld rtb: %ld nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
@@ -941,8 +1077,19 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free),
 		       atomic_read(&n_rcu_torture_mberror),
+		       n_rcu_torture_boost_ktrerror,
+		       n_rcu_torture_boost_rterror,
+		       n_rcu_torture_boost_allocerror,
+		       n_rcu_torture_boost_afferror,
+		       n_rcu_torture_boost_failure,
+		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	if (atomic_read(&n_rcu_torture_mberror) != 0)
+	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
+	    n_rcu_torture_boost_ktrerror != 0 ||
+	    n_rcu_torture_boost_rterror != 0 ||
+	    n_rcu_torture_boost_allocerror != 0 ||
+	    n_rcu_torture_boost_afferror != 0 ||
+	    n_rcu_torture_boost_failure != 0)
 		cnt += sprintf(&page[cnt], " !!!");
 	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (i > 1) {
@@ -1094,22 +1241,91 @@ rcu_torture_stutter(void *arg)
 }
 
 static inline void
-rcu_torture_print_module_parms(char *tag)
+rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
 		"shuffle_interval=%d stutter=%d irqreader=%d "
-		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d\n",
+		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
+		"test_boost=%d/%d test_boost_interval=%d "
+		"test_boost_duration=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter);
+		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
+		test_boost, cur_ops->can_boost,
+		test_boost_interval, test_boost_duration);
 }
 
-static struct notifier_block rcutorture_nb = {
+static struct notifier_block rcutorture_shutdown_nb = {
 	.notifier_call = rcutorture_shutdown_notify,
 };
 
+static void rcutorture_booster_cleanup(int cpu)
+{
+	struct task_struct *t;
+
+	if (boost_tasks[cpu] == NULL)
+		return;
+	mutex_lock(&boost_mutex);
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_boost task");
+	t = boost_tasks[cpu];
+	boost_tasks[cpu] = NULL;
+	mutex_unlock(&boost_mutex);
+
+	/* This must be outside of the mutex, otherwise deadlock! */
+	kthread_stop(t);
+}
+
+static int rcutorture_booster_init(int cpu)
+{
+	int retval;
+
+	if (boost_tasks[cpu] != NULL)
+		return 0;  /* Already created, nothing more to do. */
+
+	/* Don't allow time recalculation while creating a new task. */
+	mutex_lock(&boost_mutex);
+	VERBOSE_PRINTK_STRING("Creating rcu_torture_boost task");
+	boost_tasks[cpu] = kthread_create(rcu_torture_boost, NULL,
+					  "rcu_torture_boost");
+	if (IS_ERR(boost_tasks[cpu])) {
+		retval = PTR_ERR(boost_tasks[cpu]);
+		VERBOSE_PRINTK_STRING("rcu_torture_boost task create failed");
+		n_rcu_torture_boost_ktrerror++;
+		boost_tasks[cpu] = NULL;
+		mutex_unlock(&boost_mutex);
+		return retval;
+	}
+	kthread_bind(boost_tasks[cpu], cpu);
+	wake_up_process(boost_tasks[cpu]);
+	mutex_unlock(&boost_mutex);
+	return 0;
+}
+
+static int rcutorture_cpu_notify(struct notifier_block *self,
+				 unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		(void)rcutorture_booster_init(cpu);
+		break;
+	case CPU_DOWN_PREPARE:
+		rcutorture_booster_cleanup(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rcutorture_cpu_nb = {
+	.notifier_call = rcutorture_cpu_notify,
+};
+
 static void
 rcu_torture_cleanup(void)
 {
@@ -1127,7 +1343,7 @@ rcu_torture_cleanup(void)
 	}
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
-	unregister_reboot_notifier(&rcutorture_nb);
+	unregister_reboot_notifier(&rcutorture_shutdown_nb);
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
@@ -1184,6 +1400,12 @@ rcu_torture_cleanup(void)
 		kthread_stop(fqs_task);
 	}
 	fqs_task = NULL;
+	if ((test_boost == 1 && cur_ops->can_boost) ||
+	    test_boost == 2) {
+		unregister_cpu_notifier(&rcutorture_cpu_nb);
+		for_each_possible_cpu(i)
+			rcutorture_booster_cleanup(i);
+	}
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1195,9 +1417,9 @@ rcu_torture_cleanup(void)
 	if (cur_ops->cleanup)
 		cur_ops->cleanup();
 	if (atomic_read(&n_rcu_torture_error))
-		rcu_torture_print_module_parms("End of test: FAILURE");
+		rcu_torture_print_module_parms(cur_ops, "End of test: FAILURE");
 	else
-		rcu_torture_print_module_parms("End of test: SUCCESS");
+		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
 
 static int __init
@@ -1242,7 +1464,7 @@ rcu_torture_init(void)
 		nrealreaders = nreaders;
 	else
 		nrealreaders = 2 * num_online_cpus();
-	rcu_torture_print_module_parms("Start of test");
+	rcu_torture_print_module_parms(cur_ops, "Start of test");
 	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
@@ -1263,6 +1485,12 @@ rcu_torture_init(void)
 	atomic_set(&n_rcu_torture_free, 0);
 	atomic_set(&n_rcu_torture_mberror, 0);
 	atomic_set(&n_rcu_torture_error, 0);
+	n_rcu_torture_boost_ktrerror = 0;
+	n_rcu_torture_boost_rterror = 0;
+	n_rcu_torture_boost_allocerror = 0;
+	n_rcu_torture_boost_afferror = 0;
+	n_rcu_torture_boost_failure = 0;
+	n_rcu_torture_boosts = 0;
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
 		atomic_set(&rcu_torture_wcount[i], 0);
 	for_each_possible_cpu(cpu) {
@@ -1376,7 +1604,27 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
-	register_reboot_notifier(&rcutorture_nb);
+	if (test_boost_interval < 1)
+		test_boost_interval = 1;
+	if (test_boost_duration < 2)
+		test_boost_duration = 2;
+	if ((test_boost == 1 && cur_ops->can_boost) ||
+	    test_boost == 2) {
+		int retval;
+
+		boost_starttime = jiffies + test_boost_interval * HZ;
+		register_cpu_notifier(&rcutorture_cpu_nb);
+		for_each_possible_cpu(i) {
+			if (cpu_is_offline(i))
+				continue;  /* Heuristic: CPU can go offline. */
+			retval = rcutorture_booster_init(i);
+			if (retval < 0) {
+				firsterr = retval;
+				goto unwind;
+			}
+		}
+	}
+	register_reboot_notifier(&rcutorture_shutdown_nb);
 	mutex_unlock(&fullstop_mutex);
 	return 0;
 
-- 
1.7.0.6

