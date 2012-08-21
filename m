Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HUGSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 02:18:16 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57930 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2HUGSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 02:18:03 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 1/3] spi: omap2-mcspi: Call pm_runtime_* functions directly
Date: Tue, 21 Aug 2012 11:47:42 +0530
Message-ID: <1345529864-7937-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the pm_runtime functions directly making room for possible
pm optimisations. Also the runtime functions aren't just about
enabling and disabling of clocks though it does enable clocks also.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 259f601..dd887eb 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -260,16 +260,6 @@ static void omap2_mcspi_restore_ctx(struct omap2_mcspi *mcspi)
 	list_for_each_entry(cs, &ctx->cs, node)
 		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 }
-static void omap2_mcspi_disable_clocks(struct omap2_mcspi *mcspi)
-{
-	pm_runtime_mark_last_busy(mcspi->dev);
-	pm_runtime_put_autosuspend(mcspi->dev);
-}
-
-static int omap2_mcspi_enable_clocks(struct omap2_mcspi *mcspi)
-{
-	return pm_runtime_get_sync(mcspi->dev);
-}
 
 static int omap2_prepare_transfer(struct spi_master *master)
 {
@@ -848,12 +838,13 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 			return ret;
 	}
 
-	ret = omap2_mcspi_enable_clocks(mcspi);
+	ret = pm_runtime_get_sync(mcspi->dev);
 	if (ret < 0)
 		return ret;
 
 	ret = omap2_mcspi_setup_transfer(spi, NULL);
-	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 
 	return ret;
 }
@@ -1067,7 +1058,7 @@ static int __devinit omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
 	int			ret = 0;
 
-	ret = omap2_mcspi_enable_clocks(mcspi);
+	ret = pm_runtime_get_sync(mcspi->dev);
 	if (ret < 0)
 		return ret;
 
@@ -1076,7 +1067,8 @@ static int __devinit omap2_mcspi_master_setup(struct omap2_mcspi *mcspi)
 	ctx->wakeupenable = OMAP2_MCSPI_WAKEUPENABLE_WKEN;
 
 	omap2_mcspi_set_master_mode(master);
-	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 	return 0;
 }
 
@@ -1251,7 +1243,8 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	mcspi = spi_master_get_devdata(master);
 	dma_channels = mcspi->dma_channels;
 
-	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_unregister_master(master);
@@ -1276,7 +1269,7 @@ static int omap2_mcspi_resume(struct device *dev)
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
 	struct omap2_mcspi_cs	*cs;
 
-	omap2_mcspi_enable_clocks(mcspi);
+	pm_runtime_get_sync(mcspi->dev);
 	list_for_each_entry(cs, &ctx->cs, node) {
 		if ((cs->chconf0 & OMAP2_MCSPI_CHCONF_FORCE) == 0) {
 			/*
@@ -1289,7 +1282,8 @@ static int omap2_mcspi_resume(struct device *dev)
 			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
 		}
 	}
-	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 	return 0;
 }
 #else
-- 
1.7.5.4

