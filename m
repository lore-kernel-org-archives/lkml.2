Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2ILLss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 07:48:48 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:37916 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755114Ab2ILLq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 07:46:57 -0400
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
Subject: [PATCH 05/11] ASoC: omap-pcm: Prepare to configure the DMA data_type based on stream properties
Date: Wed, 12 Sep 2012 14:47:01 +0300
Message-Id: <1347450427-27627-6-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347450427-27627-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the format of the stream the omap-pcm can decide alone what data
type should be used with by the sDMA.
Keep the possibility for OMAP dai drivers to tell omap-pcm if they want to
use different data type. This is needed for the omap-hdmi for example which
needs 32bit data type even if the stream format is S16_LE.

The check if (dma_data->data_type) is safe at the moment since omap-pcm
does not support 8bit samples (OMAP_DMA_DATA_TYPE_S8 == 0x00).

The next step is to redefine the meaning of dma_data->data_type to unblock
this limitation.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/omap/omap-pcm.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/sound/soc/omap/omap-pcm.c b/sound/soc/omap/omap-pcm.c
index 02eeb2e..4c13a5f 100644
--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -149,6 +149,24 @@ static int omap_pcm_hw_free(struct snd_pcm_substream *substream)
 	return 0;
 }
 
+static int omap_pcm_get_dma_type(int num_bits)
+{
+	int data_type;
+
+	switch (num_bits) {
+	case 16:
+		data_type = OMAP_DMA_DATA_TYPE_S16;
+		break;
+	case 32:
+		data_type = OMAP_DMA_DATA_TYPE_S32;
+		break;
+	default:
+		data_type = -EINVAL;
+		break;
+	}
+	return data_type;
+}
+
 static int omap_pcm_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
@@ -163,7 +181,16 @@ static int omap_pcm_prepare(struct snd_pcm_substream *substream)
 		return 0;
 
 	memset(&dma_params, 0, sizeof(dma_params));
-	dma_params.data_type			= dma_data->data_type;
+
+	if (dma_data->data_type)
+		dma_params.data_type = dma_data->data_type;
+	else
+		dma_params.data_type = omap_pcm_get_dma_type(
+				snd_pcm_format_physical_width(runtime->format));
+
+	if (dma_params.data_type < 0)
+		return dma_params.data_type;
+
 	dma_params.trigger			= dma_data->dma_req;
 
 	if (dma_data->packet_size)
@@ -195,7 +222,7 @@ static int omap_pcm_prepare(struct snd_pcm_substream *substream)
 	 * still can get an interrupt at each period bounary
 	 */
 	bytes = snd_pcm_lib_period_bytes(substream);
-	dma_params.elem_count	= bytes >> dma_data->data_type;
+	dma_params.elem_count	= bytes >> dma_params.data_type;
 	dma_params.frame_count	= runtime->periods;
 	omap_set_dma_params(prtd->dma_ch, &dma_params);
 
-- 
1.7.12

