Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab2FRL3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:29:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65496 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2FRL3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:29:47 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-bb-4fdf11291042
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 7/7] mfd: s2mps11: Add samsung s2mps11 pmic
Date: Mon, 18 Jun 2012 20:29:45 +0900
Message-id: <067901cd4d45$a949f150$fbddd3f0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRaks8CwzCfUNSj+e8vu7ENRxNQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t9jQV1Nwfv+BgcXaVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M+eu/MxVcqKtYNX8pSwNjc1oXIyeHhICJxO8pFxkhbDGJC/fW
	s4HYQgLTGSU+rXOCsOcySaxaXAtiswloSKzc/RasRkTAV+LSy/+sXYwcHMwCwRJbT+uBhIUF
	rCXm/H3LAmKzCKhKTPvwDayEV8BQYv4DQZAwr4CgxI/J98BKmAW0JNbvPM4EYctLbF7zlhmk
	XEJAXeLRX10QU0RAT6LlRAVEhYjEvhfvGCcwCsxCMmgWkkGzkAyahaRlASPLKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgcHwmvYNxVYPFIUYBDkYlHt437Pf9hVgTy4orcw8xSnAwK4nw
	/uACCvGmJFZWpRblxxeV5qQWH2KU5mBREudtsr7gLySQnliSmp2aWpBaBJNl4uCUamCU2hdl
	ysnGN0Xh3t15U4T27ak/fJtTKXL9F8Xse93vZ856XZe0c61JyyKmPSe0/rEu/nz9xLPUvBcX
	WzvfBhSJpgtVnw0KMzvRZ221KJrXZr0z3+Ums/iNV5zWV0pu55gdWHfyuO29TqklbKWnbrLU
	+LUcOb5067PTXwo4NOyennseWpr57WuHEktxRqKhFnNRcSIAKH70FUMCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch support Samsung s2mps11 mfd driver.
S2MPS11 can support 10 Bucks and 38 LDOs and RTC.
By this patch, s2m and s5m mfd series can be supported.
Especially, S2MPS11 is designed for high performance
Samsung application processor.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/mfd/sec-core.c          |   10 +
 drivers/mfd/sec-irq.c           |  377 ++++++++++++++++++---------------------
 include/linux/mfd/samsung/irq.h |   47 +++++
 3 files changed, 231 insertions(+), 203 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 5bf33cd..a77c7cb 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -54,6 +54,12 @@ static struct mfd_cell s5m8767_devs[] = {
 	},
 };
 
+static struct mfd_cell s2mps11_devs[] = {
+	{
+		.name = "s2mps11-pmic",
+	},
+};
+
 int sec_reg_read(struct sec_pmic_dev *sec_pmic, u8 reg, void *dest)
 {
 	return regmap_read(sec_pmic->regmap, reg, dest);
@@ -145,6 +151,10 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		ret = mfd_add_devices(sec_pmic->dev, -1, s5m8767_devs,
 					ARRAY_SIZE(s5m8767_devs), NULL, 0);
 		break;
+	case S2MPS11X:
+		ret = mfd_add_devices(sec_pmic->dev, -1, s2mps11_devs,
+					ARRAY_SIZE(s2mps11_devs), NULL, 0);
+		break;
 	default:
 		/* If this happens the probe function is problem */
 		BUG();
diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 370cc4f..9254b86 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -16,12 +16,75 @@
 #include <linux/irq.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/irq.h>
+#include <linux/mfd/samsung/s2mps11.h>
 #include <linux/mfd/samsung/s5m8763.h>
 #include <linux/mfd/samsung/s5m8767.h>
 
-struct sec_irq_data {
-	int reg;
-	int mask;
+static struct sec_irq_data s2mps11_irqs[] = {
+	[S2MPS11_IRQ_PWRONF] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_PWRONF_MASK,
+	},
+	[S2MPS11_IRQ_PWRONR] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_PWRONR_MASK,
+	},
+	[S2MPS11_IRQ_JIGONBF] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_JIGONBF_MASK,
+	},
+	[S2MPS11_IRQ_JIGONBR] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_JIGONBR_MASK,
+	},
+	[S2MPS11_IRQ_ACOKBF] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_ACOKBF_MASK,
+	},
+	[S2MPS11_IRQ_ACOKBR] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_ACOKBR_MASK,
+	},
+	[S2MPS11_IRQ_PWRON1S] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_PWRON1S_MASK,
+	},
+	[S2MPS11_IRQ_MRB] = {
+		.reg = 1,
+		.mask = S2MPS11_IRQ_MRB_MASK,
+	},
+	[S2MPS11_IRQ_RTC60S] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_RTC60S_MASK,
+	},
+	[S2MPS11_IRQ_RTCA1] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
+	},
+	[S2MPS11_IRQ_RTCA2] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_RTCA2_MASK,
+	},
+	[S2MPS11_IRQ_SMPL] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_SMPL_MASK,
+	},
+	[S2MPS11_IRQ_RTC1S] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_RTC1S_MASK,
+	},
+	[S2MPS11_IRQ_WTSR] = {
+		.reg = 2,
+		.mask = S2MPS11_IRQ_WTSR_MASK,
+	},
+	[S2MPS11_IRQ_INT120C] = {
+		.reg = 3,
+		.mask = S2MPS11_IRQ_INT120C_MASK,
+	},
+	[S2MPS11_IRQ_INT140C] = {
+		.reg = 3,
+		.mask = S2MPS11_IRQ_INT140C_MASK,
+	},
 };
 
 static struct sec_irq_data s5m8767_irqs[] = {
@@ -171,82 +234,51 @@ static struct sec_irq_data s5m8763_irqs[] = {
 };
 
 static inline struct sec_irq_data *
-irq_to_s5m8767_irq(struct sec_pmic_dev *sec_pmic, int irq)
+irq_to_sec_pmic_irq(struct sec_pmic_dev *sec_pmic, int irq)
 {
-	return &s5m8767_irqs[irq - sec_pmic->irq_base];
+	switch (sec_pmic->device_type) {
+	case S5M8763X:
+		return &s5m8763_irqs[irq - sec_pmic->irq_base];
+	case S5M8767X:
+		return &s5m8767_irqs[irq - sec_pmic->irq_base];
+	case S2MPS11X:
+		return &s2mps11_irqs[irq - sec_pmic->irq_base];
+	default:
+		return NULL;
+	}
 }
 
-static void s5m8767_irq_lock(struct irq_data *data)
+static void sec_pmic_irq_lock(struct irq_data *data)
 {
 	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
 
 	mutex_lock(&sec_pmic->irqlock);
 }
 
-static void s5m8767_irq_sync_unlock(struct irq_data *data)
+static void sec_pmic_irq_sync_unlock(struct irq_data *data)
 {
 	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	int i;
+	int i, reg_int1m;
 
-	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
-		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
-			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
-			sec_reg_write(sec_pmic, S5M8767_REG_INT1M + i,
-					sec_pmic->irq_masks_cur[i]);
-		}
+	switch (sec_pmic->device_type) {
+	case S5M8763X:
+		reg_int1m = S5M8763_REG_IRQM1;
+	case S5M8767X:
+		reg_int1m = S5M8767_REG_INT1M;
+		break;
+	case S2MPS11X:
+		reg_int1m = S2MPS11_REG_INT1M;
+		break;
+	default:
+		dev_err(sec_pmic->dev,
+			"Unknown device type %d\n",
+			sec_pmic->device_type);
 	}
 
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
-
-static struct irq_chip s5m8767_irq_chip = {
-	.name = "s5m8767",
-	.irq_bus_lock = s5m8767_irq_lock,
-	.irq_bus_sync_unlock = s5m8767_irq_sync_unlock,
-	.irq_mask = s5m8767_irq_mask,
-	.irq_unmask = s5m8767_irq_unmask,
-};
-
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
 	for (i = 0; i < ARRAY_SIZE(sec_pmic->irq_masks_cur); i++) {
 		if (sec_pmic->irq_masks_cur[i] != sec_pmic->irq_masks_cache[i]) {
 			sec_pmic->irq_masks_cache[i] = sec_pmic->irq_masks_cur[i];
-			sec_reg_write(sec_pmic, S5M8763_REG_IRQM1 + i,
+			sec_reg_write(sec_pmic, reg_int1m + i,
 					sec_pmic->irq_masks_cur[i]);
 		}
 	}
@@ -254,41 +286,57 @@ static void s5m8763_irq_sync_unlock(struct irq_data *data)
 	mutex_unlock(&sec_pmic->irqlock);
 }
 
-static void s5m8763_irq_unmask(struct irq_data *data)
+static void sec_pmic_irq_unmask(struct irq_data *data)
 {
 	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
+	struct sec_irq_data *irq_data = irq_to_sec_pmic_irq(sec_pmic,
 							       data->irq);
 
 	sec_pmic->irq_masks_cur[irq_data->reg - 1] &= ~irq_data->mask;
 }
 
-static void s5m8763_irq_mask(struct irq_data *data)
+static void sec_pmic_irq_mask(struct irq_data *data)
 {
 	struct sec_pmic_dev *sec_pmic = irq_data_get_irq_chip_data(data);
-	struct sec_irq_data *irq_data = irq_to_s5m8763_irq(sec_pmic,
+	struct sec_irq_data *irq_data = irq_to_sec_pmic_irq(sec_pmic,
 							       data->irq);
 
 	sec_pmic->irq_masks_cur[irq_data->reg - 1] |= irq_data->mask;
 }
 
-static struct irq_chip s5m8763_irq_chip = {
-	.name = "s5m8763",
-	.irq_bus_lock = s5m8763_irq_lock,
-	.irq_bus_sync_unlock = s5m8763_irq_sync_unlock,
-	.irq_mask = s5m8763_irq_mask,
-	.irq_unmask = s5m8763_irq_unmask,
+static struct irq_chip sec_pmic_irq_chip = {
+	.name = "sec-pmic",
+	.irq_bus_lock = sec_pmic_irq_lock,
+	.irq_bus_sync_unlock = sec_pmic_irq_sync_unlock,
+	.irq_mask = sec_pmic_irq_mask,
+	.irq_unmask = sec_pmic_irq_unmask,
 };
 
-
-static irqreturn_t s5m8767_irq_thread(int irq, void *data)
+static irqreturn_t sec_pmic_irq_thread(int irq, void *data)
 {
+
 	struct sec_pmic_dev *sec_pmic = data;
 	u8 irq_reg[NUM_IRQ_REGS-1];
 	int ret;
-	int i;
+	int i, reg_int1;
+
+	switch (sec_pmic->device_type) {
+	case S5M8763X:
+		reg_int1 = S5M8763_REG_IRQ1;
+	case S5M8767X:
+		reg_int1 = S5M8767_REG_INT1;
+		break;
+	case S2MPS11X:
+		reg_int1 = S2MPS11_REG_INT1;
+		break;
+	default:
+		dev_err(sec_pmic->dev,
+			"Unknown device type %d\n",
+			sec_pmic->device_type);
+		return -EINVAL;
+	}
 
-	ret = sec_bulk_read(sec_pmic, S5M8767_REG_INT1,
+	ret = sec_bulk_read(sec_pmic, reg_int1,
 				NUM_IRQ_REGS - 1, irq_reg);
 	if (ret < 0) {
 		dev_err(sec_pmic->dev, "Failed to read interrupt register: %d\n",
@@ -307,56 +355,16 @@ static irqreturn_t s5m8767_irq_thread(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t s5m8763_irq_thread(int irq, void *data)
+int s5m_irq_resume(struct sec_pmic_dev *sec_pmic)
 {
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
-	if (sec_pmic->irq && sec_pmic->irq_base){
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
+	if (sec_pmic->irq && sec_pmic->irq_base)
+			sec_pmic_irq_thread(sec_pmic->irq_base, sec_pmic);
 	return 0;
 }
 
 int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 {
-	int i;
+	int i, reg_int1m, reg_irq_nr;
 	int cur_irq;
 	int ret = 0;
 	int type = sec_pmic->device_type;
@@ -378,106 +386,69 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
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
+		reg_int1m = S5M8763_REG_IRQM1;
+		reg_irq_nr = S5M8763_IRQ_NR;
+		break;
+	case S5M8767X:
+		reg_int1m = S5M8767_REG_INT1M;
+		reg_irq_nr = S5M8767_IRQ_NR;
+		break;
+	case S2MPS11X:
+		reg_int1m = S2MPS11_REG_INT1M;
+		reg_irq_nr = S2MPS11_IRQ_NR;
+		break;
+	default:
+		dev_err(sec_pmic->dev,
+			"Unknown device type %d\n",
+			sec_pmic->device_type);
+		return -EINVAL;
+	}
 
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
+	for (i = 0; i < NUM_IRQ_REGS - 1; i++) {
+		sec_pmic->irq_masks_cur[i] = 0xff;
+		sec_pmic->irq_masks_cache[i] = 0xff;
+		sec_reg_write(sec_pmic, reg_int1m + i, 0xff);
+	}
 
-		ret = request_threaded_irq(sec_pmic->irq, NULL,
-					s5m8763_irq_thread,
-					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					"sec-pmic-irq", sec_pmic);
+	for (i = 0; i < reg_irq_nr; i++) {
+		cur_irq = i + sec_pmic->irq_base;
+		ret = irq_set_chip_data(cur_irq, sec_pmic);
 		if (ret) {
-			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
+			dev_err(sec_pmic->dev,
+				"Failed to irq_set_chip_data %d: %d\n",
 				sec_pmic->irq, ret);
 			return ret;
 		}
-		break;
-	case S5M8767X:
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
+
+		irq_set_chip_and_handler(cur_irq, &sec_pmic_irq_chip,
+					 handle_edge_irq);
+		irq_set_nested_thread(cur_irq, 1);
 #ifdef CONFIG_ARM
 			set_irq_flags(cur_irq, IRQF_VALID);
 #else
 			irq_set_noprobe(cur_irq);
 #endif
-		}
+	}
 
-		ret = request_threaded_irq(sec_pmic->irq, NULL,
-					   s5m8767_irq_thread,
-					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-					   "sec-pmic-irq", sec_pmic);
-		if (ret) {
-			dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
-				sec_pmic->irq, ret);
-			return ret;
-		}
-		break;
-	default:
-		dev_err(sec_pmic->dev,
-			"Unknown device type %d\n", sec_pmic->device_type);
-		return -EINVAL;
+	ret = request_threaded_irq(sec_pmic->irq, NULL,
+				   sec_pmic_irq_thread,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   "sec-pmic-irq", sec_pmic);
+	if (ret) {
+		dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
+			sec_pmic->irq, ret);
+		return ret;
 	}
 
 	if (!sec_pmic->ono)
 		return 0;
 
-	switch (type) {
-	case S5M8763X:
-		ret = request_threaded_irq(sec_pmic->ono, NULL,
-						s5m8763_irq_thread,
-						IRQF_TRIGGER_FALLING |
-						IRQF_TRIGGER_RISING |
-						IRQF_ONESHOT, "sec-pmic-ono",
-						sec_pmic);
-		break;
-	case S5M8767X:
-		ret = request_threaded_irq(sec_pmic->ono, NULL,
-					s5m8767_irq_thread,
-					IRQF_TRIGGER_FALLING |
-					IRQF_TRIGGER_RISING |
-					IRQF_ONESHOT, "sec-pmic-ono", sec_pmic);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
+	ret = request_threaded_irq(sec_pmic->ono, NULL,
+				sec_pmic_irq_thread,
+				IRQF_TRIGGER_FALLING |
+				IRQF_TRIGGER_RISING |
+				IRQF_ONESHOT, "sec-pmic-ono",
+				sec_pmic);
 	if (ret) {
 		dev_err(sec_pmic->dev, "Failed to request IRQ %d: %d\n",
 			sec_pmic->ono, ret);
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index 010f444..dfde2f9 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -14,6 +14,53 @@
 #ifndef __LINUX_MFD_SEC_IRQ_H
 #define __LINUX_MFD_SEC_IRQ_H
 
+struct sec_irq_data {
+	int reg;
+	int mask;
+};
+
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


