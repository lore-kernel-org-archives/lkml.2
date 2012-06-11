Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2FKA7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:43 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40526 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab2FKA63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:29 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 02/14] sta2x11-mfd : add apb-soc regs driver and factor out common code
Date: Mon, 11 Jun 2012 02:57:47 +0200
Message-Id: <1339376279-16753-3-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

Some of the functions in sta2x11-mfd.c were almost identical
for the two existing platform devices. To avoid more code
duplication while adding the apb-soc-regs driver, some changes
have been done:

* The sctl_regs and apbreg_regs fields in struct sta2x11_mfd
have been turned into just one array of pointers accessed by
device index.
* Platform probe methods have become one-liners invoking a
common probe with the device's index as second parameter.
* For loops have been inserted where the same operations
were performed for each of the two bars of a pci device.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c |  152 ++++++++++++++++++++++++---------------------
 1 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 5c950e8..69c7bdc 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -35,13 +35,19 @@
 
 #include <asm/sta2x11.h>
 
+enum sta2x11_mfd_plat_dev {
+	sta2x11_sctl = 0,
+	sta2x11_apbreg = 1,
+	sta2x11_apb_soc_regs = 2,
+	sta2x11_n_mfd_plat_devs,
+};
+
 /* This describes STA2X11 MFD chip for us, we may have several */
 struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
 	spinlock_t lock;
 	struct list_head list;
-	void __iomem *sctl_regs;
-	void __iomem *apbreg_regs;
+	void __iomem *regs[sta2x11_n_mfd_plat_devs];
 };
 
 static LIST_HEAD(sta2x11_mfd_list);
@@ -106,21 +112,22 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	u32 r;
 	unsigned long flags;
+	void __iomem *regs = mfd->regs[sta2x11_sctl];
 
 	if (!mfd) {
 		dev_warn(&pdev->dev, ": can't access sctl regs\n");
 		return 0;
 	}
-	if (!mfd->sctl_regs) {
+	if (!regs) {
 		dev_warn(&pdev->dev, ": system ctl not initialized\n");
 		return 0;
 	}
 	spin_lock_irqsave(&mfd->lock, flags);
-	r = readl(mfd->sctl_regs + reg);
+	r = readl(regs + reg);
 	r &= ~mask;
 	r |= val;
 	if (mask)
-		writel(r, mfd->sctl_regs + reg);
+		writel(r, regs + reg);
 	spin_unlock_irqrestore(&mfd->lock, flags);
 	return r;
 }
@@ -131,21 +138,22 @@ u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	u32 r;
 	unsigned long flags;
+	void __iomem *regs = mfd->regs[sta2x11_apbreg];
 
 	if (!mfd) {
 		dev_warn(&pdev->dev, ": can't access apb regs\n");
 		return 0;
 	}
-	if (!mfd->apbreg_regs) {
+	if (!regs) {
 		dev_warn(&pdev->dev, ": apb bridge not initialized\n");
 		return 0;
 	}
 	spin_lock_irqsave(&mfd->lock, flags);
-	r = readl(mfd->apbreg_regs + reg);
+	r = readl(regs + reg);
 	r &= ~mask;
 	r |= val;
 	if (mask)
-		writel(r, mfd->apbreg_regs + reg);
+		writel(r, regs + reg);
 	spin_unlock_irqrestore(&mfd->lock, flags);
 	return r;
 }
@@ -180,15 +188,29 @@ static struct debugfs_regset32 apbreg_regset = {
 	.nregs = ARRAY_SIZE(sta2x11_apbreg_regs),
 };
 
-static struct dentry *sta2x11_sctl_debugfs;
-static struct dentry *sta2x11_apbreg_debugfs;
+static struct dentry *sta2x11_mfd_debugfs[sta2x11_n_mfd_plat_devs];
 
-/* Probe for the two platform devices */
-static int sta2x11_sctl_probe(struct platform_device *dev)
+static struct debugfs_regset32 *sta2x11_mfd_regset[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = &sctl_regset,
+	[sta2x11_apbreg] = &apbreg_regset,
+};
+
+static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = "sta2x11-sctl",
+	[sta2x11_apbreg] = "sta2x11-apbreg",
+	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
+};
+
+/* Probe for the three platform devices */
+
+static int sta2x11_mfd_platform_probe(struct platform_device *dev,
+				      enum sta2x11_mfd_plat_dev index)
 {
 	struct pci_dev **pdev;
 	struct sta2x11_mfd *mfd;
 	struct resource *res;
+	const char *name = sta2x11_mfd_names[index];
+	struct debugfs_regset32 *regset = sta2x11_mfd_regset[index];
 
 	pdev = dev->dev.platform_data;
 	mfd = sta2x11_mfd_find(*pdev);
@@ -199,59 +221,37 @@ static int sta2x11_sctl_probe(struct platform_device *dev)
 	if (!res)
 		return -ENOMEM;
 
-	if (!request_mem_region(res->start, resource_size(res),
-				"sta2x11-sctl"))
+	if (!request_mem_region(res->start, resource_size(res), name))
 		return -EBUSY;
 
-	mfd->sctl_regs = ioremap(res->start, resource_size(res));
-	if (!mfd->sctl_regs) {
+	mfd->regs[index] = ioremap(res->start, resource_size(res));
+	if (!mfd->regs[index]) {
 		release_mem_region(res->start, resource_size(res));
 		return -ENOMEM;
 	}
-	sctl_regset.base = mfd->sctl_regs;
-	sta2x11_sctl_debugfs = debugfs_create_regset32("sta2x11-sctl",
-						  S_IFREG | S_IRUGO,
-						  NULL, &sctl_regset);
+	regset->base = mfd->regs[index];
+	sta2x11_mfd_debugfs[index] = debugfs_create_regset32(name,
+							     S_IFREG | S_IRUGO,
+							     NULL, regset);
 	return 0;
 }
 
-static int sta2x11_apbreg_probe(struct platform_device *dev)
+static int sta2x11_sctl_probe(struct platform_device *dev)
 {
-	struct pci_dev **pdev;
-	struct sta2x11_mfd *mfd;
-	struct resource *res;
-
-	pdev = dev->dev.platform_data;
-	dev_dbg(&dev->dev, "%s: pdata is %p\n", __func__, pdev);
-	dev_dbg(&dev->dev, "%s: *pdata is %p\n", __func__, *pdev);
-
-	mfd = sta2x11_mfd_find(*pdev);
-	if (!mfd)
-		return -ENODEV;
-
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOMEM;
-
-	if (!request_mem_region(res->start, resource_size(res),
-				"sta2x11-apbreg"))
-		return -EBUSY;
+	return sta2x11_mfd_platform_probe(dev, sta2x11_sctl);
+}
 
-	mfd->apbreg_regs = ioremap(res->start, resource_size(res));
-	if (!mfd->apbreg_regs) {
-		release_mem_region(res->start, resource_size(res));
-		return -ENOMEM;
-	}
-	dev_dbg(&dev->dev, "%s: regbase %p\n", __func__, mfd->apbreg_regs);
+static int sta2x11_apbreg_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_apbreg);
+}
 
-	apbreg_regset.base = mfd->apbreg_regs;
-	sta2x11_apbreg_debugfs = debugfs_create_regset32("sta2x11-apbreg",
-						  S_IFREG | S_IRUGO,
-						  NULL, &apbreg_regset);
-	return 0;
+static int sta2x11_apb_soc_regs_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_apb_soc_regs);
 }
 
-/* The two platform drivers */
+/* The three platform drivers */
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
 		.name	= "sta2x11-sctl",
@@ -280,6 +280,20 @@ static int __init sta2x11_apbreg_init(void)
 	return platform_driver_register(&sta2x11_platform_driver);
 }
 
+static struct platform_driver sta2x11_apb_soc_regs_platform_driver = {
+	.driver = {
+		.name	= "sta2x11-apb-soc-regs",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sta2x11_apb_soc_regs_probe,
+};
+
+static int __init sta2x11_apb_soc_regs_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&sta2x11_apb_soc_regs_platform_driver);
+}
+
 /*
  * What follows are the PCI devices that host the above pdevs.
  * Each logic block is 4kB and they are all consecutive: we use this info.
@@ -449,7 +463,7 @@ static void __devinit sta2x11_mfd_setup(struct pci_dev *pdev,
 static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *pci_id)
 {
-	int err;
+	int err, i;
 	struct sta2x11_mfd_setup_data *setup_data;
 	struct sta2x11_gpio_pdata *gpio_data;
 
@@ -485,25 +499,18 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
 	sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
-
-	err = mfd_add_devices(&pdev->dev, -1,
-			      setup_data->bars[0].cells,
-			      setup_data->bars[0].ncells,
-			      &pdev->resource[0],
-			      0);
-	if (err) {
-		dev_err(&pdev->dev, "mfd_add_devices[0] failed: %d\n", err);
-		goto err_disable;
-	}
-
-	err = mfd_add_devices(&pdev->dev, -1,
-			      setup_data->bars[1].cells,
-			      setup_data->bars[1].ncells,
-			      &pdev->resource[1],
-			      0);
-	if (err) {
-		dev_err(&pdev->dev, "mfd_add_devices[1] failed: %d\n", err);
-		goto err_disable;
+	/* Just 2 bars for all mfd's at present */
+	for (i = 0; i < 2; i++) {
+		err = mfd_add_devices(&pdev->dev, -1,
+				      setup_data->bars[i].cells,
+				      setup_data->bars[i].ncells,
+				      &pdev->resource[i],
+				      0);
+		if (err) {
+			dev_err(&pdev->dev,
+				"mfd_add_devices[%d] failed: %d\n", i, err);
+			goto err_disable;
+		}
 	}
 
 	return 0;
@@ -543,6 +550,7 @@ static int __init sta2x11_mfd_init(void)
  */
 subsys_initcall(sta2x11_apbreg_init);
 subsys_initcall(sta2x11_sctl_init);
+subsys_initcall(sta2x11_apb_soc_regs_init);
 rootfs_initcall(sta2x11_mfd_init);
 
 MODULE_LICENSE("GPL v2");
-- 
1.7.9.1

