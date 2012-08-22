Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2HVGGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:06:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55276 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757213Ab2HVGFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:05:38 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCHv2 1/3] spi: omap2-mcspi: Call pm_runtime_* functions directly
Date: Wed, 22 Aug 2012 11:35:12 +0530
Message-ID: <1345615515-26745-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call the pm_runtime functions directly making room for possible
pm optimisations. Also the runtime functions aren't just about
enabling and disabling of clocks though it does enable clocks also.

Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index b2fb141..f542f3d 100644
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
 
@@ -1252,7 +1244,8 @@ static int __devexit omap2_mcspi_remove(struct platform_device *pdev)
 	mcspi = spi_master_get_devdata(master);
 	dma_channels = mcspi->dma_channels;
 
-	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_mark_last_busy(mcspi->dev);
+	pm_runtime_put_autosuspend(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	spi_unregister_master(master);
@@ -1278,7 +1271,7 @@ static int omap2_mcspi_resume(struct device *dev)
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
 	struct omap2_mcspi_cs	*cs;
 
-	omap2_mcspi_enable_clocks(mcspi);
+	pm_runtime_get_sync(mcspi->dev);
 	list_for_each_entry(cs, &ctx->cs, node) {
 		if ((cs->chconf0 & OMAP2_MCSPI_CHCONF_FORCE) == 0) {
 			/*
@@ -1291,7 +1284,8 @@ static int omap2_mcspi_resume(struct device *dev)
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

