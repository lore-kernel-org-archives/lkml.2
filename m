Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2GKMI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:08:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab2GKMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:08:12 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-91-4ffd6caa51d1
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH V3 5/7] mfd: samsung: Add s2mps11 irq driver
Date: Wed, 11 Jul 2012 21:08:11 +0900
Message-id: <012d01cd5f5d$d79ed3c0$86dc7b40$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXdeJr6rkAlIWTVmGWukLlmuTrw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t9jQd1VOX/9DbrmGVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mfdv2MxUcmMxYcXXyfbYGxubSLkZODgkBE4mNx98wQdhiEhfu
	rWfrYuTiEBKYzijxf+tpZghnLpPEx4WnwarYBDQkVu5+ywZiiwj4SvyethkozsHBLBAssfW0
	HkhYWMBG4t3aPlYQm0VAVeJ45z6wEl4BQ4mVDzlBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0ts
	XvOWGaRcQkBd4tFfXYhFehLX+7ayQ5SISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECA7LZ9I7GFc1WBxiFOBgVOLhPZD111+INbGsuDL3EKME
	B7OSCG+ND1CINyWxsiq1KD++qDQntfgQozQHi5I4r4n3V38hgfTEktTs1NSC1CKYLBMHp1QD
	Y6CmiVOW706VwmX7O57cNtC4tbru6YFti17ZtDAxFDyoMb7Z+2/L5jhD+dymuYsqWYLdVmpK
	nTBnX89n8eH7tEiN6zYMG14qSdd4q/eduzJlzwfPNQ87G7+w6Tit+r1/S4LtYbeErkf3UiKW
	dT4yDP1x6uHtlSetsm6unui9qX6PyftYjpO39ymxFGckGmoxFxUnAgAuuAFvRwIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support irq handling driver for s2mps11.
As this patch use regmap_irq, s5m8767 and s5m8763 are modified with
regmap_irq.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/Kconfig              |    1 +
 drivers/mfd/sec-irq.c            |  477 ++++++++++++--------------------------
 include/linux/mfd/samsung/core.h |    2 +
 include/linux/mfd/samsung/irq.h  |   42 ++++
 4 files changed, 193 insertions(+), 329 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index bad68f8..3c263a5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -513,6 +513,7 @@ config MFD_SEC_CORE
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	select REGMAP_I2C
+	select REGMAP_IRQ
 	help
 	 Support for the Samsung Electronics MFD series.
 	 This driver provides common support for accessing the device,
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index da5ec5b..c901fa5 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -14,351 +14,260 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/regmap.h>
+
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
+#include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
-struct sec_irq_data {
-	int reg;
-	int mask;
+static struct regmap_irq s2mps11_irqs[] = {
+	[S2MPS11_IRQ_PWRONF] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_PWRONF_MASK,
+	},
+	[S2MPS11_IRQ_PWRONR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_PWRONR_MASK,
+	},
+	[S2MPS11_IRQ_JIGONBF] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_JIGONBF_MASK,
+	},
+	[S2MPS11_IRQ_JIGONBR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_JIGONBR_MASK,
+	},
+	[S2MPS11_IRQ_ACOKBF] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_ACOKBF_MASK,
+	},
+	[S2MPS11_IRQ_ACOKBR] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_ACOKBR_MASK,
+	},
+	[S2MPS11_IRQ_PWRON1S] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_PWRON1S_MASK,
+	},
+	[S2MPS11_IRQ_MRB] = {
+		.reg_offset = 1,
+		.mask = S2MPS11_IRQ_MRB_MASK,
+	},
+	[S2MPS11_IRQ_RTC60S] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_RTC60S_MASK,
+	},
+	[S2MPS11_IRQ_RTCA1] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
+	},
+	[S2MPS11_IRQ_RTCA2] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_RTCA2_MASK,
+	},
+	[S2MPS11_IRQ_SMPL] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_SMPL_MASK,
+	},
+	[S2MPS11_IRQ_RTC1S] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_RTC1S_MASK,
+	},
+	[S2MPS11_IRQ_WTSR] = {
+		.reg_offset = 2,
+		.mask = S2MPS11_IRQ_WTSR_MASK,
+	},
+	[S2MPS11_IRQ_INT120C] = {
+		.reg_offset = 3,
+		.mask = S2MPS11_IRQ_INT120C_MASK,
+	},
+	[S2MPS11_IRQ_INT140C] = {
+		.reg_offset = 3,
+		.mask = S2MPS11_IRQ_INT140C_MASK,
+	},
 };
 
-static struct sec_irq_data s5m8767_irqs[] = {
+
+static struct regmap_irq s5m8767_irqs[] = {
 	[S5M8767_IRQ_PWRR] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_PWRR_MASK,
 	},
 	[S5M8767_IRQ_PWRF] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_PWRF_MASK,
 	},
 	[S5M8767_IRQ_PWR1S] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_PWR1S_MASK,
 	},
 	[S5M8767_IRQ_JIGR] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_JIGR_MASK,
 	},
 	[S5M8767_IRQ_JIGF] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_JIGF_MASK,
 	},
 	[S5M8767_IRQ_LOWBAT2] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_LOWBAT2_MASK,
 	},
 	[S5M8767_IRQ_LOWBAT1] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8767_IRQ_LOWBAT1_MASK,
 	},
 	[S5M8767_IRQ_MRB] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_MRB_MASK,
 	},
 	[S5M8767_IRQ_DVSOK2] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_DVSOK2_MASK,
 	},
 	[S5M8767_IRQ_DVSOK3] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_DVSOK3_MASK,
 	},
 	[S5M8767_IRQ_DVSOK4] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8767_IRQ_DVSOK4_MASK,
 	},
 	[S5M8767_IRQ_RTC60S] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_RTC60S_MASK,
 	},
 	[S5M8767_IRQ_RTCA1] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_RTCA1_MASK,
 	},
 	[S5M8767_IRQ_RTCA2] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_RTCA2_MASK,
 	},
 	[S5M8767_IRQ_SMPL] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_SMPL_MASK,
 	},
 	[S5M8767_IRQ_RTC1S] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_RTC1S_MASK,
 	},
 	[S5M8767_IRQ_WTSR] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8767_IRQ_WTSR_MASK,
 	},
 };
 
-static struct sec_irq_data s5m8763_irqs[] = {
+static struct regmap_irq s5m8763_irqs[] = {
 	[S5M8763_IRQ_DCINF] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_DCINF_MASK,
 	},
 	[S5M8763_IRQ_DCINR] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_DCINR_MASK,
 	},
 	[S5M8763_IRQ_JIGF] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_JIGF_MASK,
 	},
 	[S5M8763_IRQ_JIGR] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_JIGR_MASK,
 	},
 	[S5M8763_IRQ_PWRONF] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_PWRONF_MASK,
 	},
 	[S5M8763_IRQ_PWRONR] = {
-		.reg = 1,
+		.reg_offset = 1,
 		.mask = S5M8763_IRQ_PWRONR_MASK,
 	},
 	[S5M8763_IRQ_WTSREVNT] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_WTSREVNT_MASK,
 	},
 	[S5M8763_IRQ_SMPLEVNT] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_SMPLEVNT_MASK,
 	},
 	[S5M8763_IRQ_ALARM1] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_ALARM1_MASK,
 	},
 	[S5M8763_IRQ_ALARM0] = {
-		.reg = 2,
+		.reg_offset = 2,
 		.mask = S5M8763_IRQ_ALARM0_MASK,
 	},
 	[S5M8763_IRQ_ONKEY1S] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_ONKEY1S_MASK,
 	},
 	[S5M8763_IRQ_TOPOFFR] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_TOPOFFR_MASK,
 	},
 	[S5M8763_IRQ_DCINOVPR] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_DCINOVPR_MASK,
 	},
 	[S5M8763_IRQ_CHGRSTF] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_CHGRSTF_MASK,
 	},
 	[S5M8763_IRQ_DONER] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_DONER_MASK,
 	},
 	[S5M8763_IRQ_CHGFAULT] = {
-		.reg = 3,
+		.reg_offset = 3,
 		.mask = S5M8763_IRQ_CHGFAULT_MASK,
 	},
 	[S5M8763_IRQ_LOBAT1] = {
-		.reg = 4,
+		.reg_offset = 4,
 		.mask = S5M8763_IRQ_LOBAT1_MASK,
 	},
 	[S5M8763_IRQ_LOBAT2] = {
-		.reg = 4,
+		.reg_offset = 4,
 		.mask = S5M8763_IRQ_LOBAT2_MASK,
 	},
 };
 
-static inline struct sec_irq_data *
-irq_to_s5m8767_irq(struct sec_pmic_dev *sec_pmic, int irq)
-{
-	return &s5m8767_irqs[irq - sec_pmic->irq_base];
-}
-
-static void s5m8767_irq_lock(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&sec_pmic->irqlock);
-}
-
-static void s5m8767_irq_sync_unlock(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
-		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
-			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
-			sec_reg_write(sec_pmic, S5M8767_REG_INT1M + i,
-					sec_pmic->irq_masks_cur[i]);
-		}
-	}
-
-	mutex_unlock(&sec_pmic->irqlock);
-}
-
-static void s5m8767_irq_unmask(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8767_irq(sec_pmic,
-							       data->irq);
-
-	sec_pmic->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
-}
-
-static void s5m8767_irq_mask(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8767_irq(sec_pmic,
-							       data->irq);
-
-	sec_pmic->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
-}
+static struct regmap_irq_chip s2mps11_irq_chip = {
+	.name = "s2mps11",
+	.irqs = s2mps11_irqs,
+	.num_irqs = ARRAY_SIZE(s2mps11_irqs),
+	.num_regs = 3,
+	.status_base = S2MPS11_REG_INT1,
+	.mask_base = S2MPS11_REG_INT1M,
+	.ack_base = S2MPS11_REG_INT1,
+};
 
-static struct irq_chip s5m8767_irq_chip = {
+static struct regmap_irq_chip s5m8767_irq_chip = {
 	.name = "s5m8767",
-	.irq_bus_lock = s5m8767_irq_lock,
-	.irq_bus_sync_unlock = s5m8767_irq_sync_unlock,
-	.irq_mask = s5m8767_irq_mask,
-	.irq_unmask = s5m8767_irq_unmask,
+	.irqs = s5m8767_irqs,
+	.num_irqs = ARRAY_SIZE(s5m8767_irqs),
+	.num_regs = 3,
+	.status_base = S5M8767_REG_INT1,
+	.mask_base = S5M8767_REG_INT1M,
+	.ack_base = S5M8767_REG_INT1,
 };
 
-static inline struct sec_irq_data *
-irq_to_s5m8763_irq(struct sec_pmic_dev *sec_pmic, int irq)
-{
-	return &s5m8763_irqs[irq - sec_pmic->irq_base];
-}
-
-static void s5m8763_irq_lock(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&sec_pmic->irqlock);
-}
-
-static void s5m8763_irq_sync_unlock(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
-		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
-			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
-			sec_reg_write(sec_pmic, S5M8763_REG_IRQM1 + i,
-					sec_pmic->irq_masks_cur[i]);
-		}
-	}
-
-	mutex_unlock(&sec_pmic->irqlock);
-}
-
-static void s5m8763_irq_unmask(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
-							       data->irq);
-
-	sec_pmic->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
-}
-
-static void s5m8763_irq_mask(struct irq_data *data)
-{
-	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
-							       data->irq);
-
-	sec_pmic->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
-}
-
-static struct irq_chip s5m8763_irq_chip = {
+static struct regmap_irq_chip s5m8763_irq_chip = {
 	.name = "s5m8763",
-	.irq_bus_lock = s5m8763_irq_lock,
-	.irq_bus_sync_unlock = s5m8763_irq_sync_unlock,
-	.irq_mask = s5m8763_irq_mask,
-	.irq_unmask = s5m8763_irq_unmask,
+	.irqs = s5m8763_irqs,
+	.num_irqs = ARRAY_SIZE(s5m8763_irqs),
+	.num_regs = 4,
+	.status_base = S5M8763_REG_IRQ1,
+	.mask_base = S5M8763_REG_IRQM1,
+	.ack_base = S5M8763_REG_IRQ1,
 };
 
-
-static irqreturn_t s5m8767_irq_thread(int irq, void *data)
-{
-	struct sec_pmic_dev *sec_pmic = data;
-	u8 irq_reg[NUM_IRQ_REGS-1];
-	int ret;
-	int i;
-
-
-	ret = sec_bulk_read(sec_pmic, S5M8767_REG_INT1,
-				NUM_IRQ_REGS - 1, irq_reg);
-	if (ret < 0) {
-		dev_err(sec_pmic->dev, "Failed to read interrupt register: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	for (i = 0; i < NUM_IRQ_REGS - 1; i++)
-		irq_reg[i] &= ~sec_pmic->irq_masks_cur[i];
-
-	for (i = 0; i < S5M8767_IRQ_NR; i++) {
-		if (irq_reg[s5m8767_irqs[i].reg - 1] & s5m8767_irqs[i].mask)
-			handle_nested_irq(sec_pmic->irq_base + i);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t s5m8763_irq_thread(int irq, void *data)
-{
-	struct sec_pmic_dev *sec_pmic = data;
-	u8 irq_reg[NUM_IRQ_REGS];
-	int ret;
-	int i;
-
-	ret = sec_bulk_read(sec_pmic, S5M8763_REG_IRQ1,
-				NUM_IRQ_REGS, irq_reg);
-	if (ret < 0) {
-		dev_err(sec_pmic->dev, "Failed to read interrupt register: %d\n",
-				ret);
-		return IRQ_NONE;
-	}
-
-	for (i = 0; i < NUM_IRQ_REGS; i++)
-		irq_reg[i] &= ~sec_pmic->irq_masks_cur[i];
-
-	for (i = 0; i < S5M8763_IRQ_NR; i++) {
-		if (irq_reg[s5m8763_irqs[i].reg - 1] & s5m8763_irqs[i].mask)
-			handle_nested_irq(sec_pmic->irq_base + i);
-	}
-
-	return IRQ_HANDLED;
-}
-
-int sec_irq_resume(struct sec_pmic_dev *sec_pmic)
-{
-	if (sec_pmic->irq && sec_pmic->irq_base) {
-		switch (sec_pmic->device_type) {
-		case S5M8763X:
-			s5m8763_irq_thread(sec_pmic->irq_base, sec_pmic);
-			break;
-		case S5M8767X:
-			s5m8767_irq_thread(sec_pmic->irq_base, sec_pmic);
-			break;
-		default:
-			dev_err(sec_pmic->dev,
-				"Unknown device type %d\n",
-				sec_pmic->device_type);
-			return -EINVAL;
-
-		}
-	}
-	return 0;
-}
-
 int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 {
-	int i;
-	int cur_irq;
 	int ret = 0;
 	int type = sec_pmic->device_type;
 
@@ -369,119 +278,33 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 		return 0;
 	}
 
-	if (!sec_pmic->irq_base) {
-		dev_err(sec_pmic->dev,
-			"No interrupt base specified, no interrupts\n");
-		return 0;
-	}
-
-	mutex_init(&sec_pmic->irqlock);
-
 	switch (type) {
 	case S5M8763X:
-		for (i = 0; i < NUM_IRQ_REGS; i++) {
-			sec_pmic->irq_masks_cur[i] = 0xff;
-			sec_pmic->irq_masks_cache[i] = 0xff;
-			sec_reg_write(sec_pmic, S5M8763_REG_IRQM1 + i,
-						0xff);
-		}
-
-		sec_reg_write(sec_pmic, S5M8763_REG_STATUSM1, 0xff);
-		sec_reg_write(sec_pmic, S5M8763_REG_STATUSM2, 0xff);
-
-		for (i = 0; i < S5M8763_IRQ_NR; i++) {
-			cur_irq = i + sec_pmic->irq_base;
-			irq_set_chip_data(cur_irq, sec_pmic);
-			irq_set_chip_and_handler(cur_irq, &s5m8763_irq_chip,
-						 handle_edge_irq);
-			irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-			set_irq_flags(cur_irq, IRQF_VALID);
-#else
-			irq_set_noprobe(cur_irq);
-#endif
-		}
-
-		ret = request_threaded_irq(sec_pmic->irq, NULL,
-					s5m8763_irq_thread,
-					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					"sec-pmic-irq", sec_pmic);
-		if (ret) {
-			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
-				sec_pmic->irq, ret);
-			return ret;
-		}
+		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s5m8763_irq_chip,
+				  &sec_pmic->irq_data);
 		break;
 	case S5M8767X:
-		for (i = 0; i < NUM_IRQ_REGS - 1; i++) {
-			sec_pmic->irq_masks_cur[i] = 0xff;
-			sec_pmic->irq_masks_cache[i] = 0xff;
-			sec_reg_write(sec_pmic, S5M8767_REG_INT1M + i,
-						0xff);
-		}
-		for (i = 0; i < S5M8767_IRQ_NR; i++) {
-			cur_irq = i + sec_pmic->irq_base;
-			irq_set_chip_data(cur_irq, sec_pmic);
-			if (ret) {
-				dev_err(sec_pmic->dev,
-					"Failed to irq_set_chip_data %d: %d\n",
-					sec_pmic->irq, ret);
-				return ret;
-			}
-
-			irq_set_chip_and_handler(cur_irq, &s5m8767_irq_chip,
-						 handle_edge_irq);
-			irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-			set_irq_flags(cur_irq, IRQF_VALID);
-#else
-			irq_set_noprobe(cur_irq);
-#endif
-		}
-
-		ret = request_threaded_irq(sec_pmic->irq, NULL,
-					   s5m8767_irq_thread,
-					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					   "sec-pmic-irq", sec_pmic);
-		if (ret) {
-			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
-				sec_pmic->irq, ret);
-			return ret;
-		}
+		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s5m8767_irq_chip,
+				  &sec_pmic->irq_data);
 		break;
-	default:
-		dev_err(sec_pmic->dev,
-			"Unknown device type %d\n", sec_pmic->device_type);
-		return -EINVAL;
-	}
-
-	if (!sec_pmic->ono)
-		return 0;
-
-	switch (type) {
-	case S5M8763X:
-		ret = request_threaded_irq(sec_pmic->ono, NULL,
-						s5m8763_irq_thread,
-						IRQF_TRIGGER_FALLING |
-						IRQF_TRIGGER_RISING |
-						IRQF_ONESHOT, "sec_pmic-ono",
-						sec_pmic);
-		break;
-	case S5M8767X:
-		ret = request_threaded_irq(sec_pmic->ono, NULL,
-					s5m8767_irq_thread,
-					IRQF_TRIGGER_FALLING |
-					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT, "sec_pmic-ono", sec_pmic);
+	case S2MPS11X:
+		ret = regmap_add_irq_chip(sec_pmic->regmap, sec_pmic->irq,
+				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				  sec_pmic->irq_base, &s2mps11_irq_chip,
+				  &sec_pmic->irq_data);
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		dev_err(sec_pmic->dev, "Unknown device type %d\n",
+			sec_pmic->device_type);
+		return -EINVAL;
 	}
 
-	if (ret) {
-		dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
-			sec_pmic->ono, ret);
+	if (ret != 0) {
+		dev_err(sec_pmic->dev, "Failed to register IRQ chip: %d\n", ret);
 		return ret;
 	}
 
@@ -490,9 +313,5 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
 void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
 {
-	if (sec_pmic->ono)
-		free_irq(sec_pmic->ono, sec_pmic);
-
-	if (sec_pmic->irq)
-		free_irq(sec_pmic->irq, sec_pmic);
+	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
 }
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 323e200..b50c38f 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -48,6 +48,8 @@ struct sec_pmic_dev {
 	int device_type;
 	int irq_base;
 	int irq;
+	struct regmap_irq_chip_data *irq_data;
+
 	int ono;
 	u8 irq_masks_cur[NUM_IRQ_REGS];
 	u8 irq_masks_cache[NUM_IRQ_REGS];
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index 7f7a624..d43b4f9 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -13,6 +13,48 @@
 #ifndef __LINUX_MFD_SEC_IRQ_H
 #define __LINUX_MFD_SEC_IRQ_H
 
+enum s2mps11_irq {
+	S2MPS11_IRQ_PWRONF,
+	S2MPS11_IRQ_PWRONR,
+	S2MPS11_IRQ_JIGONBF,
+	S2MPS11_IRQ_JIGONBR,
+	S2MPS11_IRQ_ACOKBF,
+	S2MPS11_IRQ_ACOKBR,
+	S2MPS11_IRQ_PWRON1S,
+	S2MPS11_IRQ_MRB,
+
+	S2MPS11_IRQ_RTC60S,
+	S2MPS11_IRQ_RTCA1,
+	S2MPS11_IRQ_RTCA2,
+	S2MPS11_IRQ_SMPL,
+	S2MPS11_IRQ_RTC1S,
+	S2MPS11_IRQ_WTSR,
+
+	S2MPS11_IRQ_INT120C,
+	S2MPS11_IRQ_INT140C,
+
+	S2MPS11_IRQ_NR,
+};
+
+#define S2MPS11_IRQ_PWRONF_MASK		(1 << 0)
+#define S2MPS11_IRQ_PWRONR_MASK		(1 << 1)
+#define S2MPS11_IRQ_JIGONBF_MASK	(1 << 2)
+#define S2MPS11_IRQ_JIGONBR_MASK	(1 << 3)
+#define S2MPS11_IRQ_ACOKBF_MASK		(1 << 4)
+#define S2MPS11_IRQ_ACOKBR_MASK		(1 << 5)
+#define S2MPS11_IRQ_PWRON1S_MASK	(1 << 6)
+#define S2MPS11_IRQ_MRB_MASK		(1 << 7)
+
+#define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
+#define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
+#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
+#define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
+#define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
+#define S2MPS11_IRQ_WTSR_MASK		(1 << 5)
+
+#define S2MPS11_IRQ_INT120C_MASK	(1 << 0)
+#define S2MPS11_IRQ_INT140C_MASK	(1 << 1)
+
 enum s5m8767_irq {
 	S5M8767_IRQ_PWRR,
 	S5M8767_IRQ_PWRF,
-- 
1.7.1


