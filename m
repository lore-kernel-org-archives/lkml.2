Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2KIOUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 09:20:31 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:46797 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab2KIOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 09:20:27 -0500
From: ciminaghi@gnudd.com
To: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 02/10] drivers/mfd/sta2x11-mfd: add regmap support
Date: Fri,  9 Nov 2012 15:19:53 +0100
Message-Id: <1352470801-2418-3-git-send-email-ciminaghi@gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/sta2x11-mfd.c       |  234 +++++++++++++++++++++------------------
 include/linux/mfd/sta2x11-mfd.h |    1 +
 3 files changed, 131 insertions(+), 105 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3dcbf06..24ae0fe 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1046,6 +1046,7 @@ config MFD_STA2X11
 	bool "STA2X11 multi function device support"
 	depends on STA2X11
 	select MFD_CORE
+	select REGMAP_MMIO
 
 config MFD_SYSCON
 	bool "System Controller Register R/W Based on Regmap"
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 9e01b84..0cac201 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -27,17 +27,25 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/sta2x11-mfd.h>
+#include <linux/regmap.h>
 
 #include <asm/sta2x11.h>
 
+static inline int __reg_within_range(unsigned int r,
+				     unsigned int start,
+				     unsigned int end)
+{
+	return ((r >= start) && (r <= end));
+}
+
 /* This describes STA2X11 MFD chip for us, we may have several */
 struct sta2x11_mfd {
 	struct sta2x11_instance *instance;
+	struct regmap *regmap[sta2x11_n_mfd_plat_devs];
 	spinlock_t lock;
 	struct list_head list;
 	void __iomem *regs[sta2x11_n_mfd_plat_devs];
@@ -127,118 +135,126 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
 }
 EXPORT_SYMBOL(__sta2x11_mfd_mask);
 
-/* Two debugfs files, for our registers (FIXME: one instance only) */
-#define REG(regname) {.name = #regname, .offset = SCTL_ ## regname}
-static struct debugfs_reg32 sta2x11_sctl_regs[] = {
-	REG(SCCTL), REG(ARMCFG), REG(SCPLLCTL), REG(SCPLLFCTRL),
-	REG(SCRESFRACT), REG(SCRESCTRL1), REG(SCRESXTRL2), REG(SCPEREN0),
-	REG(SCPEREN1), REG(SCPEREN2), REG(SCGRST), REG(SCPCIPMCR1),
-	REG(SCPCIPMCR2), REG(SCPCIPMSR1), REG(SCPCIPMSR2), REG(SCPCIPMSR3),
-	REG(SCINTREN), REG(SCRISR), REG(SCCLKSTAT0), REG(SCCLKSTAT1),
-	REG(SCCLKSTAT2), REG(SCRSTSTA),
-};
-#undef REG
+/*
+ * Special sta2x11-mfd regmap lock/unlock functions
+ */
 
-static struct debugfs_regset32 sctl_regset = {
-	.regs = sta2x11_sctl_regs,
-	.nregs = ARRAY_SIZE(sta2x11_sctl_regs),
-};
+static void sta2x11_regmap_lock(void *__lock)
+{
+	spinlock_t *lock = __lock;
+	spin_lock(lock);
+}
 
-#define REG(regname) {.name = #regname, .offset = regname}
-static struct debugfs_reg32 sta2x11_apbreg_regs[] = {
-	REG(APBREG_BSR), REG(APBREG_PAER), REG(APBREG_PWAC), REG(APBREG_PRAC),
-	REG(APBREG_PCG), REG(APBREG_PUR), REG(APBREG_EMU_PCG),
-};
-#undef REG
+static void sta2x11_regmap_unlock(void *__lock)
+{
+	spinlock_t *lock = __lock;
+	spin_unlock(lock);
+}
 
-static struct debugfs_regset32 apbreg_regset = {
-	.regs = sta2x11_apbreg_regs,
-	.nregs = ARRAY_SIZE(sta2x11_apbreg_regs),
+static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = "sta2x11-sctl",
+	[sta2x11_apbreg] = "sta2x11-apbreg",
+	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
 };
 
-#define REG(regname) {.name = #regname, .offset = regname}
-static struct debugfs_reg32 sta2x11_apb_soc_regs_regs[] = {
-	REG(PCIE_EP1_FUNC3_0_INTR_REG), REG(PCIE_EP1_FUNC7_4_INTR_REG),
-	REG(PCIE_EP2_FUNC3_0_INTR_REG), REG(PCIE_EP2_FUNC7_4_INTR_REG),
-	REG(PCIE_EP3_FUNC3_0_INTR_REG), REG(PCIE_EP3_FUNC7_4_INTR_REG),
-	REG(PCIE_EP4_FUNC3_0_INTR_REG), REG(PCIE_EP4_FUNC7_4_INTR_REG),
-	REG(PCIE_INTR_ENABLE0_REG), REG(PCIE_INTR_ENABLE1_REG),
-	REG(PCIE_EP1_FUNC_TC_REG), REG(PCIE_EP2_FUNC_TC_REG),
-	REG(PCIE_EP3_FUNC_TC_REG), REG(PCIE_EP4_FUNC_TC_REG),
-	REG(PCIE_EP1_FUNC_F_REG), REG(PCIE_EP2_FUNC_F_REG),
-	REG(PCIE_EP3_FUNC_F_REG), REG(PCIE_EP4_FUNC_F_REG),
-	REG(PCIE_PAB_AMBA_SW_RST_REG), REG(PCIE_PM_STATUS_0_PORT_0_4),
-	REG(PCIE_PM_STATUS_7_0_EP1), REG(PCIE_PM_STATUS_7_0_EP2),
-	REG(PCIE_PM_STATUS_7_0_EP3), REG(PCIE_PM_STATUS_7_0_EP4),
-	REG(PCIE_DEV_ID_0_EP1_REG), REG(PCIE_CC_REV_ID_0_EP1_REG),
-	REG(PCIE_DEV_ID_1_EP1_REG), REG(PCIE_CC_REV_ID_1_EP1_REG),
-	REG(PCIE_DEV_ID_2_EP1_REG), REG(PCIE_CC_REV_ID_2_EP1_REG),
-	REG(PCIE_DEV_ID_3_EP1_REG), REG(PCIE_CC_REV_ID_3_EP1_REG),
-	REG(PCIE_DEV_ID_4_EP1_REG), REG(PCIE_CC_REV_ID_4_EP1_REG),
-	REG(PCIE_DEV_ID_5_EP1_REG), REG(PCIE_CC_REV_ID_5_EP1_REG),
-	REG(PCIE_DEV_ID_6_EP1_REG), REG(PCIE_CC_REV_ID_6_EP1_REG),
-	REG(PCIE_DEV_ID_7_EP1_REG), REG(PCIE_CC_REV_ID_7_EP1_REG),
-	REG(PCIE_DEV_ID_0_EP2_REG), REG(PCIE_CC_REV_ID_0_EP2_REG),
-	REG(PCIE_DEV_ID_1_EP2_REG), REG(PCIE_CC_REV_ID_1_EP2_REG),
-	REG(PCIE_DEV_ID_2_EP2_REG), REG(PCIE_CC_REV_ID_2_EP2_REG),
-	REG(PCIE_DEV_ID_3_EP2_REG), REG(PCIE_CC_REV_ID_3_EP2_REG),
-	REG(PCIE_DEV_ID_4_EP2_REG), REG(PCIE_CC_REV_ID_4_EP2_REG),
-	REG(PCIE_DEV_ID_5_EP2_REG), REG(PCIE_CC_REV_ID_5_EP2_REG),
-	REG(PCIE_DEV_ID_6_EP2_REG), REG(PCIE_CC_REV_ID_6_EP2_REG),
-	REG(PCIE_DEV_ID_7_EP2_REG), REG(PCIE_CC_REV_ID_7_EP2_REG),
-	REG(PCIE_DEV_ID_0_EP3_REG), REG(PCIE_CC_REV_ID_0_EP3_REG),
-	REG(PCIE_DEV_ID_1_EP3_REG), REG(PCIE_CC_REV_ID_1_EP3_REG),
-	REG(PCIE_DEV_ID_2_EP3_REG), REG(PCIE_CC_REV_ID_2_EP3_REG),
-	REG(PCIE_DEV_ID_3_EP3_REG), REG(PCIE_CC_REV_ID_3_EP3_REG),
-	REG(PCIE_DEV_ID_4_EP3_REG), REG(PCIE_CC_REV_ID_4_EP3_REG),
-	REG(PCIE_DEV_ID_5_EP3_REG), REG(PCIE_CC_REV_ID_5_EP3_REG),
-	REG(PCIE_DEV_ID_6_EP3_REG), REG(PCIE_CC_REV_ID_6_EP3_REG),
-	REG(PCIE_DEV_ID_7_EP3_REG), REG(PCIE_CC_REV_ID_7_EP3_REG),
-	REG(PCIE_DEV_ID_0_EP4_REG), REG(PCIE_CC_REV_ID_0_EP4_REG),
-	REG(PCIE_DEV_ID_1_EP4_REG), REG(PCIE_CC_REV_ID_1_EP4_REG),
-	REG(PCIE_DEV_ID_2_EP4_REG), REG(PCIE_CC_REV_ID_2_EP4_REG),
-	REG(PCIE_DEV_ID_3_EP4_REG), REG(PCIE_CC_REV_ID_3_EP4_REG),
-	REG(PCIE_DEV_ID_4_EP4_REG), REG(PCIE_CC_REV_ID_4_EP4_REG),
-	REG(PCIE_DEV_ID_5_EP4_REG), REG(PCIE_CC_REV_ID_5_EP4_REG),
-	REG(PCIE_DEV_ID_6_EP4_REG), REG(PCIE_CC_REV_ID_6_EP4_REG),
-	REG(PCIE_DEV_ID_7_EP4_REG), REG(PCIE_CC_REV_ID_7_EP4_REG),
-	REG(PCIE_SUBSYS_VEN_ID_REG), REG(PCIE_COMMON_CLOCK_CONFIG_0_4_0),
-	REG(PCIE_MIPHYP_SSC_EN_REG), REG(PCIE_MIPHYP_ADDR_REG),
-	REG(PCIE_L1_ASPM_READY_REG), REG(PCIE_EXT_CFG_RDY_REG),
-	REG(PCIE_SoC_INT_ROUTER_STATUS0_REG),
-	REG(PCIE_SoC_INT_ROUTER_STATUS1_REG),
-	REG(PCIE_SoC_INT_ROUTER_STATUS2_REG),
-	REG(PCIE_SoC_INT_ROUTER_STATUS3_REG),
-	REG(DMA_IP_CTRL_REG), REG(DISP_BRIDGE_PU_PD_CTRL_REG),
-	REG(VIP_PU_PD_CTRL_REG), REG(USB_MLB_PU_PD_CTRL_REG),
-	REG(SDIO_PU_PD_MISCFUNC_CTRL_REG1), REG(SDIO_PU_PD_MISCFUNC_CTRL_REG2),
-	REG(UART_PU_PD_CTRL_REG), REG(ARM_Lock), REG(SYS_IO_CHAR_REG1),
-	REG(SYS_IO_CHAR_REG2), REG(SATA_CORE_ID_REG), REG(SATA_CTRL_REG),
-	REG(I2C_HSFIX_MISC_REG), REG(SPARE2_RESERVED), REG(SPARE3_RESERVED),
-	REG(MASTER_LOCK_REG), REG(SYSTEM_CONFIG_STATUS_REG),
-	REG(MSP_CLK_CTRL_REG), REG(COMPENSATION_REG1), REG(COMPENSATION_REG2),
-	REG(COMPENSATION_REG3), REG(TEST_CTL_REG),
+static bool sta2x11_sctl_writeable_reg(struct device *dev, unsigned int reg)
+{
+	return !__reg_within_range(reg, SCTL_SCPCIECSBRST, SCTL_SCRSTSTA);
+}
+
+static struct regmap_config sta2x11_sctl_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.lock = sta2x11_regmap_lock,
+	.unlock = sta2x11_regmap_unlock,
+	.max_register = SCTL_SCRSTSTA,
+	.writeable_reg = sta2x11_sctl_writeable_reg,
 };
-#undef REG
 
-static struct debugfs_regset32 apb_soc_regs_regset = {
-	.regs = sta2x11_apb_soc_regs_regs,
-	.nregs = ARRAY_SIZE(sta2x11_apb_soc_regs_regs),
+static bool sta2x11_apbreg_readable_reg(struct device *dev, unsigned int reg)
+{
+	/* Two blocks (CAN and MLB, SARAC) 0x100 bytes apart */
+	if (reg >= APBREG_BSR_SARAC)
+		reg -= APBREG_BSR_SARAC;
+	switch (reg) {
+	case APBREG_BSR:
+	case APBREG_PAER:
+	case APBREG_PWAC:
+	case APBREG_PRAC:
+	case APBREG_PCG:
+	case APBREG_PUR:
+	case APBREG_EMU_PCG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool sta2x11_apbreg_writeable_reg(struct device *dev, unsigned int reg)
+{
+	if (reg >= APBREG_BSR_SARAC)
+		reg -= APBREG_BSR_SARAC;
+	if (!sta2x11_apbreg_readable_reg(dev, reg))
+		return false;
+	return reg != APBREG_PAER;
+}
+
+static struct regmap_config sta2x11_apbreg_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.lock = sta2x11_regmap_lock,
+	.unlock = sta2x11_regmap_unlock,
+	.max_register = APBREG_EMU_PCG_SARAC,
+	.readable_reg = sta2x11_apbreg_readable_reg,
+	.writeable_reg = sta2x11_apbreg_writeable_reg,
 };
 
+static bool sta2x11_apb_soc_regs_readable_reg(struct device *dev,
+					      unsigned int reg)
+{
+	return reg <= PCIE_SoC_INT_ROUTER_STATUS3_REG ||
+		__reg_within_range(reg, DMA_IP_CTRL_REG, SPARE3_RESERVED) ||
+		__reg_within_range(reg, MASTER_LOCK_REG,
+				   SYSTEM_CONFIG_STATUS_REG) ||
+		reg == MSP_CLK_CTRL_REG ||
+		__reg_within_range(reg, COMPENSATION_REG1, TEST_CTL_REG);
+}
 
-static struct dentry *sta2x11_mfd_debugfs[sta2x11_n_mfd_plat_devs];
+static bool sta2x11_apb_soc_regs_writeable_reg(struct device *dev,
+					       unsigned int reg)
+{
+	if (!sta2x11_apb_soc_regs_readable_reg(dev, reg))
+		return false;
+	switch (reg) {
+	case PCIE_COMMON_CLOCK_CONFIG_0_4_0:
+	case SYSTEM_CONFIG_STATUS_REG:
+	case COMPENSATION_REG1:
+	case PCIE_SoC_INT_ROUTER_STATUS0_REG...PCIE_SoC_INT_ROUTER_STATUS3_REG:
+	case PCIE_PM_STATUS_0_PORT_0_4...PCIE_PM_STATUS_7_0_EP4:
+		return false;
+	default:
+		return true;
+	}
+}
 
-static struct debugfs_regset32 *sta2x11_mfd_regset[sta2x11_n_mfd_plat_devs] = {
-	[sta2x11_sctl] = &sctl_regset,
-	[sta2x11_apbreg] = &apbreg_regset,
-	[sta2x11_apb_soc_regs] = &apb_soc_regs_regset,
+static struct regmap_config sta2x11_apb_soc_regs_regmap_config = {
+	.reg_bits = 32,
+	.reg_stride = 4,
+	.val_bits = 32,
+	.lock = sta2x11_regmap_lock,
+	.unlock = sta2x11_regmap_unlock,
+	.max_register = TEST_CTL_REG,
+	.readable_reg = sta2x11_apb_soc_regs_readable_reg,
+	.writeable_reg = sta2x11_apb_soc_regs_writeable_reg,
 };
 
-static const char *sta2x11_mfd_names[sta2x11_n_mfd_plat_devs] = {
-	[sta2x11_sctl] = "sta2x11-sctl",
-	[sta2x11_apbreg] = "sta2x11-apbreg",
-	[sta2x11_apb_soc_regs] = "sta2x11-apb-soc-regs",
+static struct regmap_config *
+sta2x11_mfd_regmap_configs[sta2x11_n_mfd_plat_devs] = {
+	[sta2x11_sctl] = &sta2x11_sctl_regmap_config,
+	[sta2x11_apbreg] = &sta2x11_apbreg_regmap_config,
+	[sta2x11_apb_soc_regs] = &sta2x11_apb_soc_regs_regmap_config,
 };
 
 /* Probe for the three platform devices */
@@ -250,12 +266,14 @@ static int sta2x11_mfd_platform_probe(struct platform_device *dev,
 	struct sta2x11_mfd *mfd;
 	struct resource *res;
 	const char *name = sta2x11_mfd_names[index];
-	struct debugfs_regset32 *regset = sta2x11_mfd_regset[index];
+	struct regmap_config *regmap_config = sta2x11_mfd_regmap_configs[index];
 
 	pdev = dev->dev.platform_data;
 	mfd = sta2x11_mfd_find(*pdev);
 	if (!mfd)
 		return -ENODEV;
+	if (!regmap_config)
+		return -ENODEV;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -269,10 +287,16 @@ static int sta2x11_mfd_platform_probe(struct platform_device *dev,
 		release_mem_region(res->start, resource_size(res));
 		return -ENOMEM;
 	}
-	regset->base = mfd->regs[index];
-	sta2x11_mfd_debugfs[index] = debugfs_create_regset32(name,
-							     S_IFREG | S_IRUGO,
-							     NULL, regset);
+	regmap_config->lock_arg = &mfd->lock;
+	/*
+	   No caching, registers could be reached both via regmap and via
+	   void __iomem *
+	*/
+	regmap_config->cache_type = REGCACHE_NONE;
+	mfd->regmap[index] = devm_regmap_init_mmio(&dev->dev, mfd->regs[index],
+						   regmap_config);
+	WARN_ON(!mfd->regmap[index]);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 4d85879..8334430 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -246,6 +246,7 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define SCTL_SCPEREN1		0x20	/* Peripheral clock enable register 1 */
 #define SCTL_SCPEREN2		0x24	/* Peripheral clock enable register 2 */
 #define SCTL_SCGRST		0x28	/* Peripheral global reset */
+#define SCTL_SCPCIECSBRST       0x2c    /* PCIe PAB CSB reset status register */
 #define SCTL_SCPCIPMCR1		0x30	/* PCI power management control 1 */
 #define SCTL_SCPCIPMCR2		0x34	/* PCI power management control 2 */
 #define SCTL_SCPCIPMSR1		0x38	/* PCI power management status 1 */
-- 
1.7.10.4

