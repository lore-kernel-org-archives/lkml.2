Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab1AJOmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:42:45 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42741 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab1AJOmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:42:42 -0500
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anand Gadiyar <gadiyar@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH] arm: omap4: pandaboard: turn on PHY reference clock at init
Date: Mon, 10 Jan 2011 20:12:15 +0530
Message-Id: <1294670535-9059-1-git-send-email-gadiyar@ti.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SMSC 3320 USB PHY on the OMAP4 Pandaboard needs a 19.2 MHz
reference clock. This clock is provided from the OMAP4's fref_clk3
pad.

Recent changes to clock44xx_data.c made the clock framework aware
of the existence of these fref_clk[i] lines. If the option
CONFIG_OMAP_RESET_CLOCKS is enabled in the kernel, then the
clock framework will turn these clocks off during bootup.

Explicitly request and keep this clock enabled at init for the
Pandaboard, so that the PHY receives this clock at all times.

Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
---
Tony,

The clock database changes were merged just before Christmas, so
we did not detect this sooner. Would be nice to get this merged in
the -rc series, so that we get EHCI and ethernet functional on the Panda.

Ming Lei,

Could you please test this and confirm it fixes the issue for you?

- Anand

 arch/arm/mach-omap2/board-omap4panda.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/board-omap4panda.c
+++ linux-2.6/arch/arm/mach-omap2/board-omap4panda.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/leds.h>
 #include <linux/gpio.h>
@@ -95,7 +96,16 @@ static const struct ehci_hcd_omap_platfo
 static void __init omap4_ehci_init(void)
 {
 	int ret;
+	struct clk *phy_ref_clk;
 
+	/* FREF_CLK3 provides the 19.2 MHz reference clock to the PHY */
+	phy_ref_clk = clk_get(NULL, "auxclk3_ck");
+	if (IS_ERR(phy_ref_clk)) {
+		pr_err("Cannot request auxclk3\n");
+		goto error1;
+	}
+	clk_set_rate(phy_ref_clk, 19200000);
+	clk_enable(phy_ref_clk);
 
 	/* disable the power to the usb hub prior to init */
 	ret = gpio_request(GPIO_HUB_POWER, "hub_power");
