Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2LLOC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42343 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2LLOCy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:54 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/33] leds-lp55xx: clean up unused data and functions
Thread-Topic: [PATCH 26/33] leds-lp55xx: clean up unused data and functions
Thread-Index: Ac3YcV6Vq82K8JHNSO6zry6+2kJcbw==
Date: Wed, 12 Dec 2012 14:02:50 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABE7@DQHE02.ent.ti.com>
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

 Old data structures and I2C functions are not used any more.
 Each driver uses the lp55xx common data and functions.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |  110 --------------------------------------------
 drivers/leds/leds-lp5523.c |   35 --------------
 2 files changed, 145 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 65eaaeb..2132a49 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -125,25 +125,6 @@
 #define LP5521_RUN_G			0x08
 #define LP5521_RUN_B			0x02
 
-struct lp5521_led {
-	int			id;
-	u8			chan_nr;
-	u8			led_current;
-	u8			max_current;
-	struct led_classdev	cdev;
-	struct work_struct	brightness_work;
-	u8			brightness;
-};
-
-struct lp5521_chip {
-	struct lp5521_platform_data *pdata;
-	struct mutex		lock; /* Serialize control */
-	struct i2c_client	*client;
-	struct lp5521_led	leds[LP5521_MAX_LEDS];
-	u8			num_channels;
-	u8			num_leds;
-};
-
 static inline void lp5521_wait_opmode_done(void)
 {
 	/* operation mode change needs to be longer than 153 us */
@@ -163,23 +144,6 @@ static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
-static inline int lp5521_write(struct i2c_client *client, u8 reg, u8 value)
-{
-	return i2c_smbus_write_byte_data(client, reg, value);
-}
-
-static int lp5521_read(struct i2c_client *client, u8 reg, u8 *buf)
-{
-	s32 ret;
-
-	ret = i2c_smbus_read_byte_data(client, reg);
-	if (ret < 0)
-		return ret;
-
-	*buf = ret;
-	return 0;
-}
-
 static void lp5521_load_engine(struct lp55xx_chip *chip)
 {
 	enum lp55xx_engine_index idx = chip->engine_idx;
@@ -419,80 +383,6 @@ static ssize_t lp5521_selftest(struct device *dev,
 	return sprintf(buf, "%s\n", ret ? "FAIL" : "OK");
 }
 
-static void lp5521_clear_program_memory(struct i2c_client *cl)
-{
-	int i;
-	u8 rgb_mem[] = {
-		LP5521_REG_R_PROG_MEM,
-		LP5521_REG_G_PROG_MEM,
-		LP5521_REG_B_PROG_MEM,
-	};
-
-	for (i = 0; i < ARRAY_SIZE(rgb_mem); i++) {
-		lp5521_write(cl, rgb_mem[i], 0);
-		lp5521_write(cl, rgb_mem[i] + 1, 0);
-	}
-}
-
-static void lp5521_write_program_memory(struct i2c_client *cl,
-				u8 base, u8 *rgb, int size)
-{
-	int i;
-
-	if (!rgb || size <= 0)
-		return;
-
-	for (i = 0; i < size; i++)
-		lp5521_write(cl, base + i, *(rgb + i));
-
-	lp5521_write(cl, base + i, 0);
-	lp5521_write(cl, base + i + 1, 0);
-}
-
-static inline struct lp5521_led_pattern *lp5521_get_pattern
-					(struct lp5521_chip *chip, u8 offset)
-{
-	struct lp5521_led_pattern *ptn;
-	ptn = chip->pdata->patterns + (offset - 1);
-	return ptn;
-}
-
-static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
-{
-	struct lp5521_led_pattern *ptn;
-	struct i2c_client *cl = chip->client;
-	int num_patterns = chip->pdata->num_patterns;
-
-	if (mode > num_patterns || !(chip->pdata->patterns))
-		return;
-
-	if (mode == PATTERN_OFF) {
-		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
-		usleep_range(1000, 2000);
-		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
-	} else {
-		ptn = lp5521_get_pattern(chip, mode);
-		if (!ptn)
-			return;
-
-		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
-		usleep_range(1000, 2000);
-
-		lp5521_clear_program_memory(cl);
-
-		lp5521_write_program_memory(cl, LP5521_REG_R_PROG_MEM,
-					ptn->r, ptn->size_r);
-		lp5521_write_program_memory(cl, LP5521_REG_G_PROG_MEM,
-					ptn->g, ptn->size_g);
-		lp5521_write_program_memory(cl, LP5521_REG_B_PROG_MEM,
-					ptn->b, ptn->size_b);
-
-		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_RUN);
-		usleep_range(1000, 2000);
-		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_RUN_PROGRAM);
-	}
-}
-
 /* device attributes */
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 63dec47..8affd73 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -142,25 +142,6 @@ enum lp5523_chip_id {
 	LP55231,
 };
 
-struct lp5523_led {
-	int			id;
-	u8			chan_nr;
-	u8			led_current;
-	u8			max_current;
-	struct led_classdev     cdev;
-	struct work_struct	brightness_work;
-	u8			brightness;
-};
-
-struct lp5523_chip {
-	struct mutex		lock; /* Serialize control */
-	struct i2c_client	*client;
-	struct lp5523_led	leds[LP5523_MAX_LEDS];
-	struct lp5523_platform_data *pdata;
-	u8			num_channels;
-	u8			num_leds;
-};
-
 static inline void lp5523_wait_opmode_done(void)
 {
 	usleep_range(1000, 2000);
@@ -173,22 +154,6 @@ static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
-static int lp5523_write(struct i2c_client *client, u8 reg, u8 value)
-{
-	return i2c_smbus_write_byte_data(client, reg, value);
-}
-
-static int lp5523_read(struct i2c_client *client, u8 reg, u8 *buf)
-{
-	s32 ret = i2c_smbus_read_byte_data(client, reg);
-
-	if (ret < 0)
-		return ret;
-
-	*buf = ret;
-	return 0;
-}
-
 static int lp5523_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
-- 
1.7.9.5


Best Regards,
Milo


