Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1HJMJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:09:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:55653 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1HJMJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:09:11 -0400
X-AuditID: cbfee61a-b7cf0ae000006bc6-ab-4e4274e57137
Date: Wed, 10 Aug 2011 14:03:34 -0400
From: Padmavathi Venna <padma.v@samsung.com>
Subject: [RFC][PATCH V2 1/2] S5PV210: SPI: Add clkdev support
To: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, jassisinghbrar@gmail.com,
        ben-linux@fluff.org
Message-id: <1312999414-14051-1-git-send-email-padma.v@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a clkdev alias for spi bus clock and modify the spi
driver to lookup the clock using the alias name instead of
passing clock name and clock number from SPI platform data.

Board designer has the option to pass the list of bus clocks
that are going to be used with SPI controller.If that list of
clocks are null then it uses all the available clocks.

Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
---
This patch is tested for S5PV210 platform and similar
changes can be adopted for rest of the Samsung's s3c
and s5p platforms, if this approach is accepted.

 arch/arm/mach-s5pv210/dev-spi.c                  |   38 +++++++++++++++++++---
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |    7 +---
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-s5pv210/dev-spi.c b/arch/arm/mach-s5pv210/dev-spi.c
index eaf9a7b..503a3f4 100644
--- a/arch/arm/mach-s5pv210/dev-spi.c
+++ b/arch/arm/mach-s5pv210/dev-spi.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
+#include <linux/clk.h>
 
 #include <mach/dma.h>
 #include <mach/map.h>
@@ -145,13 +146,16 @@ struct platform_device s5pv210_device_spi1 = {
 	},
 };
 
-void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
+void __init s5pv210_spi_set_info(int cntrlr, int num_cs, char *list[])
 {
 	struct s3c64xx_spi_info *pd;
+	struct device *dev;
+	char devname[16], clk_alias_name[16];
+	int ret, i;
+	char **clk_list;
 
 	/* Reject invalid configuration */
-	if (!num_cs || src_clk_nr < 0
-			|| src_clk_nr > S5PV210_SPI_SRCCLK_SCLK) {
+	if (!num_cs) {
 		printk(KERN_ERR "%s: Invalid SPI configuration\n", __func__);
 		return;
 	}
@@ -159,9 +163,11 @@ void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
 	switch (cntrlr) {
 	case 0:
 		pd = &s5pv210_spi0_pdata;
+		dev = &s5pv210_device_spi0.dev;
 		break;
 	case 1:
 		pd = &s5pv210_spi1_pdata;
+		dev = &s5pv210_device_spi1.dev;
 		break;
 	default:
 		printk(KERN_ERR "%s: Invalid SPI controller(%d)\n",
@@ -169,7 +175,29 @@ void __init s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs)
 		return;
 	}
 
+	sprintf(devname, "s3c64xx-spi.%d", cntrlr);
+
+	if (list)
+		clk_list = list;
+	else
+		clk_list = spi_src_clks;
+
+	for (i = 0; i <= S5PV210_SPI_SRCCLK_SCLK ; i++) {
+		sprintf(clk_alias_name, "clk_spi_bus%d", i);
+
+		if (clk_list[i]) {
+			if (!strcmp(clk_list[i], "pclk"))
+				ret = clk_add_alias(clk_alias_name, devname,
+							clk_list[i], NULL);
+			else
+				ret = clk_add_alias(clk_alias_name, devname,
+							clk_list[i], dev);
+			if (ret) {
+				printk(KERN_ERR "failed to create alias for"
+					" SPI%d source clock%d\n", cntrlr, i);
+				continue;
+			}
+		}
+	}
 	pd->num_cs = num_cs;
-	pd->src_clk_nr = src_clk_nr;
-	pd->src_clk_name = spi_src_clks[src_clk_nr];
 }
diff --git a/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h b/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
index 4c16fa3..acdd337 100644
--- a/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
+++ b/arch/arm/plat-samsung/include/plat/s3c64xx-spi.h
@@ -30,8 +30,6 @@ struct s3c64xx_spi_csinfo {
 
 /**
  * struct s3c64xx_spi_info - SPI Controller defining structure
- * @src_clk_nr: Clock source index for the CLK_CFG[SPI_CLKSEL] field.
- * @src_clk_name: Platform name of the corresponding clock.
  * @clk_from_cmu: If the SPI clock/prescalar control block is present
  *     by the platform's clock-management-unit and not in SPI controller.
  * @num_cs: Number of CS this controller emulates.
@@ -42,8 +40,6 @@ struct s3c64xx_spi_csinfo {
  * @tx_st_done: Depends on tx fifo_lvl field
  */
 struct s3c64xx_spi_info {
-	int src_clk_nr;
-	char *src_clk_name;
 	bool clk_from_cmu;
 
 	int num_cs;
@@ -61,7 +57,6 @@ struct s3c64xx_spi_info {
  * s3c64xx_spi_set_info - SPI Controller configure callback by the board
  *				initialization code.
  * @cntrlr: SPI controller number the configuration is for.
- * @src_clk_nr: Clock the SPI controller is to use to generate SPI clocks.
  * @num_cs: Number of elements in the 'cs' array.
  *
  * Call this from machine init code for each SPI Controller that
@@ -69,7 +64,7 @@ struct s3c64xx_spi_info {
  */
 extern void s3c64xx_spi_set_info(int cntrlr, int src_clk_nr, int num_cs);
 extern void s5pc100_spi_set_info(int cntrlr, int src_clk_nr, int num_cs);
-extern void s5pv210_spi_set_info(int cntrlr, int src_clk_nr, int num_cs);
+extern void s5pv210_spi_set_info(int cntrlr, int num_cs, char *clk_list[]);
 extern void s5p64x0_spi_set_info(int cntrlr, int src_clk_nr, int num_cs);
 
 #endif /* __S3C64XX_PLAT_SPI_H */
-- 
1.7.0.4

