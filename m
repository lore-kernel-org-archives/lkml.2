Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0EJSqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:46:48 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40843 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab0EJSq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:46:26 -0400
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv3 2.6.34-rc7 3/3] mx5: enable usb gadget for freescale mx51 babbage board
Date: Mon, 10 May 2010 13:45:59 -0500
Message-Id: <1273517159-25173-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1273517159-25173-2-git-send-email-Dinh.Nguyen@freescale.com>
References: <1273517159-25173-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1273517159-25173-2-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables usb gadget for freescale mx51 babbage hw. By default,
the OTG port will be in device mode. To put the OTG port into Host mode,
pass "otg_mode=host" in the exec command.

This patch applies to 2.6.34-rc7.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/board-mx51_babbage.c |   28 +++++++++++++++++++++++++++-
 arch/arm/mach-mx5/clock-mx51.c         |    2 ++
 arch/arm/mach-mx5/devices.c            |   12 ++++++++++++
 arch/arm/mach-mx5/devices.h            |    1 +
 4 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index 99f7ea9..dacf506 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -15,6 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/fsl_devices.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
@@ -179,12 +180,32 @@ static struct mxc_usbh_platform_data dr_utmi_config = {
 	.flags	= MXC_EHCI_INTERNAL_PHY,
 };
 
+static struct fsl_usb2_platform_data usb_pdata = {
+	.operating_mode	= FSL_USB2_DR_DEVICE,
+	.phy_mode	= FSL_USB2_PHY_UTMI_WIDE,
+};
+
 static struct mxc_usbh_platform_data usbh1_config = {
 	.init		= initialize_usbh1_port,
 	.portsc	= MXC_EHCI_MODE_ULPI,
 	.flags	= (MXC_EHCI_POWER_PINS_ENABLED | MXC_EHCI_ITC_NO_THRESHOLD),
 };
 
+static int otg_mode_host;
+
+static int __init babbage_otg_mode(char *options)
+{
+	if (!strcmp(options, "host"))
+		otg_mode_host = 1;
+	else if (!strcmp(options, "device"))
+		otg_mode_host = 0;
+	else
+		pr_info("otg_mode neither \"host\" nor \"device\". "
+			"Defaulting to device\n");
+	return 0;
+}
+__setup("otg_mode=", babbage_otg_mode);
+
 /*
  * Board specific initialization.
  */
@@ -197,7 +218,12 @@ static void __init mxc_board_init(void)
 	mxc_init_imx_uart();
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
-	mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
+	if (otg_mode_host)
+		mxc_register_device(&mxc_usbdr_host_device, &dr_utmi_config);
+	else {
+		initialize_otg_port(NULL);
+		mxc_register_device(&mxc_usbdr_udc_device, &usb_pdata);
+	}
 
 	gpio_usbh1_active();
 	mxc_register_device(&mxc_usbh1_device, &usbh1_config);
diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
index b63ba71..d9f612d 100644
--- a/arch/arm/mach-mx5/clock-mx51.c
+++ b/arch/arm/mach-mx5/clock-mx51.c
@@ -819,6 +819,8 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
 	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
 	_REGISTER_CLOCK("mxc-ehci.1", "usb_ahb", ahb_clk)
+	_REGISTER_CLOCK("fsl-usb2-udc", "usb", usboh3_clk)
+	_REGISTER_CLOCK("fsl-usb2-udc", "usb_ahb", ahb_clk)
 };
 
 static void clk_tree_init(void)
diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index e6262f3..23850e6 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -107,6 +107,18 @@ static struct resource usbotg_resources[] = {
 	},
 };
 
+/* OTG gadget device */
+struct platform_device mxc_usbdr_udc_device = {
+	.name		= "fsl-usb2-udc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(usbotg_resources),
+	.resource	= usbotg_resources,
+	.dev		= {
+		.dma_mask		= &usb_dma_mask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+	},
+};
+
 struct platform_device mxc_usbdr_host_device = {
 	.name = "mxc-ehci",
 	.id = 0,
diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
index 95c45f9..0494d6b 100644
--- a/arch/arm/mach-mx5/devices.h
+++ b/arch/arm/mach-mx5/devices.h
@@ -4,3 +4,4 @@ extern struct platform_device mxc_uart_device2;
 extern struct platform_device mxc_fec_device;
 extern struct platform_device mxc_usbdr_host_device;
 extern struct platform_device mxc_usbh1_device;
+extern struct platform_device mxc_usbdr_udc_device;
-- 
1.6.0.4

