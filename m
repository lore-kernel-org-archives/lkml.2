Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2FKA7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:38 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40538 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab2FKA6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:30 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 07/14] sta2x11-mfd : implement apbreg_mask and sctl_mask as static inlines
Date: Mon, 11 Jun 2012 02:57:52 +0200
Message-Id: <1339376279-16753-8-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

The apbreg_mask and sctl_mask functions were almost identical,
so they were turned into one-liners invoking a common
__sta2x11_mfd_mask() with the platform device's index as last
parameter.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |   35 +++++------------------------------
 include/linux/mfd/sta2x11-mfd.h |   15 +++++++++++++--
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 1aa9c78..16d340c 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -99,13 +99,14 @@ static int __devexit mfd_remove(struct pci_dev *pdev)
 	return 0;
 }
 
-/* These two functions are exported and are not expected to fail */
-u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+/* This function is exported and is not expected to fail */
+u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
+		       enum sta2x11_mfd_plat_dev index)
 {
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	u32 r;
 	unsigned long flags;
-	void __iomem *regs = mfd->regs[sta2x11_sctl];
+	void __iomem *regs = mfd->regs[index];
 
 	if (!mfd) {
 		dev_warn(&pdev->dev, ": can't access sctl regs\n");
@@ -124,33 +125,7 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 	spin_unlock_irqrestore(&mfd->lock, flags);
 	return r;
 }
-EXPORT_SYMBOL(sta2x11_sctl_mask);
-
-u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
-{
-	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
-	u32 r;
-	unsigned long flags;
-	void __iomem *regs = mfd->regs[sta2x11_apbreg];
-
-	if (!mfd) {
-		dev_warn(&pdev->dev, ": can't access apb regs\n");
-		return 0;
-	}
-	if (!regs) {
-		dev_warn(&pdev->dev, ": apb bridge not initialized\n");
-		return 0;
-	}
-	spin_lock_irqsave(&mfd->lock, flags);
-	r = readl(regs + reg);
-	r &= ~mask;
-	r |= val;
-	if (mask)
-		writel(r, regs + reg);
-	spin_unlock_irqrestore(&mfd->lock, flags);
-	return r;
-}
-EXPORT_SYMBOL(sta2x11_apbreg_mask);
+EXPORT_SYMBOL(__sta2x11_mfd_mask);
 
 /* Two debugfs files, for our registers (FIXME: one instance only) */
 #define REG(regname) {.name = #regname, .offset = SCTL_ ## regname}
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 4b2667a..09a94d3 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -37,6 +37,9 @@ enum sta2x11_mfd_plat_dev {
 	sta2x11_n_mfd_plat_devs,
 };
 
+extern u32
+__sta2x11_mfd_mask(struct pci_dev *, u32, u32, u32, enum sta2x11_mfd_plat_dev);
+
 /*
  * The MFD PCI block includes the GPIO peripherals and other register blocks.
  * For GPIO, we have 32*4 bits (I use "gsta" for "gpio sta2x11".)
@@ -193,7 +196,11 @@ struct sta2x11_gpio_pdata {
  * The APB bridge has its own registers, needed by our users as well.
  * They are accessed with the following read/mask/write function.
  */
-u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
+static inline u32
+sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	return __sta2x11_mfd_mask(pdev, reg, mask, val, sta2x11_apbreg);
+}
 
 /* CAN and MLB */
 #define APBREG_BSR	0x00	/* Bridge Status Reg */
@@ -222,7 +229,11 @@ u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
  * The system controller has its own registers. Some of these are accessed
  * by out users as well, using the following read/mask/write/function
  */
-u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
+static inline
+u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	return __sta2x11_mfd_mask(pdev, reg, mask, val, sta2x11_sctl);
+}
 
 #define SCTL_SCCTL		0x00	/* System controller control register */
 #define SCTL_ARMCFG		0x04	/* ARM configuration register */
-- 
1.7.9.1

