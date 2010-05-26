Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0EZL3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:29:33 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33320 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759196Ab0EZL3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:29:30 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] leds: driver for LP5521 and LP5523 chips from National Semiconductor
Date: Wed, 26 May 2010 14:29:13 +0300
Message-Id: <1274873354-1432-2-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1274873354-1432-1-git-send-email-samu.p.onkalo@nokia.com>
References: <1274873354-1432-1-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 26 May 2010 11:29:15.0071 (UTC) FILETIME=[ABDECCF0:01CAFCC6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for two LED driver chips from National Semiconductor.
LP5521 is a 3 channel led driver chip.
LP5523 is a 9 channel led driver chip.

Drivers are developed and tested in 2.6.32 kernel environment.
Tested to compile on 2.6.34

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/leds/Kconfig        |   16 +
 drivers/leds/Makefile       |    2 +
 drivers/leds/leds-lp5521.c  |  774 +++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp5523.c  | 1005 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lp5521.h |   23 +
 include/linux/leds-lp5523.h |   23 +
 6 files changed, 1843 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lp5521.c
 create mode 100644 drivers/leds/leds-lp5523.c
 create mode 100644 include/linux/leds-lp5521.h
 create mode 100644 include/linux/leds-lp5523.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 505eb64..66d2393 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -166,6 +166,22 @@ config LEDS_LP3944
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-lp3944.
 
+config LEDS_LP5521
+	tristate "LED support for N.S. LP5521 LED driver chip"
+	depends on I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5521 LED driver.
+	  Module is called leds-lp5521
+
+config LEDS_LP5523
+	tristate "LED support for N.S. LP5523 LED driver chip"
+	depends on I2C
+	help
+	  If you say yes here you get support for the National Semiconductor
+	  LP5523 LED driver.
+	  Module is called leds-lp5523
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook"
 	depends on X86 && SERIO_I8042 && DMI
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 0cd8b99..ad3bf5f 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
 obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
+obj-$(CONFIG_LEDS_LP5523)		+= leds-lp5523.o
+obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
new file mode 100644
index 0000000..76ceb27
--- /dev/null
+++ b/drivers/leds/leds-lp5521.c
@@ -0,0 +1,774 @@
+/*
+ * LP5521 LED chip driver.
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/ctype.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/leds.h>
+#include <linux/leds-lp5521.h>
+
+#define LP5521_PROGRAM_LENGTH		32	/* in bytes */
+
+#define LP5521_MAX_LEDS			3	/* Maximum number of LEDs */
+#define LP5521_MAX_ENGINES		3	/* Maximum number of engines */
+
+#define LP5521_ENG_MASK_BASE		0x30	/* 00110000 */
+#define LP5521_ENG_STATUS_MASK		0x07	/* 00000111 */
+
+#define LP5521_CMD_LOAD			0x15	/* 00010101 */
+#define LP5521_CMD_RUN			0x2a	/* 00101010 */
+#define LP5521_CMD_DIRECT		0x3f	/* 00111111 */
+#define LP5521_CMD_DISABLED		0x00	/* 00000000 */
+
+/* Registers */
+#define LP5521_REG_ENABLE		0x00
+#define LP5521_REG_OP_MODE		0x01
+#define LP5521_REG_R_PWM		0x02
+#define LP5521_REG_G_PWM		0x03
+#define LP5521_REG_B_PWM		0x04
+#define LP5521_REG_R_CURRENT		0x05
+#define LP5521_REG_G_CURRENT		0x06
+#define LP5521_REG_B_CURRENT		0x07
+#define LP5521_REG_CONFIG		0x08
+#define LP5521_REG_R_CHANNEL_PC		0x09
+#define LP5521_REG_G_CHANNEL_PC		0x0A
+#define LP5521_REG_B_CHANNEL_PC		0x0B
+#define LP5521_REG_STATUS		0x0C
+#define LP5521_REG_RESET		0x0D
+#define LP5521_REG_GPO			0x0E
+#define LP5521_REG_R_PROG_MEM		0x10
+#define LP5521_REG_G_PROG_MEM		0x30
+#define LP5521_REG_B_PROG_MEM		0x50
+
+#define LP5521_PROG_MEM_BASE		LP5521_REG_R_PROG_MEM
+#define LP5521_PROG_MEM_SIZE		0x20
+
+/* Base register to set LED current */
+#define LP5521_REG_LED_CURRENT_BASE	LP5521_REG_R_CURRENT
+
+/* Base register to set the brightness */
+#define LP5521_REG_LED_PWM_BASE		LP5521_REG_R_PWM
+
+/* Bits in ENABLE register */
+#define LP5521_MASTER_ENABLE		0x40	/* Chip master enable */
+#define LP5521_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
+#define LP5521_EXEC_RUN			0x2A
+
+/* Bits in CONFIG register */
+#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
+#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
+#define LP5521_CLK_INT			1	/* Internal clock */
+#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
+
+/* Status */
+#define LP5521_EXT_CLK_USED		0x08
+
+struct lp5521_engine {
+	const struct attribute_group *attributes;
+	int		id;
+	u8		mode;
+	u8		prog_page;
+	u8		engine_mask;
+};
+
+struct lp5521_led {
+	int			id;
+	u8			chan_nr;
+	u8			led_current;
+	struct led_classdev	cdev;
+};
+
+struct lp5521_chip {
+	struct lp5521_platform_data *pdata;
+	struct mutex		lock; /* Serialize control */
+	struct i2c_client	*client;
+	struct lp5521_engine	engines[LP5521_MAX_ENGINES];
+	struct lp5521_led	leds[LP5521_MAX_LEDS];
+	u8			num_channels;
+	u8			num_leds;
+};
+
+#define cdev_to_led(c)		container_of(c, struct lp5521_led, cdev)
+#define engine_to_lp5521(eng)	container_of((eng), struct lp5521_chip, \
+						engines[(eng)->id - 1])
+#define led_to_lp5521(led)	container_of((led), struct lp5521_chip, \
+						leds[(led)->id])
+
+static inline int lp5521_write(struct i2c_client *client, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int lp5521_read(struct i2c_client *client, u8 reg, u8 *buf)
+{
+	s32 ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0)
+		return -EIO;
+
+	*buf = ret;
+	return 0;
+}
+
+static int lp5521_set_engine_mode(struct lp5521_engine *engine, u8 mode)
+{
+	struct lp5521_chip *chip = engine_to_lp5521(engine);
+	struct i2c_client *client = chip->client;
+	int ret;
+	u8 engine_state;
+
+	/* Only transition between RUN and DIRECT mode are handled here */
+	if (mode == LP5521_CMD_LOAD)
+		return 0;
+
+	if (mode == LP5521_CMD_DISABLED)
+		mode = LP5521_CMD_DIRECT;
+
+	ret = lp5521_read(client, LP5521_REG_OP_MODE, &engine_state);
+
+	/* set mode only for this engine */
+	engine_state &= ~(engine->engine_mask);
+	mode &= engine->engine_mask;
+	engine_state |= mode;
+	ret |= lp5521_write(client, LP5521_REG_OP_MODE, engine_state);
+
+	return ret;
+}
+
+static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
+{
+	struct lp5521_chip *chip = engine_to_lp5521(eng);
+	struct i2c_client *client = chip->client;
+	int ret;
+	int addr;
+	u8 mode;
+
+	/* move current engine to direct mode and remember the state */
+	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
+	msleep(1);
+	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+
+	/* For loading, all the engines to load mode */
+	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+	msleep(1);
+	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
+	msleep(1);
+
+	addr = LP5521_PROG_MEM_BASE + eng->prog_page * LP5521_PROG_MEM_SIZE;
+	i2c_smbus_write_i2c_block_data(client,
+				addr,
+				LP5521_PROG_MEM_SIZE,
+				pattern);
+
+	ret |= lp5521_write(client, LP5521_REG_OP_MODE, mode);
+	return ret;
+}
+
+static int lp5521_set_led_current(struct lp5521_chip *chip, int led, u8 curr)
+{
+    return lp5521_write(chip->client,
+		    LP5521_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
+		    curr);
+}
+
+static void lp5521_init_engine(struct lp5521_chip *chip,
+			const struct attribute_group *attr_group)
+{
+	int i;
+	for (i = 0; i < LP5521_MAX_ENGINES; i++) {
+		chip->engines[i].id = i + 1;
+		chip->engines[i].engine_mask = LP5521_ENG_MASK_BASE >> (i * 2);
+		chip->engines[i].prog_page = i;
+		chip->engines[i].attributes = &attr_group[i];
+	}
+}
+
+static int lp5521_configure(struct i2c_client *client,
+			const struct attribute_group *attr_group)
+{
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	int ret;
+
+	lp5521_init_engine(chip, attr_group);
+
+	lp5521_write(client, LP5521_REG_RESET, 0xff);
+
+	msleep(10);
+
+	/* Set all PWMs to direct control mode */
+	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
+
+	/* Enable auto-powersave, set charge pump to auto, red to battery */
+	ret |= lp5521_write(client, LP5521_REG_CONFIG,
+		LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+
+	/* Initialize all channels PWM to zero -> leds off */
+	ret |= lp5521_write(client, LP5521_REG_R_PWM, 0);
+	ret |= lp5521_write(client, LP5521_REG_G_PWM, 0);
+	ret |= lp5521_write(client, LP5521_REG_B_PWM, 0);
+
+	/* Set engines are set to run state when OP_MODE enables engines */
+	ret |= lp5521_write(client, LP5521_REG_ENABLE,
+			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
+			LP5521_EXEC_RUN);
+	/* enable takes 500us */
+	msleep(1);
+
+	return ret;
+}
+
+static ssize_t lp5521_run_selftest(struct lp5521_chip *chip, char *buf)
+{
+	int ret;
+	u8 status;
+
+	ret = lp5521_read(chip->client, LP5521_REG_STATUS, &status);
+	if (ret < 0)
+		goto fail;
+
+	/* Check that ext clock is really in use if requested */
+	if (chip->pdata && chip->pdata->clock_mode == LP5521_CLOCK_EXT)
+		if  ((status & LP5521_EXT_CLK_USED) == 0)
+			goto fail;
+
+	return sprintf(buf, "OK\n");
+fail:
+	return sprintf(buf, "FAIL\n");
+}
+
+static void lp5521_set_brightness(struct led_classdev *cdev,
+			     enum led_brightness brightness)
+{
+	struct lp5521_led *led = cdev_to_led(cdev);
+	struct lp5521_chip *chip = led_to_lp5521(led);
+	struct i2c_client *client = chip->client;
+
+	mutex_lock(&chip->lock);
+	lp5521_write(client, LP5521_REG_LED_PWM_BASE + led->chan_nr,
+		(u8)brightness);
+	mutex_unlock(&chip->lock);
+}
+
+/* Detect the chip by setting its ENABLE register and reading it back. */
+static int lp5521_detect(struct i2c_client *client)
+{
+	int ret;
+	u8 buf;
+
+	ret = lp5521_write(client, LP5521_REG_ENABLE,
+			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+	if (ret)
+		return ret;
+	msleep(1);
+	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
+	if (ret)
+		return ret;
+	if (buf != (LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM))
+		return -ENODEV;
+
+	return 0;
+}
+
+/* Set engine mode and create appropriate sysfs attributes, if required. */
+static int lp5521_set_mode(struct lp5521_engine *engine, u8 mode)
+{
+	struct lp5521_chip *chip = engine_to_lp5521(engine);
+	struct i2c_client *client = chip->client;
+	struct device *dev = &client->dev;
+	int ret = 0;
+
+	/* if in that mode already do nothing, except for run */
+	if (mode == engine->mode && mode != LP5521_CMD_RUN)
+		return 0;
+
+	if (mode == LP5521_CMD_RUN)
+		ret = lp5521_set_engine_mode(engine, LP5521_CMD_RUN);
+
+	else if (mode == LP5521_CMD_LOAD) {
+		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
+		lp5521_set_engine_mode(engine, LP5521_CMD_LOAD);
+
+		ret = sysfs_create_group(&dev->kobj, engine->attributes);
+		if (ret)
+			return ret;
+	}
+
+	else if (mode == LP5521_CMD_DISABLED)
+		lp5521_set_engine_mode(engine, LP5521_CMD_DISABLED);
+
+	/* remove load attribute from sysfs if not in load mode */
+	if (engine->mode == LP5521_CMD_LOAD && mode != LP5521_CMD_LOAD)
+		sysfs_remove_group(&dev->kobj, engine->attributes);
+
+	engine->mode = mode;
+
+	return ret;
+}
+
+static int lp5521_do_store_load(struct lp5521_engine *engine,
+				const char *buf, size_t len)
+{
+	struct lp5521_chip *chip = engine_to_lp5521(engine);
+	struct i2c_client *client = chip->client;
+	int  ret, nrchars, offset = 0, i = 0;
+	char c[3];
+	unsigned cmd;
+	u8 pattern[LP5521_PROGRAM_LENGTH] = {0};
+
+	while ((offset < len - 1) && (i < LP5521_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto fail;
+		pattern[i] = (u8)cmd;
+
+		offset += nrchars;
+		i++;
+	}
+
+	/* Pattern commands are always two bytes long */
+	if (i % 2)
+		goto fail;
+
+	mutex_lock(&chip->lock);
+	ret = lp5521_load_program(engine, pattern);
+	mutex_unlock(&chip->lock);
+
+	if (ret) {
+		dev_err(&client->dev, "failed loading pattern\n");
+		return ret;
+	}
+
+	return len;
+fail:
+	dev_err(&client->dev, "wrong pattern format\n");
+	return -EINVAL;
+}
+
+static ssize_t store_engine_load(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	return lp5521_do_store_load(&chip->engines[nr - 1], buf, len);
+}
+
+#define store_load(nr)							\
+static ssize_t store_engine##nr##_load(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t len)	\
+{									\
+	return store_engine_load(dev, attr, buf, len, nr);		\
+}
+store_load(1)
+store_load(2)
+store_load(3)
+
+static ssize_t show_engine_mode(struct device *dev,
+				struct device_attribute *attr,
+				char *buf, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	switch (chip->engines[nr - 1].mode) {
+	case LP5521_CMD_RUN:
+		return sprintf(buf, "run\n");
+	case LP5521_CMD_LOAD:
+		return sprintf(buf, "load\n");
+	case LP5521_CMD_DISABLED:
+		return sprintf(buf, "disabled\n");
+	default:
+		return sprintf(buf, "disabled\n");
+	}
+}
+
+#define show_mode(nr)							\
+static ssize_t show_engine##nr##_mode(struct device *dev,		\
+				    struct device_attribute *attr,	\
+				    char *buf)				\
+{									\
+	return show_engine_mode(dev, attr, buf, nr);			\
+}
+show_mode(1)
+show_mode(2)
+show_mode(3)
+
+static ssize_t store_engine_mode(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	struct lp5521_engine *engine = &chip->engines[nr - 1];
+	mutex_lock(&chip->lock);
+
+	if (!strncmp(buf, "run", 3))
+		lp5521_set_mode(engine, LP5521_CMD_RUN);
+	else if (!strncmp(buf, "load", 4))
+		lp5521_set_mode(engine, LP5521_CMD_LOAD);
+	else if (!strncmp(buf, "disabled", 8))
+		lp5521_set_mode(engine, LP5521_CMD_DISABLED);
+
+	mutex_unlock(&chip->lock);
+	return len;
+}
+
+#define store_mode(nr)							\
+static ssize_t store_engine##nr##_mode(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t len)	\
+{									\
+	return store_engine_mode(dev, attr, buf, len, nr);		\
+}
+store_mode(1)
+store_mode(2)
+store_mode(3)
+
+static ssize_t show_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lp5521_led *led = cdev_to_led(led_cdev);
+
+	return sprintf(buf, "%d\n", led->led_current);
+}
+
+static ssize_t store_current(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lp5521_led *led = cdev_to_led(led_cdev);
+	struct lp5521_chip *chip = led_to_lp5521(led);
+	ssize_t ret;
+	unsigned long curr;
+
+	if (strict_strtoul(buf, 0, &curr))
+		return -EINVAL;
+
+	if (curr > 255)
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	ret = lp5521_set_led_current(chip, led->id, curr);
+	mutex_unlock(&chip->lock);
+
+	if (ret < 0)
+		return ret;
+
+	led->led_current = (u8)curr;
+
+	return len;
+}
+
+static ssize_t lp5521_selftest(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	ssize_t ret = 0;
+
+	mutex_lock(&chip->lock);
+	ret = lp5521_run_selftest(chip, buf);
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+/* led class device attributes */
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+
+/* device attributes */
+static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUGO,
+		   show_engine1_mode, store_engine1_mode);
+static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUGO,
+		   show_engine2_mode, store_engine2_mode);
+static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUGO,
+		   show_engine3_mode, store_engine3_mode);
+static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
+
+static struct attribute *lp5521_attributes[] = {
+	&dev_attr_engine1_mode.attr,
+	&dev_attr_engine2_mode.attr,
+	&dev_attr_engine3_mode.attr,
+	&dev_attr_selftest.attr,
+	NULL
+};
+
+static struct attribute *lp5521_engine1_attributes[] = {
+	&dev_attr_engine1_load.attr,
+	NULL
+};
+
+static struct attribute *lp5521_engine2_attributes[] = {
+	&dev_attr_engine2_load.attr,
+	NULL
+};
+
+static struct attribute *lp5521_engine3_attributes[] = {
+	&dev_attr_engine3_load.attr,
+	NULL
+};
+
+static const struct attribute_group lp5521_group = {
+	.attrs = lp5521_attributes,
+};
+
+static const struct attribute_group lp5521_engine_group[] = {
+	{.attrs = lp5521_engine1_attributes },
+	{.attrs = lp5521_engine2_attributes },
+	{.attrs = lp5521_engine3_attributes },
+};
+
+static int lp5521_register_sysfs(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	return sysfs_create_group(&dev->kobj, &lp5521_group);
+}
+
+static void lp5521_unregister_sysfs(struct i2c_client *client)
+{
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	struct device *dev = &client->dev;
+	int i;
+
+	sysfs_remove_group(&dev->kobj, &lp5521_group);
+
+	for (i = 0; i < LP5521_MAX_ENGINES; i++) {
+		if (chip->engines[i].mode == LP5521_CMD_LOAD)
+			sysfs_remove_group(&dev->kobj,
+					chip->engines[i].attributes);
+	}
+
+	for (i = 0; i < chip->num_leds; i++)
+		device_remove_file(chip->leds[i].cdev.dev,
+				   &dev_attr_led_current);
+}
+
+static int __init lp5521_init_led(struct lp5521_led *led,
+				struct i2c_client *client,
+				int chan, struct lp5521_platform_data *pdata)
+{
+	struct device *dev = &client->dev;
+	char name[32];
+	int res;
+
+	if (chan >= LP5521_MAX_LEDS)
+		return -EINVAL;
+
+	if (pdata->led_config[chan].led_current == 0)
+		return 0;
+
+	led->led_current = pdata->led_config[chan].led_current;
+	led->chan_nr = pdata->led_config[chan].chan_nr;
+
+	snprintf(name, sizeof(name), "%s:channel%d", client->name, chan);
+	led->cdev.brightness_set = lp5521_set_brightness;
+	led->cdev.name = name;
+	res = led_classdev_register(dev, &led->cdev);
+	if (res < 0) {
+		dev_err(dev, "couldn't register led on channel %d\n", chan);
+		return res;
+	}
+
+	res = device_create_file(led->cdev.dev, &dev_attr_led_current);
+	if (res < 0) {
+		dev_err(dev, "couldn't register current attribute\n");
+		led_classdev_unregister(&led->cdev);
+		return res;
+	}
+	return 0;
+}
+
+static int lp5521_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct lp5521_chip		*chip;
+	struct lp5521_platform_data	*pdata;
+	int ret, i, led;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, chip);
+	chip->client = client;
+
+	pdata = client->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		ret = -EINVAL;
+		goto fail1;
+	}
+
+	mutex_init(&chip->lock);
+
+	chip->pdata   = pdata;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0)
+			goto fail1;
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		msleep(1);
+		pdata->enable(1);
+		msleep(1); /* Spec says 500us */
+	}
+
+	ret		= lp5521_detect(client);
+
+	if (ret) {
+		dev_err(&client->dev, "Chip not found\n");
+		goto fail2;
+	}
+
+	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
+
+	ret = lp5521_configure(client, lp5521_engine_group);
+	if (ret < 0) {
+		dev_err(&client->dev, "error configuring chip\n");
+		goto fail2;
+	}
+
+	/* Initialize leds */
+	chip->num_channels = pdata->num_channels;
+	chip->num_leds = 0;
+	led = 0;
+	for (i = 0; i < pdata->num_channels; i++) {
+		/* Do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		chip->num_leds++;
+		ret = lp5521_init_led(&chip->leds[led], client, i, pdata);
+		if (ret) {
+			dev_err(&client->dev, "error initializing leds\n");
+			goto fail3;
+		}
+
+		chip->leds[led].id = led;
+		/* Set initial LED current */
+		lp5521_set_led_current(chip, led,
+				chip->leds[led].led_current);
+		led++;
+	}
+
+	ret = lp5521_register_sysfs(client);
+	if (ret) {
+		dev_err(&client->dev, "registering sysfs failed\n");
+		goto fail3;
+	}
+	return ret;
+fail3:
+	for (i = 0; i < chip->num_leds; i++)
+		led_classdev_unregister(&chip->leds[i].cdev);
+fail2:
+	if (pdata->enable)
+		pdata->enable(0);
+	if (pdata->release_resources)
+		pdata->release_resources();
+fail1:
+	kfree(chip);
+	return ret;
+}
+
+static int lp5521_remove(struct i2c_client *client)
+{
+	struct lp5521_chip *chip = i2c_get_clientdata(client);
+	int i;
+
+	lp5521_unregister_sysfs(client);
+
+	for (i = 0; i < chip->num_leds; i++)
+		led_classdev_unregister(&chip->leds[i].cdev);
+
+	if (chip->pdata->enable)
+		chip->pdata->enable(0);
+	if (chip->pdata->release_resources)
+		chip->pdata->release_resources();
+	kfree(chip);
+	return 0;
+}
+
+static const struct i2c_device_id lp5521_id[] = {
+	{ "lp5521", 0 }, /* Three channel chip */
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lp5521_id);
+
+static struct i2c_driver lp5521_driver = {
+	.driver = {
+		.name	= "lp5521",
+	},
+	.probe		= lp5521_probe,
+	.remove		= lp5521_remove,
+	.id_table	= lp5521_id,
+};
+
+static int __init lp5521_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&lp5521_driver);
+
+	if (ret < 0)
+		printk(KERN_ALERT "Adding lp5521 driver failed\n");
+
+	return ret;
+}
+
+static void __exit lp5521_exit(void)
+{
+	i2c_del_driver(&lp5521_driver);
+}
+
+module_init(lp5521_init);
+module_exit(lp5521_exit);
+
+MODULE_AUTHOR("Mathias Nyman, Yuri Zaporozhets, Samu Onkalo");
+MODULE_DESCRIPTION("LP5521 LED engine");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
new file mode 100644
index 0000000..f8436be
--- /dev/null
+++ b/drivers/leds/leds-lp5523.c
@@ -0,0 +1,1005 @@
+/*
+ * lp5523.c - LP5523 LED Driver
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Author: Mathias Nyman <mathias.nyman@nokia.com>
+ * Author: Samu Onkalo <samu.p.onkalo@nokia.com>
+ * Contact: Samu Onkalo <samu.p.onkalo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/ctype.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/leds.h>
+#include <linux/leds-lp5523.h>
+
+#define LP5523_REG_ENABLE		0x00
+#define LP5523_REG_OP_MODE		0x01
+#define LP5523_REG_RATIOMETRIC_MSB	0x02
+#define LP5523_REG_RATIOMETRIC_LSB	0x03
+#define LP5523_REG_ENABLE_LEDS_MSB	0x04
+#define LP5523_REG_ENABLE_LEDS_LSB	0x05
+#define LP5523_REG_LED_CNTRL_BASE	0x06
+#define LP5523_REG_LED_PWM_BASE		0x16
+#define LP5523_REG_LED_CURRENT_BASE	0x26
+#define LP5523_REG_CONFIG		0x36
+#define LP5523_REG_CHANNEL1_PC		0x37
+#define LP5523_REG_CHANNEL2_PC		0x38
+#define LP5523_REG_CHANNEL3_PC		0x39
+#define LP5523_REG_STATUS		0x3a
+#define LP5523_REG_GPO			0x3b
+#define LP5523_REG_VARIABLE		0x3c
+#define LP5523_REG_RESET		0x3d
+#define LP5523_REG_TEMP_CTRL		0x3e
+#define LP5523_REG_TEMP_READ		0x3f
+#define LP5523_REG_TEMP_WRITE		0x40
+#define LP5523_REG_LED_TEST_CTRL	0x41
+#define LP5523_REG_LED_TEST_ADC		0x42
+#define LP5523_REG_ENG1_VARIABLE	0x45
+#define LP5523_REG_ENG2_VARIABLE	0x46
+#define LP5523_REG_ENG3_VARIABLE	0x47
+#define LP5523_REG_MASTER_FADER1	0x48
+#define LP5523_REG_MASTER_FADER2	0x49
+#define LP5523_REG_MASTER_FADER3	0x4a
+#define LP5523_REG_CH1_PROG_START	0x4c
+#define LP5523_REG_CH2_PROG_START	0x4d
+#define LP5523_REG_CH3_PROG_START	0x4e
+#define LP5523_REG_PROG_PAGE_SEL	0x4f
+#define LP5523_REG_PROG_MEM		0x50
+
+#define LP5523_CMD_LOAD			0x15 /* 00010101 */
+#define LP5523_CMD_RUN			0x2a /* 00101010 */
+#define LP5523_CMD_DISABLED		0x00 /* 00000000 */
+
+#define LP5523_ENABLE			0x40
+#define LP5523_AUTO_INC			0x40
+#define LP5523_PWR_SAVE			0x20
+#define LP5523_PWM_PWR_SAVE		0x04
+#define LP5523_CP_1			0x08
+#define LP5523_CP_1_5			0x10
+#define LP5523_CP_AUTO			0x18
+#define LP5523_INT_CLK			0x01
+#define LP5523_AUTO_CLK			0x02
+#define LP5523_EN_LEDTEST		0x80
+#define LP5523_LEDTEST_DONE		0x80
+
+#define LP5523_DEFAULT_CURRENT		50 /* microAmps */
+#define LP5523_PROGRAM_LENGTH		32 /* in bytes */
+#define LP5523_PROGRAM_PAGES		6
+#define LP5523_ADC_SHORTCIRC_LIM	80
+
+#define LP5523_LEDS			9
+#define LP5523_ENGINES			3
+
+#define LP5523_ENG_MASK_BASE		0x30 /* 00110000 */
+
+#define LP5523_ENG_STATUS_MASK          0x07 /* 00000111 */
+
+#define LP5523_IRQ_FLAGS                IRQF_TRIGGER_FALLING
+
+#define LP5523_EXT_CLK_USED		0x08
+
+#define LED_ACTIVE(mux, led)		(!!(mux & (0x0001 << led)))
+#define SHIFT_MASK(id)			(((id) - 1) * 2)
+
+struct lp5523_engine {
+	const struct attribute_group *attributes;
+	int		id;
+	u8		mode;
+	u8		prog_page;
+	u8		mux_page;
+	u16		led_mux;
+	u8		engine_mask;
+};
+
+struct lp5523_led {
+	int			id;
+	u8			chan_nr;
+	u8			led_current;
+	struct led_classdev     cdev;
+};
+
+struct lp5523_chip {
+	struct mutex		lock; /* protect against parallel control */
+	struct i2c_client	*client;
+	struct lp5523_engine	engines[LP5523_ENGINES];
+	struct lp5523_led	leds[LP5523_LEDS];
+	struct lp5523_platform_data *pdata;
+	u8			num_channels;
+	u8			num_leds;
+};
+
+#define cdev_to_led(c)          container_of(c, struct lp5523_led, cdev)
+
+static struct lp5523_chip *engine_to_lp5523(struct lp5523_engine *engine)
+{
+	return container_of(engine, struct lp5523_chip,
+			    engines[engine->id - 1]);
+}
+
+static struct lp5523_chip *led_to_lp5523(struct lp5523_led *led)
+{
+	return container_of(led, struct lp5523_chip,
+			    leds[led->id]);
+}
+
+static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode);
+static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode);
+static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern);
+
+static int lp5523_write(struct i2c_client *client, u8 reg, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int lp5523_read(struct i2c_client *client, u8 reg, u8 *buf)
+{
+	s32 ret = i2c_smbus_read_byte_data(client, reg);
+
+	if (ret < 0)
+		return -EIO;
+
+	*buf = ret;
+	return 0;
+}
+
+static int lp5523_detect(struct i2c_client *client)
+{
+	int ret;
+	u8 buf;
+
+	ret = lp5523_write(client, LP5523_REG_ENABLE, 0x40);
+	if (ret)
+		return ret;
+	ret = lp5523_read(client, LP5523_REG_ENABLE, &buf);
+	if (ret)
+		return ret;
+	if (buf == 0x40)
+		return 0;
+	else
+		return -ENODEV;
+}
+
+static int lp5523_configure(struct i2c_client *client)
+{
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	int ret = 0;
+	u8 status;
+
+	/* one pattern per engine setting led mux start and stop addresses */
+	u8 pattern[][LP5523_PROGRAM_LENGTH] =  {
+		{ 0x9c, 0x30, 0x9c, 0xb0, 0x9d, 0x80, 0xd8, 0x00, 0},
+		{ 0x9c, 0x40, 0x9c, 0xc0, 0x9d, 0x80, 0xd8, 0x00, 0},
+		{ 0x9c, 0x50, 0x9c, 0xd0, 0x9d, 0x80, 0xd8, 0x00, 0},
+	};
+
+	lp5523_write(client, LP5523_REG_RESET, 0xff);
+
+	msleep(10);
+
+	ret |= lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
+	/* Chip startup time after reset is 500 us */
+	msleep(1);
+
+	ret |= lp5523_write(client, LP5523_REG_CONFIG,
+			    LP5523_AUTO_INC | LP5523_PWR_SAVE |
+			    LP5523_CP_AUTO | LP5523_AUTO_CLK |
+			    LP5523_PWM_PWR_SAVE);
+
+	/* turn on all leds */
+	ret |= lp5523_write(client, LP5523_REG_ENABLE_LEDS_MSB, 0x01);
+	ret |= lp5523_write(client, LP5523_REG_ENABLE_LEDS_LSB, 0xff);
+
+	/* hardcode 32 bytes of memory for each engine from program memory */
+	ret |= lp5523_write(client, LP5523_REG_CH1_PROG_START, 0x00);
+	ret |= lp5523_write(client, LP5523_REG_CH2_PROG_START, 0x10);
+	ret |= lp5523_write(client, LP5523_REG_CH3_PROG_START, 0x20);
+
+	/* write led mux address space for each channel */
+	ret |= lp5523_load_program(&chip->engines[0], pattern[0]);
+	ret |= lp5523_load_program(&chip->engines[1], pattern[1]);
+	ret |= lp5523_load_program(&chip->engines[2], pattern[2]);
+
+	if (ret) {
+		dev_err(&client->dev, "could not load mux programs\n");
+		return -1;
+	}
+
+	/* set all engines exec state and mode to run 00101010 */
+	ret |= lp5523_write(client, LP5523_REG_ENABLE,
+			    (LP5523_CMD_RUN | LP5523_ENABLE));
+
+	ret |= lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_RUN);
+
+	if (ret) {
+		dev_err(&client->dev, "could not start mux programs\n");
+		return -1;
+	}
+
+	/* Wait 3ms and check the engine status */
+	msleep(3);
+	lp5523_read(client, LP5523_REG_STATUS, &status);
+	status &= LP5523_ENG_STATUS_MASK;
+
+	if (status == LP5523_ENG_STATUS_MASK) {
+		dev_dbg(&client->dev, "all engines configured\n");
+	} else {
+		dev_info(&client->dev, "status == %x\n", status);
+		dev_err(&client->dev, "cound not configure LED engine\n");
+		return -1;
+	}
+
+	dev_info(&client->dev, "disabling engines\n");
+
+	ret |= lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
+
+	return ret;
+}
+
+static int lp5523_set_engine_mode(struct lp5523_engine *engine, u8 mode)
+{
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+	int ret;
+	u8 engine_state;
+
+	ret = lp5523_read(client, LP5523_REG_OP_MODE, &engine_state);
+	if (ret)
+		goto fail;
+
+	engine_state &= ~(engine->engine_mask);
+
+	/* set mode only for this engine */
+	mode &= engine->engine_mask;
+
+	engine_state |= mode;
+
+	ret |= lp5523_write(client, LP5523_REG_OP_MODE, engine_state);
+fail:
+	return ret;
+}
+
+static int lp5523_load_mux(struct lp5523_engine *engine, u16 mux)
+{
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+	int ret = 0;
+
+	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
+
+	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL, engine->mux_page);
+	ret |= lp5523_write(client, LP5523_REG_PROG_MEM,
+			    (u8)(mux >> 8));
+	ret |= lp5523_write(client, LP5523_REG_PROG_MEM + 1, (u8)(mux));
+	engine->led_mux = mux;
+
+	return ret;
+}
+
+static int lp5523_load_program(struct lp5523_engine *engine, u8 *pattern)
+{
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+
+	int ret = 0;
+
+	ret |= lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
+
+	ret |= lp5523_write(client, LP5523_REG_PROG_PAGE_SEL,
+			    engine->prog_page);
+	ret |= i2c_smbus_write_i2c_block_data(client, LP5523_REG_PROG_MEM,
+					      LP5523_PROGRAM_LENGTH, pattern);
+
+	return ret;
+}
+
+static int lp5523_run_program(struct lp5523_engine *engine)
+{
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+	int ret;
+
+	ret = lp5523_write(client, LP5523_REG_ENABLE,
+					LP5523_CMD_RUN | LP5523_ENABLE);
+	if (ret)
+		goto fail;
+
+	ret = lp5523_set_engine_mode(engine, LP5523_CMD_RUN);
+fail:
+	return ret;
+}
+
+static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
+{
+	int i;
+	u16 tmp_mux = 0;
+	len = len < LP5523_LEDS ? len : LP5523_LEDS;
+	for (i = 0; i < len; i++) {
+		switch (buf[i]) {
+		case '1':
+			tmp_mux |= (1 << i);
+			break;
+		case '0':
+			break;
+		case '\n':
+			i = len;
+			break;
+		default:
+			return -1;
+		}
+	}
+	*mux = tmp_mux;
+
+	return 0;
+}
+
+static void lp5523_mux_to_array(u16 led_mux, char *array)
+{
+	int i, pos = 0;
+	for (i = 0; i < LP5523_LEDS; i++)
+		pos += sprintf(array + pos, "%x", LED_ACTIVE(led_mux, i));
+
+	array[pos] = '\0';
+}
+
+/*--------------------------------------------------------------*/
+/*			Sysfs interface				*/
+/*--------------------------------------------------------------*/
+
+static ssize_t show_engine_leds(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	char mux[LP5523_LEDS + 1];
+
+	lp5523_mux_to_array(chip->engines[nr - 1].led_mux, mux);
+
+	return sprintf(buf, "%s\n", mux);
+}
+
+#define show_leds(nr)							\
+static ssize_t show_engine##nr##_leds(struct device *dev,		\
+			    struct device_attribute *attr,		\
+			    char *buf)					\
+{									\
+	return show_engine_leds(dev, attr, buf, nr);			\
+}
+show_leds(1)
+show_leds(2)
+show_leds(3)
+
+static ssize_t store_engine_leds(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	u16 mux = 0;
+
+	if (lp5523_mux_parse(buf, &mux, len))
+		return -EINVAL;
+
+	if (lp5523_load_mux(&chip->engines[nr - 1], mux))
+		return -EINVAL;
+
+	return len;
+}
+
+#define store_leds(nr)						\
+static ssize_t store_engine##nr##_leds(struct device *dev,	\
+			     struct device_attribute *attr,	\
+			     const char *buf, size_t len)	\
+{								\
+	return store_engine_leds(dev, attr, buf, len, nr);	\
+}
+store_leds(1)
+store_leds(2)
+store_leds(3)
+
+static ssize_t lp5523_selftest(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	int i, ret, pos = 0;
+	u8 status, adc, vdd;
+
+	mutex_lock(&chip->lock);
+
+	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+	if (ret < 0)
+		goto fail;
+
+	/* Check that ext clock is really in use if requested */
+	if ((chip->pdata) && (chip->pdata->clock_mode == LP5523_CLOCK_EXT))
+		if  ((status & LP5523_EXT_CLK_USED) == 0)
+			goto fail;
+
+	/* Measure VDD (i.e. VBAT) first (channel 16 corresponds to VDD) */
+	lp5523_write(chip->client, LP5523_REG_LED_TEST_CTRL,
+				    LP5523_EN_LEDTEST | 16);
+	msleep(3);
+	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+	if (!(status & LP5523_LEDTEST_DONE))
+		msleep(3);
+
+	ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	vdd--;	/* There may be some fluctuation in measurement */
+
+	for (i = 0; i < LP5523_LEDS; i++) {
+		/* Skip non-existing channels */
+		if (chip->pdata->led_config[i].led_current == 0)
+			continue;
+
+		lp5523_write(chip->client, LP5523_REG_LED_PWM_BASE + i, 0xff);
+		/* let current stabilize 2ms before measurements start */
+		msleep(2);
+		lp5523_write(chip->client,
+			     LP5523_REG_LED_TEST_CTRL,
+			     LP5523_EN_LEDTEST | i);
+		/* ledtest takes 2.7ms */
+		msleep(3);
+		ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+		if (!(status & LP5523_LEDTEST_DONE))
+			msleep(3);
+		ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &adc);
+
+		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
+			pos += sprintf(buf + pos, "LED %d FAIL\n", i);
+
+		lp5523_write(chip->client, LP5523_REG_LED_PWM_BASE + i, 0x00);
+	}
+	if (pos == 0)
+		pos = sprintf(buf, "OK\n");
+	goto release_lock;
+fail:
+	pos = sprintf(buf, "FAIL\n");
+
+release_lock:
+	mutex_unlock(&chip->lock);
+
+	return pos;
+}
+
+static void lp5523_set_brightness(struct led_classdev *cdev,
+			     enum led_brightness brightness)
+{
+	struct lp5523_led *led = cdev_to_led(cdev);
+	struct lp5523_chip *chip = led_to_lp5523(led);
+	struct i2c_client *client = chip->client;
+
+	mutex_lock(&chip->lock);
+
+	lp5523_write(client, LP5523_REG_LED_PWM_BASE + led->chan_nr,
+		     (u8)brightness);
+
+	mutex_unlock(&chip->lock);
+}
+
+static int lp5523_do_store_load(struct lp5523_engine *engine,
+				const char *buf, size_t len)
+{
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+	int  ret, nrchars, offset = 0, i = 0;
+	char c[3];
+	unsigned cmd;
+	u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
+
+	while ((offset < len - 1) && (i < LP5523_PROGRAM_LENGTH)) {
+		/* separate sscanfs because length is working only for %s */
+		ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
+		ret = sscanf(c, "%2x", &cmd);
+		if (ret != 1)
+			goto fail;
+		pattern[i] = (u8)cmd;
+
+		offset += nrchars;
+		i++;
+	}
+
+	/* pattern commands are always two bytes long */
+	if (i % 2)
+		goto fail;
+
+	mutex_lock(&chip->lock);
+
+	ret = lp5523_load_program(engine, pattern);
+	mutex_unlock(&chip->lock);
+
+	if (ret) {
+		dev_err(&client->dev, "failed loading pattern\n");
+		return ret;
+	}
+
+	return len;
+fail:
+	dev_err(&client->dev, "wrong pattern format\n");
+	return -EINVAL;
+}
+
+static ssize_t store_engine_load(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	return lp5523_do_store_load(&chip->engines[nr - 1], buf, len);
+}
+
+#define store_load(nr)							\
+static ssize_t store_engine##nr##_load(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t len)	\
+{									\
+	return store_engine_load(dev, attr, buf, len, nr);		\
+}
+store_load(1)
+store_load(2)
+store_load(3)
+
+static ssize_t show_engine_mode(struct device *dev,
+				struct device_attribute *attr,
+				char *buf, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	switch (chip->engines[nr - 1].mode) {
+	case LP5523_CMD_RUN:
+		return sprintf(buf, "run\n");
+	case LP5523_CMD_LOAD:
+		return sprintf(buf, "load\n");
+	case LP5523_CMD_DISABLED:
+		return sprintf(buf, "disabled\n");
+	default:
+		return sprintf(buf, "disabled\n");
+	}
+}
+
+#define show_mode(nr)							\
+static ssize_t show_engine##nr##_mode(struct device *dev,		\
+				    struct device_attribute *attr,	\
+				    char *buf)				\
+{									\
+	return show_engine_mode(dev, attr, buf, nr);			\
+}
+show_mode(1)
+show_mode(2)
+show_mode(3)
+
+static ssize_t store_engine_mode(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len, int nr)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	struct lp5523_engine *engine = &chip->engines[nr - 1];
+	mutex_lock(&chip->lock);
+
+	if (!strncmp(buf, "run", 3))
+		lp5523_set_mode(engine, LP5523_CMD_RUN);
+	else if (!strncmp(buf, "load", 4))
+		lp5523_set_mode(engine, LP5523_CMD_LOAD);
+	else if (!strncmp(buf, "disabled", 8))
+		lp5523_set_mode(engine, LP5523_CMD_DISABLED);
+
+	mutex_unlock(&chip->lock);
+	return len;
+}
+
+#define store_mode(nr)							\
+static ssize_t store_engine##nr##_mode(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t len)	\
+{									\
+	return store_engine_mode(dev, attr, buf, len, nr);		\
+}
+store_mode(1)
+store_mode(2)
+store_mode(3)
+
+static ssize_t show_current(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lp5523_led *led = cdev_to_led(led_cdev);
+
+	return sprintf(buf, "%d\n", led->led_current);
+}
+
+static ssize_t store_current(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lp5523_led *led = cdev_to_led(led_cdev);
+	struct lp5523_chip *chip = led_to_lp5523(led);
+	ssize_t ret;
+	unsigned long curr;
+
+	if (strict_strtoul(buf, 0, &curr))
+		return -EINVAL;
+
+	if (curr > 255)
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	ret = lp5523_write(chip->client,
+			LP5523_REG_LED_CURRENT_BASE + led->chan_nr,
+			(u8)curr);
+	mutex_unlock(&chip->lock);
+
+	if (ret < 0)
+		return ret;
+
+	led->led_current = (u8)curr;
+
+	return len;
+}
+
+/* led class device attributes */
+static DEVICE_ATTR(led_current, S_IRUGO | S_IWUGO, show_current, store_current);
+
+/* device attributes */
+static DEVICE_ATTR(engine1_mode, S_IRUGO | S_IWUGO,
+		   show_engine1_mode, store_engine1_mode);
+static DEVICE_ATTR(engine2_mode, S_IRUGO | S_IWUGO,
+		   show_engine2_mode, store_engine2_mode);
+static DEVICE_ATTR(engine3_mode, S_IRUGO | S_IWUGO,
+		   show_engine3_mode, store_engine3_mode);
+static DEVICE_ATTR(engine1_leds, S_IRUGO | S_IWUGO,
+		   show_engine1_leds, store_engine1_leds);
+static DEVICE_ATTR(engine2_leds, S_IRUGO | S_IWUGO,
+		   show_engine2_leds, store_engine2_leds);
+static DEVICE_ATTR(engine3_leds, S_IRUGO | S_IWUGO,
+		   show_engine3_leds, store_engine3_leds);
+static DEVICE_ATTR(engine1_load, S_IWUGO, NULL, store_engine1_load);
+static DEVICE_ATTR(engine2_load, S_IWUGO, NULL, store_engine2_load);
+static DEVICE_ATTR(engine3_load, S_IWUGO, NULL, store_engine3_load);
+static DEVICE_ATTR(selftest, S_IRUGO, lp5523_selftest, NULL);
+
+static struct attribute *lp5523_attributes[] = {
+	&dev_attr_engine1_mode.attr,
+	&dev_attr_engine2_mode.attr,
+	&dev_attr_engine3_mode.attr,
+	&dev_attr_selftest.attr,
+	NULL
+};
+
+static struct attribute *lp5523_engine1_attributes[] = {
+	&dev_attr_engine1_load.attr,
+	&dev_attr_engine1_leds.attr,
+	NULL
+};
+
+static struct attribute *lp5523_engine2_attributes[] = {
+	&dev_attr_engine2_load.attr,
+	&dev_attr_engine2_leds.attr,
+	NULL
+};
+
+static struct attribute *lp5523_engine3_attributes[] = {
+	&dev_attr_engine3_load.attr,
+	&dev_attr_engine3_leds.attr,
+	NULL
+};
+
+static const struct attribute_group lp5523_group = {
+	.attrs = lp5523_attributes,
+};
+
+static const struct attribute_group lp5523_engine_group[] = {
+	{.attrs = lp5523_engine1_attributes },
+	{.attrs = lp5523_engine2_attributes },
+	{.attrs = lp5523_engine3_attributes },
+};
+
+static int lp5523_register_sysfs(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	int ret;
+
+	ret = sysfs_create_group(&dev->kobj, &lp5523_group);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void lp5523_unregister_sysfs(struct i2c_client *client)
+{
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	struct device *dev = &client->dev;
+	int i;
+
+	sysfs_remove_group(&dev->kobj, &lp5523_group);
+
+	for (i = 0; i < LP5523_ENGINES; i++) {
+		if (chip->engines[i].mode == LP5523_CMD_LOAD)
+			sysfs_remove_group(&dev->kobj, &lp5523_engine_group[i]);
+	}
+
+	for (i = 0; i < chip->num_leds; i++)
+		device_remove_file(chip->leds[i].cdev.dev,
+				   &dev_attr_led_current);
+}
+
+/*--------------------------------------------------------------*/
+/*			Set chip operating mode			*/
+/*--------------------------------------------------------------*/
+static int lp5523_set_mode(struct lp5523_engine *engine, u8 mode)
+{
+	/*  engine to chip */
+	struct lp5523_chip *chip = engine_to_lp5523(engine);
+	struct i2c_client *client = chip->client;
+	struct device *dev = &client->dev;
+	int ret = 0;
+
+	/* if in that mode already do nothing, except for run */
+	if (mode == engine->mode && mode != LP5523_CMD_RUN)
+		return 0;
+
+	if (mode == LP5523_CMD_RUN)
+		ret = lp5523_run_program(engine);
+
+	else if (mode == LP5523_CMD_LOAD) {
+
+		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
+		lp5523_set_engine_mode(engine, LP5523_CMD_LOAD);
+
+		ret = sysfs_create_group(&dev->kobj, engine->attributes);
+		if (ret)
+			return ret;
+	}
+
+	else if (mode == LP5523_CMD_DISABLED)
+		lp5523_set_engine_mode(engine, LP5523_CMD_DISABLED);
+
+	/* remove load attribute from sysfs if not in load mode */
+	if (engine->mode == LP5523_CMD_LOAD && mode != LP5523_CMD_LOAD)
+		sysfs_remove_group(&dev->kobj, engine->attributes);
+
+	engine->mode = mode;
+
+	return ret;
+}
+
+/*--------------------------------------------------------------*/
+/*			Probe, Attach, Remove			*/
+/*--------------------------------------------------------------*/
+static int __init lp5523_init_engine(struct lp5523_engine *engine, int id)
+{
+	if (id < 1 || id > LP5523_ENGINES)
+		return -1;
+	engine->id = id;
+	engine->engine_mask = LP5523_ENG_MASK_BASE >> SHIFT_MASK(id);
+	engine->prog_page = id - 1;
+	engine->mux_page = id + 2;
+	engine->attributes = &lp5523_engine_group[id - 1];
+
+	return 0;
+}
+
+static int __init lp5523_init_led(struct lp5523_led *led, struct device *dev,
+			   int chan, struct lp5523_platform_data *pdata)
+{
+	char name[32];
+	int res;
+
+	if (chan >= LP5523_LEDS)
+		return -EINVAL;
+
+	if (pdata->led_config[chan].led_current) {
+		led->led_current = pdata->led_config[chan].led_current;
+		led->chan_nr = pdata->led_config[chan].chan_nr;
+
+		snprintf(name, 32, "lp5523:channel%d", chan);
+
+		led->cdev.name = name;
+		led->cdev.brightness_set = lp5523_set_brightness;
+		res = led_classdev_register(dev, &led->cdev);
+		if (res < 0) {
+			dev_err(dev, "couldn't register led on channed %d\n",
+				chan);
+			return res;
+		}
+		res = device_create_file(led->cdev.dev, &dev_attr_led_current);
+		if (res < 0) {
+			dev_err(dev, "couldn't register current attribute\n");
+			led_classdev_unregister(&led->cdev);
+			return res;
+		}
+	} else {
+		led->led_current = 0;
+	}
+	return 0;
+}
+
+static struct i2c_driver lp5523_driver;
+
+static int lp5523_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct lp5523_chip		*chip;
+	struct lp5523_platform_data	*pdata;
+	int ret, i, led;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, chip);
+	chip->client = client;
+
+	pdata = client->dev.platform_data;
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data\n");
+		ret = -EINVAL;
+		goto fail1;
+	}
+
+	mutex_init(&chip->lock);
+
+	chip->pdata   = pdata;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0)
+			goto fail1;
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		msleep(1);
+		pdata->enable(1);
+		msleep(1); /* Spec says 500us */
+	}
+
+	ret = lp5523_detect(client);
+	if (ret)
+		goto fail2;
+
+	dev_info(&client->dev, "LP5523 Programmable led chip found\n");
+
+	/* Initialize engines */
+	for (i = 0; i < LP5523_ENGINES; i++) {
+		ret = lp5523_init_engine(&chip->engines[i], i + 1);
+		if (ret) {
+			dev_err(&client->dev, "error initializing engine\n");
+			goto fail2;
+		}
+	}
+	ret = lp5523_configure(client);
+	if (ret < 0) {
+		dev_err(&client->dev, "error configuring chip\n");
+		goto fail2;
+	}
+
+	/* Initialize leds */
+	chip->num_channels = pdata->num_channels;
+	chip->num_leds = 0;
+	led = 0;
+	for (i = 0; i < pdata->num_channels; i++) {
+		/* Do not initialize channels that are not connected */
+		if (pdata->led_config[i].led_current == 0)
+			continue;
+
+		chip->num_leds++;
+		ret = lp5523_init_led(&chip->leds[led], &client->dev, i, pdata);
+		if (ret) {
+			dev_err(&client->dev, "error initializing leds\n");
+			goto fail3;
+		}
+
+		chip->leds[led].id = led;
+		/* Set LED current */
+		lp5523_write(client,
+			  LP5523_REG_LED_CURRENT_BASE + chip->leds[led].chan_nr,
+			  chip->leds[led].led_current);
+		led++;
+	}
+
+	ret = lp5523_register_sysfs(client);
+	if (ret) {
+		dev_err(&client->dev, "registering sysfs failed\n");
+		goto fail3;
+	}
+	return ret;
+fail3:
+	for (i = 0; i < chip->num_leds; i++)
+		led_classdev_unregister(&chip->leds[i].cdev);
+fail2:
+	if (pdata->enable)
+		pdata->enable(0);
+	if (pdata->release_resources)
+		pdata->release_resources();
+fail1:
+	kfree(chip);
+	return ret;
+}
+
+static int lp5523_remove(struct i2c_client *client)
+{
+	struct lp5523_chip *chip = i2c_get_clientdata(client);
+	int i;
+
+	lp5523_unregister_sysfs(client);
+
+	for (i = 0; i < chip->num_leds; i++)
+		led_classdev_unregister(&chip->leds[i].cdev);
+
+	if (chip->pdata->enable)
+		chip->pdata->enable(0);
+	if (chip->pdata->release_resources)
+		chip->pdata->release_resources();
+	kfree(chip);
+	return 0;
+}
+
+static const struct i2c_device_id lp5523_id[] = {
+	{ "lp5523", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, lp5523_id);
+
+static struct i2c_driver lp5523_driver = {
+	.driver = {
+		.name	= "lp5523",
+	},
+	.probe		= lp5523_probe,
+	.remove		= lp5523_remove,
+	.id_table	= lp5523_id,
+};
+
+static int __init lp5523_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&lp5523_driver);
+
+	if (ret < 0)
+		printk(KERN_ALERT "Adding lp5523 driver failed\n");
+
+	return ret;
+}
+
+static void __exit lp5523_exit(void)
+{
+	i2c_del_driver(&lp5523_driver);
+}
+
+module_init(lp5523_init);
+module_exit(lp5523_exit);
+
+MODULE_AUTHOR("Mathias Nyman, Samu Onkalo");
+MODULE_DESCRIPTION("LP5523 LED engine");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
new file mode 100644
index 0000000..dab011f
--- /dev/null
+++ b/include/linux/leds-lp5521.h
@@ -0,0 +1,23 @@
+#ifndef __LINUX_LP5521_H
+#define __LINUX_LP5521_H
+
+struct lp5521_led_config {
+	u8		chan_nr;
+	u8		led_current; /* mA x10, 0 if led is not connected */
+};
+
+#define LP5521_CLOCK_AUTO	0
+#define LP5521_CLOCK_INT	1
+#define LP5521_CLOCK_EXT	2
+
+struct lp5521_platform_data {
+	struct lp5521_led_config *led_config;
+	u8	num_channels;
+	u8	clock_mode;
+	int	(*setup_resources)(void);
+	void	(*release_resources)(void);
+	void	(*enable)(bool state);
+};
+
+#endif /* __LINUX_LP5521_H */
+
diff --git a/include/linux/leds-lp5523.h b/include/linux/leds-lp5523.h
new file mode 100644
index 0000000..34a57f2
--- /dev/null
+++ b/include/linux/leds-lp5523.h
@@ -0,0 +1,23 @@
+#ifndef __LINUX_LP5523_H
+#define __LINUX_LP5523_H
+
+struct lp5523_led_config {
+	u8		chan_nr;
+	u8		led_current; /* mA x10, 0 if led is not connected */
+};
+
+#define LP5523_CLOCK_AUTO	0
+#define LP5523_CLOCK_INT	1
+#define LP5523_CLOCK_EXT	2
+
+struct lp5523_platform_data {
+	struct lp5523_led_config *led_config;
+	u8	num_channels;
+	u8	clock_mode;
+	int	(*setup_resources)(void);
+	void	(*release_resources)(void);
+	void	(*enable)(bool state);
+};
+
+#endif /* __LINUX_LP5523_H */
+
-- 
1.6.3.3

