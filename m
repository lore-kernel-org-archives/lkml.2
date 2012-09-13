Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab2IMNko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:40:44 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:42863 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755135Ab2IMNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:38:17 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 11/15] ASoC: omap-mcpdm: Use platform_get_resource_* to get resources
Date: Thu, 13 Sep 2012 16:38:01 +0300
Message-Id: <1347543485-339-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347543485-339-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the needed resources in a correct way and avoid using defines for them.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-mcpdm.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index baf92da..f90d5de 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -71,15 +71,11 @@ struct omap_mcpdm {
 static struct omap_pcm_dma_data omap_mcpdm_dai_dma_params[] = {
 	{
 		.name = "Audio playback",
-		.dma_req = OMAP44XX_DMA_MCPDM_DL,
 		.data_type = OMAP_DMA_DATA_TYPE_S32,
-		.port_addr = OMAP44XX_MCPDM_L3_BASE + MCPDM_REG_DN_DATA,
 	},
 	{
 		.name = "Audio capture",
-		.dma_req = OMAP44XX_DMA_MCPDM_UP,
 		.data_type = OMAP_DMA_DATA_TYPE_S32,
-		.port_addr = OMAP44XX_MCPDM_L3_BASE + MCPDM_REG_UP_DATA,
 	},
 };
 
@@ -452,10 +448,33 @@ static __devinit int asoc_mcpdm_probe(struct platform_device *pdev)
 
 	mutex_init(&mcpdm->mutex);
 
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dma");
+	if (res == NULL)
+		return -ENOMEM;
+
+	omap_mcpdm_dai_dma_params[0].port_addr = res->start + MCPDM_REG_DN_DATA;
+	omap_mcpdm_dai_dma_params[1].port_addr = res->start + MCPDM_REG_UP_DATA;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL)
 		return -ENOMEM;
 
+	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "dn_link");
+	if (!res)
+		return -ENODEV;
+
+	omap_mcpdm_dai_dma_params[0].dma_req = res->start;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_DMA, "up_link");
+	if (!res)
+		return -ENODEV;
+
+	omap_mcpdm_dai_dma_params[1].dma_req = res->start;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
+	if (res == NULL)
+		return -ENOMEM;
+
 	if (!devm_request_mem_region(&pdev->dev, res->start,
 				     resource_size(res), "McPDM"))
 		return -EBUSY;
-- 
1.7.12

