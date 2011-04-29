Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1D2Mal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 08:30:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59298 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab1D2Mak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 08:30:40 -0400
From: srinath@mistralsolutions.com
To: linux-omap@vger.kernel.org
Cc: jdk@ti.com, tony@atomide.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        khilman@deeprootsystems.com, nm@ti.com, nagendra@mistralsolutions.com,
        umeshk@mistralsolutions.com, Srinath <srinath@mistralsolutions.com>
Subject: [PATCH 2/2] AM35xx-Craneboard:Display: Add DVI and TV Support
Date: Fri, 29 Apr 2011 17:11:01 +0530
Message-Id: <1304077261-17811-2-git-send-email-srinath@mistralsolutions.com>
X-Mailer: git-send-email 1.7.1.226.g770c5
In-Reply-To: <[PATCH]>
References: <[PATCH]>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinath <srinath@mistralsolutions.com>

Added Display (DVI and TV) support for CraneBoard.

Signed-off-by: Srinath <srinath@mistralsolutions.com>
---
 arch/arm/mach-omap2/board-am3517crane.c |   78 +++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-am3517crane.c b/arch/arm/mach-omap2/board-am3517crane.c
index 05867b5..83fe85b 100644
--- a/arch/arm/mach-omap2/board-am3517crane.c
+++ b/arch/arm/mach-omap2/board-am3517crane.c
@@ -29,12 +29,15 @@
 #include <plat/board.h>
 #include <plat/common.h>
 #include <plat/usb.h>
+#include <plat/display.h>
+#include <plat/panel-generic-dpi.h>
 
 #include "mux.h"
 #include "control.h"
 
 #define GPIO_USB_POWER		35
 #define GPIO_USB_NRESET		38
+#define GPIO_DVI_ENABLE		52
 
 
 /* Board initialization */
@@ -66,11 +69,83 @@ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
 	.reset_gpio_port[2]  = -EINVAL
 };
 
+static void __init am3517_crane_display_init(void)
+{
+	int ret;
+
+	ret = omap_mux_init_gpio(GPIO_DVI_ENABLE, OMAP_PIN_OUTPUT);
+	if (ret < 0) {
+		pr_err("Can not configure mux for GPIO_DVI_ENABLE %d\n",
+			GPIO_DVI_ENABLE);
+		return;
+	}
+
+	ret = gpio_request(GPIO_DVI_ENABLE, "dvi_enable");
+	if (ret < 0) {
+		pr_err("Can not request GPIO %d\n", GPIO_DVI_ENABLE);
+		return;
+	}
+
+	ret = gpio_direction_output(GPIO_DVI_ENABLE, 1);
+	if (ret < 0) {
+		gpio_free(GPIO_DVI_ENABLE);
+		pr_err("Unable to enable DVI\n");
+		return;
+	}
+}
+
+static struct omap_dss_device am3517_crane_tv_device = {
+	.type                   = OMAP_DISPLAY_TYPE_VENC,
+	.name                   = "tv",
+	.driver_name            = "venc",
+	.phy.venc.type          = OMAP_DSS_VENC_TYPE_COMPOSITE,
+	.platform_enable        = NULL,
+	.platform_disable       = NULL,
+};
+
+static int am3517_crane_panel_enable_dvi(struct omap_dss_device *dssdev)
+{
+	gpio_set_value(GPIO_DVI_ENABLE, 1);
+	return 0;
+}
+
+static void am3517_crane_panel_disable_dvi(struct omap_dss_device *dssdev)
+{
+	gpio_set_value(GPIO_DVI_ENABLE, 0);
+}
+
+
+static struct panel_generic_dpi_data dvi_panel = {
+	.name                   = "generic",
+	.platform_enable        = am3517_crane_panel_enable_dvi,
+	.platform_disable       = am3517_crane_panel_disable_dvi,
+};
+
+static struct omap_dss_device am3517_crane_dvi_device = {
+	.type                   = OMAP_DISPLAY_TYPE_DPI,
+	.name                   = "dvi",
+	.driver_name            = "generic_dpi_panel",
+	.data                   = &dvi_panel,
+	.phy.dpi.data_lines     = 24,
+};
+
+static struct omap_dss_device *am3517_crane_dss_devices[] = {
+	&am3517_crane_tv_device,
+	&am3517_crane_dvi_device,
+};
+
+static struct omap_dss_board_info am3517_crane_dss_data = {
+	.num_devices    = ARRAY_SIZE(am3517_crane_dss_devices),
+	.devices        = am3517_crane_dss_devices,
+	.default_device = &am3517_crane_dvi_device,
+};
+
 static void __init am3517_crane_init(void)
 {
 	int ret;
 
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
+	omap_display_init(&am3517_crane_dss_data);
 	omap_serial_init();
 
 	omap_board_config = am3517_crane_config;
@@ -103,6 +178,9 @@ static void __init am3517_crane_init(void)
 	}
 
 	usbhs_init(&usbhs_bdata);
+
+	/* DSS */
+	am3517_crane_display_init();
 }
 
 MACHINE_START(CRANEBOARD, "AM3517/05 CRANEBOARD")
-- 
1.7.1.226.g770c5

