Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2JEIUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:20:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46016 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2JEIUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:20:08 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/28] leds-lp5521/5523: use new function for stopping engine
Thread-Topic: [PATCH 16/28] leds-lp5521/5523: use new function for stopping
 engine
Thread-Index: Ac2i0jKTawCWPu0dRaOMXzHPxNgKjw==
Date: Fri, 5 Oct 2012 08:19:54 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767D3@DQHE02.ent.ti.com>
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

 While unloading the driver, running engine should be stopped.

 LP5521
 Use lp5521_stop_engine() rather than old functions.
 Unnecessary functions are removed.

 LP5523
 Reuse lp5523_stop_engine() rather than direct register access code.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   76 +-------------------------------------------
 drivers/leds/leds-lp5523.c |    3 +-
 2 files changed, 2 insertions(+), 77 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 56157e8..a5aae05 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -440,80 +440,6 @@ static ssize_t lp5521_selftest(struct device *dev,
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
 
@@ -614,7 +540,7 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
-	lp5521_run_led_pattern(PATTERN_OFF, old_chip);
+	lp5521_stop_engine(chip);
 	lp5521_unregister_sysfs(client);
 
 	for (i = 0; i < old_chip->num_leds; i++) {
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 52a9d85..c54785c 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -595,8 +595,7 @@ static int lp5523_remove(struct i2c_client *client)
 	struct lp55xx_led *led = i2c_get_clientdata(client);
 	struct lp55xx_chip *chip = led->chip;
 
-	/* Disable engine mode */
-	lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
+	lp5523_stop_engine(chip);
 
 	lp5523_unregister_sysfs(client);
 
-- 
1.7.9.5


Best Regards,
Milo


