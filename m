Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2AFK6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:58:55 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:64527 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758656Ab2AFK61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:58:27 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: khali@linux-fr.org, ben-linux@fluff.org, seth.heasley@intel.com,
        ben@decadent.org.uk, David.Woodhouse@intel.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, bleung@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/3 v2] i2c: i801: enable irq for byte_by_byte transactions
Date: Fri,  6 Jan 2012 18:58:22 +0800
Message-Id: <1325847502-17841-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Byte-by-byte transactions are used primarily for accessing i2c devices
with an smbus controller.  For these transactions, for each byte that is
read or written, the SMBus controller generates a BYTE_DONE irq.  The isr
reads/writes the next byte, and clears the irq flag to start the next byte.
On the penultimate irq, the isr also sets the LAST_BYTE flag.

There is no locking around the cmd/len/count/data variables, since the
i2c adapter lock ensures there is never multiple simultaneous transactions
for the same device, and the driver thread never accesses these variables
while interrupts might be occurring.

The end result is a dramatic speed up in emulated i2c-over smbus block
read and write transactions.

Note: This patch has only been tested and verified by doing i2c read and
write block transfers on Cougar Point 6 Series PCH.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   51 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index b123133..f957eca 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -168,6 +168,13 @@ struct i801_priv {
 	wait_queue_head_t waitq;
 	spinlock_t lock;
 	u8 status;
+
+	/* Command state used during by isr */
+	u8 cmd;
+	bool is_read;
+	int count;
+	int len;
+	u8 *data;
 };
 
 static struct pci_driver i801_driver;
@@ -368,18 +375,24 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 }
 
 /*
- * i801 signals transaction completion with one of these interrupts:
+ * There are two kinds of interrupts:
+ *
+ * (1) i801 signals transaction completion with one of these interrupts:
  *   INTR - Success
  *   DEV_ERR - Invalid command, NAK or communication timeout
  *   BUS_ERR - SMI# transaction collision
  *   FAILED - transaction was canceled due to a KILL request
  * When any of these occur, update ->status and wake up the waitq.
  * ->status must be cleared before kicking off the next transaction.
+ *
+* (2) For byte-by-byte (I2C read/write) transactions, one BYTE_DONE interrupt
+*     occurs for each byte of a byte-by-byte to prepare the next byte.
  */
 static irqreturn_t i801_isr(int irq, void *dev_id)
 {
 	struct i801_priv *priv = dev_id;
 	u8 pcists, hststs;
+	u8 cmd;
 
 	/* Confirm this is our interrupt */
 	pci_read_config_byte(priv->pci_dev, SMBPCISTS, &pcists);
@@ -391,6 +404,27 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
 	hststs = inb(SMBHSTSTS(priv));
 	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
 
+	if (hststs & SMBHSTSTS_BYTE_DONE) {
+		if (priv->is_read) {
+			priv->data[priv->count++] = inb(SMBBLKDAT(priv));
+
+			/* Set LAST_BYTE for last byte of read transaction */
+			cmd = priv->cmd;
+			if (priv->count == priv->len - 1)
+				cmd |= I801_LAST_BYTE;
+			outb_p(cmd | I801_START, SMBHSTCNT(priv));
+		} else if (priv->count < priv->len - 1) {
+			outb(priv->data[++priv->count], SMBBLKDAT(priv));
+			outb_p(priv->cmd | I801_START, SMBHSTCNT(priv));
+		}
+
+		/* Clear BYTE_DONE to start next transaction. */
+		outb(SMBHSTSTS_BYTE_DONE, SMBHSTSTS(priv));
+
+		/* Clear BYTE_DONE so it does not wake_up waitq */
+		hststs &= ~SMBHSTSTS_BYTE_DONE;
+	}
+
 	/*
 	 * Clear irq sources and report transaction result.
 	 * ->status must be cleared before the next transaction is started.
@@ -437,6 +471,21 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 	else
 		smbcmd = I801_BLOCK_DATA;
 
+	if (priv->features & FEATURE_IRQ) {
+		priv->is_read = (read_write == I2C_SMBUS_READ);
+		if (len == 1 && priv->is_read)
+			smbcmd |= I801_LAST_BYTE;
+		priv->cmd = smbcmd | I801_INTREN;
+		priv->len = len;
+		priv->count = 0;
+		priv->data = &data->block[1];
+
+		outb(priv->cmd | I801_START, SMBHSTCNT(priv));
+		wait_event(priv->waitq, (status = priv->status));
+		priv->status = 0;
+		return i801_check_post(priv, status, 0);
+	}
+
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
 			smbcmd |= I801_LAST_BYTE;
-- 
1.7.3.1

