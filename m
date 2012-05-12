Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2ELJlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 05:41:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41501 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517Ab2ELJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 05:41:31 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org, akpm@linux-foundation.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        durgadoss.r@intel.com, lenb@kernel.org, rui.zhang@intel.com,
        linux-acpi@vger.kernel.org, linaro-dev@lists.linaro.org,
        lm-sensors@lm-sensors.org, amit.kachhap@linaro.org, khali@linux-fr.org,
        guenter.roeck@ericsson.com, patches@linaro.org
Subject: [PATCH v4 5/5] ARM: exynos: Add thermal sensor driver platform data support
Date: Sat, 12 May 2012 15:10:45 +0530
Message-Id: <1336815645-29625-6-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1336815645-29625-1-git-send-email-amit.kachhap@linaro.org>
References: <1336815645-29625-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds necessary default platform data support needed for TMU driver.
This dt/non-dt values are tested for origen exynos4210 and smdk exynos5250 platforms.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
---
 drivers/thermal/exynos_thermal.c |  111 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 110 insertions(+), 1 deletions(-)

diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 48106d8..e4e6759 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -662,14 +662,121 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
 static struct thermal_sensor_conf exynos_sensor_conf = {
 	.name			= "exynos-therm",
 	.read_temperature	= (int (*)(void *))exynos_tmu_read,
+};
+
+#if defined(CONFIG_CPU_EXYNOS4210)
+static struct exynos_tmu_platform_data const exynos4_default_tmu_data = {
+	.threshold = 80,
+	.trigger_levels[0] = 5,
+	.trigger_levels[1] = 20,
+	.trigger_levels[2] = 30,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 15,
+	.reference_voltage = 7,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 100,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS4,
+};
+#define EXYNOS4_TMU_DRV_DATA (&exynos4_default_tmu_data)
+#else
+#define EXYNOS4_TMU_DRV_DATA (NULL)
+#endif
+
+#if defined(CONFIG_SOC_EXYNOS5250)
+static struct exynos_tmu_platform_data const exynos5_default_tmu_data = {
+	.trigger_levels[0] = 85,
+	.trigger_levels[1] = 103,
+	.trigger_levels[2] = 110,
+	.trigger_level0_en = 1,
+	.trigger_level1_en = 1,
+	.trigger_level2_en = 1,
+	.trigger_level3_en = 0,
+	.gain = 8,
+	.reference_voltage = 16,
+	.noise_cancel_mode = 4,
+	.cal_type = TYPE_ONE_POINT_TRIMMING,
+	.efuse_value = 55,
+	.freq_tab[0] = {
+		.freq_clip_max = 800 * 1000,
+		.temp_level = 85,
+	},
+	.freq_tab[1] = {
+		.freq_clip_max = 200 * 1000,
+		.temp_level = 103,
+	},
+	.freq_tab_count = 2,
+	.type = SOC_ARCH_EXYNOS5,
+};
+#define EXYNOS5_TMU_DRV_DATA (&exynos5_default_tmu_data)
+#else
+#define EXYNOS5_TMU_DRV_DATA (NULL)
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id exynos_tmu_match[] = {
+	{
+		.compatible = "samsung,exynos4-tmu",
+		.data = (void *)EXYNOS4_TMU_DRV_DATA,
+	},
+	{
+		.compatible = "samsung,exynos5-tmu",
+		.data = (void *)EXYNOS5_TMU_DRV_DATA,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_tmu_match);
+#else
+#define  exynos_tmu_match NULL
+#endif
+
+static struct platform_device_id exynos_tmu_driver_ids[] = {
+	{
+		.name		= "exynos4-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS4_TMU_DRV_DATA,
+	},
+	{
+		.name		= "exynos5-tmu",
+		.driver_data    = (kernel_ulong_t)EXYNOS5_TMU_DRV_DATA,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, exynos4_tmu_driver_ids);
+
+static inline struct  exynos_tmu_platform_data *exynos_get_driver_data(
+			struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(exynos_tmu_match, pdev->dev.of_node);
+		if (!match)
+			return NULL;
+		return (struct exynos_tmu_platform_data *) match->data;
+	}
+#endif
+	return (struct exynos_tmu_platform_data *)
+			platform_get_device_id(pdev)->driver_data;
 }
-;
 static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
 	struct exynos_tmu_data *data;
 	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
 	int ret, i;
 
+	if (!pdata)
+		pdata = exynos_get_driver_data(pdev);
+
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
@@ -832,11 +939,13 @@ static struct platform_driver exynos_tmu_driver = {
 	.driver = {
 		.name   = "exynos-tmu",
 		.owner  = THIS_MODULE,
+		.of_match_table = exynos_tmu_match,
 	},
 	.probe = exynos_tmu_probe,
 	.remove	= __devexit_p(exynos_tmu_remove),
 	.suspend = exynos_tmu_suspend,
 	.resume = exynos_tmu_resume,
+	.id_table = exynos_tmu_driver_ids,
 };
 
 module_platform_driver(exynos_tmu_driver);
-- 
1.7.1

