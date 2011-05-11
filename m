Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab1EKQBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:01:48 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:44251 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1EKQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uyMubVQNQAdjLZokzKAehdhe3CzohS7geIa+ZehhiqzeFN3tpR1IUnPLVlQ2tYJcog
         zstvv89FKu2VZoU5HFZQ8hb/MOT4un+kD7DcOfnBsfKSQMFRDX+ttkT+H3OGX4ZZf/1F
         yGbGOxwtW7LhpVD2kfvrvkohCfLUl8u8kYF9I=
Subject: [PATCH 2/2] spi: spi_tegra: calling spi_unregister_master instead
 of spi_master_put in spi_tegra_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Erik Gilling <konkers@android.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
In-Reply-To: <1305120420.6324.6.camel@phoenix>
References: <1305120420.6324.6.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 21:28:16 +0800
Message-ID: <1305120496.6324.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi_master_put() should only be used in error handling.
Once spi_register_master() returns success, we should call
spi_unregister_master() instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/spi/spi_tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_tegra.c b/drivers/spi/spi_tegra.c
index 891e590..6c3aa6e 100644
--- a/drivers/spi/spi_tegra.c
+++ b/drivers/spi/spi_tegra.c
@@ -578,6 +578,7 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	master = dev_get_drvdata(&pdev->dev);
 	tspi = spi_master_get_devdata(master);
 
+	spi_unregister_master(master);
 	tegra_dma_free_channel(tspi->rx_dma);
 
 	dma_free_coherent(&pdev->dev, sizeof(u32) * BB_LEN,
@@ -586,7 +587,6 @@ static int __devexit spi_tegra_remove(struct platform_device *pdev)
 	clk_put(tspi->clk);
 	iounmap(tspi->base);
 
-	spi_master_put(master);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, (r->end - r->start) + 1);
 
-- 
1.7.1



