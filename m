Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2F0Nyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 09:54:41 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:53017 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2F0NyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 09:54:23 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 7/8 v3] i2c: i801: enable irq for i801 smbus transactions
Date: Wed, 27 Jun 2012 21:54:14 +0800
Message-Id: <1340805255-8041-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new 'feature' to i2c-i801 to enable using i801 interrupts.
When the feature is enabled, then an isr is installed for the device's
pci irq.

An I2C/SMBus transaction is always terminated by one of the following
interrupt sources: FAILED, BUS_ERR, DEV_ERR, or on success: INTR.

When the isr fires for one of these cases, it sets the ->status variable
and wakes up the waitq.  The waitq then saves off the status code, and
clears ->status (in preparation for some future transaction).
The SMBus controller generates an INTR irq at the end of each
transaction where INTREN was set in the HST_CNT register.

No locking is needed around accesses to priv->status since all writes to
it are serialized: it is only ever set once in the isr at the end of a
transaction, and cleared while no irqs can occur.  In addition, the I2C
adapter lock guarantees that entire I2C transactions for a single
adapter are always serialized.

For this patch, the INTREN bit is set only for SMBus block, byte and word
transactions, but not for I2C reads or writes.  The use of the DS
(BYTE_DONE) interrupt with byte-by-byte I2C transactions is implemented in
a subsequent patch.

The interrupt feature has only been enabled for COUGARPOINT hardware.
In addition, it is disabled if SMBus is using the SMI# interrupt.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |   93 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 6fa2a0b..6bfedc0 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -60,10 +60,12 @@
   Block process call transaction   no
   I2C block read transaction       yes  (doesn't use the block buffer)
   Slave mode                       no
+  Interrupt processing             yes
 
   See the file Documentation/i2c/busses/i2c-i801 for details.
 */
 
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
@@ -76,6 +78,7 @@
 #include <linux/io.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <linux/wait.h>
 
 /* I801 SMBus address offsets */
 #define SMBHSTSTS(p)	(0 + (p)->smba)
@@ -134,8 +137,9 @@
 #define STATUS_ERROR_FLAGS	(SMBHSTSTS_FAILED | SMBHSTSTS_BUS_ERR | \
 				 SMBHSTSTS_DEV_ERR)
 
-#define STATUS_FLAGS		(SMBHSTSTS_BYTE_DONE | SMBHSTSTS_INTR | \
-				 STATUS_ERROR_FLAGS)
+#define STATUS_RESULT_FLAGS	(SMBHSTSTS_INTR | STATUS_ERROR_FLAGS)
+
+#define STATUS_FLAGS		(SMBHSTSTS_BYTE_DONE | STATUS_RESULT_FLAGS)
 
 /* Older devices have their ID defined in <linux/pci_ids.h> */
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS	0x1c22
@@ -155,6 +159,10 @@ struct i801_priv {
 	unsigned char original_hstcfg;
 	struct pci_dev *pci_dev;
 	unsigned int features;
+
+	/* isr processing */
+	wait_queue_head_t waitq;
+	u8 status;
 };
 
 static struct pci_driver i801_driver;
@@ -163,6 +171,7 @@ static struct pci_driver i801_driver;
 #define FEATURE_BLOCK_BUFFER	(1 << 1)
 #define FEATURE_BLOCK_PROC	(1 << 2)
 #define FEATURE_I2C_BLOCK_READ	(1 << 3)
+#define FEATURE_IRQ		(1 << 4)
 /* Not really a feature, but it's convenient to handle it as such */
 #define FEATURE_IDF		(1 << 15)
 
@@ -171,6 +180,7 @@ static const char *i801_feature_names[] = {
 	"Block buffer",
 	"Block process call",
 	"I2C block read",
+	"Interrupt",
 };
 
 static unsigned int disable_features;
@@ -211,7 +221,12 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
 {
 	int result = 0;
 
-	/* If the SMBus is still busy, we give up */
+	/*
+	 * If the SMBus is still busy, we give up
+	 * Note: This timeout condition only happens when using polling
+	 * transactions.  For interrupt operation, NAK/timeout is indicated by
+	 * DEV_ERR.
+	 */
 	if (timeout) {
 		dev_err(&priv->pci_dev->dev, "Transaction timeout\n");
 		/* try to stop the current command */
@@ -287,6 +302,14 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 	if (result < 0)
 		return result;
 
+	if (priv->features & FEATURE_IRQ) {
+		outb_p(xact | SMBHSTCNT_INTREN | SMBHSTCNT_START,
+		       SMBHSTCNT(priv));
+		wait_event(priv->waitq, (status = priv->status));
+		priv->status = 0;
+		return i801_check_post(priv, status, 0);
+	}
+
 	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
 	 * SMBSCMD are passed in xact */
 	outb_p(xact | SMBHSTCNT_START, SMBHSTCNT(priv));
@@ -341,6 +364,37 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 }
 
 /*
+ * i801 signals transaction completion with one of these interrupts:
+ *   INTR - Success
+ *   DEV_ERR - Invalid command, NAK or communication timeout
+ *   BUS_ERR - SMI# transaction collision
+ *   FAILED - transaction was canceled due to a KILL request
+ * When any of these occur, update ->status and wake up the waitq.
+ * ->status must be cleared before kicking off the next transaction.
+ */
+static irqreturn_t i801_isr(int irq, void *dev_id)
+{
+	struct i801_priv *priv = dev_id;
+	u8 hststs;
+
+	hststs = inb_p(SMBHSTSTS(priv));
+	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
+
+	/*
+	 * Clear irq sources and report transaction result.
+	 * ->status must be cleared before the next transaction is started.
+	 */
+	hststs &= STATUS_RESULT_FLAGS;
+	if (hststs) {
+		outb_p(hststs, SMBHSTSTS(priv));
+		priv->status |= hststs;
+		wake_up(&priv->waitq);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
  * For "byte-by-byte" block transactions:
  *   I2C write uses cmd=I801_BLOCK_DATA, I2C_EN=1
  *   I2C read uses cmd=I801_I2C_BLOCK_DATA
@@ -801,6 +855,10 @@ static int __devinit i801_probe(struct pci_dev *dev,
 		break;
 	}
 
+	/* IRQ processing only tested on CougarPoint PCH */
+	if (dev->device == PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS)
+		priv->features |= FEATURE_IRQ;
+
 	/* Disable features on user request */
 	for (i = 0; i < ARRAY_SIZE(i801_feature_names); i++) {
 		if (priv->features & disable_features & (1 << i))
@@ -848,16 +906,31 @@ static int __devinit i801_probe(struct pci_dev *dev,
 	}
 	pci_write_config_byte(priv->pci_dev, SMBHSTCFG, temp);
 
-	if (temp & SMBHSTCFG_SMB_SMI_EN)
+	if (temp & SMBHSTCFG_SMB_SMI_EN) {
 		dev_dbg(&dev->dev, "SMBus using interrupt SMI#\n");
-	else
+		/* Disable SMBus interrupt feature if SMBus using SMI# */
+		priv->features &= ~FEATURE_IRQ;
+	} else {
 		dev_dbg(&dev->dev, "SMBus using PCI Interrupt\n");
+	}
 
 	/* Clear special mode bits */
 	if (priv->features & (FEATURE_SMBUS_PEC | FEATURE_BLOCK_BUFFER))
 		outb_p(inb_p(SMBAUXCTL(priv)) &
 		       ~(SMBAUXCTL_CRC | SMBAUXCTL_E32B), SMBAUXCTL(priv));
 
+	if (priv->features & FEATURE_IRQ) {
+		init_waitqueue_head(&priv->waitq);
+
+		err = request_irq(dev->irq, i801_isr, IRQF_SHARED,
+				  i801_driver.name, priv);
+		if (err) {
+			dev_err(&dev->dev, "Failed to allocate irq %d: %d\n",
+				dev->irq, err);
+			goto exit_release;
+		}
+	}
+
 	/* set up the sysfs linkage to our parent device */
 	priv->adapter.dev.parent = &dev->dev;
 
@@ -869,14 +942,18 @@ static int __devinit i801_probe(struct pci_dev *dev,
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
 		dev_err(&dev->dev, "Failed to add SMBus adapter\n");
-		goto exit_release;
+		goto exit_free_irq;
 	}
 
 	i801_probe_optional_slaves(priv);
 
 	pci_set_drvdata(dev, priv);
+
 	return 0;
 
+exit_free_irq:
+	if (priv->features & FEATURE_IRQ)
+		free_irq(dev->irq, priv);
 exit_release:
 	pci_release_region(dev, SMBBAR);
 exit:
@@ -891,6 +968,10 @@ static void __devexit i801_remove(struct pci_dev *dev)
 	i2c_del_adapter(&priv->adapter);
 	pci_write_config_byte(dev, SMBHSTCFG, priv->original_hstcfg);
 	pci_release_region(dev, SMBBAR);
+
+	if (priv->features & FEATURE_IRQ)
+		free_irq(dev->irq, priv);
+
 	pci_set_drvdata(dev, NULL);
 	kfree(priv);
 	/*
-- 
1.7.7.3

