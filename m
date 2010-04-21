Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0DUPNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:13:55 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:52951 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab0DUPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:13:53 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv7 2.6.34-rc5 3/5] mx5: Enable board specific functions for enabling USB host on Babbage
Date: Wed, 21 Apr 2010 10:13:13 -0500
Message-Id: <1271862795-7986-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1271862795-7986-2-git-send-email-Dinh.Nguyen@freescale.com>
References: <1271862795-7986-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271862795-7986-2-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch enables USB host functionality for Host1 and OTG port on
Freescale MX51 Babbage HW. This patch contains the board specific
HW initialization of the USB HW.

This patch applies to 2.6.34-rc5.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Reviewed-by: Daniel Mack <daniel@caiaq.de>
---
 arch/arm/mach-mx5/board-mx51_babbage.c |  121 ++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index ee67a71..bd182d0 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -12,11 +12,15 @@
 
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/io.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
 #include <mach/iomux-mx51.h>
+#include <mach/mxc_ehci.h>
 
 #include <asm/irq.h>
 #include <asm/setup.h>
@@ -26,6 +30,9 @@
 
 #include "devices.h"
 
+#define BABBAGE_USB_HUB_RESET	(0*32 + 7)	/* GPIO_1_7 */
+#define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
+
 static struct platform_device *devices[] __initdata = {
 	&mxc_fec_device,
 };
@@ -46,6 +53,22 @@ static struct pad_desc mx51babbage_pads[] = {
 	MX51_PAD_EIM_D26__UART3_TXD,
 	MX51_PAD_EIM_D27__UART3_RTS,
 	MX51_PAD_EIM_D24__UART3_CTS,
+
+	/* USB HOST1 */
+	MX51_PAD_USBH1_CLK__USBH1_CLK,
+	MX51_PAD_USBH1_DIR__USBH1_DIR,
+	MX51_PAD_USBH1_NXT__USBH1_NXT,
+	MX51_PAD_USBH1_DATA0__USBH1_DATA0,
+	MX51_PAD_USBH1_DATA1__USBH1_DATA1,
+	MX51_PAD_USBH1_DATA2__USBH1_DATA2,
+	MX51_PAD_USBH1_DATA3__USBH1_DATA3,
+	MX51_PAD_USBH1_DATA4__USBH1_DATA4,
+	MX51_PAD_USBH1_DATA5__USBH1_DATA5,
+	MX51_PAD_USBH1_DATA6__USBH1_DATA6,
+	MX51_PAD_USBH1_DATA7__USBH1_DATA7,
+
+	/* USB HUB reset line*/
+	MX51_PAD_GPIO_1_7__GPIO1_7,
 };
 
 /* Serial ports */
@@ -66,15 +89,113 @@ static inline void mxc_init_imx_uart(void)
 }
 #endif /* SERIAL_IMX */
 
+static int gpio_usbh1_active(void)
+{
+	struct pad_desc usbh1stp_gpio = MX51_PAD_USBH1_STP__GPIO_1_27;
+	int ret;
+
+	/* Set USBH1_STP to GPIO and toggle it */
+	mxc_iomux_v3_setup_pad(&usbh1stp_gpio);
+	ret = gpio_request(BABBAGE_USBH1_STP, "usbh1_stp");
+
+	if (ret) {
+		pr_debug("failed to get MX51_PAD_USBH1_STP__GPIO_1_27: %d\n", ret);
+		return ret;
+	}
+	gpio_direction_output(BABBAGE_USBH1_STP, 0);
+	gpio_set_value(BABBAGE_USBH1_STP, 1);
+	msleep(100);
+	gpio_free(BABBAGE_USBH1_STP);
+	return 0;
+}
+
+static inline void babbage_usbhub_reset(void)
+{
+	int ret;
+
+	/* Bring USB hub out of reset */
+	ret = gpio_request(BABBAGE_USB_HUB_RESET, "GPIO1_7");
+	if (ret) {
+		printk(KERN_ERR"failed to get GPIO_USB_HUB_RESET: %d\n", ret);
+		return;
+	}
+	gpio_direction_output(BABBAGE_USB_HUB_RESET, 0);
+
+	/* USB HUB RESET - De-assert USB HUB RESET_N */
+	msleep(1);
+	gpio_set_value(BABBAGE_USB_HUB_RESET, 0);
+	msleep(1);
+	gpio_set_value(BABBAGE_USB_HUB_RESET, 1);
+}
+
+/* This function is board specific as the bit mask for the plldiv will also
+be different for other Freescale SoCs, thus a common bitmask is not
+possible and cannot get place in /plat-mxc/ehci.c.*/
+static int initialize_otg_port(struct platform_device *pdev)
+{
+	u32 v;
+	void __iomem *usb_base;
+	u32 usbother_base;
+
+	usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
+	usbother_base = usb_base + USBOTHER_REGS_OFFSET;
+
+	/* Set the PHY clock to 19.2MHz */
+	v = __raw_readl(usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
+	v &= ~USB_UTMI_PHYCTRL2_PLLDIV_MASK;
+	v |= USB_PLL_DIV_19_2_MHZ;
+	__raw_writel(v, usbother_base + USB_PHY_CTR_FUNC2_OFFSET);
+	iounmap(usb_base);
+	return 0;
+}
+
+static int initialize_usbh1_port(struct platform_device *pdev)
+{
+	u32 v;
+	void __iomem *usb_base;
+	u32 usbother_base;
+
+	usb_base = ioremap(MX51_OTG_BASE_ADDR, SZ_4K);
+	usbother_base = usb_base + USBOTHER_REGS_OFFSET;
+
+	/* The clock for the USBH1 ULPI port will come externally from the PHY. */
+	v = __raw_readl(usbother_base + USB_CTRL_1_OFFSET);
+	__raw_writel(v | USB_CTRL_UH1_EXT_CLK_EN, usbother_base + USB_CTRL_1_OFFSET);
+	iounmap(usb_base);
+	return 0;
+}
+
+static struct mxc_usbh_platform_data dr_utmi_config = {
+	.init		= initialize_otg_port,
+	.portsc	= MXC_EHCI_UTMI_16BIT,
+	.flags	= MXC_EHCI_INTERNAL_PHY,
+};
+
+static struct mxc_usbh_platform_data usbh1_config = {
+	.init		= initialize_usbh1_port,
+	.portsc	= MXC_EHCI_MODE_ULPI,
+	.flags	= (MXC_EHCI_POWER_PINS_ENABLED | MXC_EHCI_ITC_NO_THRESHOLD),
+};
+
 /*
  * Board specific initialization.
  */
 static void __init mxc_board_init(void)
 {
+	struct pad_desc usbh1stp = MX51_PAD_USBH1_STP__USBH1_STP;
+
 	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
 					ARRAY_SIZE(mx51babbage_pads));
 	mxc_init_imx_uart();
 	platform_add_devices(devices, ARRAY_SIZE(devices));
+
+	mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
+
+	gpio_usbh1_active();
+	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
+	/* setback USBH1_STP to be function */
+	mxc_iomux_v3_setup_pad(&usbh1stp);
+	babbage_usbhub_reset();
 }
 
 static void __init mx51_babbage_timer_init(void)
-- 
1.6.0.4

