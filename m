Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab2INRtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:49:32 -0400
Received: from relay.ihostexchange.net ([66.46.182.53]:10565 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab2INRtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:49:21 -0400
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
Subject: [PATCH v2 3/3] Input: cyttsp4 - SPI driver for Cypress TMA4XX touchscreen devices
Date: Fri, 14 Sep 2012 20:48:37 +0300
Message-ID: <1347644917-13269-4-git-send-email-fery@cypress.com>
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
devices, SPI adapter module.

This driver adds communication support with TTSP controller
using SPI bus.

Signed-off-by: Ferruh Yigit <fery@cypress.com>
---
 drivers/input/touchscreen/Kconfig       |   12 ++
 drivers/input/touchscreen/Makefile      |    3 +
 drivers/input/touchscreen/cyttsp4_spi.c |  318 +++++++++++++++++++++++++++++++
 drivers/input/touchscreen/cyttsp4_spi.h |   34 ++++
 4 files changed, 367 insertions(+)
 create mode 100644 drivers/input/touchscreen/cyttsp4_spi.c
 create mode 100644 drivers/input/touchscreen/cyttsp4_spi.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index fcc1c82..59706e8 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -224,6 +224,18 @@ config TOUCHSCREEN_CYPRESS_CYTTSP4_I2C
          Say Y here to enable I2C bus interface to TTSP
          touchscreen controller.

+config TOUCHSCREEN_CYPRESS_CYTTSP4_SPI
+       tristate "Cypress TrueTouch Gen4 SPI"
+       depends on TOUCHSCREEN_CYPRESS_CYTTSP4
+       depends on SPI
+       default n
+       help
+         Cypress TrueTouch(tm) Standard Product Generation4
+         SPI bus interface.
+
+         Say Y here to enable SPI bus interface to TTSP
+         touchscreen controller.
+
 config TOUCHSCREEN_DA9034
        tristate "Touchscreen support for Dialog Semiconductor DA9034"
        depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 8f5e8ff..585be70 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -75,12 +75,15 @@ obj-$(CONFIG_TOUCHSCREEN_W90X900)   += w90p910_ts.o
 obj-$(CONFIG_TOUCHSCREEN_TPS6507X)     += tps6507x-ts.o
 obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4)      += cyttsp4_core.o
 obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_I2C)  += cyttsp4_i2c.o
+obj-$(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_SPI)  += cyttsp4_spi.o
 ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_DEBUG),y)
 CFLAGS_cyttsp4_core.o += -DDEBUG
 CFLAGS_cyttsp4_i2c.o += -DDEBUG
+CFLAGS_cyttsp4_spi.o += -DDEBUG
 endif

 ifeq ($(CONFIG_TOUCHSCREEN_CYPRESS_CYTTSP4_VDEBUG),y)
 CFLAGS_cyttsp4_core.o += -DVERBOSE_DEBUG
 CFLAGS_cyttsp4_i2c.o += -DVERBOSE_DEBUG
+CFLAGS_cyttsp4_spi.o += -DVERBOSE_DEBUG
 endif
diff --git a/drivers/input/touchscreen/cyttsp4_spi.c b/drivers/input/touchscreen/cyttsp4_spi.c
new file mode 100644
index 0000000..4aa036e
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_spi.c
@@ -0,0 +1,318 @@
+/*
+ * cyttsp4_spi.c
+ * Cypress TrueTouch(TM) Standard Product V4 SPI Driver module.
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
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+#include <linux/input/cyttsp4.h>
+#include "cyttsp4_core.h"
+#include "cyttsp4_spi.h"
+
+#define CY_SPI_WR_OP           0x00 /* r/~w */
+#define CY_SPI_RD_OP           0x01
+#define CY_SPI_A8_BIT          0x02
+#define CY_SPI_WR_HEADER_BYTES 2
+#define CY_SPI_RD_HEADER_BYTES 1
+#define CY_SPI_SYNC_BYTE       0
+#define CY_SPI_SYNC_ACK                0x62 /* from TRM *A protocol */
+#define CY_SPI_DATA_SIZE       (3 * 256)
+#define CY_SPI_BITS_PER_WORD   8
+#define CY_SPI_MAX_REG         512
+
+#define CY_SPI_MAX_HEADER_BYTES        \
+               max(CY_SPI_WR_HEADER_BYTES, CY_SPI_RD_HEADER_BYTES)
+
+static int cyttsp4_spi_xfer(u8 op, struct spi_device *spi,
+                       u8 reg, u8 *buf, int length)
+{
+       struct device *dev = &spi->dev;
+       struct spi_message msg;
+       struct spi_transfer xfer[2];
+       u8 wr_hdr_buf[CY_SPI_MAX_HEADER_BYTES];
+       u8 rd_hdr_buf[CY_SPI_MAX_HEADER_BYTES];
+       int rc;
+
+       memset(wr_hdr_buf, 0, CY_SPI_MAX_HEADER_BYTES);
+       memset(rd_hdr_buf, 0, CY_SPI_MAX_HEADER_BYTES);
+       memset(xfer, 0, sizeof(xfer));
+
+       spi_message_init(&msg);
+
+       /* Header buffer */
+       xfer[0].tx_buf = wr_hdr_buf;
+       xfer[0].rx_buf = rd_hdr_buf;
+
+       switch (op) {
+       case CY_SPI_WR_OP:
+               if (length + CY_SPI_WR_HEADER_BYTES > CY_SPI_DATA_SIZE) {
+                       dev_vdbg(dev,
+                               "%s: length+%d=%d is greater than SPI max=%d\n",
+                               __func__, CY_SPI_WR_HEADER_BYTES,
+                               length + CY_SPI_WR_HEADER_BYTES,
+                               CY_SPI_DATA_SIZE);
+                       rc = -EINVAL;
+                       goto cyttsp4_spi_xfer_exit;
+               }
+
+               /* Header byte 0 */
+               if (reg > 255)
+                       wr_hdr_buf[0] = CY_SPI_WR_OP + CY_SPI_A8_BIT;
+               else
+                       wr_hdr_buf[0] = CY_SPI_WR_OP;
+
+               /* Header byte 1 */
+               wr_hdr_buf[1] = reg % 256;
+
+               xfer[0].len = CY_SPI_WR_HEADER_BYTES;
+
+               spi_message_add_tail(&xfer[0], &msg);
+
+               /* Data buffer */
+               if (buf) {
+                       xfer[1].tx_buf = buf;
+                       xfer[1].len = length;
+
+                       spi_message_add_tail(&xfer[1], &msg);
+               }
+               break;
+
+       case CY_SPI_RD_OP:
+               if (!buf) {
+                       dev_err(dev, "%s: No read buffer\n", __func__);
+                       rc = -EINVAL;
+                       goto cyttsp4_spi_xfer_exit;
+               }
+
+               if ((length + CY_SPI_RD_HEADER_BYTES) > CY_SPI_DATA_SIZE) {
+                       dev_vdbg(dev,
+                               "%s: length+%d=%d is greater than SPI max=%d\n",
+                               __func__, CY_SPI_RD_HEADER_BYTES,
+                               length + CY_SPI_RD_HEADER_BYTES,
+                               CY_SPI_DATA_SIZE);
+                       rc = -EINVAL;
+                       goto cyttsp4_spi_xfer_exit;
+               }
+
+               /* Header byte 0 */
+               wr_hdr_buf[0] = CY_SPI_RD_OP;
+
+               xfer[0].len = CY_SPI_RD_HEADER_BYTES;
+
+               spi_message_add_tail(&xfer[0], &msg);
+
+               /* Data buffer */
+               xfer[1].rx_buf = buf;
+               xfer[1].len = length;
+
+               spi_message_add_tail(&xfer[1], &msg);
+               break;
+
+       default:
+               dev_dbg(dev, "%s: bad op code=%d\n", __func__, op);
+               rc = -EINVAL;
+               goto cyttsp4_spi_xfer_exit;
+       }
+
+       rc = spi_sync(spi, &msg);
+       if (rc < 0) {
+               dev_vdbg(dev, "%s: spi_sync() error %d, len=%d, op=%d\n",
+                       __func__, rc, xfer[0].len, op);
+               /*
+                * do not return here since probably a bad ACK sequence
+                * let the following ACK check handle any errors and
+                * allow silent retries
+                */
+       }
+
+       if (rd_hdr_buf[CY_SPI_SYNC_BYTE] != CY_SPI_SYNC_ACK)
+               /* signal ACK error so silent retry */
+               rc = 1;
+       else
+               rc = 0;
+
+cyttsp4_spi_xfer_exit:
+       return rc;
+}
+
+static s32 cyttsp4_spi_read_block_data(struct spi_device *spi, u8 addr,
+                               size_t length, void *data)
+{
+       int rc = 0;
+       struct device *dev = &spi->dev;
+
+       dev_vdbg(dev, "%s: Enter\n", __func__);
+
+       /* Write address */
+       rc = cyttsp4_spi_xfer(CY_SPI_WR_OP, spi, addr, NULL, 0);
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail write address r=%d\n", __func__, rc);
+               return rc;
+       }
+
+       /* Read data */
+       rc = cyttsp4_spi_xfer(CY_SPI_RD_OP, spi, addr, data, length);
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail read r=%d\n", __func__, rc);
+               /*
+                * Do not print the above error if the data sync bytes
+                * were not found.
+                * This is a normal condition for the bootloader loader
+                * startup and need to retry until data sync bytes are found.
+                */
+       } else if (rc > 0)
+               /* Now signal fail; so retry can be done */
+               rc = -EIO;
+
+       return rc;
+}
+
+static s32 cyttsp4_spi_write_block_data(struct spi_device *spi, u8 addr,
+                               size_t length, const void *data)
+{
+       int rc = 0;
+       struct device *dev = &spi->dev;
+
+       dev_vdbg(dev, "%s: Enter\n", __func__);
+
+       rc = cyttsp4_spi_xfer(CY_SPI_WR_OP, spi, addr, (void *)data, length);
+       if (rc < 0) {
+               dev_err(dev, "%s: Fail write r=%d\n", __func__, rc);
+               /*
+                * Do not print the above error if the data sync bytes
+                * were not found.
+                * This is a normal condition for the bootloader loader
+                * startup and need to retry until data sync bytes are found.
+                */
+       } else if (rc > 0)
+               /* Now signal fail; so retry can be done */
+               rc = -EIO;
+
+       return rc;
+}
+
+static int cyttsp4_spi_write(struct device *dev, u8 addr,
+               const void *buf, int size)
+{
+       struct spi_device *spi = to_spi_device(dev);
+       int rc;
+
+       rc = cyttsp4_spi_write_block_data(spi, addr, size, buf);
+
+       return rc;
+}
+
+static int cyttsp4_spi_read(struct device *dev, u8 addr,
+               void *buf, int size)
+{
+       struct spi_device *spi = to_spi_device(dev);
+       int rc;
+
+       rc = cyttsp4_spi_read_block_data(spi, addr, size, buf);
+
+       return rc;
+}
+
+static struct cyttsp4_bus_ops ops = {
+       .bustype = BUS_SPI,
+       .write = cyttsp4_spi_write,
+       .read = cyttsp4_spi_read,
+};
+
+static int __devinit cyttsp4_spi_probe(struct spi_device *spi)
+{
+       struct device *dev = &spi->dev;
+       int rc = 0;
+
+       dev_dbg(dev, "%s: Probing ...\n", __func__);
+
+       spi->bits_per_word = CY_SPI_BITS_PER_WORD;
+       spi->mode = SPI_MODE_0;
+
+       rc = spi_setup(spi);
+       if (rc < 0) {
+               dev_err(dev, "%s: SPI setup error %d\n", __func__, rc);
+               return rc;
+       }
+
+       rc = cyttsp4_probe(dev, &ops, NULL);
+       if (rc) {
+               dev_err(dev, "%s: Error on probe %s\n", __func__,
+                       CYTTSP4_SPI_NAME);
+               goto probe_err;
+       }
+
+       dev_info(dev, "%s: Successful prob %s\n", __func__, CYTTSP4_SPI_NAME);
+
+       return 0;
+
+probe_err:
+       return rc;
+}
+
+static int __devexit cyttsp4_spi_remove(struct spi_device *spi)
+{
+       struct device *dev = &spi->dev;
+
+       dev_info(dev, "%s\n", __func__);
+       cyttsp4_remove(dev);
+       return 0;
+}
+
+static struct spi_driver cyttsp4_spi_driver = {
+       .driver = {
+               .name = CYTTSP4_SPI_NAME,
+               .bus = &spi_bus_type,
+               .owner = THIS_MODULE,
+               .pm = &cyttsp4_pm_ops,
+       },
+       .probe = cyttsp4_spi_probe,
+       .remove = __devexit_p(cyttsp4_spi_remove),
+};
+
+static int __init cyttsp4_spi_init(void)
+{
+       int err;
+
+       err = spi_register_driver(&cyttsp4_spi_driver);
+       pr_info("%s: Cypress TTSP SPI Touchscreen Driver (Built %s) returned %d\n",
+                __func__, CY_DRIVER_DATE, err);
+
+       return err;
+}
+module_init(cyttsp4_spi_init);
+
+static void __exit cyttsp4_spi_exit(void)
+{
+       spi_unregister_driver(&cyttsp4_spi_driver);
+       pr_info("%s: module exit\n", __func__);
+}
+module_exit(cyttsp4_spi_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) SPI driver");
+MODULE_AUTHOR("Cypress");
diff --git a/drivers/input/touchscreen/cyttsp4_spi.h b/drivers/input/touchscreen/cyttsp4_spi.h
new file mode 100644
index 0000000..82dc065
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp4_spi.h
@@ -0,0 +1,34 @@
+/*
+ * cyttsp4_spi.h
+ * Cypress TrueTouch(TM) Standard Product V4 SPI Driver module.
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
+#ifndef _LINUX_CYTTSP4_SPI_H
+#define _LINUX_CYTTSP4_SPI_H
+
+#define CYTTSP4_SPI_NAME "cyttsp4_spi_adapter"
+
+#endif /* _LINUX_CYTTSP4_SPI_H */
--
1.7.9.5


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
