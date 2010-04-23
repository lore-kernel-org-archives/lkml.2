Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0DWFAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 01:00:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:57610 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab0DWFAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 01:00:01 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv8 2.6.34-rc5 4/5] mxc: Add generic USB HW initialization for MX51
Date: Thu, 22 Apr 2010 23:51:16 -0500
Message-Id: <1271998277-3949-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1271998277-3949-3-git-send-email-Dinh.Nguyen@freescale.com>
References: <1271998277-3949-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271998277-3949-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271998277-3949-3-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch adds USB HW initializiation code to /plat-mxc/ehci.c.
	-Stops and resets USB HW
	-Sets some specific PHY settings
	-Stop and restart the USB HW.
Renames mxc_set_usbcontrol to mxc_initialize_usb_hw.
The placing of the mxc_initialize_usb_hw needs to be before setting
the USBMODE register to host, since a reset and restart is done in
mxc_initialize_usb_hw.
Adds new register bit defines for the USB HW on Freescale
SoCs.

This patch applies to 2.6.34-rc5.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Reviewed-by: Daniel Mack <daniel@caiaq.de>
---
 arch/arm/plat-mxc/ehci.c                  |  170 ++++++++++++++++++++++++++++-
 arch/arm/plat-mxc/include/mach/mxc_ehci.h |   14 ++-
 drivers/usb/host/ehci-mxc.c               |   10 +-
 3 files changed, 186 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-mxc/ehci.c b/arch/arm/plat-mxc/ehci.c
index cb0b638..6b02c45 100644
--- a/arch/arm/plat-mxc/ehci.c
+++ b/arch/arm/plat-mxc/ehci.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ * Copyright (C) 2010 Freescale Semiconductor, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -18,6 +19,7 @@
 
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 
 #include <mach/hardware.h>
 #include <mach/mxc_ehci.h>
@@ -50,7 +52,50 @@
 #define MX35_H1_TLL_BIT		(1 << 5)
 #define MX35_H1_USBTE_BIT	(1 << 4)
 
-int mxc_set_usbcontrol(int port, unsigned int flags)
+#define MXC_OTG_OFFSET		0
+#define MXC_H1_OFFSET		0x200
+
+/* USB_CTRL */
+#define MXC_OTG_UCTRL_OWIE_BIT		(1 << 27)	/* OTG wakeup intr enable */
+#define MXC_OTG_UCTRL_OPM_BIT		(1 << 24)	/* OTG power mask */
+#define MXC_H1_UCTRL_H1UIE_BIT		(1 << 12)	/* Host1 ULPI interrupt enable */
+#define MXC_H1_UCTRL_H1WIE_BIT		(1 << 11)	/* HOST1 wakeup intr enable */
+#define MXC_H1_UCTRL_H1PM_BIT		(1 <<  8)		/* HOST1 power mask */
+
+/* USB_PHY_CTRL_FUNC */
+#define MXC_OTG_PHYCTRL_OC_DIS_BIT	(1 << 8)	/* OTG Disable Overcurrent Event */
+#define MXC_H1_OC_DIS_BIT			(1 << 5)	/* UH1 Disable Overcurrent Event */
+
+#define MXC_USBCMD_OFFSET			0x140
+
+/* USBCMD */
+#define MXC_UCMD_RUN_BIT		(1 << 0)	/* controller run/stop */
+#define MXC_UCMD_RESET_BIT		(1 << 1)	/* controller reset */
+#define MXC_UCMD_ITC_NO_THRESHOLD_MASK	(~(0xff << 16))	/* Interrupt Threshold Control */
+
+/* This function is a version of David Brownell's handshake function in
+ * ehci-hcd.c. This function uses cpu_relax instead of udelay().
+ *
+ * @addr: Address of register
+ * @mask: bits to look at in result of read
+ * @done: value of those bits when handshake succeeds
+ * @timeout: timeout in count
+ *
+ * This function waits for certain bits in the HW to stick before moving
+ * on and provides a timeout in the case where those bits do not stick.
+ */
+static inline int hw_handshake(u32 addr, u32 mask, int done, int timeout)
+{
+	while (--timeout && ((__raw_readl(addr) & mask) != done))
+			cpu_relax();
+
+	if (timeout)
+		return 0;
+	else
+		return -ETIMEDOUT;
+}
+
+int mxc_initialize_usb_hw(int port, unsigned int flags)
 {
 	unsigned int v;
 #ifdef CONFIG_ARCH_MX3
@@ -186,9 +231,130 @@ int mxc_set_usbcontrol(int port, unsigned int flags)
 		return 0;
 	}
 #endif /* CONFIG_MACH_MX27 */
+#ifdef CONFIG_ARCH_MX51
+	if (cpu_is_mx51()) {
+		void __iomem *usb_base;
+		u32 usbotg_base;
+		u32 usbother_base;
+		int ret = 0;
+
+		usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
+
+		switch (port) {
+		case 0:	/* OTG port */
+			usbotg_base = usb_base + MXC_OTG_OFFSET;
+			break;
+		case 1:	/* Host 1 port */
+			usbotg_base = usb_base + MXC_H1_OFFSET;
+			break;
+		default:
+			printk(KERN_ERR"%s no such port %d\n", __func__, port);
+			ret = -ENOENT;
+			goto error;
+		}
+		usbother_base = usb_base + MX5_USBOTHER_REGS_OFFSET;
+
+		/* Stop then Reset */
+		v = __raw_readl(usbotg_base + MXC_USBCMD_OFFSET);
+		v &= ~MXC_UCMD_RUN_BIT;
+		__raw_writel(v, usbotg_base + MXC_USBCMD_OFFSET);
+		ret = hw_handshake(usbotg_base + MXC_USBCMD_OFFSET, MXC_UCMD_RUN_BIT, 0, 500);
+		if (ret) {
+			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
+			goto error;
+		}
+
+		v = __raw_readl(usbotg_base + MXC_USBCMD_OFFSET);
+		v |= MXC_UCMD_RESET_BIT;
+		__raw_writel(v, usbotg_base + MXC_USBCMD_OFFSET);
+		ret = hw_handshake(usbotg_base + MXC_USBCMD_OFFSET, MXC_UCMD_RESET_BIT, 0, 500);
+		if (ret) {
+			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
+			goto error;
+		}
+
+		switch (port) {
+		case 0:	/*OTG port */
+			if (flags & MXC_EHCI_INTERNAL_PHY) {
+				v = __raw_readl(usbother_base + MXC_USB_PHY_CTR_FUNC_OFFSET);
+
+				if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+					v |= (MXC_OTG_PHYCTRL_OC_DIS_BIT | MXC_OTG_UCTRL_OPM_BIT); /* OC/USBPWR is not used */
+				else
+					v &= ~(MXC_OTG_PHYCTRL_OC_DIS_BIT | MXC_OTG_UCTRL_OPM_BIT); /* OC/USBPWR is used */
+				__raw_writel(v, usbother_base + MXC_USB_PHY_CTR_FUNC_OFFSET);
+
+				v = __raw_readl(usbother_base + MXC_USBCTRL_OFFSET);
+				if (flags & MXC_EHCI_WAKEUP_ENABLED)
+					v |= MXC_OTG_UCTRL_OWIE_BIT;/* OTG wakeup enable */
+				else
+					v &= ~MXC_OTG_UCTRL_OWIE_BIT;/* OTG wakeup disable */
+				__raw_writel(v, usbother_base + MXC_USBCTRL_OFFSET);
+			}
+			break;
+		case 1:	/* Host 1 */
+			/*Host ULPI */
+			v = __raw_readl(usbother_base + MXC_USBCTRL_OFFSET);
+			if (flags & MXC_EHCI_WAKEUP_ENABLED)
+				v &= ~(MXC_H1_UCTRL_H1WIE_BIT | MXC_H1_UCTRL_H1UIE_BIT);/* HOST1 wakeup/ULPI intr disable */
+			else
+				v &= ~(MXC_H1_UCTRL_H1WIE_BIT | MXC_H1_UCTRL_H1UIE_BIT);/* HOST1 wakeup/ULPI intr disable */
+
+			if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+				v &= ~MXC_H1_UCTRL_H1PM_BIT; /* HOST1 power mask used*/
+			else
+				v |= MXC_H1_UCTRL_H1PM_BIT; /* HOST1 power mask used*/
+			__raw_writel(v, usbother_base + MXC_USBCTRL_OFFSET);
+
+			v = __raw_readl(usbother_base + MXC_USB_PHY_CTR_FUNC_OFFSET);
+			if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+				v &= ~MXC_H1_OC_DIS_BIT; /* OC is used */
+			else
+				v |= MXC_H1_OC_DIS_BIT; /* OC is not used */
+			__raw_writel(v, usbother_base + MXC_USB_PHY_CTR_FUNC_OFFSET);
+
+			v = __raw_readl(usbotg_base + MXC_USBCMD_OFFSET);
+			if (flags & MXC_EHCI_ITC_NO_THRESHOLD)
+				/* Interrupt Threshold Control:Immediate (no threshold) */
+				v &= MXC_UCMD_ITC_NO_THRESHOLD_MASK;
+			__raw_writel(v, usbotg_base + MXC_USBCMD_OFFSET);
+			break;
+		}
+
+		/* need to reset the controller here so that the ID pin
+		 * is correctly detected.
+		 */
+		/* Stop then Reset */
+		v = __raw_readl(usbotg_base + MXC_USBCMD_OFFSET);
+		v &= ~MXC_UCMD_RUN_BIT;
+		__raw_writel(v, usbotg_base + MXC_USBCMD_OFFSET);
+		ret = hw_handshake(usbotg_base + MXC_USBCMD_OFFSET, MXC_UCMD_RUN_BIT, 0, 500);
+		if (ret) {
+			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
+			goto error;
+		}
+
+		v = __raw_readl(usbotg_base + MXC_USBCMD_OFFSET);
+		v |= MXC_UCMD_RESET_BIT;
+		__raw_writel(v, usbotg_base + MXC_USBCMD_OFFSET);
+		ret = hw_handshake(usbotg_base + MXC_USBCMD_OFFSET, MXC_UCMD_RESET_BIT, 0, 500);
+		if (ret) {
+			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
+			goto error;
+		}
+
+		/* allow controller to reset, and leave time for
+		 * the ULPI transceiver to reset too.
+		 */
+		msleep(100);
+error:
+		iounmap(usb_base);
+		return ret;
+	}
+#endif
 	printk(KERN_WARNING
 		"%s() unable to setup USBCONTROL for this CPU\n", __func__);
 	return -EINVAL;
 }
-EXPORT_SYMBOL(mxc_set_usbcontrol);
+EXPORT_SYMBOL(mxc_initialize_usb_hw);
 
diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
index 4b9b836..7fc5f99 100644
--- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
+++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
@@ -25,6 +25,18 @@
 #define MXC_EHCI_INTERNAL_PHY		(1 << 7)
 #define MXC_EHCI_IPPUE_DOWN		(1 << 8)
 #define MXC_EHCI_IPPUE_UP		(1 << 9)
+#define MXC_EHCI_WAKEUP_ENABLED	(1 << 10)
+#define MXC_EHCI_ITC_NO_THRESHOLD	(1 << 11)
+
+#define MXC_USBCTRL_OFFSET		0
+#define MXC_USB_PHY_CTR_FUNC_OFFSET	0x8
+#define MXC_USB_PHY_CTR_FUNC2_OFFSET	0xc
+
+#define MX5_USBOTHER_REGS_OFFSET	0x800
+
+/* USB_PHY_CTRL_FUNC2*/
+#define MX5_USB_UTMI_PHYCTRL1_PLLDIV_MASK		0x3
+#define MX5_USB_UTMI_PHYCTRL1_PLLDIV_SHIFT		0
 
 struct mxc_usbh_platform_data {
 	int (*init)(struct platform_device *pdev);
@@ -35,7 +47,7 @@ struct mxc_usbh_platform_data {
 	struct otg_transceiver	*otg;
 };
 
-int mxc_set_usbcontrol(int port, unsigned int flags);
+int mxc_initialize_usb_hw(int port, unsigned int flags);
 
 #endif /* __INCLUDE_ASM_ARCH_MXC_EHCI_H */
 
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index ead59f4..bb8d092 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -191,6 +191,11 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 		clk_enable(priv->ahbclk);
 	}
 
+	/* setup specific usb hw */
+	ret = mxc_initialize_usb_hw(pdev->id, pdata->flags);
+	if (ret < 0)
+		goto err_init;
+
 	/* set USBMODE to host mode */
 	temp = readl(hcd->regs + USBMODE_OFFSET);
 	writel(temp | USBMODE_CM_HOST, hcd->regs + USBMODE_OFFSET);
@@ -199,11 +204,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	writel(pdata->portsc, hcd->regs + PORTSC_OFFSET);
 	mdelay(10);
 
-	/* setup USBCONTROL. */
-	ret = mxc_set_usbcontrol(pdev->id, pdata->flags);
-	if (ret < 0)
-		goto err_init;
-
 	/* Initialize the transceiver */
 	if (pdata->otg) {
 		pdata->otg->io_priv = hcd->regs + ULPI_VIEWPORT_OFFSET;
-- 
1.6.0.4

