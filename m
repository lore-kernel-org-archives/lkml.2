Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0KIS0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:26:21 -0500
Received: from ns2.cypress.com ([157.95.67.5]:63548 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab0KIS0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:26:16 -0500
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
Subject: [PATCH] spi: Cypress TTSP G3 MTDEV SPI Device Driver
Date: Tue,  9 Nov 2010 10:25:19 -0800
Message-Id: <1289327120-2612-3-git-send-email-kev@cypress.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <Kevin McNeely <kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial release of Cypress TTSP Gen3 SPI Device Driver.
Provides SPI communication modules for the Cypress
TTSP Gen3 MTDEV Core Driver.

Signed-off-by: Kevin McNeely <kev@cypress.com>
---
 drivers/input/touchscreen/Kconfig      |   10 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/cyttsp_spi.c |  303 ++++++++++++++++++++++++++++++++
 3 files changed, 314 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/touchscreen/cyttsp_spi.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index ee5a31b..052d5e2 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -132,6 +132,16 @@ config TOUCHSCREEN_CYTTSP_CORE
 
 	  If unsure, say N.
 
+config TOUCHSCREEN_CYTTSP_SPI
+	bool "Cypress TTSP touchscreen SPI driver"
+	depends on SPI_MASTER
+	depends on TOUCHSCREEN_CYTTSP_CORE
+	help
+	  Say Y here if you have a Cypress TTSP touchscreen
+	  connected to your system with a SPI interface.
+
+	  If unsure, say N.
+
 config TOUCHSCREEN_DA9034
 	tristate "Touchscreen support for Dialog Semiconductor DA9034"
 	depends on PMIC_DA903X
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f629af9..89557f2 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
new file mode 100644
index 0000000..9f05de4
--- /dev/null
+++ b/drivers/input/touchscreen/cyttsp_spi.c
@@ -0,0 +1,303 @@
+/* Source for:
+ * Cypress TrueTouch(TM) Standard Product (TTSP) SPI touchscreen driver.
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
+#include <linux/spi/spi.h>
+#include <linux/delay.h>
+
+#define CY_SPI_WR_OP      0x00 /* r/~w */
+#define CY_SPI_RD_OP      0x01
+#define CY_SPI_CMD_BYTES  4
+#define CY_SPI_SYNC_BYTES 2
+#define CY_SPI_SYNC_ACK1  0x62 /* from protocol v.2 */
+#define CY_SPI_SYNC_ACK2  0x9D /* from protocol v.2 */
+#define CY_SPI_DATA_SIZE  128
+#define CY_SPI_DATA_BUF_SIZE (CY_SPI_CMD_BYTES + CY_SPI_DATA_SIZE)
+#define CY_SPI_BITS_PER_WORD 8
+
+struct cyttsp_spi {
+	struct cyttsp_bus_ops ops;
+	struct spi_device *spi_client;
+	void *ttsp_client;
+	u8 wr_buf[CY_SPI_DATA_BUF_SIZE];
+	u8 rd_buf[CY_SPI_DATA_BUF_SIZE];
+};
+
+static void spi_complete(void *arg)
+{
+	complete(arg);
+}
+
+static int spi_sync_tmo(struct cyttsp_spi *ts, struct spi_message *message)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+	int status;
+
+	message->complete = spi_complete;
+	message->context = &done;
+	status = spi_async(ts->spi_client, message);
+	if (status == 0) {
+		int ret = wait_for_completion_interruptible_timeout(&done, HZ);
+		if (!ret) {
+			dev_dbg(ts->ops.dev, "%s: timeout\n", __func__);
+			status = -EIO;
+		} else
+			status = message->status;
+	}
+	message->context = NULL;
+	return status;
+}
+
+static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts,
+			    u8 reg, u8 *buf, int length)
+{
+	struct spi_message msg;
+	struct spi_transfer xfer = { 0 };
+	u8 *wr_buf = ts->wr_buf;
+	u8 *rd_buf = ts->rd_buf;
+	int retval;
+	int i;
+
+	if (length > CY_SPI_DATA_SIZE) {
+		dev_dbg(ts->ops.dev, "%s: length %d is too big.\n",
+			__func__, length);
+		return -EINVAL;
+	}
+	dev_dbg(ts->ops.dev, "%s: OP=%s length=%d\n", __func__,
+		   op == CY_SPI_RD_OP ? "Read" : "Write", length);
+
+	wr_buf[0] = 0x00; /* header byte 0 */
+	wr_buf[1] = 0xFF; /* header byte 1 */
+	wr_buf[2] = reg;  /* reg index */
+	wr_buf[3] = op;   /* r/~w */
+	if (op == CY_SPI_WR_OP)
+		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
+
+	xfer.tx_buf = wr_buf;
+	xfer.rx_buf = rd_buf;
+	xfer.len = length + CY_SPI_CMD_BYTES;
+
+	if ((op == CY_SPI_RD_OP) && (xfer.len < 32))
+		xfer.len += 1;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+	retval = spi_sync_tmo(ts, &msg);
+	if (retval < 0) {
+		dev_dbg(ts->ops.dev, "%s: spi_sync_tmo() error %d\n",
+			__func__, retval);
+		retval = 0;
+	}
+	if (op == CY_SPI_RD_OP) {
+		for (i = 0; i < (length + CY_SPI_CMD_BYTES - 1); i++) {
+			if ((rd_buf[i] != CY_SPI_SYNC_ACK1) ||
+				(rd_buf[i + 1] != CY_SPI_SYNC_ACK2)) {
+				continue;
+			}
+			if (i <= (CY_SPI_CMD_BYTES - 1)) {
+				memcpy(buf, (rd_buf + i + CY_SPI_SYNC_BYTES),
+					length);
+				return 0;
+			}
+		}
+		dev_dbg(ts->ops.dev, "%s: byte sync error\n", __func__);
+		retval = 1;
+	}
+	return retval;
+}
+
+static int cyttsp_spi_xfer(u8 op, struct cyttsp_spi *ts,
+			    u8 reg, u8 *buf, int length)
+{
+	int tries;
+	int retval;
+
+	if (op == CY_SPI_RD_OP) {
+		for (tries = CY_NUM_RETRY; tries; tries--) {
+			retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
+			if (retval == 0)
+				break;
+			else
+				msleep(20);
+		}
+	} else {
+		retval = cyttsp_spi_xfer_(op, ts, reg, buf, length);
+	}
+
+	return retval;
+}
+
+static s32 ttsp_spi_read_block_data(void *handle, u8 addr,
+				    u8 length, void *data)
+{
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+	int retval;
+
+	retval = cyttsp_spi_xfer(CY_SPI_RD_OP, ts, addr, data, length);
+	if (retval < 0)
+		dev_dbg(ts->ops.dev,  "%s: ttsp_spi_read_block_data failed\n",
+			__func__);
+
+	/* Do not print the above error if the data sync bytes were not found.
+	 * This is a normal condition for the bootloader loader startup and need
+	 * to retry until data sync bytes are found.
+	 */
+	if (retval > 0)
+		retval = -1;	/* now signal fail; so retry can be done */
+
+	return retval;
+}
+
+static s32 ttsp_spi_write_block_data(void *handle, u8 addr,
+				     u8 length, const void *data)
+{
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+	int retval;
+
+	retval = cyttsp_spi_xfer(CY_SPI_WR_OP, ts, addr, (void *)data, length);
+	if (retval < 0)
+		dev_dbg(ts->ops.dev, "%s: ttsp_spi_write_block_data failed\n",
+			__func__);
+
+	if (retval == -EIO)
+		return 0;
+	else
+		return retval;
+}
+
+static s32 ttsp_spi_tch_ext(void *handle, void *values)
+{
+	struct cyttsp_spi *ts = container_of(handle, struct cyttsp_spi, ops);
+	int retval = 0;
+
+	/* TODO: Add custom touch extension handling code here
+	 * set: retval < 0 for any returned system errors,
+	 *	retval = 0 if normal touch handling is required,
+	 *	retval > 0 if normal touch handling is *not* required
+	 */
+
+	if (!ts || !values)
+		retval = -EIO;
+
+	return retval;
+}
+
+static int __devinit cyttsp_spi_probe(struct spi_device *spi)
+{
+	struct cyttsp_spi *ts;
+	int retval;
+
+	/* Set up SPI*/
+	spi->bits_per_word = CY_SPI_BITS_PER_WORD;
+	spi->mode = SPI_MODE_0;
+	retval = spi_setup(spi);
+	if (retval < 0) {
+		dev_dbg(&spi->dev, "%s: SPI setup error %d\n",
+			__func__, retval);
+		return retval;
+	}
+
+	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
+	if (ts == NULL) {
+		dev_dbg(&spi->dev, "%s: Error, kzalloc\n", __func__);
+		retval = -ENOMEM;
+		goto error_alloc_data_failed;
+	}
+	ts->spi_client = spi;
+	dev_set_drvdata(&spi->dev, ts);
+	ts->ops.write = ttsp_spi_write_block_data;
+	ts->ops.read = ttsp_spi_read_block_data;
+	ts->ops.ext = ttsp_spi_tch_ext;
+	ts->ops.dev = &spi->dev;
+
+	retval = cyttsp_core_init(&ts->ops, &spi->dev,  &ts->ttsp_client);
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
+static int __devexit cyttsp_spi_remove(struct spi_device *spi)
+{
+	struct cyttsp_spi *ts = dev_get_drvdata(&spi->dev);
+
+	cyttsp_core_release(ts->ttsp_client);
+	kfree(ts);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int cyttsp_spi_suspend(struct spi_device *spi, pm_message_t message)
+{
+	return cyttsp_suspend(dev_get_drvdata(&spi->dev));
+}
+
+static int cyttsp_spi_resume(struct spi_device *spi)
+{
+	return cyttsp_resume(dev_get_drvdata(&spi->dev));
+}
+#endif
+
+static struct spi_driver cyttsp_spi_driver = {
+	.driver = {
+		.name = CY_SPI_NAME,
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe = cyttsp_spi_probe,
+	.remove = __devexit_p(cyttsp_spi_remove),
+#ifdef CONFIG_PM
+	.suspend = cyttsp_spi_suspend,
+	.resume = cyttsp_spi_resume,
+#endif
+};
+
+static int __init cyttsp_spi_init(void)
+{
+	return spi_register_driver(&cyttsp_spi_driver);
+}
+module_init(cyttsp_spi_init);
+
+static void __exit cyttsp_spi_exit(void)
+{
+	spi_unregister_driver(&cyttsp_spi_driver);
+}
+module_exit(cyttsp_spi_exit);
+
+MODULE_ALIAS("spi:cyttsp");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Cypress TrueTouch(R) Standard Product (TTSP) SPI driver");
+MODULE_AUTHOR("Cypress");
+
-- 
1.7.2.1

