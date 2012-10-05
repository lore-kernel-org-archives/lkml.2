Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2JEIRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:17:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57976 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab2JEIRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:17:36 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 13/28] leds-lp5521/5523: add firmware callback functions
Thread-Topic: [PATCH 13/28] leds-lp5521/5523: add firmware callback functions
Thread-Index: Ac2i0diGAkt4Lm94TVmgUH4Ls48Mgg==
Date: Fri, 5 Oct 2012 08:17:23 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767A6@DQHE02.ent.ti.com>
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

 The LP55xx common driver supports general firmware interface
 for running LED patterns.

 The callback function is invoked after loading the firmware is done.
 Actual operation is processed in this function.
 Chip specific commands for loading and updating program memory.
 Therefore, 'firmware_cb' function should be configured in each driver.

 Related functions and definitions are added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   95 +++++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp5523.c |  102 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 197 insertions(+)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 38157a0..ae0a068 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -35,6 +35,7 @@
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
@@ -265,6 +266,26 @@ static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
+static void lp5521_load_engine(struct lp55xx_chip *chip)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5521_MODE_R_M,
+		[LP55XX_ENGINE_2] = LP5521_MODE_G_M,
+		[LP55XX_ENGINE_3] = LP5521_MODE_B_M,
+	};
+
+	u8 val[] = {
+		[LP55XX_ENGINE_1] = LP5521_LOAD_R,
+		[LP55XX_ENGINE_2] = LP5521_LOAD_G,
+		[LP55XX_ENGINE_3] = LP5521_LOAD_B,
+	};
+
+	lp55xx_update_bits(chip, LP5521_REG_OP_MODE, mask[idx], val[idx]);
+
+	lp5521_wait_opmode_done();
+}
+
 static void lp5521_stop_engine(struct lp55xx_chip *chip)
 {
 	lp55xx_write(chip, LP5521_REG_OP_MODE, 0);
@@ -321,6 +342,79 @@ static void lp5521_run_engine(struct lp55xx_chip *chip, bool start)
 	lp5521_wait_enable_done();
 }
 
+static int lp5521_update_program_memory(struct lp55xx_chip *chip,
+					const u8 *data, size_t size)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 pattern[LP5521_PROGRAM_LENGTH] = {0};
+	u8 addr[] = {
+		[LP55XX_ENGINE_1] = LP5521_REG_R_PROG_MEM,
+		[LP55XX_ENGINE_2] = LP5521_REG_G_PROG_MEM,
+		[LP55XX_ENGINE_3] = LP5521_REG_B_PROG_MEM,
+	};
+	unsigned cmd;
+	char c[3];
+	int program_size;
+	int nrchars;
+	int offset = 0;
+	int ret;
+	int i;
+
+	/* clear program memory before updating */
+	for (i = 0; i < LP5521_PROGRAM_LENGTH; i++)
+		lp55xx_write(chip, addr[idx] + i, 0);
+
+	i = 0;
+	while ((offset < size - 1) && (i < LP5521_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
+		if (ret != 1)
+			goto err;
+
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto err;
+
+		pattern[i] = (u8)cmd;
+		offset += nrchars;
+		i++;
+	}
+
+	/* Each instruction is 16bit long. Check that length is even */
+	if (i % 2)
+		goto err;
+
+	program_size = i;
+	for (i = 0; i < program_size; i++)
+		lp55xx_write(chip, addr[idx] + i, pattern[i]);
+
+	return 0;
+
+err:
+	dev_err(&chip->cl->dev, "wrong pattern format\n");
+	return -EINVAL;
+}
+
+static void lp5521_firmware_loaded(struct lp55xx_chip *chip)
+{
+	const struct firmware *fw = chip->fw;
+
+	if (fw->size > LP5521_PROGRAM_LENGTH) {
+		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+			fw->size);
+		return;
+	}
+
+	/*
+	 * Program momery sequence
+	 *  1) set engine mode to "LOAD"
+	 *  2) write firmware data into program memory
+	 */
+
+	lp5521_load_engine(chip);
+	lp5521_update_program_memory(chip, fw->data, fw->size);
+}
+
 static int lp5521_post_init_device(struct lp55xx_chip *chip)
 {
 	int ret;
@@ -704,6 +798,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.brightness_work_fn = lp5521_led_brightness_work,
 	.set_led_current    = lp5521_set_led_current,
 	.run_engine         = lp5521_run_engine,
+	.firmware_cb        = lp5521_firmware_loaded,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 9aa03d2..2cb0c1a 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -35,6 +35,7 @@
 #include <linux/platform_data/leds-lp55xx.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
+#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
@@ -110,6 +111,11 @@
 #define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
+/* Memory Page Selection */
+#define LP5523_PAGE_ENG1		0
+#define LP5523_PAGE_ENG2		1
+#define LP5523_PAGE_ENG3		2
+
 /* Program Memory Operations */
 #define LP5523_MODE_ENG1_M		0x30	/* Operation Mode Register */
 #define LP5523_MODE_ENG2_M		0x0C
@@ -504,6 +510,34 @@ static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
 }
 
+static void lp5523_load_engine(struct lp55xx_chip *chip)
+{
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5523_MODE_ENG1_M,
+		[LP55XX_ENGINE_2] = LP5523_MODE_ENG2_M,
+		[LP55XX_ENGINE_3] = LP5523_MODE_ENG3_M,
+	};
+
+	u8 val[] = {
+		[LP55XX_ENGINE_1] = LP5523_LOAD_ENG1,
+		[LP55XX_ENGINE_2] = LP5523_LOAD_ENG2,
+		[LP55XX_ENGINE_3] = LP5523_LOAD_ENG3,
+	};
+
+	u8 page_sel[] = {
+		[LP55XX_ENGINE_1] = LP5523_PAGE_ENG1,
+		[LP55XX_ENGINE_2] = LP5523_PAGE_ENG2,
+		[LP55XX_ENGINE_3] = LP5523_PAGE_ENG3,
+	};
+
+	lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], val[idx]);
+
+	lp5523_wait_opmode_done();
+
+	lp55xx_write(chip, LP5523_REG_PROG_PAGE_SEL, page_sel[idx]);
+}
+
 static void lp5523_stop_engine(struct lp55xx_chip *chip)
 {
 	lp55xx_write(chip, LP5523_REG_OP_MODE, 0);
@@ -566,6 +600,73 @@ static void lp5523_run_engine(struct lp55xx_chip *chip, bool start)
 	lp55xx_update_bits(chip, LP5523_REG_ENABLE, LP5523_EXEC_M, exec);
 }
 
+static int lp5523_update_program_memory(struct lp55xx_chip *chip,
+					const u8 *data, size_t size)
+{
+	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
+	unsigned cmd;
+	char c[3];
+	int update_size;
+	int nrchars;
+	int offset = 0;
+	int ret;
+	int i;
+
+	/* clear program memory before updating */
+	for (i = 0; i < LP5523_PROGRAM_LENGTH; i++)
+		lp55xx_write(chip, LP5523_REG_PROG_MEM + i, 0);
+
+	i = 0;
+	while ((offset < size - 1) && (i < LP5523_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
+		if (ret != 1)
+			goto err;
+
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto err;
+
+		pattern[i] = (u8)cmd;
+		offset += nrchars;
+		i++;
+	}
+
+	/* Each instruction is 16bit long. Check that length is even */
+	if (i % 2)
+		goto err;
+
+	update_size = i;
+	for (i = 0; i < update_size; i++)
+		lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
+
+	return 0;
+
+err:
+	dev_err(&chip->cl->dev, "wrong pattern format\n");
+	return -EINVAL;
+}
+
+static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
+{
+	const struct firmware *fw = chip->fw;
+
+	if (fw->size > LP5523_PROGRAM_LENGTH) {
+		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+			fw->size);
+		return;
+	}
+
+	/*
+	 * Program momery sequence
+	 *  1) set engine mode to "LOAD"
+	 *  2) write firmware data into program memory
+	 */
+
+	lp5523_load_engine(chip);
+	lp5523_update_program_memory(chip, fw->data, fw->size);
+}
+
 static int lp5523_do_store_load(struct lp5523_engine *engine,
 				const char *buf, size_t len)
 {
@@ -791,6 +892,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.brightness_work_fn = lp5523_led_brightness_work,
 	.set_led_current    = lp5523_set_led_current,
 	.run_engine         = lp5523_run_engine,
+	.firmware_cb        = lp5523_firmware_loaded,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
-- 
1.7.9.5


Best Regards,
Milo


