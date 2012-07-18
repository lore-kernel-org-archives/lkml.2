Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab2GRJFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:05:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12157 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2GRJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:04:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 18 Jul 2012 02:00:44 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] dma: tegra: enable/disable dma clock
Date: Wed, 18 Jul 2012 14:26:09 +0530
Message-ID: <1342601769-13852-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the DMA clock when registering DMA driver and
disable clock when removing the DMA driver.

The failure was observed on Tegra20 based system by
Stephen Warren. However, it is working fine on tegra30
based system and probably becasue uboot enable the clock
on Tegra30.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/dma/tegra20-apb-dma.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index d52dbc6..ccfdaf4 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1255,6 +1255,12 @@ static int __devinit tegra_dma_probe(struct platform_device *pdev)
 		}
 	}
 
+	ret = clk_prepare_enable(tdma->dma_clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "clk_prepare_enable failed: %d\n", ret);
+		goto err_pm_disable;
+	}
+
 	/* Reset DMA controller */
 	tegra_periph_reset_assert(tdma->dma_clk);
 	udelay(2);
@@ -1363,6 +1369,7 @@ static int __devexit tegra_dma_remove(struct platform_device *pdev)
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_dma_runtime_suspend(&pdev->dev);
 
+	clk_disable_unprepare(tdma->dma_clk);
 	return 0;
 }
 
-- 
1.7.1.1

