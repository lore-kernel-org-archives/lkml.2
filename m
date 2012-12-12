Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2LLOC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2LLOCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:23 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 20/33] leds-lp55xx: use generic firmware interface
Thread-Topic: [PATCH 20/33] leds-lp55xx: use generic firmware interface
Thread-Index: Ac3YcUuHPNJ6HaQ2ST+N1ZCNZtflpw==
Date: Wed, 12 Dec 2012 14:02:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABAB@DQHE02.ent.ti.com>
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

 LP55xx common driver provides generic firmware interface
 for running a LED pattern.
 LP5521 and LP5523 have many device attributes for running patterns.
 This patch cleans up those complex code.

 Removed device attributes for LP5521
  engine1_mode
  engine2_mode
  engine3_mode
  engine1_load
  engine2_load
  engine3_load
  led_pattern

 Removed device attributes for LP5523
  engine1_mode
  engine2_mode
  engine3_mode
  engine1_load
  engine2_load
  engine3_load
  engine1_leds
  engine2_leds
  engine3_leds

 All device attributes and functions are replaced with two callback functions,
 'firmware_cb' and 'run_engine'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |  414 ++++++++++++++----------------------
 drivers/leds/leds-lp5523.c |  505 +++++++++++++-------------------------------
 2 files changed, 315 insertions(+), 604 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 0ae0b5f..16bbba3 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -35,6 +35,7 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/platform_data/leds-lp55xx.h>
+#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
@@ -101,12 +102,28 @@
 /* Reset register value */
 #define LP5521_RESET			0xFF
 
-struct lp5521_engine {
-	int		id;
-	u8		mode;
-	u8		prog_page;
-	u8		engine_mask;
-};
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
 
 struct lp5521_led {
 	int			id;
@@ -122,12 +139,17 @@ struct lp5521_chip {
 	struct lp5521_platform_data *pdata;
 	struct mutex		lock; /* Serialize control */
 	struct i2c_client	*client;
-	struct lp5521_engine	engines[LP5521_MAX_ENGINES];
 	struct lp5521_led	leds[LP5521_MAX_LEDS];
 	u8			num_channels;
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
@@ -141,23 +163,6 @@ static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
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
 static inline int lp5521_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -175,65 +180,153 @@ static int lp5521_read(struct i2c_client *client, u8 reg, u8 *buf)
 	return 0;
 }
 
-static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
+static void lp5521_load_engine(struct lp55xx_chip *chip)
 {
-	struct lp5521_chip *chip = engine_to_lp5521(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
-	u8 engine_state;
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5521_MODE_R_M,
+		[LP55XX_ENGINE_2] = LP5521_MODE_G_M,
+		[LP55XX_ENGINE_3] = LP5521_MODE_B_M,
+	};
 
-	/* Only transition between RUN and DIRECT mode are handled here */
-	if (mode == LP5521_CMD_LOAD)
-		return 0;
+	u8 val[] = {
+		[LP55XX_ENGINE_1] = LP5521_LOAD_R,
+		[LP55XX_ENGINE_2] = LP5521_LOAD_G,
+		[LP55XX_ENGINE_3] = LP5521_LOAD_B,
+	};
 
-	if (mode == LP5521_CMD_DISABLED)
-		mode = LP5521_CMD_DIRECT;
+	lp55xx_update_bits(chip, LP5521_REG_OP_MODE, mask[idx], val[idx]);
 
-	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
-	if (ret < 0)
-		return ret;
+	lp5521_wait_opmode_done();
+}
 
-	/* set mode only for this engine */
-	engine_state &= ~(engine->engine_mask);
-	mode &= engine->engine_mask;
-	engine_state |= mode;
-	return lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
+static void lp5521_stop_engine(struct lp55xx_chip *chip)
+{
+	lp55xx_write(chip, LP5521_REG_OP_MODE, 0);
+	lp5521_wait_opmode_done();
 }
 
-static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
+static void lp5521_run_engine(struct lp55xx_chip *chip, bool start)
 {
-	struct lp5521_chip *chip = engine_to_lp5521(eng);
-	struct i2c_client *client = chip->client;
 	int ret;
-	int addr;
 	u8 mode;
+	u8 exec;
 
-	/* move current engine to direct mode and remember the state */
-	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
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
 	if (ret)
-		return ret;
+		return;
 
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-	ret = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret = lp55xx_read(chip, LP5521_REG_ENABLE, &exec);
 	if (ret)
-		return ret;
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
 
-	/* For loading, all the engines to load mode */
-	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-
-	addr = LP5521_PROG_MEM_BASE + eng->prog_page * LP5521_PROG_MEM_SIZE;
-	i2c_smbus_write_i2c_block_data(client,
-				addr,
-				LP5521_PROG_MEM_SIZE,
-				pattern);
-
-	return lp5521_write(client, LP5521_REG_OP_MODE, mode);
+	/*
+	 * Program momery sequence
+	 *  1) set engine mode to "LOAD"
+	 *  2) write firmware data into program memory
+	 */
+
+	lp5521_load_engine(chip);
+	lp5521_update_program_memory(chip, fw->data, fw->size);
 }
 
 static int lp5521_post_init_device(struct lp55xx_chip *chip)
@@ -308,155 +401,6 @@ static void lp5521_led_brightness_work(struct work_struct *work)
 	mutex_unlock(&chip->lock);
 }
 
-/* Set engine mode and create appropriate sysfs attributes, if required. */
-static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
-{
-	int ret = 0;
-
-	/* if in that mode already do nothing, except for run */
-	if (mode == engine->mode && mode != LP5521_CMD_RUN)
-		return 0;
-
-	if (mode == LP5521_CMD_RUN) {
-		ret = lp5521_set_engine_mode(engine, LP5521_CMD_RUN);
-	} else if (mode == LP5521_CMD_LOAD) {
-		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
-		lp5521_set_engine_mode(engine, LP5521_CMD_LOAD);
-	} else if (mode == LP5521_CMD_DISABLED) {
-		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
-	}
-
-	engine->mode = mode;
-
-	return ret;
-}
-
-static int lp5521_do_store_load(struct lp5521_engine *engine,
-				const char *buf, size_t len)
-{
-	struct lp5521_chip *chip = engine_to_lp5521(engine);
-	struct i2c_client *client = chip->client;
-	int  ret, nrchars, offset = 0, i = 0;
-	char c[3];
-	unsigned cmd;
-	u8 pattern[LP5521_PROGRAM_LENGTH] = {0};
-
-	while ((offset < len - 1) && (i < LP5521_PROGRAM_LENGTH)) {
-		/* separate sscanfs because length is working only for %s */
-		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
-		if (ret != 2)
-			goto fail;
-		ret = sscanf(c, "%2x", &cmd);
-		if (ret != 1)
-			goto fail;
-		pattern[i] = (u8)cmd;
-
-		offset += nrchars;
-		i++;
-	}
-
-	/* Each instruction is 16bit long. Check that length is even */
-	if (i % 2)
-		goto fail;
-
-	mutex_lock(&chip->lock);
-	if (engine->mode == LP5521_CMD_LOAD)
-		ret = lp5521_load_program(engine, pattern);
-	else
-		ret = -EINVAL;
-	mutex_unlock(&chip->lock);
-
-	if (ret) {
-		dev_err(&client->dev, "failed loading pattern\n");
-		return ret;
-	}
-
-	return len;
-fail:
-	dev_err(&client->dev, "wrong pattern format\n");
-	return -EINVAL;
-}
-
-static ssize_t store_engine_load(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t len, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
-	return lp5521_do_store_load(&chip->engines[nr - 1], buf, len);
-}
-
-#define store_load(nr)							\
-static ssize_t store_engine##nr##_load(struct device *dev,		\
-				     struct device_attribute *attr,	\
-				     const char *buf, size_t len)	\
-{									\
-	return store_engine_load(dev, attr, buf, len, nr);		\
-}
-store_load(1)
-store_load(2)
-store_load(3)
-
-static ssize_t show_engine_mode(struct device *dev,
-				struct device_attribute *attr,
-				char *buf, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
-	switch (chip->engines[nr - 1].mode) {
-	case LP5521_CMD_RUN:
-		return sprintf(buf, "run\n");
-	case LP5521_CMD_LOAD:
-		return sprintf(buf, "load\n");
-	case LP5521_CMD_DISABLED:
-		return sprintf(buf, "disabled\n");
-	default:
-		return sprintf(buf, "disabled\n");
-	}
-}
-
-#define show_mode(nr)							\
-static ssize_t show_engine##nr##_mode(struct device *dev,		\
-				    struct device_attribute *attr,	\
-				    char *buf)				\
-{									\
-	return show_engine_mode(dev, attr, buf, nr);			\
-}
-show_mode(1)
-show_mode(2)
-show_mode(3)
-
-static ssize_t store_engine_mode(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t len, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5521_chip *chip = i2c_get_clientdata(client);
-	struct lp5521_engine *engine = &chip->engines[nr - 1];
-	mutex_lock(&chip->lock);
-
-	if (!strncmp(buf, "run", 3))
-		lp5521_set_mode(engine, LP5521_CMD_RUN);
-	else if (!strncmp(buf, "load", 4))
-		lp5521_set_mode(engine, LP5521_CMD_LOAD);
-	else if (!strncmp(buf, "disabled", 8))
-		lp5521_set_mode(engine, LP5521_CMD_DISABLED);
-
-	mutex_unlock(&chip->lock);
-	return len;
-}
-
-#define store_mode(nr)							\
-static ssize_t store_engine##nr##_mode(struct device *dev,		\
-				     struct device_attribute *attr,	\
-				     const char *buf, size_t len)	\
-{									\
-	return store_engine_mode(dev, attr, buf, len, nr);		\
-}
-store_mode(1)
-store_mode(2)
-store_mode(3)
-
 static ssize_t lp5521_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
@@ -545,45 +489,11 @@ static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
 	}
 }
 
-static ssize_t store_led_pattern(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t len)
-{
-	struct lp5521_chip *chip = i2c_get_clientdata(to_i2c_client(dev));
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul(buf, 16, &val);
-	if (ret)
-		return ret;
-
-	lp5521_run_led_pattern(val, chip);
-
-	return len;
-}
-
 /* device attributes */
-static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
-		   show_engine1_mode, store_engine1_mode);
-static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUSR,
-		   show_engine2_mode, store_engine2_mode);
-static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUSR,
-		   show_engine3_mode, store_engine3_mode);
-static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
-static DEVICE_ATTR(led_pattern, S_IWUSR, NULL, store_led_pattern);
 
 static struct attribute *lp5521_attributes[] = {
-	&dev_attr_engine1_mode.attr,
-	&dev_attr_engine2_mode.attr,
-	&dev_attr_engine3_mode.attr,
 	&dev_attr_selftest.attr,
-	&dev_attr_engine1_load.attr,
-	&dev_attr_engine2_load.attr,
-	&dev_attr_engine3_load.attr,
-	&dev_attr_led_pattern.attr,
 	NULL
 };
 
@@ -618,6 +528,8 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.post_init_device   = lp5521_post_init_device,
 	.brightness_work_fn = lp5521_led_brightness_work,
 	.set_led_current    = lp5521_set_led_current,
+	.firmware_cb        = lp5521_firmware_loaded,
+	.run_engine         = lp5521_run_engine,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index cb19eb8..92e68e7 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -35,6 +35,7 @@
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/platform_data/leds-lp55xx.h>
+#include <linux/firmware.h>
 
 #include "leds-lp55xx-common.h"
 
@@ -108,20 +109,39 @@
 #define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
 #define SHIFT_MASK(id)			(((id) - 1) * 2)
 
+/* Memory Page Selection */
+#define LP5523_PAGE_ENG1		0
+#define LP5523_PAGE_ENG2		1
+#define LP5523_PAGE_ENG3		2
+
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
 struct lp5523_led {
 	int			id;
 	u8			chan_nr;
@@ -135,13 +155,17 @@ struct lp5523_led {
 struct lp5523_chip {
 	struct mutex		lock; /* Serialize control */
 	struct i2c_client	*client;
-	struct lp5523_engine	engines[LP5523_ENGINES];
 	struct lp5523_led	leds[LP5523_MAX_LEDS];
 	struct lp5523_platform_data *pdata;
 	u8			num_channels;
 	u8			num_leds;
 };
 
+static inline void lp5523_wait_opmode_done(void)
+{
+	usleep_range(1000, 2000);
+}
+
 static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
 {
 	led->led_current = led_current;
@@ -149,27 +173,6 @@ static void lp5523_set_led_current(struct lp55xx_led *led, u8 led_current)
 		led_current);
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
-static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
-
 static int lp5523_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -212,177 +215,162 @@ static int lp5523_post_init_device(struct lp55xx_chip *chip)
 	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
 }
 
-static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode)
+static void lp5523_load_engine(struct lp55xx_chip *chip)
 {
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
-	u8 engine_state;
+	enum lp55xx_engine_index idx = chip->engine_idx;
+	u8 mask[] = {
+		[LP55XX_ENGINE_1] = LP5523_MODE_ENG1_M,
+		[LP55XX_ENGINE_2] = LP5523_MODE_ENG2_M,
+		[LP55XX_ENGINE_3] = LP5523_MODE_ENG3_M,
+	};
 
-	ret = lp5523_read(client, LP5523_REG_OP_MODE, &engine_state);
-	if (ret)
-		goto fail;
+	u8 val[] = {
+		[LP55XX_ENGINE_1] = LP5523_LOAD_ENG1,
+		[LP55XX_ENGINE_2] = LP5523_LOAD_ENG2,
+		[LP55XX_ENGINE_3] = LP5523_LOAD_ENG3,
+	};
 
-	engine_state &= ~(engine->engine_mask);
+	u8 page_sel[] = {
+		[LP55XX_ENGINE_1] = LP5523_PAGE_ENG1,
+		[LP55XX_ENGINE_2] = LP5523_PAGE_ENG2,
+		[LP55XX_ENGINE_3] = LP5523_PAGE_ENG3,
+	};
 
-	/* set mode only for this engine */
-	mode &= engine->engine_mask;
+	lp55xx_update_bits(chip, LP5523_REG_OP_MODE, mask[idx], val[idx]);
 
-	engine_state |= mode;
+	lp5523_wait_opmode_done();
 
-	ret |= lp5523_write(client, LP5523_REG_OP_MODE, engine_state);
-fail:
-	return ret;
+	lp55xx_write(chip, LP5523_REG_PROG_PAGE_SEL, page_sel[idx]);
 }
 
-static int lp5523_load_mux(struct lp5523_engine *engine, u16 mux)
+static void lp5523_stop_engine(struct lp55xx_chip *chip)
 {
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret = 0;
-
-	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
+	lp55xx_write(chip, LP5523_REG_OP_MODE, 0);
+	lp5523_wait_opmode_done();
+}
 
-	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL, engine->mux_page);
-	ret |= lp5523_write(client, LP5523_REG_PROG_MEM,
-			    (u8)(mux >> 8));
-	ret |= lp5523_write(client, LP5523_REG_PROG_MEM + 1, (u8)(mux));
-	engine->led_mux = mux;
+static void lp5523_turn_off_channels(struct lp55xx_chip *chip)
+{
+	int i;
 
-	return ret;
+	for (i = 0; i < LP5523_MAX_LEDS; i++)
+		lp55xx_write(chip, LP5523_REG_LED_PWM_BASE + i, 0);
 }
 
-static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern)
+static void lp5523_run_engine(struct lp55xx_chip *chip, bool start)
 {
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
+	int ret;
+	u8 mode;
+	u8 exec;
 
-	int ret = 0;
+	/* stop engine */
+	if (!start) {
+		lp5523_stop_engine(chip);
+		lp5523_turn_off_channels(chip);
+		return;
+	}
 
-	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
+	/*
+	 * To run the engine,
+	 * operation mode and enable register should updated at the same time
+	 */
 
-	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL,
-			    engine->prog_page);
-	ret |= i2c_smbus_write_i2c_block_data(client, LP5523_REG_PROG_MEM,
-					      LP5523_PROGRAM_LENGTH, pattern);
+	ret = lp55xx_read(chip, LP5523_REG_OP_MODE, &mode);
+	if (ret)
+		return;
 
-	return ret;
-}
+	ret = lp55xx_read(chip, LP5523_REG_ENABLE, &exec);
+	if (ret)
+		return;
 
-static int lp5523_run_program(struct lp5523_engine *engine)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
+	/* change operation mode to RUN only when each engine is loading */
+	if (LP5523_ENG1_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG1_M) | LP5523_RUN_ENG1;
+		exec = (exec & ~LP5523_EXEC_ENG1_M) | LP5523_RUN_ENG1;
+	}
 
-	ret = lp5523_write(client, LP5523_REG_ENABLE,
-					LP5523_CMD_RUN | LP5523_ENABLE);
-	if (ret)
-		goto fail;
+	if (LP5523_ENG2_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG2_M) | LP5523_RUN_ENG2;
+		exec = (exec & ~LP5523_EXEC_ENG2_M) | LP5523_RUN_ENG2;
+	}
 
-	ret = lp5523_set_engine_mode(engine, LP5523_CMD_RUN);
-fail:
-	return ret;
+	if (LP5523_ENG3_IS_LOADING(mode)) {
+		mode = (mode & ~LP5523_MODE_ENG3_M) | LP5523_RUN_ENG3;
+		exec = (exec & ~LP5523_EXEC_ENG3_M) | LP5523_RUN_ENG3;
+	}
+
+	lp55xx_write(chip, LP5523_REG_OP_MODE, mode);
+	lp5523_wait_opmode_done();
+
+	lp55xx_update_bits(chip, LP5523_REG_ENABLE, LP5523_EXEC_M, exec);
 }
 
-static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
+static int lp5523_update_program_memory(struct lp55xx_chip *chip,
+					const u8 *data, size_t size)
 {
+	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
+	unsigned cmd;
+	char c[3];
+	int update_size;
+	int nrchars;
+	int offset = 0;
+	int ret;
 	int i;
-	u16 tmp_mux = 0;
-
-	len = min_t(int, len, LP5523_MAX_LEDS);
-	for (i = 0; i < len; i++) {
-		switch (buf[i]) {
-		case '1':
-			tmp_mux |= (1 << i);
-			break;
-		case '0':
-			break;
-		case '\n':
-			i = len;
-			break;
-		default:
-			return -1;
-		}
-	}
-	*mux = tmp_mux;
 
-	return 0;
-}
+	/* clear program memory before updating */
+	for (i = 0; i < LP5523_PROGRAM_LENGTH; i++)
+		lp55xx_write(chip, LP5523_REG_PROG_MEM + i, 0);
 
-static void lp5523_mux_to_array(u16 led_mux, char *array)
-{
-	int i, pos = 0;
-	for (i = 0; i < LP5523_MAX_LEDS; i++)
-		pos += sprintf(array + pos, "%x", LED_ACTIVE(led_mux, i));
+	i = 0;
+	while ((offset < size - 1) && (i < LP5523_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(data + offset, "%2s%n ", c, &nrchars);
+		if (ret != 1)
+			goto err;
 
-	array[pos] = '\0';
-}
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto err;
 
-/*--------------------------------------------------------------*/
-/*			Sysfs interface				*/
-/*--------------------------------------------------------------*/
+		pattern[i] = (u8)cmd;
+		offset += nrchars;
+		i++;
+	}
 
-static ssize_t show_engine_leds(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	char mux[LP5523_MAX_LEDS + 1];
+	/* Each instruction is 16bit long. Check that length is even */
+	if (i % 2)
+		goto err;
 
-	lp5523_mux_to_array(chip->engines[nr - 1].led_mux, mux);
+	update_size = i;
+	for (i = 0; i < update_size; i++)
+		lp55xx_write(chip, LP5523_REG_PROG_MEM + i, pattern[i]);
 
-	return sprintf(buf, "%s\n", mux);
-}
+	return 0;
 
-#define show_leds(nr)							\
-static ssize_t show_engine##nr##_leds(struct device *dev,		\
-			    struct device_attribute *attr,		\
-			    char *buf)					\
-{									\
-	return show_engine_leds(dev, attr, buf, nr);			\
+err:
+	dev_err(&chip->cl->dev, "wrong pattern format\n");
+	return -EINVAL;
 }
-show_leds(1)
-show_leds(2)
-show_leds(3)
 
-static ssize_t store_engine_leds(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t len, int nr)
+static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 {
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	u16 mux = 0;
-	ssize_t ret;
-
-	if (lp5523_mux_parse(buf, &mux, len))
-		return -EINVAL;
+	const struct firmware *fw = chip->fw;
 
-	mutex_lock(&chip->lock);
-	ret = -EINVAL;
-	if (chip->engines[nr - 1].mode != LP5523_CMD_LOAD)
-		goto leave;
-
-	if (lp5523_load_mux(&chip->engines[nr - 1], mux))
-		goto leave;
+	if (fw->size > LP5523_PROGRAM_LENGTH) {
+		dev_err(&chip->cl->dev, "firmware data size overflow: %d\n",
+			fw->size);
+		return;
+	}
 
-	ret = len;
-leave:
-	mutex_unlock(&chip->lock);
-	return ret;
-}
+	/*
+	 * Program momery sequence
+	 *  1) set engine mode to "LOAD"
+	 *  2) write firmware data into program memory
+	 */
 
-#define store_leds(nr)						\
-static ssize_t store_engine##nr##_leds(struct device *dev,	\
-			     struct device_attribute *attr,	\
-			     const char *buf, size_t len)	\
-{								\
-	return store_engine_leds(dev, attr, buf, len, nr);	\
+	lp5523_load_engine(chip);
+	lp5523_update_program_memory(chip, fw->data, fw->size);
 }
-store_leds(1)
-store_leds(2)
-store_leds(3)
 
 static ssize_t lp5523_selftest(struct device *dev,
 			       struct device_attribute *attr,
@@ -485,159 +473,10 @@ static void lp5523_led_brightness_work(struct work_struct *work)
 	mutex_unlock(&chip->lock);
 }
 
-static int lp5523_do_store_load(struct lp5523_engine *engine,
-				const char *buf, size_t len)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int  ret, nrchars, offset = 0, i = 0;
-	char c[3];
-	unsigned cmd;
-	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
-
-	if (engine->mode != LP5523_CMD_LOAD)
-		return -EINVAL;
-
-	while ((offset < len - 1) && (i < LP5523_PROGRAM_LENGTH)) {
-		/* separate sscanfs because length is working only for %s */
-		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
-		ret = sscanf(c, "%2x", &cmd);
-		if (ret != 1)
-			goto fail;
-		pattern[i] = (u8)cmd;
-
-		offset += nrchars;
-		i++;
-	}
-
-	/* Each instruction is 16bit long. Check that length is even */
-	if (i % 2)
-		goto fail;
-
-	mutex_lock(&chip->lock);
-	ret = lp5523_load_program(engine, pattern);
-	mutex_unlock(&chip->lock);
-
-	if (ret) {
-		dev_err(&client->dev, "failed loading pattern\n");
-		return ret;
-	}
-
-	return len;
-fail:
-	dev_err(&client->dev, "wrong pattern format\n");
-	return -EINVAL;
-}
-
-static ssize_t store_engine_load(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t len, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	return lp5523_do_store_load(&chip->engines[nr - 1], buf, len);
-}
-
-#define store_load(nr)							\
-static ssize_t store_engine##nr##_load(struct device *dev,		\
-				     struct device_attribute *attr,	\
-				     const char *buf, size_t len)	\
-{									\
-	return store_engine_load(dev, attr, buf, len, nr);		\
-}
-store_load(1)
-store_load(2)
-store_load(3)
-
-static ssize_t show_engine_mode(struct device *dev,
-				struct device_attribute *attr,
-				char *buf, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	switch (chip->engines[nr - 1].mode) {
-	case LP5523_CMD_RUN:
-		return sprintf(buf, "run\n");
-	case LP5523_CMD_LOAD:
-		return sprintf(buf, "load\n");
-	case LP5523_CMD_DISABLED:
-		return sprintf(buf, "disabled\n");
-	default:
-		return sprintf(buf, "disabled\n");
-	}
-}
-
-#define show_mode(nr)							\
-static ssize_t show_engine##nr##_mode(struct device *dev,		\
-				    struct device_attribute *attr,	\
-				    char *buf)				\
-{									\
-	return show_engine_mode(dev, attr, buf, nr);			\
-}
-show_mode(1)
-show_mode(2)
-show_mode(3)
-
-static ssize_t store_engine_mode(struct device *dev,
-				 struct device_attribute *attr,
-				 const char *buf, size_t len, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	struct lp5523_engine *engine = &chip->engines[nr - 1];
-	mutex_lock(&chip->lock);
-
-	if (!strncmp(buf, "run", 3))
-		lp5523_set_mode(engine, LP5523_CMD_RUN);
-	else if (!strncmp(buf, "load", 4))
-		lp5523_set_mode(engine, LP5523_CMD_LOAD);
-	else if (!strncmp(buf, "disabled", 8))
-		lp5523_set_mode(engine, LP5523_CMD_DISABLED);
-
-	mutex_unlock(&chip->lock);
-	return len;
-}
-
-#define store_mode(nr)							\
-static ssize_t store_engine##nr##_mode(struct device *dev,		\
-				     struct device_attribute *attr,	\
-				     const char *buf, size_t len)	\
-{									\
-	return store_engine_mode(dev, attr, buf, len, nr);		\
-}
-store_mode(1)
-store_mode(2)
-store_mode(3)
-
-/* device attributes */
-static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUSR,
-		   show_engine1_mode, store_engine1_mode);
-static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUSR,
-		   show_engine2_mode, store_engine2_mode);
-static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUSR,
-		   show_engine3_mode, store_engine3_mode);
-static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUSR,
-		   show_engine1_leds, store_engine1_leds);
-static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUSR,
-		   show_engine2_leds, store_engine2_leds);
-static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUSR,
-		   show_engine3_leds, store_engine3_leds);
-static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
-static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
-static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
 
 static struct attribute *lp5523_attributes[] = {
-	&dev_attr_engine1_mode.attr,
-	&dev_attr_engine2_mode.attr,
-	&dev_attr_engine3_mode.attr,
 	&dev_attr_selftest.attr,
-	&dev_attr_engine1_load.attr,
-	&dev_attr_engine1_leds.attr,
-	&dev_attr_engine2_load.attr,
-	&dev_attr_engine2_leds.attr,
-	&dev_attr_engine3_load.attr,
-	&dev_attr_engine3_leds.attr,
 	NULL,
 };
 
@@ -664,48 +503,6 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
 	sysfs_remove_group(&dev->kobj, &lp5523_group);
 }
 
-/*--------------------------------------------------------------*/
-/*			Set chip operating mode			*/
-/*--------------------------------------------------------------*/
-static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
-{
-	/* if in that mode already do nothing, except for run */
-	if (mode == engine->mode && mode != LP5523_CMD_RUN)
-		return;
-
-	switch (mode) {
-	case LP5523_CMD_RUN:
-		lp5523_run_program(engine);
-		break;
-	case LP5523_CMD_LOAD:
-		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
-		lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-		break;
-	case LP5523_CMD_DISABLED:
-		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
-		break;
-	default:
-		return;
-	}
-
-	engine->mode = mode;
-}
-
-/*--------------------------------------------------------------*/
-/*			Probe, Attach, Remove			*/
-/*--------------------------------------------------------------*/
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
 /* Chip specific configurations */
 static struct lp55xx_device_config lp5523_cfg = {
 	.reset = {
@@ -720,6 +517,8 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.post_init_device   = lp5523_post_init_device,
 	.brightness_work_fn = lp5523_led_brightness_work,
 	.set_led_current    = lp5523_set_led_current,
+	.firmware_cb        = lp5523_firmware_loaded,
+	.run_engine         = lp5523_run_engine,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
-- 
1.7.9.5


Best Regards,
Milo


