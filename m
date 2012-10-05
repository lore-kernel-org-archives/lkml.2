Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2JEISe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:18:34 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55946 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab2JEISa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:18:30 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/28] leds-lp5521/5523: remove unnecessary dev attributes
Thread-Topic: [PATCH 14/28] leds-lp5521/5523: remove unnecessary dev
 attributes
Thread-Index: Ac2i0fRvf4q8vUoYQku5cgTESIZILA==
Date: Fri, 5 Oct 2012 08:18:18 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641767B5@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: GBAC Lxph MmAs Po2t QZQi SPqj Vxw1 d+G7 hzrL iand loV5
 mymj q0R/ sWkh xv5G
 zOY/;4;YgByAHkAYQBuAC4AdwB1AEAAYwBhAG4AbwBuAGkAYwBhAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBsAGUAZABzAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAHAAdQByAGQAaQBlAEAAcgBwAHMAeQBzAC4AbgBlAHQA;Sosha1_v1;7;{82EB58DE-523F-4DD2-924A-054A7BA12936};bQBpAGwAbwAuAGsAaQBtAEAAdABpAC4AYwBvAG0A;Fri,
 05 Oct 2012 08:18:09
 GMT;WwBQAEEAVABDAEgAIAAxADQALwAyADgAXQAgAGwAZQBkAHMALQBsAHAANQA1ADIAMQAvADUANQAyADMAOgAgAHIAZQBtAG8AdgBlACAAdQBuAG4AZQBjAGUAcwBzAGEAcgB5ACAAZABlAHYAIABhAHQAdAByAGkAYgB1AHQAZQBzAA==
x-cr-puzzleid: {82EB58DE-523F-4DD2-924A-054A7BA12936}
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch removes unused device attributes.

 LP5521 has seven device attributes for accessing program memory.
  engine1_mode
  engine2_mode
  engine3_mode
  engine1_load
  engine2_load
  engine3_load
  led_pattern

 LP5523/55231 has nine device attributes for accessing program memory.
  engine1_mode
  engine2_mode
  engine3_mode
  engine1_load
  engine2_load
  engine3_load
  engine1_leds
  engine2_leds
  engine3_leds

 engineX_mode  : Set each engine mode (load/run/disabled)
 engineX_load  : Write program data to each engine. (raw hex code)
 engineX_leds  : Select which LED output is used for running program.
 led_pattern   : Support for predefined pattern.
                 Hard-coded hex byte streams are defined in the platform data.

 The LP55xx common driver provides very simple interface as follows.
 select_engine : Select which engine is used for running program
 run_engine    : Start program which is loaded via the firmware interface
 firmware      : Load program data
 Just two device attributes are required to run the program.

 Therefore, unnecessary device attributes are deleted.
 After all, new lp55xx firmware interface and common attributes are used
 for running program data.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |  250 ------------------------------
 drivers/leds/leds-lp5523.c |  363 --------------------------------------------
 2 files changed, 613 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index ae0a068..06e5e76 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -198,67 +198,6 @@ static int lp5521_read(struct i2c_client *client, u8 reg, u8 *buf)
 	return 0;
 }
 
-static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
-{
-	struct lp5521_chip *chip = engine_to_lp5521(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
-	u8 engine_state;
-
-	/* Only transition between RUN and DIRECT mode are handled here */
-	if (mode == LP5521_CMD_LOAD)
-		return 0;
-
-	if (mode == LP5521_CMD_DISABLED)
-		mode = LP5521_CMD_DIRECT;
-
-	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
-	if (ret < 0)
-		return ret;
-
-	/* set mode only for this engine */
-	engine_state &= ~(engine->engine_mask);
-	mode &= engine->engine_mask;
-	engine_state |= mode;
-	return lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
-}
-
-static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
-{
-	struct lp5521_chip *chip = engine_to_lp5521(eng);
-	struct i2c_client *client = chip->client;
-	int ret;
-	int addr;
-	u8 mode;
-
-	/* move current engine to direct mode and remember the state */
-	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
-	if (ret)
-		return ret;
-
-	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
-	usleep_range(1000, 2000);
-	ret = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
-	if (ret)
-		return ret;
-
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
-}
-
 static void lp5521_set_led_current(struct lp55xx_led *led, u8 led_current)
 {
 	led->led_current = led_current;
@@ -487,155 +426,6 @@ static void lp5521_led_brightness_work(struct work_struct *work)
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
@@ -724,45 +514,11 @@ static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
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
-	ret = strict_strtoul(buf, 16, &val);
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
 
@@ -770,12 +526,6 @@ static const struct attribute_group lp5521_group = {
 	.attrs = lp5521_attributes,
 };
 
-static int lp5521_register_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-	return sysfs_create_group(&dev->kobj, &lp5521_group);
-}
-
 static void lp5521_unregister_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 2cb0c1a..f40b058 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -195,10 +195,6 @@ static inline struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
 			    leds[led->id]);
 }
 
-static void lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
-static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern);
-
 static int lp5523_write(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -241,178 +237,6 @@ static int lp5523_post_init_device(struct lp55xx_chip *chip)
 	return lp55xx_write(chip, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
 }
 
-static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
-	u8 engine_state;
-
-	ret = lp5523_read(client, LP5523_REG_OP_MODE, &engine_state);
-	if (ret)
-		goto fail;
-
-	engine_state &= ~(engine->engine_mask);
-
-	/* set mode only for this engine */
-	mode &= engine->engine_mask;
-
-	engine_state |= mode;
-
-	ret |= lp5523_write(client, LP5523_REG_OP_MODE, engine_state);
-fail:
-	return ret;
-}
-
-static int lp5523_load_mux(struct lp5523_engine *engine, u16 mux)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret = 0;
-
-	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-
-	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL, engine->mux_page);
-	ret |= lp5523_write(client, LP5523_REG_PROG_MEM,
-			    (u8)(mux >> 8));
-	ret |= lp5523_write(client, LP5523_REG_PROG_MEM + 1, (u8)(mux));
-	engine->led_mux = mux;
-
-	return ret;
-}
-
-static int lp5523_load_program(struct lp5523_engine *engine, const u8 *pattern)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-
-	int ret = 0;
-
-	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
-
-	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL,
-			    engine->prog_page);
-	ret |= i2c_smbus_write_i2c_block_data(client, LP5523_REG_PROG_MEM,
-					      LP5523_PROGRAM_LENGTH, pattern);
-
-	return ret;
-}
-
-static int lp5523_run_program(struct lp5523_engine *engine)
-{
-	struct lp5523_chip *chip = engine_to_lp5523(engine);
-	struct i2c_client *client = chip->client;
-	int ret;
-
-	ret = lp5523_write(client, LP5523_REG_ENABLE,
-					LP5523_CMD_RUN | LP5523_ENABLE);
-	if (ret)
-		goto fail;
-
-	ret = lp5523_set_engine_mode(engine, LP5523_CMD_RUN);
-fail:
-	return ret;
-}
-
-static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
-{
-	int i;
-	u16 tmp_mux = 0;
-
-	len = min_t(int, len, LP5523_LEDS);
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
-
-	return 0;
-}
-
-static void lp5523_mux_to_array(u16 led_mux, char *array)
-{
-	int i, pos = 0;
-	for (i = 0; i < LP5523_LEDS; i++)
-		pos += sprintf(array + pos, "%x", LED_ACTIVE(led_mux, i));
-
-	array[pos] = '\0';
-}
-
-/*--------------------------------------------------------------*/
-/*			Sysfs interface				*/
-/*--------------------------------------------------------------*/
-
-static ssize_t show_engine_leds(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	char mux[LP5523_LEDS + 1];
-
-	lp5523_mux_to_array(chip->engines[nr - 1].led_mux, mux);
-
-	return sprintf(buf, "%s\n", mux);
-}
-
-#define show_leds(nr)							\
-static ssize_t show_engine##nr##_leds(struct device *dev,		\
-			    struct device_attribute *attr,		\
-			    char *buf)					\
-{									\
-	return show_engine_leds(dev, attr, buf, nr);			\
-}
-show_leds(1)
-show_leds(2)
-show_leds(3)
-
-static ssize_t store_engine_leds(struct device *dev,
-			     struct device_attribute *attr,
-			     const char *buf, size_t len, int nr)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	u16 mux = 0;
-	ssize_t ret;
-
-	if (lp5523_mux_parse(buf, &mux, len))
-		return -EINVAL;
-
-	mutex_lock(&chip->lock);
-	ret = -EINVAL;
-	if (chip->engines[nr - 1].mode != LP5523_CMD_LOAD)
-		goto leave;
-
-	if (lp5523_load_mux(&chip->engines[nr - 1], mux))
-		goto leave;
-
-	ret = len;
-leave:
-	mutex_unlock(&chip->lock);
-	return ret;
-}
-
-#define store_leds(nr)						\
-static ssize_t store_engine##nr##_leds(struct device *dev,	\
-			     struct device_attribute *attr,	\
-			     const char *buf, size_t len)	\
-{								\
-	return store_engine_leds(dev, attr, buf, len, nr);	\
-}
-store_leds(1)
-store_leds(2)
-store_leds(3)
-
 static ssize_t lp5523_selftest(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
@@ -667,159 +491,11 @@ static void lp5523_firmware_loaded(struct lp55xx_chip *chip)
 	lp5523_update_program_memory(chip, fw->data, fw->size);
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
 /* device attributes */
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
 
@@ -827,18 +503,6 @@ static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static int lp5523_register_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-	int ret;
-
-	ret = sysfs_create_group(&dev->kobj, &lp5523_group);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static void lp5523_unregister_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -847,33 +511,6 @@ static void lp5523_unregister_sysfs(struct i2c_client *client)
 }
 
 /*--------------------------------------------------------------*/
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
 /*			Probe, Attach, Remove			*/
 /*--------------------------------------------------------------*/
 
-- 
1.7.9.5


Best Regards,
Milo


