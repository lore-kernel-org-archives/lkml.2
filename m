Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2E3Oev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:34:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47399 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2E3Oes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:34:48 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
Subject: [RFC PATCH 3/3] arm: omap: phy: remove unused functions from omap-phy-internal.c
Date: Wed, 30 May 2012 20:04:26 +0530
Message-ID: <1338388466-3565-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338388466-3565-1-git-send-email-kishon@ti.com>
References: <1338388466-3565-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the unnessary functions in omap-phy-internal is removed.
These functionality are now handled by omap-usb2 phy driver.

Cc: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/omap_phy_internal.c |  138 -------------------------------
 arch/arm/mach-omap2/twl-common.c        |    5 -
 2 files changed, 0 insertions(+), 143 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index b2c9253..9a9e960 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -31,144 +31,6 @@
 #include <plat/usb.h>
 #include <mach/control.h>
 
-/* OMAP control module register for UTMI PHY */
-#define CONTROL_DEV_CONF		0x300
-#define PHY_PD				0x1
-
-#define USBOTGHS_CONTROL		0x33c
-#define	AVALID				BIT(0)
-#define	BVALID				BIT(1)
-#define	VBUSVALID			BIT(2)
-#define	SESSEND				BIT(3)
-#define	IDDIG				BIT(4)
-
-static struct clk *phyclk, *clk48m, *clk32k;
-static void __iomem *ctrl_base;
-static int usbotghs_control;
-
-int omap4430_phy_init(struct device *dev)
-{
-	ctrl_base = ioremap(OMAP443X_SCM_BASE, SZ_1K);
-	if (!ctrl_base) {
-		pr_err("control module ioremap failed\n");
-		return -ENOMEM;
-	}
-	/* Power down the phy */
-	__raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
-
-	if (!dev) {
-		iounmap(ctrl_base);
-		return 0;
-	}
-
-	phyclk = clk_get(dev, "ocp2scp_usb_phy_ick");
-	if (IS_ERR(phyclk)) {
-		dev_err(dev, "cannot clk_get ocp2scp_usb_phy_ick\n");
-		iounmap(ctrl_base);
-		return PTR_ERR(phyclk);
-	}
-
-	clk48m = clk_get(dev, "ocp2scp_usb_phy_phy_48m");
-	if (IS_ERR(clk48m)) {
-		dev_err(dev, "cannot clk_get ocp2scp_usb_phy_phy_48m\n");
-		clk_put(phyclk);
-		iounmap(ctrl_base);
-		return PTR_ERR(clk48m);
-	}
-
-	clk32k = clk_get(dev, "usb_phy_cm_clk32k");
-	if (IS_ERR(clk32k)) {
-		dev_err(dev, "cannot clk_get usb_phy_cm_clk32k\n");
-		clk_put(phyclk);
-		clk_put(clk48m);
-		iounmap(ctrl_base);
-		return PTR_ERR(clk32k);
-	}
-	return 0;
-}
-
-int omap4430_phy_set_clk(struct device *dev, int on)
-{
-	static int state;
-
-	if (on && !state) {
-		/* Enable the phy clocks */
-		clk_enable(phyclk);
-		clk_enable(clk48m);
-		clk_enable(clk32k);
-		state = 1;
-	} else if (state) {
-		/* Disable the phy clocks */
-		clk_disable(phyclk);
-		clk_disable(clk48m);
-		clk_disable(clk32k);
-		state = 0;
-	}
-	return 0;
-}
-
-int omap4430_phy_power(struct device *dev, int ID, int on)
-{
-	if (on) {
-		if (ID)
-			/* enable VBUS valid, IDDIG groung */
-			__raw_writel(AVALID | VBUSVALID, ctrl_base +
-							USBOTGHS_CONTROL);
-		else
-			/*
-			 * Enable VBUS Valid, AValid and IDDIG
-			 * high impedance
-			 */
-			__raw_writel(IDDIG | AVALID | VBUSVALID,
-						ctrl_base + USBOTGHS_CONTROL);
-	} else {
-		/* Enable session END and IDIG to high impedance. */
-		__raw_writel(SESSEND | IDDIG, ctrl_base +
-					USBOTGHS_CONTROL);
-	}
-	return 0;
-}
-
-int omap4430_phy_suspend(struct device *dev, int suspend)
-{
-	if (suspend) {
-		/* Disable the clocks */
-		omap4430_phy_set_clk(dev, 0);
-		/* Power down the phy */
-		__raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
-
-		/* save the context */
-		usbotghs_control = __raw_readl(ctrl_base + USBOTGHS_CONTROL);
-	} else {
-		/* Enable the internel phy clcoks */
-		omap4430_phy_set_clk(dev, 1);
-		/* power on the phy */
-		if (__raw_readl(ctrl_base + CONTROL_DEV_CONF) & PHY_PD) {
-			__raw_writel(~PHY_PD, ctrl_base + CONTROL_DEV_CONF);
-			mdelay(200);
-		}
-
-		/* restore the context */
-		__raw_writel(usbotghs_control, ctrl_base + USBOTGHS_CONTROL);
-	}
-
-	return 0;
-}
-
-int omap4430_phy_exit(struct device *dev)
-{
-	if (ctrl_base)
-		iounmap(ctrl_base);
-	if (phyclk)
-		clk_put(phyclk);
-	if (clk48m)
-		clk_put(clk48m);
-	if (clk32k)
-		clk_put(clk32k);
-
-	return 0;
-}
-
 void am35x_musb_reset(void)
 {
 	u32	regval;
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index 119d5a9..396d189 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -250,11 +250,6 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 
 #if defined(CONFIG_ARCH_OMAP4)
 static struct twl4030_usb_data omap4_usb_pdata = {
-	.phy_init	= omap4430_phy_init,
-	.phy_exit	= omap4430_phy_exit,
-	.phy_power	= omap4430_phy_power,
-	.phy_set_clock	= omap4430_phy_set_clk,
-	.phy_suspend	= omap4430_phy_suspend,
 };
 
 static struct regulator_init_data omap4_vdac_idata = {
-- 
1.7.5.4

