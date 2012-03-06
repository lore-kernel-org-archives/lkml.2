Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030625Ab2CFMf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:35:57 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:48635 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030601Ab2CFMfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:35:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.112.99.202 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tony Lindgren <tony@atomide.com>, Liam Girdwood <lrg@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, paul.gortmaker@windriver.com
Subject: [PATCH 4/5] Revert "mfd: Convert twl6040 to an i2c driver, and separate it from twl core"
Date: Tue,  6 Mar 2012 14:35:15 +0200
Message-Id: <1331037316-7375-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
References: <1331037316-7375-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ded0df8510778a03a2f182a0cbfe3c25788e8852.

Reverting changes regarding to twl6040 in MFD tree since the patches will go
via the audio tree.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |    4 +-
 arch/arm/mach-omap2/twl-common.c       |   37 ++---------
 arch/arm/mach-omap2/twl-common.h       |   10 ++-
 drivers/input/misc/Kconfig             |    1 +
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |    2 +-
 drivers/mfd/twl6040-core.c             |  114 +++++++++++++-------------------
 include/linux/i2c/twl.h                |   12 ++++
 include/linux/mfd/twl6040.h            |   27 --------
 sound/soc/codecs/twl6040.c             |    3 +-
 12 files changed, 83 insertions(+), 145 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 474bcf3..4e90715 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -20,7 +20,6 @@
 #include <linux/usb/otg.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c/twl.h>
-#include <linux/mfd/twl6040.h>
 #include <linux/gpio_keys.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
@@ -527,7 +526,7 @@ static struct regulator_init_data sdp4430_vusim = {
 	},
 };
 
-static struct twl6040_codec_data twl6040_codec = {
+static struct twl4030_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -535,7 +534,7 @@ static struct twl6040_codec_data twl6040_codec = {
 	.hf_right_step	= 0x1d,
 };
 
-static struct twl6040_vibra_data twl6040_vibra = {
+static struct twl4030_vibra_data twl6040_vibra = {
 	.vibldrv_res = 8,
 	.vibrdrv_res = 3,
 	.viblmotor_res = 10,
@@ -544,14 +543,16 @@ static struct twl6040_vibra_data twl6040_vibra = {
 	.vddvibr_uV = 0,	/* fixed volt supply - VBAT */
 };
 
-static struct twl6040_platform_data twl6040_data = {
+static struct twl4030_audio_data twl6040_audio = {
 	.codec		= &twl6040_codec,
 	.vibra		= &twl6040_vibra,
 	.audpwron_gpio	= 127,
+	.naudint_irq	= OMAP44XX_IRQ_SYS_2N,
 	.irq_base	= TWL6040_CODEC_IRQ_BASE,
 };
 
 static struct twl4030_platform_data sdp4430_twldata = {
+	.audio		= &twl6040_audio,
 	/* Regulators */
 	.vusim		= &sdp4430_vusim,
 	.vaux1		= &sdp4430_vaux1,
@@ -582,8 +583,7 @@ static int __init omap4_i2c_init(void)
 			TWL_COMMON_REGULATOR_VCXIO |
 			TWL_COMMON_REGULATOR_VUSB |
 			TWL_COMMON_REGULATOR_CLK32KG);
-	omap4_pmic_init("twl6030", &sdp4430_twldata,
-			&twl6040_data, OMAP44XX_IRQ_SYS_2N);
+	omap4_pmic_init("twl6030", &sdp4430_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, sdp4430_i2c_3_boardinfo,
 				ARRAY_SIZE(sdp4430_i2c_3_boardinfo));
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 42f6a27..ad49762 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -36,7 +36,7 @@ static struct twl4030_platform_data sdp4430_twldata = {
 
 static void __init omap4_i2c_init(void)
 {
-	omap4_pmic_init("twl6030", &sdp4430_twldata, NULL, 0);
+	omap4_pmic_init("twl6030", &sdp4430_twldata);
 }
 #endif
 
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index c39d6d5..28fc271 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -25,7 +25,6 @@
 #include <linux/gpio.h>
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl.h>
-#include <linux/mfd/twl6040.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 #include <linux/wl12xx.h>
@@ -278,8 +277,7 @@ static int __init omap4_panda_i2c_init(void)
 			TWL_COMMON_REGULATOR_VCXIO |
 			TWL_COMMON_REGULATOR_VUSB |
 			TWL_COMMON_REGULATOR_CLK32KG);
-	omap4_pmic_init("twl6030", &omap4_panda_twldata,
-			&twl6040_data, OMAP44XX_IRQ_SYS_2N);
+	omap4_pmic_init("twl6030", &omap4_panda_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	/*
 	 * Bus 3 is attached to the DVI port where devices like the pico DLP
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index bc03154..10b20c6 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -37,16 +37,6 @@ static struct i2c_board_info __initdata pmic_i2c_board_info = {
 	.flags		= I2C_CLIENT_WAKE,
 };
 
-static struct i2c_board_info __initdata omap4_i2c1_board_info[] = {
-	{
-		.addr		= 0x48,
-		.flags		= I2C_CLIENT_WAKE,
-	},
-	{
-		I2C_BOARD_INFO("twl6040", 0x4b),
-	},
-};
-
 void __init omap_pmic_init(int bus, u32 clkrate,
 			   const char *pmic_type, int pmic_irq,
 			   struct twl4030_platform_data *pmic_data)
@@ -59,31 +49,14 @@ void __init omap_pmic_init(int bus, u32 clkrate,
 	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
 }
 
-void omap4_pmic_init(const char *pmic_type,
-		    struct twl4030_platform_data *pmic_data,
-		    struct twl6040_platform_data *twl6040_data, int twl6040_irq)
-{
-	/* PMIC part*/
-	strncpy(omap4_i2c1_board_info[0].type, pmic_type,
-		sizeof(omap4_i2c1_board_info[0].type));
-	omap4_i2c1_board_info[0].irq = OMAP44XX_IRQ_SYS_1N;
-	omap4_i2c1_board_info[0].platform_data = pmic_data;
-
-	/* TWL6040 audio IC part */
-	omap4_i2c1_board_info[1].irq = twl6040_irq;
-	omap4_i2c1_board_info[1].platform_data = twl6040_data;
-
-	omap_register_i2c_bus(1, 400, omap4_i2c1_board_info, 2);
-
-}
-
 void __init omap_pmic_late_init(void)
 {
 	/* Init the OMAP TWL parameters (if PMIC has been registerd) */
-	if (pmic_i2c_board_info.irq)
-		omap3_twl_init();
-	if (omap4_i2c1_board_info[0].irq)
-		omap4_twl_init();
+	if (!pmic_i2c_board_info.irq)
+		return;
+
+	omap3_twl_init();
+	omap4_twl_init();
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index 0962748..275dde8 100644
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -29,7 +29,6 @@
 
 
 struct twl4030_platform_data;
-struct twl6040_platform_data;
 
 void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
 		    struct twl4030_platform_data *pmic_data);
@@ -47,9 +46,12 @@ static inline void omap3_pmic_init(const char *pmic_type,
 	omap_pmic_init(1, 2600, pmic_type, INT_34XX_SYS_NIRQ, pmic_data);
 }
 
-void omap4_pmic_init(const char *pmic_type,
-		    struct twl4030_platform_data *pmic_data,
-		    struct twl6040_platform_data *audio_data, int twl6040_irq);
+static inline void omap4_pmic_init(const char *pmic_type,
+				   struct twl4030_platform_data *pmic_data)
+{
+	/* Phoenix Audio IC needs I2C1 to start with 400 KHz or less */
+	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
+}
 
 void omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 			   u32 pdata_flags, u32 regulators_flags);
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 6a9ee24..7b46781 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -368,6 +368,7 @@ config INPUT_TWL4030_VIBRA
 
 config INPUT_TWL6040_VIBRA
 	tristate "Support for TWL6040 Vibrator"
+	depends on TWL4030_CORE
 	select TWL6040_CORE
 	select INPUT_FF_MEMLESS
 	help
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 14e94f5..45874fe 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
-#include <linux/input.h>
+#include <linux/i2c/twl.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -257,7 +257,7 @@ static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops, twl6040_vibra_suspend, NULL);
 
 static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 {
-	struct twl6040_vibra_data *pdata = pdev->dev.platform_data;
+	struct twl4030_vibra_data *pdata = pdev->dev.platform_data;
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 880c69a..82da448 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -268,7 +268,7 @@ config TWL6030_PWM
 
 config TWL6040_CORE
 	bool
-	depends on I2C && GENERIC_HARDIRQS
+	depends on TWL4030_CORE && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 2d6beda..b2d8e51 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -30,9 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
-#include <linux/i2c.h>
-#include <linux/regmap.h>
-#include <linux/err.h>
+#include <linux/i2c/twl.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 
@@ -41,7 +39,7 @@
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
-	unsigned int val;
+	u8 val = 0;
 
 	mutex_lock(&twl6040->io_mutex);
 	/* Vibra control registers from cache */
@@ -49,7 +47,7 @@ int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 		     reg == TWL6040_REG_VIBCTLR)) {
 		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
 	} else {
-		ret = regmap_read(twl6040->regmap, reg, &val);
+		ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
 		if (ret < 0) {
 			mutex_unlock(&twl6040->io_mutex);
 			return ret;
@@ -66,7 +64,7 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 	int ret;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = regmap_write(twl6040->regmap, reg, val);
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
 	/* Cache the vibra control registers */
 	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
 		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
@@ -79,9 +77,16 @@ EXPORT_SYMBOL(twl6040_reg_write);
 int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
 	int ret;
+	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = regmap_update_bits(twl6040->regmap, reg, mask, mask);
+	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	if (ret)
+		goto out;
+
+	val |= mask;
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+out:
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
 }
@@ -90,9 +95,16 @@ EXPORT_SYMBOL(twl6040_set_bits);
 int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
 	int ret;
+	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = regmap_update_bits(twl6040->regmap, reg, mask, 0);
+	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	if (ret)
+		goto out;
+
+	val &= ~mask;
+	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+out:
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
 }
@@ -482,58 +494,32 @@ static struct resource twl6040_codec_rsrc[] = {
 	},
 };
 
-static bool twl6040_readable_reg(struct device *dev, unsigned int reg)
+static int __devinit twl6040_probe(struct platform_device *pdev)
 {
-	/* Register 0 is not readable */
-	if (!reg)
-		return false;
-	return true;
-}
-
-static struct regmap_config twl6040_regmap_config = {
-	.reg_bits = 8,
-	.val_bits = 8,
-	.max_register = TWL6040_REG_STATUS, /* 0x2e */
-
-	.readable_reg = twl6040_readable_reg,
-};
-
-static int __devinit twl6040_probe(struct i2c_client *client,
-				     const struct i2c_device_id *id)
-{
-	struct twl6040_platform_data *pdata = client->dev.platform_data;
+	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
 	int ret, children = 0;
 
 	if (!pdata) {
-		dev_err(&client->dev, "Platform data is missing\n");
+		dev_err(&pdev->dev, "Platform data is missing\n");
 		return -EINVAL;
 	}
 
 	/* In order to operate correctly we need valid interrupt config */
-	if (!client->irq || !pdata->irq_base) {
-		dev_err(&client->dev, "Invalid IRQ configuration\n");
+	if (!pdata->naudint_irq || !pdata->irq_base) {
+		dev_err(&pdev->dev, "Invalid IRQ configuration\n");
 		return -EINVAL;
 	}
 
-	twl6040 = devm_kzalloc(&client->dev, sizeof(struct twl6040),
-			       GFP_KERNEL);
-	if (!twl6040) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
-	if (IS_ERR(twl6040->regmap)) {
-		ret = PTR_ERR(twl6040->regmap);
-		goto err;
-	}
+	twl6040 = kzalloc(sizeof(struct twl6040), GFP_KERNEL);
+	if (!twl6040)
+		return -ENOMEM;
 
-	i2c_set_clientdata(client, twl6040);
+	platform_set_drvdata(pdev, twl6040);
 
-	twl6040->dev = &client->dev;
-	twl6040->irq = client->irq;
+	twl6040->dev = &pdev->dev;
+	twl6040->irq = pdata->naudint_irq;
 	twl6040->irq_base = pdata->irq_base;
 
 	mutex_init(&twl6040->mutex);
@@ -602,12 +588,12 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	}
 
 	if (children) {
-		ret = mfd_add_devices(&client->dev, -1, twl6040->cells,
+		ret = mfd_add_devices(&pdev->dev, pdev->id, twl6040->cells,
 				      children, NULL, 0);
 		if (ret)
 			goto mfd_err;
 	} else {
-		dev_err(&client->dev, "No platform data found for children\n");
+		dev_err(&pdev->dev, "No platform data found for children\n");
 		ret = -ENODEV;
 		goto mfd_err;
 	}
@@ -622,15 +608,14 @@ gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 gpio1_err:
-	i2c_set_clientdata(client, NULL);
-	regmap_exit(twl6040->regmap);
-err:
+	platform_set_drvdata(pdev, NULL);
+	kfree(twl6040);
 	return ret;
 }
 
-static int __devexit twl6040_remove(struct i2c_client *client)
+static int __devexit twl6040_remove(struct platform_device *pdev)
 {
-	struct twl6040 *twl6040 = i2c_get_clientdata(client);
+	struct twl6040 *twl6040 = platform_get_drvdata(pdev);
 
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
@@ -641,30 +626,23 @@ static int __devexit twl6040_remove(struct i2c_client *client)
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 	twl6040_irq_exit(twl6040);
 
-	mfd_remove_devices(&client->dev);
-	i2c_set_clientdata(client, NULL);
-	regmap_exit(twl6040->regmap);
+	mfd_remove_devices(&pdev->dev);
+	platform_set_drvdata(pdev, NULL);
+	kfree(twl6040);
 
 	return 0;
 }
 
-static const struct i2c_device_id twl6040_i2c_id[] = {
-	{ "twl6040", 0, },
-	{ },
-};
-MODULE_DEVICE_TABLE(i2c, twl6040_i2c_id);
-
-static struct i2c_driver twl6040_driver = {
-	.driver = {
-		.name = "twl6040",
-		.owner = THIS_MODULE,
-	},
+static struct platform_driver twl6040_driver = {
 	.probe		= twl6040_probe,
 	.remove		= __devexit_p(twl6040_remove),
-	.id_table	= twl6040_i2c_id,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "twl6040",
+	},
 };
 
-module_i2c_driver(twl6040_driver);
+module_platform_driver(twl6040_driver);
 
 MODULE_DESCRIPTION("TWL6040 MFD");
 MODULE_AUTHOR("Misael Lopez Cruz <misael.lopez@ti.com>");
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 3826a53..78d3465 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -666,11 +666,23 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
+	u16 hs_left_step;
+	u16 hs_right_step;
+	u16 hf_left_step;
+	u16 hf_right_step;
 	void (*set_hs_extmute)(int mute);
 };
 
 struct twl4030_vibra_data {
 	unsigned int	coexist;
+
+	/* twl6040 */
+	unsigned int vibldrv_res;	/* left driver resistance */
+	unsigned int vibrdrv_res;	/* right driver resistance */
+	unsigned int viblmotor_res;	/* left motor resistance */
+	unsigned int vibrmotor_res;	/* right motor resistance */
+	int vddvibl_uV;			/* VDDVIBL volt, set 0 for fixed reg */
+	int vddvibr_uV;			/* VDDVIBR volt, set 0 for fixed reg */
 };
 
 struct twl4030_audio_data {
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index b15b5f0..9bc9ac6 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -174,35 +174,8 @@
 #define TWL6040_SYSCLK_SEL_LPPLL	0
 #define TWL6040_SYSCLK_SEL_HPPLL	1
 
-struct twl6040_codec_data {
-	u16 hs_left_step;
-	u16 hs_right_step;
-	u16 hf_left_step;
-	u16 hf_right_step;
-};
-
-struct twl6040_vibra_data {
-	unsigned int vibldrv_res;	/* left driver resistance */
-	unsigned int vibrdrv_res;	/* right driver resistance */
-	unsigned int viblmotor_res;	/* left motor resistance */
-	unsigned int vibrmotor_res;	/* right motor resistance */
-	int vddvibl_uV;			/* VDDVIBL volt, set 0 for fixed reg */
-	int vddvibr_uV;			/* VDDVIBR volt, set 0 for fixed reg */
-};
-
-struct twl6040_platform_data {
-	int audpwron_gpio;	/* audio power-on gpio */
-	unsigned int irq_base;
-
-	struct twl6040_codec_data *codec;
-	struct twl6040_vibra_data *vibra;
-};
-
-struct regmap;
-
 struct twl6040 {
 	struct device *dev;
-	struct regmap *regmap;
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 406eeee..5b9c79b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -26,6 +26,7 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/i2c/twl.h>
 #include <linux/mfd/twl6040.h>
 
 #include <sound/core.h>
@@ -1514,7 +1515,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv;
-	struct twl6040_codec_data *pdata = dev_get_platdata(codec->dev);
+	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct platform_device *pdev = container_of(codec->dev,
 						   struct platform_device, dev);
 	int ret = 0;
-- 
1.7.8.5

