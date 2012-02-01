Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab2BATtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:49:50 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43636 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323Ab2BATtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:49:47 -0500
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
Subject: [PATCH RFC tip/core/rcu 31/41] rcu: Add CPU-stall capability to rcutorture
Date: Wed,  1 Feb 2012 11:41:49 -0800
Message-Id: <1328125319-5205-31-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5806-0000-0000-000011F30CF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Add module parameters to rcutorture that induce a CPU stall.
The stall_cpu parameter specifies how long to stall in seconds,
defaulting to zero, which indicates no stalling is to be undertaken.
The stall_cpu_holdoff parameter specifies how many seconds after
insmod (or boot, if rcutorture is built into the kernel) that this
stall is to start.  The default value for stall_cpu_holdoff is ten
seconds.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |   18 +++++++++++
 kernel/rcutorture.c           |   63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index d25be87..375d3fb 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -86,6 +86,24 @@ shutdown_secs	The number of seconds to run the test before terminating
 		zero, which disables test termination and system shutdown.
 		This capability is useful for automated testing.
 
+stall_cpu	The number of seconds that a CPU should be stalled while
+		within both an rcu_read_lock() and a preempt_disable().
+		This stall happens only once per rcutorture run.
+		If you need multiple stalls, use modprobe and rmmod to
+		repeatedly run rcutorture.  The default for stall_cpu
+		is zero, which prevents rcutorture from stalling a CPU.
+
+		Note that attempts to rmmod rcutorture while the stall
+		is ongoing will hang, so be careful what value you
+		choose for this module parameter!  In addition, too-large
+		values for stall_cpu might well induce failures and
+		warnings in other parts of the kernel.  You have been
+		warned!
+
+stall_cpu_holdoff
+		The number of seconds to wait after rcutorture starts
+		before stalling a CPU.  Defaults to 10 seconds.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index eeafbd0..4910681 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -67,6 +67,8 @@ static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
 static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
+static int stall_cpu;		/* CPU-stall duration (s).  0 for no stall. */
+static int stall_cpu_holdoff = 10; /* Time to wait until stall (s).  */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
 static int test_boost_duration = 4; /* Duration of each boost test, seconds. */
@@ -100,6 +102,10 @@ module_param(onoff_holdoff, int, 0444);
 MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
 module_param(shutdown_secs, int, 0444);
 MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
+module_param(stall_cpu, int, 0444);
+MODULE_PARM_DESC(stall_cpu, "Stall duration (s), zero to disable.");
+module_param(stall_cpu_holdoff, int, 0444);
+MODULE_PARM_DESC(stall_cpu_holdoff, "Time to wait before starting stall (s).");
 module_param(test_boost, int, 0444);
 MODULE_PARM_DESC(test_boost, "Test RCU prio boost: 0=no, 1=maybe, 2=yes.");
 module_param(test_boost_interval, int, 0444);
@@ -132,6 +138,7 @@ static struct task_struct *shutdown_task;
 #ifdef CONFIG_HOTPLUG_CPU
 static struct task_struct *onoff_task;
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static struct task_struct *stall_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -1489,6 +1496,60 @@ static void rcu_torture_onoff_cleanup(void)
 
 #endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
 
+/*
+ * CPU-stall kthread.  It waits as specified by stall_cpu_holdoff, then
+ * induces a CPU stall for the time specified by stall_cpu.
+ */
+static int __cpuinit rcu_torture_stall(void *args)
+{
+	unsigned long stop_at;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_stall task started");
+	if (stall_cpu_holdoff > 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_stall begin holdoff");
+		schedule_timeout_interruptible(stall_cpu_holdoff * HZ);
+		VERBOSE_PRINTK_STRING("rcu_torture_stall end holdoff");
+	}
+	if (!kthread_should_stop()) {
+		stop_at = get_seconds() + stall_cpu;
+		/* RCU CPU stall is expected behavior in following code. */
+		printk(KERN_ALERT "rcu_torture_stall start.\n");
+		rcu_read_lock();
+		preempt_disable();
+		while (ULONG_CMP_LT(get_seconds(), stop_at))
+			continue;  /* Induce RCU CPU stall warning. */
+		preempt_enable();
+		rcu_read_unlock();
+		printk(KERN_ALERT "rcu_torture_stall end.\n");
+	}
+	rcutorture_shutdown_absorb("rcu_torture_stall");
+	while (!kthread_should_stop())
+		schedule_timeout_interruptible(10 * HZ);
+	return 0;
+}
+
+/* Spawn CPU-stall kthread, if stall_cpu specified. */
+static int __init rcu_torture_stall_init(void)
+{
+	if (stall_cpu <= 0)
+		return 0;
+	stall_task = kthread_run(rcu_torture_stall, NULL, "rcu_torture_stall");
+	if (IS_ERR(stall_task)) {
+		stall_task = NULL;
+		return PTR_ERR(stall_task);
+	}
+	return 0;
+}
+
+/* Clean up after the CPU-stall kthread, if one was spawned. */
+static void rcu_torture_stall_cleanup(void)
+{
+	if (stall_task == NULL)
+		return;
+	VERBOSE_PRINTK_STRING("Stopping rcu_torture_stall_task.");
+	kthread_stop(stall_task);
+}
+
 static int rcutorture_cpu_notify(struct notifier_block *self,
 				 unsigned long action, void *hcpu)
 {
@@ -1531,6 +1592,7 @@ rcu_torture_cleanup(void)
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_shutdown_nb);
+	rcu_torture_stall_cleanup();
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
@@ -1831,6 +1893,7 @@ rcu_torture_init(void)
 	}
 	rcu_torture_onoff_init();
 	register_reboot_notifier(&rcutorture_shutdown_nb);
+	rcu_torture_stall_init();
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
-- 
1.7.8

