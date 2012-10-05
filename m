Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2JEIP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:15:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2JEIPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:15:24 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/28] leds-lp55xx: support firmware interface for LED
 patterns
Thread-Topic: [PATCH 10/28] leds-lp55xx: support firmware interface for LED
 patterns
Thread-Index: Ac2i0YvTYOWzAGjeQkCNYVVQ4XA9hg==
Date: Fri, 5 Oct 2012 08:15:14 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64176779@DQHE02.ent.ti.com>
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

 This patch provides additional device attributes which enable
 loading the firmware. ('select_engine' and 'run_engine')

 LP55xx family chips have internal program memory which run various patterns.
 Using this memory, LEDs continue on blinking/dimming without continuous I2C
 commands. That means the I2C HOST can be entered into sleep once the memory
 is updated.

 An application can get program data from a file or raw hex data in code,
 and write data into the program memory through the I2C.

 LP55xx chips have three program engines.
 To load and run the pattern, the programming sequence is as follows.
 (1) Select an engine number (1/2/3)
 (2) Set engine mode to load
 (3) Write pattern data into selected area
 (4) Set engine mode to run

 This sequence is almost same as the firmware interface.
 (1) Select an engine number               : 'select_engine' dev attribute
 (2) Mode change to load                   : 'loading' of firmware class
 (3) Write pattern data into selected area : 'data' of firmware class
 (4) Mode change to run                    : 'run_engine' dev attribute

 For example,
 echo 1 or 2 or 3 > /sys/class/leds/<name>/device/select_engine
 echo 1 > /sys/class/firmware/<name>/loading
 echo HEX STREAM DATA > /sys/class/firmware/<name>/data
 echo 0 > /sys/class/firmware/<name>/loading
 echo 1 > /sys/class/leds/<name>/device/run_engine

 As soon as 'loading' is set to 0, registered callback is called.
 Inside the callback, the selected engine is loaded and memory is updated.
 To run programmed pattern, 'run_engine' attribute should be enabled.

 ( Chip specific features )
 o Firmware callback : load selected engine and update program memory
 o Run engine        : change the engine mode
 Both operations depend on the device - different register address.
 Those are configurable in each driver side.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp55xx-common.c |  141 +++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.h |    4 ++
 2 files changed, 145 insertions(+)

diff --git a/drivers/leds/leds-lp55xx-common.c b/drivers/leds/leds-lp55xx-common.c
index 987c699..af3fb49 100644
--- a/drivers/leds/leds-lp55xx-common.c
+++ b/drivers/leds/leds-lp55xx-common.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/firmware.h>
 #include <linux/i2c.h>
 #include <linux/leds.h>
 #include <linux/module.h>
@@ -184,6 +185,130 @@ static int lp55xx_init_led(struct lp55xx_led *led,
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
+static ssize_t show_engine_select(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct lp55xx_led *led = i2c_get_clientdata(to_i2c_client(dev));
+	struct lp55xx_chip *chip = led->chip;
+
+	return sprintf(buf, "%d\n", chip->engine_idx);
+}
+
+static ssize_t store_engine_select(struct device *dev,
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
+static ssize_t store_engine_run(struct device *dev,
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
+		   show_engine_select, store_engine_select);
+static DEVICE_ATTR(run_engine, S_IWUSR, NULL, store_engine_run);
+
+static struct attribute *lp55xx_dev_attributes[] = {
+	&dev_attr_select_engine.attr,
+	&dev_attr_run_engine.attr,
+	NULL,
+};
+
+static const struct attribute_group lp55xx_dev_attr_group = {
+	.attrs = lp55xx_dev_attributes,
+};
+
 int lp55xx_write(struct lp55xx_chip *chip, u8 reg, u8 val)
 {
 	return i2c_smbus_write_byte_data(chip->cl, reg, val);
@@ -360,3 +485,19 @@ void lp55xx_unregister_leds(struct lp55xx_led *led, struct lp55xx_chip *chip)
 	}
 }
 EXPORT_SYMBOL_GPL(lp55xx_unregister_leds);
+
+int lp55xx_register_sysfs(struct lp55xx_chip *chip)
+{
+	struct device *dev = &chip->cl->dev;
+
+	return sysfs_create_group(&dev->kobj, &lp55xx_dev_attr_group);
+}
+EXPORT_SYMBOL_GPL(lp55xx_register_sysfs);
+
+void lp55xx_unregister_sysfs(struct lp55xx_chip *chip)
+{
+	struct device *dev = &chip->cl->dev;
+
+	sysfs_remove_group(&dev->kobj, &lp55xx_dev_attr_group);
+}
+EXPORT_SYMBOL_GPL(lp55xx_unregister_sysfs);
diff --git a/drivers/leds/leds-lp55xx-common.h b/drivers/leds/leds-lp55xx-common.h
index 66d7039..b5b7b3e 100644
--- a/drivers/leds/leds-lp55xx-common.h
+++ b/drivers/leds/leds-lp55xx-common.h
@@ -131,4 +131,8 @@ extern int lp55xx_register_leds(struct lp55xx_led *led,
 extern void lp55xx_unregister_leds(struct lp55xx_led *led,
 				struct lp55xx_chip *chip);
 
+/* common device attributes functions */
+extern int lp55xx_register_sysfs(struct lp55xx_chip *chip);
+extern void lp55xx_unregister_sysfs(struct lp55xx_chip *chip);
+
 #endif /* __LINUX_LP55XX_COMMON_H */
-- 
1.7.9.5


Best Regards,
Milo


