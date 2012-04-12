Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216Ab2DLItD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:49:03 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63772 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab2DLIs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:48:56 -0400
Date: Thu, 12 Apr 2012 10:48:44 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
Subject: [PATCH V3 1/2] mfd: Add driver for STA2X11 MFD block
Message-ID: <99e873520a5e9278abfaaf9fbd514bab2c326479.1334219874.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1334219873.git.rubini@gnudd.com>
In-Reply-To: <cover.1334219873.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also introduces <asm/sta2x11.h> to export a function that is in
the base sta2x11 support patches. The header will increase with other
prototypes and constants over time.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 arch/x86/include/asm/sta2x11.h  |   12 +
 drivers/mfd/Kconfig             |    6 +
 drivers/mfd/Makefile            |    1 +
 drivers/mfd/sta2x11-mfd.c       |  467 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/sta2x11-mfd.h |  324 +++++++++++++++++++++++++++
 5 files changed, 810 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/sta2x11.h
 create mode 100644 drivers/mfd/sta2x11-mfd.c
 create mode 100644 include/linux/mfd/sta2x11-mfd.h

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
new file mode 100644
index 0000000..e9d32df
--- /dev/null
+++ b/arch/x86/include/asm/sta2x11.h
@@ -0,0 +1,12 @@
+/*
+ * Header file for STMicroelectronics ConneXt (STA2X11) IOHub
+ */
+#ifndef __ASM_STA2X11_H
+#define __ASM_STA2X11_H
+
+#include <linux/pci.h>
+
+/* This needs to be called from the MFD to configure its sub-devices */
+struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev);
+
+#endif /* __ASM_STA2X11_H */
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..c194c67 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -873,6 +873,12 @@ config MFD_RC5T583
 	  Additional drivers must be enabled in order to use the
 	  different functionality of the device.
 
+config MFD_STA2X11
+	bool "STA2X11 multi function device support"
+	depends on STA2X11
+	select MFD_CORE
+	select GPIO_STA2X11
+
 config MFD_ANATOP
 	bool "Support for Freescale i.MX on-chip ANATOP controller"
 	depends on SOC_IMX6Q
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 05fa538..7cd8f02 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 obj-$(CONFIG_MFD_TI_SSP)	+= ti-ssp.o
 
+obj-$(CONFIG_MFD_STA2X11)	+= sta2x11-mfd.o
 obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
 obj-$(CONFIG_STMPE_I2C)		+= stmpe-i2c.o
 obj-$(CONFIG_STMPE_SPI)		+= stmpe-spi.o
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
new file mode 100644
index 0000000..14a79e6
--- /dev/null
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (c) 2009-2011 Wind River Systems, Inc.
+ * Copyright (c) 2011 ST Microelectronics (Alessandro Rubini)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/pci.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sta2x11-mfd.h>
+
+#include <asm/sta2x11.h>
+
+/* This describes STA2X11 MFD chip for us, we may have several */
+struct sta2x11_mfd {
+	struct sta2x11_instance *instance;
+	spinlock_t lock;
+	struct list_head list;
+	void __iomem *sctl_regs;
+	void __iomem *apbreg_regs;
+};
+
+static LIST_HEAD(sta2x11_mfd_list);
+
+/* Three functions to act on the list */
+static struct sta2x11_mfd *sta2x11_mfd_find(struct pci_dev *pdev)
+{
+	struct sta2x11_instance *instance;
+	struct sta2x11_mfd *mfd;
+
+	if (!pdev && !list_empty(&sta2x11_mfd_list)) {
+		pr_warning("%s: Unspecified device, "
+			    "using first instance\n", __func__);
+		return list_entry(sta2x11_mfd_list.next,
+				  struct sta2x11_mfd, list);
+	}
+
+	instance = sta2x11_get_instance(pdev);
+	if (!instance)
+		return NULL;
+	list_for_each_entry(mfd, &sta2x11_mfd_list, list) {
+		if (mfd->instance == instance)
+			return mfd;
+	}
+	return NULL;
+}
+
+static int __devinit sta2x11_mfd_add(struct pci_dev *pdev, gfp_t flags)
+{
+	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
+	struct sta2x11_instance *instance;
+
+	if (mfd)
+		return -EBUSY;
+	instance = sta2x11_get_instance(pdev);
+	if (!instance)
+		return -EINVAL;
+	mfd = kzalloc(sizeof(*mfd), flags);
+	if (!mfd)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&mfd->list);
+	spin_lock_init(&mfd->lock);
+	mfd->instance = instance;
+	list_add(&mfd->list, &sta2x11_mfd_list);
+	return 0;
+}
+
+static int __devexit mfd_remove(struct pci_dev *pdev)
+{
+	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
+
+	if (!mfd)
+		return -ENODEV;
+	list_del(&mfd->list);
+	kfree(mfd);
+	return 0;
+}
+
+/* These two functions are exported and are not expected to fail */
+u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
+	u32 r;
+	unsigned long flags;
+
+	if (!mfd) {
+		dev_warn(&pdev->dev, ": can't access sctl regs\n");
+		return 0;
+	}
+	if (!mfd->sctl_regs) {
+		dev_warn(&pdev->dev, ": system ctl not initialized\n");
+		return 0;
+	}
+	spin_lock_irqsave(&mfd->lock, flags);
+	r = readl(mfd->sctl_regs + reg);
+	r &= ~mask;
+	r |= val;
+	if (mask)
+		writel(r, mfd->sctl_regs + reg);
+	spin_unlock_irqrestore(&mfd->lock, flags);
+	return r;
+}
+EXPORT_SYMBOL(sta2x11_sctl_mask);
+
+u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
+	u32 r;
+	unsigned long flags;
+
+	if (!mfd) {
+		dev_warn(&pdev->dev, ": can't access apb regs\n");
+		return 0;
+	}
+	if (!mfd->apbreg_regs) {
+		dev_warn(&pdev->dev, ": apb bridge not initialized\n");
+		return 0;
+	}
+	spin_lock_irqsave(&mfd->lock, flags);
+	r = readl(mfd->apbreg_regs + reg);
+	r &= ~mask;
+	r |= val;
+	if (mask)
+		writel(r, mfd->apbreg_regs + reg);
+	spin_unlock_irqrestore(&mfd->lock, flags);
+	return r;
+}
+EXPORT_SYMBOL(sta2x11_apbreg_mask);
+
+/* Two debugfs files, for our registers (FIXME: one instance only) */
+#define REG(regname) {.name = #regname, .offset = SCTL_ ## regname}
+static struct debugfs_reg32 sta2x11_sctl_regs[] = {
+	REG(SCCTL), REG(ARMCFG), REG(SCPLLCTL), REG(SCPLLFCTRL),
+	REG(SCRESFRACT), REG(SCRESCTRL1), REG(SCRESXTRL2), REG(SCPEREN0),
+	REG(SCPEREN1), REG(SCPEREN2), REG(SCGRST), REG(SCPCIPMCR1),
+	REG(SCPCIPMCR2), REG(SCPCIPMSR1), REG(SCPCIPMSR2), REG(SCPCIPMSR3),
+	REG(SCINTREN), REG(SCRISR), REG(SCCLKSTAT0), REG(SCCLKSTAT1),
+	REG(SCCLKSTAT2), REG(SCRSTSTA),
+};
+#undef REG
+
+static struct debugfs_regset32 sctl_regset = {
+	.regs = sta2x11_sctl_regs,
+	.nregs = ARRAY_SIZE(sta2x11_sctl_regs),
+};
+
+#define REG(regname) {.name = #regname, .offset = regname}
+static struct debugfs_reg32 sta2x11_apbreg_regs[] = {
+	REG(APBREG_BSR), REG(APBREG_PAER), REG(APBREG_PWAC), REG(APBREG_PRAC),
+	REG(APBREG_PCG), REG(APBREG_PUR), REG(APBREG_EMU_PCG),
+};
+#undef REG
+
+static struct debugfs_regset32 apbreg_regset = {
+	.regs = sta2x11_apbreg_regs,
+	.nregs = ARRAY_SIZE(sta2x11_apbreg_regs),
+};
+
+static struct dentry *sta2x11_sctl_debugfs;
+static struct dentry *sta2x11_apbreg_debugfs;
+
+/* Probe for the two platform devices */
+static int sta2x11_sctl_probe(struct platform_device *dev)
+{
+	struct pci_dev **pdev;
+	struct sta2x11_mfd *mfd;
+	struct resource *res;
+
+	pdev = dev->dev.platform_data;
+	mfd = sta2x11_mfd_find(*pdev);
+	if (!mfd)
+		return -ENODEV;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOMEM;
+
+	if (!request_mem_region(res->start, resource_size(res),
+				"sta2x11-sctl"))
+		return -EBUSY;
+
+	mfd->sctl_regs = ioremap(res->start, resource_size(res));
+	if (!mfd->sctl_regs) {
+		release_mem_region(res->start, resource_size(res));
+		return -ENOMEM;
+	}
+	sctl_regset.base = mfd->sctl_regs;
+	sta2x11_sctl_debugfs = debugfs_create_regset32("sta2x11-sctl",
+						  S_IFREG | S_IRUGO,
+						  NULL, &sctl_regset);
+	return 0;
+}
+
+static int sta2x11_apbreg_probe(struct platform_device *dev)
+{
+	struct pci_dev **pdev;
+	struct sta2x11_mfd *mfd;
+	struct resource *res;
+
+	pdev = dev->dev.platform_data;
+	dev_dbg(&dev->dev, "%s: pdata is %p\n", __func__, pdev);
+	dev_dbg(&dev->dev, "%s: *pdata is %p\n", __func__, *pdev);
+
+	mfd = sta2x11_mfd_find(*pdev);
+	if (!mfd)
+		return -ENODEV;
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOMEM;
+
+	if (!request_mem_region(res->start, resource_size(res),
+				"sta2x11-apbreg"))
+		return -EBUSY;
+
+	mfd->apbreg_regs = ioremap(res->start, resource_size(res));
+	if (!mfd->apbreg_regs) {
+		release_mem_region(res->start, resource_size(res));
+		return -ENOMEM;
+	}
+	dev_dbg(&dev->dev, "%s: regbase %p\n", __func__, mfd->apbreg_regs);
+
+	apbreg_regset.base = mfd->apbreg_regs;
+	sta2x11_apbreg_debugfs = debugfs_create_regset32("sta2x11-apbreg",
+						  S_IFREG | S_IRUGO,
+						  NULL, &apbreg_regset);
+	return 0;
+}
+
+/* The two platform drivers */
+static struct platform_driver sta2x11_sctl_platform_driver = {
+	.driver = {
+		.name	= "sta2x11-sctl",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sta2x11_sctl_probe,
+};
+
+static int __init sta2x11_sctl_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&sta2x11_sctl_platform_driver);
+}
+
+static struct platform_driver sta2x11_platform_driver = {
+	.driver = {
+		.name	= "sta2x11-apbreg",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sta2x11_apbreg_probe,
+};
+
+static int __init sta2x11_apbreg_init(void)
+{
+	pr_info("%s\n", __func__);
+	return platform_driver_register(&sta2x11_platform_driver);
+}
+
+/*
+ * What follows is the PCI device that hosts the above two pdevs.
+ * Each logic block is 4kB and they are all consecutive: we use this info.
+ */
+
+/* Bar 0 */
+enum bar0_cells {
+	GPIO_0 = 0,
+	GPIO_1,
+	GPIO_2,
+	GPIO_3,
+	SCTL,
+	SCR,
+	TIME,
+};
+/* Bar 1 */
+enum bar1_cells {
+	APBREG = 0,
+};
+#define CELL_4K(_name, _cell) { \
+		.name = _name, \
+		.start = _cell * 4096, .end = _cell * 4096 + 4095, \
+		.flags = IORESOURCE_MEM, \
+		}
+
+static const __devinitconst struct resource gpio_resources[] = {
+	{
+		.name = "sta2x11_gpio", /* 4 consecutive cells, 1 driver */
+		.start = 0,
+		.end = (4 * 4096) - 1,
+		.flags = IORESOURCE_MEM,
+	}
+};
+static const __devinitconst struct resource sctl_resources[] = {
+	CELL_4K("sta2x11-sctl", SCTL),
+};
+static const __devinitconst struct resource scr_resources[] = {
+	CELL_4K("sta2x11-scr", SCR),
+};
+static const __devinitconst struct resource time_resources[] = {
+	CELL_4K("sta2x11-time", TIME),
+};
+
+static const __devinitconst struct resource apbreg_resources[] = {
+	CELL_4K("sta2x11-apbreg", APBREG),
+};
+
+#define DEV(_name, _r) \
+	{ .name = _name, .num_resources = ARRAY_SIZE(_r), .resources = _r, }
+
+static __devinitdata struct mfd_cell sta2x11_mfd_bar0[] = {
+	DEV("sta2x11-gpio", gpio_resources), /* offset 0: we add pdata later */
+	DEV("sta2x11-sctl", sctl_resources),
+	DEV("sta2x11-scr", scr_resources),
+	DEV("sta2x11-time", time_resources),
+};
+
+static __devinitdata struct mfd_cell sta2x11_mfd_bar1[] = {
+	DEV("sta2x11-apbreg", apbreg_resources),
+};
+
+static int sta2x11_mfd_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static int sta2x11_mfd_resume(struct pci_dev *pdev)
+{
+	int err;
+
+	pci_set_power_state(pdev, 0);
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+	pci_restore_state(pdev);
+
+	return 0;
+}
+
+static int __devinit sta2x11_mfd_probe(struct pci_dev *pdev,
+				       const struct pci_device_id *pci_id)
+{
+	int err, i;
+	struct sta2x11_gpio_pdata *gpio_data;
+
+	dev_info(&pdev->dev, "%s\n", __func__);
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "Can't enable device.\n");
+		return err;
+	}
+
+	err = pci_enable_msi(pdev);
+	if (err)
+		dev_info(&pdev->dev, "Enable msi failed\n");
+
+	/* Read gpio config data as pci device's platform data */
+	gpio_data = dev_get_platdata(&pdev->dev);
+	if (!gpio_data)
+		dev_warn(&pdev->dev, "no gpio configuration\n");
+
+	dev_dbg(&pdev->dev, "%s, gpio_data = %p (%p)\n", __func__,
+		gpio_data, &gpio_data);
+	dev_dbg(&pdev->dev, "%s, pdev = %p (%p)\n", __func__,
+		pdev, &pdev);
+
+	/* platform data is the pci device for all of them */
+	for (i = 0; i < ARRAY_SIZE(sta2x11_mfd_bar0); i++) {
+		sta2x11_mfd_bar0[i].pdata_size = sizeof(pdev);
+		sta2x11_mfd_bar0[i].platform_data = &pdev;
+	}
+	sta2x11_mfd_bar1[0].pdata_size = sizeof(pdev);
+	sta2x11_mfd_bar1[0].platform_data = &pdev;
+
+	/* Record this pdev before mfd_add_devices: their probe looks for it */
+	sta2x11_mfd_add(pdev, GFP_ATOMIC);
+
+
+	err = mfd_add_devices(&pdev->dev, -1,
+			      sta2x11_mfd_bar0,
+			      ARRAY_SIZE(sta2x11_mfd_bar0),
+			      &pdev->resource[0],
+			      0);
+	if (err) {
+		dev_err(&pdev->dev, "mfd_add_devices[0] failed: %d\n", err);
+		goto err_disable;
+	}
+
+	err = mfd_add_devices(&pdev->dev, -1,
+			      sta2x11_mfd_bar1,
+			      ARRAY_SIZE(sta2x11_mfd_bar1),
+			      &pdev->resource[1],
+			      0);
+	if (err) {
+		dev_err(&pdev->dev, "mfd_add_devices[1] failed: %d\n", err);
+		goto err_disable;
+	}
+
+	return 0;
+
+err_disable:
+	mfd_remove_devices(&pdev->dev);
+	pci_disable_device(pdev);
+	pci_disable_msi(pdev);
+	return err;
+}
+
+static DEFINE_PCI_DEVICE_TABLE(sta2x11_mfd_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
+	{0,},
+};
+
+static struct pci_driver sta2x11_mfd_driver = {
+	.name =		"sta2x11-mfd",
+	.id_table =	sta2x11_mfd_tbl,
+	.probe =	sta2x11_mfd_probe,
+	.suspend =	sta2x11_mfd_suspend,
+	.resume =	sta2x11_mfd_resume,
+};
+
+static int __init sta2x11_mfd_init(void)
+{
+	pr_info("%s\n", __func__);
+	return pci_register_driver(&sta2x11_mfd_driver);
+}
+
+/*
+ * All of this must be ready before "normal" devices like MMCI appear.
+ * But MFD (the pci device) can't be too early. The following choice
+ * prepares platform drivers very early and probe the PCI device later,
+ * but before other PCI devices.
+ */
+subsys_initcall(sta2x11_apbreg_init);
+subsys_initcall(sta2x11_sctl_init);
+rootfs_initcall(sta2x11_mfd_init);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Wind River");
+MODULE_DESCRIPTION("STA2x11 mfd for GPIO, SCTL and APBREG");
+MODULE_DEVICE_TABLE(pci, sta2x11_mfd_tbl);
diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
new file mode 100644
index 0000000..d179227
--- /dev/null
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -0,0 +1,324 @@
+/*
+ * Copyright (c) 2009-2011 Wind River Systems, Inc.
+ * Copyright (c) 2011 ST Microelectronics (Alessandro Rubini)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * The STMicroelectronics ConneXt (STA2X11) chip has several unrelated
+ * functions in one PCI endpoint functions. This driver simply
+ * registers the platform devices in this iomemregion and exports a few
+ * functions to access common registers
+ */
+
+#ifndef __STA2X11_MFD_H
+#define __STA2X11_MFD_H
+#include <linux/types.h>
+#include <linux/pci.h>
+
+/*
+ * The MFD PCI block includes the GPIO peripherals and other register blocks.
+ * For GPIO, we have 32*4 bits (I use "gsta" for "gpio sta2x11".)
+ */
+#define GSTA_GPIO_PER_BLOCK	32
+#define GSTA_NR_BLOCKS		4
+#define GSTA_NR_GPIO		(GSTA_GPIO_PER_BLOCK * GSTA_NR_BLOCKS)
+
+/* Pinconfig is set by the board definition: altfunc, pull-up, pull-down */
+struct sta2x11_gpio_pdata {
+	unsigned pinconfig[GSTA_NR_GPIO];
+};
+
+/* Macros below lifted from sh_pfc.h, with minor differences */
+#define PINMUX_TYPE_NONE		0
+#define PINMUX_TYPE_FUNCTION		1
+#define PINMUX_TYPE_OUTPUT_LOW		2
+#define PINMUX_TYPE_OUTPUT_HIGH		3
+#define PINMUX_TYPE_INPUT		4
+#define PINMUX_TYPE_INPUT_PULLUP	5
+#define PINMUX_TYPE_INPUT_PULLDOWN	6
+
+/* Give names to GPIO pins, like PXA does, taken from the manual */
+#define STA2X11_GPIO0			0
+#define STA2X11_GPIO1			1
+#define STA2X11_GPIO2			2
+#define STA2X11_GPIO3			3
+#define STA2X11_GPIO4			4
+#define STA2X11_GPIO5			5
+#define STA2X11_GPIO6			6
+#define STA2X11_GPIO7			7
+#define STA2X11_GPIO8_RGBOUT_RED7	8
+#define STA2X11_GPIO9_RGBOUT_RED6	9
+#define STA2X11_GPIO10_RGBOUT_RED5	10
+#define STA2X11_GPIO11_RGBOUT_RED4	11
+#define STA2X11_GPIO12_RGBOUT_RED3	12
+#define STA2X11_GPIO13_RGBOUT_RED2	13
+#define STA2X11_GPIO14_RGBOUT_RED1	14
+#define STA2X11_GPIO15_RGBOUT_RED0	15
+#define STA2X11_GPIO16_RGBOUT_GREEN7	16
+#define STA2X11_GPIO17_RGBOUT_GREEN6	17
+#define STA2X11_GPIO18_RGBOUT_GREEN5	18
+#define STA2X11_GPIO19_RGBOUT_GREEN4	19
+#define STA2X11_GPIO20_RGBOUT_GREEN3	20
+#define STA2X11_GPIO21_RGBOUT_GREEN2	21
+#define STA2X11_GPIO22_RGBOUT_GREEN1	22
+#define STA2X11_GPIO23_RGBOUT_GREEN0	23
+#define STA2X11_GPIO24_RGBOUT_BLUE7	24
+#define STA2X11_GPIO25_RGBOUT_BLUE6	25
+#define STA2X11_GPIO26_RGBOUT_BLUE5	26
+#define STA2X11_GPIO27_RGBOUT_BLUE4	27
+#define STA2X11_GPIO28_RGBOUT_BLUE3	28
+#define STA2X11_GPIO29_RGBOUT_BLUE2	29
+#define STA2X11_GPIO30_RGBOUT_BLUE1	30
+#define STA2X11_GPIO31_RGBOUT_BLUE0	31
+#define STA2X11_GPIO32_RGBOUT_VSYNCH	32
+#define STA2X11_GPIO33_RGBOUT_HSYNCH	33
+#define STA2X11_GPIO34_RGBOUT_DEN	34
+#define STA2X11_GPIO35_ETH_CRS_DV	35
+#define STA2X11_GPIO36_ETH_TXD1		36
+#define STA2X11_GPIO37_ETH_TXD0		37
+#define STA2X11_GPIO38_ETH_TX_EN	38
+#define STA2X11_GPIO39_MDIO		39
+#define STA2X11_GPIO40_ETH_REF_CLK	40
+#define STA2X11_GPIO41_ETH_RXD1		41
+#define STA2X11_GPIO42_ETH_RXD0		42
+#define STA2X11_GPIO43_MDC		43
+#define STA2X11_GPIO44_CAN_TX		44
+#define STA2X11_GPIO45_CAN_RX		45
+#define STA2X11_GPIO46_MLB_DAT		46
+#define STA2X11_GPIO47_MLB_SIG		47
+#define STA2X11_GPIO48_SPI0_CLK		48
+#define STA2X11_GPIO49_SPI0_TXD		49
+#define STA2X11_GPIO50_SPI0_RXD		50
+#define STA2X11_GPIO51_SPI0_FRM		51
+#define STA2X11_GPIO52_SPI1_CLK		52
+#define STA2X11_GPIO53_SPI1_TXD		53
+#define STA2X11_GPIO54_SPI1_RXD		54
+#define STA2X11_GPIO55_SPI1_FRM		55
+#define STA2X11_GPIO56_SPI2_CLK		56
+#define STA2X11_GPIO57_SPI2_TXD		57
+#define STA2X11_GPIO58_SPI2_RXD		58
+#define STA2X11_GPIO59_SPI2_FRM		59
+#define STA2X11_GPIO60_I2C0_SCL		60
+#define STA2X11_GPIO61_I2C0_SDA		61
+#define STA2X11_GPIO62_I2C1_SCL		62
+#define STA2X11_GPIO63_I2C1_SDA		63
+#define STA2X11_GPIO64_I2C2_SCL		64
+#define STA2X11_GPIO65_I2C2_SDA		65
+#define STA2X11_GPIO66_I2C3_SCL		66
+#define STA2X11_GPIO67_I2C3_SDA		67
+#define STA2X11_GPIO68_MSP0_RCK		68
+#define STA2X11_GPIO69_MSP0_RXD		69
+#define STA2X11_GPIO70_MSP0_RFS		70
+#define STA2X11_GPIO71_MSP0_TCK		71
+#define STA2X11_GPIO72_MSP0_TXD		72
+#define STA2X11_GPIO73_MSP0_TFS		73
+#define STA2X11_GPIO74_MSP0_SCK		74
+#define STA2X11_GPIO75_MSP1_CK		75
+#define STA2X11_GPIO76_MSP1_RXD		76
+#define STA2X11_GPIO77_MSP1_FS		77
+#define STA2X11_GPIO78_MSP1_TXD		78
+#define STA2X11_GPIO79_MSP2_CK		79
+#define STA2X11_GPIO80_MSP2_RXD		80
+#define STA2X11_GPIO81_MSP2_FS		81
+#define STA2X11_GPIO82_MSP2_TXD		82
+#define STA2X11_GPIO83_MSP3_CK		83
+#define STA2X11_GPIO84_MSP3_RXD		84
+#define STA2X11_GPIO85_MSP3_FS		85
+#define STA2X11_GPIO86_MSP3_TXD		86
+#define STA2X11_GPIO87_MSP4_CK		87
+#define STA2X11_GPIO88_MSP4_RXD		88
+#define STA2X11_GPIO89_MSP4_FS		89
+#define STA2X11_GPIO90_MSP4_TXD		90
+#define STA2X11_GPIO91_MSP5_CK		91
+#define STA2X11_GPIO92_MSP5_RXD		92
+#define STA2X11_GPIO93_MSP5_FS		93
+#define STA2X11_GPIO94_MSP5_TXD		94
+#define STA2X11_GPIO95_SDIO3_DAT3	95
+#define STA2X11_GPIO96_SDIO3_DAT2	96
+#define STA2X11_GPIO97_SDIO3_DAT1	97
+#define STA2X11_GPIO98_SDIO3_DAT0	98
+#define STA2X11_GPIO99_SDIO3_CLK	99
+#define STA2X11_GPIO100_SDIO3_CMD	100
+#define STA2X11_GPIO101			101
+#define STA2X11_GPIO102			102
+#define STA2X11_GPIO103			103
+#define STA2X11_GPIO104			104
+#define STA2X11_GPIO105_SDIO2_DAT3	105
+#define STA2X11_GPIO106_SDIO2_DAT2	106
+#define STA2X11_GPIO107_SDIO2_DAT1	107
+#define STA2X11_GPIO108_SDIO2_DAT0	108
+#define STA2X11_GPIO109_SDIO2_CLK	109
+#define STA2X11_GPIO110_SDIO2_CMD	110
+#define STA2X11_GPIO111			111
+#define STA2X11_GPIO112			112
+#define STA2X11_GPIO113			113
+#define STA2X11_GPIO114			114
+#define STA2X11_GPIO115_SDIO1_DAT3	115
+#define STA2X11_GPIO116_SDIO1_DAT2	116
+#define STA2X11_GPIO117_SDIO1_DAT1	117
+#define STA2X11_GPIO118_SDIO1_DAT0	118
+#define STA2X11_GPIO119_SDIO1_CLK	119
+#define STA2X11_GPIO120_SDIO1_CMD	120
+#define STA2X11_GPIO121			121
+#define STA2X11_GPIO122			122
+#define STA2X11_GPIO123			123
+#define STA2X11_GPIO124			124
+#define STA2X11_GPIO125_UART2_TXD	125
+#define STA2X11_GPIO126_UART2_RXD	126
+#define STA2X11_GPIO127_UART3_TXD	127
+
+/*
+ * The APB bridge has its own registers, needed by our users as well.
+ * They are accessed with the following read/mask/write function.
+ */
+u32 sta2x11_apbreg_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
+
+/* CAN and MLB */
+#define APBREG_BSR	0x00	/* Bridge Status Reg */
+#define APBREG_PAER	0x08	/* Peripherals Address Error Reg */
+#define APBREG_PWAC	0x20	/* Peripheral Write Access Control reg */
+#define APBREG_PRAC	0x40	/* Peripheral Read Access Control reg */
+#define APBREG_PCG	0x60	/* Peripheral Clock Gating Reg */
+#define APBREG_PUR	0x80	/* Peripheral Under Reset Reg */
+#define APBREG_EMU_PCG	0xA0	/* Emulator Peripheral Clock Gating Reg */
+
+#define APBREG_CAN	(1 << 1)
+#define APBREG_MLB	(1 << 3)
+
+/* SARAC */
+#define APBREG_BSR_SARAC     0x100 /* Bridge Status Reg */
+#define APBREG_PAER_SARAC    0x108 /* Peripherals Address Error Reg */
+#define APBREG_PWAC_SARAC    0x120 /* Peripheral Write Access Control reg */
+#define APBREG_PRAC_SARAC    0x140 /* Peripheral Read Access Control reg */
+#define APBREG_PCG_SARAC     0x160 /* Peripheral Clock Gating Reg */
+#define APBREG_PUR_SARAC     0x180 /* Peripheral Under Reset Reg */
+#define APBREG_EMU_PCG_SARAC 0x1A0 /* Emulator Peripheral Clock Gating Reg */
+
+#define APBREG_SARAC	(1 << 2)
+
+/*
+ * The system controller has its own registers. Some of these are accessed
+ * by out users as well, using the following read/mask/write/function
+ */
+u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val);
+
+#define SCTL_SCCTL		0x00	/* System controller control register */
+#define SCTL_ARMCFG		0x04	/* ARM configuration register */
+#define SCTL_SCPLLCTL		0x08	/* PLL control status register */
+#define SCTL_SCPLLFCTRL		0x0c	/* PLL frequency control register */
+#define SCTL_SCRESFRACT		0x10	/* PLL fractional input register */
+#define SCTL_SCRESCTRL1		0x14	/* Peripheral reset control 1 */
+#define SCTL_SCRESXTRL2		0x18	/* Peripheral reset control 2 */
+#define SCTL_SCPEREN0		0x1c	/* Peripheral clock enable register 0 */
+#define SCTL_SCPEREN1		0x20	/* Peripheral clock enable register 1 */
+#define SCTL_SCPEREN2		0x24	/* Peripheral clock enable register 2 */
+#define SCTL_SCGRST		0x28	/* Peripheral global reset */
+#define SCTL_SCPCIPMCR1		0x30	/* PCI power management control 1 */
+#define SCTL_SCPCIPMCR2		0x34	/* PCI power management control 2 */
+#define SCTL_SCPCIPMSR1		0x38	/* PCI power management status 1 */
+#define SCTL_SCPCIPMSR2		0x3c	/* PCI power management status 2 */
+#define SCTL_SCPCIPMSR3		0x40	/* PCI power management status 3 */
+#define SCTL_SCINTREN		0x44	/* Interrupt enable */
+#define SCTL_SCRISR		0x48	/* RAW interrupt status */
+#define SCTL_SCCLKSTAT0		0x4c	/* Peripheral clocks status 0 */
+#define SCTL_SCCLKSTAT1		0x50	/* Peripheral clocks status 1 */
+#define SCTL_SCCLKSTAT2		0x54	/* Peripheral clocks status 2 */
+#define SCTL_SCRSTSTA		0x58	/* Reset status register */
+
+#define SCTL_SCRESCTRL1_USB_PHY_POR	(1 << 0)
+#define SCTL_SCRESCTRL1_USB_OTG	(1 << 1)
+#define SCTL_SCRESCTRL1_USB_HRST	(1 << 2)
+#define SCTL_SCRESCTRL1_USB_PHY_HOST	(1 << 3)
+#define SCTL_SCRESCTRL1_SATAII	(1 << 4)
+#define SCTL_SCRESCTRL1_VIP		(1 << 5)
+#define SCTL_SCRESCTRL1_PER_MMC0	(1 << 6)
+#define SCTL_SCRESCTRL1_PER_MMC1	(1 << 7)
+#define SCTL_SCRESCTRL1_PER_GPIO0	(1 << 8)
+#define SCTL_SCRESCTRL1_PER_GPIO1	(1 << 9)
+#define SCTL_SCRESCTRL1_PER_GPIO2	(1 << 10)
+#define SCTL_SCRESCTRL1_PER_GPIO3	(1 << 11)
+#define SCTL_SCRESCTRL1_PER_MTU0	(1 << 12)
+#define SCTL_SCRESCTRL1_KER_SPI0	(1 << 13)
+#define SCTL_SCRESCTRL1_KER_SPI1	(1 << 14)
+#define SCTL_SCRESCTRL1_KER_SPI2	(1 << 15)
+#define SCTL_SCRESCTRL1_KER_MCI0	(1 << 16)
+#define SCTL_SCRESCTRL1_KER_MCI1	(1 << 17)
+#define SCTL_SCRESCTRL1_PRE_HSI2C0	(1 << 18)
+#define SCTL_SCRESCTRL1_PER_HSI2C1	(1 << 19)
+#define SCTL_SCRESCTRL1_PER_HSI2C2	(1 << 20)
+#define SCTL_SCRESCTRL1_PER_HSI2C3	(1 << 21)
+#define SCTL_SCRESCTRL1_PER_MSP0	(1 << 22)
+#define SCTL_SCRESCTRL1_PER_MSP1	(1 << 23)
+#define SCTL_SCRESCTRL1_PER_MSP2	(1 << 24)
+#define SCTL_SCRESCTRL1_PER_MSP3	(1 << 25)
+#define SCTL_SCRESCTRL1_PER_MSP4	(1 << 26)
+#define SCTL_SCRESCTRL1_PER_MSP5	(1 << 27)
+#define SCTL_SCRESCTRL1_PER_MMC	(1 << 28)
+#define SCTL_SCRESCTRL1_KER_MSP0	(1 << 29)
+#define SCTL_SCRESCTRL1_KER_MSP1	(1 << 30)
+#define SCTL_SCRESCTRL1_KER_MSP2	(1 << 31)
+
+#define SCTL_SCPEREN0_UART0		(1 << 0)
+#define SCTL_SCPEREN0_UART1		(1 << 1)
+#define SCTL_SCPEREN0_UART2		(1 << 2)
+#define SCTL_SCPEREN0_UART3		(1 << 3)
+#define SCTL_SCPEREN0_MSP0		(1 << 4)
+#define SCTL_SCPEREN0_MSP1		(1 << 5)
+#define SCTL_SCPEREN0_MSP2		(1 << 6)
+#define SCTL_SCPEREN0_MSP3		(1 << 7)
+#define SCTL_SCPEREN0_MSP4		(1 << 8)
+#define SCTL_SCPEREN0_MSP5		(1 << 9)
+#define SCTL_SCPEREN0_SPI0		(1 << 10)
+#define SCTL_SCPEREN0_SPI1		(1 << 11)
+#define SCTL_SCPEREN0_SPI2		(1 << 12)
+#define SCTL_SCPEREN0_I2C0		(1 << 13)
+#define SCTL_SCPEREN0_I2C1		(1 << 14)
+#define SCTL_SCPEREN0_I2C2		(1 << 15)
+#define SCTL_SCPEREN0_I2C3		(1 << 16)
+#define SCTL_SCPEREN0_SVDO_LVDS		(1 << 17)
+#define SCTL_SCPEREN0_USB_HOST		(1 << 18)
+#define SCTL_SCPEREN0_USB_OTG		(1 << 19)
+#define SCTL_SCPEREN0_MCI0		(1 << 20)
+#define SCTL_SCPEREN0_MCI1		(1 << 21)
+#define SCTL_SCPEREN0_MCI2		(1 << 22)
+#define SCTL_SCPEREN0_MCI3		(1 << 23)
+#define SCTL_SCPEREN0_SATA		(1 << 24)
+#define SCTL_SCPEREN0_ETHERNET		(1 << 25)
+#define SCTL_SCPEREN0_VIC		(1 << 26)
+#define SCTL_SCPEREN0_DMA_AUDIO		(1 << 27)
+#define SCTL_SCPEREN0_DMA_SOC		(1 << 28)
+#define SCTL_SCPEREN0_RAM		(1 << 29)
+#define SCTL_SCPEREN0_VIP		(1 << 30)
+#define SCTL_SCPEREN0_ARM		(1 << 31)
+
+#define SCTL_SCPEREN1_UART0		(1 << 0)
+#define SCTL_SCPEREN1_UART1		(1 << 1)
+#define SCTL_SCPEREN1_UART2		(1 << 2)
+#define SCTL_SCPEREN1_UART3		(1 << 3)
+#define SCTL_SCPEREN1_MSP0		(1 << 4)
+#define SCTL_SCPEREN1_MSP1		(1 << 5)
+#define SCTL_SCPEREN1_MSP2		(1 << 6)
+#define SCTL_SCPEREN1_MSP3		(1 << 7)
+#define SCTL_SCPEREN1_MSP4		(1 << 8)
+#define SCTL_SCPEREN1_MSP5		(1 << 9)
+#define SCTL_SCPEREN1_SPI0		(1 << 10)
+#define SCTL_SCPEREN1_SPI1		(1 << 11)
+#define SCTL_SCPEREN1_SPI2		(1 << 12)
+#define SCTL_SCPEREN1_I2C0		(1 << 13)
+#define SCTL_SCPEREN1_I2C1		(1 << 14)
+#define SCTL_SCPEREN1_I2C2		(1 << 15)
+#define SCTL_SCPEREN1_I2C3		(1 << 16)
+#define SCTL_SCPEREN1_USB_PHY		(1 << 17)
+
+#endif /* __STA2X11_MFD_H */
-- 
1.7.7.2
