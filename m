Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab1KVI1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:27:20 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:55013 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755987Ab1KVI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:27:16 -0500
From: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>
Cc: <rabin.vincent@stericsson.com>, <linus.walleij@stericsson.com>,
        Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Subject: [PATCH] dmaengine/ste_dma40: Add support to use lcla area from esram
Date: Tue, 22 Nov 2011 13:56:55 +0530
Message-ID: <1321950415-31864-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides an option of having the lcla (link address)
in ESRAM instead of allocating it. The bool value (use_esram_lcla)
in the stedma40_platform_data if set to true, then the lcla
address would be taken from platform resources. Also, the
corresponding esram regulator is managed in the
suspend/resume functions.

Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    1 +
 drivers/dma/ste_dma40.c                        |   95 +++++++++++++++++++++---
 2 files changed, 86 insertions(+), 10 deletions(-)

This just adds the support to move lcla into esram. The enabling of this
will be done from the platform_data in another patch.

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 685c787..d7edcbe 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -153,6 +153,7 @@ struct stedma40_platform_data {
 	struct stedma40_chan_cfg	*memcpy_conf_phy;
 	struct stedma40_chan_cfg	*memcpy_conf_log;
 	int				 disabled_channels[STEDMA40_MAX_PHYS];
+	bool				 use_esram_lcla;
 };
 
 #ifdef CONFIG_STE_DMA40
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 909cf0d..865af22 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -304,6 +304,7 @@ struct d40_chan {
  * to phy_chans entries.
  * @plat_data: Pointer to provided platform_data which is the driver
  * configuration.
+ * @lcpa_regulator: Pointer to hold the regulator for the esram bank for lcla.
  * @phy_res: Vector containing all physical channels.
  * @lcla_pool: lcla pool settings and data.
  * @lcpa_base: The virtual mapped address of LCPA.
@@ -338,6 +339,7 @@ struct d40_base {
 	struct d40_chan			**lookup_log_chans;
 	struct d40_chan			**lookup_phy_chans;
 	struct stedma40_platform_data	 *plat_data;
+	struct regulator		 *lcpa_regulator;
 	/* Physical half channels */
 	struct d40_phy_res		 *phy_res;
 	struct d40_lcla_pool		  lcla_pool;
@@ -605,6 +607,7 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 	bool cyclic = desc->cyclic;
 	int curr_lcla = -EINVAL;
 	int first_lcla = 0;
+	bool use_esram_lcla = chan->base->plat_data->use_esram_lcla;
 	bool linkback;
 
 	/*
@@ -677,11 +680,16 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 				       &lli->src[lli_current],
 				       next_lcla, flags);
 
-		dma_sync_single_range_for_device(chan->base->dev,
-					pool->dma_addr, lcla_offset,
-					2 * sizeof(struct d40_log_lli),
-					DMA_TO_DEVICE);
-
+		/*
+		 * Cache maintenance is not needed if lcla is
+		 * mapped in esram
+		 */
+		if (!use_esram_lcla) {
+			dma_sync_single_range_for_device(chan->base->dev,
+						pool->dma_addr, lcla_offset,
+						2 * sizeof(struct d40_log_lli),
+						DMA_TO_DEVICE);
+		}
 		curr_lcla = next_lcla;
 
 		if (curr_lcla == -EINVAL || curr_lcla == first_lcla) {
@@ -2668,10 +2676,15 @@ failure1:
 #ifdef CONFIG_PM
 static int dma40_pm_suspend(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+	int ret = 0;
 	if (!pm_runtime_suspended(dev))
 		return -EBUSY;
 
-	return 0;
+	if (base->lcpa_regulator)
+		ret = regulator_disable(base->lcpa_regulator);
+	return ret;
 }
 
 static int dma40_runtime_suspend(struct device *dev)
@@ -2702,11 +2715,23 @@ static int dma40_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static int dma40_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct d40_base *base = platform_get_drvdata(pdev);
+	int ret = 0;
+
+	if (base->lcpa_regulator)
+		ret = regulator_enable(base->lcpa_regulator);
+
+	return ret;
+}
 
 static const struct dev_pm_ops dma40_pm_ops = {
 	.suspend		= dma40_pm_suspend,
 	.runtime_suspend	= dma40_runtime_suspend,
 	.runtime_resume		= dma40_runtime_resume,
+	.resume			= dma40_resume,
 };
 #define DMA40_PM_OPS	(&dma40_pm_ops)
 #else
@@ -3165,11 +3190,31 @@ static int __init d40_probe(struct platform_device *pdev)
 		d40_err(&pdev->dev, "Failed to ioremap LCPA region\n");
 		goto failure;
 	}
+	/* If lcla has to be located in ESRAM we don't need to allocate */
+	if (base->plat_data->use_esram_lcla) {
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+							"lcla_esram");
+		if (!res) {
+			ret = -ENOENT;
+			d40_err(&pdev->dev,
+				"No \"lcla_esram\" memory resource\n");
+			goto failure;
+		}
+		base->lcla_pool.base = ioremap(res->start,
+						resource_size(res));
+		if (!base->lcla_pool.base) {
+			ret = -ENOMEM;
+			d40_err(&pdev->dev, "Failed to ioremap LCLA region\n");
+			goto failure;
+		}
+		writel(res->start, base->virtbase + D40_DREG_LCLA);
 
-	ret = d40_lcla_allocate(base);
-	if (ret) {
-		d40_err(&pdev->dev, "Failed to allocate LCLA area\n");
-		goto failure;
+	} else {
+		ret = d40_lcla_allocate(base);
+		if (ret) {
+			d40_err(&pdev->dev, "Failed to allocate LCLA area\n");
+			goto failure;
+		}
 	}
 
 	spin_lock_init(&base->lcla_pool.lock);
@@ -3187,6 +3232,26 @@ static int __init d40_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(base->dev);
 	pm_runtime_enable(base->dev);
 	pm_runtime_resume(base->dev);
+
+	if (base->plat_data->use_esram_lcla) {
+
+		base->lcpa_regulator = regulator_get(base->dev, "lcla_esram");
+		if (IS_ERR(base->lcpa_regulator)) {
+			d40_err(&pdev->dev, "Failed to get lcpa_regulator\n");
+			base->lcpa_regulator = NULL;
+			goto failure;
+		}
+
+		ret = regulator_enable(base->lcpa_regulator);
+		if (ret) {
+			d40_err(&pdev->dev,
+				"Failed to enable lcpa_regulator\n");
+			regulator_put(base->lcpa_regulator);
+			base->lcpa_regulator = NULL;
+			goto failure;
+		}
+	}
+
 	base->initialized = true;
 	err = d40_dmaengine_init(base, num_reserved_chans);
 	if (err)
@@ -3204,6 +3269,11 @@ failure:
 		if (base->virtbase)
 			iounmap(base->virtbase);
 
+		if (base->lcla_pool.base && base->plat_data->use_esram_lcla) {
+			iounmap(base->lcla_pool.base);
+			base->lcla_pool.base = NULL;
+		}
+
 		if (base->lcla_pool.dma_addr)
 			dma_unmap_single(base->dev, base->lcla_pool.dma_addr,
 					 SZ_1K * base->num_phy_chans,
@@ -3226,6 +3296,11 @@ failure:
 			clk_put(base->clk);
 		}
 
+		if (base->lcpa_regulator) {
+			regulator_disable(base->lcpa_regulator);
+			regulator_put(base->lcpa_regulator);
+		}
+
 		kfree(base->lcla_pool.alloc_map);
 		kfree(base->lookup_log_chans);
 		kfree(base->lookup_phy_chans);
-- 
1.7.4.3

