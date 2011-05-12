Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1ELE3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 00:29:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65100 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1ELE3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 00:29:49 -0400
Subject: [RFC PATCH] input: Add wiichuck driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 12 May 2011 06:29:44 +0200
Message-ID: <20110512042218.12859.66600.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the Nintendo Nunchuck (wiimote accessory)
attached to an i2c bus via something like a wiichuck adapter board
from Sparkfun.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

This is RFC because the driver doesn't completely work yet.  The
joystick and buttons work fine.  There is a bug with the accelerometer
reporting though (nothing gets reported), and I'm not even sure I'm
using the right input type for reporting accelerometer values.
Comments welcome.

 drivers/input/joystick/Kconfig    |    8 +
 drivers/input/joystick/Makefile   |    1 
 drivers/input/joystick/wiichuck.c |  225 +++++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/joystick/wiichuck.c

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 56eb471..79f18db 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -193,6 +193,14 @@ config JOYSTICK_TWIDJOY
 	  To compile this driver as a module, choose M here: the
 	  module will be called twidjoy.
 
+config JOYSTICK_WIICHUCK
+	tristate "Nintendo Nunchuck on i2c bus"
+	depends on I2C
+	select INPUT_POLLDEV
+	help
+	  Say Y here if you have a Nintendo Nunchuck directly attached to
+	  the machine's i2c bus.
+
 config JOYSTICK_ZHENHUA
 	tristate "5-byte Zhenhua RC transmitter"
 	select SERIO
diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Makefile
index 92dc0de..78466d6 100644
--- a/drivers/input/joystick/Makefile
+++ b/drivers/input/joystick/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_JOYSTICK_TMDC)		+= tmdc.o
 obj-$(CONFIG_JOYSTICK_TURBOGRAFX)	+= turbografx.o
 obj-$(CONFIG_JOYSTICK_TWIDJOY)		+= twidjoy.o
 obj-$(CONFIG_JOYSTICK_WARRIOR)		+= warrior.o
+obj-$(CONFIG_JOYSTICK_WIICHUCK)		+= wiichuck.o
 obj-$(CONFIG_JOYSTICK_XPAD)		+= xpad.o
 obj-$(CONFIG_JOYSTICK_ZHENHUA)		+= zhenhua.o
 obj-$(CONFIG_JOYSTICK_WALKERA0701)	+= walkera0701.o
diff --git a/drivers/input/joystick/wiichuck.c b/drivers/input/joystick/wiichuck.c
new file mode 100644
index 0000000..2afc274
--- /dev/null
+++ b/drivers/input/joystick/wiichuck.c
@@ -0,0 +1,225 @@
+/*
+ * Nintendo Nunchuck driver for i2c connection.
+ *
+ * Copyright (c) 2011 Secret Lab Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/input-polldev.h>
+#include <linux/mod_devicetable.h>
+#include <linux/slab.h>
+
+MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
+MODULE_DESCRIPTION("Nintendo Nunchuck driver");
+MODULE_LICENSE("GPL");
+
+#define WIICHUCK_JOY_MAX_AXIS	220
+#define WIICHUCK_JOY_MIN_AXIS	30
+#define WIICHUCK_JOY_FUZZ	4
+#define WIICHUCK_JOY_FLAT	8
+
+struct wiichuck_device {
+	struct input_polled_dev *poll_dev;
+	struct i2c_client *i2c_client;
+	int state;
+};
+
+static void wiichuck_poll(struct input_polled_dev *poll_dev)
+{
+	struct wiichuck_device *wiichuck = poll_dev->private;
+	struct i2c_client *i2c = wiichuck->i2c_client;
+	static uint8_t cmd_byte = 0;
+	struct i2c_msg cmd_msg =
+		{ .addr = i2c->addr, .len = 1, .buf = &cmd_byte };
+	uint8_t b[6];
+	struct i2c_msg data_msg =
+		{ .addr = i2c->addr, .flags = I2C_M_RD, .len = 6, .buf = b };
+	int jx, jy, ax, ay, az;
+	bool c, z;
+
+	switch (wiichuck->state) {
+	case 0:
+		i2c_transfer(i2c->adapter, &cmd_msg, 1);
+		wiichuck->state = 1;
+		break;
+
+	case 1:
+		i2c_transfer(i2c->adapter, &data_msg, 1);
+
+		jx = b[0];
+		jy = b[1];
+		ax = (b[2] << 2) & ((b[5] >> 2) & 0x3);
+		ay = (b[3] << 2) & ((b[5] >> 4) & 0x3);
+		az = (b[4] << 2) & ((b[5] >> 6) & 0x3);
+		z = !(b[5] & 1);
+		c = !(b[5] & 2);
+
+		input_report_abs(poll_dev->input, ABS_X, jx);
+		input_report_abs(poll_dev->input, ABS_Y, jy);
+		input_report_abs(poll_dev->input, ABS_RX, ax);
+		input_report_abs(poll_dev->input, ABS_RY, ax);
+		input_report_abs(poll_dev->input, ABS_RZ, ay);
+		input_report_key(poll_dev->input, BTN_C, c);
+		input_report_key(poll_dev->input, BTN_Z, z);
+		input_sync(poll_dev->input);
+
+		wiichuck->state = 0;
+		dev_dbg(&i2c->dev, "wiichuck: j=%.3i,%.3i a=%.3x,%.3x,%.3x %c%c\n",
+			jx,jy, ax,ay,az, c ? 'C' : 'c', z ? 'Z' : 'z');
+		break;
+
+	default:
+		wiichuck->state = 0;
+	}
+}
+
+static void wiichuck_open(struct input_polled_dev *poll_dev)
+{
+	struct wiichuck_device *wiichuck = poll_dev->private;
+	struct i2c_client *i2c = wiichuck->i2c_client;
+	static uint8_t data1[2] = { 0xf0, 0x55 };
+	static uint8_t data2[2] = { 0xfb, 0x00 };
+	struct i2c_msg msg1 = { .addr = i2c->addr, .len = 2, .buf = data1 };
+	struct i2c_msg msg2 = { .addr = i2c->addr, .len = 2, .buf = data2 };
+
+	i2c_transfer(i2c->adapter, &msg1, 1);
+	i2c_transfer(i2c->adapter, &msg2, 1);
+	wiichuck->state = 0;
+
+	dev_dbg(&i2c->dev, "wiichuck open()\n");
+}
+
+static int __devinit wiichuck_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct wiichuck_device *wiichuck;
+	struct input_polled_dev *poll_dev;
+	struct input_dev *input_dev;
+	int rc;
+
+	wiichuck = kzalloc(sizeof(*wiichuck), GFP_KERNEL);
+	if (!wiichuck)
+		return -ENOMEM;
+
+	poll_dev = input_allocate_polled_device();
+	if (!poll_dev) {
+		rc = -ENOMEM;
+		goto err_alloc;
+	}
+
+	wiichuck->i2c_client = client;
+	wiichuck->poll_dev = poll_dev;
+
+	poll_dev->private = wiichuck;
+	poll_dev->poll = wiichuck_poll;
+	poll_dev->poll_interval = 50; /* Poll every 50ms */
+	poll_dev->open = wiichuck_open;
+
+	input_dev = poll_dev->input;
+	input_dev->name = "Nintendo Nunchuck";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &client->dev;
+
+	/* Declare the events generated by this driver */
+	set_bit(EV_ABS, input_dev->evbit);
+	set_bit(ABS_X, input_dev->absbit); /* joystick */
+	set_bit(ABS_Y, input_dev->absbit);
+	set_bit(ABS_RX, input_dev->absbit); /* accelerometer */
+	set_bit(ABS_RY, input_dev->absbit);
+	set_bit(ABS_RZ, input_dev->absbit);
+
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(BTN_C, input_dev->keybit); /* buttons */
+	set_bit(BTN_Z, input_dev->keybit);
+
+	input_set_abs_params(input_dev, ABS_X, 30, 220, 4, 8);
+	input_set_abs_params(input_dev, ABS_Y, 40, 200, 4, 8);
+	input_set_abs_params(input_dev, ABS_RX, 0, 0x3ff, 4, 8);
+	input_set_abs_params(input_dev, ABS_RY, 0, 0x3ff, 4, 8);
+	input_set_abs_params(input_dev, ABS_RZ, 0, 0x3ff, 4, 8);
+
+	rc = input_register_polled_device(wiichuck->poll_dev);
+	if (rc) {
+		dev_err(&client->dev, "Failed to register input device\n");
+		goto err_register;
+	}
+
+	i2c_set_clientdata(client, wiichuck);
+
+	return 0;
+
+ err_register:
+	input_free_polled_device(poll_dev);
+ err_alloc:
+	kfree(wiichuck);
+
+	return rc;
+}
+
+static int __devexit wiichuck_remove(struct i2c_client *client)
+{
+	struct wiichuck_device *wiichuck = i2c_get_clientdata(client);
+
+	i2c_set_clientdata(client, NULL);
+	input_unregister_polled_device(wiichuck->poll_dev);
+	input_free_polled_device(wiichuck->poll_dev);
+	kfree(wiichuck);
+
+	return 0;
+}
+
+static const struct i2c_device_id wiichuck_id[] = {
+	{ "nunchuck", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, wiichuck_id);
+
+#ifdef CONFIG_OF
+static struct of_device_id wiichuck_match_table[] __devinitdata = {
+	{ .compatible = "nintendo,nunchuck", },
+	{ }
+};
+#else
+#define wiichuck_match_table NULL
+#endif
+
+static struct i2c_driver wiichuck_driver = {
+	.driver = {
+		.name = "nunchuck",
+		.owner = THIS_MODULE,
+		.of_match_table = wiichuck_match_table,
+	},
+	.probe		= wiichuck_probe,
+	.remove		= __devexit_p(wiichuck_remove),
+	.id_table	= wiichuck_id,
+};
+
+static int __init wiichuck_init(void)
+{
+	return i2c_add_driver(&wiichuck_driver);
+}
+module_init(wiichuck_init);
+
+static void __exit wiichuck_exit(void)
+{
+	i2c_del_driver(&wiichuck_driver);
+}
+module_exit(wiichuck_exit);

