Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2LNN5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:57:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60871 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab2LNN5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:57:45 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@sisk.pl
Cc: jwerner@chromium.org, francescolavra.fl@gmail.com,
        linux-pm@vger.kernel.org, deepthi@linux.vnet.ibm.com,
        g.trinabh@gmail.com, linaro-dev@lists.linaro.org, len.brown@intel.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        snanda@chromium.org
Subject: [PATCH 2/2][V2] cpuidle - optimize the select function for the 'menu' governor
Date: Fri, 14 Dec 2012 14:57:35 +0100
Message-Id: <1355493455-30665-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1355493455-30665-1-git-send-email-daniel.lezcano@linaro.org>
References: <1355493455-30665-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the power is backward sorted in the states array and we are looking for
the state consuming the little power as possible, instead of looking from
the beginning of the array, we look from the end. That should save us some
iterations in the loop each time we select a state at idle time.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index fe343a0..05b8998 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -367,24 +367,24 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	 * Find the idle state with the lowest power while satisfying
 	 * our constraints.
 	 */
-	for (i = CPUIDLE_DRIVER_STATE_START; i < drv->state_count; i++) {
+	for (i = drv->state_count - 1; i >= CPUIDLE_DRIVER_STATE_START; i--) {
 		struct cpuidle_state *s = &drv->states[i];
 		struct cpuidle_state_usage *su = &dev->states_usage[i];
 
 		if (s->disabled || su->disable)
 			continue;
-		if (s->target_residency > data->predicted_us) {
-			low_predicted = 1;
-			continue;
-		}
 		if (s->exit_latency > latency_req)
 			continue;
+		if (s->target_residency > data->predicted_us)
+			continue;
 		if (s->exit_latency * multiplier > data->predicted_us)
 			continue;
 
+		low_predicted = i - CPUIDLE_DRIVER_STATE_START;
 		data->last_state_idx = i;
 		data->exit_us = s->exit_latency;
-	}
+		break;
+       }
 
 	/* not deepest C-state chosen for low predicted residency */
 	if (low_predicted) {
-- 
1.7.5.4

