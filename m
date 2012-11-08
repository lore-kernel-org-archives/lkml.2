Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab2KHE1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:27:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44206 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443Ab2KHE0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:26:54 -0500
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com, lenb@kernel.org, rui.zhang@intel.com,
        linux-acpi@vger.kernel.org, amit.kachhap@linaro.org,
        jonghwa3.lee@samsung.com
Subject: [PATCH 3/4] thermal: exynos: Miscellaneous fixes to support falling threshold interrupt
Date: Thu,  8 Nov 2012 09:56:26 +0530
Message-Id: <1352348786-24255-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below fixes are done to support falling threshold interrupt,
* Falling interrupt status macro corrected according to exynos5 data sheet.
* The get trend function modified to calculate trip temperature correctly.
* The clearing of interrupt status in the isr is now done after handling
  the the event that caused the interrupt.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/exynos_thermal.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index f6667e8..bbaff56 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -82,7 +82,7 @@
 
 #define EXYNOS_TRIMINFO_RELOAD		0x1
 #define EXYNOS_TMU_CLEAR_RISE_INT	0x111
-#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 16)
+#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 12)
 #define EXYNOS_MUX_ADDR_VALUE		6
 #define EXYNOS_MUX_ADDR_SHIFT		20
 #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
@@ -365,12 +365,19 @@ static int exynos_get_temp(struct thermal_zone_device *thermal,
 static int exynos_get_trend(struct thermal_zone_device *thermal,
 			int trip, enum thermal_trend *trend)
 {
-	if (thermal->temperature >= trip)
+	int ret = 0;
+	unsigned long trip_temp;
+
+	ret = exynos_get_trip_temp(thermal, trip, &trip_temp);
+	if (ret < 0)
+		return ret;
+
+	if (thermal->temperature >= trip_temp)
 		*trend = THERMAL_TREND_RAISING;
 	else
 		*trend = THERMAL_TREND_DROPPING;
 
-	return 0;
+	return ret;
 }
 /* Operation callback functions for thermal zone */
 static struct thermal_zone_device_ops const exynos_dev_ops = {
@@ -704,10 +711,9 @@ static void exynos_tmu_work(struct work_struct *work)
 	struct exynos_tmu_data *data = container_of(work,
 			struct exynos_tmu_data, irq_work);
 
+	exynos_report_trigger();
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
-
-
 	if (data->soc == SOC_ARCH_EXYNOS)
 		writel(EXYNOS_TMU_CLEAR_RISE_INT |
 				EXYNOS_TMU_CLEAR_FALL_INT,
@@ -715,10 +721,8 @@ static void exynos_tmu_work(struct work_struct *work)
 	else
 		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
 				data->base + EXYNOS_TMU_REG_INTCLEAR);
-
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
-	exynos_report_trigger();
 	enable_irq(data->irq);
 }
 
-- 
1.7.1

