Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab1FMQMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 12:12:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34210 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1FMQMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 12:12:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=TqbTjRhMo4qR/uyll0gzWAb52Ha6HmeMq1yugDgwXLkNBo+ZZD3F+eftM/Za5xMu8n
         SLedpJPYuTPJeqnw9f1k83GysnK4pSngSjp2T6w2VIQfIS0CpO9s4WQT7Fy9CYplk+Gk
         NQVcRjgToKIj0InrbBPbqTiHq7yFW9ctPThOk=
MIME-Version: 1.0
In-Reply-To: <BANLkTimPu2K4o5jbe7XjnzKx6tV5AOPX6w@mail.gmail.com>
References: <1307873303-27371-1-git-send-email-eric.miao@linaro.org> <BANLkTimPu2K4o5jbe7XjnzKx6tV5AOPX6w@mail.gmail.com>
From: Eric Miao <eric.miao@linaro.org>
Date: Tue, 14 Jun 2011 00:11:58 +0800
X-Google-Sender-Auth: F7_B-YwAMUIjUkYdz09lOnW-Rz4
Message-ID: <BANLkTimsdMJfU5=GYmEK_k2gFKPV6b+AJA@mail.gmail.com>
Subject: Re: [PATCH] input: add support for mma8450 accelerometer
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sammy He <r62914@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 2:42 PM, Shubhrajyoti Datta
<omaplinuxkernel@gmail.com> wrote:
> Hi Eric,
> Some minor comments.
>

OK, patch updated as below:

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 45dc6aa..faf7e0c 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -478,4 +478,14 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.

+config INPUT_MMA8450
+	tristate "MMA8450 - Freescale's 3-Axis, 8/12-bit Digital Accelerometer"
+	depends on I2C
+	help
+	  Say Y here if you want to support Freescale's MMA8450 Accelerometer
+	  through I2C interface.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mma8450.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 38efb2c..5239e29 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -45,4 +45,5 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
+obj-$(CONFIG_INPUT_MMA8450)		+= mma8450.o

diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
new file mode 100644
index 0000000..6b9235e3
--- /dev/null
+++ b/drivers/input/misc/mma8450.c
@@ -0,0 +1,246 @@
+/*
+ *  Driver for Freescale's 3-Axis Accelerometer MMA8450
+ *
+ *  Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/input-polldev.h>
+
+#define MMA8450_DRV_NAME	"mma8450"
+
+#define MODE_CHANGE_DELAY_MS	100
+#define POLL_INTERVAL		100
+#define POLL_INTERVAL_MAX	500
+
+/* register definitions */
+#define MMA8450_STATUS		0x00
+#define MMA8450_STATUS_ZXYDR	0x08
+
+#define MMA8450_OUT_X8		0x01
+#define MMA8450_OUT_Y8		0x02
+#define MMA8450_OUT_Z8		0x03
+
+#define MMA8450_OUT_X_LSB	0x05
+#define MMA8450_OUT_X_MSB	0x06
+#define MMA8450_OUT_Y_LSB	0x07
+#define MMA8450_OUT_Y_MSB	0x08
+#define MMA8450_OUT_Z_LSB	0x09
+#define MMA8450_OUT_Z_MSB	0x0a
+
+#define MMA8450_XYZ_DATA_CFG	0x16
+
+#define MMA8450_CTRL_REG1	0x38
+#define MMA8450_CTRL_REG2	0x39
+
+/* mma8450 status */
+struct mma8450 {
+	struct i2c_client	*client;
+	struct input_polled_dev	*idev;
+};
+
+static int mma8450_read(struct mma8450 *m, unsigned off, uint8_t *v)
+{
+	struct i2c_client *c = m->client;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(c, off);
+	if (ret < 0)
+		dev_err(&c->dev, "failed to read register 0x%02x\n", off);
+
+	*v = (uint8_t)ret;
+	return ret;
+}
+
+static int mma8450_write(struct mma8450 *m, unsigned off, uint8_t v)
+{
+	struct i2c_client *c = m->client;
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(c, off, v);
+	if (ret < 0)
+		dev_err(&c->dev, "failed to write to register 0x%02x\n", off);
+
+	return ret;
+}
+
+static int mma8450_init_client(struct mma8450 *m)
+{
+	int err;
+
+	/* enable all events from X/Y/Z, no FIFO */
+	err = mma8450_write(m, MMA8450_XYZ_DATA_CFG, 0x07);
+	if (err < 0)
+		return err;
+
+	/* Sleep mode poll rate - 50Hz
+	 * System output data rate - 400Hz
+	 * Full scale selection - Active, +/- 2G
+	 */
+	err = mma8450_write(m, MMA8450_CTRL_REG1, 0x01);
+	if (err < 0)
+		return err;
+
+	msleep(MODE_CHANGE_DELAY_MS);
+	return 0;
+}
+
+static int mma8450_read_xyz(struct mma8450 *m, int *x, int *y, int *z)
+{
+	struct i2c_client *c = m->client;
+	uint8_t buff[6];
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(c, MMA8450_OUT_X_LSB, 6, buff);
+	if (ret < 0) {
+		dev_err(&c->dev, "failed to read block data at 0x%02x\n",
+				MMA8450_OUT_X_LSB);
+		return ret;
+	}
+
+	*x = ((buff[1] << 4) & 0xff0) | (buff[0] & 0xf);
+	*y = ((buff[3] << 4) & 0xff0) | (buff[2] & 0xf);
+	*z = ((buff[5] << 4) & 0xff0) | (buff[4] & 0xf);
+
+	return 0;
+}
+
+static void mma8450_poll(struct input_polled_dev *dev)
+{
+	struct mma8450 *m = dev->private;
+	uint8_t status;
+	int x, y, z, err;
+
+	err = mma8450_read(m, MMA8450_STATUS, &status);
+	if (err)
+		return;
+
+	if ((status & MMA8450_STATUS_ZXYDR) == 0)
+		return;
+
+	err = mma8450_read_xyz(m, &x, &y, &z);
+	if (err)
+		return;
+
+	input_report_abs(dev->input, ABS_X, x);
+	input_report_abs(dev->input, ABS_Y, y);
+	input_report_abs(dev->input, ABS_Z, z);
+	input_sync(dev->input);
+}
+
+/*
+ * I2C init/probing/exit functions
+ */
+static int __devinit mma8450_probe(struct i2c_client *c,
+				   const struct i2c_device_id *id)
+{
+	struct input_polled_dev *idev;
+	struct mma8450 *m;
+	int err;
+
+	m = kzalloc(sizeof(struct mma8450), GFP_KERNEL);
+	if (m == NULL)
+		return -ENOMEM;
+
+	m->client = c;
+
+	/* Initialize the MMA8450 chip */
+	err = mma8450_init_client(m);
+	if (err)
+		goto exit_free;
+
+	/*input poll device register */
+	idev = input_allocate_polled_device();
+	if (idev == NULL) {
+		dev_err(&c->dev, "failed to allocate polled input device\n");
+		goto exit_free;
+	}
+
+	idev->private		= m;
+	idev->input->name	= MMA8450_DRV_NAME;
+	idev->input->id.bustype	= BUS_I2C;
+	idev->poll		= mma8450_poll;
+	idev->poll_interval	= POLL_INTERVAL;
+	idev->poll_interval_max	= POLL_INTERVAL_MAX;
+	__set_bit(EV_ABS, idev->input->evbit);
+
+	input_set_abs_params(idev->input, ABS_X, -2048, 2047, 32, 32);
+	input_set_abs_params(idev->input, ABS_Y, -2048, 2047, 32, 32);
+	input_set_abs_params(idev->input, ABS_Z, -2048, 2047, 32, 32);
+
+	err = input_register_polled_device(idev);
+	if (err) {
+		dev_err(&c->dev, "failed to register polled input device\n");
+		goto exit_free_input;
+	}
+
+	dev_info(&c->dev, "polled input device registered\n");
+	return 0;
+
+exit_free_input:
+	input_free_polled_device(idev);
+exit_free:
+	kfree(m);
+	return err;
+}
+
+static int __devexit mma8450_remove(struct i2c_client *c)
+{
+	struct mma8450 *m = i2c_get_clientdata(c);
+
+	mma8450_write(m, MMA8450_CTRL_REG1, 0x00);
+	mma8450_write(m, MMA8450_CTRL_REG2, 0x01);
+
+	kfree(m);
+	return 0;
+}
+
+static const struct i2c_device_id mma8450_id[] = {
+	{ MMA8450_DRV_NAME, 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, mma8450_id);
+
+static struct i2c_driver mma8450_driver = {
+	.driver = {
+		.name	= MMA8450_DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mma8450_probe,
+	.remove		= __devexit_p(mma8450_remove),
+	.id_table	= mma8450_id,
+};
+
+static int __init mma8450_init(void)
+{
+	return i2c_add_driver(&mma8450_driver);
+}
+module_init(mma8450_init);
+
+static void __exit mma8450_exit(void)
+{
+	i2c_del_driver(&mma8450_driver);
+}
+module_exit(mma8450_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("MMA8450 3-Axis Accelerometer Driver");
+MODULE_LICENSE("GPL");
