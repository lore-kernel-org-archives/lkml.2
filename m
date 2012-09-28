Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423391Ab2I1Vgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:36:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423367Ab2I1Vg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Chris Ball <cjb@laptop.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-mmc@vger.kernel.org
Subject: [PATCH 03/12] mmc: dw_mmc: fix building exynos driver as a module
Date: Fri, 28 Sep 2012 23:36:08 +0200
Message-Id: <1348868177-21205-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:uttyTGatBxP0MdqdwpytIug6c1eWOwSme4tHlF6NqbU
 sTj/Z+8u4d3f900C6H8ytBs9DbYa1C4UzV3A/T5TEwvuXDmGdT
 A8/ilcWO2CgIMl19umag9ye4b4g4n5SejtxTgOvBAk2a0IJpqV
 IqpR+NbNDTEF1BOdmSZQ8vSa3p8GQStHRz2Zr/l4tYgkg81rOv
 6C6xys0NmaOSGgga7IyNv60AsSSazyX/lDRgIvpHcYZB0aFMEY
 OFx+rq7ZmiPeYXUiuGpPM9lnkg6pDPhbk2bClDNaAxzTAzmdE1
 vr5AEaaaILUMoy77MuFaTFriNR00ozPiSXO6vrLySqu9E6VX4u
 l+poRbVvGCrBNHJ3Edb4h4aPp7m62/VZjZyYb8XSMzngeMTZMB
 VnyNKORy/EPuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MODULE_DEVICE_TABLE() entry in the dw_mmc_exynos driver
points to the wrong symbol which results in a link error
when building as a loadable module.

Further, we get a warning about the driver_data being
marked constant, which requires annotating a few pointers
as const.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Ball <cjb@laptop.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Will Newton <will.newton@imgtec.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-mmc@vger.kernel.org
---
 drivers/mmc/host/dw_mmc-exynos.c |    4 ++--
 drivers/mmc/host/dw_mmc-pltfm.c  |    2 +-
 drivers/mmc/host/dw_mmc-pltfm.h  |    2 +-
 drivers/mmc/host/dw_mmc.c        |    2 +-
 include/linux/mmc/dw_mmc.h       |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 660bbc5..32109a6 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -223,11 +223,11 @@ static const struct of_device_id dw_mci_exynos_match[] = {
 			.data = (void *)&exynos5250_drv_data, },
 	{},
 };
-MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
+MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
 
 int dw_mci_exynos_probe(struct platform_device *pdev)
 {
-	struct dw_mci_drv_data *drv_data;
+	const struct dw_mci_drv_data *drv_data;
 	const struct of_device_id *match;
 
 	match = of_match_node(dw_mci_exynos_match, pdev->dev.of_node);
diff --git a/drivers/mmc/host/dw_mmc-pltfm.c b/drivers/mmc/host/dw_mmc-pltfm.c
index c960ca7..5e33156 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.c
+++ b/drivers/mmc/host/dw_mmc-pltfm.c
@@ -24,7 +24,7 @@
 #include "dw_mmc.h"
 
 int dw_mci_pltfm_register(struct platform_device *pdev,
-				struct dw_mci_drv_data *drv_data)
+				const struct dw_mci_drv_data *drv_data)
 {
 	struct dw_mci *host;
 	struct resource	*regs;
diff --git a/drivers/mmc/host/dw_mmc-pltfm.h b/drivers/mmc/host/dw_mmc-pltfm.h
index 301f245..2ac37b8 100644
--- a/drivers/mmc/host/dw_mmc-pltfm.h
+++ b/drivers/mmc/host/dw_mmc-pltfm.h
@@ -13,7 +13,7 @@
 #define _DW_MMC_PLTFM_H_
 
 extern int dw_mci_pltfm_register(struct platform_device *pdev,
-				struct dw_mci_drv_data *drv_data);
+				const struct dw_mci_drv_data *drv_data);
 extern int __devexit dw_mci_pltfm_remove(struct platform_device *pdev);
 extern const struct dev_pm_ops dw_mci_pltfm_pmops;
 
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index a23af77..026cf92 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1973,7 +1973,7 @@ static void dw_mci_init_dma(struct dw_mci *host)
 	/* Determine which DMA interface to use */
 #ifdef CONFIG_MMC_DW_IDMAC
 	host->dma_ops = &dw_mci_idmac_ops;
-	dev_info(&host->dev, "Using internal DMA controller.\n");
+	dev_info(host->dev, "Using internal DMA controller.\n");
 #endif
 
 	if (!host->dma_ops)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 7c6a113..0f62c8c 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -162,7 +162,7 @@ struct dw_mci {
 	u16			data_offset;
 	struct device		*dev;
 	struct dw_mci_board	*pdata;
-	struct dw_mci_drv_data	*drv_data;
+	const struct dw_mci_drv_data	*drv_data;
 	void			*priv;
 	struct clk		*biu_clk;
 	struct clk		*ciu_clk;
-- 
1.7.10

