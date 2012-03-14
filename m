Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2CNSaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 14:30:11 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54854 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2CNSaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 14:30:00 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@lists.linux-foundation.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCHv2 1/5] cpuidle: refactor out cpuidle_enter_state
Date: Wed, 14 Mar 2012 11:29:50 -0700
Message-Id: <1331749794-8056-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1331749794-8056-1-git-send-email-ccross@android.com>
References: <1331749794-8056-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the code to enter a state and update the stats into a helper
function, cpuidle_enter_state, and export it.  This function will
be called by the coupled state code to handle entering the safe
state and the final coupled state.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/cpuidle.c |   44 ++++++++++++++++++++++++++++++--------------
 drivers/cpuidle/cpuidle.h |    2 ++
 2 files changed, 32 insertions(+), 14 deletions(-)

v2:
   * fixed kerneldoc comment format

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 59f4261..1453830 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -54,6 +54,35 @@ static void cpuidle_kick_cpus(void) {}
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 /**
+ * cpuidle_enter_state - enter the state and update stats
+ * @dev: cpuidle device for this cpu
+ * @drv: cpuidle driver for this cpu
+ * @next_state: index into drv->states of the state to enter
+ */
+int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
+		int next_state)
+{
+	int entered_state;
+	struct cpuidle_state *target_state;
+
+	target_state = &drv->states[next_state];
+
+	entered_state = target_state->enter(dev, drv, next_state);
+
+	if (entered_state >= 0) {
+		/* Update cpuidle counters */
+		/* This can be moved to within driver enter routine
+		 * but that results in multiple copies of same code.
+		 */
+		dev->states_usage[entered_state].time +=
+				(unsigned long long)dev->last_residency;
+		dev->states_usage[entered_state].usage++;
+	}
+
+	return entered_state;
+}
+
+/**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
@@ -63,7 +92,6 @@ int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_driver();
-	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
 	if (off)
@@ -92,26 +120,14 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	target_state = &drv->states[next_state];
-
 	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle(next_state, dev->cpu);
 
-	entered_state = target_state->enter(dev, drv, next_state);
+	entered_state = cpuidle_enter_state(dev, drv, next_state);
 
 	trace_power_end(dev->cpu);
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
-	if (entered_state >= 0) {
-		/* Update cpuidle counters */
-		/* This can be moved to within driver enter routine
-		 * but that results in multiple copies of same code.
-		 */
-		dev->states_usage[entered_state].time +=
-				(unsigned long long)dev->last_residency;
-		dev->states_usage[entered_state].usage++;
-	}
-
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);
diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
index 7db1866..d8a3ccc 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -14,6 +14,8 @@ extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
 extern spinlock_t cpuidle_driver_lock;
 extern int cpuidle_disabled(void);
+extern int cpuidle_enter_state(struct cpuidle_device *dev,
+		struct cpuidle_driver *drv, int next_state);
 
 /* idle loop */
 extern void cpuidle_install_idle_handler(void);
-- 
1.7.9.2

