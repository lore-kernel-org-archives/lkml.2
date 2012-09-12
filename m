Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2ILLrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:47:19 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:46687 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756885Ab2ILLrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:47:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Ricardo Neri <ricardo.neri@ti.com>
Subject: [PATCH 10/11] ASoC: OMAP: mcbsp, mcpdm, dmic, hdmi: Set dma_data at startup time
Date: Wed, 12 Sep 2012 14:47:06 +0300
Message-Id: <1347450427-27627-11-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set the dma_data for the stream (snd_soc_dai_set_dma_data) at dai_startup
time so omap-pcm will have access to the needed information regarding to
the DMA channel earlier.
This is needed for the clean dmaengine support.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-dmic.c  |  6 ++++--
 sound/soc/omap/omap-hdmi.c  | 15 +++++++++------
 sound/soc/omap/omap-mcbsp.c |  7 ++++---
 sound/soc/omap/omap-mcpdm.c |  8 ++++----
 4 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index df0ff24..68f2cd1 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -118,6 +118,7 @@ static int omap_dmic_dai_startup(struct snd_pcm_substream *substream,
 
 	mutex_unlock(&dmic->mutex);
 
+	snd_soc_dai_set_dma_data(dai, substream, &omap_dmic_dai_dma_params);
 	return ret;
 }
 
@@ -202,6 +203,7 @@ static int omap_dmic_dai_hw_params(struct snd_pcm_substream *substream,
 				    struct snd_soc_dai *dai)
 {
 	struct omap_dmic *dmic = snd_soc_dai_get_drvdata(dai);
+	struct omap_pcm_dma_data *dma_data;
 	int channels;
 
 	dmic->clk_div = omap_dmic_select_divider(dmic, params_rate(params));
@@ -227,8 +229,8 @@ static int omap_dmic_dai_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	/* packet size is threshold * channels */
-	omap_dmic_dai_dma_params.packet_size = dmic->threshold * channels;
-	snd_soc_dai_set_dma_data(dai, substream, &omap_dmic_dai_dma_params);
+	dma_data = snd_soc_dai_get_dma_data(dai, substream);
+	dma_data->packet_size = dmic->threshold * channels;
 
 	return 0;
 }
diff --git a/sound/soc/omap/omap-hdmi.c b/sound/soc/omap/omap-hdmi.c
index 0951767..f59c69f 100644
--- a/sound/soc/omap/omap-hdmi.c
+++ b/sound/soc/omap/omap-hdmi.c
@@ -67,6 +67,9 @@ static int omap_hdmi_dai_startup(struct snd_pcm_substream *substream,
 		dev_err(dai->dev, "audio not supported\n");
 		return -ENODEV;
 	}
+
+	snd_soc_dai_set_dma_data(dai, substream, &priv->dma_params);
+
 	return 0;
 }
 
@@ -85,24 +88,24 @@ static int omap_hdmi_dai_hw_params(struct snd_pcm_substream *substream,
 	struct hdmi_priv *priv = snd_soc_dai_get_drvdata(dai);
 	struct snd_aes_iec958 *iec = &priv->iec;
 	struct snd_cea_861_aud_if *cea = &priv->cea;
+	struct omap_pcm_dma_data *dma_data;
 	int err = 0;
 
+	dma_data = snd_soc_dai_get_dma_data(dai, substream);
+
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
-		priv->dma_params.packet_size = 16;
+		dma_data->packet_size = 16;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
-		priv->dma_params.packet_size = 32;
+		dma_data->packet_size = 32;
 		break;
 	default:
 		dev_err(dai->dev, "format not supported!\n");
 		return -EINVAL;
 	}
 
-	priv->dma_params.data_type = 32;
-
-	snd_soc_dai_set_dma_data(dai, substream,
-				 &priv->dma_params);
+	dma_data->data_type = 32;
 
 	/*
 	 * fill the IEC-60958 channel status word
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index a230646..fef2f59 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -151,6 +151,9 @@ static int omap_mcbsp_dai_startup(struct snd_pcm_substream *substream,
 					   SNDRV_PCM_HW_PARAM_PERIOD_SIZE, 2);
 	}
 
+	snd_soc_dai_set_dma_data(cpu_dai, substream,
+				 &mcbsp->dma_data[substream->stream]);
+
 	return err;
 }
 
@@ -228,7 +231,7 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 	int pkt_size = 0;
 	unsigned int format, div, framesize, master;
 
-	dma_data = &mcbsp->dma_data[substream->stream];
+	dma_data = snd_soc_dai_get_dma_data(cpu_dai, substream);
 	channels = params_channels(params);
 
 	switch (params_format(params)) {
@@ -277,8 +280,6 @@ static int omap_mcbsp_dai_hw_params(struct snd_pcm_substream *substream,
 
 	dma_data->packet_size = pkt_size;
 
-	snd_soc_dai_set_dma_data(cpu_dai, substream, dma_data);
-
 	if (mcbsp->configured) {
 		/* McBSP already configured by another stream */
 		return 0;
diff --git a/sound/soc/omap/omap-mcpdm.c b/sound/soc/omap/omap-mcpdm.c
index c1b4935..060cd16 100644
--- a/sound/soc/omap/omap-mcpdm.c
+++ b/sound/soc/omap/omap-mcpdm.c
@@ -266,9 +266,11 @@ static int omap_mcpdm_dai_startup(struct snd_pcm_substream *substream,
 		}
 		omap_mcpdm_open_streams(mcpdm);
 	}
-
 	mutex_unlock(&mcpdm->mutex);
 
+	snd_soc_dai_set_dma_data(dai, substream,
+				 &omap_mcpdm_dai_dma_params[substream->stream]);
+
 	return 0;
 }
 
@@ -323,7 +325,7 @@ static int omap_mcpdm_dai_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	dma_data = &omap_mcpdm_dai_dma_params[stream];
+	dma_data = snd_soc_dai_get_dma_data(dai, substream);
 
 	/* Configure McPDM channels, and DMA packet size */
 	if (stream == SNDRV_PCM_STREAM_PLAYBACK) {
@@ -335,8 +337,6 @@ static int omap_mcpdm_dai_hw_params(struct snd_pcm_substream *substream,
 		dma_data->packet_size = mcpdm->up_threshold * channels;
 	}
 
-	snd_soc_dai_set_dma_data(dai, substream, dma_data);
-
 	return 0;
 }
 
-- 
1.7.12

