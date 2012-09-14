Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab2INRtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:49:14 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:10485 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab2INRtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:49:12 -0400
From: Ferruh Yigit <fery@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Kevin McNeely <kev@cypress.com>, Phil Warkentin <pwar@cypress.com>,
        Ferruh Yigit <fery@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] Input: cyttsp4 - I2C driver for Cypress TMA4XX touchscreen devices
Date: Fri, 14 Sep 2012 20:48:36 +0300
Message-ID: <1347644917-13269-3-git-send-email-fery@cypress.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347644917-13269-1-git-send-email-fery@cypress.com>
References: <Ferruh Yigit <fery@cypress.com>
 <1347644917-13269-1-git-send-email-fery@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cypress TrueTouch(tm) Standard Product controllers, Generation4
devices, I2C adapter module.

This driver adds communication support with TTSP controller
using I2C bus.

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Kconfig       |   12 ++
 drivers/input/touchscreen/Makefile      |    3 +
 drivers/input/touchscreen/cyttsp4_i2c.c |  191 +++++++++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp4_i2c.h |   34 ++++++
 4 files changed, 240 insertions(+)
 create mode 100644 drivers/input/touchscreen/cyttsp4_i2c.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_i2c.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index d6ebd4c..fcc1c82 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -212,6 +212,18 @@ config TOUCHSCREEN_CYPRESS_CYTTSP4_VDEBUG

          Say Y here to enable verbose debug output.

+config TOUCHSCREEN_CYPRESS_CYTTSP4_I2C
+       tristate "Cypress TrueTouch Gen4 I2C"
+       depends on TOUCHSCREEN_CYPRESS_CYTTSP4
+       depends on I2C
+       default n
+       help
+         Cypress TrueTouch(tm) Standard Product Generation4
+         I2C bus interface.
+
+         Say Y here to enable I2C bus interface to TTSP
+         touchscreen controller.
+
 config TOUCHSCREEN_DA9034
        tristate "Touchscreen support for Dialog Semiconductor DA9034"
        depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 1cdab28..8f5e8ff 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -74,10 +74,13 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)   += zylonite-wm97xx.o
 obj-$(CONFIG_TOUCHSCREEN_W90X900)      += w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)     += tps6507x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4)      += cyttsp4_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_I2C)  += cyttsp4_i2c.o
 ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_DEBUG),y)
 CFLAGS_cyttsp4_core.o += -DDEBUG
+CFLAGS_cyttsp4_i2c.o += -DDEBUG
 endif

 ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_VDEBUG),y)
 CFLAGS_cyttsp4_core.o += -DVERBOSE_DEBUG
+CFLAGS_cyttsp4_i2c.o += -DVERBOSE_DEBUG
 endif
diff --git a/drivers/input/touchscreen/cyttsp4_i2c.c b/drivers/input/touchscreen/cyttsp4_i2c.c
new file mode 100644
index 0000000..0faf0f7
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_i2c.c
@@ -0,0 +1,191 @@
+/*
+ * cyttsp4_i2c.c
+ * Cypress TrueTouch(TM) Standard Product V4 I2C Driver module.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2012 Cypress Semiconductor
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
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/input/cyttsp4.h>
+#include "cyttsp4_core.h"
+#include "cyttsp4_i2c.h"
+
+#define CY_I2C_DATA_SIZE       256
+
+static int cyttsp4_i2c_read_block_data(struct i2c_client *client, u8 addr,
+       size_t length, void *values)
+{
+       int rc;
+
+       /* write addr */
+       rc = i2c_master_send(client, &addr, sizeof(addr));
+       if (rc < 0)
+               return rc;
+       else if (rc != sizeof(addr))
+               return -EIO;
+
+       /* read data */
+       rc = i2c_master_recv(client, values, length);
+
+       return (rc < 0) ? rc : rc != length ? -EIO : 0;
+}
+
+static int cyttsp4_i2c_write_block_data(struct i2c_client *client, u8 addr,
+       size_t length, const void *values)
+{
+       int rc;
+       u8 *wr_buf = cyttsp4_get_xfer_buf(&client->dev);
+
+       if (length + 1 > CY_I2C_DATA_SIZE)
+               return -EINVAL;
+
+       wr_buf[0] = addr;
+       memcpy(&wr_buf[1], values, length);
+       length += 1;
+
+       /* write data */
+       rc = i2c_master_send(client, wr_buf, length);
+
+       return (rc < 0) ? rc : rc != length ? -EIO : 0;
+}
+
+static int cyttsp4_i2c_write(struct device *dev, u8 addr,
+       const void *buf, int size)
+{
+       struct i2c_client *client = to_i2c_client(dev);
+       int rc;
+
+       rc = cyttsp4_i2c_write_block_data(client, addr, size, buf);
+
+       return rc;
+}
+
+static int cyttsp4_i2c_read(struct device *dev, u8 addr,
+               void *buf, int size)
+{
+       struct i2c_client *client = to_i2c_client(dev);
+       int rc;
+
+       rc = cyttsp4_i2c_read_block_data(client, addr, size, buf);
+
+       return rc;
+}
+
+static struct cyttsp4_bus_ops ops = {
+       .bustype = BUS_I2C,
+       .write = cyttsp4_i2c_write,
+       .read = cyttsp4_i2c_read,
+};
+
+static int __devinit cyttsp4_i2c_probe(struct i2c_client *client,
+       const struct i2c_device_id *i2c_id)
+{
+       struct device *dev = &client->dev;
+       u8 *xfer_buf;
+       int rc;
+
+       dev_info(dev, "%s: Starting %s probe...\n", __func__, CYTTSP4_I2C_NAME);
+
+       dev_dbg(dev, "%s: debug on\n", __func__);
+       dev_vdbg(dev, "%s: verbose debug on\n", __func__);
+
+       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+               dev_err(dev, "%s: fail check I2C functionality\n", __func__);
+               return -EIO;
+       }
+
+       xfer_buf = kmalloc(CY_I2C_DATA_SIZE, GFP_KERNEL);
+       if (!xfer_buf) {
+               dev_err(dev, "%s: Error, kmalloc\n", __func__);
+               return -ENOMEM;
+       }
+
+       client->dev.bus = &i2c_bus_type;
+
+       rc = cyttsp4_probe(dev, &ops, xfer_buf);
+       if (rc) {
+               dev_err(dev, "%s: Error on probe %s\n", __func__,
+                       CYTTSP4_I2C_NAME);
+               goto probe_err;
+       }
+
+       dev_info(dev, "%s: Successful probe %s\n", __func__, CYTTSP4_I2C_NAME);
+
+       return 0;
+
+probe_err:
+       kfree(xfer_buf);
+       return rc;
+}
+
+static int __devexit cyttsp4_i2c_remove(struct i2c_client *client)
+{
+       struct device *dev = &client->dev;
+       u8 *xfer_buf = cyttsp4_get_xfer_buf(dev);
+
+       dev_info(dev, "%s\n", __func__);
+       cyttsp4_remove(dev);
+       kfree(xfer_buf);
+       return 0;
+}
+
+static const struct i2c_device_id cyttsp4_i2c_id[] = {
+       { CYTTSP4_I2C_NAME, 0 },  { }
+};
+
+static struct i2c_driver cyttsp4_i2c_driver = {
+       .driver = {
+               .name = CYTTSP4_I2C_NAME,
+               .owner = THIS_MODULE,
+               .pm = &cyttsp4_pm_ops,
+       },
+       .probe = cyttsp4_i2c_probe,
+       .remove = __devexit_p(cyttsp4_i2c_remove),
+       .id_table = cyttsp4_i2c_id,
+};
+
+static int __init cyttsp4_i2c_init(void)
+{
+       int rc = i2c_add_driver(&cyttsp4_i2c_driver);
+
+       pr_info("%s: Cypress TTSP I2C Touchscreen Driver (Built %s) rc=%d\n",
+                __func__, CY_DRIVER_DATE, rc);
+       return rc;
+}
+module_init(cyttsp4_i2c_init);
+
+static void __exit cyttsp4_i2c_exit(void)
+{
+       i2c_del_driver(&cyttsp4_i2c_driver);
+       pr_info("%s: module exit\n", __func__);
+}
+module_exit(cyttsp4_i2c_exit);
+
+MODULE_ALIAS(CYTTSP4_I2C_NAME);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) I2C driver");
+MODULE_AUTHOR("Cypress");
+MODULE_DEVICE_TABLE(i2c, cyttsp4_i2c_id);
diff --git a/drivers/input/touchscreen/cyttsp4_i2c.h b/drivers/input/touchscreen/cyttsp4_i2c.h
new file mode 100644
index 0000000..5137102
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_i2c.h
@@ -0,0 +1,34 @@
+/*
+ * cyttsp4_i2c.h
+ * Cypress TrueTouch(TM) Standard Product V4 I2C driver module.
+ * For use with Cypress Txx4xx parts.
+ * Supported parts include:
+ * TMA4XX
+ * TMA1036
+ *
+ * Copyright (C) 2012 Cypress Semiconductor
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
+ * Contact Cypress Semiconductor at www.cypress.com <ttdrivers@cypress.com>
+ *
+ */
+
+#ifndef _LINUX_CYTTSP4_I2C_H
+#define _LINUX_CYTTSP4_I2C_H
+
+#define CYTTSP4_I2C_NAME "cyttsp4_i2c_adapter"
+
+#endif /* _LINUX_CYTTSP4_I2C_H */
--
1.7.9.5


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
