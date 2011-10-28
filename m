Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab1J1Loh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:44:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60599 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab1J1Lod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:44:33 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <linux-kernel@vger.kernel.org>, Shubhrajyoti D <shubhrajyoti@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: [PATCH 2/3] OMAP: SPI: call pm_runtime_disable in error path and remove
Date: Fri, 28 Oct 2011 17:14:18 +0530
Message-ID: <1319802259-16565-3-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
References: <1319802259-16565-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap mcspi probe() doesnt call pm_runtime  disable functions
in case of failure. remove() doesnt call pm_runtime disable. This could
lead to warnings as below on subsequent insmod.

~# insmod spi-omap2-mcspi.ko
[  255.383671] omap2_mcspi omap2_mcspi.1: Unbalanced pm_runtime_enable!
...

This patch adds the pm_runtime disable() at appropriate stages.

Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 471b0f3..6875a0b 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1195,6 +1195,7 @@ static int __init omap2_mcspi_probe(struct platform_device *pdev)
 err4:
 	spi_master_put(master);
 err3:
+	pm_runtime_disable(&pdev->dev);
 	kfree(mcspi->dma_channels);
 err2:
 	release_mem_region(r->start, resource_size(r));
@@ -1216,6 +1217,7 @@ static int __exit omap2_mcspi_remove(struct platform_device *pdev)
 	dma_channels = mcspi->dma_channels;
 
 	omap2_mcspi_disable_clocks(mcspi);
+	pm_runtime_disable(&pdev->dev);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 
-- 
1.7.1

