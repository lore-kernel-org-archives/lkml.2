Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0DSW1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:27:51 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:56785 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0DSW1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:27:47 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, r.herring@freescale.com,
       Jun.Li@freescale.com, xiao-lizhang@freescale.com,
       Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 2.6.34-rc4 4/5] mxc: Add generic USB HW initialization for MX51
Date: Mon, 19 Apr 2010 17:27:03 -0500
Message-Id: <1271716024-22990-4-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1271716024-22990-3-git-send-email-Dinh.Nguyen@freescale.com>
References: <1271716024-22990-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271716024-22990-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271716024-22990-3-git-send-email-Dinh.Nguyen@freescale.com>
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

This patch applies to 2.6.34-rc4.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/plat-mxc/ehci.c                  |  151 ++++++++++++++++++++++++++++-
 arch/arm/plat-mxc/include/mach/mxc_ehci.h |   58 +++++++++++-
 drivers/usb/host/ehci-mxc.c               |   10 +-
 3 files changed, 211 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-mxc/ehci.c b/arch/arm/plat-mxc/ehci.c
index cb0b638..a622d90 100644
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
@@ -50,9 +52,25 @@
 #define MX35_H1_TLL_BIT		(1 << 5)
 #define MX35_H1_USBTE_BIT	(1 << 4)
 
-int mxc_set_usbcontrol(int port, unsigned int flags)
+static inline int hw_handshake(u32 addr, u32 mask, int done, int usec)
+{
+	u32 result;
+
+	do {
+		result = __raw_readl(addr);
+		result &= mask;
+		if (result == done)
+			return 0;
+		udelay(1);
+		usec--;
+	} while (usec > 0);
+	return ETIMEDOUT;
+}
+
+int mxc_intialize_usb_hw(int port, unsigned int flags)
 {
 	unsigned int v;
+
 #ifdef CONFIG_ARCH_MX3
 	if (cpu_is_mx31()) {
 		v = readl(MX31_IO_ADDRESS(MX31_OTG_BASE_ADDR +
@@ -186,9 +204,138 @@ int mxc_set_usbcontrol(int port, unsigned int flags)
 		return 0;
 	}
 #endif /* CONFIG_MACH_MX27 */
+#ifdef CONFIG_ARCH_MX51
+	if (cpu_is_mx51()) {
+		void __iomem *usb_base;
+		u32 usbotg_base;
+		u32 usbother_base;
+		int timeout;
+		int ret = 0;
+
+		usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
+
+		switch (port) {
+		case 0:	/* OTG port */
+			usbotg_base = usb_base + USBOTG_OFFSET;
+			break;
+		case 1:	/* Host 1 port */
+			usbotg_base = usb_base + USBH1_OFFSET;
+			break;
+		default:
+			printk(KERN_ERR"%s no such port %d\n", __func__, port);
+			ret = -ENOENT;
+			goto error;
+		}
+		usbother_base = usb_base + USBOTHER_REGS_OFFSET;
+
+		/* Stop then Reset */
+		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
+		v &= ~UCMD_RUN_STOP;
+		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
+		timeout = hw_handshake(usbotg_base + USBCMD_OFFSET, UCMD_RUN_STOP, 0, 500);
+		if (timeout) {
+			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
+			ret = -timeout;
+			goto error;
+		}
+
+		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
+		v |= UCMD_RESET;
+		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
+		timeout = hw_handshake(usbotg_base + USBCMD_OFFSET, UCMD_RESET, 0, 500);
+		if (timeout) {
+			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
+			ret = -timeout;
+			goto error;
+		}
+
+		switch (port) {
+		case 0:	/*OTG port */
+			if (flags & MXC_EHCI_INTERNAL_PHY) {
+				v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
+
+				if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+					v |= (USB_UTMI_PHYCTRL_OC_DIS | UCTRL_OPM); /* OC/USBPWR is not used */
+				else
+					v &= ~(USB_UTMI_PHYCTRL_OC_DIS | UCTRL_OPM); /* OC/USBPWR is used */
+				__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
+
+				v = __raw_readl(usbother_base + USBCTRL_OFFSET);
+				if (flags & MXC_EHCI_WAKEUP_ENABLED)
+					v |= UCTRL_OWIE;/* OTG wakeup enable */
+				else
+					v &= ~UCTRL_OWIE;/* OTG wakeup disable */
+				__raw_writel(v, usbother_base + USBCTRL_OFFSET);
+			}
+			break;
+		case 1:	/* Host 1 */
+			/*Host ULPI */
+			v = __raw_readl(usbother_base + USB_CTRL_1_OFFSET);
+			__raw_writel(v | USB_CTRL_UH1_EXT_CLK_EN, usbother_base + USB_CTRL_1_OFFSET);
+
+			v = __raw_readl(usbother_base + USBCTRL_OFFSET);
+			if (flags & MXC_EHCI_WAKEUP_ENABLED)
+				v &= ~(UCTRL_H1WIE | UCTRL_H1UIE);/* HOST1 wakeup/ULPI intr disable */
+			else
+				v &= ~(UCTRL_H1WIE | UCTRL_H1UIE);/* HOST1 wakeup/ULPI intr disable */
+
+			if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+				v &= ~UCTRL_H1PM; /* HOST1 power mask used*/
+			else
+				v |= UCTRL_H1PM; /* HOST1 power mask used*/
+			__raw_writel(v, usbother_base + USBCTRL_OFFSET);
+
+			v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC_OFFSET);
+			if (flags & MXC_EHCI_POWER_PINS_ENABLED)
+				v &= ~USB_UH1_OC_DIS; /* OC is used */
+			else
+				v |= USB_UH1_OC_DIS; /* OC is not used */
+			__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC_OFFSET);
+
+			v = __raw_readl(usbotg_base + USBCMD_OFFSET);
+			if (flags & MXC_EHCI_ITC_NO_THRESHOLD)
+				/* Interrupt Threshold Control:Immediate (no threshold) */
+				v &= UCMD_ITC_NO_THRESHOLD;
+			__raw_writel(v, usbotg_base + USBCMD_OFFSET);
+			break;
+		}
+
+		/* need to reset the controller here so that the ID pin
+		 * is correctly detected.
+		 */
+		/* Stop then Reset */
+		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
+		v &= ~UCMD_RUN_STOP;
+		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
+		timeout = hw_handshake(usbotg_base + USBCMD_OFFSET, UCMD_RUN_STOP, 0, 500);
+		if (timeout) {
+			printk(KERN_ERR "%s could not stop usb hardware\n", __func__);
+			ret = -timeout;
+			goto error;
+		}
+
+		v = __raw_readl(usbotg_base + USBCMD_OFFSET);
+		v |= UCMD_RESET;
+		__raw_writel(v, usbotg_base + USBCMD_OFFSET);
+		timeout = hw_handshake(usbotg_base + USBCMD_OFFSET, UCMD_RESET, 0, 500);
+		if (timeout) {
+			printk(KERN_ERR "%s could not reset usb hardware\n", __func__);
+			ret = -timeout;
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
+EXPORT_SYMBOL(mxc_intialize_usb_hw);
 
diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
index 4b9b836..42c4beb 100644
--- a/arch/arm/plat-mxc/include/mach/mxc_ehci.h
+++ b/arch/arm/plat-mxc/include/mach/mxc_ehci.h
@@ -1,6 +1,30 @@
 #ifndef __INCLUDE_ASM_ARCH_MXC_EHCI_H
 #define __INCLUDE_ASM_ARCH_MXC_EHCI_H
 
+#define USBOTG_OFFSET			0
+#define USBH1_OFFSET			0x200
+#define USBH2_OFFSET			0x400
+#define USBH3_OFFSET			0x600
+#define USBOTHER_REGS_OFFSET	0x800
+
+#define USBCMD_OFFSET			0x140
+
+#define ULPI_VIEWPORT_OFFSET	0x170
+#define PORTSC_OFFSET		0x184
+#define USBMODE_OFFSET		0x1a8
+#define USBMODE_CM_HOST		3
+
+#define USBCTRL_OFFSET					0
+#define USB_PHY_CTR_FUNC_OFFSET		0x8
+#define USB_PHY_CTR_FUNC2_OFFSET		0xc
+#define USB_CTRL_1_OFFSET				0x10
+
+
+/* USBCMD */
+#define UCMD_RUN_STOP           (1 << 0)        /* controller run/stop */
+#define UCMD_RESET		(1 << 1)	/* controller reset */
+#define UCMD_ITC_NO_THRESHOLD		(~(0xff << 16))	/* Interrupt Threshold Control */
+
 /* values for portsc field */
 #define MXC_EHCI_PHY_LOW_POWER_SUSPEND	(1 << 23)
 #define MXC_EHCI_FORCE_FS		(1 << 24)
@@ -25,6 +49,38 @@
 #define MXC_EHCI_INTERNAL_PHY		(1 << 7)
 #define MXC_EHCI_IPPUE_DOWN		(1 << 8)
 #define MXC_EHCI_IPPUE_UP		(1 << 9)
+#define MXC_EHCI_WAKEUP_ENABLED	(1 << 10)
+#define MXC_EHCI_ITC_NO_THRESHOLD	(1 << 11)
+
+/* USB_CTRL */
+#define UCTRL_OUIE		(1 << 28)	/* OTG ULPI intr enable */
+#define UCTRL_OWIE		(1 << 27)	/* OTG wakeup intr enable */
+#define UCTRL_OBPVAL_RXDP	(1 << 26)	/* OTG RxDp status in bypass mode */
+#define UCTRL_OBPVAL_RXDM	(1 << 25)	/* OTG RxDm status in bypass mode */
+#define UCTRL_OPM		(1 << 24)	/* OTG power mask */
+#define UCTRL_H1UIE		(1 << 12)	/* Host1 ULPI interrupt enable */
+#define UCTRL_H1WIE		(1 << 11)	/* HOST1 wakeup intr enable */
+#define UCTRL_H1PM		(1 <<  8)		/* HOST1 power mask */
+
+/* USB_PHY_CTRL_FUNC */
+#define USB_UTMI_PHYCTRL_OC_DIS	(1 << 8)	/* OTG Disable Overcurrent Event */
+#define USB_UH1_OC_DIS	(1 << 5)		/* UH1 Disable Overcurrent Event */
+
+/* USB_CTRL_1 */
+#define USB_CTRL_UH1_EXT_CLK_EN			(1 << 25)
+#define USB_CTRL_UH2_EXT_CLK_EN			(1 << 26)
+
+/* USB_PHY_CTRL_FUNC2*/
+#define USB_UTMI_PHYCTRL2_PLLDIV_MASK		0x3
+#define USB_UTMI_PHYCTRL2_PLLDIV_SHIFT		0
+#define USB_UTMI_PHYCTRL2_HSDEVSEL_MASK		0x3
+#define USB_UTMI_PHYCTRL2_HSDEVSEL_SHIFT	19
+
+#ifdef CONFIG_ARCH_MX51
+#define	USB_PLLDIV_12_MHZ		0x00
+#define	USB_PLL_DIV_19_2_MHZ	0x01
+#define	USB_PLL_DIV_24_MHZ	0x02
+#endif
 
 struct mxc_usbh_platform_data {
 	int (*init)(struct platform_device *pdev);
@@ -35,7 +91,7 @@ struct mxc_usbh_platform_data {
 	struct otg_transceiver	*otg;
 };
 
-int mxc_set_usbcontrol(int port, unsigned int flags);
+int mxc_intialize_usb_hw(int port, unsigned int flags);
 
 #endif /* __INCLUDE_ASM_ARCH_MXC_EHCI_H */
 
diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index ead59f4..7091b20 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -191,6 +191,11 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 		clk_enable(priv->ahbclk);
 	}
 
+	/* setup specific usb hw */
+	ret = mxc_intialize_usb_hw(pdev->id, pdata->flags);
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

