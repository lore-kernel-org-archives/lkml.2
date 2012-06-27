Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2F0NzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:55:09 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63767 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2F0NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:22 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 8/8 v3] i2c: i801: enable irq for byte_by_byte transactions
Date: Wed, 27 Jun 2012 21:54:15 +0800
Message-Id: <1340805255-8041-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byte-by-byte transactions are used primarily for accessing I2C devices
with an SMBus controller.  For these transactions, for each byte that is
read or written, the SMBus controller generates a BYTE_DONE irq.  The isr
reads/writes the next byte, and clears the irq flag to start the next byte.
On the penultimate irq, the isr also sets the LAST_BYTE flag.

There is no locking around the cmd/len/count/data variables, since the
I2C adapter lock ensures there is never multiple simultaneous transactions
for the same device, and the driver thread never accesses these variables
while interrupts might be occurring.

The end result is faster I2C block read and write transactions.

Note: This patch has only been tested and verified by doing I2C read and
write block transfers on Cougar Point 6 Series PCH.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   78 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 71 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 6bfedc0..bbd3508 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -163,6 +163,13 @@ struct i801_priv {
 	/* isr processing */
 	wait_queue_head_t waitq;
 	u8 status;
+
+	/* Command state used by isr for byte-by-byte block transactions */
+	u8 cmd;
+	bool is_read;
+	int count;
+	int len;
+	u8 *data;
 };
 
 static struct pci_driver i801_driver;
@@ -363,14 +370,53 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 	return 0;
 }
 
+static void i801_isr_byte_done(struct i801_priv *priv)
+{
+	/* For SMBus block reads, length is first byte read */
+	if (priv->is_read && ((priv->cmd & 0x1c) == I801_BLOCK_DATA) &&
+	    (priv->count == 0)) {
+		priv->len = inb_p(SMBHSTDAT0(priv));
+		if (priv->len < 1 || priv->len > I2C_SMBUS_BLOCK_MAX) {
+			dev_err(&priv->pci_dev->dev,
+				"Illegal SMBus block read size %d\n",
+				priv->len);
+			/* FIXME: Recover */
+			priv->len = I2C_SMBUS_BLOCK_MAX;
+		} else {
+			dev_dbg(&priv->pci_dev->dev,
+				"SMBus block read size is %d\n",
+				priv->len);
+		}
+		priv->data[-1] = priv->len;
+	} else if (priv->is_read) {
+		priv->data[priv->count++] = inb(SMBBLKDAT(priv));
+		/* Set LAST_BYTE for last byte of read transaction */
+		if (priv->count == priv->len - 1)
+			priv->cmd |= SMBHSTCNT_LAST_BYTE;
+		outb_p(priv->cmd, SMBHSTCNT(priv));
+	} else if (priv->count < priv->len - 1) {
+		/* Write next byte, except for IRQ after last byte */
+		outb_p(priv->data[++priv->count], SMBBLKDAT(priv));
+		outb_p(priv->cmd, SMBHSTCNT(priv));
+	}
+
+	/* Clear BYTE_DONE to start next transaction. */
+	outb_p(SMBHSTSTS_BYTE_DONE, SMBHSTSTS(priv));
+}
+
 /*
- * i801 signals transaction completion with one of these interrupts:
- *   INTR - Success
- *   DEV_ERR - Invalid command, NAK or communication timeout
- *   BUS_ERR - SMI# transaction collision
- *   FAILED - transaction was canceled due to a KILL request
- * When any of these occur, update ->status and wake up the waitq.
- * ->status must be cleared before kicking off the next transaction.
+ * There are two kinds of interrupts:
+ *
+ * 1) i801 signals transaction completion with one of these interrupts:
+ *      INTR - Success
+ *      DEV_ERR - Invalid command, NAK or communication timeout
+ *      BUS_ERR - SMI# transaction collision
+ *      FAILED - transaction was canceled due to a KILL request
+ *    When any of these occur, update ->status and wake up the waitq.
+ *    ->status must be cleared before kicking off the next transaction.
+ *
+ * 2) For byte-by-byte (I2C read/write) transactions, one BYTE_DONE interrupt
+ *    occurs for each byte of a byte-by-byte to prepare the next byte.
  */
 static irqreturn_t i801_isr(int irq, void *dev_id)
 {
@@ -380,6 +426,9 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
 	hststs = inb_p(SMBHSTSTS(priv));
 	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
 
+	if (hststs & SMBHSTSTS_BYTE_DONE)
+		i801_isr_byte_done(priv);
+
 	/*
 	 * Clear irq sources and report transaction result.
 	 * ->status must be cleared before the next transaction is started.
@@ -427,6 +476,21 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 	else
 		smbcmd = I801_BLOCK_DATA;
 
+	if (priv->features & FEATURE_IRQ) {
+		priv->is_read = (read_write == I2C_SMBUS_READ);
+		if (len == 1 && priv->is_read)
+			smbcmd |= SMBHSTCNT_LAST_BYTE;
+		priv->cmd = smbcmd | SMBHSTCNT_INTREN;
+		priv->len = len;
+		priv->count = 0;
+		priv->data = &data->block[1];
+
+		outb_p(priv->cmd | SMBHSTCNT_START, SMBHSTCNT(priv));
+		wait_event(priv->waitq, (status = priv->status));
+		priv->status = 0;
+		return i801_check_post(priv, status, 0);
+	}
+
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
 			smbcmd |= SMBHSTCNT_LAST_BYTE;
-- 
1.7.7.3

