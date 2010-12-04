Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0LDCGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 21:06:32 -0500
Received: from ns2.cypress.com ([157.95.67.5]:33565 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab0LDCG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 21:06:29 -0500
From: Kevin McNeely <kev@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Brown <davidb@codeaurora.org>, Trilok Soni <tsoni@codeaurora.org>,
        Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Luotao Fu <l.fu@pengutronix.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v2] 3/3 spi: Cypress TTSP G3 MTDEV SPI Device Driver
Date: Fri,  3 Dec 2010 18:06:23 -0800
Message-Id: <1291428384-26364-3-git-send-email-kev@cypress.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <Kevin McNeely <kev@cypress.com>
References: <Kevin McNeely <kev@cypress.com>
X-Brightmail-Tracker: AAAAAA==
MIME-Version: 1.0
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amended version of Cypress TTSP Gen3 SPI Device Driver.
Provides spi communications modules for the Cypress
TTSP Gen3 MTDEV Core Driver.
Amendments include changes recommended by reviewers of
initial version.

Signed-off-by: Kevin McNeely <kev@cypress.com>
---
 drivers/input/touchscreen/Makefile     |    4 +-
 drivers/input/touchscreen/cyttsp_spi.c |   84 +++++++++++++++++--------------
 2 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 89557f2..c52c0f5 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -16,8 +16,8 @@ obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
 obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)	+= cy8ctmg110_ts.o
-obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)	+= cyttsp_core.o
-obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)	+= cyttsp_spi.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_CORE)   += cyttsp_core.o
+obj-$(CONFIG_TOUCHSCREEN_CYTTSP_SPI)    += cyttsp_spi.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)	+= da9034-ts.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
diff --git a/drivers/input/touchscreen/cyttsp_spi.c b/drivers/input/touchscreen/cyttsp_spi.c
index 9f05de4..27b8347 100644
--- a/drivers/input/touchscreen/cyttsp_spi.c
+++ b/drivers/input/touchscreen/cyttsp_spi.c
@@ -33,7 +33,7 @@
 #define CY_SPI_WR_OP      0x00 /* r/~w */
 #define CY_SPI_RD_OP      0x01
 #define CY_SPI_CMD_BYTES  4
-#define CY_SPI_SYNC_BYTES 2
+#define CY_SPI_SYNC_BYTE  2
 #define CY_SPI_SYNC_ACK1  0x62 /* from protocol v.2 */
 #define CY_SPI_SYNC_ACK2  0x9D /* from protocol v.2 */
 #define CY_SPI_DATA_SIZE  128
@@ -77,19 +77,19 @@ static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts,
 			    u8 reg, u8 *buf, int length)
 {
 	struct spi_message msg;
-	struct spi_transfer xfer = { 0 };
+	struct spi_transfer xfer[2];
 	u8 *wr_buf = ts->wr_buf;
 	u8 *rd_buf = ts->rd_buf;
 	int retval;
-	int i;
 
 	if (length > CY_SPI_DATA_SIZE) {
 		dev_dbg(ts->ops.dev, "%s: length %d is too big.\n",
 			__func__, length);
 		return -EINVAL;
 	}
-	dev_dbg(ts->ops.dev, "%s: OP=%s length=%d\n", __func__,
-		   op == CY_SPI_RD_OP ? "Read" : "Write", length);
+
+	memset(wr_buf, 0, CY_SPI_DATA_BUF_SIZE);
+	memset(rd_buf, 0, CY_SPI_DATA_BUF_SIZE);
 
 	wr_buf[0] = 0x00; /* header byte 0 */
 	wr_buf[1] = 0xFF; /* header byte 1 */
@@ -98,35 +98,45 @@ static int cyttsp_spi_xfer_(u8 op, struct cyttsp_spi *ts,
 	if (op == CY_SPI_WR_OP)
 		memcpy(wr_buf + CY_SPI_CMD_BYTES, buf, length);
 
-	xfer.tx_buf = wr_buf;
-	xfer.rx_buf = rd_buf;
-	xfer.len = length + CY_SPI_CMD_BYTES;
-
-	if ((op == CY_SPI_RD_OP) && (xfer.len < 32))
-		xfer.len += 1;
-
+	memset((void *)xfer, 0, sizeof(xfer));
 	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
+	xfer[0].tx_buf = wr_buf;
+	xfer[0].rx_buf = rd_buf;
+	if (op == CY_SPI_WR_OP) {
+		xfer[0].len = length + CY_SPI_CMD_BYTES;
+		spi_message_add_tail(&xfer[0], &msg);
+	} else if (op == CY_SPI_RD_OP) {
+		xfer[0].len = CY_SPI_CMD_BYTES;
+		spi_message_add_tail(&xfer[0], &msg);
+
+		xfer[1].rx_buf = buf;
+		xfer[1].len = length;
+		spi_message_add_tail(&xfer[1], &msg);
+	}
+
 	retval = spi_sync_tmo(ts, &msg);
 	if (retval < 0) {
-		dev_dbg(ts->ops.dev, "%s: spi_sync_tmo() error %d\n",
-			__func__, retval);
+		dev_dbg(ts->ops.dev, "%s: spi sync error %d, len=%d, op=%d\n",
+			__func__, retval, xfer[1].len, op);
 		retval = 0;
 	}
+
 	if (op == CY_SPI_RD_OP) {
-		for (i = 0; i < (length + CY_SPI_CMD_BYTES - 1); i++) {
-			if ((rd_buf[i] != CY_SPI_SYNC_ACK1) ||
-				(rd_buf[i + 1] != CY_SPI_SYNC_ACK2)) {
-				continue;
-			}
-			if (i <= (CY_SPI_CMD_BYTES - 1)) {
-				memcpy(buf, (rd_buf + i + CY_SPI_SYNC_BYTES),
-					length);
-				return 0;
-			}
+		if ((rd_buf[CY_SPI_SYNC_BYTE] == CY_SPI_SYNC_ACK1) &&
+			(rd_buf[CY_SPI_SYNC_BYTE+1] == CY_SPI_SYNC_ACK2))
+			retval = 0;
+		else {
+			int i;
+			for (i = 0; i < (CY_SPI_CMD_BYTES); i++)
+				dev_dbg(ts->ops.dev,
+					"%s: test rd_buf[%d]:0x%02x\n",
+					__func__, i, rd_buf[i]);
+			for (i = 0; i < (length); i++)
+				dev_dbg(ts->ops.dev,
+					"%s: test buf[%d]:0x%02x\n",
+					__func__, i, buf[i]);
+			retval = 1;
 		}
-		dev_dbg(ts->ops.dev, "%s: byte sync error\n", __func__);
-		retval = 1;
 	}
 	return retval;
 }
@@ -223,11 +233,11 @@ static int __devinit cyttsp_spi_probe(struct spi_device *spi)
 	}
 
 	ts = kzalloc(sizeof(*ts), GFP_KERNEL);
-	if (ts == NULL) {
+	if (!ts) {
 		dev_dbg(&spi->dev, "%s: Error, kzalloc\n", __func__);
-		retval = -ENOMEM;
-		goto error_alloc_data_failed;
+		return -ENOMEM;
 	}
+
 	ts->spi_client = spi;
 	dev_set_drvdata(&spi->dev, ts);
 	ts->ops.write = ttsp_spi_write_block_data;
@@ -235,18 +245,16 @@ static int __devinit cyttsp_spi_probe(struct spi_device *spi)
 	ts->ops.ext = ttsp_spi_tch_ext;
 	ts->ops.dev = &spi->dev;
 
-	retval = cyttsp_core_init(&ts->ops, &spi->dev,  &ts->ttsp_client);
-	if (retval)
-		goto ttsp_core_err;
+	ts->ttsp_client = cyttsp_core_init(&ts->ops, &spi->dev);
+	if (IS_ERR(ts->ttsp_client)) {
+		int retval = PTR_ERR(ts->ttsp_client);
+		kfree(ts);
+		return retval;
+	}
 
 	dev_dbg(ts->ops.dev, "%s: Registration complete\n", __func__);
 
 	return 0;
-
-ttsp_core_err:
-	kfree(ts);
-error_alloc_data_failed:
-	return retval;
 }
 
 static int __devexit cyttsp_spi_remove(struct spi_device *spi)
-- 
1.7.2.1


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

