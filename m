Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab2DEQE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:04:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54496 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab2DEQE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:04:27 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3 4/9] ARM: OMAP2+: gpmc-nand: populate gpmc configs
Date: Thu, 5 Apr 2012 21:16:23 +0530
Message-ID: <6c120ab77d0900a6f977246bc58fb37c62280371.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently gpmc is configured in platform for nand.
As configuring gpmc has been moved to gpmc driver,
populate details needed for the driver to configure
gpmc. gpmc driver would configure based on this
information.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/gpmc-nand.c        |   97 ++++++++++++++------------------
 arch/arm/plat-omap/include/plat/nand.h |    8 ++-
 2 files changed, 48 insertions(+), 57 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-nand.c b/arch/arm/mach-omap2/gpmc-nand.c
index 386dec8..85de31f 100644
--- a/arch/arm/mach-omap2/gpmc-nand.c
+++ b/arch/arm/mach-omap2/gpmc-nand.c
@@ -21,24 +21,38 @@
 #include <plat/board.h>
 #include <plat/gpmc.h>
 
-static struct resource gpmc_nand_resource = {
-	.flags		= IORESOURCE_MEM,
+
+#define	GPMC_NAND_CONFIG_NUM	4
+#define	IDX_DEV_SIZE		2
+#define	IDX_RDY_BSY		3
+
+static struct gpmc_config gpmc_nand_config[GPMC_NAND_CONFIG_NUM] = {
+	{ GPMC_CONFIG_DEV_TYPE, GPMC_DEVICETYPE_NAND},
+	{ GPMC_CONFIG_WP, 0},
 };
 
-static struct platform_device gpmc_nand_device = {
+static struct gpmc_cs_data gpmc_nand_cs_info = {
+	.config		= gpmc_nand_config,
+	.num_config	= ARRAY_SIZE(gpmc_nand_config),
+	.irq_flags	= GPMC_IRQ_FIFOEVENT | GPMC_IRQ_TERMINALCOUNT,
+};
+
+static struct gpmc_device_pdata gpmc_nand_info = {
 	.name		= "omap2-nand",
 	.id		= 0,
-	.num_resources	= 1,
-	.resource	= &gpmc_nand_resource,
+	.cs_data	= &gpmc_nand_cs_info,
+	.num_cs		= 1,
 };
 
-static int omap2_nand_gpmc_retime(struct omap_nand_platform_data *gpmc_nand_data)
-{
-	struct gpmc_timings t;
-	int err;
+static struct gpmc_timings t;
 
-	if (!gpmc_nand_data->gpmc_t)
+static struct gpmc_timings *
+gpmc_nand_retime(struct omap_nand_platform_data *gpmc_nand_data)
+{
+	if (!gpmc_nand_data->gpmc_t) {
+		pr_warn("gpmc timings not provided\n");
 		return 0;
+	}
 
 	memset(&t, 0, sizeof(t));
 	t.sync_clk = gpmc_nand_data->gpmc_t->sync_clk;
@@ -68,56 +82,31 @@ static int omap2_nand_gpmc_retime(struct omap_nand_platform_data *gpmc_nand_data
 	t.cs_wr_off = gpmc_round_ns_to_ticks(gpmc_nand_data->gpmc_t->cs_wr_off);
 	t.wr_cycle  = gpmc_round_ns_to_ticks(gpmc_nand_data->gpmc_t->wr_cycle);
 
-	/* Configure GPMC */
-	if (gpmc_nand_data->devsize == NAND_BUSWIDTH_16)
-		gpmc_cs_configure(gpmc_nand_data->cs, GPMC_CONFIG_DEV_SIZE, 1);
-	else
-		gpmc_cs_configure(gpmc_nand_data->cs, GPMC_CONFIG_DEV_SIZE, 0);
-	gpmc_cs_configure(gpmc_nand_data->cs,
-			GPMC_CONFIG_DEV_TYPE, GPMC_DEVICETYPE_NAND);
-	err = gpmc_cs_set_timings(gpmc_nand_data->cs, &t);
-	if (err)
-		return err;
-
-	return 0;
+	return &t;
 }
 
-int __init gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data)
+struct gpmc_device_pdata *
+__init gpmc_nand_init(struct omap_nand_platform_data *gpmc_nand_data)
 {
-	int err	= 0;
-	struct device *dev = &gpmc_nand_device.dev;
+	gpmc_nand_info.pdata = gpmc_nand_data;
+	gpmc_nand_info.pdata_size = sizeof(*gpmc_nand_data);
 
-	gpmc_nand_device.dev.platform_data = gpmc_nand_data;
+	gpmc_nand_cs_info.cs = gpmc_nand_data->cs;
+	gpmc_nand_cs_info.mem_size = NAND_IO_SIZE;
 
-	err = gpmc_cs_request(gpmc_nand_data->cs, NAND_IO_SIZE,
-				&gpmc_nand_data->phys_base);
-	if (err < 0) {
-		dev_err(dev, "Cannot request GPMC CS\n");
-		return err;
-	}
+	gpmc_nand_cs_info.timing = gpmc_nand_retime(gpmc_nand_data);
 
-	 /* Set timings in GPMC */
-	err = omap2_nand_gpmc_retime(gpmc_nand_data);
-	if (err < 0) {
-		dev_err(dev, "Unable to set gpmc timings: %d\n", err);
-		return err;
-	}
-
-	/* Enable RD PIN Monitoring Reg */
-	if (gpmc_nand_data->dev_ready) {
-		gpmc_cs_configure(gpmc_nand_data->cs, GPMC_CONFIG_RDY_BSY, 1);
-	}
-
-	err = platform_device_register(&gpmc_nand_device);
-	if (err < 0) {
-		dev_err(dev, "Unable to register NAND device\n");
-		goto out_free_cs;
-	}
-
-	return 0;
+	gpmc_nand_config[IDX_DEV_SIZE].cmd = GPMC_CONFIG_DEV_SIZE;
+	if (gpmc_nand_data->devsize == NAND_BUSWIDTH_16)
+		gpmc_nand_config[IDX_DEV_SIZE].val = 1;
+	else
+		gpmc_nand_config[IDX_DEV_SIZE].val = 0;
 
-out_free_cs:
-	gpmc_cs_free(gpmc_nand_data->cs);
+	gpmc_nand_config[IDX_RDY_BSY].cmd = GPMC_CONFIG_RDY_BSY;
+	if (gpmc_nand_data->dev_ready)
+		gpmc_nand_config[IDX_RDY_BSY].val = 1;
+	else
+		gpmc_nand_config[IDX_RDY_BSY].val = 0;
 
-	return err;
+	return &gpmc_nand_info;
 }
diff --git a/arch/arm/plat-omap/include/plat/nand.h b/arch/arm/plat-omap/include/plat/nand.h
index 86e4d9c..30c61c9 100644
--- a/arch/arm/plat-omap/include/plat/nand.h
+++ b/arch/arm/plat-omap/include/plat/nand.h
@@ -36,10 +36,12 @@ struct omap_nand_platform_data {
 #define	NAND_IO_SIZE	4
 
 #if defined(CONFIG_MTD_NAND_OMAP2) || defined(CONFIG_MTD_NAND_OMAP2_MODULE)
-extern int gpmc_nand_init(struct omap_nand_platform_data *d);
+extern struct gpmc_device_pdata *
+gpmc_nand_init(struct omap_nand_platform_data *d);
 #else
-static inline int gpmc_nand_init(struct omap_nand_platform_data *d)
+static inline struct gpmc_device_pdata *
+gpmc_nand_init(struct omap_nand_platform_data *d)
 {
-	return 0;
+	return NULL;
 }
 #endif
-- 
1.7.9.3

