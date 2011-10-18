Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1JRCsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:48:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60562 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1JRCsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:48:52 -0400
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Ralf Baechle <ralf@linux-mips.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] sound/soc/au1x: keep pointer to resource so it can be freed
Date: Tue, 18 Oct 2011 05:45:54 +0200
Message-Id: <1318909555-12933-2-git-send-email-julia@diku.dk>
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
 sound/soc/au1x/psc-ac97.c |   14 +++++++-------
 sound/soc/au1x/psc-i2s.c  |   14 +++++++-------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/au1x/psc-ac97.c b/sound/soc/au1x/psc-ac97.c
index 172eefd..62e5640 100644
--- a/sound/soc/au1x/psc-ac97.c
+++ b/sound/soc/au1x/psc-ac97.c
@@ -364,7 +364,7 @@ static const struct snd_soc_dai_driver au1xpsc_ac97_dai_template = {
 static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 {
 	int ret;
-	struct resource *r;
+	struct resource *r, *r1;
 	unsigned long sel;
 	struct au1xpsc_audio_data *wd;
 
@@ -388,15 +388,15 @@ static int __devinit au1xpsc_ac97_drvprobe(struct platform_device *pdev)
 	if (!wd->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
+	r1 = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!r1)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r1->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
+	r1 = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!r1)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r1->start;
 
 	/* configuration: max dma trigger threshold, enable ac97 */
 	wd->cfg = PSC_AC97CFG_RT_FIFO8 | PSC_AC97CFG_TT_FIFO8 |
diff --git a/sound/soc/au1x/psc-i2s.c b/sound/soc/au1x/psc-i2s.c
index 7c5ae92..621e260 100644
--- a/sound/soc/au1x/psc-i2s.c
+++ b/sound/soc/au1x/psc-i2s.c
@@ -290,7 +290,7 @@ static const struct snd_soc_dai_driver au1xpsc_i2s_dai_template = {
 
 static int __devinit au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 {
-	struct resource *r;
+	struct resource *r, *r1;
 	unsigned long sel;
 	int ret;
 	struct au1xpsc_audio_data *wd;
@@ -313,15 +313,15 @@ static int __devinit au1xpsc_i2s_drvprobe(struct platform_device *pdev)
 	if (!wd->mmio)
 		goto out1;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
-	if (!r)
+	r1 = platform_get_resource(pdev, IORESOURCE_DMA, 0);
+	if (!r1)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r1->start;
 
-	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
-	if (!r)
+	r1 = platform_get_resource(pdev, IORESOURCE_DMA, 1);
+	if (!r1)
 		goto out2;
-	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;
+	wd->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r1->start;
 
 	/* preserve PSC clock source set up by platform (dev.platform_data
 	 * is already occupied by soc layer)

