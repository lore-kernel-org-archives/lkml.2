Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2ILKN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:13:56 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:39801 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab2ILKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:11:41 -0400
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Date: Wed, 12 Sep 2012 12:11:12 +0200
Message-Id: <1347444680-31479-2-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347444680-31479-1-git-send-email-ciminaghi@gnudd.com>
References: <1347444680-31479-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>

A driver for the apb-soc registers is needed by the clock
infrastructure code to configure and control clocks on the sta2x11
chip.
Since some of the functions in sta2x11-mfd.c were almost identical
for the two existing platform devices, the following changes
have been performed to avoid further code duplication while
adding the apb-soc-regs driver:

* The sctl_regs and apbreg_regs fields in struct sta2x11_mfd
have been turned into just one array of pointers accessed by
device index.
* Platform probe methods have become one-liners invoking a
common probe with the device's index as second parameter.
* For loops have been inserted where the same operations
were performed for each of the two bars of a pci device.
* The apbreg_mask and sctl_mask functions were almost identical,
so they were turned into inline functions invoking a common
__sta2x11_mfd_mask() with the platform device's index as last
parameter. To do this, enum sta2x11_mfd_plat_dev has been declared in
sta2x11-mfd.h and more device types have been added to it.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/sta2x11-mfd.c       |  350 +++++++++++++++++++++++++++------------
 include/linux/mfd/sta2x11-mfd.h |  156 +++++++++++++++++-
 2 files changed, 395 insertions(+), 111 deletions(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index d31fed0..5fbd044 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -40,8 +40,7 @@ struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
 	spinlock_t lock;
 	struct list_head list;
-	void __iomem *sctl_regs;
-	void __iomem *apbreg_regs;
+	void __iomem *regs[sta2x11_n_mfd_plat_devs];
 };
 
 static LIST_HEAD(sta2x11_mfd_list);
@@ -100,56 +99,33 @@ static int __devexit mfd_remove(struct pci_dev *pdev)
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
+	void __iomem *regs = mfd->regs[index];
 
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
-EXPORT_SYMBOL(sta2x11_sctl_mask);
-
-u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
-{
-	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
-	u32 r;
-	unsigned long flags;
-
-	if (!mfd) {
-		dev_warn(&pdev->dev, ": can't access apb regs\n");
-		return 0;
-	}
-	if (!mfd->apbreg_regs) {
-		dev_warn(&pdev->dev, ": apb bridge not initialized\n");
-		return 0;
-	}
-	spin_lock_irqsave(&mfd->lock, flags);
-	r = readl(mfd->apbreg_regs + reg);
-	r &= ~mask;
-	r |= val;
-	if (mask)
-		writel(r, mfd->apbreg_regs + reg);
-	spin_unlock_irqrestore(&mfd->lock, flags);
-	return r;
-}
-EXPORT_SYMBOL(sta2x11_apbreg_mask);
+EXPORT_SYMBOL(__sta2x11_mfd_mask);
 
 /* Two debugfs files, for our registers (FIXME: one instance only) */
 #define REG(regname) {.name = #regname, .offset = SCTL_ ## regname}
@@ -180,51 +156,103 @@ static struct debugfs_regset32 apbreg_regset = {
 	.nregs = ARRAY_SIZE(sta2x11_apbreg_regs),
 };
 
-static struct dentry *sta2x11_sctl_debugfs;
-static struct dentry *sta2x11_apbreg_debugfs;
+#define REG(regname) {.name = #regname, .offset = regname}
+static struct debugfs_reg32 sta2x11_apb_soc_regs_regs[] = {
+	REG(PCIE_EP1_FUNC3_0_INTR_REG), REG(PCIE_EP1_FUNC7_4_INTR_REG),
+	REG(PCIE_EP2_FUNC3_0_INTR_REG), REG(PCIE_EP2_FUNC7_4_INTR_REG),
+	REG(PCIE_EP3_FUNC3_0_INTR_REG), REG(PCIE_EP3_FUNC7_4_INTR_REG),
+	REG(PCIE_EP4_FUNC3_0_INTR_REG), REG(PCIE_EP4_FUNC7_4_INTR_REG),
+	REG(PCIE_INTR_ENABLE0_REG), REG(PCIE_INTR_ENABLE1_REG),
+	REG(PCIE_EP1_FUNC_TC_REG), REG(PCIE_EP2_FUNC_TC_REG),
+	REG(PCIE_EP3_FUNC_TC_REG), REG(PCIE_EP4_FUNC_TC_REG),
+	REG(PCIE_EP1_FUNC_F_REG), REG(PCIE_EP2_FUNC_F_REG),
+	REG(PCIE_EP3_FUNC_F_REG), REG(PCIE_EP4_FUNC_F_REG),
+	REG(PCIE_PAB_AMBA_SW_RST_REG), REG(PCIE_PM_STATUS_0_PORT_0_4),
+	REG(PCIE_PM_STATUS_7_0_EP1), REG(PCIE_PM_STATUS_7_0_EP2),
+	REG(PCIE_PM_STATUS_7_0_EP3), REG(PCIE_PM_STATUS_7_0_EP4),
+	REG(PCIE_DEV_ID_0_EP1_REG), REG(PCIE_CC_REV_ID_0_EP1_REG),
+	REG(PCIE_DEV_ID_1_EP1_REG), REG(PCIE_CC_REV_ID_1_EP1_REG),
+	REG(PCIE_DEV_ID_2_EP1_REG), REG(PCIE_CC_REV_ID_2_EP1_REG),
+	REG(PCIE_DEV_ID_3_EP1_REG), REG(PCIE_CC_REV_ID_3_EP1_REG),
+	REG(PCIE_DEV_ID_4_EP1_REG), REG(PCIE_CC_REV_ID_4_EP1_REG),
+	REG(PCIE_DEV_ID_5_EP1_REG), REG(PCIE_CC_REV_ID_5_EP1_REG),
+	REG(PCIE_DEV_ID_6_EP1_REG), REG(PCIE_CC_REV_ID_6_EP1_REG),
+	REG(PCIE_DEV_ID_7_EP1_REG), REG(PCIE_CC_REV_ID_7_EP1_REG),
+	REG(PCIE_DEV_ID_0_EP2_REG), REG(PCIE_CC_REV_ID_0_EP2_REG),
+	REG(PCIE_DEV_ID_1_EP2_REG), REG(PCIE_CC_REV_ID_1_EP2_REG),
+	REG(PCIE_DEV_ID_2_EP2_REG), REG(PCIE_CC_REV_ID_2_EP2_REG),
+	REG(PCIE_DEV_ID_3_EP2_REG), REG(PCIE_CC_REV_ID_3_EP2_REG),
+	REG(PCIE_DEV_ID_4_EP2_REG), REG(PCIE_CC_REV_ID_4_EP2_REG),
+	REG(PCIE_DEV_ID_5_EP2_REG), REG(PCIE_CC_REV_ID_5_EP2_REG),
+	REG(PCIE_DEV_ID_6_EP2_REG), REG(PCIE_CC_REV_ID_6_EP2_REG),
+	REG(PCIE_DEV_ID_7_EP2_REG), REG(PCIE_CC_REV_ID_7_EP2_REG),
+	REG(PCIE_DEV_ID_0_EP3_REG), REG(PCIE_CC_REV_ID_0_EP3_REG),
+	REG(PCIE_DEV_ID_1_EP3_REG), REG(PCIE_CC_REV_ID_1_EP3_REG),
+	REG(PCIE_DEV_ID_2_EP3_REG), REG(PCIE_CC_REV_ID_2_EP3_REG),
+	REG(PCIE_DEV_ID_3_EP3_REG), REG(PCIE_CC_REV_ID_3_EP3_REG),
+	REG(PCIE_DEV_ID_4_EP3_REG), REG(PCIE_CC_REV_ID_4_EP3_REG),
+	REG(PCIE_DEV_ID_5_EP3_REG), REG(PCIE_CC_REV_ID_5_EP3_REG),
+	REG(PCIE_DEV_ID_6_EP3_REG), REG(PCIE_CC_REV_ID_6_EP3_REG),
+	REG(PCIE_DEV_ID_7_EP3_REG), REG(PCIE_CC_REV_ID_7_EP3_REG),
+	REG(PCIE_DEV_ID_0_EP4_REG), REG(PCIE_CC_REV_ID_0_EP4_REG),
+	REG(PCIE_DEV_ID_1_EP4_REG), REG(PCIE_CC_REV_ID_1_EP4_REG),
+	REG(PCIE_DEV_ID_2_EP4_REG), REG(PCIE_CC_REV_ID_2_EP4_REG),
+	REG(PCIE_DEV_ID_3_EP4_REG), REG(PCIE_CC_REV_ID_3_EP4_REG),
+	REG(PCIE_DEV_ID_4_EP4_REG), REG(PCIE_CC_REV_ID_4_EP4_REG),
+	REG(PCIE_DEV_ID_5_EP4_REG), REG(PCIE_CC_REV_ID_5_EP4_REG),
+	REG(PCIE_DEV_ID_6_EP4_REG), REG(PCIE_CC_REV_ID_6_EP4_REG),
+	REG(PCIE_DEV_ID_7_EP4_REG), REG(PCIE_CC_REV_ID_7_EP4_REG),
+	REG(PCIE_SUBSYS_VEN_ID_REG), REG(PCIE_COMMON_CLOCK_CONFIG_0_4_0),
+	REG(PCIE_MIPHYP_SSC_EN_REG), REG(PCIE_MIPHYP_ADDR_REG),
+	REG(PCIE_L1_ASPM_READY_REG), REG(PCIE_EXT_CFG_RDY_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS0_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS1_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS2_REG),
+	REG(PCIE_SoC_INT_ROUTER_STATUS3_REG),
+	REG(DMA_IP_CTRL_REG), REG(DISP_BRIDGE_PU_PD_CTRL_REG),
+	REG(VIP_PU_PD_CTRL_REG), REG(USB_MLB_PU_PD_CTRL_REG),
+	REG(SDIO_PU_PD_MISCFUNC_CTRL_REG1), REG(SDIO_PU_PD_MISCFUNC_CTRL_REG2),
+	REG(UART_PU_PD_CTRL_REG), REG(ARM_Lock), REG(SYS_IO_CHAR_REG1),
+	REG(SYS_IO_CHAR_REG2), REG(SATA_CORE_ID_REG), REG(SATA_CTRL_REG),
+	REG(I2C_HSFIX_MISC_REG), REG(SPARE2_RESERVED), REG(SPARE3_RESERVED),
+	REG(MASTER_LOCK_REG), REG(SYSTEM_CONFIG_STATUS_REG),
+	REG(MSP_CLK_CTRL_REG), REG(COMPENSATION_REG1), REG(COMPENSATION_REG2),
+	REG(COMPENSATION_REG3), REG(TEST_CTL_REG),
+};
+#undef REG
 
-/* Probe for the two platform devices */
-static int sta2x11_sctl_probe(struct platform_device *dev)
-{
-	struct pci_dev **pdev;
-	struct sta2x11_mfd *mfd;
-	struct resource *res;
+static struct debugfs_regset32 apb_soc_regs_regset = {
+	.regs = sta2x11_apb_soc_regs_regs,
+	.nregs = ARRAY_SIZE(sta2x11_apb_soc_regs_regs),
+};
 
-	pdev = dev->dev.platform_data;
-	mfd = sta2x11_mfd_find(*pdev);
-	if (!mfd)
-		return -ENODEV;
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOMEM;
+static struct dentry *sta2x11_mfd_debugfs[sta2x11_n_mfd_plat_devs];
 
-	if (!request_mem_region(res->start, resource_size(res),
-				"sta2x11-sctl"))
-		return -EBUSY;
+static struct debugfs_regset32 *sta2x11_mfd_regset[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = &sctl_regset,
+	[sta2x11_apbreg] = &apbreg_regset,
+	[sta2x11_apb_soc_regs] = &apb_soc_regs_regset,
+};
 
-	mfd->sctl_regs = ioremap(res->start, resource_size(res));
-	if (!mfd->sctl_regs) {
-		release_mem_region(res->start, resource_size(res));
-		return -ENOMEM;
-	}
-	sctl_regset.base = mfd->sctl_regs;
-	sta2x11_sctl_debugfs = debugfs_create_regset32("sta2x11-sctl",
-						  S_IFREG | S_IRUGO,
-						  NULL, &sctl_regset);
-	return 0;
-}
+static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = "sta2x11-sctl",
+	[sta2x11_apbreg] = "sta2x11-apbreg",
+	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
+};
 
-static int sta2x11_apbreg_probe(struct platform_device *dev)
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
-	dev_dbg(&dev->dev, "%s: pdata is %p\n", __func__, pdev);
-	dev_dbg(&dev->dev, "%s: *pdata is %p\n", __func__, *pdev);
-
 	mfd = sta2x11_mfd_find(*pdev);
 	if (!mfd)
 		return -ENODEV;
@@ -233,25 +261,37 @@ static int sta2x11_apbreg_probe(struct platform_device *dev)
 	if (!res)
 		return -ENOMEM;
 
-	if (!request_mem_region(res->start, resource_size(res),
-				"sta2x11-apbreg"))
+	if (!request_mem_region(res->start, resource_size(res), name))
 		return -EBUSY;
 
-	mfd->apbreg_regs = ioremap(res->start, resource_size(res));
-	if (!mfd->apbreg_regs) {
+	mfd->regs[index] = ioremap(res->start, resource_size(res));
+	if (!mfd->regs[index]) {
 		release_mem_region(res->start, resource_size(res));
 		return -ENOMEM;
 	}
-	dev_dbg(&dev->dev, "%s: regbase %p\n", __func__, mfd->apbreg_regs);
-
-	apbreg_regset.base = mfd->apbreg_regs;
-	sta2x11_apbreg_debugfs = debugfs_create_regset32("sta2x11-apbreg",
-						  S_IFREG | S_IRUGO,
-						  NULL, &apbreg_regset);
+	regset->base = mfd->regs[index];
+	sta2x11_mfd_debugfs[index] = debugfs_create_regset32(name,
+							     S_IFREG | S_IRUGO,
+							     NULL, regset);
 	return 0;
 }
 
-/* The two platform drivers */
+static int sta2x11_sctl_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_sctl);
+}
+
+static int sta2x11_apbreg_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_apbreg);
+}
+
+static int sta2x11_apb_soc_regs_probe(struct platform_device *dev)
+{
+	return sta2x11_mfd_platform_probe(dev, sta2x11_apb_soc_regs);
+}
+
+/* The three platform drivers */
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
 		.name	= "sta2x11-sctl",
@@ -280,13 +320,29 @@ static int __init sta2x11_apbreg_init(void)
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
- * What follows is the PCI device that hosts the above two pdevs.
+ * What follows are the PCI devices that host the above pdevs.
  * Each logic block is 4kB and they are all consecutive: we use this info.
  */
 
-/* Bar 0 */
-enum bar0_cells {
+/* Mfd 0 device */
+
+/* Mfd 0, Bar 0 */
+enum mfd0_bar0_cells {
 	STA2X11_GPIO_0 = 0,
 	STA2X11_GPIO_1,
 	STA2X11_GPIO_2,
@@ -295,8 +351,8 @@ enum bar0_cells {
 	STA2X11_SCR,
 	STA2X11_TIME,
 };
-/* Bar 1 */
-enum bar1_cells {
+/* Mfd 0 , Bar 1 */
+enum mfd0_bar1_cells {
 	STA2X11_APBREG = 0,
 };
 #define CELL_4K(_name, _cell) { \
@@ -330,17 +386,46 @@ static const __devinitconst struct resource apbreg_resources[] = {
 #define DEV(_name, _r) \
 	{ .name = _name, .num_resources = ARRAY_SIZE(_r), .resources = _r, }
 
-static __devinitdata struct mfd_cell sta2x11_mfd_bar0[] = {
+static __devinitdata struct mfd_cell sta2x11_mfd0_bar0[] = {
 	DEV("sta2x11-gpio", gpio_resources), /* offset 0: we add pdata later */
 	DEV("sta2x11-sctl", sctl_resources),
 	DEV("sta2x11-scr", scr_resources),
 	DEV("sta2x11-time", time_resources),
 };
 
-static __devinitdata struct mfd_cell sta2x11_mfd_bar1[] = {
+static __devinitdata struct mfd_cell sta2x11_mfd0_bar1[] = {
 	DEV("sta2x11-apbreg", apbreg_resources),
 };
 
+/* Mfd 1 devices */
+
+/* Mfd 1, Bar 0 */
+enum mfd1_bar0_cells {
+	STA2X11_VIC = 0,
+};
+
+/* Mfd 1, Bar 1 */
+enum mfd1_bar1_cells {
+	STA2X11_APB_SOC_REGS = 0,
+};
+
+static const __devinitconst struct resource vic_resources[] = {
+	CELL_4K("sta2x11-vic", STA2X11_VIC),
+};
+
+static const __devinitconst struct resource apb_soc_regs_resources[] = {
+	CELL_4K("sta2x11-apb-soc-regs", STA2X11_APB_SOC_REGS),
+};
+
+static __devinitdata struct mfd_cell sta2x11_mfd1_bar0[] = {
+	DEV("sta2x11-vic", vic_resources),
+};
+
+static __devinitdata struct mfd_cell sta2x11_mfd1_bar1[] = {
+	DEV("sta2x11-apb-soc-regs", apb_soc_regs_resources),
+};
+
+
 static int sta2x11_mfd_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	pci_save_state(pdev);
@@ -363,10 +448,63 @@ static int sta2x11_mfd_resume(struct pci_dev *pdev)
 	return 0;
 }
 
+struct sta2x11_mfd_bar_setup_data {
+	struct mfd_cell *cells;
+	int ncells;
+};
+
+struct sta2x11_mfd_setup_data {
+	struct sta2x11_mfd_bar_setup_data bars[2];
+};
+
+#define STA2X11_MFD0 0
+#define STA2X11_MFD1 1
+
+static struct sta2x11_mfd_setup_data mfd_setup_data[] = {
+	/* Mfd 0: gpio, sctl, scr, timers / apbregs */
+	[STA2X11_MFD0] = {
+		.bars = {
+			[0] = {
+				.cells = sta2x11_mfd0_bar0,
+				.ncells = ARRAY_SIZE(sta2x11_mfd0_bar0),
+			},
+			[1] = {
+				.cells = sta2x11_mfd0_bar1,
+				.ncells = ARRAY_SIZE(sta2x11_mfd0_bar1),
+			},
+		},
+	},
+	/* Mfd 1: vic / apb-soc-regs */
+	[STA2X11_MFD1] = {
+		.bars = {
+			[0] = {
+				.cells = sta2x11_mfd1_bar0,
+				.ncells = ARRAY_SIZE(sta2x11_mfd1_bar0),
+			},
+			[1] = {
+				.cells = sta2x11_mfd1_bar1,
+				.ncells = ARRAY_SIZE(sta2x11_mfd1_bar1),
+			},
+		},
+	},
+};
+
+static void __devinit sta2x11_mfd_setup(struct pci_dev *pdev,
+					struct sta2x11_mfd_setup_data *sd)
+{
+	int i, j;
+	for (i = 0; i < ARRAY_SIZE(sd->bars); i++)
+		for (j = 0; j < sd->bars[i].ncells; j++) {
+			sd->bars[i].cells[j].pdata_size = sizeof(pdev);
+			sd->bars[i].cells[j].platform_data = &pdev;
+		}
+}
+
 static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 				       const struct pci_device_id *pci_id)
 {
 	int err, i;
+	struct sta2x11_mfd_setup_data *setup_data;
 	struct sta2x11_gpio_pdata *gpio_data;
 
 	dev_info(&pdev->dev, "%s\n", __func__);
@@ -381,6 +519,10 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 	if (err)
 		dev_info(&pdev->dev, "Enable msi failed\n");
 
+	setup_data = pci_id->device == PCI_DEVICE_ID_STMICRO_GPIO ?
+		&mfd_setup_data[STA2X11_MFD0] :
+		&mfd_setup_data[STA2X11_MFD1];
+
 	/* Read gpio config data as pci device's platform data */
 	gpio_data = dev_get_platdata(&pdev->dev);
 	if (!gpio_data)
@@ -392,35 +534,23 @@ static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
 		pdev, &pdev);
 
 	/* platform data is the pci device for all of them */
-	for (i = 0; i < ARRAY_SIZE(sta2x11_mfd_bar0); i++) {
-		sta2x11_mfd_bar0[i].pdata_size = sizeof(pdev);
-		sta2x11_mfd_bar0[i].platform_data = &pdev;
-	}
-	sta2x11_mfd_bar1[0].pdata_size = sizeof(pdev);
-	sta2x11_mfd_bar1[0].platform_data = &pdev;
+	sta2x11_mfd_setup(pdev, setup_data);
 
 	/* Record this pdev before mfd_add_devices: their probe looks for it */
 	sta2x11_mfd_add(pdev, GFP_ATOMIC);
 
-
-	err = mfd_add_devices(&pdev->dev, -1,
-			      sta2x11_mfd_bar0,
-			      ARRAY_SIZE(sta2x11_mfd_bar0),
-			      &pdev->resource[0],
-			      0);
-	if (err) {
-		dev_err(&pdev->dev, "mfd_add_devices[0] failed: %d\n", err);
-		goto err_disable;
-	}
-
-	err = mfd_add_devices(&pdev->dev, -1,
-			      sta2x11_mfd_bar1,
-			      ARRAY_SIZE(sta2x11_mfd_bar1),
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
@@ -434,6 +564,7 @@ err_disable:
 
 static DEFINE_PCI_DEVICE_TABLE(sta2x11_mfd_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIC)},
 	{0,},
 };
 
@@ -459,6 +590,7 @@ static int __init sta2x11_mfd_init(void)
  */
 subsys_initcall(sta2x11_apbreg_init);
 subsys_initcall(sta2x11_sctl_init);
+subsys_initcall(sta2x11_apb_soc_regs_init);
 rootfs_initcall(sta2x11_mfd_init);
 
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index d179227..4d85879 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -26,6 +26,20 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
+enum sta2x11_mfd_plat_dev {
+	sta2x11_sctl = 0,
+	sta2x11_gpio,
+	sta2x11_scr,
+	sta2x11_time,
+	sta2x11_apbreg,
+	sta2x11_apb_soc_regs,
+	sta2x11_vic,
+	sta2x11_n_mfd_plat_devs,
+};
+
+extern u32
+__sta2x11_mfd_mask(struct pci_dev *, u32, u32, u32, enum sta2x11_mfd_plat_dev);
+
 /*
  * The MFD PCI block includes the GPIO peripherals and other register blocks.
  * For GPIO, we have 32*4 bits (I use "gsta" for "gpio sta2x11".)
@@ -182,7 +196,11 @@ struct sta2x11_gpio_pdata {
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
@@ -211,7 +229,11 @@ u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
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
@@ -321,4 +343,134 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
 #define SCTL_SCPEREN1_I2C3		(1 << 16)
 #define SCTL_SCPEREN1_USB_PHY		(1 << 17)
 
+/*
+ * APB-SOC registers
+ */
+static inline
+u32 sta2x11_apb_soc_regs_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	return __sta2x11_mfd_mask(pdev, reg, mask, val, sta2x11_apb_soc_regs);
+}
+
+#define PCIE_EP1_FUNC3_0_INTR_REG	0x000
+#define PCIE_EP1_FUNC7_4_INTR_REG	0x004
+#define PCIE_EP2_FUNC3_0_INTR_REG	0x008
+#define PCIE_EP2_FUNC7_4_INTR_REG	0x00c
+#define PCIE_EP3_FUNC3_0_INTR_REG	0x010
+#define PCIE_EP3_FUNC7_4_INTR_REG	0x014
+#define PCIE_EP4_FUNC3_0_INTR_REG	0x018
+#define PCIE_EP4_FUNC7_4_INTR_REG	0x01c
+#define PCIE_INTR_ENABLE0_REG		0x020
+#define PCIE_INTR_ENABLE1_REG		0x024
+#define PCIE_EP1_FUNC_TC_REG		0x028
+#define PCIE_EP2_FUNC_TC_REG		0x02c
+#define PCIE_EP3_FUNC_TC_REG		0x030
+#define PCIE_EP4_FUNC_TC_REG		0x034
+#define PCIE_EP1_FUNC_F_REG		0x038
+#define PCIE_EP2_FUNC_F_REG		0x03c
+#define PCIE_EP3_FUNC_F_REG		0x040
+#define PCIE_EP4_FUNC_F_REG		0x044
+#define PCIE_PAB_AMBA_SW_RST_REG	0x048
+#define PCIE_PM_STATUS_0_PORT_0_4	0x04c
+#define PCIE_PM_STATUS_7_0_EP1		0x050
+#define PCIE_PM_STATUS_7_0_EP2		0x054
+#define PCIE_PM_STATUS_7_0_EP3		0x058
+#define PCIE_PM_STATUS_7_0_EP4		0x05c
+#define PCIE_DEV_ID_0_EP1_REG		0x060
+#define PCIE_CC_REV_ID_0_EP1_REG	0x064
+#define PCIE_DEV_ID_1_EP1_REG		0x068
+#define PCIE_CC_REV_ID_1_EP1_REG	0x06c
+#define PCIE_DEV_ID_2_EP1_REG		0x070
+#define PCIE_CC_REV_ID_2_EP1_REG	0x074
+#define PCIE_DEV_ID_3_EP1_REG		0x078
+#define PCIE_CC_REV_ID_3_EP1_REG	0x07c
+#define PCIE_DEV_ID_4_EP1_REG		0x080
+#define PCIE_CC_REV_ID_4_EP1_REG	0x084
+#define PCIE_DEV_ID_5_EP1_REG		0x088
+#define PCIE_CC_REV_ID_5_EP1_REG	0x08c
+#define PCIE_DEV_ID_6_EP1_REG		0x090
+#define PCIE_CC_REV_ID_6_EP1_REG	0x094
+#define PCIE_DEV_ID_7_EP1_REG		0x098
+#define PCIE_CC_REV_ID_7_EP1_REG	0x09c
+#define PCIE_DEV_ID_0_EP2_REG		0x0a0
+#define PCIE_CC_REV_ID_0_EP2_REG	0x0a4
+#define PCIE_DEV_ID_1_EP2_REG		0x0a8
+#define PCIE_CC_REV_ID_1_EP2_REG	0x0ac
+#define PCIE_DEV_ID_2_EP2_REG		0x0b0
+#define PCIE_CC_REV_ID_2_EP2_REG	0x0b4
+#define PCIE_DEV_ID_3_EP2_REG		0x0b8
+#define PCIE_CC_REV_ID_3_EP2_REG	0x0bc
+#define PCIE_DEV_ID_4_EP2_REG		0x0c0
+#define PCIE_CC_REV_ID_4_EP2_REG	0x0c4
+#define PCIE_DEV_ID_5_EP2_REG		0x0c8
+#define PCIE_CC_REV_ID_5_EP2_REG	0x0cc
+#define PCIE_DEV_ID_6_EP2_REG		0x0d0
+#define PCIE_CC_REV_ID_6_EP2_REG	0x0d4
+#define PCIE_DEV_ID_7_EP2_REG		0x0d8
+#define PCIE_CC_REV_ID_7_EP2_REG	0x0dC
+#define PCIE_DEV_ID_0_EP3_REG		0x0e0
+#define PCIE_CC_REV_ID_0_EP3_REG	0x0e4
+#define PCIE_DEV_ID_1_EP3_REG		0x0e8
+#define PCIE_CC_REV_ID_1_EP3_REG	0x0ec
+#define PCIE_DEV_ID_2_EP3_REG		0x0f0
+#define PCIE_CC_REV_ID_2_EP3_REG	0x0f4
+#define PCIE_DEV_ID_3_EP3_REG		0x0f8
+#define PCIE_CC_REV_ID_3_EP3_REG	0x0fc
+#define PCIE_DEV_ID_4_EP3_REG		0x100
+#define PCIE_CC_REV_ID_4_EP3_REG	0x104
+#define PCIE_DEV_ID_5_EP3_REG		0x108
+#define PCIE_CC_REV_ID_5_EP3_REG	0x10c
+#define PCIE_DEV_ID_6_EP3_REG		0x110
+#define PCIE_CC_REV_ID_6_EP3_REG	0x114
+#define PCIE_DEV_ID_7_EP3_REG		0x118
+#define PCIE_CC_REV_ID_7_EP3_REG	0x11c
+#define PCIE_DEV_ID_0_EP4_REG		0x120
+#define PCIE_CC_REV_ID_0_EP4_REG	0x124
+#define PCIE_DEV_ID_1_EP4_REG		0x128
+#define PCIE_CC_REV_ID_1_EP4_REG	0x12c
+#define PCIE_DEV_ID_2_EP4_REG		0x130
+#define PCIE_CC_REV_ID_2_EP4_REG	0x134
+#define PCIE_DEV_ID_3_EP4_REG		0x138
+#define PCIE_CC_REV_ID_3_EP4_REG	0x13c
+#define PCIE_DEV_ID_4_EP4_REG		0x140
+#define PCIE_CC_REV_ID_4_EP4_REG	0x144
+#define PCIE_DEV_ID_5_EP4_REG		0x148
+#define PCIE_CC_REV_ID_5_EP4_REG	0x14c
+#define PCIE_DEV_ID_6_EP4_REG		0x150
+#define PCIE_CC_REV_ID_6_EP4_REG	0x154
+#define PCIE_DEV_ID_7_EP4_REG		0x158
+#define PCIE_CC_REV_ID_7_EP4_REG	0x15c
+#define PCIE_SUBSYS_VEN_ID_REG		0x160
+#define PCIE_COMMON_CLOCK_CONFIG_0_4_0	0x164
+#define PCIE_MIPHYP_SSC_EN_REG		0x168
+#define PCIE_MIPHYP_ADDR_REG		0x16c
+#define PCIE_L1_ASPM_READY_REG		0x170
+#define PCIE_EXT_CFG_RDY_REG		0x174
+#define PCIE_SoC_INT_ROUTER_STATUS0_REG 0x178
+#define PCIE_SoC_INT_ROUTER_STATUS1_REG 0x17c
+#define PCIE_SoC_INT_ROUTER_STATUS2_REG 0x180
+#define PCIE_SoC_INT_ROUTER_STATUS3_REG 0x184
+#define DMA_IP_CTRL_REG			0x324
+#define DISP_BRIDGE_PU_PD_CTRL_REG	0x328
+#define VIP_PU_PD_CTRL_REG		0x32c
+#define USB_MLB_PU_PD_CTRL_REG		0x330
+#define SDIO_PU_PD_MISCFUNC_CTRL_REG1	0x334
+#define SDIO_PU_PD_MISCFUNC_CTRL_REG2	0x338
+#define UART_PU_PD_CTRL_REG		0x33c
+#define ARM_Lock			0x340
+#define SYS_IO_CHAR_REG1		0x344
+#define SYS_IO_CHAR_REG2		0x348
+#define SATA_CORE_ID_REG		0x34c
+#define SATA_CTRL_REG			0x350
+#define I2C_HSFIX_MISC_REG		0x354
+#define SPARE2_RESERVED			0x358
+#define SPARE3_RESERVED			0x35c
+#define MASTER_LOCK_REG			0x368
+#define SYSTEM_CONFIG_STATUS_REG	0x36c
+#define MSP_CLK_CTRL_REG		0x39c
+#define COMPENSATION_REG1		0x3c4
+#define COMPENSATION_REG2		0x3c8
+#define COMPENSATION_REG3		0x3cc
+#define TEST_CTL_REG			0x3d0
+
 #endif /* __STA2X11_MFD_H */
-- 
1.7.9.1

