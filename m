Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2LLWFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:05:21 -0500
Received: from mail-vc0-f201.google.com ([209.85.220.201]:59391 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2LLWFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:05:19 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2012 17:05:18 EST
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 3/5] mfd: Add ChromeOS EC I2C driver
Date: Wed, 12 Dec 2012 13:33:46 -0800
Message-Id: <1355348028-19017-4-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1355348028-19017-1-git-send-email-sjg@chromium.org>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses an I2C bus to talk to the ChromeOS EC. The protocol
is defined by the EC and is fairly simple, with a length byte,
checksum, command byte and version byte (to permit easy creation
of new commands).

Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/mfd/Kconfig       |   10 ++
 drivers/mfd/Makefile      |    1 +
 drivers/mfd/cros_ec_i2c.c |  262 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/cros_ec_i2c.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6983eb4..9351614 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -29,6 +29,16 @@ config MFD_CROS_EC
 	  You also ned to enable the driver for the bus you are using. The
 	  protocol for talking to the EC is defined by the bus driver.
 
+config MFD_CROS_EC_I2C
+	tristate "ChromeOS Embedded Controller (I2C)"
+	depends on MFD_CROS_EC && I2C
+
+	help
+	  If you say here, you get support for talking to the ChromeOS EC
+	  through an I2C bus. This uses a simple byte-level protocol with
+	  a checksum. Failing accesses will be retried three times to
+	  improve reliability.
+
 config MFD_88PM800
 	tristate "Support Marvell 88PM800"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5a9c9f6..603912e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
 obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
+obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 
 rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
diff --git a/drivers/mfd/cros_ec_i2c.c b/drivers/mfd/cros_ec_i2c.c
new file mode 100644
index 0000000..6b112ad
--- /dev/null
+++ b/drivers/mfd/cros_ec_i2c.c
@@ -0,0 +1,262 @@
+/*
+ * ChromeOS EC multi-function device (I2C)
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+
+/* Since I2C can be unreliable, we retry commands */
+#define COMMAND_MAX_TRIES 3
+
+static inline struct cros_ec_device *to_ec_dev(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_get_clientdata(client);
+}
+
+static int cros_ec_command_xfer_noretry(struct cros_ec_device *ec_dev,
+					struct cros_ec_msg *msg)
+{
+	struct i2c_client *client = ec_dev->priv;
+	int ret = -ENOMEM;
+	int i;
+	int packet_len;
+	u8 *out_buf = NULL;
+	u8 *in_buf = NULL;
+	u8 sum;
+	struct i2c_msg i2c_msg[2];
+
+	i2c_msg[0].addr = client->addr;
+	i2c_msg[0].flags = 0;
+	i2c_msg[1].addr = client->addr;
+	i2c_msg[1].flags = I2C_M_RD;
+
+	/*
+	 * allocate larger packet (one byte for checksum, one byte for
+	 * length, and one for result code)
+	 */
+	packet_len = msg->in_len + 3;
+	in_buf = kzalloc(packet_len, GFP_KERNEL);
+	if (!in_buf)
+		goto done;
+	i2c_msg[1].len = packet_len;
+	i2c_msg[1].buf = (char *)in_buf;
+
+	/*
+	 * allocate larger packet (one byte for checksum, one for
+	 * command code, one for length, and one for command version)
+	 */
+	packet_len = msg->out_len + 4;
+	out_buf = kzalloc(packet_len, GFP_KERNEL);
+	if (!out_buf)
+		goto done;
+	i2c_msg[0].len = packet_len;
+	i2c_msg[0].buf = (char *)out_buf;
+
+	out_buf[0] = EC_CMD_VERSION0 + msg->version;
+	out_buf[1] = msg->cmd;
+	out_buf[2] = msg->out_len;
+
+	/* copy message payload and compute checksum */
+	sum = out_buf[0] + out_buf[1] + out_buf[2];
+	for (i = 0; i < msg->out_len; i++) {
+		out_buf[3 + i] = msg->out_buf[i];
+		sum += out_buf[3 + i];
+	}
+	out_buf[3 + msg->out_len] = sum;
+
+	/* send command to EC and read answer */
+	ret = i2c_transfer(client->adapter, i2c_msg, 2);
+	if (ret < 0) {
+		dev_err(ec_dev->dev, "i2c transfer failed: %d\n", ret);
+		goto done;
+	} else if (ret != 2) {
+		dev_err(ec_dev->dev, "failed to get response: %d\n", ret);
+		ret = -EIO;
+		goto done;
+	}
+
+	/* check response error code */
+	if (i2c_msg[1].buf[0]) {
+		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
+			 msg->cmd, i2c_msg[1].buf[0]);
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* copy response packet payload and compute checksum */
+	sum = in_buf[0] + in_buf[1];
+	for (i = 0; i < msg->in_len; i++) {
+		msg->in_buf[i] = in_buf[2 + i];
+		sum += in_buf[2 + i];
+	}
+#ifdef DEBUG
+	dev_dbg(ec_dev->dev, "packet: ");
+	for (i = 0; i < i2c_msg[1].len; i++)
+		dev_cont(ec_dev->dev, " %02x", in_buf[i]);
+	dev_cont(ec_dev->dev, ", sum = %02x\n", sum);
+#endif
+	if (sum != in_buf[2 + msg->in_len]) {
+		dev_err(ec_dev->dev, "bad packet checksum\n");
+		ret = -EBADMSG;
+		goto done;
+	}
+
+	ret = 0;
+ done:
+	kfree(in_buf);
+	kfree(out_buf);
+	return ret;
+}
+
+static int cros_ec_command_xfer(struct cros_ec_device *ec_dev,
+				 struct cros_ec_msg *msg)
+{
+	int tries;
+	int ret;
+	/*
+	 * Try the command a few times in case there are transmission errors.
+	 * It is possible that this is overkill, but we don't completely trust
+	 * i2c.
+	 */
+	for (tries = 0; tries < COMMAND_MAX_TRIES; tries++) {
+		ret = cros_ec_command_xfer_noretry(ec_dev, msg);
+		if (ret >= 0)
+			return ret;
+	}
+	dev_err(ec_dev->dev, "ec_command failed with %d (%d tries)\n",
+		ret, tries);
+	return ret;
+}
+
+static const char *cros_ec_get_name(struct cros_ec_device *ec_dev)
+{
+	struct i2c_client *client = ec_dev->priv;
+
+	return client->name;
+}
+
+static const char *cros_ec_get_phys_name(struct cros_ec_device *ec_dev)
+{
+	struct i2c_client *client = ec_dev->priv;
+
+	return client->adapter->name;
+}
+
+static struct device *cros_ec_get_parent(struct cros_ec_device *ec_dev)
+{
+	struct i2c_client *client = ec_dev->priv;
+
+	return &client->dev;
+}
+
+static int __devinit cros_ec_probe_i2c(struct i2c_client *client,
+				   const struct i2c_device_id *dev_id)
+{
+	struct device *dev = &client->dev;
+	struct cros_ec_device *ec_dev = NULL;
+	int err;
+
+	if (dev->of_node && !of_device_is_available(dev->of_node)) {
+		dev_warn(dev, "Device disabled by device tree\n");
+		return -ENODEV;
+	}
+
+	ec_dev = cros_ec_alloc("I2C");
+	if (!ec_dev) {
+		err = -ENOMEM;
+		dev_err(dev, "cannot create cros_ec\n");
+		goto fail;
+	}
+
+	i2c_set_clientdata(client, ec_dev);
+	ec_dev->dev = dev;
+	ec_dev->priv = client;
+	ec_dev->irq = client->irq;
+	ec_dev->command_xfer = cros_ec_command_xfer;
+	ec_dev->get_name = cros_ec_get_name;
+	ec_dev->get_phys_name = cros_ec_get_phys_name;
+	ec_dev->get_parent = cros_ec_get_parent;
+
+	err = cros_ec_register(ec_dev);
+	if (err) {
+		dev_err(dev, "cannot register EC\n");
+		goto fail_register;
+	}
+
+	return 0;
+fail_register:
+	cros_ec_free(ec_dev);
+fail:
+	return err;
+}
+
+static int __devexit cros_ec_remove_i2c(struct i2c_client *client)
+{
+	struct cros_ec_device *ec_dev = i2c_get_clientdata(client);
+
+	cros_ec_remove(ec_dev);
+	cros_ec_free(ec_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int cros_ec_i2c_suspend(struct device *dev)
+{
+	struct cros_ec_device *ec_dev = to_ec_dev(dev);
+
+	return cros_ec_suspend(ec_dev);
+}
+
+static int cros_ec_i2c_resume(struct device *dev)
+{
+	struct cros_ec_device *ec_dev = to_ec_dev(dev);
+
+	return cros_ec_resume(ec_dev);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(cros_ec_i2c_pm_ops, cros_ec_i2c_suspend,
+			  cros_ec_i2c_resume);
+
+static const struct i2c_device_id cros_ec_i2c_id[] = {
+	{ "cros-ec-i2c", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cros_ec_i2c_id);
+
+static struct i2c_driver cros_ec_driver = {
+	.driver	= {
+		.name	= "cros-ec-i2c",
+		.owner	= THIS_MODULE,
+		.pm	= &cros_ec_i2c_pm_ops,
+	},
+	.probe		= cros_ec_probe_i2c,
+	.remove		= cros_ec_remove_i2c,
+	.id_table	= cros_ec_i2c_id,
+};
+
+module_i2c_driver(cros_ec_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ChromeOS EC multi function device");
-- 
1.7.7.3

