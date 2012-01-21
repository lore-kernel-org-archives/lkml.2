Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab2AVACn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37108 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2AVACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:15 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:35 2012
Subject: [PATCH 7/8] ARM: OMAP2+: HDQ1W: use omap_device
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Date: Sat, 21 Jan 2012 16:59:35 -0700
Message-ID: <20120121235934.17619.61644.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the old-style device registration code for HDQ1W to use
omap_device.  This will allow the driver to be converted to use PM
runtime and to take advantage of the OMAP IP block management
infrastructure (hwmod, PM, etc.).

A side benefit of this conversion is that it also makes the HDQ device
available on OMAP2420.  The previous code only enabled it on 2430 and
3430.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
---
 arch/arm/mach-omap2/devices.c |   37 -------------------------------------
 arch/arm/mach-omap2/hdq1w.c   |   26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 0b510ad0..cf68525 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -650,42 +650,6 @@ void __init omap242x_init_mmc(struct omap_mmc_platform_data **mmc_data)
 
 #endif
 
-/*-------------------------------------------------------------------------*/
-
-#if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
-#if defined(CONFIG_SOC_OMAP2430) || defined(CONFIG_SOC_OMAP3430)
-#define OMAP_HDQ_BASE	0x480B2000
-#endif
-static struct resource omap_hdq_resources[] = {
-	{
-		.start		= OMAP_HDQ_BASE,
-		.end		= OMAP_HDQ_BASE + 0x1C,
-		.flags		= IORESOURCE_MEM,
-	},
-	{
-		.start		= INT_24XX_HDQ_IRQ,
-		.flags		= IORESOURCE_IRQ,
-	},
-};
-static struct platform_device omap_hdq_dev = {
-	.name = "omap_hdq",
-	.id = 0,
-	.dev = {
-		.platform_data = NULL,
-	},
-	.num_resources	= ARRAY_SIZE(omap_hdq_resources),
-	.resource	= omap_hdq_resources,
-};
-static inline void omap_hdq_init(void)
-{
-	(void) platform_device_register(&omap_hdq_dev);
-}
-#else
-static inline void omap_hdq_init(void) {}
-#endif
-
-/*---------------------------------------------------------------------------*/
-
 #if defined(CONFIG_VIDEO_OMAP2_VOUT) || \
 	defined(CONFIG_VIDEO_OMAP2_VOUT_MODULE)
 #if defined(CONFIG_FB_OMAP2) || defined(CONFIG_FB_OMAP2_MODULE)
@@ -726,7 +690,6 @@ static int __init omap2_init_devices(void)
 	omap_init_mbox();
 	omap_init_mcspi();
 	omap_init_pmu();
-	omap_hdq_init();
 	omap_init_sti();
 	omap_init_sham();
 	omap_init_aes();
diff --git a/arch/arm/mach-omap2/hdq1w.c b/arch/arm/mach-omap2/hdq1w.c
index 15849ce..c917317 100644
--- a/arch/arm/mach-omap2/hdq1w.c
+++ b/arch/arm/mach-omap2/hdq1w.c
@@ -22,7 +22,13 @@
  * 02110-1301 USA
  */
 
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+
 #include <plat/omap_hwmod.h>
+#include <plat/omap_device.h>
 #include <plat/hdq1w.h>
 
 #include "common.h"
@@ -70,3 +76,23 @@ int omap_hdq1w_reset(struct omap_hwmod *oh)
 
 	return 0;
 }
+
+static int __init omap_init_hdq(void)
+{
+	int id = -1;
+	struct platform_device *pdev;
+	struct omap_hwmod *oh;
+	char *oh_name = "hdq1w";
+	char *devname = "omap_hdq";
+
+	oh = omap_hwmod_lookup(oh_name);
+	if (!oh)
+		return 0;
+
+	pdev = omap_device_build(devname, id, oh, NULL, 0, NULL, 0, 0);
+	WARN(IS_ERR(pdev), "Can't build omap_device for %s:%s.\n",
+	     devname, oh->name);
+
+	return 0;
+}
+arch_initcall(omap_init_hdq);


