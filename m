Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab0EZG45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:56:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33565 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934225Ab0EZG4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:56:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] backlight: adp8860: add support for ADP8861 & ADP8863
Date: Wed, 26 May 2010 03:00:59 -0400
Message-Id: <1274857259-18771-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/backlight/Kconfig      |    6 ++--
 drivers/video/backlight/adp8860_bl.c |   58 ++++++++++++++++++++++++----------
 include/linux/i2c/adp8860.h          |   17 ++++++++++
 3 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 7bad1d5..2f21cad 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -277,13 +277,13 @@ config BACKLIGHT_ADP5520
 	  be called adp5520_bl.
 
 config BACKLIGHT_ADP8860
-	tristate "Backlight Driver for ADP8860 using WLED"
+	tristate "Backlight Driver for ADP8860/ADP8861/ADP8863 using WLED"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	select NEW_LEDS
 	select LEDS_CLASS
 	help
-	  If you have a LCD backlight connected to the ADP8860,
-	  say Y here to enable this driver.
+	  If you have a LCD backlight connected to the ADP8860, ADP8861 or
+	  ADP8863 say Y here to enable this driver.
 
 	  To compile this driver as a module, choose M here: the module will
 	  be called adp8860_bl.
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 9ab0af8..ae23cc0 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -62,7 +62,9 @@
 #define ADP8860_PH2LEVH 0x24 /* Second phototransistor ambient light level-high byte register */
 
 #define ADP8860_MANUFID		0x0  /* Analog Devices ADP8860 Manufacturer ID */
-#define ADP8860_DEVICEID	0x7  /* Analog Devices ADP8860 Device ID */
+#define ADP8861_MANUFID		0x4  /* Analog Devices ADP8861 Manufacturer ID */
+#define ADP8863_MANUFID		0x2  /* Analog Devices ADP8863 Manufacturer ID */
+
 #define ADP8860_DEVID(x)	((x) & 0xF)
 #define ADP8860_MANID(x)	((x) >> 4)
 
@@ -70,6 +72,7 @@
 #define INT_CFG			(1 << 6)
 #define NSTBY			(1 << 5)
 #define DIM_EN			(1 << 4)
+#define GDWN_DIS		(1 << 3)
 #define SIS_EN			(1 << 2)
 #define CMP_AUTOEN		(1 << 1)
 #define BLEN			(1 << 0)
@@ -86,6 +89,12 @@
 #define BL_CFGR_VAL(law, blv)	((((blv) & CFGR_BLV_MASK) << CFGR_BLV_SHIFT) | ((0x3 & (law)) << 1))
 #define ALS_CCFG_VAL(filt)	((0x7 & filt) << 5)
 
+enum {
+	adp8860,
+	adp8861,
+	adp8863
+};
+
 struct adp8860_led {
 	struct led_classdev	cdev;
 	struct work_struct	work;
@@ -105,6 +114,8 @@ struct adp8860_bl {
 	int id;
 	int revid;
 	int current_brightness;
+	unsigned en_ambl_sens:1;
+	unsigned gdwn_dis:1;
 };
 
 static int adp8860_read(struct i2c_client *client, int reg, uint8_t *val)
@@ -121,7 +132,6 @@ static int adp8860_read(struct i2c_client *client, int reg, uint8_t *val)
 	return 0;
 }
 
-
 static int adp8860_write(struct i2c_client *client, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(client, reg, val);
@@ -321,7 +331,7 @@ static int adp8860_bl_set(struct backlight_device *bl, int brightness)
 	struct i2c_client *client = data->client;
 	int ret = 0;
 
-	if (data->pdata->en_ambl_sens) {
+	if (data->en_ambl_sens) {
 		if ((brightness > 0) && (brightness < ADP8860_MAX_BRIGHTNESS)) {
 			/* Disable Ambient Light auto adjust */
 			ret |= adp8860_clr_bits(client, ADP8860_MDCR,
@@ -388,7 +398,7 @@ static int adp8860_bl_setup(struct backlight_device *bl)
 	ret |= adp8860_write(client, ADP8860_BLMX1, pdata->l1_daylight_max);
 	ret |= adp8860_write(client, ADP8860_BLDM1, pdata->l1_daylight_dim);
 
-	if (pdata->en_ambl_sens) {
+	if (data->en_ambl_sens) {
 		data->cached_daylight_max = pdata->l1_daylight_max;
 		ret |= adp8860_write(client, ADP8860_BLMX2,
 						pdata->l2_office_max);
@@ -413,7 +423,8 @@ static int adp8860_bl_setup(struct backlight_device *bl)
 	ret |= adp8860_write(client, ADP8860_BLFR, FADE_VAL(pdata->bl_fade_in,
 			pdata->bl_fade_out));
 
-	ret |= adp8860_set_bits(client, ADP8860_MDCR, BLEN | DIM_EN | NSTBY);
+	ret |= adp8860_set_bits(client, ADP8860_MDCR, BLEN | DIM_EN | NSTBY |
+			(data->gdwn_dis ? GDWN_DIS : 0));
 
 	return ret;
 }
@@ -663,19 +674,29 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
 	ret = adp8860_read(client, ADP8860_MFDVID, &reg_val);
 	if (ret < 0)
-		return -EIO;
+		goto out2;
 
-	if (ADP8860_MANID(reg_val) != ADP8860_MANUFID) {
+	switch (ADP8860_MANID(reg_val)) {
+	case ADP8863_MANUFID:
+		data->gdwn_dis = !!pdata->gdwn_dis;
+	case ADP8860_MANUFID:
+		data->en_ambl_sens = !!pdata->en_ambl_sens;
+		break;
+	case ADP8861_MANUFID:
+		data->gdwn_dis = !!pdata->gdwn_dis;
+		break;
+	default:
 		dev_err(&client->dev, "failed to probe\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out2;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (data == NULL)
-		return -ENOMEM;
-
 	/* It's confirmed that the DEVID field is actually a REVID */
 
 	data->revid = ADP8860_DEVID(reg_val);
@@ -699,7 +720,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 
 	data->bl = bl;
 
-	if (pdata->en_ambl_sens)
+	if (data->en_ambl_sens)
 		ret = sysfs_create_group(&bl->dev.kobj,
 			&adp8860_bl_attr_group);
 
@@ -716,7 +737,8 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 
 	backlight_update_status(bl);
 
-	dev_info(&client->dev, "Rev.%d Backlight\n", data->revid);
+	dev_info(&client->dev, "%s Rev.%d Backlight\n",
+		client->name, data->revid);
 
 	if (pdata->num_leds)
 		adp8860_led_probe(client);
@@ -724,7 +746,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 	return 0;
 
 out:
-	if (data->pdata->en_ambl_sens)
+	if (data->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8860_bl_attr_group);
 out1:
@@ -745,7 +767,7 @@ static int __devexit adp8860_remove(struct i2c_client *client)
 	if (data->led)
 		adp8860_led_remove(client);
 
-	if (data->pdata->en_ambl_sens)
+	if (data->en_ambl_sens)
 		sysfs_remove_group(&data->bl->dev.kobj,
 			&adp8860_bl_attr_group);
 
@@ -776,7 +798,9 @@ static int adp8860_i2c_resume(struct i2c_client *client)
 #endif
 
 static const struct i2c_device_id adp8860_id[] = {
-	{ "adp8860", 0 },
+	{ "adp8860", adp8860 },
+	{ "adp8861", adp8861 },
+	{ "adp8863", adp8863 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, adp8860_id);
diff --git a/include/linux/i2c/adp8860.h b/include/linux/i2c/adp8860.h
index 115514b..0b4d398 100644
--- a/include/linux/i2c/adp8860.h
+++ b/include/linux/i2c/adp8860.h
@@ -132,6 +132,23 @@ struct adp8860_backlight_platform_data {
 	u8 led_fade_out;	/* LED Fade-Out Timer */
 	u8 led_fade_law;	/* fade-on/fade-off transfer characteristic */
 	u8 led_on_time;
+
+	/**
+	 * Gain down disable. Setting this option does not allow the
+	 * charge pump to switch to lower gains. NOT AVAILABLE on ADP8860
+	 * 1 = the charge pump doesn't switch down in gain until all LEDs are 0.
+	 *  The charge pump switches up in gain as needed. This feature is
+	 *  useful if the ADP8863 charge pump is used to drive an external load.
+	 *  This feature must be used when utilizing small fly capacitors
+	 *  (0402 or smaller).
+	 * 0 = the charge pump automatically switches up and down in gain.
+	 *  This provides optimal efficiency, but is not suitable for driving
+	 *  loads that are not connected through the ADP8863 diode drivers.
+	 *  Additionally, the charge pump fly capacitors should be low ESR
+	 * and sized 0603 or greater.
+	 */
+
+	u8 gdwn_dis;
 };
 
 #endif /* __LINUX_I2C_ADP8860_H */
-- 
1.7.1

