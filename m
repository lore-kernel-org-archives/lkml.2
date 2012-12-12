Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2LLOBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47806 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab2LLOBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:01:25 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/33] leds-lp55xx: use lp55xx common init function in
 _probe()
Thread-Topic: [PATCH 10/33] leds-lp55xx: use lp55xx common init function in
 _probe()
Thread-Index: Ac3YcSlo3bR2DZN9S6OV8fM+d6bpZA==
Date: Wed, 12 Dec 2012 14:01:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB2D@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
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

 LP5521 and LP5523 driver have separate device init function, but
 they can be merged into one common init function.

 Driver specific functions are replaced with consolidated functions.

  lp5521/lp5523_init_device()   => lp55xx_init_device()
  lp5521/lp5523_reset_device()  => lp55xx_reset_device()
  lp5521/lp5523_detect_device() => lp55xx_detect_device()
  lp5521/lp5523_configure()     => lp55xx_post_init_device()

 Reset, detection and chip configuration depend the device.
 For the device specific fucntions, 'lp55xx_device_config' is configured
 in each driver.

 Unnecessary code are removed.
 a) Engine initialization in lp5521_init_engine() and lp5523_init_engine()
   With reset command, internal LED engines are initialized automatically.
   Therefore this function is duplicated, unnecessary.

 b) Engine verification in lp5523_configure()
   To check whether internal engine works or not, many lines of code are executed.
   However, this job is unnecessary during the chip initialization because
   the engine usage is not mandatory but optional function.
   LED engines are enabled when specific LED pattern is loaded.
   Therefore, this verification code is removed.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c        |  175 ++++++++++++-------------------------
 drivers/leds/leds-lp5523.c        |  159 +++++----------------------------
 drivers/leds/leds-lp55xx-common.c |  107 +++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |   29 ++++++
 4 files changed, 214 insertions(+), 256 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index ef713ab..b07784c 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -98,6 +98,9 @@
 /* Pattern Mode */
 #define PATTERN_OFF	0
 
+/* Reset register value */
+#define LP5521_RESET			0xFF
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -125,6 +128,12 @@ struct lp5521_chip {
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
@@ -229,43 +238,48 @@ static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
 		    curr);
 }
 
-static void lp5521_init_engine(struct lp5521_chip *chip)
+static int lp5521_post_init_device(struct lp55xx_chip *chip)
 {
-	int i;
-	for (i = 0; i < ARRAY_SIZE(chip->engines); i++) {
-		chip->engines[i].id = i + 1;
-		chip->engines[i].engine_mask = LP5521_ENG_MASK_BASE >> (i * 2);
-		chip->engines[i].prog_page = i;
-	}
-}
-
-static int lp5521_configure(struct i2c_client *client)
-{
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
@@ -306,26 +320,6 @@ static void lp5521_led_brightness_work(struct work_struct *work)
 	mutex_unlock(&chip->lock);
 }
 
-/* Detect the chip by setting its ENABLE register and reading it back. */
-static int lp5521_detect(struct i2c_client *client)
-{
-	int ret;
-	u8 buf;
-
-	ret = lp5521_write(client, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
-	if (ret)
-		return ret;
-	/* enable takes 500us. 1 - 2 ms leaves some margin */
-	usleep_range(1000, 2000);
-	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
-	if (ret)
-		return ret;
-	if (buf != LP5521_ENABLE_DEFAULT)
-		return -ENODEV;
-
-	return 0;
-}
-
 /* Set engine mode and create appropriate sysfs attributes, if required. */
 static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
 {
@@ -690,81 +684,6 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 				&lp5521_led_attribute_group);
 }
 
-static void lp5521_reset_device(struct lp5521_chip *chip)
-{
-	struct i2c_client *client = chip->client;
-
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
-}
-
-static void lp5521_deinit_device(struct lp5521_chip *chip);
-static int lp5521_init_device(struct lp5521_chip *chip)
-{
-	struct lp5521_platform_data *pdata = chip->pdata;
-	struct i2c_client *client = chip->client;
-	int ret;
-	u8 buf;
-
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (pdata->enable) {
-		pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5521_reset_device(chip);
-
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-
-	/*
-	 * Make sure that the chip is reset by reading back the r channel
-	 * current reg. This is dummy read is required on some platforms -
-	 * otherwise further access to the R G B channels in the
-	 * LP5521_REG_ENABLE register will not have any effect - strange!
-	 */
-	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (ret) {
-		dev_err(&client->dev, "error in resetting chip\n");
-		return ret;
-	}
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev,
-			"unexpected data in register (expected 0x%x got 0x%x)\n",
-			LP5521_REG_R_CURR_DEFAULT, buf);
-		ret = -EINVAL;
-		return ret;
-	}
-	usleep_range(10000, 20000);
-
-	ret = lp5521_detect(client);
-	if (ret) {
-		dev_err(&client->dev, "Chip not found\n");
-		goto err;
-	}
-
-	ret = lp5521_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto err_config;
-	}
-
-	return 0;
-
-err_config:
-	lp5521_deinit_device(chip);
-err:
-	return ret;
-}
-
 static void lp5521_deinit_device(struct lp5521_chip *chip)
 {
 	struct lp5521_platform_data *pdata = chip->pdata;
@@ -872,6 +791,19 @@ static void lp5521_unregister_leds(struct lp5521_chip *chip)
 	}
 }
 
+/* Chip specific configurations */
+static struct lp55xx_device_config lp5521_cfg = {
+	.reset = {
+		.addr = LP5521_REG_RESET,
+		.val  = LP5521_RESET,
+	},
+	.enable = {
+		.addr = LP5521_REG_ENABLE,
+		.val  = LP5521_ENABLE_DEFAULT,
+	},
+	.post_init_device   = lp5521_post_init_device,
+};
+
 static int __devinit lp5521_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -897,12 +829,13 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	chip->cl = client;
 	chip->pdata = pdata;
+	chip->cfg = &lp5521_cfg;
 
 	mutex_init(&chip->lock);
 
 	i2c_set_clientdata(client, led);
 
-	ret = lp5521_init_device(old_chip);
+	ret = lp55xx_init_device(chip);
 	if (ret)
 		goto err_init;
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index aa66a3b..63e74d2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -87,6 +87,7 @@
 #define LP5523_AUTO_CLK			0x02
 #define LP5523_EN_LEDTEST		0x80
 #define LP5523_LEDTEST_DONE		0x80
+#define LP5523_RESET			0xFF
 
 #define LP5523_DEFAULT_CURRENT		50 /* microAmps */
 #define LP5523_PROGRAM_LENGTH		32 /* in bytes */
@@ -180,96 +181,30 @@ static int lp5523_read(struct i2c_client *client, u8 reg, u8 *buf)
 	return 0;
 }
 
-static int lp5523_detect(struct i2c_client *client)
+static int lp5523_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
-	u8 buf;
 
-	ret = lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
+	ret = lp55xx_write(chip, LP5523_REG_ENABLE, LP5523_ENABLE);
 	if (ret)
 		return ret;
-	ret = lp5523_read(client, LP5523_REG_ENABLE, &buf);
-	if (ret)
-		return ret;
-	if (buf == 0x40)
-		return 0;
-	else
-		return -ENODEV;
-}
 
-static int lp5523_configure(struct i2c_client *client)
-{
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	int ret = 0;
-	u8 status;
-
-	/* one pattern per engine setting led mux start and stop addresses */
-	static const u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
-		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
-		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
-		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
-	};
-
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
-	ret = lp5523_read(client, LP5523_REG_STATUS, &status);
-	if (ret < 0)
+	ret = lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_MSB, 0x01);
+	if (ret)
 		return ret;
 
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
-
-	return ret;
+	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
 }
 
 static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode)
@@ -949,57 +884,6 @@ static void lp5523_unregister_leds(struct lp5523_chip *chip)
 	}
 }
 
-static void lp5523_reset_device(struct lp5523_chip *chip)
-{
-	struct i2c_client *client = chip->client;
-
-	lp5523_write(client, LP5523_REG_RESET, 0xff);
-}
-
-static void lp5523_deinit_device(struct lp5523_chip *chip);
-static int lp5523_init_device(struct lp5523_chip *chip)
-{
-	struct lp5523_platform_data *pdata = chip->pdata;
-	struct i2c_client *client = chip->client;
-	int ret;
-
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (pdata->enable) {
-		pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5523_reset_device(chip);
-
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-	ret = lp5523_detect(client);
-	if (ret)
-		goto err;
-
-	ret = lp5523_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto err_config;
-	}
-
-	return 0;
-
-err_config:
-	lp5523_deinit_device(chip);
-err:
-	return ret;
-}
-
 static void lp5523_deinit_device(struct lp5523_chip *chip)
 {
 	struct lp5523_platform_data *pdata = chip->pdata;
@@ -1010,6 +894,19 @@ static void lp5523_deinit_device(struct lp5523_chip *chip)
 		pdata->release_resources();
 }
 
+/* Chip specific configurations */
+static struct lp55xx_device_config lp5523_cfg = {
+	.reset = {
+		.addr = LP5523_REG_RESET,
+		.val  = LP5523_RESET,
+	},
+	.enable = {
+		.addr = LP5523_REG_ENABLE,
+		.val  = LP5523_ENABLE,
+	},
+	.post_init_device   = lp5523_post_init_device,
+};
+
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -1035,26 +932,18 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	chip->cl = client;
 	chip->pdata = pdata;
+	chip->cfg = &lp5523_cfg;
 
 	mutex_init(&chip->lock);
 
 	i2c_set_clientdata(client, led);
 
-	ret = lp5523_init_device(old_chip);
+	ret = lp55xx_init_device(chip);
 	if (ret)
 		goto err_init;
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
-	/* Initialize engines */
-	for (i = 0; i < ARRAY_SIZE(old_chip->engines); i++) {
-		ret = lp5523_init_engine(&old_chip->engines[i], i + 1);
-		if (ret) {
-			dev_err(&client->dev, "error initializing engine\n");
-			goto fail1;
-		}
-	}
-
 	ret = lp5523_register_leds(old_chip, id->name);
 	if (ret)
 		goto fail2;
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 4dc4dc6..bf21765 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -12,6 +12,7 @@
  * Derived from leds-lp5521.c, leds-lp5523.c
  */
 
+#include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
 #include <linux/module.h>
@@ -19,6 +20,49 @@
 
 #include "leds-lp55xx-common.h"
 
+static void lp55xx_reset_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_device_config *cfg = chip->cfg;
+	u8 addr = cfg->reset.addr;
+	u8 val  = cfg->reset.val;
+
+	/* no error checking here because no ACK from the device after reset */
+	lp55xx_write(chip, addr, val);
+}
+
+static int lp55xx_detect_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_device_config *cfg = chip->cfg;
+	u8 addr = cfg->enable.addr;
+	u8 val  = cfg->enable.val;
+	int ret;
+
+	ret = lp55xx_write(chip, addr, val);
+	if (ret)
+		return ret;
+
+	usleep_range(1000, 2000);
+
+	ret = lp55xx_read(chip, addr, &val);
+	if (ret)
+		return ret;
+
+	if (val != cfg->enable.val)
+		return -ENODEV;
+
+	return 0;
+}
+
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
@@ -53,3 +97,66 @@ int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg, u8 mask, u8 val)
 	return lp55xx_write(chip, reg, tmp);
 }
 EXPORT_SYMBOL_GPL(lp55xx_update_bits);
+
+int lp55xx_init_device(struct lp55xx_chip *chip)
+{
+	struct lp55xx_platform_data *pdata;
+	struct lp55xx_device_config *cfg;
+	struct device *dev = &chip->cl->dev;
+	int ret;
+
+	WARN_ON(!chip);
+
+	pdata = chip->pdata;
+	cfg = chip->cfg;
+
+	if (!pdata || !cfg)
+		return -EINVAL;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0) {
+			dev_err(dev, "setup resoure err: %d\n", ret);
+			goto err;
+		}
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
+		pdata->enable(1);
+		usleep_range(1000, 2000); /* 500us abs min. */
+	}
+
+	lp55xx_reset_device(chip);
+
+	/*
+	 * Exact value is not available. 10 - 20ms
+	 * appears to be enough for reset.
+	 */
+	usleep_range(10000, 20000);
+
+	ret = lp55xx_detect_device(chip);
+	if (ret) {
+		dev_err(dev, "device detection err: %d\n", ret);
+		goto err;
+	}
+
+	/* chip specific initialization */
+	ret = lp55xx_post_init_device(chip);
+	if (ret) {
+		dev_err(dev, "post init device err: %d\n", ret);
+		goto err_post_init;
+	}
+
+	return 0;
+
+err_post_init:
+	if (pdata->enable)
+		pdata->enable(0);
+	if (pdata->release_resources)
+		pdata->release_resources();
+err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp55xx_init_device);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 369cb9c..ffedc77 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -19,17 +19,43 @@ struct lp55xx_led;
 struct lp55xx_chip;
 
 /*
+ * struct lp55xx_reg
+ * @addr : Register address
+ * @val  : Register value
+ */
+struct lp55xx_reg {
+	u8 addr;
+	u8 val;
+};
+
+/*
+ * struct lp55xx_device_config
+ * @reset              : Chip specific reset command
+ * @enable             : Chip specific enable command
+ * @post_init_device   : Chip specific initialization code
+ */
+struct lp55xx_device_config {
+	const struct lp55xx_reg reset;
+	const struct lp55xx_reg enable;
+
+	/* define if the device has specific initialization process */
+	int (*post_init_device) (struct lp55xx_chip *chip);
+};
+
+/*
  * struct lp55xx_chip
  * @cl         : I2C communication for access registers
  * @pdata      : Platform specific data
  * @lock       : Lock for user-space interface
  * @num_leds   : Number of registered LEDs
+ * @cfg        : Device specific configuration data
  */
 struct lp55xx_chip {
 	struct i2c_client *cl;
 	struct lp55xx_platform_data *pdata;
 	struct mutex lock;	/* lock for user-space interface */
 	int num_leds;
+	struct lp55xx_device_config *cfg;
 };
 
 /*
@@ -58,4 +84,7 @@ extern int lp55xx_read(struct lp55xx_chip *chip, u8 reg, u8 *val);
 extern int lp55xx_update_bits(struct lp55xx_chip *chip, u8 reg,
 			u8 mask, u8 val);
 
+/* common device init functions */
+extern int lp55xx_init_device(struct lp55xx_chip *chip);
+
 #endif /* _LEDS_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


