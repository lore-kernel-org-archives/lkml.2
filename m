Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2JEIMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:12:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47229 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2JEIM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:12:27 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/28] leds-lp5521/5523: add post_init_device()
Thread-Topic: [PATCH 05/28] leds-lp5521/5523: add post_init_device()
Thread-Index: Ac2i0R8E8fwQ410hQ1S9PwfdtnGP+g==
Date: Fri, 5 Oct 2012 08:12:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417672F@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Device initialization can be divided into two sections.
 One is common initialization code.
 The other is the device specific initialization.

 Common initialization is handled by the lp55xx_init_device().
 Chip specific init code is processed by the lp55xx_post_init_device().
 To configure this feature, the lp55xx_device_config data is used.

 LP5521
 Reading LP5521_REG_R_CURRENT register and lp5521_configure() are
 moved to the lp5521_post_init_device() except the engine initialization code.
 The engine related code is unnecessary here.
 The lp5521_wait_enable_done() is added for better code readability.

 LP5523
 The lp5523_configure() is replaced with lp5523_post_init_device().
 Like LP5521, the checking LED engines is unnecessary during the initialization.
 To clean up the init code, minimum code remains in the post_init_device().

 LP55XX-COMMON
 Chip dependent init code is handled after initializing common data.
 Registered post_init_device() function is called.
 If the init gets failed, the device should be de-initialized.
 To handle this error, the lp55xx_deinit_device() is added.
 For future use, this function is declared as an exported function.

 The Reason of Removing Engine Code during Initialization
 The engines are used in case of running various LED patterns.
 Running LED patterns is not mandatory function.
 Even the engine doesn't work, LED brightness should be controlled.
 And it takes some time to run engines.
 To initialize a device more fast, it's required to remove the engine routine.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |   82 ++++++++++++++-----------------
 drivers/leds/leds-lp5523.c        |   97 +++++--------------------------------
 drivers/leds/leds-lp55xx-common.c |   31 ++++++++++++
 drivers/leds/leds-lp55xx-common.h |    2 +
 4 files changed, 83 insertions(+), 129 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 5beba13..0f2bbd5 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -128,6 +128,12 @@ struct lp5521_chip {
 	u8			num_leds;
 };
 
+static inline void lp5521_wait_enable_done(void)
+{
+	/* it takes more 488 us to update ENABLE register */
+	usleep_range(500, 600);
+}
+
 static inline struct lp5521_led *cdev_to_led(struct led_classdev *cdev)
 {
 	return container_of(cdev, struct lp5521_led, cdev);
@@ -232,43 +238,48 @@ static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
 		    curr);
 }
 
-static void lp5521_init_engine(struct lp5521_chip *chip)
-{
-	int i;
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
-		chip->engines[i].id = i + 1;
-		chip->engines[i].engine_mask = LP5521_ENG_MASK_BASE >> (i * 2);
-		chip->engines[i].prog_page = i;
-	}
-}
-
-static int lp5521_configure(struct i2c_client *client)
+static int lp5521_post_init_device(struct lp55xx_chip *chip)
 {
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int ret;
-	u8 cfg;
+	u8 val;
+
+	/*
+	 * Make sure that the chip is reset by reading back the r channel
+	 * current reg. This is dummy read is required on some platforms -
+	 * otherwise further access to the R G B channels in the
+	 * LP5521_REG_ENABLE register will not have any effect - strange!
+	 */
+	ret = lp55xx_read(chip, LP5521_REG_R_CURRENT, &val);
+	if (ret || val != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&chip->cl->dev, "error in resetting chip\n");
+		return ret;
+	}
 
-	lp5521_init_engine(chip);
+	usleep_range(10000, 20000);
 
 	/* Set all PWMs to direct control mode */
-	ret = lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+	ret = lp55xx_write(chip, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 
-	cfg = chip->pdata->update_config ?
+	val = chip->pdata->update_config ?
 		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
-	ret |= lp5521_write(client, LP5521_REG_CONFIG, cfg);
+
+	ret = lp55xx_write(chip, LP5521_REG_CONFIG, val);
+	if (ret)
+		return ret;
 
 	/* Initialize all channels PWM to zero -> leds off */
-	ret |= lp5521_write(client, LP5521_REG_R_PWM, 0);
-	ret |= lp5521_write(client, LP5521_REG_G_PWM, 0);
-	ret |= lp5521_write(client, LP5521_REG_B_PWM, 0);
+	lp55xx_write(chip, LP5521_REG_R_PWM, 0);
+	lp55xx_write(chip, LP5521_REG_G_PWM, 0);
+	lp55xx_write(chip, LP5521_REG_B_PWM, 0);
 
 	/* Set engines are set to run state when OP_MODE enables engines */
-	ret |= lp5521_write(client, LP5521_REG_ENABLE,
-			LP5521_ENABLE_RUN_PROGRAM);
-	/* enable takes 500us. 1 - 2 ms leaves some margin */
-	usleep_range(1000, 2000);
+	ret = lp55xx_write(chip, LP5521_REG_ENABLE, LP5521_ENABLE_RUN_PROGRAM);
+	if (ret)
+		return ret;
 
-	return ret;
+	lp5521_wait_enable_done();
+
+	return 0;
 }
 
 static int lp5521_run_selftest(struct lp5521_chip *chip, char *buf)
@@ -732,6 +743,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 		.addr = LP5521_REG_ENABLE,
 		.val  = LP5521_ENABLE_DEFAULT,
 	},
+	.post_init_device   = lp5521_post_init_device,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
@@ -740,7 +752,6 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	struct lp5521_chip		*old_chip;
 	struct lp5521_platform_data	*old_pdata;
 	int ret, i, old_led;
-	u8 buf;
 	struct lp55xx_chip *chip;
 	struct lp55xx_led *led;
 	struct lp55xx_platform_data *pdata = client->dev.platform_data;
@@ -771,27 +782,8 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	if (ret)
 		goto err_init;
 
-	/*
-	 * Make sure that the chip is reset by reading back the r channel
-	 * current reg. This is dummy read is required on some platforms -
-	 * otherwise further access to the R G B channels in the
-	 * LP5521_REG_ENABLE register will not have any effect - strange!
-	 */
-	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev, "error in resetting chip\n");
-		goto fail2;
-	}
-	usleep_range(10000, 20000);
-
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
-	ret = lp5521_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto fail1;
-	}
-
 	/* Initialize leds */
 	old_chip->num_channels = old_pdata->num_channels;
 	old_chip->num_leds = 0;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index a602888..c487a91 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -181,76 +181,30 @@ static int lp5523_read(struct i2c_client *client, u8 reg, u8 *buf)
 	return 0;
 }
 
-static int lp5523_configure(struct i2c_client *client)
+static int lp5523_post_init_device(struct lp55xx_chip *chip)
 {
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	int ret = 0;
-	u8 status;
+	int ret;
 
-	/* one pattern per engine setting led mux start and stop addresses */
-	static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
-		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
-		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
-		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
-	};
+	ret = lp55xx_write(chip, LP5523_REG_ENABLE, LP5523_ENABLE);
+	if (ret)
+		return ret;
 
-	ret |= lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
 	/* Chip startup time is 500 us, 1 - 2 ms gives some margin */
 	usleep_range(1000, 2000);
 
-	ret |= lp5523_write(client, LP5523_REG_CONFIG,
+	ret = lp55xx_write(chip, LP5523_REG_CONFIG,
 			    LP5523_AUTO_INC | LP5523_PWR_SAVE |
 			    LP5523_CP_AUTO | LP5523_AUTO_CLK |
 			    LP5523_PWM_PWR_SAVE);
+	if (ret)
+		return ret;
 
 	/* turn on all leds */
-	ret |= lp5523_write(client, LP5523_REG_ENABLE_LEDS_MSB, 0x01);
-	ret |= lp5523_write(client, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
-
-	/* hardcode 32 bytes of memory for each engine from program memory */
-	ret |= lp5523_write(client, LP5523_REG_CH1_PROG_START, 0x00);
-	ret |= lp5523_write(client, LP5523_REG_CH2_PROG_START, 0x10);
-	ret |= lp5523_write(client, LP5523_REG_CH3_PROG_START, 0x20);
-
-	/* write led mux address space for each channel */
-	ret |= lp5523_load_program(&chip->engines[0], pattern[0]);
-	ret |= lp5523_load_program(&chip->engines[1], pattern[1]);
-	ret |= lp5523_load_program(&chip->engines[2], pattern[2]);
-
-	if (ret) {
-		dev_err(&client->dev, "could not load mux programs\n");
-		return -1;
-	}
-
-	/* set all engines exec state and mode to run 00101010 */
-	ret |= lp5523_write(client, LP5523_REG_ENABLE,
-			    (LP5523_CMD_RUN | LP5523_ENABLE));
-
-	ret |= lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_RUN);
-
-	if (ret) {
-		dev_err(&client->dev, "could not start mux programs\n");
-		return -1;
-	}
-
-	/* Let the programs run for couple of ms and check the engine status */
-	usleep_range(3000, 6000);
-	lp5523_read(client, LP5523_REG_STATUS, &status);
-	status &= LP5523_ENG_STATUS_MASK;
-
-	if (status == LP5523_ENG_STATUS_MASK) {
-		dev_dbg(&client->dev, "all engines configured\n");
-	} else {
-		dev_info(&client->dev, "status == %x\n", status);
-		dev_err(&client->dev, "cound not configure LED engine\n");
-		return -1;
-	}
-
-	dev_info(&client->dev, "disabling engines\n");
-
-	ret |= lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
+	ret = lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_MSB, 0x01);
+	if (ret)
+		return ret;
 
-	return ret;
+	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
 }
 
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode)
@@ -808,18 +762,6 @@ static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
 /*--------------------------------------------------------------*/
 /*			Probe, Attach, Remove			*/
 /*--------------------------------------------------------------*/
-static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
-{
-	if (id < 1 || id > LP5523_ENGINES)
-		return -1;
-	engine->id = id;
-	engine->engine_mask = LP5523_ENG_MASK_BASE >> SHIFT_MASK(id);
-	engine->prog_page = id - 1;
-	engine->mux_page = id + 2;
-
-	return 0;
-}
-
 static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 			   int chan, struct lp5523_platform_data *pdata,
 			   const char *chip_name)
@@ -879,6 +821,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 		.addr = LP5523_REG_ENABLE,
 		.val  = LP5523_ENABLE,
 	},
+	.post_init_device   = lp5523_post_init_device,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
@@ -919,20 +862,6 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
-	/* Initialize engines */
-	for (i = 0; i < ARRAY_SIZE(old_chip->engines); i++) {
-		ret = lp5523_init_engine(&old_chip->engines[i], i + 1);
-		if (ret) {
-			dev_err(&client->dev, "error initializing engine\n");
-			goto fail1;
-		}
-	}
-	ret = lp5523_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto fail1;
-	}
-
 	/* Initialize leds */
 	old_chip->num_channels = old_pdata->num_channels;
 	old_chip->num_leds = 0;
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 22a9643..bab96a4 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -51,6 +51,16 @@ static int lp55xx_detect_device(struct lp55xx_chip *chip)
 	return 0;
 }
 
+static int lp55xx_post_init_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_device_config *cfg = chip->cfg;
+
+	if (!cfg->post_init_device)
+		return 0;
+
+	return cfg->post_init_device(chip);
+}
+
 int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(chip->cl, reg, val);
@@ -142,9 +152,30 @@ int lp55xx_init_device(struct lp55xx_chip *chip)
 		goto err;
 	}
 
+	/* chip specific initialization */
+	ret = lp55xx_post_init_device(chip);
+	if (ret) {
+		dev_err(dev, "post init device err: %d\n", ret);
+		goto err_post_init;
+	}
+
 	return 0;
 
+err_post_init:
+	lp55xx_deinit_device(chip);
 err:
 	return ret;
 }
 EXPORT_SYMBOL_GPL(lp55xx_init_device);
+
+void lp55xx_deinit_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata = chip->pdata;
+
+	if (pdata->enable)
+		pdata->enable(0);
+
+	if (pdata->release_resources)
+		pdata->release_resources();
+}
+EXPORT_SYMBOL_GPL(lp55xx_deinit_device);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 0ecc79b..eb5b691 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -121,6 +121,8 @@ extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
 extern struct lp55xx_led *cdev_to_lp55xx_led(struct led_classdev *cdev);
 extern struct lp55xx_led *dev_to_lp55xx_led(struct device *dev);
 
+/* common device init/deinit functions */
 extern int lp55xx_init_device(struct lp55xx_chip *chip);
+extern void lp55xx_deinit_device(struct lp55xx_chip *chip);
 
 #endif /* __LINUX_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


