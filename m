Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab2GYDmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 23:42:38 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33308 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2GYDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 23:42:29 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 15/52] cpuidle: refactor out cpuidle_enter_state
Date: Tue, 24 Jul 2012 23:41:11 -0400
Message-Id: <56cfbf74a17c40f3a741398103c9f5d5a6806715.1343187617.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.12.rc0
In-Reply-To: <1343187708-19532-1-git-send-email-lenb@kernel.org>
References: <1343187708-19532-1-git-send-email-lenb@kernel.org>
In-Reply-To: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
References: <6af1c4fc5227af65092ebc848989693562bfa3e8.1343187617.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Split the code to enter a state and update the stats into a helper
function, cpuidle_enter_state, and export it.  This function will
be called by the coupled state code to handle entering the safe
state and the final coupled state.

Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>
Tested-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Colin Cross <ccross@android.com>
Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/cpuidle/cpuidle.c | 42 +++++++++++++++++++++++++++++-------------
 drivers/cpuidle/cpuidle.h |  2 ++
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 2f0083a..3e3e3e4 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -103,6 +103,34 @@ int cpuidle_play_dead(void)
 }
 
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
+
+	entered_state = cpuidle_enter_ops(dev, drv, next_state);
+
+	if (entered_state >= 0) {
+		/* Update cpuidle counters */
+		/* This can be moved to within driver enter routine
+		 * but that results in multiple copies of same code.
+		 */
+		dev->states_usage[entered_state].time +=
+				(unsigned long long)dev->last_residency;
+		dev->states_usage[entered_state].usage++;
+	} else {
+		dev->last_residency = 0;
+	}
+
+	return entered_state;
+}
+
+/**
  * cpuidle_idle_call - the main idle loop
  *
  * NOTE: no locks or semaphores should be used here
@@ -143,23 +171,11 @@ int cpuidle_idle_call(void)
 	trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);
 	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
-	entered_state = cpuidle_enter_ops(dev, drv, next_state);
+	entered_state = cpuidle_enter_state(dev, drv, next_state);
 
 	trace_power_end_rcuidle(dev->cpu);
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
 
-	if (entered_state >= 0) {
-		/* Update cpuidle counters */
-		/* This can be moved to within driver enter routine
-		 * but that results in multiple copies of same code.
-		 */
-		dev->states_usage[entered_state].time +=
-				(unsigned long long)dev->last_residency;
-		dev->states_usage[entered_state].usage++;
-	} else {
-		dev->last_residency = 0;
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
1.7.12.rc0

