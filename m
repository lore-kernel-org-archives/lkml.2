Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2LLOGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:06:09 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50847 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2LLOCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:18 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/33] leds-lp55xx: support firmware interface
Thread-Topic: [PATCH 19/33] leds-lp55xx: support firmware interface
Thread-Index: Ac3YcUks0a56h8DZRMaDpQydC8tr9A==
Date: Wed, 12 Dec 2012 14:02:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AB75@DQHE02.ent.ti.com>
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

 This patch provides additional device attributes which enable
 loading the firmware. ('select_engine' and 'run_engine')
 To run a LED pattern, two parts of driver should be enabled.

 Common features : lp55xx-common
 ===============================
 Firmware interface for loading LED patterns

 Chip specific features : leds-lp5521, leds-lp5523
 =================================================
 Register addresses for loading firmware data
 Register addresses for running selected engine

 Pattern programming sequence
 ============================
 LP55xx chips have three program engines.
 To load and run a LED pattern, the programming sequence is as follows.
 (1) Select an engine number (1/2/3)
 (2) Set engine mode to load
 (3) Write pattern data into selected area
 (4) Set engine mode to run

 This sequence is almost same as the firmware interface.
 (1) Select an engine number               : 'select_engine' dev attribute
 (2) Mode change to load                   : 'loading' of firmware class
 (3) Write pattern data into selected area : 'data' of firmware class
 (4) Mode change to run                    : 'run_engine' dev attribute

 (1) and (4) are device specific features which provide callback functions
 (2) and (3) are common features.

 For example,
 echo 1 or 2 or 3 > /sys/bus/i2c/devices/xxxx/select_engine
 echo 1 > /sys/class/firmware/lp5521/loading
 echo "4000600040FF6000" > /sys/class/firmware/lp5521/data
 echo 0 > /sys/class/firmware/lp5521/loading
 echo 1 > /sys/bus/i2c/devices/xxxx/run_engine

 As soon as 'loading' is set to 0, registered callback is called.
 Inside the callback, the selected engine is loaded and memory is updated.
 To run programmed pattern, 'run_engine' attribute should be enabled.

 Device specific data structure
 ==============================
 o Firmware callback
   load selected engine and update program memory
 o Run engine
   change the engine mode
 o 'engine_idx' and firmware data, 'fw'
   Those are used in the driver internally with callback functions

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/Kconfig              |    1 +
 drivers/leds/leds-lp55xx-common.c |  117 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |   19 ++++++
 3 files changed, 137 insertions(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 36f389f..f57cd94 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -197,6 +197,7 @@ config LEDS_LP55XX_COMMON
 	bool "Common Driver for TI/National LP5521 and LP5523/55231"
 	depends on LEDS_LP5521 || LEDS_LP5523
 	depends on I2C
+	select FW_LOADER
 	help
 	  This option supports common operations for LP5521 and LP5523/55231
 	  devices.
diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 4995369..f3a2866 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/firmware.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
 #include <linux/module.h>
@@ -197,7 +198,123 @@ static int lp55xx_init_led(struct lp55xx_led *led,
 	return 0;
 }
 
+static void lp55xx_firmware_loaded(const struct firmware *fw, void *context)
+{
+	struct lp55xx_chip *chip = context;
+	struct device *dev = &chip->cl->dev;
+
+	if (!fw) {
+		dev_err(dev, "firmware request failed\n");
+		goto out;
+	}
+
+	/* handling firmware data is chip dependent */
+	mutex_lock(&chip->lock);
+
+	chip->fw = fw;
+	if (chip->cfg->firmware_cb)
+		chip->cfg->firmware_cb(chip);
+
+	mutex_unlock(&chip->lock);
+
+out:
+	/* firmware should be released for other channel use */
+	release_firmware(chip->fw);
+}
+
+static int lp55xx_request_firmware(struct lp55xx_chip *chip)
+{
+	const char *name = chip->cl->name;
+	struct device *dev = &chip->cl->dev;
+
+	return request_firmware_nowait(THIS_MODULE, true, name, dev,
+				GFP_KERNEL, chip, lp55xx_firmware_loaded);
+}
+
+static ssize_t lp55xx_show_engine_select(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+
+	return sprintf(buf, "%d\n", chip->engine_idx);
+}
+
+static ssize_t lp55xx_store_engine_select(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	unsigned long val;
+	int ret;
+
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	/* select the engine to be run */
+
+	switch (val) {
+	case LP55XX_ENGINE_1:
+	case LP55XX_ENGINE_2:
+	case LP55XX_ENGINE_3:
+		mutex_lock(&chip->lock);
+		chip->engine_idx = val;
+		ret = lp55xx_request_firmware(chip);
+		mutex_unlock(&chip->lock);
+		break;
+	default:
+		dev_err(dev, "%lu: invalid engine index. (1, 2, 3)\n", val);
+		return -EINVAL;
+	}
+
+	if (ret) {
+		dev_err(dev, "request firmware err: %d\n", ret);
+		return ret;
+	}
+
+	return len;
+}
+
+static inline void lp55xx_run_engine(struct lp55xx_chip *chip, bool start)
+{
+	if (chip->cfg->run_engine)
+		chip->cfg->run_engine(chip, start);
+}
+
+static ssize_t lp55xx_store_engine_run(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	/* run or stop the selected engine */
+
+	if (val <= 0) {
+		lp55xx_run_engine(chip, false);
+		return len;
+	}
+
+	mutex_lock(&chip->lock);
+	lp55xx_run_engine(chip, true);
+	mutex_unlock(&chip->lock);
+
+	return len;
+}
+
+static DEVICE_ATTR(select_engine, S_IRUGO | S_IWUSR,
+		   lp55xx_show_engine_select, lp55xx_store_engine_select);
+static DEVICE_ATTR(run_engine, S_IWUSR, NULL, lp55xx_store_engine_run);
+
 static struct attribute *lp55xx_engine_attributes[] = {
+	&dev_attr_select_engine.attr,
+	&dev_attr_run_engine.attr,
 	NULL,
 };
 
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 2972bae..affdb43 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -15,6 +15,13 @@
 #ifndef _LEDS_LP55XX_COMMON_H
 #define _LEDS_LP55XX_COMMON_H
 
+enum lp55xx_engine_index {
+	LP55XX_ENGINE_INVALID,
+	LP55XX_ENGINE_1,
+	LP55XX_ENGINE_2,
+	LP55XX_ENGINE_3,
+};
+
 struct lp55xx_led;
 struct lp55xx_chip;
 
@@ -35,6 +42,8 @@ struct lp55xx_reg {
  * @max_channel        : Maximum number of channels
  * @post_init_device   : Chip specific initialization code
  * @brightness_work_fn : Brightness work function
+ * @firmware_cb        : Call function when the firmware is loaded
+ * @run_engine         : Run internal engine for pattern
  */
 struct lp55xx_device_config {
 	const struct lp55xx_reg reset;
@@ -49,6 +58,12 @@ struct lp55xx_device_config {
 
 	/* current setting function */
 	void (*set_led_current) (struct lp55xx_led *led, u8 led_current);
+
+	/* access program memory when the firmware is loaded */
+	void (*firmware_cb)(struct lp55xx_chip *chip);
+
+	/* used for running firmware LED patterns */
+	void (*run_engine) (struct lp55xx_chip *chip, bool start);
 };
 
 /*
@@ -58,6 +73,8 @@ struct lp55xx_device_config {
  * @lock       : Lock for user-space interface
  * @num_leds   : Number of registered LEDs
  * @cfg        : Device specific configuration data
+ * @engine_idx : Selected engine number
+ * @fw         : Firmware data for running a LED pattern
  */
 struct lp55xx_chip {
 	struct i2c_client *cl;
@@ -65,6 +82,8 @@ struct lp55xx_chip {
 	struct mutex lock;	/* lock for user-space interface */
 	int num_leds;
 	struct lp55xx_device_config *cfg;
+	enum lp55xx_engine_index engine_idx;
+	const struct firmware *fw;
 };
 
 /*
-- 
1.7.9.5


Best Regards,
Milo


