Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2BATnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:43:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40483 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab2BATnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:43:02 -0500
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
Subject: [PATCH RFC tip/core/rcu 30/41] rcutorture: Permit holding off CPU-hotplug operations during boot
Date: Wed,  1 Feb 2012 11:41:48 -0800
Message-Id: <1328125319-5205-30-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-7282-0000-0000-0000061F24F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

When rcutorture is started automatically at boot time, it might well
also start CPU-hotplug operations at that time, which might not be
desirable.  This commit therefore adds an rcutorture parameter that
allows CPU-hotplug operations to be held off for the specified number
of seconds after the start of boot.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/torture.txt |   15 ++++++++++++---
 kernel/rcutorture.c           |   12 ++++++++++--
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index d67068d..d25be87 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -69,6 +69,13 @@ onoff_interval
 		CPU-hotplug operations regardless of what value is
 		specified for onoff_interval.
 
+onoff_holdoff	The number of seconds to wait until starting CPU-hotplug
+		operations.  This would normally only be used when
+		rcutorture was built into the kernel and started
+		automatically at boot time, in which case it is useful
+		in order to avoid confusing boot-time code with CPUs
+		coming and going.
+
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
 		to a particular subset of the CPUs, defaults to 3 seconds.
@@ -271,11 +278,13 @@ The following script may be used to torture RCU:
 	#!/bin/sh
 
 	modprobe rcutorture
-	sleep 100
+	sleep 3600
 	rmmod rcutorture
 	dmesg | grep torture:
 
 The output can be manually inspected for the error flag of "!!!".
 One could of course create a more elaborate script that automatically
-checked for such errors.  The "rmmod" command forces a "SUCCESS" or
-"FAILURE" indication to be printk()ed.
+checked for such errors.  The "rmmod" command forces a "SUCCESS",
+"FAILURE", or "RCU_HOTPLUG" indication to be printk()ed.  The first
+two are self-explanatory, while the last indicates that while there
+were no RCU failures, CPU-hotplug problems were detected.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a94eaef..eeafbd0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -65,6 +65,7 @@ static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
+static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
 static int test_boost = 1;	/* Test RCU prio boost: 0=no, 1=maybe, 2=yes. */
 static int test_boost_interval = 7; /* Interval between boost tests, seconds. */
@@ -95,6 +96,8 @@ module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
 module_param(onoff_interval, int, 0444);
 MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
+module_param(onoff_holdoff, int, 0444);
+MODULE_PARM_DESC(onoff_holdoff, "Time after boot before CPU hotplugs (s)");
 module_param(shutdown_secs, int, 0444);
 MODULE_PARM_DESC(shutdown_secs, "Shutdown time (s), zero to disable.");
 module_param(test_boost, int, 0444);
@@ -1300,13 +1303,13 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, char *tag)
 		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d "
 		"test_boost=%d/%d test_boost_interval=%d "
 		"test_boost_duration=%d shutdown_secs=%d "
-		"onoff_interval=%d\n",
+		"onoff_interval=%d onoff_holdoff=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter,
 		test_boost, cur_ops->can_boost,
 		test_boost_interval, test_boost_duration, shutdown_secs,
-		onoff_interval);
+		onoff_interval, onoff_holdoff);
 }
 
 static struct notifier_block rcutorture_shutdown_nb = {
@@ -1410,6 +1413,11 @@ rcu_torture_onoff(void *arg)
 	for_each_online_cpu(cpu)
 		maxcpu = cpu;
 	WARN_ON(maxcpu < 0);
+	if (onoff_holdoff > 0) {
+		VERBOSE_PRINTK_STRING("rcu_torture_onoff begin holdoff");
+		schedule_timeout_interruptible(onoff_holdoff * HZ);
+		VERBOSE_PRINTK_STRING("rcu_torture_onoff end holdoff");
+	}
 	while (!kthread_should_stop()) {
 		cpu = (rcu_random(&rand) >> 4) % (maxcpu + 1);
 		if (cpu_online(cpu) && cpu_is_hotpluggable(cpu)) {
-- 
1.7.8

