Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3AJQwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:52:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54091 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3AJQwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:06 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 11/14] ARM: OMAP2+: omap4panda: Provide USB Host's PHY platform data
Date: Thu, 10 Jan 2013 18:51:31 +0200
Message-ID: <1357836694-30788-12-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide platform data for the USB host's PHY.

Also get rid of managing PHY clock. This will now be done by the phy driver.
For that to work we create a clock alias that links the PHY clock name to the
PHY device name.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-omap4panda.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index ee76830..350c4db 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -30,6 +30,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/ti_wilink_st.h>
 #include <linux/usb/musb.h>
+#include <linux/usb/nop-usb-xceiv.h>
 #include <linux/wl12xx.h>
 #include <linux/platform_data/omap-abe-twl6040.h>
 
@@ -139,6 +140,18 @@ static struct platform_device *panda_devices[] __initdata = {
 	&btwilink_device,
 };
 
+static struct nop_usb_xceiv_platform_data phy_pdata0 = {
+	.type = USB_PHY_TYPE_UNDEFINED,
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	.clk_rate = 19200000,
+};
+
+static struct usbhs_phy_config phy_config0 = {
+	.name = "nop_usb_xceiv",
+	.pdata = &phy_pdata0,
+	.pdata_size = sizeof(phy_pdata0),
+};
+
 static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.port_mode[0] = OMAP_EHCI_PORT_MODE_PHY,
 	.port_mode[1] = OMAP_USBHS_PORT_MODE_UNUSED,
@@ -146,7 +159,8 @@ static struct usbhs_omap_platform_data usbhs_bdata __initdata = {
 	.phy_reset  = false,
 	.reset_gpio_port[0]  = -EINVAL,
 	.reset_gpio_port[1]  = -EINVAL,
-	.reset_gpio_port[2]  = -EINVAL
+	.reset_gpio_port[2]  = -EINVAL,
+	.phy_config[0] = &phy_config0,
 };
 
 static struct gpio panda_ehci_gpios[] __initdata = {
@@ -157,16 +171,6 @@ static struct gpio panda_ehci_gpios[] __initdata = {
 static void __init omap4_ehci_init(void)
 {
 	int ret;
-	struct clk *phy_ref_clk;
-
-	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
-	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
-	if (IS_ERR(phy_ref_clk)) {
-		pr_err("Cannot request auxclk3\n");
-		return;
-	}
-	clk_set_rate(phy_ref_clk, 19200000);
-	clk_prepare_enable(phy_ref_clk);
 
 	/* disable the power to the usb hub prior to init and reset phy+hub */
 	ret = gpio_request_array(panda_ehci_gpios,
@@ -180,6 +184,11 @@ static void __init omap4_ehci_init(void)
 	gpio_export(GPIO_HUB_NRESET, 0);
 	gpio_set_value(GPIO_HUB_NRESET, 1);
 
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	ret = clk_add_alias("main_clk", "nop_usb_xceiv.0", "auxclk3_ck", NULL);
+	if (ret)
+		pr_err("Failed to add main_clk alias to auxclk3_ck\n");
+
 	usbhs_init(&usbhs_bdata);
 
 	/* enable power to hub */
-- 
1.7.4.1

