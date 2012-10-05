Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab2JEIXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:23:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47737 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2JEIX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:23:27 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/28] leds-lp5521/5523: clean up unused code
Thread-Topic: [PATCH 22/28] leds-lp5521/5523: clean up unused code
Thread-Index: Ac2i0qmuJ2HwnCGDSRCC80Hc5euY/g==
Date: Fri, 5 Oct 2012 08:23:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6417682E@DQHE02.ent.ti.com>
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

 Old data structures and I2C functions are not used any more.
 Each driver uses the lp55xx common data and functions.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   61 -------------------------------------------
 drivers/leds/leds-lp5523.c |   62 --------------------------------------------
 2 files changed, 123 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 71e8d31..f810712 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -125,33 +125,6 @@
 #define LP5521_RUN_G			0x08
 #define LP5521_RUN_B			0x02
 
-struct lp5521_engine {
-	int		id;
-	u8		mode;
-	u8		prog_page;
-	u8		engine_mask;
-};
-
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
-	struct lp5521_engine	engines[LP5521_MAX_ENGINES];
-	struct lp5521_led	leds[LP5521_MAX_LEDS];
-	u8			num_channels;
-	u8			num_leds;
-};
-
 static inline void lp5521_wait_opmode_done(void)
 {
 	/* operation mode change needs to be longer than 153 us */
@@ -164,40 +137,6 @@ static inline void lp5521_wait_enable_done(void)
 	usleep_range(500, 600);
 }
 
-static inline struct lp5521_led *cdev_to_led(struct led_classdev *cdev)
-{
-	return container_of(cdev, struct lp5521_led, cdev);
-}
-
-static inline struct lp5521_chip *engine_to_lp5521(struct lp5521_engine *engine)
-{
-	return container_of(engine, struct lp5521_chip,
-			    engines[engine->id - 1]);
-}
-
-static inline struct lp5521_chip *led_to_lp5521(struct lp5521_led *led)
-{
-	return container_of(led, struct lp5521_chip,
-			    leds[led->id]);
-}
-
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
-		return -EIO;
-
-	*buf = ret;
-	return 0;
-}
-
 static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 {
 	led->led_current = led_current;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 9518be4..463ab72 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -144,73 +144,11 @@ enum lp5523_chip_id {
 	LP55231,
 };
 
-struct lp5523_engine {
-	int		id;
-	u8		mode;
-	u8		prog_page;
-	u8		mux_page;
-	u16		led_mux;
-	u8		engine_mask;
-};
-
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
-	struct lp5523_engine	engines[LP5523_ENGINES];
-	struct lp5523_led	leds[LP5523_LEDS];
-	struct lp5523_platform_data *pdata;
-	u8			num_channels;
-	u8			num_leds;
-};
-
 static inline void lp5523_wait_opmode_done(void)
 {
 	usleep_range(1000, 2000);
 }
 
-static inline struct lp5523_led *cdev_to_led(struct led_classdev *cdev)
-{
-	return container_of(cdev, struct lp5523_led, cdev);
-}
-
-static inline struct lp5523_chip *engine_to_lp5523(struct lp5523_engine *engine)
-{
-	return container_of(engine, struct lp5523_chip,
-			    engines[engine->id - 1]);
-}
-
-static inline struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
-{
-	return container_of(led, struct lp5523_chip,
-			    leds[led->id]);
-}
-
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
-		return -EIO;
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


