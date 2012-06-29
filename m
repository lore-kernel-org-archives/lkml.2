Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab2F2K1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:27:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19758 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2F2K0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:26:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 29 Jun 2012 03:26:36 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tiwai@suse.de>, <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>,
        <lars@metafoo.de>, <swarren@nvidia.com>, <perex@perex.cz>,
        <clemens@ladisch.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] ASoC: add apis for creating/free pcm dma buffer
Date: Fri, 29 Jun 2012 15:53:17 +0530
Message-ID: <1340965398-20872-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
References: <1340965398-20872-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APIs for creating and freeing the new pcm writecombine
dma buffer.
Adding these APIs for ARM only and if other architecture
supports the write combine dma buffer then these APIs can
be extended to that architecture.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/sound/soc.h  |   13 +++++++++++++
 sound/soc/soc-core.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index e063380..6050ac7 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -1153,6 +1153,19 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname);
 
+/**
+ * Create the snd_soc_pcm using the writecombine dma buffer.
+ * The writecombine dma buffer is supported on some architecture
+ * like ARM and so restricting this for ARM only.
+ * The more architecture can be added here or make it available for
+ * all architecture if writecombine dma buffer is supported.
+ */
+#ifdef CONFIG_ARM
+int snd_soc_pcm_new_writecombine_dma_buffer(struct snd_soc_pcm_runtime *rtd,
+		size_t max_bytes);
+void snd_soc_pcm_free_writecombine_dma_buffer(struct snd_pcm *pcm);
+#endif
+
 #include <sound/soc-dai.h>
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index fe16135..d2c0dc4 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -29,6 +29,7 @@
 #include <linux/pm.h>
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
+#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
@@ -4094,6 +4095,55 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
 }
 EXPORT_SYMBOL_GPL(snd_soc_of_parse_card_name);
 
+#ifdef CONFIG_ARM
+static u64 snd_soc_pcm_wc_dma_mask = DMA_BIT_MASK(32);
+int snd_soc_pcm_new_writecombine_dma_buffer(struct snd_soc_pcm_runtime *rtd,
+		size_t max_bytes)
+{
+	struct snd_card *card = rtd->card->snd_card;
+	struct snd_pcm *pcm = rtd->pcm;
+	int ret = 0;
+
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &snd_soc_pcm_wc_dma_mask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
+
+	if (pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream) {
+		ret = snd_pcm_lib_alloc_writecombine_dma_buffer(pcm,
+				max_bytes, SNDRV_PCM_STREAM_PLAYBACK);
+		if (ret)
+			goto err;
+	}
+	if (pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream) {
+		ret = snd_pcm_lib_alloc_writecombine_dma_buffer(pcm,
+				max_bytes, SNDRV_PCM_STREAM_CAPTURE);
+		if (ret)
+			goto err_free_play;
+	}
+
+	return 0;
+
+err_free_play:
+	snd_pcm_lib_dealloc_writecombine_dma_buffer(pcm,
+				SNDRV_PCM_STREAM_PLAYBACK);
+err:
+	return ret;
+
+}
+EXPORT_SYMBOL_GPL(snd_soc_pcm_new_writecombine_dma_buffer);
+
+void snd_soc_pcm_free_writecombine_dma_buffer(struct snd_pcm *pcm)
+{
+	snd_pcm_lib_dealloc_writecombine_dma_buffer(pcm,
+					SNDRV_PCM_STREAM_CAPTURE);
+	snd_pcm_lib_dealloc_writecombine_dma_buffer(pcm,
+					SNDRV_PCM_STREAM_PLAYBACK);
+}
+EXPORT_SYMBOL_GPL(snd_soc_pcm_free_writecombine_dma_buffer);
+#endif
+
+
 int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
 				   const char *propname)
 {
-- 
1.7.1.1

