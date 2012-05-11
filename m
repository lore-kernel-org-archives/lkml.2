Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab2EKDCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 23:02:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:27369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932182Ab2EKDCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 23:02:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164756955"
From: Youquan Song <youquan.song@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, len.brown@intel.com,
        akpm@linux-foundation.org
Cc: arjan@linux.intel.com, len.brown@linux.intel.com,
        suresh.b.siddha@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 1/3] x86,idle: Quickly notice prediction failure for repeat mode
Date: Fri, 11 May 2012 11:15:55 -0400
Message-Id: <1336749357-9133-2-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1336749357-9133-1-git-send-email-youquan.song@intel.com>
References: <1336749357-9133-1-git-send-email-youquan.song@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prediction for future is difficult and when the cpuidle governor prediction 
fails and govenor possibly choose the shallower C-state than it should. How to 
quickly notice and find the failure becomes important for power saving.    

cpuidle menu governor has a method to predict the repeat pattern if there are 8
C-states residency which are continuous and the same or very close, so it will
predict the next C-states residency will keep same residency time.

We encountered a real case that turbostat utility (tools/power/x86/turbostat) 
at kernel 3.3 or early. turbostat utility will read 10 registers one by one at
Sandybridge, so it will generate 10 IPIs to wake up idle CPUs. So cpuidle menu
 governor will predict it is repeat mode and there is another IPI wake up idle
 CPU soon, so it keeps idle CPU stay at C1 state even though CPU is totally 
idle. However, in the turbostat, following 10 registers reading is sleep 5 
seconds by default, so the idle CPU will keep at C1 for a long time though it is
 idle until break event occurs.

In the patch, a timer is added when menu governor detects a repeat mode and
choose a shallow C-state.The timer will be time out in (2 * predicted_time + 60)
micro-seconds. When repeat mode happens as expected, the timer is not triggered
and CPU waken up from C-states and it will cancel the timer initiatively. 
When repeat mode does not happen, the timer will be time out and menu governor 
will quickly in (2 * predicted_time + 60) us notice that the repeat mode 
prediction fails and re-evaluates deeper C-states possibility. 

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 drivers/cpuidle/governors/menu.c |   68 +++++++++++++++++++++++++++++++++++--
 include/linux/tick.h             |    6 +++
 kernel/time/tick-sched.c         |    2 +
 3 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 0633575..8c23fbd 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -28,6 +28,11 @@
 #define MAX_INTERESTING 50000
 #define STDDEV_THRESH 400
 
+/* 60 * 60 > STDDEV_THRESH * INTERVALS = 400 * 8 */
+#define MAX_DEVIATION 60
+
+static DEFINE_PER_CPU(struct hrtimer, menu_hrtimer);
+static DEFINE_PER_CPU(int, hrtimer_started);
 
 /*
  * Concepts and ideas behind the menu governor
@@ -191,17 +196,42 @@ static u64 div_round64(u64 dividend, u32 divisor)
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
+/* Cancel the hrtimer if it is not triggered yet */
+void menu_hrtimer_cancel(void)
+{
+	int cpu = smp_processor_id();
+	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
+
+	/* The timer is still not time out*/
+	if (per_cpu(hrtimer_started, cpu)) {
+		hrtimer_cancel(hrtmr);
+		per_cpu(hrtimer_started, cpu) = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(menu_hrtimer_cancel);
+
+/* Call back for hrtimer is triggered */
+static enum hrtimer_restart menu_hrtimer_notify(struct hrtimer *hrtimer)
+{
+	int cpu = smp_processor_id();
+
+	per_cpu(hrtimer_started, cpu) = 0;
+
+	return HRTIMER_NORESTART;
+}
+
 /*
  * Try detecting repeating patterns by keeping track of the last 8
  * intervals, and checking if the standard deviation of that set
  * of points is below a threshold. If it is... then use the
  * average of these 8 points as the estimated value.
  */
-static void detect_repeating_patterns(struct menu_device *data)
+static int detect_repeating_patterns(struct menu_device *data)
 {
 	int i;
 	uint64_t avg = 0;
 	uint64_t stddev = 0; /* contains the square of the std deviation */
+	int ret = 0;
 
 	/* first calculate average and standard deviation of the past */
 	for (i = 0; i < INTERVALS; i++)
@@ -210,7 +240,7 @@ static void detect_repeating_patterns(struct menu_device *data)
 
 	/* if the avg is beyond the known next tick, it's worthless */
 	if (avg > data->expected_us)
-		return;
+		return 0;
 
 	for (i = 0; i < INTERVALS; i++)
 		stddev += (data->intervals[i] - avg) *
@@ -223,8 +253,12 @@ static void detect_repeating_patterns(struct menu_device *data)
 	 * repeating pattern and predict we keep doing this.
 	 */
 
-	if (avg && stddev < STDDEV_THRESH)
+	if (avg && stddev < STDDEV_THRESH) {
 		data->predicted_us = avg;
+		ret = 1;
+	}
+
+	return ret;
 }
 
 /**
@@ -240,6 +274,9 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	int i;
 	int multiplier;
 	struct timespec t;
+	int repeat = 0;
+	int cpu = smp_processor_id();
+	struct hrtimer *hrtmr = &per_cpu(menu_hrtimer, cpu);
 
 	if (data->needs_update) {
 		menu_update(drv, dev);
@@ -274,7 +311,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	detect_repeating_patterns(data);
+	repeat = detect_repeating_patterns(data);
 
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
@@ -307,6 +344,26 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		}
 	}
 
+	if (data->last_state_idx < drv->state_count - 1) {
+
+		/* Repeat mode detected */
+		if (repeat) {
+			unsigned int repeat_us = 0;
+			/*
+			 * Set enough timer to recognize the repeat mode broken.
+			 * If the timer is time out, the repeat mode prediction
+			 * fails,then re-evaluate deeper C-states possibility.
+			 * If the timer is not triggered, the timer will be
+			 * cancelled when CPU waken up.
+			 */
+			repeat_us = 2 * data->predicted_us + MAX_DEVIATION;
+			hrtimer_start(hrtmr, ns_to_ktime(1000 * repeat_us),
+				HRTIMER_MODE_REL_PINNED);
+			/* menu hrtimer is started */
+			per_cpu(hrtimer_started, cpu) = 1;
+		}
+	}
+
 	return data->last_state_idx;
 }
 
@@ -397,6 +454,9 @@ static int menu_enable_device(struct cpuidle_driver *drv,
 				struct cpuidle_device *dev)
 {
 	struct menu_device *data = &per_cpu(menu_devices, dev->cpu);
+	struct hrtimer *t = &per_cpu(menu_hrtimer, dev->cpu);
+	hrtimer_init(t, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->function = menu_hrtimer_notify;
 
 	memset(data, 0, sizeof(struct menu_device));
 
diff --git a/include/linux/tick.h b/include/linux/tick.h
index ab8be90..4cea029 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -142,4 +142,10 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+# ifdef CONFIG_CPU_IDLE_GOV_MENU
+extern void menu_hrtimer_cancel(void);
+# else
+static inline void menu_hrtimer_cancel(void) { return -1; }
+# endif /* CONFIG_CPU_IDLE_GOV_MENU */
+
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..812c1d6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -499,6 +499,8 @@ void tick_nohz_irq_exit(void)
 	if (!ts->inidle)
 		return;
 
+	/* Cancel the timer because CPU already waken up from the C-states*/
+	menu_hrtimer_cancel();
 	tick_nohz_stop_sched_tick(ts);
 }
 
@@ -562,6 +564,8 @@ void tick_nohz_idle_exit(void)
 
 	ts->inidle = 0;
 
+	/* Cancel the timer because CPU already waken up from the C-states*/
+	menu_hrtimer_cancel();
 	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
