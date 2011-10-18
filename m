Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1JRCsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:48:53 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60556 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab1JRCsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:48:52 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Dong Aisheng <b29396@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sound/soc/mxs/mxs-saif.c: keep pointer to resource so it can be freed
Date: Tue, 18 Oct 2011 05:45:53 +0200
Message-Id: <1318909555-12933-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a new variable for storing resources accessed subsequent to the one
accessed using request_mem_region, so the one accessed using
request_mem_region can be released if needed.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/mxs/mxs-saif.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 401944c..e12ff78 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -617,7 +617,7 @@ static irqreturn_t mxs_saif_irq(int irq, void *dev_id)
 
 static int mxs_saif_probe(struct platform_device *pdev)
 {
-	struct resource *res;
+	struct resource *res, *res1;
 	struct mxs_saif *saif;
 	struct mxs_saif_platform_data *pdata;
 	int ret = 0;
@@ -676,14 +676,14 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		goto failed_ioremap;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!res) {
+	res1 = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!res1) {
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
 			ret);
 		goto failed_ioremap;
 	}
-	saif->dma_param.chan_num = res->start;
+	saif->dma_param.chan_num = res1->start;
 
 	saif->irq = platform_get_irq(pdev, 0);
 	if (saif->irq < 0) {

