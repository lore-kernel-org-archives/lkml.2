Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2DEQEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:04:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56509 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab2DEQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:04:26 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3 3/9] ARM: OMAP2+: nand: create platform data structure
Date: Thu, 5 Apr 2012 21:16:15 +0530
Message-ID: <7af1cfbe02ec8e188a54b07902a701053c62cd7a.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New API for updating nand platform data. This has
been created by unifying the two existing ones and
taking out gpmc hardware handling.

>From now on, platforms can call omap_nand_init to
initialize platform nand structures, it's fields.
Or can statically create the same.

Acquiring gpmc CS has been removed. Acquiring CS
probably should be avoided, if ever required, do
in GPMC driver.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/board-devkit8000.c     |    6 ++-
 arch/arm/mach-omap2/board-flash.c          |   63 ++++++++++++++--------------
 arch/arm/mach-omap2/board-flash.h          |   13 ++++--
 arch/arm/mach-omap2/board-ldp.c            |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    6 ++-
 arch/arm/mach-omap2/board-omap3touchbook.c |    6 ++-
 arch/arm/mach-omap2/board-overo.c          |    5 ++-
 arch/arm/mach-omap2/board-zoom.c           |    5 ++-
 arch/arm/mach-omap2/common-board-devices.c |   46 --------------------
 arch/arm/mach-omap2/common-board-devices.h |    1 -
 10 files changed, 61 insertions(+), 94 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index a2010f0..adfcfc1 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -59,6 +59,7 @@
 
 #include "mux.h"
 #include "hsmmc.h"
+#include "board-flash.h"
 #include "common-board-devices.h"
 
 #define OMAP_DM9000_GPIO_IRQ	25
@@ -648,8 +649,9 @@ static void __init devkit8000_init(void)
 
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
-	omap_nand_flash_init(NAND_BUSWIDTH_16, devkit8000_nand_partitions,
-			     ARRAY_SIZE(devkit8000_nand_partitions));
+	omap_nand_init(devkit8000_nand_partitions,
+		ARRAY_SIZE(devkit8000_nand_partitions), GPMC_CS_NUM + 1,
+		NAND_BUSWIDTH_16, NULL);
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index 0349fd2..26c70b8 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -108,45 +108,45 @@ __init board_onenand_init(struct mtd_partition *nor_parts, u8 nr_parts, u8 cs)
 		defined(CONFIG_MTD_NAND_OMAP2_MODULE)
 
 /* Note that all values in this struct are in nanoseconds */
-static struct gpmc_timings nand_timings = {
+struct gpmc_timings nand_default_timings[1] = {
+	{
+		.sync_clk = 0,
 
-	.sync_clk = 0,
+		.cs_on = 0,
+		.cs_rd_off = 36,
+		.cs_wr_off = 36,
 
-	.cs_on = 0,
-	.cs_rd_off = 36,
-	.cs_wr_off = 36,
+		.adv_on = 6,
+		.adv_rd_off = 24,
+		.adv_wr_off = 36,
 
-	.adv_on = 6,
-	.adv_rd_off = 24,
-	.adv_wr_off = 36,
+		.we_off = 30,
+		.oe_off = 48,
 
-	.we_off = 30,
-	.oe_off = 48,
+		.access = 54,
+		.rd_cycle = 72,
+		.wr_cycle = 72,
 
-	.access = 54,
-	.rd_cycle = 72,
-	.wr_cycle = 72,
-
-	.wr_access = 30,
-	.wr_data_mux_bus = 0,
+		.wr_access = 30,
+		.wr_data_mux_bus = 0,
+	},
 };
 
-static struct omap_nand_platform_data board_nand_data = {
-	.gpmc_t		= &nand_timings,
+static struct omap_nand_platform_data omap_nand_data = {
+	.gpmc_t		= nand_default_timings,
 };
 
-void
-__init board_nand_init(struct mtd_partition *nand_parts,
-			u8 nr_parts, u8 cs, int nand_type)
+struct omap_nand_platform_data *
+__init omap_nand_init(struct mtd_partition *nand_parts, u8 nr_parts, u8 cs,
+				int nand_type, struct gpmc_timings *gpmc_t)
 {
-	board_nand_data.cs		= cs;
-	board_nand_data.parts		= nand_parts;
-	board_nand_data.nr_parts	= nr_parts;
-	board_nand_data.devsize		= nand_type;
-
-	board_nand_data.ecc_opt = OMAP_ECC_HAMMING_CODE_DEFAULT;
-	board_nand_data.gpmc_irq = OMAP_GPMC_IRQ_BASE + cs;
-	gpmc_nand_init(&board_nand_data);
+	omap_nand_data.cs		= cs;
+	omap_nand_data.parts		= nand_parts;
+	omap_nand_data.nr_parts		= nr_parts;
+	omap_nand_data.devsize		= nand_type;
+	omap_nand_data.gpmc_t		= gpmc_t;
+
+	return &omap_nand_data;
 }
 #endif /* CONFIG_MTD_NAND_OMAP2 || CONFIG_MTD_NAND_OMAP2_MODULE */
 
@@ -242,6 +242,7 @@ void __init board_flash_init(struct flash_partitions partition_info[],
 	if (nandcs > GPMC_CS_NUM)
 		pr_err("NAND: Unable to find configuration in GPMC\n");
 	else
-		board_nand_init(partition_info[2].parts,
-			partition_info[2].nr_parts, nandcs, nand_type);
+		omap_nand_init(partition_info[2].parts,
+			partition_info[2].nr_parts, nandcs,
+			nand_type, nand_default_timings);
 }
diff --git a/arch/arm/mach-omap2/board-flash.h b/arch/arm/mach-omap2/board-flash.h
index d25503a..1d3f039 100644
--- a/arch/arm/mach-omap2/board-flash.h
+++ b/arch/arm/mach-omap2/board-flash.h
@@ -39,11 +39,16 @@ static inline void board_flash_init(struct flash_partitions part[],
 
 #if defined(CONFIG_MTD_NAND_OMAP2) || \
 		defined(CONFIG_MTD_NAND_OMAP2_MODULE)
-extern void board_nand_init(struct mtd_partition *nand_parts,
-					u8 nr_parts, u8 cs, int nand_type);
+extern struct gpmc_timings nand_default_timings[];
+extern struct omap_nand_platform_data *
+__init omap_nand_init(struct mtd_partition *nand_parts, u8 nr_parts, u8 cs,
+				int nand_type, struct gpmc_timings *gpmc_t);
 #else
-static inline void board_nand_init(struct mtd_partition *nand_parts,
-					u8 nr_parts, u8 cs, int nand_type)
+#define	nand_default_timings	NULL
+static inline struct omap_nand_platform_data *
+omap_nand_init(struct mtd_partition *nand_parts,
+		u8 nr_parts, u8 cs, int nand_type, struct gpmc_timings *gpmc_t)
 {
+	return NULL;
 }
 #endif
diff --git a/arch/arm/mach-omap2/board-ldp.c b/arch/arm/mach-omap2/board-ldp.c
index 1b60495..a2510b2 100644
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@ -427,8 +427,8 @@ static void __init omap_ldp_init(void)
 	omap_serial_init();
 	omap_sdrc_init(NULL, NULL);
 	usb_musb_init(NULL);
-	board_nand_init(ldp_nand_partitions,
-		ARRAY_SIZE(ldp_nand_partitions), ZOOM_NAND_CS, 0);
+	omap_nand_init(ldp_nand_partitions, ARRAY_SIZE(ldp_nand_partitions),
+				ZOOM_NAND_CS, 0, nand_default_timings);
 
 	omap_hsmmc_init(mmc);
 	ldp_display_init();
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 7be8d65..f9beece 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -51,6 +51,7 @@
 #include "mux.h"
 #include "hsmmc.h"
 #include "pm.h"
+#include "board-flash.h"
 #include "common-board-devices.h"
 
 /*
@@ -542,8 +543,9 @@ static void __init omap3_beagle_init(void)
 
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
-	omap_nand_flash_init(NAND_BUSWIDTH_16, omap3beagle_nand_partitions,
-			     ARRAY_SIZE(omap3beagle_nand_partitions));
+	omap_nand_init(omap3beagle_nand_partitions,
+		ARRAY_SIZE(omap3beagle_nand_partitions), GPMC_CS_NUM + 1,
+		NAND_BUSWIDTH_16, NULL);
 
 	/* Ensure msecure is mux'd to be able to set the RTC. */
 	omap_mux_init_signal("sys_drm_msecure", OMAP_PIN_OFF_OUTPUT_HIGH);
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index ae2251f..dd917ca 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -52,6 +52,7 @@
 
 #include "mux.h"
 #include "hsmmc.h"
+#include "board-flash.h"
 #include "common-board-devices.h"
 
 #include <asm/setup.h>
@@ -370,8 +371,9 @@ static void __init omap3_touchbook_init(void)
 	omap_ads7846_init(4, OMAP3_TS_GPIO, 310, &ads7846_pdata);
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
-	omap_nand_flash_init(NAND_BUSWIDTH_16, omap3touchbook_nand_partitions,
-			     ARRAY_SIZE(omap3touchbook_nand_partitions));
+	omap_nand_init(omap3touchbook_nand_partitions,
+		ARRAY_SIZE(omap3touchbook_nand_partitions), GPMC_CS_NUM + 1,
+		NAND_BUSWIDTH_16, NULL);
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
 	omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 33aa391..4b70a31 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -57,6 +57,7 @@
 #include "mux.h"
 #include "sdram-micron-mt46h32m32lf-6.h"
 #include "hsmmc.h"
+#include "board-flash.h"
 #include "common-board-devices.h"
 
 #define OVERO_GPIO_BT_XGATE	15
@@ -517,8 +518,8 @@ static void __init overo_init(void)
 	omap_serial_init();
 	omap_sdrc_init(mt46h32m32lf6_sdrc_params,
 				  mt46h32m32lf6_sdrc_params);
-	omap_nand_flash_init(0, overo_nand_partitions,
-			     ARRAY_SIZE(overo_nand_partitions));
+	omap_nand_init(overo_nand_partitions,
+		ARRAY_SIZE(overo_nand_partitions), GPMC_CS_NUM + 1, 0, NULL);
 	usb_musb_init(NULL);
 	usbhs_init(&usbhs_bdata);
 	overo_spi_init();
diff --git a/arch/arm/mach-omap2/board-zoom.c b/arch/arm/mach-omap2/board-zoom.c
index 5c20bcc..0faef81 100644
--- a/arch/arm/mach-omap2/board-zoom.c
+++ b/arch/arm/mach-omap2/board-zoom.c
@@ -114,8 +114,9 @@ static void __init omap_zoom_init(void)
 		usbhs_init(&usbhs_bdata);
 	}
 
-	board_nand_init(zoom_nand_partitions, ARRAY_SIZE(zoom_nand_partitions),
-						ZOOM_NAND_CS, NAND_BUSWIDTH_16);
+	omap_nand_init(zoom_nand_partitions,
+			ARRAY_SIZE(zoom_nand_partitions), ZOOM_NAND_CS,
+			NAND_BUSWIDTH_16, nand_default_timings);
 	zoom_debugboard_init();
 	zoom_peripherals_init();
 
diff --git a/arch/arm/mach-omap2/common-board-devices.c b/arch/arm/mach-omap2/common-board-devices.c
index 1706ebc..0fd35a4 100644
--- a/arch/arm/mach-omap2/common-board-devices.c
+++ b/arch/arm/mach-omap2/common-board-devices.c
@@ -93,49 +93,3 @@ void __init omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
 {
 }
 #endif
-
-#if defined(CONFIG_MTD_NAND_OMAP2) || defined(CONFIG_MTD_NAND_OMAP2_MODULE)
-static struct omap_nand_platform_data nand_data;
-
-void __init omap_nand_flash_init(int options, struct mtd_partition *parts,
-				 int nr_parts)
-{
-	u8 cs = 0;
-	u8 nandcs = GPMC_CS_NUM + 1;
-
-	/* find out the chip-select on which NAND exists */
-	while (cs < GPMC_CS_NUM) {
-		u32 ret = 0;
-		ret = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG1);
-
-		if ((ret & 0xC00) == 0x800) {
-			printk(KERN_INFO "Found NAND on CS%d\n", cs);
-			if (nandcs > GPMC_CS_NUM)
-				nandcs = cs;
-		}
-		cs++;
-	}
-
-	if (nandcs > GPMC_CS_NUM) {
-		printk(KERN_INFO "NAND: Unable to find configuration "
-				 "in GPMC\n ");
-		return;
-	}
-
-	if (nandcs < GPMC_CS_NUM) {
-		nand_data.cs = nandcs;
-		nand_data.parts = parts;
-		nand_data.nr_parts = nr_parts;
-		nand_data.devsize = options;
-
-		printk(KERN_INFO "Registering NAND on CS%d\n", nandcs);
-		if (gpmc_nand_init(&nand_data) < 0)
-			printk(KERN_ERR "Unable to register NAND device\n");
-	}
-}
-#else
-void __init omap_nand_flash_init(int options, struct mtd_partition *parts,
-				 int nr_parts)
-{
-}
-#endif
diff --git a/arch/arm/mach-omap2/common-board-devices.h b/arch/arm/mach-omap2/common-board-devices.h
index a0b4a428..72bb41b 100644
--- a/arch/arm/mach-omap2/common-board-devices.h
+++ b/arch/arm/mach-omap2/common-board-devices.h
@@ -10,6 +10,5 @@ struct ads7846_platform_data;
 
 void omap_ads7846_init(int bus_num, int gpio_pendown, int gpio_debounce,
 		       struct ads7846_platform_data *board_pdata);
-void omap_nand_flash_init(int opts, struct mtd_partition *parts, int n_parts);
 
 #endif /* __OMAP_COMMON_BOARD_DEVICES__ */
-- 
1.7.9.3

