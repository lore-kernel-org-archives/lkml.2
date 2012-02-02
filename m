Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab2BBMSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 07:18:45 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57166 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905Ab2BBMRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 07:17:18 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dtor@mail.ru>
Cc: Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 2/7] MFD: twl6040: Convert to i2c driver, and separate it from twl core
Date: Thu,  2 Feb 2012 14:16:54 +0200
Message-Id: <1328185019-29575-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

twl6040 is a separate chip, it is not part of the twl6030
PMIC.
Complete the separation of the twl6040 from the twl core.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c    |   12 ++--
 arch/arm/mach-omap2/board-generic.c    |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c |   13 ++--
 arch/arm/mach-omap2/twl-common.c       |   37 ++++++++--
 arch/arm/mach-omap2/twl-common.h       |   10 +--
 drivers/input/misc/Kconfig             |    1 -
 drivers/input/misc/twl6040-vibra.c     |    4 +-
 drivers/mfd/Kconfig                    |    2 +-
 drivers/mfd/twl6040-core.c             |  124 ++++++++++++++++++++++++-------
 include/linux/i2c/twl.h                |   12 ---
 include/linux/mfd/twl6040.h            |   25 +++++++
 sound/soc/codecs/twl6040.c             |    3 +-
 12 files changed, 174 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 7eaeb08..f4ac553 100644
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
@@ -554,7 +555,7 @@ static struct regulator_init_data sdp4430_vusim = {
 	},
 };
 
-static struct twl4030_codec_data twl6040_codec = {
+static struct twl6040_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -562,7 +563,7 @@ static struct twl4030_codec_data twl6040_codec = {
 	.hf_right_step	= 0x1d,
 };
 
-static struct twl4030_vibra_data twl6040_vibra = {
+static struct twl6040_vibra_data twl6040_vibra = {
 	.vibldrv_res = 8,
 	.vibrdrv_res = 3,
 	.viblmotor_res = 10,
@@ -571,16 +572,14 @@ static struct twl4030_vibra_data twl6040_vibra = {
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
@@ -611,7 +610,8 @@ static int __init omap4_i2c_init(void)
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
index d587560..68b9d8a 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -35,7 +35,7 @@ static struct twl4030_platform_data sdp4430_twldata = {
 
 static void __init omap4_i2c_init(void)
 {
-	omap4_pmic_init("twl6030", &sdp4430_twldata);
+	omap4_pmic_init("twl6030", &sdp4430_twldata, NULL, 0);
 }
 #endif
 
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index eada955..da31a72 100644
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
@@ -277,7 +278,7 @@ static int __init omap4_twl6030_hsmmc_init(struct omap2_hsmmc_info *controllers)
 	return 0;
 }
 
-static struct twl4030_codec_data twl6040_codec = {
+static struct twl6040_codec_data twl6040_codec = {
 	/* single-step ramp for headset and handsfree */
 	.hs_left_step	= 0x0f,
 	.hs_right_step	= 0x0f,
@@ -285,17 +286,14 @@ static struct twl4030_codec_data twl6040_codec = {
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
@@ -319,7 +317,8 @@ static int __init omap4_panda_i2c_init(void)
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
index 10b20c6..bc03154 100644
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
 
+void omap4_pmic_init(const char *pmic_type,
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
index 7b46781..6a9ee24 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -368,7 +368,6 @@ config INPUT_TWL4030_VIBRA
 
 config INPUT_TWL6040_VIBRA
 	tristate "Support for TWL6040 Vibrator"
-	depends on TWL4030_CORE
 	select TWL6040_CORE
 	select INPUT_FF_MEMLESS
 	help
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
index cd13e9f..203e9bc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -252,7 +252,7 @@ config TWL6030_PWM
 
 config TWL6040_CORE
 	bool
-	depends on TWL4030_CORE && GENERIC_HARDIRQS
+	depends on I2C && GENERIC_HARDIRQS
 	select MFD_CORE
 	default n
 
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index dda8629..21d6a99 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -30,12 +30,60 @@
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
-#include <linux/i2c/twl.h>
+#include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/twl6040.h>
 
 #define VIBRACTRL_MEMBER(reg) ((reg == TWL6040_REG_VIBCTLL) ? 0 : 1)
 
+static int twl6040_i2c_read(struct i2c_client *i2c, u8 *value, u8 reg)
+{
+	struct i2c_msg msg[2];
+	int ret;
+
+	msg[0].addr = i2c->addr;
+	msg[0].len = 1;
+	msg[0].flags = 0;
+	msg[0].buf = &reg;
+
+	msg[1].addr = i2c->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 1;
+	msg[1].buf = value;
+	ret = i2c_transfer(i2c->adapter, msg, 2);
+
+	if (ret < 0)
+		return ret;
+	if (ret != 2)
+		return -EIO;
+
+	return 0;
+}
+
+static int twl6040_i2c_write(struct i2c_client *i2c, u8 value, u8 reg)
+{
+	struct i2c_msg msg;
+	u8 data[2];
+	int ret;
+
+	data[0] = reg;
+	data[1] = value;
+
+	msg.addr = i2c->addr;
+	msg.len = 2;
+	msg.flags = 0;
+	msg.buf = data;
+
+	ret = i2c_transfer(i2c->adapter, &msg, 1);
+
+	if (ret < 0)
+		return ret;
+	if (ret != 1)
+		return -EIO;
+
+	return 0;
+}
+
 int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 {
 	int ret;
@@ -47,7 +95,7 @@ int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 		     reg == TWL6040_REG_VIBCTLR)) {
 		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
 	} else {
-		ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+		ret = twl6040_i2c_read(twl6040->control_data, &val, reg);
 		if (ret < 0) {
 			mutex_unlock(&twl6040->io_mutex);
 			return ret;
@@ -64,7 +112,7 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 	int ret;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	ret = twl6040_i2c_write(twl6040->control_data, val, reg);
 	/* Cache the vibra control registers */
 	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
 		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
@@ -80,12 +128,12 @@ int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	ret = twl6040_i2c_read(twl6040->control_data, &val, reg);
 	if (ret)
 		goto out;
 
 	val |= mask;
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	ret = twl6040_i2c_write(twl6040->control_data, val, reg);
 out:
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
@@ -98,12 +146,12 @@ int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 	u8 val;
 
 	mutex_lock(&twl6040->io_mutex);
-	ret = twl_i2c_read_u8(TWL_MODULE_AUDIO_VOICE, &val, reg);
+	ret = twl6040_i2c_read(twl6040->control_data, &val, reg);
 	if (ret)
 		goto out;
 
 	val &= ~mask;
-	ret = twl_i2c_write_u8(TWL_MODULE_AUDIO_VOICE, val, reg);
+	ret = twl6040_i2c_write(twl6040->control_data, val, reg);
 out:
 	mutex_unlock(&twl6040->io_mutex);
 	return ret;
@@ -468,21 +516,22 @@ static struct resource twl6040_codec_rsrc[] = {
 	},
 };
 
-static int __devinit twl6040_probe(struct platform_device *pdev)
+static int __devinit twl6040_probe(struct i2c_client *client,
+				     const struct i2c_device_id *id)
 {
-	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
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
 
@@ -490,10 +539,11 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
 	if (!twl6040)
 		return -ENOMEM;
 
-	platform_set_drvdata(pdev, twl6040);
+	i2c_set_clientdata(client, twl6040);
 
-	twl6040->dev = &pdev->dev;
-	twl6040->irq = pdata->naudint_irq;
+	twl6040->dev = &client->dev;
+	twl6040->control_data = client;
+	twl6040->irq = client->irq;
 	twl6040->irq_base = pdata->irq_base;
 
 	mutex_init(&twl6040->mutex);
@@ -562,12 +612,12 @@ static int __devinit twl6040_probe(struct platform_device *pdev)
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
@@ -582,14 +632,14 @@ gpio2_err:
 	if (gpio_is_valid(twl6040->audpwron))
 		gpio_free(twl6040->audpwron);
 gpio1_err:
-	platform_set_drvdata(pdev, NULL);
+	i2c_set_clientdata(client, NULL);
 	kfree(twl6040);
 	return ret;
 }
 
-static int __devexit twl6040_remove(struct platform_device *pdev)
+static int __devexit twl6040_remove(struct i2c_client *client)
 {
-	struct twl6040 *twl6040 = platform_get_drvdata(pdev);
+	struct twl6040 *twl6040 = i2c_get_clientdata(client);
 
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
@@ -600,23 +650,41 @@ static int __devexit twl6040_remove(struct platform_device *pdev)
 	free_irq(twl6040->irq_base + TWL6040_IRQ_READY, twl6040);
 	twl6040_irq_exit(twl6040);
 
-	mfd_remove_devices(&pdev->dev);
-	platform_set_drvdata(pdev, NULL);
+	mfd_remove_devices(&client->dev);
+	i2c_set_clientdata(client, NULL);
 	kfree(twl6040);
 
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
+static int __devinit twl6040_init(void)
+{
+	return i2c_add_driver(&twl6040_driver);
+}
+module_init(twl6040_init);
+
+static void __devexit twl6040_exit(void)
+{
+	i2c_del_driver(&twl6040_driver);
+}
+
+module_exit(twl6040_exit);
 
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
index 2463c261..72f530f 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -174,7 +174,32 @@
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
 struct twl6040 {
+	struct i2c_client *control_data;
 	struct device *dev;
 	struct mutex mutex;
 	struct mutex io_mutex;
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index ece47ed..3694e9f 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -26,7 +26,6 @@
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
-#include <linux/i2c/twl.h>
 #include <linux/mfd/twl6040.h>
 
 #include <sound/core.h>
@@ -1515,7 +1514,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
 	struct twl6040_data *priv;
-	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
+	struct twl6040_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct platform_device *pdev = container_of(codec->dev,
 						   struct platform_device, dev);
 	int ret = 0;
-- 
1.7.8.4

