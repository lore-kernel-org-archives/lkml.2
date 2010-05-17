Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0EQWHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:07:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab0EQWG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:06:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu
Cc: a.p.zijlstra@chello.nl, gorcunov@gmail.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/3] [watchdog] separate hardlockup/softlockup enable paths
Date: Mon, 17 May 2010 18:06:05 -0400
Message-Id: <1274133966-18415-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
References: <1274133966-18415-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to support the backwards compatible option nmi_watchdog properly
from the kernel commandline, the enable/disable paths for the hardlockup and
softlockup code needed to separated more cleanly.

The code is re-arranged a bit to create a watchdog_softlockup_enable/disable
function to mimic the hardlockup counterpart.  In addition, a softlockup callback
is created to make it easy to turn the softlockup code on/off with out interfering
with the hardlockup code.

The functionality should still be the same.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   92 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 91b0b26..0a6bdb7 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -30,9 +30,12 @@
 int watchdog_enabled;
 int __read_mostly softlockup_thresh = 60;
 
+typedef void (*callback_t)(void);
+
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
-static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
+static DEFINE_PER_CPU(struct task_struct *, watchdog_thread);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU(callback_t, softlockup_callback);
 static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -244,21 +247,14 @@ static void watchdog_interrupt_count(void)
 static inline void watchdog_interrupt_count(void) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
-/* watchdog kicker functions */
-static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
+static void watchdog_softlockup_callback(void)
 {
 	unsigned long touch_ts = __get_cpu_var(watchdog_touch_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
 
-	/* kick the hardlockup detector */
-	watchdog_interrupt_count();
-
 	/* kick the softlockup detector */
-	wake_up_process(__get_cpu_var(softlockup_watchdog));
-
-	/* .. and repeat */
-	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+	wake_up_process(__get_cpu_var(watchdog_thread));
 
 	if (touch_ts == 0) {
 		if (unlikely(__get_cpu_var(softlockup_touch_sync))) {
@@ -270,7 +266,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			sched_clock_tick();
 		}
 		__touch_watchdog();
-		return HRTIMER_RESTART;
+		return;
 	}
 
 	/* check for a softlockup
@@ -283,7 +279,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	if (unlikely(duration)) {
 		/* only warn once */
 		if (__get_cpu_var(soft_watchdog_warn) == true)
-			return HRTIMER_RESTART;
+			return;
 
 		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
@@ -301,6 +297,24 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	} else
 		__get_cpu_var(soft_watchdog_warn) = false;
 
+	return;
+}
+
+/* watchdog kicker functions */
+static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
+{
+	callback_t cb = __get_cpu_var(softlockup_callback);
+
+	/* setup next timer */
+	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
+
+	/* kick the hardlockup detector */
+	watchdog_interrupt_count();
+
+	/* check the softlockup detector */
+	if (cb)
+		cb();
+
 	return HRTIMER_RESTART;
 }
 
@@ -397,12 +411,27 @@ static int watchdog_nmi_enable(int cpu) { return 0; }
 static void watchdog_nmi_disable(int cpu) { return; }
 #endif /* CONFIG_HARDLOCKUP_DETECTOR */
 
+static int watchdog_softlockup_enable(int cpu)
+{
+	/* if any cpu succeeds, watchdog is considered enabled for the system */
+	per_cpu(softlockup_callback, cpu) = watchdog_softlockup_callback;
+	wake_up_process(per_cpu(watchdog_thread, cpu));
+
+	return 0;
+}
+
+static void watchdog_softlockup_disable(int cpu)
+{
+	per_cpu(softlockup_callback, cpu) = NULL;
+	return;
+}
+
 /* prepare/enable/disable routines */
 static int watchdog_prepare_cpu(int cpu)
 {
 	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
 
-	WARN_ON(per_cpu(softlockup_watchdog, cpu));
+	WARN_ON(per_cpu(watchdog_thread, cpu));
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hrtimer->function = watchdog_timer_fn;
 
@@ -411,11 +440,8 @@ static int watchdog_prepare_cpu(int cpu)
 
 static int watchdog_enable(int cpu)
 {
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
-
-	/* enable the perf event */
-	if (watchdog_nmi_enable(cpu) != 0)
-		return -1;
+	struct task_struct *p = per_cpu(watchdog_thread, cpu);
+	int result;
 
 	/* create the watchdog thread */
 	if (!p) {
@@ -426,35 +452,43 @@ static int watchdog_enable(int cpu)
 		}
 		kthread_bind(p, cpu);
 		per_cpu(watchdog_touch_ts, cpu) = 0;
-		per_cpu(softlockup_watchdog, cpu) = p;
-		wake_up_process(p);
+		per_cpu(watchdog_thread, cpu) = p;
+
 	}
 
-	return 0;
+	/* enable the hardlockup detector */
+	if (watchdog_nmi_enable(cpu) != 0)
+		result += 1;
+
+	/* enable the softlockup detector */
+	if (watchdog_softlockup_enable(cpu) != 0)
+		result += 1;
+
+	return result;
 }
 
 static void watchdog_disable(int cpu)
 {
-	struct task_struct *p = per_cpu(softlockup_watchdog, cpu);
+	struct task_struct *p = per_cpu(watchdog_thread, cpu);
 	struct hrtimer *hrtimer = &per_cpu(watchdog_hrtimer, cpu);
 
+	/* disable the hardlockup detector */
+	watchdog_nmi_disable(cpu);
+
+	/* disable the softlockup detector */
+	watchdog_softlockup_disable(cpu);
+
 	/*
 	 * cancel the timer first to stop incrementing the stats
 	 * and waking up the kthread
 	 */
 	hrtimer_cancel(hrtimer);
 
-	/* disable the perf event */
-	watchdog_nmi_disable(cpu);
-
 	/* stop the watchdog thread */
 	if (p) {
-		per_cpu(softlockup_watchdog, cpu) = NULL;
+		per_cpu(watchdog_thread, cpu) = NULL;
 		kthread_stop(p);
 	}
-
-	/* if any cpu succeeds, watchdog is considered enabled for the system */
-	watchdog_enabled = 1;
 }
 
 static void watchdog_enable_all_cpus(void)
-- 
1.7.0.1

