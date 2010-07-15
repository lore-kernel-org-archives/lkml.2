Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934696Ab0GOUbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:31:03 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57625 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934681Ab0GOUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:30:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6044"; a="47456207"
X-IronPort-AV: E=Sophos;i="4.55,208,1278313200"; 
   d="scan'208";a="42849861"
From: Ai Li <aili@codeaurora.org>
To: akpm@linux-foundation.org, dwalker@codeaurora.org
Cc: arjan@linux.intel.com, mingo@elte.hu, shemminger@vyatta.com,
        czoccolo@gmail.com, len.brown@intel.com, aili@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: [PATCH] cpuidle: extend cpuidle and menu governor to handle dynamic states
Date: Thu, 15 Jul 2010 14:30:25 -0600
Message-Id: <1279225825-31069-1-git-send-email-aili@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some SoC chips, HW resources may be in use during any particular idle
period.  As a consequence, the cpuidle states that the SoC is safe to
enter can change from idle period to idle period.  In addition, the
latency and threshold of each cpuidle state can vary, depending on the
operating condition when the CPU becomes idle, e.g. the current cpu
frequency, the current state of the HW blocks, etc.

cpuidle core and the menu governor, in the current form, are geared
towards cpuidle states that are static, i.e. the availabiltiy of the
states, their latencies, their thresholds are non-changing during run
time.  cpuidle does not provide any hook that cpuidle drivers can use
to adjust those values on the fly for the current idle period before the
menu governor selects the target cpuidle state.

This patch extends cpuidle core and the menu governor to handle states
that are dynamic.  There are three additions in the patch and the patch
maintains backwards-compatibility with existing cpuidle drivers.

1) add prepare() to struct cpuidle_device.  A cpuidle driver can hook
into the callback and the menu governor will call prepare() in
menu_select().  The callback gives the cpuidle driver a chance to update
the dynamic information of the cpuidle states for the current idle
period, e.g. state availability, latencies, thresholds, power values,
etc.

2) add CPUIDLE_FLAG_IGNORE as one of the state flags.  In the prepare()
function, a cpuidle driver can set/clear the flag to indicate to the
menu governor whether a cpuidle state should be ignored, i.e. not
available, during the current idle period.

3) add compare_power bit to struct cpuidle_device.  The menu governor
currently assumes that the cpuidle states are arranged in the order of
increasing latency, threshold, and power savings.  This is true or can
be made true for static states.  Once the state parameters are dynamic,
the latencies, thresholds, and power savings for the cpuidle states can
increase or decrease by different amounts from idle period to idle
period.  So the assumption of increasing latency, threshold, and power
savings from Cn to C(n+1) can no longer be guaranteed.

It can be straight forward to calculate the power consumption of each
available state for the predicted idle period.  The menu governor then
selects the state that has the lowest power consumption and that still
satisfies all other critieria.  When the compare_power bit is true, the
menu governor uses the power_usage fields to find the lowest power
state instead of relying on the above assumption.

Signed-off-by: Ai Li <aili@codeaurora.org>
---
 drivers/cpuidle/governors/menu.c |   59 +++++++++++++++++++++++++++++--------
 include/linux/cpuidle.h          |    4 ++
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 1b12870..b3854cc 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -271,6 +271,9 @@ static int menu_select(struct cpuidle_device *dev)
 
 	detect_repeating_patterns(data);
 
+	if (dev->prepare)
+		dev->prepare(dev, data->predicted_us);
+
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
@@ -278,19 +281,49 @@ static int menu_select(struct cpuidle_device *dev)
 	if (data->expected_us > 5)
 		data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
 
-
-	/* find the deepest idle state that satisfies our constraints */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
-		struct cpuidle_state *s = &dev->states[i];
-
-		if (s->target_residency > data->predicted_us)
-			break;
-		if (s->exit_latency > latency_req)
-			break;
-		if (s->exit_latency * multiplier > data->predicted_us)
-			break;
-		data->exit_us = s->exit_latency;
-		data->last_state_idx = i;
+	if (dev->compare_power) {
+		/* find the idle state with the lowest power while satisfying
+		 * our constraints
+		 */
+		unsigned int power_usage = (unsigned int) ~0UL;
+
+		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
+			struct cpuidle_state *s = &dev->states[i];
+
+			if (s->flags & CPUIDLE_FLAG_IGNORE)
+				continue;
+			if (s->target_residency > data->predicted_us)
+				continue;
+			if (s->exit_latency > latency_req)
+				continue;
+			if (s->exit_latency * multiplier > data->predicted_us)
+				continue;
+
+			if (s->power_usage < power_usage) {
+				power_usage = s->power_usage;
+				data->exit_us = s->exit_latency;
+				data->last_state_idx = i;
+			}
+		}
+	} else {
+		/* find the deepest idle state that satisfies our
+		 * constraints
+		 */
+		for (i = CPUIDLE_DRIVER_STATE_START; i < dev->state_count; i++) {
+			struct cpuidle_state *s = &dev->states[i];
+
+			if (s->flags & CPUIDLE_FLAG_IGNORE)
+				continue;
+
+			if (s->target_residency > data->predicted_us)
+				break;
+			if (s->exit_latency > latency_req)
+				break;
+			if (s->exit_latency * multiplier > data->predicted_us)
+				break;
+			data->exit_us = s->exit_latency;
+			data->last_state_idx = i;
+		}
 	}
 
 	return data->last_state_idx;
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 55215cc..4406670 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -52,6 +52,7 @@ struct cpuidle_state {
 #define CPUIDLE_FLAG_SHALLOW	(0x20) /* low latency, minimal savings */
 #define CPUIDLE_FLAG_BALANCED	(0x40) /* medium latency, moderate savings */
 #define CPUIDLE_FLAG_DEEP	(0x80) /* high latency, large savings */
+#define CPUIDLE_FLAG_IGNORE	(0x100) /* ignore during this idle period */
 
 #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
 
@@ -84,6 +85,7 @@ struct cpuidle_state_kobj {
 struct cpuidle_device {
 	unsigned int		registered:1;
 	unsigned int		enabled:1;
+	unsigned int		compare_power:1;
 	unsigned int		cpu;
 
 	int			last_residency;
@@ -97,6 +99,8 @@ struct cpuidle_device {
 	struct completion	kobj_unregister;
 	void			*governor_data;
 	struct cpuidle_state	*safe_state;
+
+	int (*prepare)		(struct cpuidle_device *dev, int idle_us);
 };
 
 DECLARE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
-- 
1.5.6.3

Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
