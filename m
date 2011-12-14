Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab1LNM7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 07:59:49 -0500
Received: from multi.imgtec.com ([194.200.65.239]:48548 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583Ab1LNM7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 07:59:48 -0500
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 07:59:48 EST
Message-ID: <4EE89A06.80101@imgtec.com>
Date: Wed, 14 Dec 2011 12:43:50 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Neil <neil.jones@imgtec.com>
Subject: bugs in "ASoC: core - Optimise and refactor pcm_new() to pass only
 rtd"?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2011 12:43:50.0546 (UTC) FILETIME=[07AE5720:01CCBA5E]
X-SEF-Processed: 7_3_0_01158__2011_12_14_12_43_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've bisected a problem with an out of tree set of asoc drivers down to commit
552d1ef6b5a98d7b95959d5b139071e3c90cebf1 ("ASoC: core - Optimise and refactor
pcm_new() to pass only rtd"). By the looks of it this change was intended not 
to change the workings of the code, however the dai parameter of pcm_new used
to be passed codec_dai in soc_new_pcm() (initialised from rtd->codec_dai), but
each driver now sets it's dai to rtd->cpu_dai instead. This seems to make the
driver check the wrong dai's driver->capture.channels_min in the pcm_new
callback, which makes it dereference
pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream in the driver's
preallocate_dma_buffer() function which can be NULL. Is this a bug (in every
pcm asoc driver) that just happens not to have been noticed, or have I
misunderstood it?

Relevant snippets of the original patch below.

Thanks
James

diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index 5cb3b88..9465588 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -425,9 +425,11 @@ static void dma_free_dma_buffers(struct snd_pcm *pcm)
 
 static u64 dma_mask = DMA_BIT_MASK(32);
 
-static int dma_new(struct snd_card *card,
-	struct snd_soc_dai *dai, struct snd_pcm *pcm)
+static int dma_new(struct snd_soc_pcm_runtime *rtd)
 {
+	struct snd_card *card = rtd->card->snd_card;
+	struct snd_soc_dai *dai = rtd->cpu_dai;
+	struct snd_pcm *pcm = rtd->pcm;
 	int ret = 0;
 
 	pr_debug("Entered %s\n", __func__);


diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c53f5d5..29bf9fb 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2143,8 +2143,7 @@ static int soc_new_pcm(struct snd_soc_pcm_runtime *rtd, int num)
 		snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &soc_pcm_ops);
 
 	if (platform->driver->pcm_new) {
-		ret = platform->driver->pcm_new(rtd->card->snd_card,
-						codec_dai, pcm);
+		ret = platform->driver->pcm_new(rtd);
 		if (ret < 0) {
 			pr_err("asoc: platform pcm constructor failed\n");
 			return ret;

