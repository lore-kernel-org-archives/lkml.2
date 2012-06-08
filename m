Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab2FHQDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:03:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42644 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2FHQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:02:50 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: lenb@kernel.org
Cc: linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: [RFC 2/4] cpuidle: move enter_dead to the driver structure
Date: Fri,  8 Jun 2012 18:02:43 +0200
Message-Id: <1339171365-4098-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
References: <1339171365-4098-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'enter_dead' function is only used for processor_idle.c
and the same function is used several times. We fall into the
same abuse with the multiple callbacks for the same function.

This patch fixes that by moving the 'enter_dead' function to the
driver structure. A flag CPUIDLE_FLAG_DEAD_VALID has been added
to handle the callback conditional invokation.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/acpi/processor_idle.c |    7 +++----
 drivers/cpuidle/cpuidle.c     |    4 ++--
 include/linux/cpuidle.h       |   25 +++++++++++++++++--------
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f3decb3..5590ab4 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -996,6 +996,7 @@ static int acpi_idle_enter_bm(struct cpuidle_device *dev,
 struct cpuidle_driver acpi_idle_driver = {
 	.name =		"acpi_idle",
 	.owner =	THIS_MODULE,
+	.enter_dead = acpi_idle_play_dead,
 };
 
 /**
@@ -1104,16 +1105,14 @@ static int acpi_processor_setup_cpuidle_states(struct acpi_processor *pr)
 			case ACPI_STATE_C1:
 			if (cx->entry_method == ACPI_CSTATE_FFH)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
-
+			state->flags |= CPUIDLE_FLAG_DEAD_VALID;
 			state->enter = acpi_idle_enter_c1;
-			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 			break;
 
 			case ACPI_STATE_C2:
-			state->flags |= CPUIDLE_FLAG_TIME_VALID;
+			state->flags |= CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_DEAD_VALID;
 			state->enter = acpi_idle_enter_simple;
-			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 			break;
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 155dee7..68bf115 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -81,14 +81,14 @@ int cpuidle_play_dead(void)
 	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
 		struct cpuidle_state *s = &drv->states[i];
 
-		if (s->power_usage < power_usage && s->enter_dead) {
+		if (s->power_usage < power_usage && (s->flags & CPUIDLE_FLAG_DEAD_VALID)) {
 			power_usage = s->power_usage;
 			dead_state = i;
 		}
 	}
 
 	if (dead_state != -1)
-		return drv->states[dead_state].enter_dead(dev, dead_state);
+		return drv->enter_dead(dev, dead_state);
 
 	return -ENODEV;
 }
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index d82e169..f5915e9 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -49,16 +49,24 @@ struct cpuidle_state {
 	unsigned int    disable;
 
 	int (*enter)	(struct cpuidle_device *dev,
-			struct cpuidle_driver *drv,
-			int index);
-
-	int (*enter_dead) (struct cpuidle_device *dev, int index);
+			 struct cpuidle_driver *drv,
+			 int index);
 };
 
-/* Idle State Flags */
-#define CPUIDLE_FLAG_TIME_VALID	(0x01) /* is residency time measurable? */
-
-#define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
+/********************************************************************************
+ * Idle State Flags:                                                            *
+ * CPUIDLE_FLAG_TIME_VALID  : the drivers could measure the state residency     *
+ *                            time and store it in the 'target_residency'field. *
+ *                            This flag will tell the cpuidle core to use this  *
+ *                            value to compute an accurate prediction.          *
+ *                                                                              *
+ * CPUIDLE_FLAG_DEAD_VALID  : the driver may want to deal with dead cpus, tell  *
+ *                            the cpuidle core the specified state can use the  *
+ *                            enter_dead function.                              *
+ *                                                                              *
+ *******************************************************************************/
+#define CPUIDLE_FLAG_TIME_VALID  0x01
+#define CPUIDLE_FLAG_DEAD_VALID  0x02
 
 /**
  * cpuidle_get_statedata - retrieves private driver state data
@@ -131,6 +139,7 @@ struct cpuidle_driver {
 	int			state_count;
 	int			safe_state_index;
 	int (*enter)(struct cpuidle_device *, struct cpuidle_driver *, int);
+	int (*enter_dead)(struct cpuidle_device *, int);
 };
 
 #ifdef CONFIG_CPU_IDLE
-- 
1.7.5.4

