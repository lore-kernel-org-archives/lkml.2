Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1LNIBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:01:52 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:57841 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1LNIBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:01:51 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: khali@linux-fr.org, ben-linux@fluff.org, seth.heasley@intel.com,
        ben@decadent.org.uk, David.Woodhouse@intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, dlaurie@chromium.org, bleung@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 3/3] i2c: i801: enable irq for byte_by_byte transactions
Date: Wed, 14 Dec 2011 15:56:32 +0800
Message-Id: <1323849392-20413-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1323849392-20413-1-git-send-email-djkurtz@chromium.org>
References: <1323849392-20413-1-git-send-email-djkurtz@chromium.org>
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
 drivers/i2c/busses/i2c-i801.c |   49 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 3abc624..1b6673b 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -166,6 +166,13 @@ struct i801_priv {
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
@@ -379,6 +386,7 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
 {
 	struct i801_priv *priv = dev_id;
 	u8 pcists, hststs;
+	u8 cmd;
 	unsigned long flags;
 
 	/* Confirm this is our interrupt */
@@ -394,16 +402,35 @@ static irqreturn_t i801_isr(int irq, void *dev_id)
 	/* Only process irq sources */
 	hststs &= STATUS_FLAGS;
 
-	/* Clear and report irq sources */
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
+	/* Clear and report other irq sources */
 	if (hststs) {
 		outb(hststs, SMBHSTSTS(priv));
-
 		spin_lock_irqsave(&priv->lock, flags);
 		priv->status |= hststs;
 		spin_unlock_irqrestore(&priv->lock, flags);
 		wake_up(&priv->waitq);
 	}
-
 	return IRQ_HANDLED;
 }
 
@@ -439,6 +466,22 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
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
+		timeout = wait_event_timeout(priv->waitq,
+					     (status = i801_get_status(priv)),
+					     IRQ_TIMEOUT);
+		return i801_check_post(priv, status, timeout == 0);
+	}
+
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
 			smbcmd |= I801_LAST_BYTE;
-- 
1.7.3.1

