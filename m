Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1I2OZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:25:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:32828 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1I2OZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:25:43 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>
Subject: [PATCH 3/5 v12] arm: omap: usb: register hwmods of usbhs
Date: Thu, 29 Sep 2011 19:54:05 +0530
Message-ID: <1317306247-1103-4-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1317306247-1103-3-git-send-email-keshava_mgowda@ti.com>
References: <1317306247-1103-1-git-send-email-keshava_mgowda@ti.com>
 <1317306247-1103-2-git-send-email-keshava_mgowda@ti.com>
 <1317306247-1103-3-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwmod structure of usb_host_hs  and usb_tll are
retrieved and registered with omap device

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Reviewed-by: Partha Basak <parthab@india.ti.com>
---
 arch/arm/mach-omap2/usb-host.c |  100 ++++++++++++++--------------------------
 1 files changed, 34 insertions(+), 66 deletions(-)

diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
index 89ae298..771dc78 100644
--- a/arch/arm/mach-omap2/usb-host.c
+++ b/arch/arm/mach-omap2/usb-host.c
@@ -28,51 +28,28 @@
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <plat/usb.h>
+#include <plat/omap_device.h>
 
 #include "mux.h"
 
 #ifdef CONFIG_MFD_OMAP_USB_HOST
 
-#define OMAP_USBHS_DEVICE	"usbhs-omap"
-
-static struct resource usbhs_resources[] = {
-	{
-		.name	= "uhh",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "tll",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "ehci",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "ehci-irq",
-		.flags	= IORESOURCE_IRQ,
-	},
-	{
-		.name	= "ohci",
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "ohci-irq",
-		.flags	= IORESOURCE_IRQ,
-	}
-};
-
-static struct platform_device usbhs_device = {
-	.name		= OMAP_USBHS_DEVICE,
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(usbhs_resources),
-	.resource	= usbhs_resources,
-};
+#define OMAP_USBHS_DEVICE	"usbhs_omap"
+#define	USBHS_UHH_HWMODNAME	"usb_host_hs"
+#define USBHS_TLL_HWMODNAME	"usb_tll_hs"
 
 static struct usbhs_omap_platform_data		usbhs_data;
 static struct ehci_hcd_omap_platform_data	ehci_data;
 static struct ohci_hcd_omap_platform_data	ohci_data;
 
+static struct omap_device_pm_latency omap_uhhtll_latency[] = {
+	  {
+		.deactivate_func = omap_device_idle_hwmods,
+		.activate_func	 = omap_device_enable_hwmods,
+		.flags = OMAP_DEVICE_LATENCY_AUTO_ADJUST,
+	  },
+};
+
 /* MUX settings for EHCI pins */
 /*
  * setup_ehci_io_mux - initialize IO pad mux for USBHOST
@@ -508,7 +485,10 @@ static void setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
 
 void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 {
-	int	i;
+	struct omap_hwmod	*oh[2];
+	struct omap_device	*od;
+	int			bus_id = -1;
+	int			i;
 
 	for (i = 0; i < OMAP3_HS_USB_PORTS; i++) {
 		usbhs_data.port_mode[i] = pdata->port_mode[i];
@@ -523,44 +503,34 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 	usbhs_data.ohci_data = &ohci_data;
 
 	if (cpu_is_omap34xx()) {
-		usbhs_resources[0].start = OMAP34XX_UHH_CONFIG_BASE;
-		usbhs_resources[0].end = OMAP34XX_UHH_CONFIG_BASE + SZ_1K - 1;
-		usbhs_resources[1].start = OMAP34XX_USBTLL_BASE;
-		usbhs_resources[1].end = OMAP34XX_USBTLL_BASE + SZ_4K - 1;
-		usbhs_resources[2].start	= OMAP34XX_EHCI_BASE;
-		usbhs_resources[2].end	= OMAP34XX_EHCI_BASE + SZ_1K - 1;
-		usbhs_resources[3].start = INT_34XX_EHCI_IRQ;
-		usbhs_resources[4].start	= OMAP34XX_OHCI_BASE;
-		usbhs_resources[4].end	= OMAP34XX_OHCI_BASE + SZ_1K - 1;
-		usbhs_resources[5].start = INT_34XX_OHCI_IRQ;
 		setup_ehci_io_mux(pdata->port_mode);
 		setup_ohci_io_mux(pdata->port_mode);
 	} else if (cpu_is_omap44xx()) {
-		usbhs_resources[0].start = OMAP44XX_UHH_CONFIG_BASE;
-		usbhs_resources[0].end = OMAP44XX_UHH_CONFIG_BASE + SZ_1K - 1;
-		usbhs_resources[1].start = OMAP44XX_USBTLL_BASE;
-		usbhs_resources[1].end = OMAP44XX_USBTLL_BASE + SZ_4K - 1;
-		usbhs_resources[2].start = OMAP44XX_HSUSB_EHCI_BASE;
-		usbhs_resources[2].end = OMAP44XX_HSUSB_EHCI_BASE + SZ_1K - 1;
-		usbhs_resources[3].start = OMAP44XX_IRQ_EHCI;
-		usbhs_resources[4].start = OMAP44XX_HSUSB_OHCI_BASE;
-		usbhs_resources[4].end = OMAP44XX_HSUSB_OHCI_BASE + SZ_1K - 1;
-		usbhs_resources[5].start = OMAP44XX_IRQ_OHCI;
 		setup_4430ehci_io_mux(pdata->port_mode);
 		setup_4430ohci_io_mux(pdata->port_mode);
 	}
 
-	if (platform_device_add_data(&usbhs_device,
-				&usbhs_data, sizeof(usbhs_data)) < 0) {
-		printk(KERN_ERR "USBHS platform_device_add_data failed\n");
-		goto init_end;
+	oh[0] = omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
+	if (!oh[0]) {
+		pr_err("Could not look up %s\n", USBHS_UHH_HWMODNAME);
+		return;
 	}
 
-	if (platform_device_register(&usbhs_device) < 0)
-		printk(KERN_ERR "USBHS platform_device_register failed\n");
+	oh[1] = omap_hwmod_lookup(USBHS_TLL_HWMODNAME);
+	if (!oh[1]) {
+		pr_err("Could not look up %s\n", USBHS_TLL_HWMODNAME);
+		return;
+	}
 
-init_end:
-	return;
+	od = omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
+				(void *)&usbhs_data, sizeof(usbhs_data),
+				omap_uhhtll_latency,
+				ARRAY_SIZE(omap_uhhtll_latency), false);
+	if (IS_ERR(od)) {
+		pr_err("Could not build hwmod devices %s,%s\n",
+			USBHS_UHH_HWMODNAME, USBHS_TLL_HWMODNAME);
+		return;
+	}
 }
 
 #else
@@ -570,5 +540,3 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
 }
 
 #endif
-
-
-- 
1.6.0.4

