Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108Ab2I1S6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:34 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35428 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965095Ab2I1S63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dylan Reid <dgreid@chromium.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 095/262] ASoC: samsung dma - Dont indicate support for pause/resume.
Date: Fri, 28 Sep 2012 11:50:24 -0700
Message-Id: <20120928183009.290008641@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dylan Reid <dgreid@chromium.org>

commit 57b2d68863f281737d8596cb3d76d89d9cc54fd8 upstream.

The pause and resume operations indicate that the stream can be
un-paused/resumed from the exact location they were paused/suspended.
This is not true for this driver, the pause and suspend triggers share
the same code path with stop, they flush all pending DMA transfers.
This drops all pending samples.  The pause_release/resume triggers are
the same as start, except that prepare won't be called beforehand,
nothing will be enqueued to the DMA engine and nothing will happen (no
audio).  Removing the pause flag will let apps know that it isn't
supported.  Removing the resume flag will cause user space to call
prepare and start instead of resume, so audio will continue playing when
the system wakes up.

Before removing the pause and resume flags, I tested this on an exynos
5250, using 'aplay -i'. Pause/un-pause leads to silence followed by a
write error.  Suspend/resume testing led to the same result.  Removing
the two flags fixes suspend/resume (since snd_pcm_prepare is called
again). And leads to a proper reporting of pause not supported.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/samsung/dma.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -34,9 +34,7 @@ static const struct snd_pcm_hardware dma
 	.info			= SNDRV_PCM_INFO_INTERLEAVED |
 				    SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				    SNDRV_PCM_INFO_MMAP |
-				    SNDRV_PCM_INFO_MMAP_VALID |
-				    SNDRV_PCM_INFO_PAUSE |
-				    SNDRV_PCM_INFO_RESUME,
+				    SNDRV_PCM_INFO_MMAP_VALID,
 	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
 				    SNDRV_PCM_FMTBIT_U16_LE |
 				    SNDRV_PCM_FMTBIT_U8 |
@@ -246,15 +244,11 @@ static int dma_trigger(struct snd_pcm_su
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
-	case SNDRV_PCM_TRIGGER_RESUME:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		prtd->state |= ST_RUNNING;
 		prtd->params->ops->trigger(prtd->params->ch);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		prtd->state &= ~ST_RUNNING;
 		prtd->params->ops->stop(prtd->params->ch);
 		break;


