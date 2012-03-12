Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab2CLVzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:55:48 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:29596 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752531Ab2CLVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:55:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v8 3/4] USB: ohci-nxp: Support for LPC32xx
Date: Mon, 12 Mar 2012 22:54:51 +0100
Message-Id: <1331589292-18986-4-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331589292-18986-1-git-send-email-stigge@antcom.de>
References: <1331589292-18986-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the LPC32xx to ohci-nxp

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 drivers/usb/host/ohci-hcd.c |    2 +-
 drivers/usb/host/ohci-nxp.c |  142 ++++++++++++++++++++++++++++++++----------
 2 files changed, 109 insertions(+), 35 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index c190962..1c1a506 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1050,7 +1050,7 @@ MODULE_LICENSE ("GPL");
 #define PLATFORM_DRIVER		ohci_hcd_at91_driver
 #endif
 
-#ifdef CONFIG_ARCH_PNX4008
+#if defined(CONFIG_ARCH_PNX4008) || defined(CONFIG_ARCH_LPC32XX)
 #include "ohci-nxp.c"
 #define PLATFORM_DRIVER		usb_hcd_nxp_driver
 #endif
diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index a12c6b4..e7cc7b6 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -3,6 +3,7 @@
  *
  * Currently supported OHCI host devices:
  * - Philips PNX4008
+ * - NXP LPC32xx
  *
  * Authors: Dmitry Chigirev <source@mvista.com>
  *	    Vitaly Wool <vitalywool@gmail.com>
@@ -23,20 +24,24 @@
 #include <linux/i2c.h>
 
 #include <mach/hardware.h>
+#include <asm/mach-types.h>
 #include <asm/io.h>
 
 #include <mach/platform.h>
 #include <mach/irqs.h>
 #include <asm/gpio.h>
 
-#define USB_CTRL	IO_ADDRESS(PNX4008_PWRMAN_BASE + 0x64)
+#define USB_CONFIG_BASE		0x31020000
+#define PWRMAN_BASE		0x40004000
+
+#define USB_CTRL		IO_ADDRESS(PWRMAN_BASE + 0x64)
 
 /* USB_CTRL bit defines */
 #define USB_SLAVE_HCLK_EN	(1 << 24)
 #define USB_HOST_NEED_CLK_EN	(1 << 21)
 
-#define USB_OTG_CLK_CTRL	IO_ADDRESS(PNX4008_USB_CONFIG_BASE + 0xFF4)
-#define USB_OTG_CLK_STAT	IO_ADDRESS(PNX4008_USB_CONFIG_BASE + 0xFF8)
+#define USB_OTG_CLK_CTRL	IO_ADDRESS(USB_CONFIG_BASE + 0xFF4)
+#define USB_OTG_CLK_STAT	IO_ADDRESS(USB_CONFIG_BASE + 0xFF8)
 
 /* USB_OTG_CLK_CTRL bit defines */
 #define AHB_M_CLOCK_ON		(1 << 4)
@@ -45,7 +50,7 @@
 #define DEV_CLOCK_ON		(1 << 1)
 #define HOST_CLOCK_ON		(1 << 0)
 
-#define USB_OTG_STAT_CONTROL	IO_ADDRESS(PNX4008_USB_CONFIG_BASE + 0x110)
+#define USB_OTG_STAT_CONTROL	IO_ADDRESS(USB_CONFIG_BASE + 0x110)
 
 /* USB_OTG_STAT_CONTROL bit defines */
 #define TRANSPARENT_I2C_EN	(1 << 7)
@@ -99,6 +104,15 @@
 #define ISP1301_I2C_INTERRUPT_RISING 0xE
 #define ISP1301_I2C_REG_CLEAR_ADDR 1
 
+/* On LPC32xx, those are undefined */
+#ifndef start_int_set_falling_edge
+#define start_int_set_falling_edge(irq)
+#define start_int_set_rising_edge(irq)
+#define start_int_ack(irq)
+#define start_int_mask(irq)
+#define start_int_umask(irq)
+#endif
+
 static struct i2c_driver isp1301_driver;
 static struct i2c_client *isp1301_i2c_client;
 
@@ -144,7 +158,7 @@ static void i2c_write(u8 buf, u8 subaddr)
 	i2c_master_send(isp1301_i2c_client, &tmpbuf[0], 2);
 }
 
-static void isp1301_configure(void)
+static void isp1301_configure_pnx4008(void)
 {
 	/* PNX4008 only supports DAT_SE0 USB mode */
 	/* PNX4008 R2A requires setting the MAX603 to output 3.6V */
@@ -167,7 +181,63 @@ static void isp1301_configure(void)
 		  ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR);
 	i2c_write(0xFF,
 		  ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR);
+}
 
+static void isp1301_configure_lpc32xx(void)
+{
+	/* LPC32XX only supports DAT_SE0 USB mode */
+	/* This sequence is important */
+
+	/* Disable transparent UART mode first */
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		(ISP1301_I2C_MODE_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR),
+		MC1_UART_EN);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		(ISP1301_I2C_MODE_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR),
+		~MC1_SPEED_REG);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+				  ISP1301_I2C_MODE_CONTROL_1, MC1_SPEED_REG);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		  (ISP1301_I2C_MODE_CONTROL_2 | ISP1301_I2C_REG_CLEAR_ADDR),
+		  ~0);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_2,
+		(MC2_BI_DI | MC2_PSW_EN | MC2_SPD_SUSP_CTRL));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		(ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR), ~0);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_MODE_CONTROL_1, MC1_DAT_SE0);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_OTG_CONTROL_1,
+		(OTG1_DM_PULLDOWN | OTG1_DP_PULLDOWN));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		(ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR),
+		(OTG1_DM_PULLUP | OTG1_DP_PULLUP));
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_LATCH | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_FALLING | ISP1301_I2C_REG_CLEAR_ADDR,
+		~0);
+	i2c_smbus_write_byte_data(isp1301_i2c_client,
+		ISP1301_I2C_INTERRUPT_RISING | ISP1301_I2C_REG_CLEAR_ADDR, ~0);
+
+	/* Enable usb_need_clk clock after transceiver is initialized */
+	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);
+
+	printk(KERN_INFO "ISP1301 Vendor ID  : 0x%04x\n",
+	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x00));
+	printk(KERN_INFO "ISP1301 Product ID : 0x%04x\n",
+	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x02));
+	printk(KERN_INFO "ISP1301 Version ID : 0x%04x\n",
+	      i2c_smbus_read_word_data(isp1301_i2c_client, 0x14));
+}
+
+static void isp1301_configure(void)
+{
+	if (machine_is_pnx4008())
+		isp1301_configure_pnx4008();
+	else
+		isp1301_configure_lpc32xx();
 }
 
 static inline void isp1301_vbus_on(void)
@@ -258,39 +328,43 @@ static const struct hc_driver ohci_nxp_hc_driver = {
 
 static void nxp_set_usb_bits(void)
 {
-	start_int_set_falling_edge(SE_USB_OTG_ATX_INT_N);
-	start_int_ack(SE_USB_OTG_ATX_INT_N);
-	start_int_umask(SE_USB_OTG_ATX_INT_N);
-
-	start_int_set_rising_edge(SE_USB_OTG_TIMER_INT);
-	start_int_ack(SE_USB_OTG_TIMER_INT);
-	start_int_umask(SE_USB_OTG_TIMER_INT);
-
-	start_int_set_rising_edge(SE_USB_I2C_INT);
-	start_int_ack(SE_USB_I2C_INT);
-	start_int_umask(SE_USB_I2C_INT);
-
-	start_int_set_rising_edge(SE_USB_INT);
-	start_int_ack(SE_USB_INT);
-	start_int_umask(SE_USB_INT);
-
-	start_int_set_rising_edge(SE_USB_NEED_CLK_INT);
-	start_int_ack(SE_USB_NEED_CLK_INT);
-	start_int_umask(SE_USB_NEED_CLK_INT);
-
-	start_int_set_rising_edge(SE_USB_AHB_NEED_CLK_INT);
-	start_int_ack(SE_USB_AHB_NEED_CLK_INT);
-	start_int_umask(SE_USB_AHB_NEED_CLK_INT);
+	if (machine_is_pnx4008()) {
+		start_int_set_falling_edge(SE_USB_OTG_ATX_INT_N);
+		start_int_ack(SE_USB_OTG_ATX_INT_N);
+		start_int_umask(SE_USB_OTG_ATX_INT_N);
+
+		start_int_set_rising_edge(SE_USB_OTG_TIMER_INT);
+		start_int_ack(SE_USB_OTG_TIMER_INT);
+		start_int_umask(SE_USB_OTG_TIMER_INT);
+
+		start_int_set_rising_edge(SE_USB_I2C_INT);
+		start_int_ack(SE_USB_I2C_INT);
+		start_int_umask(SE_USB_I2C_INT);
+
+		start_int_set_rising_edge(SE_USB_INT);
+		start_int_ack(SE_USB_INT);
+		start_int_umask(SE_USB_INT);
+
+		start_int_set_rising_edge(SE_USB_NEED_CLK_INT);
+		start_int_ack(SE_USB_NEED_CLK_INT);
+		start_int_umask(SE_USB_NEED_CLK_INT);
+
+		start_int_set_rising_edge(SE_USB_AHB_NEED_CLK_INT);
+		start_int_ack(SE_USB_AHB_NEED_CLK_INT);
+		start_int_umask(SE_USB_AHB_NEED_CLK_INT);
+	}
 }
 
 static void nxp_unset_usb_bits(void)
 {
-	start_int_mask(SE_USB_OTG_ATX_INT_N);
-	start_int_mask(SE_USB_OTG_TIMER_INT);
-	start_int_mask(SE_USB_I2C_INT);
-	start_int_mask(SE_USB_INT);
-	start_int_mask(SE_USB_NEED_CLK_INT);
-	start_int_mask(SE_USB_AHB_NEED_CLK_INT);
+	if (machine_is_pnx4008()) {
+		start_int_mask(SE_USB_OTG_ATX_INT_N);
+		start_int_mask(SE_USB_OTG_TIMER_INT);
+		start_int_mask(SE_USB_I2C_INT);
+		start_int_mask(SE_USB_INT);
+		start_int_mask(SE_USB_NEED_CLK_INT);
+		start_int_mask(SE_USB_AHB_NEED_CLK_INT);
+	}
 }
 
 static int __devinit usb_hcd_nxp_probe(struct platform_device *pdev)
-- 
1.7.9

