Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1LUAJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:09:26 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62070 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1LUAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:09:15 -0500
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org
Cc: Len Brown <len.brown@intel.com>, Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>
Subject: [PATCH 1/3] cpuidle: refactor out cpuidle_enter_state
Date: Tue, 20 Dec 2011 16:09:05 -0800
Message-Id: <1324426147-16735-2-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1324426147-16735-1-git-send-email-ccross@android.com>
References: <1324426147-16735-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the code to enter a state and update the stats into a helper
function, cpuidle_enter_state, and export it.  This function will
be called by the coupled state code to handle entering the safe
state and the final coupled state.

Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/cpuidle/cpuidle.c |   43 +++++++++++++++++++++++++++++--------------
 drivers/cpuidle/cpuidle.h |    2 ++
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 06ce268..1486b3c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -54,6 +54,34 @@ static void cpuidle_kick_cpus(void) {}
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 /**
+ * cpuidle_enter_state
+ *
+ * enter the state and update stats
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
@@ -63,7 +91,6 @@ int cpuidle_idle_call(void)
 {
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_driver();
-	struct cpuidle_state *target_state;
 	int next_state, entered_state;
 
 	if (off)
@@ -92,26 +119,14 @@ int cpuidle_idle_call(void)
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
index 38c3fd8..dd2df8f 100644
--- a/drivers/cpuidle/cpuidle.h
+++ b/drivers/cpuidle/cpuidle.h
@@ -14,6 +14,8 @@ extern struct list_head cpuidle_detected_devices;
 extern struct mutex cpuidle_lock;
 extern spinlock_t cpuidle_driver_lock;
 extern int cpuidle_disabled(void);
+int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
+		int next_state);
 
 /* idle loop */
 extern void cpuidle_install_idle_handler(void);
-- 
1.7.4.1

