Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab2B1IfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:35:15 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47232 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196Ab2B1IfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:35:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of peter.ujfalusi@ti.com designates 10.112.24.196 as permitted sender) smtp.mail=peter.ujfalusi@ti.com
MIME-Version: 1.0
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] MFD: twl6040: Convert to i2c driver, and separate it from twl core
Date: Tue, 28 Feb 2012 10:34:52 +0200
Message-Id: <1330418092-12314-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
References: <1330418092-12314-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Complete the separation of the twl6040 from the twl core since
it is a separate chip, not part of the twl6030 PMIC.

Make the needed Kconfig changes for the depending drivers at the same time to
avoid breaking the kernel build (vibra, ASoC components).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonicro.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   13 ++--
 arch/arm/mach-omap2/twl-common.c       |   37 +++++++++--
 arch/arm/mach-omap2/twl-common.h       |   10 +--
 drivers/input/misc/Kconfig             |    3 +-
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |   11 +++-
 drivers/mfd/twl6040-core.c             |  114 +++++++++++++++++++-------------
 include/linux/i2c/twl.h                |   12 ----
 include/linux/mfd/twl6040.h            |   27 ++++++++
 sound/soc/codecs/Kconfig               |    3 +-
 sound/soc/codecs/twl6040.c             |    3 +-
 sound/soc/omap/Kconfig                 |    2 +-
 14 files changed, 159 insertions(+), 94 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 90c76d3..f5a03fa 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -20,6 +20,7 @@
 #include <linux/usb/otg.h>
 #include <linux/spi/spi.h>
 #include <linux/i2c/twl.h>
+#include <linux/mfd/twl6040.h>
 #include <linux/gpio_keys.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
@@ -555,7 +556,7 @@ static struct regulator_init_data sdp4430_vusim = {
 	},
 };
 
-static struct twl4030_codec_data twl6040_codec = {
+static struct twl6040_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -563,7 +564,7 @@ static struct twl4030_codec_data twl6040_codec = {
 	.hf_right_step	= 0x1d,
 };
 
-static struct twl4030_vibra_data twl6040_vibra = {
+static struct twl6040_vibra_data twl6040_vibra = {
 	.vibldrv_res = 8,
 	.vibrdrv_res = 3,
 	.viblmotor_res = 10,
@@ -572,16 +573,14 @@ static struct twl4030_vibra_data twl6040_vibra = {
 	.vddvibr_uV = 0,	/* fixed volt supply - VBAT */
 };
 
-static struct twl4030_audio_data twl6040_audio = {
+static struct twl6040_platform_data twl6040_data = {
 	.codec		= &twl6040_codec,
 	.vibra		= &twl6040_vibra,
 	.audpwron_gpio	= 127,
-	.naudint_irq	= OMAP44XX_IRQ_SYS_2N,
 	.irq_base	= TWL6040_CODEC_IRQ_BASE,
 };
 
 static struct twl4030_platform_data sdp4430_twldata = {
-	.audio		= &twl6040_audio,
 	/* Regulators */
 	.vusim		= &sdp4430_vusim,
 	.vaux1		= &sdp4430_vaux1,
@@ -612,7 +611,8 @@ static int __init omap4_i2c_init(void)
 			TWL_COMMON_REGULATOR_VCXIO |
 			TWL_COMMON_REGULATOR_VUSB |
 			TWL_COMMON_REGULATOR_CLK32KG);
-	omap4_pmic_init("twl6030", &sdp4430_twldata);
+	omap4_pmic_init("twl6030", &sdp4430_twldata,
+			&twl6040_data, OMAP44XX_IRQ_SYS_2N);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	omap_register_i2c_bus(3, 400, sdp4430_i2c_3_boardinfo,
 				ARRAY_SIZE(sdp4430_i2c_3_boardinfo));
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index ad49762..42f6a27 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -36,7 +36,7 @@ static struct twl4030_platform_data sdp4430_twldata = {
 
 static void __init omap4_i2c_init(void)
 {
-	omap4_pmic_init("twl6030", &sdp4430_twldata);
+	omap4_pmic_init("twl6030", &sdp4430_twldata, NULL, 0);
 }
 #endif
 
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 1af564b..56431e4 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -25,6 +25,7 @@
 #include <linux/gpio.h>
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl.h>
+#include <linux/mfd/twl6040.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 #include <linux/wl12xx.h>
@@ -278,7 +279,7 @@ static int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
 	return 0;
 }
 
-static struct twl4030_codec_data twl6040_codec = {
+static struct twl6040_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -286,17 +287,14 @@ static struct twl4030_codec_data twl6040_codec = {
 	.hf_right_step	= 0x1d,
 };
 
-static struct twl4030_audio_data twl6040_audio = {
+static struct twl6040_platform_data twl6040_data = {
 	.codec		= &twl6040_codec,
 	.audpwron_gpio	= 127,
-	.naudint_irq	= OMAP44XX_IRQ_SYS_2N,
 	.irq_base	= TWL6040_CODEC_IRQ_BASE,
 };
 
 /* Panda board uses the common PMIC configuration */
-static struct twl4030_platform_data omap4_panda_twldata = {
-	.audio		= &twl6040_audio,
-};
+static struct twl4030_platform_data omap4_panda_twldata;
 
 /*
  * Display monitor features are burnt in their EEPROM as EDID data. The EEPROM
@@ -320,7 +318,8 @@ static int __init omap4_panda_i2c_init(void)
 			TWL_COMMON_REGULATOR_VCXIO |
 			TWL_COMMON_REGULATOR_VUSB |
 			TWL_COMMON_REGULATOR_CLK32KG);
-	omap4_pmic_init("twl6030", &omap4_panda_twldata);
+	omap4_pmic_init("twl6030", &omap4_panda_twldata,
+			&twl6040_data, OMAP44XX_IRQ_SYS_2N);
 	omap_register_i2c_bus(2, 400, NULL, 0);
 	/*
 	 * Bus 3 is attached to the DVI port where devices like the pico DLP
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 10b20c6..376231d 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -37,6 +37,16 @@ static struct i2c_board_info __initdata pmic_i2c_board_info = {
 	.flags		= I2C_CLIENT_WAKE,
 };
 
+static struct i2c_board_info __initdata omap4_i2c1_board_info[] = {
+	{
+		.addr		= 0x48,
+		.flags		= I2C_CLIENT_WAKE,
+	},
+	{
+		I2C_BOARD_INFO("twl6040", 0x4b),
+	},
+};
+
 void __init omap_pmic_init(int bus, u32 clkrate,
 			   const char *pmic_type, int pmic_irq,
 			   struct twl4030_platform_data *pmic_data)
@@ -49,14 +59,31 @@ void __init omap_pmic_init(int bus, u32 clkrate,
 	omap_register_i2c_bus(bus, clkrate, &pmic_i2c_board_info, 1);
 }
 
+void __init omap4_pmic_init(const char *pmic_type,
+		    struct twl4030_platform_data *pmic_data,
+		    struct twl6040_platform_data *twl6040_data, int twl6040_irq)
+{
+	/* PMIC part*/
+	strncpy(omap4_i2c1_board_info[0].type, pmic_type,
+		sizeof(omap4_i2c1_board_info[0].type));
+	omap4_i2c1_board_info[0].irq = OMAP44XX_IRQ_SYS_1N;
+	omap4_i2c1_board_info[0].platform_data = pmic_data;
+
+	/* TWL6040 audio IC part */
+	omap4_i2c1_board_info[1].irq = twl6040_irq;
+	omap4_i2c1_board_info[1].platform_data = twl6040_data;
+
+	omap_register_i2c_bus(1, 400, omap4_i2c1_board_info, 2);
+
+}
+
 void __init omap_pmic_late_init(void)
 {
 	/* Init the OMAP TWL parameters (if PMIC has been registerd) */
-	if (!pmic_i2c_board_info.irq)
-		return;
-
-	omap3_twl_init();
-	omap4_twl_init();
+	if (pmic_i2c_board_info.irq)
+		omap3_twl_init();
+	if (omap4_i2c1_board_info[0].irq)
+		omap4_twl_init();
 }
 
 #if defined(CONFIG_ARCH_OMAP3)
diff --git a/arch/arm/mach-omap2/twl-common.h b/arch/arm/mach-omap2/twl-common.h
index 275dde8..0962748 100644
--- a/arch/arm/mach-omap2/twl-common.h
+++ b/arch/arm/mach-omap2/twl-common.h
@@ -29,6 +29,7 @@
 
 
 struct twl4030_platform_data;
+struct twl6040_platform_data;
 
 void omap_pmic_init(int bus, u32 clkrate, const char *pmic_type, int pmic_irq,
 		    struct twl4030_platform_data *pmic_data);
@@ -46,12 +47,9 @@ static inline void omap3_pmic_init(const char *pmic_type,
 	omap_pmic_init(1, 2600, pmic_type, INT_34XX_SYS_NIRQ, pmic_data);
 }
 
-static inline void omap4_pmic_init(const char *pmic_type,
-				   struct twl4030_platform_data *pmic_data)
-{
-	/* Phoenix Audio IC needs I2C1 to start with 400 KHz or less */
-	omap_pmic_init(1, 400, pmic_type, OMAP44XX_IRQ_SYS_1N, pmic_data);
-}
+void omap4_pmic_init(const char *pmic_type,
+		    struct twl4030_platform_data *pmic_data,
+		    struct twl6040_platform_data *audio_data, int twl6040_irq);
 
 void omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 			   u32 pdata_flags, u32 regulators_flags);
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7b46781..9450d4c 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -368,8 +368,7 @@ config INPUT_TWL4030_VIBRA
 
 config INPUT_TWL6040_VIBRA
 	tristate "Support for TWL6040 Vibrator"
-	depends on TWL4030_CORE
-	select TWL6040_CORE
+	depends on TWL6040_CORE
 	select INPUT_FF_MEMLESS
 	help
 	  This option enables support for TWL6040 Vibrator Driver.
diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index 45874fe..14e94f5 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -28,7 +28,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
-#include <linux/i2c/twl.h>
+#include <linux/input.h>
 #include <linux/mfd/twl6040.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -257,7 +257,7 @@ static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops, twl6040_vibra_suspend, NULL);
 
 static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 {
-	struct twl4030_vibra_data *pdata = pdev->dev.platform_data;
+	struct twl6040_vibra_data *pdata = pdev->dev.platform_data;
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index f147395..c8410ea 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -251,10 +251,17 @@ config TWL6030_PWM
 	  This is used to control charging LED brightness.
 
 config TWL6040_CORE
-	bool
-	depends on TWL4030_CORE && GENERIC_HARDIRQS
+	bool "Support for TWL6040 audio codec"
+	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
+	select REGMAP_I2C
 	default n
+	help
+	  Say yes here if you want support for Texas Instruments TWL6040 audio
+	  codec.
+	  This driver provides common support for accessing the device,
+	  additional drivers must be enabled in order to use the
+	  functionality of the device (audio, vibra).
 
 config MFD_STMPE
 	bool "Support STMicroelectronics STMPE"
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index b2d8e51..2d6beda 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -30,7 +30,9 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
-#include <linux/i2c/twl.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/err.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 
@@ -39,7 +41,7 @@
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
-	u8 val = 0;
+	unsigned int val;
 
 	mutex_lock(&twl6040->io_mutex);
 	/* Vibra control registers from cache */
@@ -47,7 +49,7 @@ int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 		     reg == TWL6040_REG_VIBCTLR)) {
 		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
 	} else {
-		ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+		ret = regmap_read(twl6040->regmap, reg, &val);
 		if (ret < 0) {
 			mutex_unlock(&twl6040->io_mutex);
 			return ret;
@@ -64,7 +66,7 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 	int ret;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	ret = regmap_write(twl6040->regmap, reg, val);
 	/* Cache the vibra control registers */
 	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
 		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
@@ -77,16 +79,9 @@ EXPORT_SYMBOL(twl6040_reg_write);
 int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
 	int ret;
-	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
-	if (ret)
-		goto out;
-
-	val |= mask;
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
-out:
+	ret = regmap_update_bits(twl6040->regmap, reg, mask, mask);
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
 }
@@ -95,16 +90,9 @@ EXPORT_SYMBOL(twl6040_set_bits);
 int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
 	int ret;
-	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
-	if (ret)
-		goto out;
-
-	val &= ~mask;
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
-out:
+	ret = regmap_update_bits(twl6040->regmap, reg, mask, 0);
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
 }
@@ -494,32 +482,58 @@ static struct resource twl6040_codec_rsrc[] = {
 	},
 };
 
-static int __devinit twl6040_probe(struct platform_device *pdev)
+static bool twl6040_readable_reg(struct device *dev, unsigned int reg)
 {
-	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
+	/* Register 0 is not readable */
+	if (!reg)
+		return false;
+	return true;
+}
+
+static struct regmap_config twl6040_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = TWL6040_REG_STATUS, /* 0x2e */
+
+	.readable_reg = twl6040_readable_reg,
+};
+
+static int __devinit twl6040_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
+{
+	struct twl6040_platform_data *pdata = client->dev.platform_data;
 	struct twl6040 *twl6040;
 	struct mfd_cell *cell = NULL;
 	int ret, children = 0;
 
 	if (!pdata) {
-		dev_err(&pdev->dev, "Platform data is missing\n");
+		dev_err(&client->dev, "Platform data is missing\n");
 		return -EINVAL;
 	}
 
 	/* In order to operate correctly we need valid interrupt config */
-	if (!pdata->naudint_irq || !pdata->irq_base) {
-		dev_err(&pdev->dev, "Invalid IRQ configuration\n");
+	if (!client->irq || !pdata->irq_base) {
+		dev_err(&client->dev, "Invalid IRQ configuration\n");
 		return -EINVAL;
 	}
 
-	twl6040 = kzalloc(sizeof(struct twl6040), GFP_KERNEL);
-	if (!twl6040)
-		return -ENOMEM;
+	twl6040 = devm_kzalloc(&client->dev, sizeof(struct twl6040),
+			       GFP_KERNEL);
+	if (!twl6040) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	twl6040->regmap = regmap_init_i2c(client, &twl6040_regmap_config);
+	if (IS_ERR(twl6040->regmap)) {
+		ret = PTR_ERR(twl6040->regmap);
+		goto err;
+	}
 
-	platform_set_drvdata(pdev, twl6040);
+	i2c_set_clientdata(client, twl6040);
 
-	twl6040->dev = &pdev->dev;
-	twl6040->irq = pdata->naudint_irq;
+	twl6040->dev = &client->dev;
+	twl6040->irq = client->irq;
 	twl6040->irq_base = pdata->irq_base;
 
 	mutex_init(&twl6040->mutex);
@@ -588,12 +602,12 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	}
 
 	if (children) {
-		ret = mfd_add_devices(&pdev->dev, pdev->id, twl6040->cells,
+		ret = mfd_add_devices(&client->dev, -1, twl6040->cells,
 				      children, NULL, 0);
 		if (ret)
 			goto mfd_err;
 	} else {
-		dev_err(&pdev->dev, "No platform data found for children\n");
+		dev_err(&client->dev, "No platform data found for children\n");
 		ret = -ENODEV;
 		goto mfd_err;
 	}
@@ -608,14 +622,15 @@ gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 gpio1_err:
-	platform_set_drvdata(pdev, NULL);
-	kfree(twl6040);
+	i2c_set_clientdata(client, NULL);
+	regmap_exit(twl6040->regmap);
+err:
 	return ret;
 }
 
-static int __devexit twl6040_remove(struct platform_device *pdev)
+static int __devexit twl6040_remove(struct i2c_client *client)
 {
-	struct twl6040 *twl6040 = platform_get_drvdata(pdev);
+	struct twl6040 *twl6040 = i2c_get_clientdata(client);
 
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
@@ -626,23 +641,30 @@ static int __devexit twl6040_remove(struct platform_device *pdev)
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 	twl6040_irq_exit(twl6040);
 
-	mfd_remove_devices(&pdev->dev);
-	platform_set_drvdata(pdev, NULL);
-	kfree(twl6040);
+	mfd_remove_devices(&client->dev);
+	i2c_set_clientdata(client, NULL);
+	regmap_exit(twl6040->regmap);
 
 	return 0;
 }
 
-static struct platform_driver twl6040_driver = {
+static const struct i2c_device_id twl6040_i2c_id[] = {
+	{ "twl6040", 0, },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, twl6040_i2c_id);
+
+static struct i2c_driver twl6040_driver = {
+	.driver = {
+		.name = "twl6040",
+		.owner = THIS_MODULE,
+	},
 	.probe		= twl6040_probe,
 	.remove		= __devexit_p(twl6040_remove),
-	.driver		= {
-		.owner	= THIS_MODULE,
-		.name	= "twl6040",
-	},
+	.id_table	= twl6040_i2c_id,
 };
 
-module_platform_driver(twl6040_driver);
+module_i2c_driver(twl6040_driver);
 
 MODULE_DESCRIPTION("TWL6040 MFD");
 MODULE_AUTHOR("Misael Lopez Cruz <misael.lopez@ti.com>");
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 78d3465..3826a53 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -666,23 +666,11 @@ struct twl4030_codec_data {
 	unsigned int check_defaults:1;
 	unsigned int reset_registers:1;
 	unsigned int hs_extmute:1;
-	u16 hs_left_step;
-	u16 hs_right_step;
-	u16 hf_left_step;
-	u16 hf_right_step;
 	void (*set_hs_extmute)(int mute);
 };
 
 struct twl4030_vibra_data {
 	unsigned int	coexist;
-
-	/* twl6040 */
-	unsigned int vibldrv_res;	/* left driver resistance */
-	unsigned int vibrdrv_res;	/* right driver resistance */
-	unsigned int viblmotor_res;	/* left motor resistance */
-	unsigned int vibrmotor_res;	/* right motor resistance */
-	int vddvibl_uV;			/* VDDVIBL volt, set 0 for fixed reg */
-	int vddvibr_uV;			/* VDDVIBR volt, set 0 for fixed reg */
 };
 
 struct twl4030_audio_data {
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 9bc9ac6..b15b5f0 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -174,8 +174,35 @@
 #define TWL6040_SYSCLK_SEL_LPPLL	0
 #define TWL6040_SYSCLK_SEL_HPPLL	1
 
+struct twl6040_codec_data {
+	u16 hs_left_step;
+	u16 hs_right_step;
+	u16 hf_left_step;
+	u16 hf_right_step;
+};
+
+struct twl6040_vibra_data {
+	unsigned int vibldrv_res;	/* left driver resistance */
+	unsigned int vibrdrv_res;	/* right driver resistance */
+	unsigned int viblmotor_res;	/* left motor resistance */
+	unsigned int vibrmotor_res;	/* right motor resistance */
+	int vddvibl_uV;			/* VDDVIBL volt, set 0 for fixed reg */
+	int vddvibr_uV;			/* VDDVIBR volt, set 0 for fixed reg */
+};
+
+struct twl6040_platform_data {
+	int audpwron_gpio;	/* audio power-on gpio */
+	unsigned int irq_base;
+
+	struct twl6040_codec_data *codec;
+	struct twl6040_vibra_data *vibra;
+};
+
+struct regmap;
+
 struct twl6040 {
 	struct device *dev;
+	struct regmap *regmap;
 	struct mutex mutex;
 	struct mutex io_mutex;
 	struct mutex irq_mutex;
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 6508e8b..59d8efa 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -57,7 +57,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TPA6130A2 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
-	select SND_SOC_TWL6040 if TWL4030_CORE
+	select SND_SOC_TWL6040 if TWL6040_CORE
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
 	select SND_SOC_WL1273 if MFD_WL1273_CORE
@@ -276,7 +276,6 @@ config SND_SOC_TWL4030
 	tristate
 
 config SND_SOC_TWL6040
-	select TWL6040_CORE
 	tristate
 
 config SND_SOC_UDA134X
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 2d8c6b8..dc7509b 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -26,7 +26,6 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/i2c/twl.h>
 #include <linux/mfd/twl6040.h>
 
 #include <sound/core.h>
@@ -1528,7 +1527,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv;
-	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
+	struct twl6040_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct platform_device *pdev = container_of(codec->dev,
 						   struct platform_device, dev);
 	int ret = 0;
diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index 27a3a29..4bb7802 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -103,7 +103,7 @@ config SND_OMAP_SOC_SDP3430
 
 config SND_OMAP_SOC_OMAP_ABE_TWL6040
 	tristate "SoC Audio support for OMAP boards using ABE and twl6040 codec"
-	depends on TWL4030_CORE && SND_OMAP_SOC && ARCH_OMAP4
+	depends on TWL6040_CORE && SND_OMAP_SOC && ARCH_OMAP4
 	select SND_OMAP_SOC_DMIC
 	select SND_OMAP_SOC_MCPDM
 	select SND_SOC_TWL6040
-- 
1.7.8.4

