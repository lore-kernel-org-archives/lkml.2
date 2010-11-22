Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0KVIzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:55:35 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58594 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0KVIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:55:33 -0500
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nm@ti.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com, sshtylyov@mvista.com,
        Srinath <srinath@mistralsolutions.com>
Subject: [Patch v2] AM35xx: Craneboard: Add USB EHCI support
Date: Mon, 22 Nov 2010 14:02:16 +0530
Message-Id: <1290414736-21973-1-git-send-email-srinath@mistralsolutions.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
In-Reply-To: <[PATCH] AM35xx-Craneboard-Add-USB-EHCI-support>
References: <[PATCH] AM35xx-Craneboard-Add-USB-EHCI-support>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinath <srinath@mistralsolutions.com>

AM3517/05 Craneboard has one EHCI interface on board using port1.

GPIO35 is used as power enable.
GPIO38 is used as port1 PHY reset.

Signed-off-by: Srinath <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 13ead33..91791bc 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -28,8 +28,10 @@
 
 #include <plat/board.h>
 #include <plat/common.h>
+#include <plat/usb.h>
 
 #include "mux.h"
+#include "control.h"
 
 /* Board initialization */
 static struct omap_board_config_kernel am3517_crane_config[] __initdata = {
@@ -53,10 +55,28 @@ static void __init am3517_crane_init_irq(void)
 	omap_gpio_init();
 }
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = 38,
+	.reset_gpio_port[1]  = -EINVAL,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init am3517_crane_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 	omap_serial_init();
+
+	/* Configure GPIO for EHCI port */
+	omap_mux_init_gpio(35, OMAP_PIN_OUTPUT);
+	gpio_request(35, "usb_ehci_enable");
+	gpio_direction_output(35, 1);
+	omap_mux_init_gpio(38, OMAP_PIN_OUTPUT);
+	usb_ehci_init(&ehci_pdata);
 }
 
 MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
-- 
1.7.1.226.g770c5

