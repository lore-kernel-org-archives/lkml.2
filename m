Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1KOU2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:16 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52263 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab1KOU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/9] rcu: Add rcutorture system-shutdown capability
Date: Tue, 15 Nov 2011 12:27:58 -0800
Message-Id: <1321388885-11211-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-5112-0000-0000-000002106FD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Although it is easy to run rcutorture tests under KVM, there is currently
no nice way to run such a test for a fixed time period, collect all of
the rcutorture data, and then shut the system down cleanly.  This commit
therefore adds an rcutorture module parameter named "shutdown_secs" that
specified the run duration in seconds, after which rcutorture terminates
the test and powers the system down.  The default value for "shutdown_secs"
is zero, which disables shutdown.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |    5 +++
 kernel/rcutorture.c           |   62 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 783d6c1..af40929 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -66,6 +66,11 @@ shuffle_interval
 		to a particular subset of the CPUs, defaults to 3 seconds.
 		Used in conjunction with test_no_idle_hz.
 
+shutdown_secs	The number of seconds to run the test before terminating
+		the test and powering off the system.  The default is
+		zero, which disables test termination and system shutdown.
+		This capability is useful for automated testing.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index df35228..41802be 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -61,9 +61,10 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
-static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
-static int fqs_holdoff = 0;	/* Hold time within burst (us). */
+static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
+static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
+static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
 static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
@@ -91,6 +92,8 @@ module_param(fqs_holdoff, int, 0444);
 MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
 module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
+module_param(shutdown_secs, int, 0444);
+MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
 module_param(test_boost_interval, int, 0444);
@@ -119,6 +122,7 @@ static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
+static struct task_struct *shutdown_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -167,6 +171,7 @@ int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 #define rcu_can_boost() 0
 #endif /* #else #if defined(CONFIG_RCU_BOOST) && !defined(CONFIG_HOTPLUG_CPU) */
 
+static unsigned long shutdown_time;	/* jiffies to system shutdown. */
 static unsigned long boost_starttime;	/* jiffies of next boost test start. */
 DEFINE_MUTEX(boost_mutex);		/* protect setting boost_starttime */
 					/*  and boost task create/destroy. */
@@ -182,6 +187,9 @@ static int fullstop = FULLSTOP_RMMOD;
  */
 static DEFINE_MUTEX(fullstop_mutex);
 
+/* Forward reference. */
+static void rcu_torture_cleanup(void);
+
 /*
  * Detect and respond to a system shutdown.
  */
@@ -1250,12 +1258,12 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		"shuffle_interval=%d stutter=%d irqreader=%d "
 		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		"test_boost=%d/%d test_boost_interval=%d "
-		"test_boost_duration=%d\n",
+		"test_boost_duration=%d shutdown_secs=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		test_boost, cur_ops->can_boost,
-		test_boost_interval, test_boost_duration);
+		test_boost_interval, test_boost_duration, shutdown_secs);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1305,6 +1313,37 @@ static int rcutorture_booster_init(int cpu)
 	return 0;
 }
 
+/*
+ * Cause the rcutorture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int
+rcu_torture_shutdown(void *arg)
+{
+	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task started");
+	while (ULONG_CMP_LT(jiffies, shutdown_time) &&
+	       !kthread_should_stop()) {
+		if (verbose)
+			printk(KERN_ALERT "%s" TORTURE_FLAG
+			       "rcu_torture_shutdown task: %lu "
+			       "jiffies remaining\n",
+			       torture_type, shutdown_time - jiffies);
+		schedule_timeout_interruptible(HZ);
+	}
+	if (ULONG_CMP_LT(jiffies, shutdown_time)) {
+		VERBOSE_PRINTK_STRING("rcu_torture_shutdown task stopping");
+		return 0;
+	}
+
+	/* OK, shut down the system. */
+
+	VERBOSE_PRINTK_STRING("rcu_torture_shutdown task shutting down system");
+	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
+	rcu_torture_cleanup();	/* Get the success/failure message. */
+	kernel_power_off();	/* Shut down the system. */
+	return 0;
+}
+
 static int rcutorture_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -1409,6 +1448,10 @@ rcu_torture_cleanup(void)
 		for_each_possible_cpu(i)
 			rcutorture_booster_cleanup(i);
 	}
+	if (shutdown_task != NULL) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shutdown task");
+		kthread_stop(shutdown_task);
+	}
 
 	/* Wait for all RCU callbacks to fire.  */
 
@@ -1625,6 +1668,17 @@ rcu_torture_init(void)
 			}
 		}
 	}
+	if (shutdown_secs > 0) {
+		shutdown_time = jiffies + shutdown_secs * HZ;
+		shutdown_task = kthread_run(rcu_torture_shutdown, NULL,
+					    "rcu_torture_shutdown");
+		if (IS_ERR(shutdown_task)) {
+			firsterr = PTR_ERR(shutdown_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create shutdown");
+			shutdown_task = NULL;
+			goto unwind;
+		}
+	}
 	register_reboot_notifier(&rcutorture_shutdown_nb);
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
-- 
1.7.3.2

