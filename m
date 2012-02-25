Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab2BYN57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 08:57:59 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:29870 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756563Ab2BYN55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 08:57:57 -0500
From: Roland Stigge <stigge@antcom.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3] ARM: LPC32xx: USB Support
Date: Sat, 25 Feb 2012 14:57:04 +0100
Message-Id: <1330178224-24999-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330178224-24999-1-git-send-email-stigge@antcom.de>
References: <1330178224-24999-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds OHCI support to the LPC32xx ARM platform. Besides the trivial
addition of platform "usb-ohci" support, fixes for the USB PLL have been added
to arch/arm/mach-lpc32xx/clock.c, ported from NXP's lpclinux.com.

(This is the mach-lpc32xx specific part, the USB subsystem specific changes are
in a separate patch for the USB maintainers.)

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/clock.c                 |   87 ++++++++++++++++++--------
 arch/arm/mach-lpc32xx/common.c                |   26 +++++++
 arch/arm/mach-lpc32xx/common.h                |    1 
 arch/arm/mach-lpc32xx/include/mach/platform.h |   10 ++
 arch/arm/mach-lpc32xx/phy3250.c               |    1 
 5 files changed, 101 insertions(+), 24 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -87,6 +87,7 @@
 #include <linux/list.h>
 #include <linux/errno.h>
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/amba/bus.h>
@@ -100,6 +101,8 @@
 
 static DEFINE_SPINLOCK(global_clkregs_lock);
 
+static int usb_pll_enable, usb_pll_valid;
+
 static struct clk clk_armpll;
 static struct clk clk_usbpll;
 
@@ -384,30 +387,62 @@ static u32 local_clk_usbpll_setup(struct
 static int local_usbpll_enable(struct clk *clk, int enable)
 {
 	u32 reg;
-	int ret = -ENODEV;
-	unsigned long timeout = jiffies + msecs_to_jiffies(10);
+	int ret = 0;
+	unsigned long timeout = jiffies + msecs_to_jiffies(20);
 
 	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 
-	if (enable == 0) {
-		reg &= ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN1 |
-			LPC32XX_CLKPWR_USBCTRL_CLK_EN2);
-		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
-	} else if (reg & LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP) {
+	__raw_writel(reg & ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN2 |
+		LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP),
+		LPC32XX_CLKPWR_USB_CTRL);
+	__raw_writel(reg & ~LPC32XX_CLKPWR_USBCTRL_CLK_EN1,
+		LPC32XX_CLKPWR_USB_CTRL);
+
+	if (enable && usb_pll_valid && usb_pll_enable) {
+		ret = -ENODEV;
+		/*
+		 * If the PLL rate has been previously set, then the rate
+		 * in the PLL register is valid and can be enabled here.
+		 * Otherwise, it needs to be enabled as part of setrate.
+		 */
+
+		/*
+		 * Gate clock into PLL
+		 */
 		reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN1;
 		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
 
-		/* Wait for PLL lock */
+		/*
+		 * Enable PLL
+		 */
+		reg |= LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP;
+		__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+
+		/*
+		 * Wait for PLL to lock
+		 */
 		while (time_before(jiffies, timeout) && (ret == -ENODEV)) {
 			reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
 			if (reg & LPC32XX_CLKPWR_USBCTRL_PLL_STS)
 				ret = 0;
+			else
+				udelay(10);
 		}
 
+		/*
+		 * Gate clock from PLL if PLL is locked
+		 */
 		if (ret == 0) {
-			reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN2;
-			__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+			__raw_writel(reg | LPC32XX_CLKPWR_USBCTRL_CLK_EN2,
+				LPC32XX_CLKPWR_USB_CTRL);
+		} else {
+			__raw_writel(reg & ~(LPC32XX_CLKPWR_USBCTRL_CLK_EN1 |
+				LPC32XX_CLKPWR_USBCTRL_PLL_PWRUP),
+				LPC32XX_CLKPWR_USB_CTRL);
 		}
+	} else if ((enable == 0) && usb_pll_valid  && usb_pll_enable) {
+		usb_pll_valid = 0;
+		usb_pll_enable = 0;
 	}
 
 	return ret;
@@ -425,7 +460,7 @@ static unsigned long local_usbpll_round_
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->parent->rate;
+	clkin = clk->get_rate(clk);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -439,7 +474,8 @@ static unsigned long local_usbpll_round_
 
 static int local_usbpll_set_rate(struct clk *clk, unsigned long rate)
 {
-	u32 clkin, reg, usbdiv;
+	int ret = -ENODEV;
+	u32 clkin, usbdiv;
 	struct clk_pll_setup pllsetup;
 
 	/*
@@ -448,7 +484,7 @@ static int local_usbpll_set_rate(struct
 	 */
 	rate = rate * 1000;
 
-	clkin = clk->get_rate(clk);
+	clkin = clk->get_rate(clk->parent);
 	usbdiv = (__raw_readl(LPC32XX_CLKPWR_USBCLK_PDIV) &
 		LPC32XX_CLKPWR_USBPDIV_PLL_MASK) + 1;
 	clkin = clkin / usbdiv;
@@ -457,22 +493,25 @@ static int local_usbpll_set_rate(struct
 	if (local_clk_find_pll_cfg(clkin, rate, &pllsetup) == 0)
 		return -EINVAL;
 
+	/*
+	 * Disable PLL clocks during PLL change
+	 */
 	local_usbpll_enable(clk, 0);
-
-	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN1;
-	__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
-
-	pllsetup.analog_on = 1;
+	pllsetup.analog_on = 0;
 	local_clk_usbpll_setup(&pllsetup);
 
-	clk->rate = clk_check_pll_setup(clkin, &pllsetup);
+	/*
+	 * Start USB PLL and check PLL status
+	 */
+
+	usb_pll_valid = 1;
+	usb_pll_enable = 1;
 
-	reg = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
-	reg |= LPC32XX_CLKPWR_USBCTRL_CLK_EN2;
-	__raw_writel(reg, LPC32XX_CLKPWR_USB_CTRL);
+	ret = local_usbpll_enable(clk, 1);
+	if (ret >= 0)
+		clk->rate = clk_check_pll_setup(clkin, &pllsetup);
 
-	return 0;
+	return ret;
 }
 
 static struct clk clk_usbpll = {
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.c
+++ linux-2.6/arch/arm/mach-lpc32xx/common.c
@@ -160,6 +160,32 @@ struct platform_device lpc32xx_adc_devic
 };
 
 /*
+ * USB support
+ */
+/* The dmamask must be set for OHCI to work */
+static u64 ohci_dmamask = ~(u32) 0;
+static struct resource ohci_resources[] = {
+	{
+		.start = IO_ADDRESS(LPC32XX_USB_BASE),
+		.end = IO_ADDRESS(LPC32XX_USB_BASE + 0x100 - 1),
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_LPC32XX_USB_HOST,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+struct platform_device lpc32xx_ohci_device = {
+	.name = "usb-ohci",
+	.id = -1,
+	.dev = {
+		.dma_mask = &ohci_dmamask,
+		.coherent_dma_mask = 0xFFFFFFFF,
+	},
+	.num_resources = ARRAY_SIZE(ohci_resources),
+	.resource = ohci_resources,
+};
+
+/*
  * Returns the unique ID for the device
  */
 void lpc32xx_get_uid(u32 devid[4])
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.h
+++ linux-2.6/arch/arm/mach-lpc32xx/common.h
@@ -31,6 +31,7 @@ extern struct platform_device lpc32xx_i2
 extern struct platform_device lpc32xx_tsc_device;
 extern struct platform_device lpc32xx_adc_device;
 extern struct platform_device lpc32xx_rtc_device;
+extern struct platform_device lpc32xx_ohci_device;
 
 /*
  * Other arch specific structures and functions
--- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/platform.h
+++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/platform.h
@@ -694,4 +694,14 @@
 #define LPC32XX_GPIO_P2_MUX_CLR			_GPREG(0x02C)
 #define LPC32XX_GPIO_P2_MUX_STATE		_GPREG(0x030)
 
+#ifdef CONFIG_USB_OHCI_HCD
+#define PNX4008_PWRMAN_BASE			LPC32XX_CLK_PM_BASE
+#define PNX4008_USB_CONFIG_BASE			LPC32XX_USB_BASE
+#define start_int_set_falling_edge(irq)
+#define start_int_set_rising_edge(irq)
+#define start_int_ack(irq)
+#define start_int_mask(irq)
+#define start_int_umask(irq)
+#endif
+
 #endif
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -277,6 +277,7 @@ static struct platform_device *phy3250_d
 	&lpc32xx_watchdog_device,
 	&lpc32xx_gpio_led_device,
 	&lpc32xx_adc_device,
+	&lpc32xx_ohci_device,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
