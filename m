Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab0K2JhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:37:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55258 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0K2JhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TLfJoM8vaesRalm76E4qasLjnAV836HC6cm9pf1R7+T+tx+TEuqFG+oOZddwETdKAQ
         ZYRLVGdAkW6CrftrrbsgT6qpQb/0ln9HI3DrQEr2/wiVQxM/yMoUeR7SnoTbWT2gnGDX
         anFhwNZXlqPuQjGeUehcgkEctIOU2WZwiWaIQ=
Subject: [RFC][PATCH 4/5] ASoC: Fix missing spin_unlock_irqrestore
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wan ZongShun <mcuos.com@gmail.com>, alsa-devel@alsa-project.org
In-Reply-To: <1291023491.22911.1.camel@mola>
References: <1291023491.22911.1.camel@mola>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 17:42:47 +0800
Message-Id: <1291023767.22911.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In nuc900_dma_hw_params(), if snd_pcm_lib_malloc_pages failed
it returns without calling spin_unlock_irqrestore().

Since snd_pcm_lib_malloc_pages() does not touch struct nuc900_audio,
we don't need to hold the lock while calling snd_pcm_lib_malloc_pages().
Fix it by moving spin_lock_irqsave() down to after snd_pcm_lib_malloc_pages().

In nuc900_dma_prepare(), spin_unlock_irqrestore() is missing in the error path.
Fix it by removing the return in default case.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---

hi ZongShun,
I don't have this hardware handy, could you help to test this patch
if you think this patch is ok.

Regards,
Axel

 sound/soc/nuc900/nuc900-pcm.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
index 2245f8b..8263f56 100644
--- a/sound/soc/nuc900/nuc900-pcm.c
+++ b/sound/soc/nuc900/nuc900-pcm.c
@@ -50,12 +50,12 @@ static int nuc900_dma_hw_params(struct snd_pcm_substream *substream,
 	unsigned long flags;
 	int ret = 0;
 
-	spin_lock_irqsave(&nuc900_audio->lock, flags);
-
 	ret = snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(params));
 	if (ret < 0)
 		return ret;
 
+	spin_lock_irqsave(&nuc900_audio->lock, flags);
+
 	nuc900_audio->substream = substream;
 	nuc900_audio->dma_addr[substream->stream] = runtime->dma_addr;
 	nuc900_audio->buffersize[substream->stream] =
@@ -169,6 +169,7 @@ static int nuc900_dma_prepare(struct snd_pcm_substream *substream)
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct nuc900_audio *nuc900_audio = runtime->private_data;
 	unsigned long flags, val;
+	int ret = 0;
 
 	spin_lock_irqsave(&nuc900_audio->lock, flags);
 
@@ -197,10 +198,10 @@ static int nuc900_dma_prepare(struct snd_pcm_substream *substream)
 		AUDIO_WRITE(nuc900_audio->mmio + ACTL_RESET, val);
 		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 	spin_unlock_irqrestore(&nuc900_audio->lock, flags);
-	return 0;
+	return ret;
 }
 
 static int nuc900_dma_trigger(struct snd_pcm_substream *substream, int cmd)
-- 
1.7.2



