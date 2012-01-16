Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab2APGbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:31:10 -0500
Received: from mail2.nsc.com ([12.238.8.132]:48636 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750728Ab2APGbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:31:08 -0500
X-WSS-ID: 0LXVORQ-0A-15R-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
cc: "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "Kim, Milo" <Milo.Kim@nsc.com>
Date: Sun, 15 Jan 2012 22:30:51 -0800
Subject: RE: [PATCH] leds-lp5521: additional platform data and
 attributes
Thread-Topic: [PATCH] leds-lp5521: additional platform data and
 attributes
Thread-Index: AczMF7EM8BN2pF0QQ7CIJoVlxyiQXwAAYChgAf/E4BA=
Message-ID: <B567DBAB974C0544994013492B949F8E3812BEEBAB@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 630D1B941LS9703823-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better readability, values of LP5521_REG_ENABLE register were redefined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 8239319..3f7cfe8 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -261,8 +261,7 @@ static int lp5521_configure(struct i2c_client *client)

        /* Set engines are set to run state when OP_MODE enables engines */
        ret |= lp5521_write(client, LP5521_REG_ENABLE,
-                       LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
-                       LP5521_EXEC_RUN);
+                       LP5521_ENABLE_RUN_PROGRAM);
        /* enable takes 500us. 1 - 2 ms leaves some margin */
        usleep_range(1000, 2000);

@@ -313,8 +312,7 @@ static int lp5521_detect(struct i2c_client *client)
        int ret;
        u8 buf;

-       ret = lp5521_write(client, LP5521_REG_ENABLE,
-                       LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+       ret = lp5521_write(client, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
        if (ret)
                return ret;
        /* enable takes 500us. 1 - 2 ms leaves some margin */
@@ -322,7 +320,7 @@ static int lp5521_detect(struct i2c_client *client)
        ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
        if (ret)
                return ret;
-       if (buf != (LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM))
+       if (buf != LP5521_ENABLE_DEFAULT)
                return -ENODEV;

        return 0;
--
1.7.4.1

-----Original Message-----
From: Kim, Milo
Sent: Friday, January 06, 2012 11:20 AM
To: 'linux-kernel@vger.kernel.org'; 'rpurdie@rpsys.net'
Cc: 'linaro-dev@lists.linaro.org'; 'milo.kim@ti.com'
Subject: [PATCH] leds-lp5521: additional platform data and attributes

* Changes of lp5521_platform_data
> 'update_config' is added
> 'name' is added
Value of CONFIG register(Addr 08h) and name of led channels are dependant on the project.
So these fields have been added in lp5521_platform_data.
> led pattern data
lp5521 has autonomous operation mode without external control.
This patch includes how to configure the led patterns and load them.

* Additional led class device attributes : delay_on, delay_off, blink
For supporting blink mode, 3 attributes have been updated.

* Additional i2c device attribute : led_pattern
Platform specific led pattern can be loaded via the user-space.

* Base kernel version : 3.0.9

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/leds-lp5521.txt |   60 ++++++++++
 drivers/leds/leds-lp5521.c         |  222 +++++++++++++++++++++++++++++++++---
 include/linux/leds-lp5521.h        |   25 ++++
 3 files changed, 289 insertions(+), 18 deletions(-)

diff --git a/Documentation/leds/leds-lp5521.txt b/Documentation/leds/leds-lp5521.txt
index c4d8d15..b0d6abe 100644
--- a/Documentation/leds/leds-lp5521.txt
+++ b/Documentation/leds/leds-lp5521.txt
@@ -3,6 +3,7 @@ Kernel driver for lp5521

 * National Semiconductor LP5521 led driver chip
 * Datasheet: http://www.national.com/pf/LP/LP5521.html
+       or http://www.ti.com/product/lp5521

 Authors: Mathias Nyman, Yuri Zaporozhets, Samu Onkalo
 Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
@@ -43,17 +44,23 @@ Format: 10x mA i.e 10 means 1.0 mA
 example platform data:

 Note: chan_nr can have values between 0 and 2.
+Each channel can have own name.
+If name field is not defined, the default name will be set to 'xxxx:channelN'
+(XXXX : pdata->label or i2c client name, N : channel number)

 static struct lp5521_led_config lp5521_led_config[] = {
         {
+               .name = "red",
                 .chan_nr        = 0,
                 .led_current    = 50,
                .max_current    = 130,
         }, {
+               .name = "green",
                 .chan_nr        = 1,
                 .led_current    = 0,
                .max_current    = 130,
         }, {
+               .name = "blue",
                 .chan_nr        = 2,
                 .led_current    = 0,
                .max_current    = 130,
@@ -86,3 +93,56 @@ static struct lp5521_platform_data lp5521_platform_data = {

 If the current is set to 0 in the platform data, that channel is
 disabled and it is not visible in the sysfs.
+
+update_config : CONFIG register (ADDR 08h)
+This value is platform-specific data. If NULL, the default value will be set.
+
+example)
+
+#define LP5521_CONFIGS (LP5521_PWM_HF | LP5521_PWRSAVE_EN | \
+                       LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT | \
+                       LP5521_CLK_INT)
+
+static struct lp5521_platform_data lp5521_pdata = {
+       .led_config = lp5521_led_config,
+       .num_channels = ARRAY_SIZE(lp5521_led_config),
+       .clock_mode = LP5521_CLOCK_INT,
+       .update_config = LP5521_CONFIGS,
+};
+
+LED patterns : LP5521 has autonomous operation without external control.
+Pattern data can be defined in the platform data.
+
+example)
+/* Pattern : RGB(50,5,0) 500ms on, 500ms off, infinite loop */
+static u8 pattern_red[] = {
+               0x40, 0x32, 0x60, 0x00, 0x40, 0x00, 0x60, 0x00,
+               };
+
+static u8 pattern_green[] = {
+               0x40, 0x05, 0x60, 0x00, 0x40, 0x00, 0x60, 0x00,
+               };
+
+static struct lp5521_led_pattern board_led_patterns[] = {
+       {
+               .r = pattern_r,
+               .g = pattern_g,
+               .size_r = ARRAY_SIZE(pattern_r),
+               .size_g = ARRAY_SIZE(pattern_g),
+       },
+};
+
+static struct lp5521_platform_data lp5521_platform_data = {
+        .led_config     = lp5521_led_config,
+        .num_channels   = ARRAY_SIZE(lp5521_led_config),
+        .clock_mode     = LP5521_CLOCK_EXT,
+       .patterns = board_led_patterns,
+       .num_patterns = ARRAY_SIZE(board_led_patterns),
+};
+
+Then the predefined led pattern can be executed via the user-space.
+To start the pattern #1,
+# echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern
+(xxxx : i2c bus & slave address)
+To end the pattern,
+# echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index cc1dc48..8239319 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -80,23 +80,23 @@
 /* Bits in ENABLE register */
 #define LP5521_MASTER_ENABLE           0x40    /* Chip master enable */
 #define LP5521_LOGARITHMIC_PWM         0x80    /* Logarithmic PWM adjustment */
+#define LP5521_EXEC_MASK               0xC0
 #define LP5521_EXEC_RUN                        0x2A
-
-/* Bits in CONFIG register */
-#define LP5521_PWM_HF                  0x40    /* PWM: 0 = 256Hz, 1 = 558Hz */
-#define LP5521_PWRSAVE_EN              0x20    /* 1 = Power save mode */
-#define LP5521_CP_MODE_OFF             0       /* Charge pump (CP) off */
-#define LP5521_CP_MODE_BYPASS          8       /* CP forced to bypass mode */
-#define LP5521_CP_MODE_1X5             0x10    /* CP forced to 1.5x mode */
-#define LP5521_CP_MODE_AUTO            0x18    /* Automatic mode selection */
-#define LP5521_R_TO_BATT               4       /* R out: 0 = CP, 1 = Vbat */
-#define LP5521_CLK_SRC_EXT             0       /* Ext-clk source (CLK_32K) */
-#define LP5521_CLK_INT                 1       /* Internal clock */
-#define LP5521_CLK_AUTO                        2       /* Automatic clock selection */
+#define LP5521_EXEC_HOLD               0x00
+#define LP5521_ENABLE_DEFAULT  \
+       (LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM)
+#define LP5521_ENABLE_RUN_PROGRAM      \
+       (LP5521_ENABLE_DEFAULT | LP5521_EXEC_RUN)

 /* Status */
 #define LP5521_EXT_CLK_USED            0x08

+/* Blink mode */
+#define ALWAYS_OFF     0
+
+/* Pattern Mode */
+#define PATTERN_OFF    0
+
 struct lp5521_engine {
        int             id;
        u8              mode;
@@ -112,6 +112,8 @@ struct lp5521_led {
        struct led_classdev     cdev;
        struct work_struct      brightness_work;
        u8                      brightness;
+       int                     delay_on;
+       int                     delay_off;
 };

 struct lp5521_chip {
@@ -237,6 +239,7 @@ static void lp5521_init_engine(struct lp5521_chip *chip)
 static int lp5521_configure(struct i2c_client *client)
 {
        struct lp5521_chip *chip = i2c_get_clientdata(client);
+       u8 cfg = chip->pdata->update_config;
        int ret;

        lp5521_init_engine(chip);
@@ -244,9 +247,12 @@ static int lp5521_configure(struct i2c_client *client)
        /* Set all PWMs to direct control mode */
        ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);

-       /* Enable auto-powersave, set charge pump to auto, red to battery */
-       ret |= lp5521_write(client, LP5521_REG_CONFIG,
-               LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+       if (cfg)
+               ret |= lp5521_write(client, LP5521_REG_CONFIG, cfg);
+       else
+               ret |= lp5521_write(client, LP5521_REG_CONFIG,
+                       LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO |
+                       LP5521_R_TO_BATT);

        /* Initialize all channels PWM to zero -> leds off */
        ret |= lp5521_write(client, LP5521_REG_R_PWM, 0);
@@ -533,13 +539,184 @@ static ssize_t lp5521_selftest(struct device *dev,
        return sprintf(buf, "%s\n", ret ? "FAIL" : "OK");
 }

+static void lp5521_clear_program_memory(struct i2c_client *cl)
+{
+       int i;
+       u8 rgb_mem[] = {
+               LP5521_REG_R_PROG_MEM,
+               LP5521_REG_G_PROG_MEM,
+               LP5521_REG_B_PROG_MEM,
+       };
+
+       for (i = 0; i < ARRAY_SIZE(rgb_mem); i++) {
+               lp5521_write(cl, rgb_mem[i], 0);
+               lp5521_write(cl, rgb_mem[i] + 1, 0);
+       }
+}
+
+static void lp5521_write_program_memory(struct i2c_client *cl,
+                               u8 base, u8 *rgb, int size)
+{
+       int i;
+
+       if (!rgb || size <= 0)
+               return;
+
+       for (i = 0; i < size; i++)
+               lp5521_write(cl, base + i, *(rgb + i));
+
+       lp5521_write(cl, base + i, 0);
+       lp5521_write(cl, base + i + 1, 0);
+}
+
+static inline struct lp5521_led_pattern *lp5521_get_pattern
+                                       (struct lp5521_chip *chip, u8 offset)
+{
+       struct lp5521_led_pattern *pattern;
+       pattern = chip->pdata->patterns + (offset - 1);
+       return pattern;
+}
+
+static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
+{
+       struct lp5521_led_pattern *ptn;
+       struct i2c_client *cl = chip->client;
+       u8 num_patterns = chip->pdata->num_patterns;
+
+       if (mode > num_patterns || !(chip->pdata->patterns))
+               return;
+
+       if (mode == PATTERN_OFF) {
+               lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
+               usleep_range(1000, 2000);
+               lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+       } else {
+               ptn = lp5521_get_pattern(chip, mode);
+               if (!ptn)
+                       return;
+
+               lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
+               usleep_range(1000, 2000);
+
+               lp5521_clear_program_memory(cl);
+
+               lp5521_write_program_memory(cl, LP5521_REG_R_PROG_MEM,
+                                       ptn->r, ptn->size_r);
+               lp5521_write_program_memory(cl, LP5521_REG_G_PROG_MEM,
+                                       ptn->g, ptn->size_g);
+               lp5521_write_program_memory(cl, LP5521_REG_B_PROG_MEM,
+                                       ptn->b, ptn->size_b);
+
+               lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_RUN);
+               usleep_range(1000, 2000);
+               lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_RUN_PROGRAM);
+       }
+}
+
+static ssize_t store_led_pattern(struct device *dev,
+                               struct device_attribute *attr,
+                               const char *buf, size_t len)
+{
+       struct lp5521_chip *chip = i2c_get_clientdata(to_i2c_client(dev));
+       unsigned long val;
+       int ret;
+
+       ret = strict_strtoul(buf, 16, &val);
+       if (ret)
+               return ret;
+
+       lp5521_run_led_pattern(val, chip);
+
+       return len;
+}
+
+static ssize_t show_delay_on(struct device *dev,
+                           struct device_attribute *attr,
+                           char *buf)
+{
+       struct led_classdev *led_cdev = dev_get_drvdata(dev);
+       struct lp5521_led *led = cdev_to_led(led_cdev);
+
+       return sprintf(buf, "%d\n", led->delay_on);
+}
+
+static ssize_t store_delay_on(struct device *dev,
+                            struct device_attribute *attr,
+                            const char *buf, size_t len)
+{
+       struct led_classdev *led_cdev = dev_get_drvdata(dev);
+       struct lp5521_led *led = cdev_to_led(led_cdev);
+       unsigned long curr;
+
+       if (strict_strtoul(buf, 0, &curr))
+               return -EINVAL;
+
+       led->delay_on = (int)curr;
+
+       return len;
+}
+
+static ssize_t show_delay_off(struct device *dev,
+                           struct device_attribute *attr,
+                           char *buf)
+{
+       struct led_classdev *led_cdev = dev_get_drvdata(dev);
+       struct lp5521_led *led = cdev_to_led(led_cdev);
+
+       return sprintf(buf, "%d\n", led->delay_off);
+}
+
+static ssize_t store_delay_off(struct device *dev,
+                            struct device_attribute *attr,
+                            const char *buf, size_t len)
+{
+       struct led_classdev *led_cdev = dev_get_drvdata(dev);
+       struct lp5521_led *led = cdev_to_led(led_cdev);
+       unsigned long curr;
+
+       if (strict_strtoul(buf, 0, &curr))
+               return -EINVAL;
+
+       led->delay_off = (int)curr;
+
+       return len;
+}
+
+static ssize_t store_blink(struct device *dev,
+                            struct device_attribute *attr,
+                            const char *buf, size_t len)
+{
+       struct led_classdev *led_cdev = dev_get_drvdata(dev);
+       struct lp5521_led *led = cdev_to_led(led_cdev);
+       unsigned long is_blink_set;
+       unsigned long on = led->delay_on;
+       unsigned long off = led->delay_off;
+
+       if (strict_strtoul(buf, 0, &is_blink_set))
+               return -EINVAL;
+
+       if (!is_blink_set)
+               on = ALWAYS_OFF;
+
+       led_blink_set(led_cdev, &on, &off);
+
+       return len;
+}
+
 /* led class device attributes */
 static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
+static DEVICE_ATTR(delay_on, S_IRUGO | S_IWUSR, show_delay_on, store_delay_on);
+static DEVICE_ATTR(delay_off, S_IRUGO | S_IWUSR, show_delay_off,
+               store_delay_off);
+static DEVICE_ATTR(blink, S_IWUSR, NULL, store_blink);

 static struct attribute *lp5521_led_attributes[] = {
        &dev_attr_led_current.attr,
        &dev_attr_max_current.attr,
+       &dev_attr_delay_on.attr,
+       &dev_attr_delay_off.attr,
+       &dev_attr_blink.attr,
        NULL,
 };

@@ -558,6 +735,7 @@ static DEVICE_ATTR(engine1_load, S_IWUSR, NULL, store_engine1_load);
 static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
 static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
+static DEVICE_ATTR(led_pattern, S_IWUSR, NULL, store_led_pattern);

 static struct attribute *lp5521_attributes[] = {
        &dev_attr_engine1_mode.attr,
@@ -567,6 +745,7 @@ static struct attribute *lp5521_attributes[] = {
        &dev_attr_engine1_load.attr,
        &dev_attr_engine2_load.attr,
        &dev_attr_engine3_load.attr,
+       &dev_attr_led_pattern.attr,
        NULL
 };

@@ -617,10 +796,16 @@ static int __devinit lp5521_init_led(struct lp5521_led *led,
                return -EINVAL;
        }

-       snprintf(name, sizeof(name), "%s:channel%d",
-                       pdata->label ?: client->name, chan);
        led->cdev.brightness_set = lp5521_set_brightness;
-       led->cdev.name = name;
+
+       if (pdata->led_config[chan].name) {
+               led->cdev.name = pdata->led_config[chan].name;
+       } else {
+               snprintf(name, sizeof(name), "%s:channel%d",
+                       pdata->label ?: client->name, chan);
+               led->cdev.name = name;
+       }
+
        res = led_classdev_register(dev, &led->cdev);
        if (res < 0) {
                dev_err(dev, "couldn't register led on channel %d\n", chan);
@@ -749,6 +934,7 @@ static int lp5521_remove(struct i2c_client *client)
        struct lp5521_chip *chip = i2c_get_clientdata(client);
        int i;

+       lp5521_run_led_pattern(PATTERN_OFF, chip);
        lp5521_unregister_sysfs(client);

        for (i = 0; i < chip->num_leds; i++) {
diff --git a/include/linux/leds-lp5521.h b/include/linux/leds-lp5521.h
index fd548d2..c842527 100644
--- a/include/linux/leds-lp5521.h
+++ b/include/linux/leds-lp5521.h
@@ -26,23 +26,48 @@
 /* See Documentation/leds/leds-lp5521.txt */

 struct lp5521_led_config {
+       char            *name;
        u8              chan_nr;
        u8              led_current; /* mA x10, 0 if led is not connected */
        u8              max_current;
 };

+struct lp5521_led_pattern {
+       u8 *r;
+       u8 *g;
+       u8 *b;
+       u8 size_r;
+       u8 size_g;
+       u8 size_b;
+};
+
 #define LP5521_CLOCK_AUTO      0
 #define LP5521_CLOCK_INT       1
 #define LP5521_CLOCK_EXT       2

+/* Bits in CONFIG register */
+#define LP5521_PWM_HF                  0x40    /* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN              0x20    /* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF             0       /* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS          8       /* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5             0x10    /* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO            0x18    /* Automatic mode selection */
+#define LP5521_R_TO_BATT               4       /* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_SRC_EXT             0       /* Ext-clk source (CLK_32K) */
+#define LP5521_CLK_INT                 1       /* Internal clock */
+#define LP5521_CLK_AUTO                        2       /* Automatic clock selection */
+
 struct lp5521_platform_data {
        struct lp5521_led_config *led_config;
        u8      num_channels;
        u8      clock_mode;
+       u8      update_config;
        int     (*setup_resources)(void);
        void    (*release_resources)(void);
        void    (*enable)(bool state);
        const char *label;
+       struct lp5521_led_pattern *patterns;
+       u8 num_patterns;
 };

 #endif /* __LINUX_LP5521_H */
--
1.7.4.1


Best Regards

Milo (Woogyom) Kim
Texas Instruments Incorporated

