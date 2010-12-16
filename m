Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab0LPPw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:52:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51795 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0LPPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:52:55 -0500
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nm@ti.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com, sshtylyov@mvista.com, manjugk@ti.com,
        Srinath <srinath@mistralsolutions.com>
Subject: [Patch v4] AM35xx: Craneboard: Add USB EHCI support
Date: Thu, 16 Dec 2010 20:55:12 +0530
Message-Id: <1292513112-12471-1-git-send-email-srinath@mistralsolutions.com>
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

History:
http://marc.info/?l=linux-omap&w=2&r=1&s=Craneboard%3A+Add+USB+EHCI+support&q=t

Signed-off-by: Srinath <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   53 +++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 8ba4047..1a80175 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -19,6 +19,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -27,8 +28,14 @@
 
 #include <plat/board.h>
 #include <plat/common.h>
+#include <plat/usb.h>
 
 #include "mux.h"
+#include "control.h"
+
+#define GPIO_USB_POWER		35
+#define GPIO_USB_NRESET		38
+
 
 /* Board initialization */
 static struct omap_board_config_kernel am3517_crane_config[] __initdata = {
@@ -51,10 +58,56 @@ static void __init am3517_crane_init_irq(void)
 	omap_init_irq();
 }
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initdata = {
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = GPIO_USB_NRESET,
+	.reset_gpio_port[1]  = -EINVAL,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init am3517_crane_init(void)
 {
+	int ret;
+
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
 	omap_serial_init();
+
+	/* Configure GPIO for EHCI port */
+	if (omap_mux_init_gpio(GPIO_USB_NRESET, OMAP_PIN_OUTPUT)) {
+		pr_err("Can not cofigure mux for GPIO_USB_NRESET %d\n",
+			GPIO_USB_NRESET);
+		return;
+	}
+
+	if (omap_mux_init_gpio(GPIO_USB_POWER, OMAP_PIN_OUTPUT)) {
+		pr_err("Can not cofigure mux for GPIO_USB_POWER %d\n",
+
+			GPIO_USB_POWER);
+		return;
+	}
+
+	ret = gpio_request(GPIO_USB_POWER, "usb_ehci_enable");
+	if (ret < 0) {
+		pr_err("Cannot request GPIO %d\n", GPIO_USB_POWER);
+		return;
+	}
+
+	ret = gpio_direction_output(GPIO_USB_POWER, 1);
+	if (ret < 0)
+		goto err;
+
+
+	usb_ehci_init(&ehci_pdata);
+	return;
+
+err:
+	gpio_free(GPIO_USB_POWER);
+	pr_err("Unable to initialize EHCI power\n");
+	return;
 }
 
 MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
-- 
1.7.1.226.g770c5

