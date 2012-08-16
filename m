Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2HPLuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:50:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55347 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2HPLt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:49:59 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 07:49:58 EDT
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org, Durgadoss <durgadoss.r@intel.com>,
        Len Brown <lenb@kernel.org>, Jean Delvare <khali@linux-fr.org>,
        Kyungmin Park <kmpark@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH v6 3/6] thermal: exynos5: add exynos5250 thermal sensor driver support
Date: Thu, 16 Aug 2012 17:11:42 +0530
Message-Id: <1345117305-8299-4-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
References: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Insert exynos5 TMU sensor changes into the thermal driver.  Some exynos4
changes are made generic for exynos series.

[akpm@linux-foundation.org: fix comment layout]
Signed-off-by: SangWook Ju <sw.ju@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Durgadoss <durgadoss.r@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/Kconfig                      |    2 +-
 drivers/thermal/exynos_thermal.c             |  351 ++++++++++++++++----------
 include/linux/platform_data/exynos_thermal.h |   19 ++-
 3 files changed, 240 insertions(+), 132 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 8f2b6ea..edfd67d 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -49,7 +49,7 @@ config RCAR_THERMAL
 
 config EXYNOS_THERMAL
 	tristate "Temperature sensor on Samsung EXYNOS"
-	depends on ARCH_EXYNOS4 && THERMAL
+	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5) && THERMAL
 	help
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
index 556d15b..c9a33dd 100644
--- a/drivers/thermal/exynos_thermal.c
+++ b/drivers/thermal/exynos_thermal.c
@@ -33,44 +33,83 @@
 #include <linux/kobject.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
-
 #include <linux/platform_data/exynos_thermal.h>
-
-#define EXYNOS4_TMU_REG_TRIMINFO	0x0
-#define EXYNOS4_TMU_REG_CONTROL		0x20
-#define EXYNOS4_TMU_REG_STATUS		0x28
-#define EXYNOS4_TMU_REG_CURRENT_TEMP	0x40
-#define EXYNOS4_TMU_REG_THRESHOLD_TEMP	0x44
-#define EXYNOS4_TMU_REG_TRIG_LEVEL0	0x50
-#define EXYNOS4_TMU_REG_TRIG_LEVEL1	0x54
-#define EXYNOS4_TMU_REG_TRIG_LEVEL2	0x58
-#define EXYNOS4_TMU_REG_TRIG_LEVEL3	0x5C
-#define EXYNOS4_TMU_REG_PAST_TEMP0	0x60
-#define EXYNOS4_TMU_REG_PAST_TEMP1	0x64
-#define EXYNOS4_TMU_REG_PAST_TEMP2	0x68
-#define EXYNOS4_TMU_REG_PAST_TEMP3	0x6C
-#define EXYNOS4_TMU_REG_INTEN		0x70
-#define EXYNOS4_TMU_REG_INTSTAT		0x74
-#define EXYNOS4_TMU_REG_INTCLEAR	0x78
-
-#define EXYNOS4_TMU_GAIN_SHIFT		8
-#define EXYNOS4_TMU_REF_VOLTAGE_SHIFT	24
-
-#define EXYNOS4_TMU_TRIM_TEMP_MASK	0xff
-#define EXYNOS4_TMU_CORE_ON	3
-#define EXYNOS4_TMU_CORE_OFF	2
-#define EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET	50
-#define EXYNOS4_TMU_TRIG_LEVEL0_MASK	0x1
-#define EXYNOS4_TMU_TRIG_LEVEL1_MASK	0x10
-#define EXYNOS4_TMU_TRIG_LEVEL2_MASK	0x100
-#define EXYNOS4_TMU_TRIG_LEVEL3_MASK	0x1000
-#define EXYNOS4_TMU_INTCLEAR_VAL	0x1111
-
-struct exynos4_tmu_data {
-	struct exynos4_tmu_platform_data *pdata;
+#include <linux/of.h>
+
+#include <plat/cpu.h>
+
+/* Exynos generic registers */
+#define EXYNOS_TMU_REG_TRIMINFO		0x0
+#define EXYNOS_TMU_REG_CONTROL		0x20
+#define EXYNOS_TMU_REG_STATUS		0x28
+#define EXYNOS_TMU_REG_CURRENT_TEMP	0x40
+#define EXYNOS_TMU_REG_INTEN		0x70
+#define EXYNOS_TMU_REG_INTSTAT		0x74
+#define EXYNOS_TMU_REG_INTCLEAR		0x78
+
+#define EXYNOS_TMU_TRIM_TEMP_MASK	0xff
+#define EXYNOS_TMU_GAIN_SHIFT		8
+#define EXYNOS_TMU_REF_VOLTAGE_SHIFT	24
+#define EXYNOS_TMU_CORE_ON		3
+#define EXYNOS_TMU_CORE_OFF		2
+#define EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET	50
+
+/* Exynos4210 specific registers */
+#define EXYNOS4210_TMU_REG_THRESHOLD_TEMP	0x44
+#define EXYNOS4210_TMU_REG_TRIG_LEVEL0	0x50
+#define EXYNOS4210_TMU_REG_TRIG_LEVEL1	0x54
+#define EXYNOS4210_TMU_REG_TRIG_LEVEL2	0x58
+#define EXYNOS4210_TMU_REG_TRIG_LEVEL3	0x5C
+#define EXYNOS4210_TMU_REG_PAST_TEMP0	0x60
+#define EXYNOS4210_TMU_REG_PAST_TEMP1	0x64
+#define EXYNOS4210_TMU_REG_PAST_TEMP2	0x68
+#define EXYNOS4210_TMU_REG_PAST_TEMP3	0x6C
+
+#define EXYNOS4210_TMU_TRIG_LEVEL0_MASK	0x1
+#define EXYNOS4210_TMU_TRIG_LEVEL1_MASK	0x10
+#define EXYNOS4210_TMU_TRIG_LEVEL2_MASK	0x100
+#define EXYNOS4210_TMU_TRIG_LEVEL3_MASK	0x1000
+#define EXYNOS4210_TMU_INTCLEAR_VAL	0x1111
+
+/* Exynos5250 and Exynos4412 specific registers */
+#define EXYNOS_TMU_TRIMINFO_CON	0x14
+#define EXYNOS_THD_TEMP_RISE		0x50
+#define EXYNOS_THD_TEMP_FALL		0x54
+#define EXYNOS_EMUL_CON		0x80
+
+#define EXYNOS_TRIMINFO_RELOAD		0x1
+#define EXYNOS_TMU_CLEAR_RISE_INT	0x111
+#define EXYNOS_TMU_CLEAR_FALL_INT	(0x111 << 16)
+#define EXYNOS_MUX_ADDR_VALUE		6
+#define EXYNOS_MUX_ADDR_SHIFT		20
+#define EXYNOS_TMU_TRIP_MODE_SHIFT	13
+
+#define EFUSE_MIN_VALUE 40
+#define EFUSE_MAX_VALUE 100
+
+/* In-kernel thermal framework related macros & definations */
+#define SENSOR_NAME_LEN	16
+#define MAX_TRIP_COUNT	8
+#define MAX_COOLING_DEVICE 4
+
+#define ACTIVE_INTERVAL 500
+#define IDLE_INTERVAL 10000
+
+/* CPU Zone information */
+#define PANIC_ZONE      4
+#define WARN_ZONE       3
+#define MONITOR_ZONE    2
+#define SAFE_ZONE       1
+
+#define GET_ZONE(trip) (trip + 2)
+#define GET_TRIP(zone) (zone - 2)
+
+struct exynos_tmu_data {
+	struct exynos_tmu_platform_data *pdata;
 	struct resource *mem;
 	void __iomem *base;
 	int irq;
+	enum soc_type soc;
 	struct work_struct irq_work;
 	struct mutex lock;
 	struct clk *clk;
@@ -81,16 +120,17 @@ struct exynos4_tmu_data {
  * TMU treats temperature as a mapped temperature code.
  * The temperature is converted differently depending on the calibration type.
  */
-static int temp_to_code(struct exynos4_tmu_data *data, u8 temp)
+static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 {
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp_code;
 
-	/* temp should range between 25 and 125 */
-	if (temp < 25 || temp > 125) {
-		temp_code = -EINVAL;
-		goto out;
-	}
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		/* temp should range between 25 and 125 */
+		if (temp < 25 || temp > 125) {
+			temp_code = -EINVAL;
+			goto out;
+		}
 
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
@@ -102,7 +142,7 @@ static int temp_to_code(struct exynos4_tmu_data *data, u8 temp)
 		temp_code = temp + data->temp_error1 - 25;
 		break;
 	default:
-		temp_code = temp + EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		temp_code = temp + EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
 		break;
 	}
 out:
@@ -113,16 +153,17 @@ out:
  * Calculate a temperature value from a temperature code.
  * The unit of the temperature is degree Celsius.
  */
-static int code_to_temp(struct exynos4_tmu_data *data, u8 temp_code)
+static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 {
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	struct exynos_tmu_platform_data *pdata = data->pdata;
 	int temp;
 
-	/* temp_code should range between 75 and 175 */
-	if (temp_code < 75 || temp_code > 175) {
-		temp = -ENODATA;
-		goto out;
-	}
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		/* temp_code should range between 75 and 175 */
+		if (temp_code < 75 || temp_code > 175) {
+			temp = -ENODATA;
+			goto out;
+		}
 
 	switch (pdata->cal_type) {
 	case TYPE_TWO_POINT_TRIMMING:
@@ -133,54 +174,92 @@ static int code_to_temp(struct exynos4_tmu_data *data, u8 temp_code)
 		temp = temp_code - data->temp_error1 + 25;
 		break;
 	default:
-		temp = temp_code - EXYNOS4_TMU_DEF_CODE_TO_TEMP_OFFSET;
+		temp = temp_code - EXYNOS_TMU_DEF_CODE_TO_TEMP_OFFSET;
 		break;
 	}
 out:
 	return temp;
 }
 
-static int exynos4_tmu_initialize(struct platform_device *pdev)
+static int exynos_tmu_initialize(struct platform_device *pdev)
 {
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
-	unsigned int status, trim_info;
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
+	unsigned int status, trim_info, rising_threshold;
 	int ret = 0, threshold_code;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	status = readb(data->base + EXYNOS4_TMU_REG_STATUS);
+	status = readb(data->base + EXYNOS_TMU_REG_STATUS);
 	if (!status) {
 		ret = -EBUSY;
 		goto out;
 	}
 
+	if (data->soc == SOC_ARCH_EXYNOS) {
+		__raw_writel(EXYNOS_TRIMINFO_RELOAD,
+				data->base + EXYNOS_TMU_TRIMINFO_CON);
+	}
 	/* Save trimming info in order to perform calibration */
-	trim_info = readl(data->base + EXYNOS4_TMU_REG_TRIMINFO);
-	data->temp_error1 = trim_info & EXYNOS4_TMU_TRIM_TEMP_MASK;
-	data->temp_error2 = ((trim_info >> 8) & EXYNOS4_TMU_TRIM_TEMP_MASK);
-
-	/* Write temperature code for threshold */
-	threshold_code = temp_to_code(data, pdata->threshold);
-	if (threshold_code < 0) {
-		ret = threshold_code;
-		goto out;
+	trim_info = readl(data->base + EXYNOS_TMU_REG_TRIMINFO);
+	data->temp_error1 = trim_info & EXYNOS_TMU_TRIM_TEMP_MASK;
+	data->temp_error2 = ((trim_info >> 8) & EXYNOS_TMU_TRIM_TEMP_MASK);
+
+	if ((EFUSE_MIN_VALUE > data->temp_error1) ||
+			(data->temp_error1 > EFUSE_MAX_VALUE) ||
+			(data->temp_error2 != 0))
+		data->temp_error1 = pdata->efuse_value;
+
+	if (data->soc == SOC_ARCH_EXYNOS4210) {
+		/* Write temperature code for threshold */
+		threshold_code = temp_to_code(data, pdata->threshold);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			goto out;
+		}
+		writeb(threshold_code,
+			data->base + EXYNOS4210_TMU_REG_THRESHOLD_TEMP);
+
+		writeb(pdata->trigger_levels[0],
+			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL0);
+		writeb(pdata->trigger_levels[1],
+			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL1);
+		writeb(pdata->trigger_levels[2],
+			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL2);
+		writeb(pdata->trigger_levels[3],
+			data->base + EXYNOS4210_TMU_REG_TRIG_LEVEL3);
+
+		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
+			data->base + EXYNOS_TMU_REG_INTCLEAR);
+	} else if (data->soc == SOC_ARCH_EXYNOS) {
+		/* Write temperature code for threshold */
+		threshold_code = temp_to_code(data, pdata->trigger_levels[0]);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			goto out;
+		}
+		rising_threshold = threshold_code;
+		threshold_code = temp_to_code(data, pdata->trigger_levels[1]);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			goto out;
+		}
+		rising_threshold |= (threshold_code << 8);
+		threshold_code = temp_to_code(data, pdata->trigger_levels[2]);
+		if (threshold_code < 0) {
+			ret = threshold_code;
+			goto out;
+		}
+		rising_threshold |= (threshold_code << 16);
+
+		writel(rising_threshold,
+				data->base + EXYNOS_THD_TEMP_RISE);
+		writel(0, data->base + EXYNOS_THD_TEMP_FALL);
+
+		writel(EXYNOS_TMU_CLEAR_RISE_INT|EXYNOS_TMU_CLEAR_FALL_INT,
+				data->base + EXYNOS_TMU_REG_INTCLEAR);
 	}
-	writeb(threshold_code,
-		data->base + EXYNOS4_TMU_REG_THRESHOLD_TEMP);
-
-	writeb(pdata->trigger_levels[0],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL0);
-	writeb(pdata->trigger_levels[1],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL1);
-	writeb(pdata->trigger_levels[2],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL2);
-	writeb(pdata->trigger_levels[3],
-		data->base + EXYNOS4_TMU_REG_TRIG_LEVEL3);
-
-	writel(EXYNOS4_TMU_INTCLEAR_VAL,
-		data->base + EXYNOS4_TMU_REG_INTCLEAR);
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
@@ -188,35 +267,41 @@ out:
 	return ret;
 }
 
-static void exynos4_tmu_control(struct platform_device *pdev, bool on)
+static void exynos_tmu_control(struct platform_device *pdev, bool on)
 {
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
-	struct exynos4_tmu_platform_data *pdata = data->pdata;
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_platform_data *pdata = data->pdata;
 	unsigned int con, interrupt_en;
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	con = pdata->reference_voltage << EXYNOS4_TMU_REF_VOLTAGE_SHIFT |
-		pdata->gain << EXYNOS4_TMU_GAIN_SHIFT;
+	con = pdata->reference_voltage << EXYNOS_TMU_REF_VOLTAGE_SHIFT |
+		pdata->gain << EXYNOS_TMU_GAIN_SHIFT;
+
+	if (data->soc == SOC_ARCH_EXYNOS) {
+		con |= pdata->noise_cancel_mode << EXYNOS_TMU_TRIP_MODE_SHIFT;
+		con |= (EXYNOS_MUX_ADDR_VALUE << EXYNOS_MUX_ADDR_SHIFT);
+	}
+
 	if (on) {
-		con |= EXYNOS4_TMU_CORE_ON;
+		con |= EXYNOS_TMU_CORE_ON;
 		interrupt_en = pdata->trigger_level3_en << 12 |
 			pdata->trigger_level2_en << 8 |
 			pdata->trigger_level1_en << 4 |
 			pdata->trigger_level0_en;
 	} else {
-		con |= EXYNOS4_TMU_CORE_OFF;
+		con |= EXYNOS_TMU_CORE_OFF;
 		interrupt_en = 0; /* Disable all interrupts */
 	}
-	writel(interrupt_en, data->base + EXYNOS4_TMU_REG_INTEN);
-	writel(con, data->base + EXYNOS4_TMU_REG_CONTROL);
+	writel(interrupt_en, data->base + EXYNOS_TMU_REG_INTEN);
+	writel(con, data->base + EXYNOS_TMU_REG_CONTROL);
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 }
 
-static int exynos4_tmu_read(struct exynos4_tmu_data *data)
+static int exynos_tmu_read(struct exynos_tmu_data *data)
 {
 	u8 temp_code;
 	int temp;
@@ -224,7 +309,7 @@ static int exynos4_tmu_read(struct exynos4_tmu_data *data)
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	temp_code = readb(data->base + EXYNOS4_TMU_REG_CURRENT_TEMP);
+	temp_code = readb(data->base + EXYNOS_TMU_REG_CURRENT_TEMP);
 	temp = code_to_temp(data, temp_code);
 
 	clk_disable(data->clk);
@@ -233,25 +318,30 @@ static int exynos4_tmu_read(struct exynos4_tmu_data *data)
 	return temp;
 }
 
-static void exynos4_tmu_work(struct work_struct *work)
+static void exynos_tmu_work(struct work_struct *work)
 {
-	struct exynos4_tmu_data *data = container_of(work,
-			struct exynos4_tmu_data, irq_work);
+	struct exynos_tmu_data *data = container_of(work,
+			struct exynos_tmu_data, irq_work);
 
 	mutex_lock(&data->lock);
 	clk_enable(data->clk);
 
-	writel(EXYNOS4_TMU_INTCLEAR_VAL, data->base + EXYNOS4_TMU_REG_INTCLEAR);
 
-	enable_irq(data->irq);
+	if (data->soc == SOC_ARCH_EXYNOS)
+		writel(EXYNOS_TMU_CLEAR_RISE_INT,
+				data->base + EXYNOS_TMU_REG_INTCLEAR);
+	else
+		writel(EXYNOS4210_TMU_INTCLEAR_VAL,
+				data->base + EXYNOS_TMU_REG_INTCLEAR);
 
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
+	enable_irq(data->irq);
 }
 
-static irqreturn_t exynos4_tmu_irq(int irq, void *id)
+static irqreturn_t exynos_tmu_irq(int irq, void *id)
 {
-	struct exynos4_tmu_data *data = id;
+	struct exynos_tmu_data *data = id;
 
 	disable_irq_nosync(irq);
 	schedule_work(&data->irq_work);
@@ -259,18 +349,17 @@ static irqreturn_t exynos4_tmu_irq(int irq, void *id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
+static int __devinit exynos_tmu_probe(struct platform_device *pdev)
 {
-	struct exynos4_tmu_data *data;
-	struct exynos4_tmu_platform_data *pdata = pdev->dev.platform_data;
+	struct exynos_tmu_data *data;
+	struct exynos_tmu_platform_data *pdata = pdev->dev.platform_data;
 	int ret;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform init data supplied.\n");
 		return -ENODEV;
 	}
-
-	data = kzalloc(sizeof(struct exynos4_tmu_data), GFP_KERNEL);
+	data = kzalloc(sizeof(struct exynos_tmu_data), GFP_KERNEL);
 	if (!data) {
 		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
 		return -ENOMEM;
@@ -283,7 +372,7 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	INIT_WORK(&data->irq_work, exynos4_tmu_work);
+	INIT_WORK(&data->irq_work, exynos_tmu_work);
 
 	data->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!data->mem) {
@@ -307,9 +396,8 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 		goto err_mem_region;
 	}
 
-	ret = request_irq(data->irq, exynos4_tmu_irq,
-		IRQF_TRIGGER_RISING,
-		"exynos4-tmu", data);
+	ret = request_irq(data->irq, exynos_tmu_irq,
+		IRQF_TRIGGER_RISING, "exynos-tmu", data);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
 		goto err_io_remap;
@@ -322,17 +410,26 @@ static int __devinit exynos4_tmu_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	if (pdata->type == SOC_ARCH_EXYNOS ||
+				pdata->type == SOC_ARCH_EXYNOS4210)
+		data->soc = pdata->type;
+	else {
+		ret = -EINVAL;
+		dev_err(&pdev->dev, "Platform not supported\n");
+		goto err_clk;
+	}
+
 	data->pdata = pdata;
 	platform_set_drvdata(pdev, data);
 	mutex_init(&data->lock);
 
-	ret = exynos4_tmu_initialize(pdev);
+	ret = exynos_tmu_initialize(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to initialize TMU\n");
 		goto err_clk;
 	}
 
-	exynos4_tmu_control(pdev, true);
+	exynos_tmu_control(pdev, true);
 
 	return 0;
 err_clk:
@@ -350,11 +447,11 @@ err_free:
 	return ret;
 }
 
-static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
+static int __devexit exynos_tmu_remove(struct platform_device *pdev)
 {
-	struct exynos4_tmu_data *data = platform_get_drvdata(pdev);
+	struct exynos_tmu_data *data = platform_get_drvdata(pdev);
 
-	exynos4_tmu_control(pdev, false);
+	exynos_tmu_control(pdev, false);
 
 	clk_put(data->clk);
 
@@ -371,43 +468,43 @@ static int __devexit exynos4_tmu_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int exynos4_tmu_suspend(struct device *dev)
+static int exynos_tmu_suspend(struct device *dev)
 {
-	exynos4_tmu_control(to_platform_device(dev), false);
+	exynos_tmu_control(to_platform_device(dev), false);
 
 	return 0;
 }
 
-static int exynos4_tmu_resume(struct device *dev)
+static int exynos_tmu_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 
-	exynos4_tmu_initialize(pdev);
-	exynos4_tmu_control(pdev, true);
+	exynos_tmu_initialize(pdev);
+	exynos_tmu_control(pdev, true);
 
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm,
-			 exynos4_tmu_suspend, exynos4_tmu_resume);
-#define EXYNOS4_TMU_PM	(&exynos4_tmu_pm)
+static SIMPLE_DEV_PM_OPS(exynos_tmu_pm,
+			 exynos_tmu_suspend, exynos_tmu_resume);
+#define EXYNOS_TMU_PM	(&exynos_tmu_pm)
 #else
-#define EXYNOS4_TMU_PM	NULL
+#define EXYNOS_TMU_PM	NULL
 #endif
 
-static struct platform_driver exynos4_tmu_driver = {
+static struct platform_driver exynos_tmu_driver = {
 	.driver = {
-		.name   = "exynos4-tmu",
+		.name   = "exynos-tmu",
 		.owner  = THIS_MODULE,
-		.pm     = EXYNOS4_TMU_PM,
+		.pm     = EXYNOS_TMU_PM,
 	},
-	.probe = exynos4_tmu_probe,
-	.remove	= __devexit_p(exynos4_tmu_remove),
+	.probe = exynos_tmu_probe,
+	.remove	= __devexit_p(exynos_tmu_remove),
 };
 
-module_platform_driver(exynos4_tmu_driver);
+module_platform_driver(exynos_tmu_driver);
 
-MODULE_DESCRIPTION("EXYNOS4 TMU Driver");
+MODULE_DESCRIPTION("EXYNOS TMU Driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:exynos4-tmu");
+MODULE_ALIAS("platform:exynos-tmu");
diff --git a/include/linux/platform_data/exynos_thermal.h b/include/linux/platform_data/exynos_thermal.h
index d6c3f93..a9e960a 100644
--- a/include/linux/platform_data/exynos_thermal.h
+++ b/include/linux/platform_data/exynos_thermal.h
@@ -1,5 +1,5 @@
 /*
- * exynos_thermal.h - Samsung EXYNOS4 TMU (Thermal Management Unit)
+ * exynos_thermal.h - Samsung EXYNOS TMU (Thermal Management Unit)
  *
  *  Copyright (C) 2011 Samsung Electronics
  *  Donggeun Kim <dg77.kim@samsung.com>
@@ -28,8 +28,12 @@ enum calibration_type {
 	TYPE_NONE,
 };
 
+enum soc_type {
+	SOC_ARCH_EXYNOS4210 = 1,
+	SOC_ARCH_EXYNOS,
+};
 /**
- * struct exynos4_tmu_platform_data
+ * struct exynos_tmu_platform_data
  * @threshold: basic temperature for generating interrupt
  *	       25 <= threshold <= 125 [unit: degree Celsius]
  * @trigger_levels: array for each interrupt levels
@@ -63,11 +67,15 @@ enum calibration_type {
  * @reference_voltage: reference voltage of amplifier
  *	in the positive-TC generator block
  *	0 <= reference_voltage <= 31
+ * @noise_cancel_mode: noise cancellation mode
+ *	000, 100, 101, 110 and 111 can be different modes
+ * @type: determines the type of SOC
+ * @efuse_value: platform defined fuse value
  * @cal_type: calibration type for temperature
  *
- * This structure is required for configuration of exynos4_tmu driver.
+ * This structure is required for configuration of exynos_tmu driver.
  */
-struct exynos4_tmu_platform_data {
+struct exynos_tmu_platform_data {
 	u8 threshold;
 	u8 trigger_levels[4];
 	bool trigger_level0_en;
@@ -77,7 +85,10 @@ struct exynos4_tmu_platform_data {
 
 	u8 gain;
 	u8 reference_voltage;
+	u8 noise_cancel_mode;
+	u32 efuse_value;
 
 	enum calibration_type cal_type;
+	enum soc_type type;
 };
 #endif /* _LINUX_EXYNOS_THERMAL_H */
-- 
1.7.1

