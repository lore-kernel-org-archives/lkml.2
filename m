Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1LNIDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 03:03:12 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33131 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1LNIDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 03:03:07 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 03:03:07 EST
From: Daniel Kurtz <djkurtz@chromium.org>
To: khali@linux-fr.org, ben-linux@fluff.org, seth.heasley@intel.com,
        ben@decadent.org.uk, David.Woodhouse@intel.com
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, dlaurie@chromium.org, bleung@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/3] i2c: i801: enable irq for i801 smbus transactions
Date: Wed, 14 Dec 2011 15:56:31 +0800
Message-Id: <1323849392-20413-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1323849392-20413-1-git-send-email-djkurtz@chromium.org>
References: <1323849392-20413-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new 'feature' to i2c-i801 to enable using i801 interrupts.
When the feature is enabled, then an isr is installed for the device's
pci irq.  The SMBus controller generates an INTR irq at the end of each
transaction where INTREN was set in the HST_CNT register.

For this patch, the INTREN bit is set only for smbus block, byte and word
transactions, but not for emulated i2c reads or writes.

The use of the DS (BYTE_DONE) interrupt with byte-by-byte i2c
transactions is implemented in a subsequent patch.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/i2c/busses/i2c-i801.c |  107 ++++++++++++++++++++++++++++++++++++++--
 1 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index f3418cf..3abc624 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -59,10 +59,12 @@
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
@@ -90,6 +92,7 @@
 
 /* PCI Address Constants */
 #define SMBBAR		4
+#define SMBPCISTS	0x006
 #define SMBHSTCFG	0x040
 
 /* Host configuration bits for SMBHSTCFG */
@@ -97,6 +100,9 @@
 #define SMBHSTCFG_SMB_SMI_EN	2
 #define SMBHSTCFG_I2C_EN	4
 
+/* Host status bits for SMBHSTSTS */
+#define SMBPCISTS_INTS		8
+
 /* Auxiliary control register bits, ICH4+ only */
 #define SMBAUXCTL_CRC		1
 #define SMBAUXCTL_E32B		2
@@ -106,7 +112,7 @@
 
 /* Other settings */
 #define MAX_TIMEOUT		100
-#define ENABLE_INT9		0	/* set to 0x01 to enable - untested */
+#define IRQ_TIMEOUT		(HZ/2)
 
 /* I801 command constants */
 #define I801_QUICK		0x00
@@ -116,7 +122,11 @@
 #define I801_PROC_CALL		0x10	/* unimplemented */
 #define I801_BLOCK_DATA		0x14
 #define I801_I2C_BLOCK_DATA	0x18	/* ICH5 and later */
-#define I801_LAST_BYTE		0x20
+
+/* I801 Hosts Control register bits */
+#define I801_INTREN		0x01
+#define I801_KILL		0x02
+#define I801_LAST_BYTE		0x20	/* ICH5 and later */
 #define I801_START		0x40
 #define I801_PEC_EN		0x80	/* ICH3 and later */
 
@@ -151,6 +161,11 @@ struct i801_priv {
 	unsigned char original_hstcfg;
 	struct pci_dev *pci_dev;
 	unsigned int features;
+
+	/* isr processing */
+	wait_queue_head_t waitq;
+	spinlock_t lock;
+	u8 status;
 };
 
 static struct pci_driver i801_driver;
@@ -159,6 +174,7 @@ static struct pci_driver i801_driver;
 #define FEATURE_BLOCK_BUFFER	(1 << 1)
 #define FEATURE_BLOCK_PROC	(1 << 2)
 #define FEATURE_I2C_BLOCK_READ	(1 << 3)
+#define FEATURE_IRQ		(1 << 4)
 /* Not really a feature, but it's convenient to handle it as such */
 #define FEATURE_IDF		(1 << 15)
 
@@ -167,6 +183,7 @@ static const char *i801_feature_names[] = {
 	"Block buffer",
 	"Block process call",
 	"I2C block read",
+	"Interrupt"
 };
 
 static unsigned int disable_features;
@@ -255,6 +272,20 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
 	return result;
 }
 
+/* interrupt handling: fetch & consume host status out of algo_data */
+static inline u8 i801_get_status(struct i801_priv *priv)
+{
+	unsigned long flags;
+	u8 status;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	status = priv->status;
+	priv->status = 0;
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return status;
+}
+
 static int i801_transaction(struct i801_priv *priv, int xact)
 {
 	int status;
@@ -265,8 +296,16 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 	if (result < 0)
 		return result;
 
+	if (priv->features & FEATURE_IRQ) {
+		outb(xact | I801_INTREN | I801_START, SMBHSTCNT(priv));
+		timeout = wait_event_timeout(priv->waitq,
+					     (status = i801_get_status(priv)),
+					     IRQ_TIMEOUT);
+		return i801_check_post(priv, status, timeout == 0);
+	}
+
 	/* the current contents of SMBHSTCNT can be overwritten, since PEC,
-	 * INTREN, SMBSCMD are passed in xact */
+	 * SMBSCMD are passed in xact */
 	outb_p(xact | I801_START, SMBHSTCNT(priv));
 
 	/* We will always wait for a fraction of a second! */
@@ -280,6 +319,7 @@ static int i801_transaction(struct i801_priv *priv, int xact)
 		return result;
 
 	outb_p(SMBHSTSTS_INTR, SMBHSTSTS(priv));
+
 	return 0;
 }
 
@@ -318,7 +358,7 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 			outb_p(data->block[i+1], SMBBLKDAT(priv));
 	}
 
-	status = i801_transaction(priv, I801_BLOCK_DATA | ENABLE_INT9 |
+	status = i801_transaction(priv, I801_BLOCK_DATA |
 				  (hwpec ? I801_PEC_EN : 0));
 	if (status)
 		return status;
@@ -335,6 +375,38 @@ static int i801_block_transaction_by_block(struct i801_priv *priv,
 	return 0;
 }
 
+static irqreturn_t i801_isr(int irq, void *dev_id)
+{
+	struct i801_priv *priv = dev_id;
+	u8 pcists, hststs;
+	unsigned long flags;
+
+	/* Confirm this is our interrupt */
+	pci_read_config_byte(priv->pci_dev, SMBPCISTS, &pcists);
+	if (!(pcists & SMBPCISTS_INTS)) {
+		dev_dbg(&priv->pci_dev->dev, "irq: pcists.ints not set\n");
+		return IRQ_NONE;
+	}
+
+	hststs = inb(SMBHSTSTS(priv));
+	dev_dbg(&priv->pci_dev->dev, "irq: hststs = %02x\n", hststs);
+
+	/* Only process irq sources */
+	hststs &= STATUS_FLAGS;
+
+	/* Clear and report irq sources */
+	if (hststs) {
+		outb(hststs, SMBHSTSTS(priv));
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->status |= hststs;
+		spin_unlock_irqrestore(&priv->lock, flags);
+		wake_up(&priv->waitq);
+	}
+
+	return IRQ_HANDLED;
+}
+
 /*
  * i2c write uses cmd=I801_BLOCK_DATA, I2C_EN=1
  * i2c read uses cmd=I801_I2C_BLOCK_DATA
@@ -370,7 +442,7 @@ static int i801_block_transaction_byte_by_byte(struct i801_priv *priv,
 	for (i = 1; i <= len; i++) {
 		if (i == len && read_write == I2C_SMBUS_READ)
 			smbcmd |= I801_LAST_BYTE;
-		outb_p(smbcmd | ENABLE_INT9, SMBHSTCNT(priv));
+		outb_p(smbcmd, SMBHSTCNT(priv));
 
 		if (i == 1)
 			outb_p(inb(SMBHSTCNT(priv)) | I801_START,
@@ -571,7 +643,7 @@ static s32 i801_access(struct i2c_adapter *adap, u16 addr,
 		ret = i801_block_transaction(priv, data, read_write, size,
 					     hwpec);
 	else
-		ret = i801_transaction(priv, xact | ENABLE_INT9);
+		ret = i801_transaction(priv, xact);
 
 	/* Some BIOSes don't like it when PEC is enabled at reboot or resume
 	   time, so we forcibly disable it after every transaction. Turn off
@@ -805,6 +877,10 @@ static int __devinit i801_probe(struct pci_dev *dev,
 		break;
 	}
 
+	/* IRQ processing only tested on CougarPoint PCH */
+	if (dev->device == PCI_DEVICE_ID_INTEL_COUGARPOINT_SMBUS)
+		priv->features |= FEATURE_IRQ;
+
 	/* Disable features on user request */
 	for (i = 0; i < ARRAY_SIZE(i801_feature_names); i++) {
 		if (priv->features & disable_features & (1 << i))
@@ -879,8 +955,24 @@ static int __devinit i801_probe(struct pci_dev *dev,
 	i801_probe_optional_slaves(priv);
 
 	pci_set_drvdata(dev, priv);
+
+	if (priv->features & FEATURE_IRQ) {
+		init_waitqueue_head(&priv->waitq);
+		spin_lock_init(&priv->lock);
+
+		err = request_irq(dev->irq, i801_isr, IRQF_SHARED,
+				  i801_driver.name, priv);
+		if (err) {
+			dev_err(&dev->dev, "Failed to allocate irq %d: %d",
+				dev->irq, err);
+			goto exit_del_adapter;
+		}
+	}
 	return 0;
 
+exit_del_adapter:
+	pci_set_drvdata(dev, NULL);
+	i2c_del_adapter(&priv->adapter);
 exit_release:
 	pci_release_region(dev, SMBBAR);
 exit:
@@ -892,6 +984,9 @@ static void __devexit i801_remove(struct pci_dev *dev)
 {
 	struct i801_priv *priv = pci_get_drvdata(dev);
 
+	if (priv->features & FEATURE_IRQ)
+		free_irq(dev->irq, priv);
+
 	i2c_del_adapter(&priv->adapter);
 	pci_write_config_byte(dev, SMBHSTCFG, priv->original_hstcfg);
 	pci_release_region(dev, SMBBAR);
-- 
1.7.3.1

