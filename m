Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab1JROJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:09:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51067 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab1JROJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:09:43 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sound/soc: keep pointer to resource so it can be freed
Date: Tue, 18 Oct 2011 17:06:39 +0200
Message-Id: <1318950399-17201-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a new variable for storing resources accessed subsequent to the one
accessed using request_mem_region, so the one accessed using
request_mem_region can be released if needed.

The resource variable names are also changed to be more descriptive.

This code is also missing some calls to iounmap.

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
 sound/soc/au1x/ac97c.c    |   33 ++++++++++++++++++---------------
 sound/soc/au1x/i2sc.c     |   33 ++++++++++++++++++---------------
 sound/soc/au1x/psc-ac97.c |   25 +++++++++++++------------
 sound/soc/au1x/psc-i2s.c  |   25 +++++++++++++------------
 sound/soc/mxs/mxs-saif.c  |   19 ++++++++++---------
 5 files changed, 72 insertions(+), 63 deletions(-)

diff --git a/sound/soc/au1x/ac97c.c b/sound/soc/au1x/ac97c.c
index 13802ff..726bd65 100644
--- a/sound/soc/au1x/ac97c.c
+++ b/sound/soc/au1x/ac97c.c
@@ -226,7 +226,7 @@ static struct snd_soc_dai_driver au1xac97c_dai_driver = {
 static int __devinit au1xac97c_drvprobe(struct platform_device *pdev)
 {
 	int ret;
-	struct resource *r;
+	struct resource *iores, *dmares;
 	struct au1xpsc_audio_data *ctx;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -235,29 +235,30 @@ static int __devinit au1xac97c_drvprobe(struct platform_device *pdev)
 
 	mutex_init(&ctx->lock);
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
 		ret = -ENODEV;
 		goto out0;
 	}
 
 	ret = -EBUSY;
-	if (!request_mem_region(r->start, resource_size(r), pdev->name))
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name))
 		goto out0;
 
-	ctx->mmio = ioremap_nocache(r->start, resource_size(r));
+	ctx->mmio = ioremap_nocache(iores->start, resource_size(iores));
 	if (!ctx->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
-		goto out1;
-	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!dmares)
+		goto out2;
+	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
-		goto out1;
-	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!dmares)
+		goto out2;
+	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	/* switch it on */
 	WR(ctx, AC97_ENABLE, EN_D | EN_CE);
@@ -270,13 +271,15 @@ static int __devinit au1xac97c_drvprobe(struct platform_device *pdev)
 
 	ret = snd_soc_register_dai(&pdev->dev, &au1xac97c_dai_driver);
 	if (ret)
-		goto out1;
+		goto out2;
 
 	ac97c_workdata = ctx;
 	return 0;
 
+out2:
+	iounmap(ctx->mmio);
 out1:
-	release_mem_region(r->start, resource_size(r));
+	release_mem_region(iores->start, resource_size(iores));
 out0:
 	kfree(ctx);
 	return ret;
diff --git a/sound/soc/au1x/i2sc.c b/sound/soc/au1x/i2sc.c
index 19e0d2a..6bcf48f 100644
--- a/sound/soc/au1x/i2sc.c
+++ b/sound/soc/au1x/i2sc.c
@@ -228,47 +228,50 @@ static struct snd_soc_dai_driver au1xi2s_dai_driver = {
 static int __devinit au1xi2s_drvprobe(struct platform_device *pdev)
 {
 	int ret;
-	struct resource *r;
+	struct resource *iores, *dmares;
 	struct au1xpsc_audio_data *ctx;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
 		ret = -ENODEV;
 		goto out0;
 	}
 
 	ret = -EBUSY;
-	if (!request_mem_region(r->start, resource_size(r), pdev->name))
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name))
 		goto out0;
 
-	ctx->mmio = ioremap_nocache(r->start, resource_size(r));
+	ctx->mmio = ioremap_nocache(iores->start, resource_size(iores));
 	if (!ctx->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
-		goto out1;
-	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!dmares)
+		goto out2;
+	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
-		goto out1;
-	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!dmares)
+		goto out2;
+	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	platform_set_drvdata(pdev, ctx);
 
 	ret = snd_soc_register_dai(&pdev->dev, &au1xi2s_dai_driver);
 	if (ret)
-		goto out1;
+		goto out2;
 
 	return 0;
 
+out2:
+	iounmap(ctx->mmio);
 out1:
-	release_mem_region(r->start, resource_size(r));
+	release_mem_region(iores->start, resource_size(iores));
 out0:
 	kfree(ctx);
 	return ret;
diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index 172eefd..cab74ab 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -364,7 +364,7 @@ static const struct snd_soc_dai_driver au1xpsc_ac97_dai_template = {
 static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 {
 	int ret;
-	struct resource *r;
+	struct resource *iores, *dmares;
 	unsigned long sel;
 	struct au1xpsc_audio_data *wd;
 
@@ -374,29 +374,30 @@ static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 
 	mutex_init(&wd->lock);
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
 		ret = -ENODEV;
 		goto out0;
 	}
 
 	ret = -EBUSY;
-	if (!request_mem_region(r->start, resource_size(r), pdev->name))
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name))
 		goto out0;
 
-	wd->mmio = ioremap(r->start, resource_size(r));
+	wd->mmio = ioremap(iores->start, resource_size(iores));
 	if (!wd->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!dmares)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!dmares)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	/* configuration: max dma trigger threshold, enable ac97 */
 	wd->cfg = PSC_AC97CFG_RT_FIFO8 | PSC_AC97CFG_TT_FIFO8 |
@@ -428,7 +429,7 @@ static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 out2:
 	iounmap(wd->mmio);
 out1:
-	release_mem_region(r->start, resource_size(r));
+	release_mem_region(iores->start, resource_size(iores));
 out0:
 	kfree(wd);
 	return ret;
diff --git a/sound/soc/au1x/psc-i2s.c b/sound/soc/au1x/psc-i2s.c
index 7c5ae92..d792bc0 100644
--- a/sound/soc/au1x/psc-i2s.c
+++ b/sound/soc/au1x/psc-i2s.c
@@ -290,7 +290,7 @@ static const struct snd_soc_dai_driver au1xpsc_i2s_dai_template = {
 
 static int __devinit au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 {
-	struct resource *r;
+	struct resource *iores, *dmares;
 	unsigned long sel;
 	int ret;
 	struct au1xpsc_audio_data *wd;
@@ -299,29 +299,30 @@ static int __devinit au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 	if (!wd)
 		return -ENOMEM;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
 		ret = -ENODEV;
 		goto out0;
 	}
 
 	ret = -EBUSY;
-	if (!request_mem_region(r->start, resource_size(r), pdev->name))
+	if (!request_mem_region(iores->start, resource_size(iores),
+				pdev->name))
 		goto out0;
 
-	wd->mmio = ioremap(r->start, resource_size(r));
+	wd->mmio = ioremap(iores->start, resource_size(iores));
 	if (!wd->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!dmares)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = dmares->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!dmares)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = dmares->start;
 
 	/* preserve PSC clock source set up by platform (dev.platform_data
 	 * is already occupied by soc layer)
@@ -355,7 +356,7 @@ static int __devinit au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 out2:
 	iounmap(wd->mmio);
 out1:
-	release_mem_region(r->start, resource_size(r));
+	release_mem_region(iores->start, resource_size(iores));
 out0:
 	kfree(wd);
 	return ret;
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 401944c..76dc74d 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -617,7 +617,7 @@ static irqreturn_t mxs_saif_irq(int irq, void *dev_id)
 
 static int mxs_saif_probe(struct platform_device *pdev)
 {
-	struct resource *res;
+	struct resource *iores, *dmares;
 	struct mxs_saif *saif;
 	struct mxs_saif_platform_data *pdata;
 	int ret = 0;
@@ -655,35 +655,36 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		goto failed_clk;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!iores) {
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "failed to get io resource: %d\n",
 			ret);
 		goto failed_get_resource;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), "mxs-saif")) {
+	if (!request_mem_region(iores->start, resource_size(iores),
+				"mxs-saif")) {
 		dev_err(&pdev->dev, "request_mem_region failed\n");
 		ret = -EBUSY;
 		goto failed_get_resource;
 	}
 
-	saif->base = ioremap(res->start, resource_size(res));
+	saif->base = ioremap(iores->start, resource_size(iores));
 	if (!saif->base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
 		ret = -ENODEV;
 		goto failed_ioremap;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!res) {
+	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!dmares) {
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "failed to get dma resource: %d\n",
 			ret);
 		goto failed_ioremap;
 	}
-	saif->dma_param.chan_num = res->start;
+	saif->dma_param.chan_num = dmares->start;
 
 	saif->irq = platform_get_irq(pdev, 0);
 	if (saif->irq < 0) {
@@ -742,7 +743,7 @@ failed_get_irq2:
 failed_get_irq1:
 	iounmap(saif->base);
 failed_ioremap:
-	release_mem_region(res->start, resource_size(res));
+	release_mem_region(iores->start, resource_size(iores));
 failed_get_resource:
 	clk_put(saif->clk);
 failed_clk:

