Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab1JSOub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:50:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1JSOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <1318909555-12933-3-git-send-email-julia@diku.dk>
References: <1318909555-12933-3-git-send-email-julia@diku.dk>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Wed, 19 Oct 2011 16:50:08 +0200
Message-ID: <CAOLZvyFoiuHEfpnozWpAM5h92rjay-asqXX0tY1P1ZzO8eTGOQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] sound/soc/au1x: keep pointer to resource so it can be freed
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Axel Lin <axel.lin@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 5:45 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Add a new variable for storing resources accessed subsequent to the one
> accessed using request_mem_region, so the one accessed using
> request_mem_region can be released if needed.
>
> This code is also missing some calls to iounmap.

How about something much simpler, like this:

>From 940e38b3f0beff6fcd8f62f627dce622e9ca0e54 Mon Sep 17 00:00:00 2001
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Wed, 19 Oct 2011 16:45:12 +0200
Subject: [PATCH] ASoC: au1x: fix error paths in ac97c/i2cs probe callbacks.

add iounmap() and release the correct mem resource.

Signed-off-by: Manuel Lauss <manuel.lauss@googlemail.com>
---
 sound/soc/au1x/ac97c.c |    7 +++++--
 sound/soc/au1x/i2sc.c  |    7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/soc/au1x/ac97c.c b/sound/soc/au1x/ac97c.c
index 13802ff..4ec39aa 100644
--- a/sound/soc/au1x/ac97c.c
+++ b/sound/soc/au1x/ac97c.c
@@ -251,12 +251,12 @@ static int __devinit au1xac97c_drvprobe(struct
platform_device *pdev)

 	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!r)
-		goto out1;
+		goto out2;
 	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;

 	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!r)
-		goto out1;
+		goto out2;
 	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;

 	/* switch it on */
@@ -275,7 +275,10 @@ static int __devinit au1xac97c_drvprobe(struct
platform_device *pdev)
 	ac97c_workdata = ctx;
 	return 0;

+out2:
+	iounmap(ctx->mmio);
 out1:
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 out0:
 	kfree(ctx);
diff --git a/sound/soc/au1x/i2sc.c b/sound/soc/au1x/i2sc.c
index 19e0d2a..59fb31a 100644
--- a/sound/soc/au1x/i2sc.c
+++ b/sound/soc/au1x/i2sc.c
@@ -251,12 +251,12 @@ static int __devinit au1xi2s_drvprobe(struct
platform_device *pdev)

 	r = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!r)
-		goto out1;
+		goto out2;
 	ctx->dmaids[SNDRV_PCM_STREAM_PLAYBACK] = r->start;

 	r = platform_get_resource(pdev, IORESOURCE_DMA, 1);
 	if (!r)
-		goto out1;
+		goto out2;
 	ctx->dmaids[SNDRV_PCM_STREAM_CAPTURE] = r->start;

 	platform_set_drvdata(pdev, ctx);
@@ -267,7 +267,10 @@ static int __devinit au1xi2s_drvprobe(struct
platform_device *pdev)

 	return 0;

+out2:
+	iounmap(ctx->mmio);
 out1:
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
 out0:
 	kfree(ctx);
-- 
1.7.7
