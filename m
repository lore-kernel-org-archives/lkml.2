Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2AEAPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:15:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60477 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2AEAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:15:49 -0500
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Mohan Pallaka <mpallaka@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>
Subject: [PATCH v8 2/3] Input: cyttsp - add support for Cypress TTSP touchscreen I2C bus interface
Date: Thu,  5 Jan 2012 01:16:25 +0100
Message-Id: <1325722586-12886-3-git-send-email-javier@dowhile0.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1325722586-12886-1-git-send-email-javier@dowhile0.org>
References: <1325722586-12886-1-git-send-email-javier@dowhile0.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is composed of a core driver that process the data sent by
the contacts and a set of bus specific interface modules.

This patch add supports for the Cypress TTSP I2C bus interface.

Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
---

Changes for v8:
	Javier Martinez Canillas (5):
      	- Check i2c_master_recv() didn't return and error before checking length
	- Check i2c read completed sucessful
	- Define module exit macro in i2c driver
	- Fix return values for I2C transport
	- Add error msg when capability is not supported

 drivers/input/touchscreen/cyttsp_i2c.c |  137 ++++++++++++++++++++++++++++++++
 1 files changed, 137 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c.c

diff --git a/drivers/input/touchscreen/cyttsp_i2c.c b/drivers/input/touchscreen/cyttsp_i2c.c
new file mode 100644
index 0000000..cdbf61d
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_i2c.c
@@ -0,0 +1,137 @@
+/*
+ * Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
+ * For use with Cypress Txx3xx parts.
+ * Supported parts include:
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010, 2011 Cypress Semiconductor, Inc.
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@dowhile0.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, and only version 2, as published by the
+ * Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * Contact Cypress Semiconductor at www.cypress.com <kev@cypress.com>
+ *
+ */
+
+#include "cyttsp_core.h"
+
+#include <linux/i2c.h>
+#include <linux/input.h>
+
+#define CY_I2C_DATA_SIZE  128
+
+static int cyttsp_i2c_read_block_data(struct device *dev,
+				      u8 addr, u8 length, void *values)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	int retval;
+
+	retval = i2c_master_send(client, &addr, 1);
+	if (retval < 0)
+		return retval;
+
+	retval = i2c_master_recv(client, values, length);
+
+	if (retval < 0)
+		return retval;
+
+	return (retval != length) ? -EIO : 0;
+}
+
+static int cyttsp_i2c_write_block_data(struct device *dev,
+				       u8 addr, u8 length, const void *values)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct cyttsp *ts = i2c_get_clientdata(client);
+	int retval;
+
+	ts->xfer_buf[0] = addr;
+	memcpy(&ts->xfer_buf[1], values, length);
+	retval = i2c_master_send(client, ts->xfer_buf, length + 1);
+
+	return (retval < 0) ? retval : 0;
+}
+
+static const struct cyttsp_bus_ops cyttsp_i2c_bus_ops = {
+	.bustype        = BUS_I2C,
+	.write          = cyttsp_i2c_write_block_data,
+	.read           = cyttsp_i2c_read_block_data,
+};
+
+static int __devinit cyttsp_i2c_probe(struct i2c_client *client,
+				      const struct i2c_device_id *id)
+{
+	struct cyttsp *ts;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "I2C functionality not Supported\n");
+		return -EIO;
+	}
+
+	ts = cyttsp_probe(&cyttsp_i2c_bus_ops, &client->dev, client->irq,
+			  CY_I2C_DATA_SIZE);
+
+	if (IS_ERR(ts))
+		return PTR_ERR(ts);
+
+	i2c_set_clientdata(client, ts);
+
+	return 0;
+}
+
+static int __devexit cyttsp_i2c_remove(struct i2c_client *client)
+{
+	struct cyttsp *ts = i2c_get_clientdata(client);
+
+	cyttsp_remove(ts);
+
+	return 0;
+}
+
+static const struct i2c_device_id cyttsp_i2c_id[] = {
+	{ CY_I2C_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cyttsp_i2c_id);
+
+static struct i2c_driver cyttsp_i2c_driver = {
+	.driver = {
+		.name   = CY_I2C_NAME,
+		.owner  = THIS_MODULE,
+		.pm     = &cyttsp_pm_ops,
+	},
+	.probe          = cyttsp_i2c_probe,
+	.remove         = __devexit_p(cyttsp_i2c_remove),
+	.id_table       = cyttsp_i2c_id,
+};
+
+static int __init cyttsp_i2c_init(void)
+{
+	return i2c_add_driver(&cyttsp_i2c_driver);
+}
+module_init(cyttsp_i2c_init);
+
+static void __exit cyttsp_i2c_exit(void)
+{
+	return i2c_del_driver(&cyttsp_i2c_driver);
+}
+module_exit(cyttsp_i2c_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
+MODULE_AUTHOR("Cypress");
+MODULE_ALIAS("i2c:cyttsp");
-- 
1.7.4.1

