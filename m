Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2JEIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:16:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55868 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab2JEIQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:16:20 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 12/28] leds-lp5521/5523: add internal engine control
 functions
Thread-Topic: [PATCH 12/28] leds-lp5521/5523: add internal engine control
 functions
Thread-Index: Ac2i0a4qtbEsIwyKSg+vPpWka9WcPw==
Date: Fri, 5 Oct 2012 08:16:12 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176797@DQHE02.ent.ti.com>
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

 The LP55xx common driver has a device attribute for running selected engine.
 Then an application can run the engine via the sysfs.
 Actual operation is accessing the register.
 Therefore, run_engine internal function should be configured in each driver.

 Related definitions and internal static functions are added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   86 +++++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp5523.c |   91 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 45a2d56..38157a0 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -101,6 +101,29 @@
 /* Reset register value */
 #define LP5521_RESET			0xFF
 
+/* Program Memory Operations */
+#define LP5521_MODE_R_M			0x30	/* Operation Mode Register */
+#define LP5521_MODE_G_M			0x0C
+#define LP5521_MODE_B_M			0x03
+#define LP5521_LOAD_R			0x10
+#define LP5521_LOAD_G			0x04
+#define LP5521_LOAD_B			0x01
+
+#define LP5521_R_IS_LOADING(mode)	\
+	((mode & LP5521_MODE_R_M) == LP5521_LOAD_R)
+#define LP5521_G_IS_LOADING(mode)	\
+	((mode & LP5521_MODE_G_M) == LP5521_LOAD_G)
+#define LP5521_B_IS_LOADING(mode)	\
+	((mode & LP5521_MODE_B_M) == LP5521_LOAD_B)
+
+#define LP5521_EXEC_R_M			0x30	/* Enable Register */
+#define LP5521_EXEC_G_M			0x0C
+#define LP5521_EXEC_B_M			0x03
+#define LP5521_EXEC_M			0x3F
+#define LP5521_RUN_R			0x20
+#define LP5521_RUN_G			0x08
+#define LP5521_RUN_B			0x02
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -128,6 +151,12 @@ struct lp5521_chip {
 	u8			num_leds;
 };
 
+static inline void lp5521_wait_opmode_done(void)
+{
+	/* operation mode change needs to be longer than 153 us */
+	usleep_range(200, 300);
+}
+
 static inline void lp5521_wait_enable_done(void)
 {
 	/* it takes more 488 us to update ENABLE register */
@@ -236,6 +265,62 @@ static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
+static void lp5521_stop_engine(struct lp55xx_chip *chip)
+{
+	lp55xx_write(chip, LP5521_REG_OP_MODE, 0);
+	lp5521_wait_opmode_done();
+}
+
+static void lp5521_run_engine(struct lp55xx_chip *chip, bool start)
+{
+	int ret;
+	u8 mode;
+	u8 exec;
+
+	/* stop engine */
+	if (!start) {
+		lp5521_stop_engine(chip);
+		lp55xx_write(chip, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+		lp5521_wait_opmode_done();
+		return;
+	}
+
+	/*
+	 * To run the engine,
+	 * operation mode and enable register should updated at the same time
+	 */
+
+	ret = lp55xx_read(chip, LP5521_REG_OP_MODE, &mode);
+	if (ret)
+		return;
+
+	ret = lp55xx_read(chip, LP5521_REG_ENABLE, &exec);
+	if (ret)
+		return;
+
+	/* change operation mode to RUN only when each engine is loading */
+	if (LP5521_R_IS_LOADING(mode)) {
+		mode = (mode & ~LP5521_MODE_R_M) | LP5521_RUN_R;
+		exec = (exec & ~LP5521_EXEC_R_M) | LP5521_RUN_R;
+	}
+
+	if (LP5521_G_IS_LOADING(mode)) {
+		mode = (mode & ~LP5521_MODE_G_M) | LP5521_RUN_G;
+		exec = (exec & ~LP5521_EXEC_G_M) | LP5521_RUN_G;
+	}
+
+	if (LP5521_B_IS_LOADING(mode)) {
+		mode = (mode & ~LP5521_MODE_B_M) | LP5521_RUN_B;
+		exec = (exec & ~LP5521_EXEC_B_M) | LP5521_RUN_B;
+	}
+
+	lp55xx_write(chip, LP5521_REG_OP_MODE, mode);
+	lp5521_wait_opmode_done();
+
+	lp55xx_update_bits(chip, LP5521_REG_ENABLE, LP5521_EXEC_M, exec);
+	lp5521_wait_enable_done();
+}
+
 static int lp5521_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
@@ -618,6 +703,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.post_init_device   = lp5521_post_init_device,
 	.brightness_work_fn = lp5521_led_brightness_work,
 	.set_led_current    = lp5521_set_led_current,
+	.run_engine         = lp5521_run_engine,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index e262fdc..9aa03d2 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -110,6 +110,29 @@
 #define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
+/* Program Memory Operations */
+#define LP5523_MODE_ENG1_M		0x30	/* Operation Mode Register */
+#define LP5523_MODE_ENG2_M		0x0C
+#define LP5523_MODE_ENG3_M		0x03
+#define LP5523_LOAD_ENG1		0x10
+#define LP5523_LOAD_ENG2		0x04
+#define LP5523_LOAD_ENG3		0x01
+
+#define LP5523_ENG1_IS_LOADING(mode)	\
+	((mode & LP5523_MODE_ENG1_M) == LP5523_LOAD_ENG1)
+#define LP5523_ENG2_IS_LOADING(mode)	\
+	((mode & LP5523_MODE_ENG2_M) == LP5523_LOAD_ENG2)
+#define LP5523_ENG3_IS_LOADING(mode)	\
+	((mode & LP5523_MODE_ENG3_M) == LP5523_LOAD_ENG3)
+
+#define LP5523_EXEC_ENG1_M		0x30	/* Enable Register */
+#define LP5523_EXEC_ENG2_M		0x0C
+#define LP5523_EXEC_ENG3_M		0x03
+#define LP5523_EXEC_M			0x3F
+#define LP5523_RUN_ENG1			0x20
+#define LP5523_RUN_ENG2			0x08
+#define LP5523_RUN_ENG3			0x02
+
 enum lp5523_chip_id {
 	LP5523,
 	LP55231,
@@ -144,6 +167,11 @@ struct lp5523_chip {
 	u8			num_leds;
 };
 
+static inline void lp5523_wait_opmode_done(void)
+{
+	usleep_range(1000, 2000);
+}
+
 static inline struct lp5523_led *cdev_to_led(struct led_classdev *cdev)
 {
 	return container_of(cdev, struct lp5523_led, cdev);
@@ -476,6 +504,68 @@ static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
+static void lp5523_stop_engine(struct lp55xx_chip *chip)
+{
+	lp55xx_write(chip, LP5523_REG_OP_MODE, 0);
+	lp5523_wait_opmode_done();
+}
+
+static void lp5523_turn_off_channels(struct lp55xx_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < LP5523_MAX_LEDS; i++)
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0);
+}
+
+static void lp5523_run_engine(struct lp55xx_chip *chip, bool start)
+{
+	int ret;
+	u8 mode;
+	u8 exec;
+
+	/* stop engine */
+	if (!start) {
+		lp5523_stop_engine(chip);
+		lp5523_turn_off_channels(chip);
+		return;
+	}
+
+	/*
+	 * To run the engine,
+	 * operation mode and enable register should updated at the same time
+	 */
+
+	ret = lp55xx_read(chip, LP5523_REG_OP_MODE, &mode);
+	if (ret)
+		return;
+
+	ret = lp55xx_read(chip, LP5523_REG_ENABLE, &exec);
+	if (ret)
+		return;
+
+	/* change operation mode to RUN only when each engine is loading */
+	if (LP5523_ENG1_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG1_M) | LP5523_RUN_ENG1;
+		exec = (exec & ~LP5523_EXEC_ENG1_M) | LP5523_RUN_ENG1;
+	}
+
+	if (LP5523_ENG2_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG2_M) | LP5523_RUN_ENG2;
+		exec = (exec & ~LP5523_EXEC_ENG2_M) | LP5523_RUN_ENG2;
+	}
+
+	if (LP5523_ENG3_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG3_M) | LP5523_RUN_ENG3;
+		exec = (exec & ~LP5523_EXEC_ENG3_M) | LP5523_RUN_ENG3;
+	}
+
+	lp55xx_write(chip, LP5523_REG_OP_MODE, mode);
+	lp5523_wait_opmode_done();
+
+	lp55xx_update_bits(chip, LP5523_REG_ENABLE, LP5523_EXEC_M, exec);
+}
+
 static int lp5523_do_store_load(struct lp5523_engine *engine,
 				const char *buf, size_t len)
 {
@@ -700,6 +790,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.post_init_device   = lp5523_post_init_device,
 	.brightness_work_fn = lp5523_led_brightness_work,
 	.set_led_current    = lp5523_set_led_current,
+	.run_engine         = lp5523_run_engine,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
-- 
1.7.9.5


Best Regards,
Milo


