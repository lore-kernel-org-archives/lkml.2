Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab2CGDmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:42:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab2CGDm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:42:29 -0500
From: Robert Lee <rob.lee@linaro.org>
To: rjw@sisk.pl, len.brown@intel.com
Cc: khilman@ti.com, robherring2@gmail.com, Baohua.Song@csr.com,
        amit.kucheria@linaro.org, nicolas.ferre@atmel.com, linux@maxim.org.za,
        kgene.kim@samsung.com, amit.kachhap@linaro.org, magnus.damm@gmail.com,
        nsekhar@ti.com, daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, arnd.bergmann@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        deepthi@linux.vnet.ibm.com, broonie@opensource.wolfsonmicro.com,
        nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        jean.pihet@newoldbits.com, venki@google.com, ccross@google.com,
        g.trinabh@gmail.com, kernel@wantstofly.org, lethal@linux-sh.org,
        jon-hunter@ti.com, tony@atomide.com, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [RFC PATCH] cpuidle: avoid unnecessary expensive governor processing
Date: Tue,  6 Mar 2012 21:42:18 -0600
Message-Id: <1331091738-26322-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There a few cases when a platform's cpuidle_device will only have one
cpuidle state.  e.g., when a single idle state system uses cpuidle
to provide sysfs staticstics for profiling (powertop, etc).  This can
also be the case for coupled smp system implementations that keep
all but one cpuidle_device at a state_count of 1, but they still want
to export idle statistics for these states using cpuidle.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 drivers/cpuidle/governors/ladder.c |    7 +++++--
 drivers/cpuidle/governors/menu.c   |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index b6a09ea..13abdba 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -71,8 +71,11 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0)) {
+	/*
+	 * Special case when user has set very strict latency requirement or
+	 * there is currently only one state for this device.
+	 */
+	if ((latency_req == 0) || (dev->state_count == 1)) {
 		ladder_do_selection(ldev, last_idx, 0);
 		return 0;
 	}
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index ad09526..80eb606 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -249,8 +249,11 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	data->last_state_idx = 0;
 	data->exit_us = 0;
 
-	/* Special case when user has set very strict latency requirement */
-	if (unlikely(latency_req == 0))
+	/*
+	 * Special case when user has set very strict latency requirement or
+	 * there is currently only one state for this device.
+	 */
+	if ((latency_req == 0) || (dev->state_count == 1))
 		return 0;
 
 	/* determine the expected residency time, round up */
-- 
1.7.1

