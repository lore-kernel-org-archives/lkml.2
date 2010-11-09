Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0KIS00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:26:26 -0500
Received: from ns2.cypress.com ([157.95.67.5]:63556 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0KIS0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:26:22 -0500
From: Kevin McNeely <kev@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Henrik Rydberg <rydberg@euromail.se>, Luotao Fu <l.fu@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: Cypress TTSP G3 MTDEV I2C Device Driver
Date: Tue,  9 Nov 2010 10:25:18 -0800
Message-Id: <1289327120-2612-2-git-send-email-kev@cypress.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <Kevin McNeely <kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial release of Cypress TTSP Gen3 I2C Device Driver.
Provides i2C communication modules for the Cypress
TTSP Gen3 MTDEV Core Driver.

Signed-off-by: Kevin McNeely <kev@cypress.com>
---
 drivers/input/touchscreen/Kconfig      |   10 ++
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/cyttsp_i2c.c |  185 ++++++++++++++++++++++++++++++++
 3 files changed, 196 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp_i2c.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index ee5a31b..bc21ed9 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -132,6 +132,16 @@ config TOUCHSCREEN_CYTTSP_CORE
 
 	  If unsure, say N.
 
+config TOUCHSCREEN_CYTTSP_I2C
+	bool "Cypress TTSP touchscreen I2C driver"
+	depends on I2C
+	depends on TOUCHSCREEN_CYTTSP_CORE
+	help
+	  Say Y here if you have a Cypress TTSP touchscreen
+	  connected to your system with an I2C interface.
+
+	  If unsure, say N.
+
 config TOUCHSCREEN_DA9034
 	tristate "Touchscreen support for Dialog Semiconductor DA9034"
 	depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f629af9..9c142b8 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_I2C)	+= cyttsp_i2c.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
diff --git a/drivers/input/touchscreen/cyttsp_i2c.c b/drivers/input/touchscreen/cyttsp_i2c.c
new file mode 100644
index 0000000..cacfe4d
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_i2c.c
@@ -0,0 +1,185 @@
+/* Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) I2C touchscreen driver.
+ * For use with Cypress Txx3xx parts.
+ * Supported parts include:
+ * CY8CTST341
+ * CY8CTMA340
+ *
+ * Copyright (C) 2009, 2010 Cypress Semiconductor, Inc.
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
+#include <linux/slab.h>
+
+#define CY_I2C_DATA_SIZE  128
+
+struct cyttsp_i2c {
+	struct cyttsp_bus_ops ops;
+	struct i2c_client *client;
+	void *ttsp_client;
+	u8 wr_buf[CY_I2C_DATA_SIZE];
+};
+
+static s32 ttsp_i2c_read_block_data(void *handle, u8 addr,
+	u8 length, void *values)
+{
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+	int retval = 0;
+
+	retval = i2c_master_send(ts->client, &addr, 1);
+	if (retval < 0)
+		return retval;
+
+	retval = i2c_master_recv(ts->client, values, length);
+
+	return (retval < 0) ? retval : 0;
+}
+
+static s32 ttsp_i2c_write_block_data(void *handle, u8 addr,
+	u8 length, const void *values)
+{
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+	int retval;
+
+	ts->wr_buf[0] = addr;
+	memcpy(&ts->wr_buf[1], values, length);
+
+	retval = i2c_master_send(ts->client, ts->wr_buf, length+1);
+
+	return (retval < 0) ? retval : 0;
+}
+
+static s32 ttsp_i2c_tch_ext(void *handle, void *values)
+{
+	struct cyttsp_i2c *ts = container_of(handle, struct cyttsp_i2c, ops);
+	int retval = 0;
+
+	/* TODO: Add custom touch extension handling code here
+	 * set: retval < 0 for any returned system errors,
+	 *	retval = 0 if normal touch handling is required,
+	 *	retval > 0 if normal touch handling is *not* required
+	 */
+	if (!ts || !values)
+		retval = -EIO;
+
+	return retval;
+}
+static int __devinit cyttsp_i2c_probe(struct i2c_client *client,
+	const struct i2c_device_id *id)
+{
+	struct cyttsp_i2c *ts;
+	int retval;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -EIO;
+
+	/* allocate and clear memory */
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (ts == NULL) {
+		dev_dbg(&client->dev, "%s: Error, kzalloc.\n", __func__);
+		retval = -ENOMEM;
+		goto error_alloc_data_failed;
+	}
+
+	/* register driver_data */
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+	ts->ops.write = ttsp_i2c_write_block_data;
+	ts->ops.read = ttsp_i2c_read_block_data;
+	ts->ops.ext = ttsp_i2c_tch_ext;
+	ts->ops.dev = &client->dev;
+	ts->ops.dev->bus = &i2c_bus_type;
+
+	retval = cyttsp_core_init(&ts->ops, &client->dev, &ts->ttsp_client);
+	if (retval)
+		goto ttsp_core_err;
+
+	dev_dbg(ts->ops.dev, "%s: Registration complete\n", __func__);
+
+	return 0;
+
+ttsp_core_err:
+	kfree(ts);
+error_alloc_data_failed:
+	return retval;
+}
+
+
+/* registered in driver struct */
+static int __devexit cyttsp_i2c_remove(struct i2c_client *client)
+{
+	struct cyttsp_i2c *ts;
+
+	ts = i2c_get_clientdata(client);
+	cyttsp_core_release(ts->ttsp_client);
+	kfree(ts);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cyttsp_i2c_suspend(struct i2c_client *client, pm_message_t message)
+{
+	return cyttsp_suspend(dev_get_drvdata(&client->dev));
+}
+
+static int cyttsp_i2c_resume(struct i2c_client *client)
+{
+	return cyttsp_resume(dev_get_drvdata(&client->dev));
+}
+#endif
+
+static const struct i2c_device_id cyttsp_i2c_id[] = {
+	{ CY_I2C_NAME, 0 },  { }
+};
+
+static struct i2c_driver cyttsp_i2c_driver = {
+	.driver = {
+		.name = CY_I2C_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = cyttsp_i2c_probe,
+	.remove = __devexit_p(cyttsp_i2c_remove),
+	.id_table = cyttsp_i2c_id,
+#ifdef CONFIG_PM
+	.suspend = cyttsp_i2c_suspend,
+	.resume = cyttsp_i2c_resume,
+#endif
+};
+
+static int __init cyttsp_i2c_init(void)
+{
+	return i2c_add_driver(&cyttsp_i2c_driver);
+}
+
+static void __exit cyttsp_i2c_exit(void)
+{
+	return i2c_del_driver(&cyttsp_i2c_driver);
+}
+
+module_init(cyttsp_i2c_init);
+module_exit(cyttsp_i2c_exit);
+
+MODULE_ALIAS("i2c:cyttsp");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
+MODULE_AUTHOR("Cypress");
+MODULE_DEVICE_TABLE(i2c, cyttsp_i2c_id);
-- 
1.7.2.1

