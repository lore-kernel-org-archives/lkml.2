Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab2BANbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:31:33 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:47086 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754436Ab2BANbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:31:32 -0500
From: stigge@antcom.de
To: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: LPC32xx: Support for OHCI HCD
Date: Wed,  1 Feb 2012 14:30:28 +0100
Message-Id: <1328103028-20547-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.8.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds OHCI support to the LPC32xx ARM platform

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/arch/arm/mach-lpc32xx/common.c b/arch/arm/mach-lpc32xx/common.c
index 369b152..f220eb0 100644
--- a/arch/arm/mach-lpc32xx/common.c
+++ b/arch/arm/mach-lpc32xx/common.c
@@ -137,6 +137,31 @@ struct platform_device lpc32xx_rtc_device = {
 	.resource = lpc32xx_rtc_resources,
 };
 
+#if defined(CONFIG_USB_OHCI_HCD)
+/* The dmamask must be set for OHCI to work */
+static u64 ohci_dmamask = ~(u32) 0;
+static struct resource ohci_resources[] = {
+	{
+		.start = IO_ADDRESS(LPC32XX_USB_BASE),
+		.end = IO_ADDRESS(LPC32XX_USB_BASE + 0x100),
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
+#endif
+
 /*
  * Returns the unique ID for the device
  */
diff --git a/arch/arm/mach-lpc32xx/common.h b/arch/arm/mach-lpc32xx/common.h
index 4b4e700..f63d43c 100644
--- a/arch/arm/mach-lpc32xx/common.h
+++ b/arch/arm/mach-lpc32xx/common.h
@@ -30,6 +30,7 @@ extern struct platform_device lpc32xx_i2c1_device;
 extern struct platform_device lpc32xx_i2c2_device;
 extern struct platform_device lpc32xx_tsc_device;
 extern struct platform_device lpc32xx_rtc_device;
+extern struct platform_device lpc32xx_ohci_device;
 
 /*
  * Other arch specific structures and functions
diff --git a/arch/arm/mach-lpc32xx/phy3250.c b/arch/arm/mach-lpc32xx/phy3250.c
index bfee5b4..4e81e99 100644
--- a/arch/arm/mach-lpc32xx/phy3250.c
+++ b/arch/arm/mach-lpc32xx/phy3250.c
@@ -276,6 +276,9 @@ static struct platform_device *phy3250_devs[] __initdata = {
 	&lpc32xx_i2c2_device,
 	&lpc32xx_watchdog_device,
 	&lpc32xx_gpio_led_device,
+#if defined(CONFIG_USB_OHCI_HCD)
+	&lpc32xx_ohci_device,
+#endif
 };
 
 static struct amba_device *amba_devs[] __initdata = {
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..4285335 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1055,6 +1055,11 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
 #endif
 
+#ifdef CONFIG_ARCH_LPC32XX
+#include "ohci-pnx4008.c"
+#define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
+#endif
+
 #ifdef CONFIG_ARCH_DAVINCI_DA8XX
 #include "ohci-da8xx.c"
 #define PLATFORM_DRIVER		ohci_hcd_da8xx_driver
diff --git a/drivers/usb/host/ohci-pnx4008.c b/drivers/usb/host/ohci-pnx4008.c
index 0013db7..de05a6d 100644
--- a/drivers/usb/host/ohci-pnx4008.c
+++ b/drivers/usb/host/ohci-pnx4008.c
@@ -24,8 +24,15 @@
 #include <mach/hardware.h>
 #include <asm/io.h>
 
+#if defined(CONFIG_ARCH_LPC32XX)
 #include <mach/platform.h>
 #include <mach/irqs.h>
+#define PNX4008_PWRMAN_BASE LPC32XX_CLK_PM_BASE
+#define PNX4008_USB_CONFIG_BASE LPC32XX_USB_BASE
+#else
+#include <mach/platform.h>
+#include <mach/irqs.h>
+#endif
 #include <asm/gpio.h>
 
 #define USB_CTRL	IO_ADDRESS(PNX4008_PWRMAN_BASE + 0x64)
@@ -143,8 +150,21 @@ static void i2c_write(u8 buf, u8 subaddr)
 	i2c_master_send(isp1301_i2c_client, &tmpbuf[0], 2);
 }
 
+#ifdef CONFIG_ARCH_LPC32XX
+static u16 i2c_read16(u8 subaddr)
+{
+	u16 data;
+
+	i2c_master_send(isp1301_i2c_client, &subaddr, 1);
+	i2c_master_recv(isp1301_i2c_client, (u8 *) &data, 2);
+
+	return data;
+}
+#endif
+
 static void isp1301_configure(void)
 {
+#if !defined(CONFIG_ARCH_LPC32XX)
 	/* PNX4008 only supports DAT_SE0 USB mode */
 	/* PNX4008 R2A requires setting the MAX603 to output 3.6V */
 	/* Power up externel charge-pump */
@@ -166,7 +186,41 @@ static void isp1301_configure(void)
 		  ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
 	i2c_write(0xFF,
 		  ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
-
+#else
+	/* LPC32XX only supports DAT_SE0 USB mode */
+	/* This sequence is important */
+
+	/* Disable transparent UART mode first */
+	i2c_write(MC1_UART_EN, (ISP1301_I2C_MODE_CONTROL_1 |
+		ISP1301_I2C_REG_CLEAR_ADDR));
+
+	i2c_write(~MC1_SPEED_REG, (ISP1301_I2C_MODE_CONTROL_1 |
+		ISP1301_I2C_REG_CLEAR_ADDR));
+	i2c_write(MC1_SPEED_REG, ISP1301_I2C_MODE_CONTROL_1);
+	i2c_write(~0,
+		(ISP1301_I2C_MODE_CONTROL_2 | ISP1301_I2C_REG_CLEAR_ADDR));
+	i2c_write((MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL),
+		ISP1301_I2C_MODE_CONTROL_2);
+	i2c_write(~0, (ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR));
+	i2c_write(MC1_DAT_SE0, ISP1301_I2C_MODE_CONTROL_1);
+	i2c_write((OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN),
+		ISP1301_I2C_OTG_CONTROL_1);
+	i2c_write((OTG1_DM_PULLUP | OTG1_DP_PULLUP),
+		(ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR));
+	i2c_write(~0,
+		 ISP1301_I2C_INTERRUPT_LATCH | ISP1301_I2C_REG_CLEAR_ADDR);
+	i2c_write(~0,
+		ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
+	i2c_write(~0,
+		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
+
+	/* Enable usb_need_clk clock after transceiver is initialized */
+	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
+
+	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n", i2c_read16(0x00));
+	printk(KERN_INFO "ISP1301 Product ID : 0x%04x\n", i2c_read16(0x02));
+	printk(KERN_INFO "ISP1301 Version ID : 0x%04x\n", i2c_read16(0x14));
+#endif
 }
 
 static inline void isp1301_vbus_on(void)
@@ -257,6 +311,7 @@ static const struct hc_driver ohci_pnx4008_hc_driver = {
 
 static void pnx4008_set_usb_bits(void)
 {
+#if !defined(CONFIG_ARCH_LPC32XX)
 	start_int_set_falling_edge(SE_USB_OTG_ATX_INT_N);
 	start_int_ack(SE_USB_OTG_ATX_INT_N);
 	start_int_umask(SE_USB_OTG_ATX_INT_N);
@@ -280,16 +335,19 @@ static void pnx4008_set_usb_bits(void)
 	start_int_set_rising_edge(SE_USB_AHB_NEED_CLK_INT);
 	start_int_ack(SE_USB_AHB_NEED_CLK_INT);
 	start_int_umask(SE_USB_AHB_NEED_CLK_INT);
+#endif
 }
 
 static void pnx4008_unset_usb_bits(void)
 {
+#if !defined(CONFIG_ARCH_LPC32XX)
 	start_int_mask(SE_USB_OTG_ATX_INT_N);
 	start_int_mask(SE_USB_OTG_TIMER_INT);
 	start_int_mask(SE_USB_I2C_INT);
 	start_int_mask(SE_USB_INT);
 	start_int_mask(SE_USB_NEED_CLK_INT);
 	start_int_mask(SE_USB_AHB_NEED_CLK_INT);
+#endif
 }
 
 static int __devinit usb_hcd_pnx4008_probe(struct platform_device *pdev)
