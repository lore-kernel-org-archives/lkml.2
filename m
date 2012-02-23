Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2BWU6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:58:11 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:43285 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756663Ab2BWU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:58:10 -0500
From: Roland Stigge <stigge@antcom.de>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2] USB: Support for LPC32xx SoC
Date: Thu, 23 Feb 2012 21:57:18 +0100
Message-Id: <1330030639-3796-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds OHCI support to the LPC32xx ARM platform

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/usb/host/ohci-hcd.c     |    5 +++
 drivers/usb/host/ohci-pnx4008.c |   53 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 57 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/usb/host/ohci-hcd.c
+++ linux-2.6/drivers/usb/host/ohci-hcd.c
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
--- linux-2.6.orig/drivers/usb/host/ohci-pnx4008.c
+++ linux-2.6/drivers/usb/host/ohci-pnx4008.c
@@ -143,8 +143,21 @@ static void i2c_write(u8 buf, u8 subaddr
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
@@ -166,7 +179,41 @@ static void isp1301_configure(void)
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
@@ -257,6 +304,7 @@ static const struct hc_driver ohci_pnx40
 
 static void pnx4008_set_usb_bits(void)
 {
+#if !defined(CONFIG_ARCH_LPC32XX)
 	start_int_set_falling_edge(SE_USB_OTG_ATX_INT_N);
 	start_int_ack(SE_USB_OTG_ATX_INT_N);
 	start_int_umask(SE_USB_OTG_ATX_INT_N);
@@ -280,16 +328,19 @@ static void pnx4008_set_usb_bits(void)
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
