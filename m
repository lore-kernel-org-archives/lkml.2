Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2DEQFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:05:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54563 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab2DEQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:05:08 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [TMP] OMAP3EVM: Test gpmc nand & smsc911x
Date: Thu, 5 Apr 2012 21:17:19 +0530
Message-ID: <bb95fec60401f7cf6ac77200a12baf3fc83852f5.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/board-omap3evm.c |   95 +++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 49df127..60938af 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -23,6 +23,7 @@
 #include <linux/input/matrix_keypad.h>
 #include <linux/leds.h>
 #include <linux/interrupt.h>
+#include <linux/mtd/nand.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
@@ -41,6 +42,7 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
+#include <plat/nand.h>
 #include <plat/board.h>
 #include <plat/usb.h>
 #include "common.h"
@@ -52,6 +54,7 @@
 #include "sdram-micron-mt46h32m32lf-6.h"
 #include "hsmmc.h"
 #include "common-board-devices.h"
+#include "board-flash.h"
 
 #define OMAP3_EVM_TS_GPIO	175
 #define OMAP3_EVM_EHCI_VBUS	22
@@ -102,6 +105,36 @@ static void __init omap3_evm_get_revision(void)
 	}
 }
 
+static struct gpmc_device_pdata *gpmc_data_array[3];
+static struct gpmc_device_pdata **gpmc_data_cur = gpmc_data_array;
+
+static struct gpmc_pdata gpmc_data = {
+	.device_pdata = gpmc_data_array,
+};
+
+static struct resource gpmc_resources[] = {
+	{
+		.start = OMAP34XX_GPMC_BASE,
+		.end   = OMAP34XX_GPMC_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = INT_34XX_GPMC_IRQ,
+		.end   = INT_34XX_GPMC_IRQ,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gpmc_device = {
+	.name		= "omap-gpmc",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(gpmc_resources),
+	.resource	= gpmc_resources,
+	.dev	= {
+		.platform_data = &gpmc_data,
+	}
+};
+
 #if defined(CONFIG_SMSC911X) || defined(CONFIG_SMSC911X_MODULE)
 #include <plat/gpmc-smsc911x.h>
 
@@ -114,6 +147,8 @@ static struct omap_smsc911x_platform_data smsc911x_cfg = {
 
 static inline void __init omap3evm_init_smsc911x(void)
 {
+	struct gpmc_device_pdata *gpmc_smsc911x_info;
+
 	/* Configure ethernet controller reset gpio */
 	if (cpu_is_omap3430()) {
 		if (get_omap3_evm_rev() == OMAP3EVM_BOARD_GEN_1)
@@ -122,7 +157,11 @@ static inline void __init omap3evm_init_smsc911x(void)
 			smsc911x_cfg.gpio_reset = OMAP3EVM_GEN2_ETHR_GPIO_RST;
 	}
 
-	gpmc_smsc911x_init(&smsc911x_cfg);
+	gpmc_smsc911x_info = gpmc_smsc911x_init(&smsc911x_cfg);
+	if (gpmc_smsc911x_info)
+		*gpmc_data_cur++ = gpmc_smsc911x_info;
+	else
+		pr_err("error: unable to initilaize gpmc smsc911x\n");
 }
 
 #else
@@ -523,6 +562,41 @@ static struct usbhs_omap_board_data usbhs_bdata __initdata = {
 	.reset_gpio_port[2]  = -EINVAL
 };
 
+/*
+ * NAND
+ */
+static struct mtd_partition omap3_evm_nand_partitions[] = {
+	/* All the partition sizes are listed in terms of NAND block size */
+	{
+		.name		= "X-Loader-NAND",
+		.offset		= 0,
+		.size		= 4 * (64 * 2048),
+		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
+	},
+	{
+		.name		= "U-Boot-NAND",
+		.offset		= MTDPART_OFS_APPEND,	/* Offset = 0x80000 */
+		.size		= 10 * (64 * 2048),
+		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
+	},
+	{
+		.name		= "Boot Env-NAND",
+
+		.offset		= MTDPART_OFS_APPEND,	/* Offset = 0x1c0000 */
+		.size		= 6 * (64 * 2048),
+	},
+	{
+		.name		= "Kernel-NAND",
+		.offset		= MTDPART_OFS_APPEND,	/* Offset = 0x280000 */
+		.size		= 40 * (64 * 2048),
+	},
+	{
+		.name		= "File System - NAND",
+		.size		= MTDPART_SIZ_FULL,
+		.offset		= MTDPART_OFS_APPEND,	/* Offset = 0x780000 */
+	},
+};
+
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux omap35x_board_mux[] __initdata = {
 	OMAP3_MUX(SYS_NIRQ, OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP |
@@ -630,6 +704,8 @@ static struct regulator_consumer_supply dummy_supplies[] = {
 
 static void __init omap3_evm_init(void)
 {
+	struct omap_nand_platform_data *nand_data;
+
 	omap3_evm_get_revision();
 	regulator_register_fixed(0, dummy_supplies, ARRAY_SIZE(dummy_supplies));
 
@@ -681,6 +757,23 @@ static void __init omap3_evm_init(void)
 	omap3evm_init_smsc911x();
 	omap3_evm_display_init();
 	omap3_evm_wl12xx_init();
+	/* NAND */
+	nand_data = omap_nand_init(omap3_evm_nand_partitions,
+			ARRAY_SIZE(omap3_evm_nand_partitions),
+			0, NAND_BUSWIDTH_16, nand_default_timings);
+/*	nand_data->xfer_type = NAND_OMAP_PREFETCH_IRQ;
+ */	if (nand_data != NULL) {
+		*gpmc_data_cur = gpmc_nand_init(nand_data);
+		(*gpmc_data_cur++)->is_nand = true;
+	} else
+		pr_err("omap_nand_init() failed\n");
+
+
+	gpmc_data.fclk_period = gpmc_get_fclk_period();
+	gpmc_data.irq_start = OMAP_GPMC_IRQ_BASE;
+	gpmc_data.num_irq = OMAP_GPMC_NR_IRQS;
+
+	platform_device_register(&gpmc_device);
 }
 
 MACHINE_START(OMAP3EVM, "OMAP3 EVM")
-- 
1.7.9.3

