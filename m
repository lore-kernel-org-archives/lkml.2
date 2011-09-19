Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1ISXfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 19:35:22 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:57983 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751178Ab1ISXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 19:35:21 -0400
From: Kevin Hilman <khilman@ti.com>
To: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Nicole Chalhoub <n-chalhoub@ti.com>
Subject: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor deeper C-states
Date: Mon, 19 Sep 2011 16:35:15 -0700
Message-Id: <1316475315-5905-1-git-send-email-khilman@ti.com>
X-Mailer: git-send-email 1.7.6
CC: Nicole Chalhoub <n-chalhoub@ti.com>, Kevin Hilman <khilman@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicole Chalhoub <n-chalhoub@ti.com>

While there is CPU load, program a C-state specific one-shot timer in
order to give CPUidle another opportunity to pick a deeper C-state
instead of spending potentially long idle times in a shallow C-state.

Long winded version:
When going idle with a high load average, CPUidle menu governor will
decide to pick a shallow C-state since one of the guiding principles
of the menu governor is "The busier the system, the less impact of
C-states is acceptable" (taken from cpuidle/governors/menu.c.)
That makes perfect sense.

However, there are missed power-saving opportunities for bursty
workloads with long idle times (e.g. MP3 playback.)  Given such a
workload, because of the load average, CPUidle tends to pick a shallow
C-state.  Because we also go tickless, this shallow C-state is used
for the duration of the idle period. If the idle period is long, a
deeper C state would've resulted in better power savings.
This patch provides an additional opportuntity for CPUidle to pick a
deeper C-state by programming a timer (with a C-state specific timeout)
such that the CPUidle governor will have another opportunity to pick a
deeper C-state.

Adding this timer for C-state reevaluation improved the load estimation
on our ARM/OMAP4 platform and increased the time spent in deep C-states
(~50% of idle time in C-states deeper than C1).  A power saving of ~10mA
at battery level is observed during MP3 playback on OMAP4/Blaze board.

Signed-off-by: Nicole Chalhoub <n-chalhoub@ti.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 drivers/cpuidle/cpuidle.c        |   28 +++++++++++++++++++++++++-
 drivers/cpuidle/governors/menu.c |   39 ++++++++++++++++++++++++++++++++-----
 include/linux/cpuidle.h          |    4 +++
 3 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 1994885..4b1ac0c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -92,13 +92,33 @@ static void cpuidle_idle_call(void)
 	target_state->time += (unsigned long long)dev->last_residency;
 	target_state->usage++;
 
-	/* give the governor an opportunity to reflect on the outcome */
-	if (cpuidle_curr_governor->reflect)
+	hrtimer_cancel(&dev->cstate_timer);
+
+	/*
+	 * Give the governor an opportunity to reflect on the outcome
+	 * Do not take into account the wakeups due to the hrtimer, they
+	 * should not impact the predicted idle time.
+	 */
+	if ((!dev->hrtimer_expired) && cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
 	trace_power_end(0);
 }
 
 /**
+ * cstate_reassessment_timer - interrupt handler of the cstate hrtimer
+ * @handle:	the expired hrtimer
+ */
+static enum hrtimer_restart cstate_reassessment_timer(struct hrtimer *handle)
+{
+	struct cpuidle_device *data =
+		container_of(handle, struct cpuidle_device, cstate_timer);
+
+	data->hrtimer_expired = 1;
+
+	return HRTIMER_NORESTART;
+}
+
+/**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
  */
 void cpuidle_install_idle_handler(void)
@@ -185,6 +205,10 @@ int cpuidle_enable_device(struct cpuidle_device *dev)
 
 	dev->enabled = 1;
 
+	dev->hrtimer_expired = 0;
+	hrtimer_init(&dev->cstate_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	dev->cstate_timer.function = cstate_reassessment_timer;
+
 	enabled_devices++;
 	return 0;
 
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 1b12870..fd54584 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -125,10 +125,21 @@ struct menu_device {
 #define LOAD_INT(x) ((x) >> FSHIFT)
 #define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
 
-static int get_loadavg(void)
+static int get_loadavg(struct cpuidle_device *dev)
 {
-	unsigned long this = this_cpu_load();
+	unsigned long this;
 
+	/*
+	 * this_cpu_load() returns the value of rq->load.weight
+	 * at the previous scheduler tick and not the current value.
+	 * If the timer expired, that means we are in idle,there
+	 * are no more runnable processes in the current queue
+	 * =>return the current value of rq->load.weight which is 0.
+	 */
+	if (dev->hrtimer_expired == 1)
+		return 0;
+	else
+		this = this_cpu_load();
 
 	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
 }
@@ -166,13 +177,13 @@ static inline int which_bucket(unsigned int duration)
  * to be, the higher this multiplier, and thus the higher
  * the barrier to go to an expensive C state.
  */
-static inline int performance_multiplier(void)
+static inline int performance_multiplier(struct cpuidle_device *dev)
 {
 	int mult = 1;
 
 	/* for higher loadavg, we are more reluctant */
 
-	mult += 2 * get_loadavg();
+	mult += 2 * get_loadavg(dev);
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
 	mult += 10 * nr_iowait_cpu(smp_processor_id());
@@ -236,6 +247,7 @@ static int menu_select(struct cpuidle_device *dev)
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 	int i;
 	int multiplier;
+	ktime_t timeout;
 
 	if (data->needs_update) {
 		menu_update(dev);
@@ -256,7 +268,7 @@ static int menu_select(struct cpuidle_device *dev)
 
 	data->bucket = which_bucket(data->expected_us);
 
-	multiplier = performance_multiplier();
+	multiplier = performance_multiplier(dev);
 
 	/*
 	 * if the correction factor is 0 (eg first time init or cpu hotplug
@@ -287,12 +299,27 @@ static int menu_select(struct cpuidle_device *dev)
 			break;
 		if (s->exit_latency > latency_req)
 			break;
-		if (s->exit_latency * multiplier > data->predicted_us)
+		if (s->exit_latency * multiplier > data->predicted_us) {
+			/*
+			 * Could not enter the next C-state because of a high
+			 * load. Set a timer in order to check the load again
+			 * after the timeout expires and re-evaluate cstate.
+			 */
+			if (s->hrtimer_timeout != 0 && get_loadavg(dev)) {
+				timeout =
+				       ktime_set(0,
+					   s->hrtimer_timeout * NSEC_PER_USEC);
+				hrtimer_start(&dev->cstate_timer, timeout,
+					   HRTIMER_MODE_REL);
+			}
 			break;
+		}
 		data->exit_us = s->exit_latency;
 		data->last_state_idx = i;
 	}
 
+	/* Reset hrtimer_expired which is set when the hrtimer fires */
+	dev->hrtimer_expired = 0;
 	return data->last_state_idx;
 }
 
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 55215cc..8d11b52 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/completion.h>
+#include <linux/hrtimer.h>
 
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
@@ -37,6 +38,7 @@ struct cpuidle_state {
 	unsigned int	exit_latency; /* in US */
 	unsigned int	power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
+	unsigned int	hrtimer_timeout; /* in US */
 
 	unsigned long long	usage;
 	unsigned long long	time; /* in US */
@@ -97,6 +99,8 @@ struct cpuidle_device {
 	struct completion	kobj_unregister;
 	void			*governor_data;
 	struct cpuidle_state	*safe_state;
+	struct hrtimer          cstate_timer;
+	unsigned int            hrtimer_expired;
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
-- 
1.7.0.4

