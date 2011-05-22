Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1EVRF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 13:05:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40645 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1EVRF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 13:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vgYMYEfp+fRlCu2MDFLOLqqhDNe6StuuCRdAptMOGrOwEn5W81XEQXf5svn76ad8Qn
         Wfkh5a2UvMfTUXIKn6KA0eiTFfAWokOKeRz5y6EYQ2OAiVfruk28UT1ucuEOn9FDPQN4
         5c71R2yk63KqffJXX7N9j1trj38rkwCfpscmM=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: hsweeten@visionengravers.com, ryan@bluewatersys.com,
        linux-kernel@vger.kernel.org, Mika Westerberg <mika.westerberg@iki.fi>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] ASoC: ep93xx: convert to use the DMA engine API
Date: Sun, 22 May 2011 20:03:06 +0300
Message-Id: <9f8dd1eb40a6cb44d8207c84f244345a98bb9c0f.1306082097.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have the EP93xx DMA engine driver in place, we convert the ASoC
drivers (I2S, AC97 and PCM) to take advantage of this new API. There are no
functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/ep93xx/ep93xx-ac97.c |    4 +-
 sound/soc/ep93xx/ep93xx-i2s.c  |    4 +-
 sound/soc/ep93xx/ep93xx-pcm.c  |  137 ++++++++++++++++++++++-----------------
 3 files changed, 81 insertions(+), 64 deletions(-)

diff --git a/sound/soc/ep93xx/ep93xx-ac97.c b/sound/soc/ep93xx/ep93xx-ac97.c
index 104e95c..c7417c7 100644
--- a/sound/soc/ep93xx/ep93xx-ac97.c
+++ b/sound/soc/ep93xx/ep93xx-ac97.c
@@ -106,12 +106,12 @@ static struct ep93xx_ac97_info *ep93xx_ac97_info;
 
 static struct ep93xx_pcm_dma_params ep93xx_ac97_pcm_out = {
 	.name		= "ac97-pcm-out",
-	.dma_port	= EP93XX_DMA_M2P_PORT_AAC1,
+	.dma_port	= EP93XX_DMA_AAC1,
 };
 
 static struct ep93xx_pcm_dma_params ep93xx_ac97_pcm_in = {
 	.name		= "ac97-pcm-in",
-	.dma_port	= EP93XX_DMA_M2P_PORT_AAC1,
+	.dma_port	= EP93XX_DMA_AAC1,
 };
 
 static inline unsigned ep93xx_ac97_read_reg(struct ep93xx_ac97_info *info,
diff --git a/sound/soc/ep93xx/ep93xx-i2s.c b/sound/soc/ep93xx/ep93xx-i2s.c
index 042f4e9..30df425 100644
--- a/sound/soc/ep93xx/ep93xx-i2s.c
+++ b/sound/soc/ep93xx/ep93xx-i2s.c
@@ -70,11 +70,11 @@ struct ep93xx_i2s_info {
 struct ep93xx_pcm_dma_params ep93xx_i2s_dma_params[] = {
 	[SNDRV_PCM_STREAM_PLAYBACK] = {
 		.name		= "i2s-pcm-out",
-		.dma_port	= EP93XX_DMA_M2P_PORT_I2S1,
+		.dma_port	= EP93XX_DMA_I2S1,
 	},
 	[SNDRV_PCM_STREAM_CAPTURE] = {
 		.name		= "i2s-pcm-in",
-		.dma_port	= EP93XX_DMA_M2P_PORT_I2S1,
+		.dma_port	= EP93XX_DMA_I2S1,
 	},
 };
 
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index a456e49..a07f99c 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/slab.h>
+#include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 
 #include <sound/core.h>
@@ -53,43 +54,34 @@ static const struct snd_pcm_hardware ep93xx_pcm_hardware = {
 
 struct ep93xx_runtime_data
 {
-	struct ep93xx_dma_m2p_client	cl;
-	struct ep93xx_pcm_dma_params	*params;
 	int				pointer_bytes;
-	struct tasklet_struct		period_tasklet;
 	int				periods;
-	struct ep93xx_dma_buffer	buf[32];
+	int				period_bytes;
+	struct dma_chan			*dma_chan;
+	struct ep93xx_dma_data		dma_data;
 };
 
-static void ep93xx_pcm_period_elapsed(unsigned long data)
+static void ep93xx_pcm_dma_callback(void *data)
 {
-	struct snd_pcm_substream *substream = (struct snd_pcm_substream *)data;
-	snd_pcm_period_elapsed(substream);
-}
+	struct snd_pcm_substream *substream = data;
+	struct ep93xx_runtime_data *rtd = substream->runtime->private_data;
 
-static void ep93xx_pcm_buffer_started(void *cookie,
-				      struct ep93xx_dma_buffer *buf)
-{
+	rtd->pointer_bytes += rtd->period_bytes;
+	rtd->pointer_bytes %= rtd->period_bytes * rtd->periods;
+
+	snd_pcm_period_elapsed(substream);
 }
 
-static void ep93xx_pcm_buffer_finished(void *cookie, 
-				       struct ep93xx_dma_buffer *buf, 
-				       int bytes, int error)
+static bool ep93xx_pcm_dma_filter(struct dma_chan *chan, void *filter_param)
 {
-	struct snd_pcm_substream *substream = cookie;
-	struct ep93xx_runtime_data *rtd = substream->runtime->private_data;
-
-	if (buf == rtd->buf + rtd->periods - 1)
-		rtd->pointer_bytes = 0;
-	else
-		rtd->pointer_bytes += buf->size;
+	struct ep93xx_dma_data *data = filter_param;
 
-	if (!error) {
-		ep93xx_dma_m2p_submit_recursive(&rtd->cl, buf);
-		tasklet_schedule(&rtd->period_tasklet);
-	} else {
-		snd_pcm_stop(substream, SNDRV_PCM_STATE_XRUN);
+	if (data->direction == ep93xx_dma_chan_direction(chan)) {
+		chan->private = data;
+		return true;
 	}
+
+	return false;
 }
 
 static int ep93xx_pcm_open(struct snd_pcm_substream *substream)
@@ -98,30 +90,38 @@ static int ep93xx_pcm_open(struct snd_pcm_substream *substream)
 	struct snd_soc_dai *cpu_dai = soc_rtd->cpu_dai;
 	struct ep93xx_pcm_dma_params *dma_params;
 	struct ep93xx_runtime_data *rtd;    
+	dma_cap_mask_t mask;
 	int ret;
 
-	dma_params = snd_soc_dai_get_dma_data(cpu_dai, substream);
+	ret = snd_pcm_hw_constraint_integer(substream->runtime,
+					    SNDRV_PCM_HW_PARAM_PERIODS);
+	if (ret < 0)
+		return ret;
+
 	snd_soc_set_runtime_hwparams(substream, &ep93xx_pcm_hardware);
 
 	rtd = kmalloc(sizeof(*rtd), GFP_KERNEL);
 	if (!rtd) 
 		return -ENOMEM;
 
-	memset(&rtd->period_tasklet, 0, sizeof(rtd->period_tasklet));
-	rtd->period_tasklet.func = ep93xx_pcm_period_elapsed;
-	rtd->period_tasklet.data = (unsigned long)substream;
-
-	rtd->cl.name = dma_params->name;
-	rtd->cl.flags = dma_params->dma_port | EP93XX_DMA_M2P_IGNORE_ERROR |
-		((substream->stream == SNDRV_PCM_STREAM_PLAYBACK) ?
-		 EP93XX_DMA_M2P_TX : EP93XX_DMA_M2P_RX);
-	rtd->cl.cookie = substream;
-	rtd->cl.buffer_started = ep93xx_pcm_buffer_started;
-	rtd->cl.buffer_finished = ep93xx_pcm_buffer_finished;
-	ret = ep93xx_dma_m2p_client_register(&rtd->cl);
-	if (ret < 0) {
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_CYCLIC, mask);
+
+	dma_params = snd_soc_dai_get_dma_data(cpu_dai, substream);
+	rtd->dma_data.port = dma_params->dma_port;
+	rtd->dma_data.name = dma_params->name;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		rtd->dma_data.direction = DMA_TO_DEVICE;
+	else
+		rtd->dma_data.direction = DMA_FROM_DEVICE;
+
+	rtd->dma_chan = dma_request_channel(mask, ep93xx_pcm_dma_filter,
+					    &rtd->dma_data);
+	if (!rtd->dma_chan) {
 		kfree(rtd);
-		return ret;
+		return -EINVAL;
 	}
 	
 	substream->runtime->private_data = rtd;
@@ -132,31 +132,52 @@ static int ep93xx_pcm_close(struct snd_pcm_substream *substream)
 {
 	struct ep93xx_runtime_data *rtd = substream->runtime->private_data;
 
-	ep93xx_dma_m2p_client_unregister(&rtd->cl);
+	dma_release_channel(rtd->dma_chan);
 	kfree(rtd);
 	return 0;
 }
 
+static int ep93xx_pcm_dma_submit(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ep93xx_runtime_data *rtd = runtime->private_data;
+	struct dma_chan *chan = rtd->dma_chan;
+	struct dma_device *dma_dev = chan->device;
+	struct dma_async_tx_descriptor *desc;
+
+	rtd->pointer_bytes = 0;
+	desc = dma_dev->device_prep_dma_cyclic(chan, runtime->dma_addr,
+					       rtd->period_bytes * rtd->periods,
+					       rtd->period_bytes,
+					       rtd->dma_data.direction);
+	if (!desc)
+		return -EINVAL;
+
+	desc->callback = ep93xx_pcm_dma_callback;
+	desc->callback_param = substream;
+
+	dmaengine_submit(desc);
+	return 0;
+}
+
+static void ep93xx_pcm_dma_flush(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct ep93xx_runtime_data *rtd = runtime->private_data;
+
+	dmaengine_terminate_all(rtd->dma_chan);
+}
+
 static int ep93xx_pcm_hw_params(struct snd_pcm_substream *substream,
 				struct snd_pcm_hw_params *params)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct ep93xx_runtime_data *rtd = runtime->private_data;
-	size_t totsize = params_buffer_bytes(params);
-	size_t period = params_period_bytes(params);
-	int i;
 
 	snd_pcm_set_runtime_buffer(substream, &substream->dma_buffer);
-	runtime->dma_bytes = totsize;
-
-	rtd->periods = (totsize + period - 1) / period;
-	for (i = 0; i < rtd->periods; i++) {
-		rtd->buf[i].bus_addr = runtime->dma_addr + (i * period);
-		rtd->buf[i].size = period;
-		if ((i + 1) * period > totsize)
-			rtd->buf[i].size = totsize - (i * period);
-	}
 
+	rtd->periods = params_periods(params);
+	rtd->period_bytes = params_period_bytes(params);
 	return 0;
 }
 
@@ -168,24 +189,20 @@ static int ep93xx_pcm_hw_free(struct snd_pcm_substream *substream)
 
 static int ep93xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 {
-	struct ep93xx_runtime_data *rtd = substream->runtime->private_data;
 	int ret;
-	int i;
 
 	ret = 0;
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		rtd->pointer_bytes = 0;
-		for (i = 0; i < rtd->periods; i++)
-			ep93xx_dma_m2p_submit(&rtd->cl, rtd->buf + i);
+		ret = ep93xx_pcm_dma_submit(substream);
 		break;
 
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		ep93xx_dma_m2p_flush(&rtd->cl);
+		ep93xx_pcm_dma_flush(substream);
 		break;
 
 	default:
-- 
1.7.4.4

