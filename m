Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1ATUeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:34:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55352 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1ATUdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:33:24 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6232"; a="71278394"
From: Daniel Walker <dwalker@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidb@codeaurora.org, Daniel Walker <dwalker@codeaurora.org>
Subject: [PATCH 5/7] msm: mahimahi: add in mmc support code
Date: Thu, 20 Jan 2011 12:32:43 -0800
Message-Id: <1295555565-21563-6-git-send-email-dwalker@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
References: <1295555565-21563-1-git-send-email-dwalker@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds code to enable MMC on mahimahi.

This code was taken from Google's tree, with slight modifications
and clean up.

Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
---
 arch/arm/mach-msm/Makefile             |    1 +
 arch/arm/mach-msm/board-mahimahi-mmc.c |  206 ++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-mahimahi-mmc.c

diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index a0ebce4..5012c37 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
 obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
 obj-$(CONFIG_ARCH_MSM8X60) += board-msm8x60.o
 obj-$(CONFIG_MACH_MAHIMAHI) += board-mahimahi.o
+obj-$(CONFIG_MACH_MAHIMAHI) += board-mahimahi-mmc.o
 
 obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
 obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
diff --git a/arch/arm/mach-msm/board-mahimahi-mmc.c b/arch/arm/mach-msm/board-mahimahi-mmc.c
new file mode 100644
index 0000000..991818e
--- /dev/null
+++ b/arch/arm/mach-msm/board-mahimahi-mmc.c
@@ -0,0 +1,206 @@
+/* linux/arch/arm/mach-msm/board-mahimahi-mmc.c
+ *
+ * Copyright (C) 2009 Google, Inc.
+ * Copyright (C) 2009 HTC Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/platform_device.h>
+
+#include <asm/gpio.h>
+#include <asm/io.h>
+#include <asm/mach-types.h>
+#include <mach/mmc.h>
+
+#include <mach/vreg.h>
+
+#include "board-mahimahi.h"
+#include "devices.h"
+#include "proc_comm.h"
+
+static bool opt_disable_sdcard;
+static int __init mahimahi_disablesdcard_setup(char *str)
+{
+	opt_disable_sdcard = (bool)simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("board_mahimahi.disable_sdcard=", mahimahi_disablesdcard_setup);
+
+static struct msm_mmc_gpio sdc1_gpio_cfg[] = {
+	{62, "sdc1_clk"},
+	{63, "sdc1_cmd"},
+	{64, "sdc1_dat_3"},
+	{65, "sdc1_dat_2"},
+	{66, "sdc1_dat_1"},
+	{67, "sdc1_dat_0"},
+};
+
+static struct vreg	*sdslot_vreg;
+static uint32_t		sdslot_vdd = 0xffffffff;
+static uint32_t		sdslot_vreg_enabled;
+
+static struct {
+	int mask;
+	int level;
+} mmc_vdd_table[] = {
+	{ MMC_VDD_165_195,	1800 },
+	{ MMC_VDD_20_21,	2050 },
+	{ MMC_VDD_21_22,	2150 },
+	{ MMC_VDD_22_23,	2250 },
+	{ MMC_VDD_23_24,	2350 },
+	{ MMC_VDD_24_25,	2450 },
+	{ MMC_VDD_25_26,	2550 },
+	{ MMC_VDD_26_27,	2650 },
+	{ MMC_VDD_27_28,	2750 },
+	{ MMC_VDD_28_29,	2850 },
+	{ MMC_VDD_29_30,	2950 },
+};
+
+static uint32_t mahimahi_sdslot_switchvdd(struct device *dev, unsigned int vdd)
+{
+	int i;
+	int ret;
+
+	if (vdd == sdslot_vdd)
+		return 0;
+
+	sdslot_vdd = vdd;
+
+	if (vdd == 0) {
+		vreg_disable(sdslot_vreg);
+		sdslot_vreg_enabled = 0;
+		return 0;
+	}
+
+	if (!sdslot_vreg_enabled) {
+		ret = vreg_enable(sdslot_vreg);
+		if (ret)
+			pr_err("Error enabling vreg (%d)\n", ret);
+		sdslot_vreg_enabled = 1;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(mmc_vdd_table); i++) {
+		if (mmc_vdd_table[i].mask != (1 << vdd))
+			continue;
+		ret = vreg_set_level(sdslot_vreg, mmc_vdd_table[i].level);
+		if (ret)
+			pr_err("Error setting level (%d)\n", ret);
+		return 0;
+	}
+
+	pr_err("Invalid VDD (%d) specified\n", vdd);
+	return 0;
+}
+
+static uint32_t
+mahimahi_cdma_sdslot_switchvdd(struct device *dev, unsigned int vdd)
+{
+	if (!vdd == !sdslot_vdd)
+		return 0;
+
+	/* In CDMA version, the vdd of sdslot is not configurable, and it is
+	 * fixed in 2.85V by hardware design.
+	 */
+
+	sdslot_vdd = vdd ? MMC_VDD_28_29 : 0;
+
+	if (vdd)
+		gpio_set_value(MAHIMAHI_CDMA_SD_2V85_EN, 1);
+	else
+		gpio_set_value(MAHIMAHI_CDMA_SD_2V85_EN, 0);
+
+	sdslot_vreg_enabled = !!vdd;
+
+	return 0;
+}
+
+static unsigned int mahimahi_sdslot_status_rev0(struct device *dev)
+{
+	return !gpio_get_value(MAHIMAHI_GPIO_SDMC_CD_REV0_N);
+}
+
+#define MAHIMAHI_MMC_VDD	(MMC_VDD_165_195 | MMC_VDD_20_21 | \
+				 MMC_VDD_21_22  | MMC_VDD_22_23 | \
+				 MMC_VDD_23_24 | MMC_VDD_24_25 | \
+				 MMC_VDD_25_26 | MMC_VDD_26_27 | \
+				 MMC_VDD_27_28 | MMC_VDD_28_29 | \
+				 MMC_VDD_29_30)
+
+static struct msm_mmc_gpio_data sdc1_gpio =
+	.gpio			= sdc1_gpio_cfg,
+	.size			= ARRAY_SIZE(sdc1_gpio_cfg),
+};
+
+static struct msm_mmc_platform_data mahimahi_sdslot_data = {
+	.ocr_mask		= MAHIMAHI_MMC_VDD,
+	.translate_vdd		= mahimahi_sdslot_switchvdd,
+	.gpio_data		= &sdc1_gpio,
+};
+
+int msm_add_sdcc(unsigned int controller, struct msm_mmc_platform_data *plat,
+		 unsigned int stat_irq, unsigned long stat_irq_flags);
+
+int __init mahimahi_init_mmc(unsigned int sys_rev, unsigned debug_uart)
+{
+	uint32_t id;
+
+	if (debug_uart) {
+		pr_info("%s: sdcard disabled due to debug uart\n", __func__);
+		goto done;
+	}
+	if (opt_disable_sdcard) {
+		pr_info("%s: sdcard disabled on cmdline\n", __func__);
+		goto done;
+	}
+
+	sdslot_vreg_enabled = 0;
+
+	if (is_cdma_version(sys_rev)) {
+		/* In the CDMA version, sdslot is supplied by a gpio. */
+		int rc = gpio_request(MAHIMAHI_CDMA_SD_2V85_EN, "sdslot_en");
+		if (rc < 0) {
+			pr_err("%s: gpio_request(%d) failed: %d\n", __func__,
+				MAHIMAHI_CDMA_SD_2V85_EN, rc);
+			return rc;
+		}
+		mahimahi_sdslot_data.translate_vdd = mahimahi_cdma_sdslot_switchvdd;
+	} else {
+		/* in UMTS version, sdslot is supplied by pmic */
+		sdslot_vreg = vreg_get(0, "gp6");
+		if (IS_ERR(sdslot_vreg))
+			return PTR_ERR(sdslot_vreg);
+	}
+
+	if (system_rev > 0)
+		msm_add_sdcc(2, &mahimahi_sdslot_data, 0, 0);
+	else {
+		mahimahi_sdslot_data.status = mahimahi_sdslot_status_rev0;
+		mahimahi_sdslot_data.register_status_notify = NULL;
+		set_irq_wake(MSM_GPIO_TO_INT(MAHIMAHI_GPIO_SDMC_CD_REV0_N), 1);
+		msm_add_sdcc(2, &mahimahi_sdslot_data,
+			     MSM_GPIO_TO_INT(MAHIMAHI_GPIO_SDMC_CD_REV0_N),
+			     IORESOURCE_IRQ_LOWEDGE | IORESOURCE_IRQ_HIGHEDGE);
+	}
+
+done:
+	return 0;
+}
-- 
1.7.0.4

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
