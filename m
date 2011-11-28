Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1K1Xd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:33:28 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46502 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655Ab1K1XdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:33:21 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 01/13] rcu: Add rcutorture CPU-hotplug capability
Date: Mon, 28 Nov 2011 15:32:53 -0800
Message-Id: <1322523185-456-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111128233212.GA32279@linux.vnet.ibm.com>
References: <20111128233212.GA32279@linux.vnet.ibm.com>
x-cbid: 11112823-5930-0000-0000-000002A601CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Running CPU-hotplug operations concurrently with rcutorture has
historically been a good way to find bugs in both RCU and CPU hotplug.
This commit therefore adds an rcutorture module parameter called
"onoff_interval" that causes a randomly selected CPU-hotplug operation to
be executed at the specified interval, in seconds.  The default value of
"onoff_interval" is zero, which disables rcutorture-instigated CPU-hotplug
operations.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |    8 +++
 kernel/rcutorture.c           |  117 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 120 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index af40929..d67068d 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -61,6 +61,14 @@ nreaders	This is the number of RCU reading threads supported.
 		To properly exercise RCU implementations with preemptible
 		read-side critical sections.
 
+onoff_interval
+		The number of seconds between each attempt to execute a
+		randomly selected CPU-hotplug operation.  Defaults to
+		zero, which disables CPU hotplugging.  In HOTPLUG_CPU=n
+		kernels, rcutorture will silently refuse to do any
+		CPU-hotplug operations regardless of what value is
+		specified for onoff_interval.
+
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
 		to a particular subset of the CPUs, defaults to 3 seconds.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index eed9f46..1e422ae 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -64,6 +64,7 @@ static int irqreader = 1;	/* RCU readers from irq (timers). */
 static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
@@ -92,6 +93,8 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(onoff_interval, int, 0444);
+MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
 module_param(shutdown_secs, int, 0444);
 MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
 module_param(test_boost, int, 0444);
@@ -123,6 +126,9 @@ static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
 static struct task_struct *shutdown_task;
+#ifdef CONFIG_HOTPLUG_CPU
+static struct task_struct *onoff_task;
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -153,6 +159,10 @@ static long n_rcu_torture_boost_rterror;
 static long n_rcu_torture_boost_failure;
 static long n_rcu_torture_boosts;
 static long n_rcu_torture_timers;
+static long n_offline_attempts;
+static long n_offline_successes;
+static long n_online_attempts;
+static long n_online_successes;
 static struct list_head rcu_torture_removed;
 static cpumask_var_t shuffle_tmp_mask;
 
@@ -1084,7 +1094,8 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d "
 		       "rtmbe: %d rtbke: %ld rtbre: %ld "
-		       "rtbf: %ld rtb: %ld nt: %ld",
+		       "rtbf: %ld rtb: %ld nt: %ld "
+		       "onoff: %ld/%ld:%ld/%ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
@@ -1096,7 +1107,11 @@ rcu_torture_printk(char *page)
 		       n_rcu_torture_boost_rterror,
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
-		       n_rcu_torture_timers);
+		       n_rcu_torture_timers,
+		       n_online_successes,
+		       n_online_attempts,
+		       n_offline_successes,
+		       n_offline_attempts);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
@@ -1260,12 +1275,14 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		"shuffle_interval=%d stutter=%d irqreader=%d "
 		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		"test_boost=%d/%d test_boost_interval=%d "
-		"test_boost_duration=%d shutdown_secs=%d\n",
+		"test_boost_duration=%d shutdown_secs=%d "
+		"onoff_interval=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		test_boost, cur_ops->can_boost,
-		test_boost_interval, test_boost_duration, shutdown_secs);
+		test_boost_interval, test_boost_duration, shutdown_secs,
+		onoff_interval);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1338,7 +1355,7 @@ rcu_torture_shutdown(void *arg)
 		schedule_timeout_interruptible(delta);
 		jiffies_snap = ACCESS_ONCE(jiffies);
 	}
-	if (ULONG_CMP_LT(jiffies, shutdown_time)) {
+	if (kthread_should_stop()) {
 		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
 		return 0;
 	}
@@ -1352,6 +1369,94 @@ rcu_torture_shutdown(void *arg)
 	return 0;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Execute random CPU-hotplug operations at the interval specified
+ * by the onoff_interval.
+ */
+static int
+rcu_torture_onoff(void *arg)
+{
+	int cpu;
+	int maxcpu = -1;
+	DEFINE_RCU_RANDOM(rand);
+
+	VERBOSE_PRINTK_STRING("rcu_torture_onoff task started");
+	for_each_online_cpu(cpu)
+		maxcpu = cpu;
+	WARN_ON(maxcpu < 0);
+	while (!kthread_should_stop()) {
+		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
+		if (cpu_online(cpu)) {
+			if (verbose)
+				printk(KERN_ALERT "%s" TORTURE_FLAG
+				       "rcu_torture_onoff task: offlining %d\n",
+				       torture_type, cpu);
+			n_offline_attempts++;
+			if (cpu_down(cpu) == 0) {
+				if (verbose)
+					printk(KERN_ALERT "%s" TORTURE_FLAG
+					       "rcu_torture_onoff task: "
+					       "offlined %d\n",
+					       torture_type, cpu);
+				n_offline_successes++;
+			}
+		} else {
+			if (verbose)
+				printk(KERN_ALERT "%s" TORTURE_FLAG
+				       "rcu_torture_onoff task: onlining %d\n",
+				       torture_type, cpu);
+			n_online_attempts++;
+			if (cpu_up(cpu) == 0) {
+				if (verbose)
+					printk(KERN_ALERT "%s" TORTURE_FLAG
+					       "rcu_torture_onoff task: "
+					       "onlined %d\n",
+					       torture_type, cpu);
+				n_online_successes++;
+			}
+		}
+		schedule_timeout_interruptible(onoff_interval * HZ);
+	}
+	VERBOSE_PRINTK_STRING("rcu_torture_onoff task stopping");
+	return 0;
+}
+
+static int
+rcu_torture_onoff_init(void)
+{
+	if (onoff_interval <= 0)
+		return 0;
+	onoff_task = kthread_run(rcu_torture_onoff, NULL, "rcu_torture_onoff");
+	if (IS_ERR(onoff_task)) {
+		onoff_task = NULL;
+		return PTR_ERR(onoff_task);
+	}
+	return 0;
+}
+
+static void rcu_torture_onoff_cleanup(void)
+{
+	if (onoff_task == NULL)
+		return;
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_onoff task");
+	kthread_stop(onoff_task);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void
+rcu_torture_onoff_init(void)
+{
+}
+
+static void rcu_torture_onoff_cleanup(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
 static int rcutorture_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -1460,6 +1565,7 @@ rcu_torture_cleanup(void)
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
 		kthread_stop(shutdown_task);
 	}
+	rcu_torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1687,6 +1793,7 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	rcu_torture_onoff_init();
 	register_reboot_notifier(&rcutorture_shutdown_nb);
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
-- 
1.7.3.2

