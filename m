Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2FWMzf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:55:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45506 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab2FWMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:55:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/7] mfd: arizona: Core driver
Date: Sat, 23 Jun 2012 13:55:13 +0100
Message-Id: <1340456118-22366-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20120623125446.GX4037@opensource.wolfsonmicro.com>
 <1340456118-22366-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several forthcoming Wolfson devices are based on a common platform
known as Arizona allowing a great deal of reuse of driver code. This
patch adds core support for these devices.

In order to handle systems which do not use the generic clock API a
simple wrapper for the 32kHz clock domain in the devices is provided.
Once the generic clock API is widely available this code will be moved
over to use that.

For simplicity some WM5102 specific code is included in the core driver,
the effort involved in splitting the device out isn't worth it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c        |  527 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/arizona.h             |   33 +++
 include/linux/mfd/arizona/core.h  |  102 +++++++
 include/linux/mfd/arizona/pdata.h |  119 +++++++++
 4 files changed, 781 insertions(+)
 create mode 100644 drivers/mfd/arizona-core.c
 create mode 100644 drivers/mfd/arizona.h
 create mode 100644 include/linux/mfd/arizona/core.h
 create mode 100644 include/linux/mfd/arizona/pdata.h

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
new file mode 100644
index 0000000..42cb28b
--- /dev/null
+++ b/drivers/mfd/arizona-core.c
@@ -0,0 +1,527 @@
+/*
+ * Arizona core driver
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/arizona/core.h>
+#include <linux/mfd/arizona/registers.h>
+
+#include "arizona.h"
+
+static const char *wm5102_core_supplies[] = {
+	"AVDD",
+	"DBVDD1",
+	"DCVDD",
+};
+
+int arizona_clk32k_enable(struct arizona *arizona)
+{
+	int ret = 0;
+
+	mutex_lock(&arizona->clk_lock);
+
+	arizona->clk32k_ref++;
+
+	if (arizona->clk32k_ref == 1)
+		ret = regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
+					 ARIZONA_CLK_32K_ENA,
+					 ARIZONA_CLK_32K_ENA);
+
+	if (ret != 0)
+		arizona->clk32k_ref--;
+
+	mutex_unlock(&arizona->clk_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_clk32k_enable);
+
+int arizona_clk32k_disable(struct arizona *arizona)
+{
+	int ret = 0;
+
+	mutex_lock(&arizona->clk_lock);
+
+	BUG_ON(arizona->clk32k_ref <= 0);
+
+	arizona->clk32k_ref--;
+
+	if (arizona->clk32k_ref == 0)
+		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
+				   ARIZONA_CLK_32K_ENA, 0);
+
+	mutex_unlock(&arizona->clk_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_clk32k_disable);
+
+static irqreturn_t arizona_clkgen_err(int irq, void *data)
+{
+	struct arizona *arizona = data;
+
+	dev_err(arizona->dev, "CLKGEN error\n");
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t arizona_underclocked(int irq, void *data)
+{
+	struct arizona *arizona = data;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(arizona->regmap, ARIZONA_INTERRUPT_RAW_STATUS_8,
+			  &val);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read underclock status: %d\n",
+			ret);
+		return IRQ_NONE;
+	}
+
+	if (val & ARIZONA_AIF3_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF3 underclocked\n");
+	if (val & ARIZONA_AIF3_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF3 underclocked\n");
+	if (val & ARIZONA_AIF2_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF1 underclocked\n");
+	if (val & ARIZONA_ISRC2_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC2 underclocked\n");
+	if (val & ARIZONA_ISRC1_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC1 underclocked\n");
+	if (val & ARIZONA_FX_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "FX underclocked\n");
+	if (val & ARIZONA_ASRC_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "ASRC underclocked\n");
+	if (val & ARIZONA_DAC_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "DAC underclocked\n");
+	if (val & ARIZONA_ADC_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "ADC underclocked\n");
+	if (val & ARIZONA_MIXER_UNDERCLOCKED_STS)
+		dev_err(arizona->dev, "Mixer underclocked\n");
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t arizona_overclocked(int irq, void *data)
+{
+	struct arizona *arizona = data;
+	unsigned int val[2];
+	int ret;
+	
+	ret = regmap_bulk_read(arizona->regmap, ARIZONA_INTERRUPT_RAW_STATUS_6,
+			       &val[0], 2);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to read overclock status: %d\n",
+			ret);
+		return IRQ_NONE;
+	}
+
+	if (val[0] & ARIZONA_PWM_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "PWM overclocked\n");
+	if (val[0] & ARIZONA_FX_CORE_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "FX core overclocked\n");
+	if (val[0] & ARIZONA_DAC_SYS_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "DAC SYS overclocked\n");
+	if (val[0] & ARIZONA_DAC_WARP_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "DAC WARP overclocked\n");
+	if (val[0] & ARIZONA_ADC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ADC overclocked\n");
+	if (val[0] & ARIZONA_MIXER_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "Mixer overclocked\n");
+	if (val[0] & ARIZONA_AIF3_SYNC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF3 overclocked\n");
+	if (val[0] & ARIZONA_AIF2_SYNC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF2 overclocked\n");
+	if (val[0] & ARIZONA_AIF1_SYNC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "AIF1 overclocked\n");
+	if (val[0] & ARIZONA_PAD_CTRL_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "Pad control overclocked\n");
+
+	if (val[1] & ARIZONA_SLIMBUS_SUBSYS_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "Slimbus subsystem overclocked\n");
+	if (val[1] & ARIZONA_SLIMBUS_ASYNC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "Slimbus async overclocked\n");
+	if (val[1] & ARIZONA_SLIMBUS_SYNC_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "Slimbus sync overclocked\n");
+	if (val[1] & ARIZONA_ASRC_ASYNC_SYS_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ASRC async system overclocked\n");
+	if (val[1] & ARIZONA_ASRC_ASYNC_WARP_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ASRC async WARP overclocked\n");
+	if (val[1] & ARIZONA_ASRC_SYNC_SYS_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ASRC sync system overclocked\n");
+	if (val[1] & ARIZONA_ASRC_SYNC_WARP_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ASRC sync WARP overclocked\n");
+	if (val[1] & ARIZONA_ADSP2_1_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "DSP1 overclocked\n");
+	if (val[1] & ARIZONA_ISRC2_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC2 overclocked\n");
+	if (val[1] & ARIZONA_ISRC1_OVERCLOCKED_STS)
+		dev_err(arizona->dev, "ISRC1 overclocked\n");
+
+	return IRQ_HANDLED;
+}
+
+static int arizona_wait_for_boot(struct arizona *arizona)
+{
+	unsigned int reg;
+	int ret, i;
+
+	/*
+	 * We can't use an interrupt as we need to runtime resume to do so,
+	 * we won't race with the interrupt handler as it'll be blocked on
+	 * runtime resume.
+	 */
+	for (i = 0; i < 5; i++) {
+		msleep(1);
+
+		ret = regmap_read(arizona->regmap,
+				  ARIZONA_INTERRUPT_RAW_STATUS_5, &reg);
+		if (ret != 0) {
+			dev_err(arizona->dev, "Failed to read boot state: %d\n",
+				ret);
+			return ret;
+		}
+
+		if (reg & ARIZONA_BOOT_DONE_STS)
+			break;
+	}
+
+	if (reg & ARIZONA_BOOT_DONE_STS) {
+		regmap_write(arizona->regmap, ARIZONA_INTERRUPT_STATUS_5,
+			     ARIZONA_BOOT_DONE_STS);
+	} else {
+		dev_err(arizona->dev, "Device boot timed out: %x\n", reg);
+		return -ETIMEDOUT;
+	}
+
+	pm_runtime_mark_last_busy(arizona->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int arizona_runtime_resume(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+	int ret;
+
+	if (arizona->pdata.ldoena)
+		gpio_set_value_cansleep(arizona->pdata.ldoena, 1);
+
+	regcache_cache_only(arizona->regmap, false);
+
+	ret = arizona_wait_for_boot(arizona);
+	if (ret != 0)
+		return ret;
+
+	regcache_sync(arizona->regmap);
+
+	return 0;
+}
+
+static int arizona_runtime_suspend(struct device *dev)
+{
+	struct arizona *arizona = dev_get_drvdata(dev);
+
+	if (arizona->pdata.ldoena) {
+		gpio_set_value_cansleep(arizona->pdata.ldoena, 0);
+		regcache_cache_only(arizona->regmap, true);
+		regcache_mark_dirty(arizona->regmap);
+	}
+
+	return 0;
+}
+#endif
+
+const struct dev_pm_ops arizona_pm_ops = {
+	SET_RUNTIME_PM_OPS(arizona_runtime_suspend,
+			   arizona_runtime_resume,
+			   NULL)
+};
+EXPORT_SYMBOL_GPL(arizona_pm_ops);
+
+static struct mfd_cell early_devs[] = {
+	{ .name = "arizona-ldo1" },
+};
+
+static struct mfd_cell wm5102_devs[] = {
+	{ .name = "arizona-extcon" },
+	{ .name = "arizona-gpio" },
+	{ .name = "arizona-micsupp" },
+	{ .name = "arizona-pwm" },
+	{ .name = "wm5102-codec" },
+};
+
+int __devinit arizona_dev_init(struct arizona *arizona)
+{
+	struct device *dev = arizona->dev;
+	const char *type_name;
+	unsigned int reg, val;
+	int ret, i;
+
+	dev_set_drvdata(arizona->dev, arizona);
+	mutex_init(&arizona->clk_lock);
+
+	if (dev_get_platdata(arizona->dev))
+		memcpy(&arizona->pdata, dev_get_platdata(arizona->dev),
+		       sizeof(arizona->pdata));
+
+	regcache_cache_only(arizona->regmap, true);
+
+	switch (arizona->type) {
+	case WM5102:
+		for (i = 0; i < ARRAY_SIZE(wm5102_core_supplies); i++)
+			arizona->core_supplies[i].supply
+				= wm5102_core_supplies[i];
+		arizona->num_core_supplies = ARRAY_SIZE(wm5102_core_supplies);
+		break;
+	default:
+		dev_err(arizona->dev, "Unknown device type %d\n",
+			arizona->type);
+		return -EINVAL;
+	}
+
+	ret = mfd_add_devices(arizona->dev, -1, early_devs,
+			      ARRAY_SIZE(early_devs), NULL, 0);
+	if (ret != 0) {
+		dev_err(dev, "Failed to add early children: %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_regulator_bulk_get(dev, arizona->num_core_supplies,
+				      arizona->core_supplies);
+	if (ret != 0) {
+		dev_err(dev, "Failed to request core supplies: %d\n",
+			ret);
+		goto err_early;
+	}
+
+	ret = regulator_bulk_enable(arizona->num_core_supplies,
+				    arizona->core_supplies);
+	if (ret != 0) {
+		dev_err(dev, "Failed to enable core supplies: %d\n",
+			ret);
+		goto err_early;
+	}
+
+	if (arizona->pdata.reset) {
+		/* Start out with /RESET low to put the chip into reset */
+		ret = gpio_request_one(arizona->pdata.reset,
+				       GPIOF_DIR_OUT | GPIOF_INIT_LOW,
+				       "arizona /RESET");
+		if (ret != 0) {
+			dev_err(dev, "Failed to request /RESET: %d\n", ret);
+			goto err_enable;
+		}
+
+		gpio_set_value_cansleep(arizona->pdata.reset, 1);
+	}
+
+	if (arizona->pdata.ldoena) {
+		ret = gpio_request_one(arizona->pdata.ldoena,
+				       GPIOF_DIR_OUT | GPIOF_INIT_HIGH,
+				       "arizona LDOENA");
+		if (ret != 0) {
+			dev_err(dev, "Failed to request LDOENA: %d\n", ret);
+			goto err_reset;
+		}
+	}
+
+	regcache_cache_only(arizona->regmap, false);
+
+	ret = regmap_read(arizona->regmap, ARIZONA_SOFTWARE_RESET, &reg);
+	if (ret != 0) {
+		dev_err(dev, "Failed to read ID register: %d\n", ret);
+		goto err_ldoena;
+	}
+
+	ret = regmap_read(arizona->regmap, ARIZONA_DEVICE_REVISION,
+			  &arizona->rev);
+	if (ret != 0) {
+		dev_err(dev, "Failed to read revision register: %d\n", ret);
+		goto err_ldoena;
+	}
+	arizona->rev &= ARIZONA_DEVICE_REVISION_MASK;
+
+	switch (reg) {
+	case 0x5102:
+		type_name = "WM5102";
+		if (arizona->type != WM5102) {
+			dev_err(arizona->dev, "WM5102 registered as %d\n",
+				arizona->type);
+			arizona->type = WM5102;
+		}
+		ret = wm5102_patch(arizona);
+		break;
+
+	default:
+		dev_err(arizona->dev, "Unknown device ID %x\n", reg);
+		goto err_ldoena;
+	}
+
+	dev_info(dev, "%s revision %c\n", type_name, arizona->rev + 'A');
+
+	if (ret != 0)
+		dev_err(arizona->dev, "Failed to apply patch: %d\n", ret);
+
+	/* If we have a /RESET GPIO we'll already be reset */
+	if (!arizona->pdata.reset) {
+		ret = regmap_write(arizona->regmap, ARIZONA_SOFTWARE_RESET, 0);
+		if (ret != 0) {
+			dev_err(dev, "Failed to reset device: %d\n", ret);
+			goto err_ldoena;
+		}
+	}
+
+	arizona_wait_for_boot(arizona);
+
+	for (i = 0; i < ARRAY_SIZE(arizona->pdata.gpio_defaults); i++) {
+		if (!arizona->pdata.gpio_defaults[i])
+			continue;
+
+		regmap_write(arizona->regmap, ARIZONA_GPIO1_CTRL + i,
+			     arizona->pdata.gpio_defaults[i]);
+	}
+
+	pm_runtime_set_autosuspend_delay(arizona->dev, 100);
+	pm_runtime_use_autosuspend(arizona->dev);
+	pm_runtime_enable(arizona->dev);
+
+	/* Chip default */
+	if (!arizona->pdata.clk32k_src)
+		arizona->pdata.clk32k_src = ARIZONA_32KZ_MCLK2;
+
+	switch (arizona->pdata.clk32k_src) {
+	case ARIZONA_32KZ_MCLK1:
+	case ARIZONA_32KZ_MCLK2:
+		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
+				   ARIZONA_CLK_32K_SRC_MASK,
+				   arizona->pdata.clk32k_src - 1);
+		break;
+	case ARIZONA_32KZ_NONE:
+		regmap_update_bits(arizona->regmap, ARIZONA_CLOCK_32K_1,
+				   ARIZONA_CLK_32K_SRC_MASK, 2);
+		break;
+	default:
+		dev_err(arizona->dev, "Invalid 32kHz clock source: %d\n",
+			arizona->pdata.clk32k_src);
+		ret = -EINVAL;
+		goto err_ldoena;
+	}
+
+	for (i = 0; i < ARIZONA_MAX_INPUT; i++) {
+		/* Default for both is 0 so noop with defaults */
+		val = arizona->pdata.dmic_ref[i]
+			<< ARIZONA_IN1_DMIC_SUP_SHIFT;
+		val |= arizona->pdata.inmode[i] << ARIZONA_IN1_MODE_SHIFT;
+
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_IN1L_CONTROL + (i * 8),
+				   ARIZONA_IN1_DMIC_SUP_MASK |
+				   ARIZONA_IN1_MODE_MASK, val);
+	}
+
+	for (i = 0; i < ARIZONA_MAX_OUTPUT; i++) {
+		/* Default is 0 so noop with defaults */
+		if (arizona->pdata.out_mono[i])
+			val = ARIZONA_OUT1_MONO;
+		else
+			val = 0;
+
+		regmap_update_bits(arizona->regmap,
+				   ARIZONA_OUTPUT_PATH_CONFIG_1L + (i * 8),
+				   ARIZONA_OUT1_MONO, val);
+	}
+
+	BUILD_BUG_ON(ARIZONA_MAX_PDM_SPK > 1);
+	for (i = 0; i < ARIZONA_MAX_PDM_SPK; i++) {
+		if (arizona->pdata.spk_mute[i])
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_PDM_SPK1_CTRL_1,
+					   ARIZONA_SPK1_MUTE_ENDIAN_MASK |
+					   ARIZONA_SPK1_MUTE_SEQ1_MASK,
+					   arizona->pdata.spk_mute[i]);
+
+		if (arizona->pdata.spk_fmt[i])
+			regmap_update_bits(arizona->regmap,
+					   ARIZONA_PDM_SPK1_CTRL_2,
+					   ARIZONA_SPK1_FMT_MASK,
+					   arizona->pdata.spk_fmt[i]);
+	}
+
+	/* Set up for interrupts */
+	ret = arizona_irq_init(arizona);
+	if (ret != 0)
+		goto err_ldoena;
+
+	arizona_request_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, "CLKGEN error",
+			    arizona_clkgen_err, arizona);
+	arizona_request_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, "Overclocked",
+			    arizona_overclocked, arizona);
+	arizona_request_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, "Underclocked",
+			    arizona_underclocked, arizona);
+
+	switch (arizona->type) {
+	case WM5102:
+		ret = mfd_add_devices(arizona->dev, -1, wm5102_devs,
+				      ARRAY_SIZE(wm5102_devs), NULL, 0);
+		break;
+	}
+
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to add subdevices: %d\n", ret);
+		goto err_irq;
+	}
+
+	return 0;
+
+err_irq:
+	arizona_irq_exit(arizona);
+err_ldoena:
+	if (arizona->pdata.ldoena) {
+		gpio_set_value_cansleep(arizona->pdata.ldoena, 0);
+		gpio_free(arizona->pdata.ldoena);
+	}
+err_reset:
+	if (arizona->pdata.reset) {
+		gpio_set_value_cansleep(arizona->pdata.reset, 1);
+		gpio_free(arizona->pdata.reset);
+	}
+err_enable:
+	regulator_bulk_disable(ARRAY_SIZE(arizona->core_supplies),
+			       arizona->core_supplies);
+err_early:
+	mfd_remove_devices(dev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(arizona_dev_init);
+
+int __devexit arizona_dev_exit(struct arizona *arizona)
+{
+	mfd_remove_devices(arizona->dev);
+	arizona_free_irq(arizona, ARIZONA_IRQ_UNDERCLOCKED, arizona);
+	arizona_free_irq(arizona, ARIZONA_IRQ_OVERCLOCKED, arizona);
+	arizona_free_irq(arizona, ARIZONA_IRQ_CLKGEN_ERR, arizona);
+	pm_runtime_disable(arizona->dev);
+	arizona_irq_exit(arizona);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arizona_dev_exit);
diff --git a/drivers/mfd/arizona.h b/drivers/mfd/arizona.h
new file mode 100644
index 0000000..1c9f333
--- /dev/null
+++ b/drivers/mfd/arizona.h
@@ -0,0 +1,33 @@
+/*
+ * wm5102.h  --  WM5102 MFD internals
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _WM5102_H
+#define _WM5102_H
+
+#include <linux/regmap.h>
+#include <linux/pm.h>
+
+struct wm_arizona;
+
+extern const struct regmap_config wm5102_i2c_regmap;
+extern const struct regmap_config wm5102_spi_regmap;
+extern const struct dev_pm_ops arizona_pm_ops;
+
+extern const struct regmap_irq_chip wm5102_aod;
+extern const struct regmap_irq_chip wm5102_irq;
+
+int arizona_dev_init(struct arizona *arizona);
+int arizona_dev_exit(struct arizona *arizona);
+int arizona_irq_init(struct arizona *arizona);
+int arizona_irq_exit(struct arizona *arizona);
+
+#endif
diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
new file mode 100644
index 0000000..0157d84
--- /dev/null
+++ b/include/linux/mfd/arizona/core.h
@@ -0,0 +1,102 @@
+/*
+ * Arizona MFD internals
+ *
+ * Copyright 2012 Wolfson Microelectronics plc
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _WM_ARIZONA_CORE_H
+#define _WM_ARIZONA_CORE_H
+
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/mfd/arizona/pdata.h>
+
+#define ARIZONA_MAX_CORE_SUPPLIES 3
+
+enum arizona_type {
+	WM5102 = 1,
+};
+
+#define ARIZONA_IRQ_GP1                    0
+#define ARIZONA_IRQ_GP2                    1
+#define ARIZONA_IRQ_GP3                    2
+#define ARIZONA_IRQ_GP4                    3
+#define ARIZONA_IRQ_GP5_FALL               4
+#define ARIZONA_IRQ_GP5_RISE               5
+#define ARIZONA_IRQ_JD_FALL                6
+#define ARIZONA_IRQ_JD_RISE                7
+#define ARIZONA_IRQ_DSP1_RAM_RDY           8
+#define ARIZONA_IRQ_DSP_IRQ1               9
+#define ARIZONA_IRQ_DSP_IRQ2              10
+#define ARIZONA_IRQ_SPK_SHUTDOWN_WARN     11
+#define ARIZONA_IRQ_SPK_SHUTDOWN          12
+#define ARIZONA_IRQ_MICDET                13
+#define ARIZONA_IRQ_HPDET                 14
+#define ARIZONA_IRQ_WSEQ_DONE             15
+#define ARIZONA_IRQ_DRC2_SIG_DET          16
+#define ARIZONA_IRQ_DRC1_SIG_DET          17
+#define ARIZONA_IRQ_ASRC2_LOCK            18
+#define ARIZONA_IRQ_ASRC1_LOCK            19
+#define ARIZONA_IRQ_UNDERCLOCKED          20
+#define ARIZONA_IRQ_OVERCLOCKED           21
+#define ARIZONA_IRQ_FLL2_LOCK             22
+#define ARIZONA_IRQ_FLL1_LOCK             23
+#define ARIZONA_IRQ_CLKGEN_ERR            24
+#define ARIZONA_IRQ_CLKGEN_ERR_ASYNC      25
+#define ARIZONA_IRQ_ASRC_CFG_ERR          26
+#define ARIZONA_IRQ_AIF3_ERR              27
+#define ARIZONA_IRQ_AIF2_ERR              28
+#define ARIZONA_IRQ_AIF1_ERR              29
+#define ARIZONA_IRQ_CTRLIF_ERR            30
+#define ARIZONA_IRQ_MIXER_DROPPED_SAMPLES 31
+#define ARIZONA_IRQ_ASYNC_CLK_ENA_LOW     32
+#define ARIZONA_IRQ_SYSCLK_ENA_LOW        33
+#define ARIZONA_IRQ_ISRC1_CFG_ERR         34
+#define ARIZONA_IRQ_ISRC2_CFG_ERR         35
+#define ARIZONA_IRQ_BOOT_DONE             36
+#define ARIZONA_IRQ_DCS_DAC_DONE          37
+#define ARIZONA_IRQ_DCS_HP_DONE           38
+#define ARIZONA_IRQ_FLL2_CLOCK_OK         39
+#define ARIZONA_IRQ_FLL1_CLOCK_OK         40
+
+#define ARIZONA_NUM_IRQ                   41
+
+struct arizona {
+	struct regmap *regmap;
+	struct device *dev;
+
+	enum arizona_type type;
+	unsigned int rev;
+
+	int num_core_supplies;
+	struct regulator_bulk_data core_supplies[ARIZONA_MAX_CORE_SUPPLIES];
+
+	struct arizona_pdata pdata;
+
+	int irq;
+	struct irq_domain *virq;
+	struct regmap_irq_chip_data *aod_irq_chip;
+	struct regmap_irq_chip_data *irq_chip;
+
+	struct mutex clk_lock;
+	int clk32k_ref;
+};
+
+int arizona_clk32k_enable(struct arizona *arizona);
+int arizona_clk32k_disable(struct arizona *arizona);
+
+int arizona_request_irq(struct arizona *arizona, int irq, char *name,
+			irq_handler_t handler, void *data);
+void arizona_free_irq(struct arizona *arizona, int irq, void *data);
+int arizona_set_irq_wake(struct arizona *arizona, int irq, int on);
+
+int wm5102_patch(struct arizona *arizona);
+
+#endif
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
new file mode 100644
index 0000000..fa2cb98
--- /dev/null
+++ b/include/linux/mfd/arizona/pdata.h
@@ -0,0 +1,119 @@
+/*
+ * Platform data for Arizona devices
+ *
+ * Copyright 2012 Wolfson Microelectronics. PLC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ARIZONA_PDATA_H
+#define _ARIZONA_PDATA_H
+
+#define ARIZONA_GPN_DIR                          0x8000  /* GPN_DIR */
+#define ARIZONA_GPN_DIR_MASK                     0x8000  /* GPN_DIR */
+#define ARIZONA_GPN_DIR_SHIFT                        15  /* GPN_DIR */
+#define ARIZONA_GPN_DIR_WIDTH                         1  /* GPN_DIR */
+#define ARIZONA_GPN_PU                           0x4000  /* GPN_PU */
+#define ARIZONA_GPN_PU_MASK                      0x4000  /* GPN_PU */
+#define ARIZONA_GPN_PU_SHIFT                         14  /* GPN_PU */
+#define ARIZONA_GPN_PU_WIDTH                          1  /* GPN_PU */
+#define ARIZONA_GPN_PD                           0x2000  /* GPN_PD */
+#define ARIZONA_GPN_PD_MASK                      0x2000  /* GPN_PD */
+#define ARIZONA_GPN_PD_SHIFT                         13  /* GPN_PD */
+#define ARIZONA_GPN_PD_WIDTH                          1  /* GPN_PD */
+#define ARIZONA_GPN_LVL                          0x0800  /* GPN_LVL */
+#define ARIZONA_GPN_LVL_MASK                     0x0800  /* GPN_LVL */
+#define ARIZONA_GPN_LVL_SHIFT                        11  /* GPN_LVL */
+#define ARIZONA_GPN_LVL_WIDTH                         1  /* GPN_LVL */
+#define ARIZONA_GPN_POL                          0x0400  /* GPN_POL */
+#define ARIZONA_GPN_POL_MASK                     0x0400  /* GPN_POL */
+#define ARIZONA_GPN_POL_SHIFT                        10  /* GPN_POL */
+#define ARIZONA_GPN_POL_WIDTH                         1  /* GPN_POL */
+#define ARIZONA_GPN_OP_CFG                       0x0200  /* GPN_OP_CFG */
+#define ARIZONA_GPN_OP_CFG_MASK                  0x0200  /* GPN_OP_CFG */
+#define ARIZONA_GPN_OP_CFG_SHIFT                      9  /* GPN_OP_CFG */
+#define ARIZONA_GPN_OP_CFG_WIDTH                      1  /* GPN_OP_CFG */
+#define ARIZONA_GPN_DB                           0x0100  /* GPN_DB */
+#define ARIZONA_GPN_DB_MASK                      0x0100  /* GPN_DB */
+#define ARIZONA_GPN_DB_SHIFT                          8  /* GPN_DB */
+#define ARIZONA_GPN_DB_WIDTH                          1  /* GPN_DB */
+#define ARIZONA_GPN_FN_MASK                      0x007F  /* GPN_FN - [6:0] */
+#define ARIZONA_GPN_FN_SHIFT                          0  /* GPN_FN - [6:0] */
+#define ARIZONA_GPN_FN_WIDTH                          7  /* GPN_FN - [6:0] */
+
+#define ARIZONA_MAX_GPIO 5
+
+#define ARIZONA_32KZ_MCLK1 1
+#define ARIZONA_32KZ_MCLK2 2
+#define ARIZONA_32KZ_NONE  3
+
+#define ARIZONA_MAX_INPUT 3
+
+#define ARIZONA_DMIC_MICVDD   0
+#define ARIZONA_DMIC_MICBIAS1 1
+#define ARIZONA_DMIC_MICBIAS2 2
+#define ARIZONA_DMIC_MICBIAS3 3
+
+#define ARIZONA_INMODE_DIFF 0
+#define ARIZONA_INMODE_SE   1
+#define ARIZONA_INMODE_DMIC 2
+
+#define ARIZONA_MAX_OUTPUT 5
+
+#define ARIZONA_MAX_PDM_SPK 1
+
+struct regulator_init_data;
+
+struct arizona_micd_config {
+	unsigned int src;
+	unsigned int bias;
+	bool gpio;
+};
+
+struct arizona_pdata {
+	int reset;      /** GPIO controlling /RESET, if any */
+	int ldoena;     /** GPIO controlling LODENA, if any */
+
+	/** Regulator configuration for MICVDD */
+	struct regulator_init_data *micvdd;
+
+	/** Regulator configuration for LDO1 */
+	struct regulator_init_data *ldo1;
+
+	/** If a direct 32kHz clock is provided on an MCLK specify it here */
+	int clk32k_src;
+
+	bool irq_active_high; /** IRQ polarity */
+
+	/* Base GPIO */
+	int gpio_base;
+
+	/** Pin state for GPIO pins */
+	int gpio_defaults[ARIZONA_MAX_GPIO];
+
+	/** GPIO for mic detection polarity */
+	int micd_pol_gpio;
+
+	/** Headset polarity configurations */
+	struct arizona_micd_config *micd_configs;
+	int num_micd_configs;
+
+	/** Reference voltage for DMIC inputs */
+	int dmic_ref[ARIZONA_MAX_INPUT];
+
+	/** Mode of input structures */
+	int inmode[ARIZONA_MAX_INPUT];
+
+	/** Mode for outputs */
+	bool out_mono[ARIZONA_MAX_OUTPUT];
+
+	/** PDM speaker mute setting */
+	unsigned int spk_mute[ARIZONA_MAX_PDM_SPK];
+
+	/** PDM speaker format */
+	unsigned int spk_fmt[ARIZONA_MAX_PDM_SPK];
+};
+
+#endif
-- 
1.7.10

