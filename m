Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab2FXNsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:48:55 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:40652 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756113Ab2FXNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:47:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 6/7] ARM: LPC32xx: Cleanup USB clock init
Date: Sun, 24 Jun 2012 15:47:16 +0200
Message-Id: <1340545637-5449-7-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340545637-5449-1-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Move most of usb clock initialization from lpc32xx_udc and ohci-nxp to
clock.c. Also adds ohci clocks and otg clocks.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/arm/mach-lpc32xx/clock.c                 |   68 +++++++++++++++++++++++++-
 arch/arm/mach-lpc32xx/include/mach/platform.h |   14 +++++
 2 files changed, 81 insertions(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -739,14 +739,77 @@ static struct clk clk_rtc = {
 	.get_rate	= local_return_parent_rate,
 };
 
+static int local_usb_enable(struct clk *clk, int enable)
+{
+	u32 tmp;
+
+	if (enable) {
+		/* Set up I2C pull levels */
+		tmp = __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
+		tmp |= LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE;
+		__raw_writel(tmp, LPC32XX_CLKPWR_I2C_CLK_CTRL);
+	}
+
+	return local_onoff_enable(clk, enable);
+}
+
 static struct clk clk_usbd = {
 	.parent		= &clk_usbpll,
-	.enable		= local_onoff_enable,
+	.enable		= local_usb_enable,
 	.enable_reg	= LPC32XX_CLKPWR_USB_CTRL,
 	.enable_mask	= LPC32XX_CLKPWR_USBCTRL_HCLK_EN,
 	.get_rate	= local_return_parent_rate,
 };
 
+#define OTG_ALWAYS_MASK		(LPC32XX_USB_OTG_OTG_CLOCK_ON | \
+				 LPC32XX_USB_OTG_I2C_CLOCK_ON)
+
+static int local_usb_otg_enable(struct clk *clk, int enable)
+{
+	int to = 1000;
+
+	if (enable) {
+		__raw_writel(clk->enable_mask, clk->enable_reg);
+
+		while (((__raw_readl(LPC32XX_USB_OTG_CLK_STAT) &
+			clk->enable_mask) != clk->enable_mask) && (to > 0))
+			to--;
+	} else {
+		__raw_writel(OTG_ALWAYS_MASK, clk->enable_reg);
+
+		while (((__raw_readl(LPC32XX_USB_OTG_CLK_STAT) &
+			OTG_ALWAYS_MASK) != OTG_ALWAYS_MASK) && (to > 0))
+			to--;
+	}
+
+	if (to)
+		return 0;
+	else
+		return -1;
+}
+
+static struct clk clk_usb_otg_dev = {
+	.parent		= &clk_usbpll,
+	.enable		= local_usb_otg_enable,
+	.enable_reg	= LPC32XX_USB_OTG_CLK_CTRL,
+	.enable_mask	= LPC32XX_USB_OTG_AHB_M_CLOCK_ON |
+			  LPC32XX_USB_OTG_OTG_CLOCK_ON |
+			  LPC32XX_USB_OTG_DEV_CLOCK_ON |
+			  LPC32XX_USB_OTG_I2C_CLOCK_ON,
+	.get_rate	= local_return_parent_rate,
+};
+
+static struct clk clk_usb_otg_host = {
+	.parent		= &clk_usbpll,
+	.enable		= local_usb_otg_enable,
+	.enable_reg	= LPC32XX_USB_OTG_CLK_CTRL,
+	.enable_mask	= LPC32XX_USB_OTG_AHB_M_CLOCK_ON |
+			  LPC32XX_USB_OTG_OTG_CLOCK_ON |
+			  LPC32XX_USB_OTG_HOST_CLOCK_ON |
+			  LPC32XX_USB_OTG_I2C_CLOCK_ON,
+	.get_rate	= local_return_parent_rate,
+};
+
 static int tsc_onoff_enable(struct clk *clk, int enable)
 {
 	u32 tmp;
@@ -1145,6 +1208,9 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT("31060000.ethernet", NULL, &clk_net),
 	CLKDEV_INIT("dev:clcd", NULL, &clk_lcd),
 	CLKDEV_INIT("31020000.usbd", "ck_usbd", &clk_usbd),
+	CLKDEV_INIT("31020000.ohci", "ck_usbd", &clk_usbd),
+	CLKDEV_INIT("31020000.usbd", "ck_usb_otg", &clk_usb_otg_dev),
+	CLKDEV_INIT("31020000.ohci", "ck_usb_otg", &clk_usb_otg_host),
 	CLKDEV_INIT("lpc32xx_rtc", NULL, &clk_rtc),
 };
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/platform.h
+++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/platform.h
@@ -694,4 +694,18 @@
 #define LPC32XX_GPIO_P2_MUX_CLR			_GPREG(0x02C)
 #define LPC32XX_GPIO_P2_MUX_STATE		_GPREG(0x030)
 
+/*
+ * USB Otg Registers
+ */
+#define _OTGREG(x)			io_p2v(LPC32XX_USB_OTG_BASE + (x))
+#define LPC32XX_USB_OTG_CLK_CTRL	_OTGREG(0xFF4)
+#define LPC32XX_USB_OTG_CLK_STAT	_OTGREG(0xFF8)
+
+/* USB OTG CLK CTRL bit defines */
+#define LPC32XX_USB_OTG_AHB_M_CLOCK_ON	_BIT(4)
+#define LPC32XX_USB_OTG_OTG_CLOCK_ON	_BIT(3)
+#define LPC32XX_USB_OTG_I2C_CLOCK_ON	_BIT(2)
+#define LPC32XX_USB_OTG_DEV_CLOCK_ON	_BIT(1)
+#define LPC32XX_USB_OTG_HOST_CLOCK_ON	_BIT(0)
+
 #endif
