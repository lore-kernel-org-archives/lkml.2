Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2DEQEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:04:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41788 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEQEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:04:23 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <tony@atomide.com>, <khilman@ti.com>, <linux@arm.linux.org.uk>,
        <dwmw2@infradead.org>, <sameo@linux.intel.com>,
        <grinberg@compulab.co.il>, <mike@compulab.co.il>, <nm@ti.com>,
        <artem.bityutskiy@linux.intel.com>, <vimal.newwork@gmail.com>,
        <dbaryshkov@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v3 2/9] ARM: OMAP2+: gpmc: registers for nand driver
Date: Thu, 5 Apr 2012 21:16:08 +0530
Message-ID: <a78d77dd5012e9d47616eeaf727e5b4265db0834.1333640054.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <cover.1333640054.git.afzal@ti.com>
References: <cover.1333640054.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If peripheral connected is NAND, update NAND drivers platform data
with NAND related register addresses so that NAND driver can handle
GPMC NAND operations by itself

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/gpmc.c             |   25 +++++++++++++++++++++++++
 arch/arm/plat-omap/include/plat/gpmc.h |   16 ++++++++++++++++
 arch/arm/plat-omap/include/plat/nand.h |    1 +
 3 files changed, 42 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index cf5d8f3..ca7fa83 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -30,6 +30,7 @@
 
 #include <asm/mach-types.h>
 #include <plat/gpmc.h>
+#include <plat/nand.h>
 
 #include <plat/sdrc.h>
 
@@ -766,6 +767,28 @@ static int __init gpmc_init(void)
 }
 postcore_initcall(gpmc_init);
 
+static __devinit void gpmc_update_nand_reg(struct gpmc *gpmc,
+				struct omap_nand_platform_data *nand)
+{
+	int cs = nand->cs;
+
+	nand->reg.gpmc_status = gpmc->io_base + GPMC_STATUS;
+	nand->reg.gpmc_nand_command = gpmc->io_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_COMMAND + GPMC_CS_SIZE * cs;
+	nand->reg.gpmc_nand_address = gpmc->io_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_ADDRESS + GPMC_CS_SIZE * cs;
+	nand->reg.gpmc_nand_data = gpmc->io_base + GPMC_CS0_OFFSET +
+				GPMC_CS_NAND_DATA + GPMC_CS_SIZE * cs;
+	nand->reg.gpmc_prefetch_config1 = gpmc->io_base + GPMC_PREFETCH_CONFIG1;
+	nand->reg.gpmc_prefetch_config2 = gpmc->io_base + GPMC_PREFETCH_CONFIG2;
+	nand->reg.gpmc_prefetch_control = gpmc->io_base + GPMC_PREFETCH_CONTROL;
+	nand->reg.gpmc_prefetch_status = gpmc->io_base + GPMC_PREFETCH_STATUS;
+	nand->reg.gpmc_ecc_config = gpmc->io_base + GPMC_ECC_CONFIG;
+	nand->reg.gpmc_ecc_control = gpmc->io_base + GPMC_ECC_CONTROL;
+	nand->reg.gpmc_ecc_size_config = gpmc->io_base + GPMC_ECC_SIZE_CONFIG;
+	nand->reg.gpmc_ecc1_result = gpmc->io_base + GPMC_ECC1_RESULT;
+}
+
 static __devinit struct resource gpmc_setup_cs_mem(struct gpmc_cs_data *p,
 			struct gpmc_device_pdata *gdp, struct gpmc *gpmc)
 {
@@ -1066,6 +1089,8 @@ static __devinit int gpmc_probe(struct platform_device *pdev)
 	gpmc_mem_init();
 
 	for (gdq = gp->device_pdata, gd = gpmc->device; *gdq; gdq++, i++) {
+		if ((*gdq)->is_nand)
+			gpmc_update_nand_reg(gpmc, (*gdq)->pdata);
 		ret = gpmc_setup_device(*gdq, gd, gpmc);
 		if (IS_ERR_VALUE(ret))
 			dev_err(gpmc->dev, "gpmc setup on %s failed\n",
diff --git a/arch/arm/plat-omap/include/plat/gpmc.h b/arch/arm/plat-omap/include/plat/gpmc.h
index fa62cdf..a320e71 100644
--- a/arch/arm/plat-omap/include/plat/gpmc.h
+++ b/arch/arm/plat-omap/include/plat/gpmc.h
@@ -169,6 +169,7 @@ struct gpmc_device_pdata {
 	unsigned		num_per_res;
 	struct gpmc_cs_data	*cs_data;
 	unsigned		num_cs;
+	bool			is_nand;
 };
 
 struct gpmc_pdata {
@@ -179,6 +180,21 @@ struct gpmc_pdata {
 	unsigned			num_irq;
 };
 
+struct gpmc_nand_regs {
+	void __iomem	*gpmc_status;
+	void __iomem	*gpmc_nand_command;
+	void __iomem	*gpmc_nand_address;
+	void __iomem	*gpmc_nand_data;
+	void __iomem	*gpmc_prefetch_config1;
+	void __iomem	*gpmc_prefetch_config2;
+	void __iomem	*gpmc_prefetch_control;
+	void __iomem	*gpmc_prefetch_status;
+	void __iomem	*gpmc_ecc_config;
+	void __iomem	*gpmc_ecc_control;
+	void __iomem	*gpmc_ecc_size_config;
+	void __iomem	*gpmc_ecc1_result;
+};
+
 extern unsigned int gpmc_ns_to_ticks(unsigned int time_ns);
 extern unsigned int gpmc_ps_to_ticks(unsigned int time_ps);
 extern unsigned int gpmc_ticks_to_ns(unsigned int ticks);
diff --git a/arch/arm/plat-omap/include/plat/nand.h b/arch/arm/plat-omap/include/plat/nand.h
index 67fc506..86e4d9c 100644
--- a/arch/arm/plat-omap/include/plat/nand.h
+++ b/arch/arm/plat-omap/include/plat/nand.h
@@ -29,6 +29,7 @@ struct omap_nand_platform_data {
 	unsigned long		phys_base;
 	int			devsize;
 	enum omap_ecc           ecc_opt;
+	struct gpmc_nand_regs	reg;
 };
 
 /* minimum size for IO mapping */
-- 
1.7.9.3

