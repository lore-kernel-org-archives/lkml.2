Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab2ARTwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:52:04 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:47483 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2ARTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:52:02 -0500
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: lars@metafoo.de, rpurdie@rpsys.net
Subject: [PATCH v2] add LED driver for PCA9663 I2C chip
Date: Wed, 18 Jan 2012 20:51:29 +0100
Message-Id: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

v2: address Lars-Peter's comments
* remove unnecessary spinlock
* remove printk()
* change return code to EINVAL for invalid platform data
* use module_i2c_driver()

---
 drivers/leds/Kconfig        |    8 ++
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-pca9633.c |  196 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-pca9633.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index c957c34..72df181 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -244,6 +244,14 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
+config LEDS_PCA9663
+	tristate "LED support for PCA9663 I2C chip"
+	depends on LEDS_CLASS
+	depends on I2C
+	help
+	  This option enables support for LEDs connected to the PCA9663
+	  LED driver chip accessed via the I2C bus.
+
 config LEDS_WM831X_STATUS
 	tristate "LED support for status LEDs on WM831x PMICs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index b8a9723..a809871 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
+obj-$(CONFIG_LEDS_PCA9633)		+= leds-pca9633.o
 obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
 obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
 obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
new file mode 100644
index 0000000..feb5aa9
--- /dev/null
+++ b/drivers/leds/leds-pca9633.c
@@ -0,0 +1,196 @@
+/*
+ * Copyright 2011 bct electronic GmbH
+ *
+ * Author: Peter Meerwald <p.meerwald@bct-electronic.com>
+ *
+ * Based on leds-pca955x.c
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * LED driver for the PCA9633 I2C LED driver (7-bit slave address 0x62)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+
+/* LED select registers determine the source that drives LED outputs */
+#define PCA9633_LED_OFF		0x0	/* LED driver off */
+#define PCA9633_LED_ON		0x1	/* LED driver on */
+#define PCA9633_LED_PWM		0x2	/* Controlled through PWM */
+#define PCA9633_LED_GRP_PWM	0x3	/* Controlled through PWM/GRPPWM */
+
+#define PCA9633_MODE1		0x00
+#define PCA9633_MODE2		0x01
+#define PCA9633_PWM_BASE	0x02
+#define PCA9633_LEDOUT		0x08
+
+static const struct i2c_device_id pca9633_id[] = {
+	{ "pca9633", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pca9633_id);
+
+struct pca9633_led {
+	struct i2c_client *client;
+	struct work_struct work;
+	enum led_brightness brightness;
+	struct led_classdev led_cdev;
+	int led_num; /* 0 .. 3 potentially */
+	char name[32];
+};
+
+static void pca9633_led_work(struct work_struct *work)
+{
+	struct pca9633_led *pca9633 = container_of(work,
+		struct pca9633_led, work);
+
+	u8 ledout = i2c_smbus_read_byte_data(pca9633->client, PCA9633_LEDOUT);
+	int shift = 2 * pca9633->led_num;
+	u8 mask = 0x3 << shift;
+
+	switch (pca9633->brightness) {
+	case LED_FULL:
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			(ledout & ~mask) | (PCA9633_LED_ON << shift));
+		break;
+	case LED_OFF:
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			ledout & ~mask);
+		break;
+	default:
+		i2c_smbus_write_byte_data(pca9633->client,
+			PCA9633_PWM_BASE + pca9633->led_num,
+			pca9633->brightness);
+		i2c_smbus_write_byte_data(pca9633->client, PCA9633_LEDOUT,
+			(ledout & ~mask) | (PCA9633_LED_PWM << shift));
+		break;
+	}
+}
+
+static void pca9633_led_set(struct led_classdev *led_cdev,
+	enum led_brightness value)
+{
+	struct pca9633_led *pca9633;
+
+	pca9633 = container_of(led_cdev, struct pca9633_led, led_cdev);
+
+	pca9633->brightness = value;
+
+	/*
+	 * Must use workqueue for the actual I/O since I2C operations
+	 * can sleep.
+	 */
+	schedule_work(&pca9633->work);
+}
+
+static int __devinit pca9633_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct pca9633_led *pca9633;
+	struct i2c_adapter *adapter;
+	struct led_platform_data *pdata;
+	int i, err;
+
+	adapter = to_i2c_adapter(client->dev.parent);
+	pdata = client->dev.platform_data;
+
+	if (pdata) {
+		if (pdata->num_leds <= 0 || pdata->num_leds > 4) {
+			dev_err(&client->dev, "board info must claim at most 4 LEDs");
+			return -EINVAL;
+		}
+	}
+
+	pca9633 = kzalloc(sizeof(*pca9633) * 4, GFP_KERNEL);
+	if (!pca9633)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, pca9633);
+
+	for (i = 0; i < 4; i++) {
+		pca9633[i].client = client;
+		pca9633[i].led_num = i;
+
+		/* Platform data can specify LED names and default triggers */
+		if (pdata && i < pdata->num_leds) {
+			if (pdata->leds[i].name)
+				snprintf(pca9633[i].name,
+					 sizeof(pca9633[i].name), "pca9633:%s",
+					 pdata->leds[i].name);
+			if (pdata->leds[i].default_trigger)
+				pca9633[i].led_cdev.default_trigger =
+					pdata->leds[i].default_trigger;
+		} else {
+			snprintf(pca9633[i].name, sizeof(pca9633[i].name),
+				 "pca9633:%d", i);
+		}
+
+		pca9633[i].led_cdev.name = pca9633[i].name;
+		pca9633[i].led_cdev.brightness_set = pca9633_led_set;
+
+		INIT_WORK(&pca9633[i].work, pca9633_led_work);
+
+		err = led_classdev_register(&client->dev, &pca9633[i].led_cdev);
+		if (err < 0)
+			goto exit;
+	}
+
+	/* Disable LED all-call address and set normal mode */
+	i2c_smbus_write_byte_data(client, PCA9633_MODE1, 0x00);
+
+	/* Turn off LEDs */
+	i2c_smbus_write_byte_data(client, PCA9633_LEDOUT, 0x00);
+
+	return 0;
+
+exit:
+	while (i--) {
+		led_classdev_unregister(&pca9633[i].led_cdev);
+		cancel_work_sync(&pca9633[i].work);
+	}
+
+	kfree(pca9633);
+
+	return err;
+}
+
+static int __devexit pca9633_remove(struct i2c_client *client)
+{
+	struct pca9633_led *pca9633 = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		led_classdev_unregister(&pca9633[i].led_cdev);
+		cancel_work_sync(&pca9633[i].work);
+	}
+
+	kfree(pca9633);
+
+	return 0;
+}
+
+static struct i2c_driver pca9633_driver = {
+	.driver = {
+		.name	= "leds-pca9633",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= pca9633_probe,
+	.remove	= __devexit_p(pca9633_remove),
+	.id_table = pca9633_id,
+};
+
+module_i2c_driver(pca9633_driver);
+
+MODULE_AUTHOR("Peter Meerwald <p.meerwald@bct-electronic.com>");
+MODULE_DESCRIPTION("PCA9633 LED driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4.1

