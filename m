Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2FKSLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:11:14 -0400
Received: from smtp-out-208.synserver.de ([212.40.185.208]:1335 "EHLO
	smtp-out-199.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752573Ab2FKSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:11:09 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31470
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mika Westerberg <mika.westerberg@iki.fi>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/3] ASoC: dmaengine-pcm: Rename and deprecate snd_dmaengine_pcm_pointer
Date: Mon, 11 Jun 2012 20:11:41 +0200
Message-Id: <1339438302-12417-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339438302-12417-1-git-send-email-lars@metafoo.de>
References: <1339438302-12417-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the sound dmaengine pcm helper functions implement the pcm_pointer
callback by trying to count the number of elapsed periods. This is done by
advancing the stream position in the dmaengine callback by one period.
Unfortunately there is no guarantee that the callback will be called for each
elapsed period. It may be possible that under high system load it is only called
once for multiple elapsed periods. This patch renames the current implementation
and documents its shortcomings and that it should not be used anymore in new
drivers.

The next patch will introduce a new snd_dmaengine_pcm_pointer which will be
implemented based on querying the current stream position from the dma device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
If you are maintaining a pcm driver which use the dmaengine pcm helper please
check if you platform works with the new snd_dmaengine_pcm_pointer
implementation which is added in the next patch (ux500 seems to be good
candidate). And if it does send a follow-up patch to convert your platform to
the new implementation. If it does not please try to fix or add residue
reporting support to your dmaengine driver.

This patch is new in v2 of this series

---
 include/sound/dmaengine_pcm.h |    2 +-
 sound/soc/ep93xx/ep93xx-pcm.c |    2 +-
 sound/soc/fsl/imx-pcm-dma.c   |    2 +-
 sound/soc/mxs/mxs-pcm.c       |    2 +-
 sound/soc/soc-dmaengine-pcm.c |   10 +++++-----
 sound/soc/ux500/ux500_pcm.c   |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/sound/dmaengine_pcm.h b/include/sound/dmaengine_pcm.h
index a8fcaa6..ea57915 100644
--- a/include/sound/dmaengine_pcm.h
+++ b/include/sound/dmaengine_pcm.h
@@ -38,7 +38,7 @@ void *snd_dmaengine_pcm_get_data(struct snd_pcm_substream *substream);
 int snd_hwparams_to_dma_slave_config(const struct snd_pcm_substream *substream,
 	const struct snd_pcm_hw_params *params, struct dma_slave_config *slave_config);
 int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd);
-snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream);
+snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream *substream);
 
 int snd_dmaengine_pcm_open(struct snd_pcm_substream *substream,
 	dma_filter_fn filter_fn, void *filter_data);
diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index 162dbb7..4eea98b 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -136,7 +136,7 @@ static struct snd_pcm_ops ep93xx_pcm_ops = {
 	.hw_params	= ep93xx_pcm_hw_params,
 	.hw_free	= ep93xx_pcm_hw_free,
 	.trigger	= snd_dmaengine_pcm_trigger,
-	.pointer	= snd_dmaengine_pcm_pointer,
+	.pointer	= snd_dmaengine_pcm_pointer_no_residue,
 	.mmap		= ep93xx_pcm_mmap,
 };
 
diff --git a/sound/soc/fsl/imx-pcm-dma.c b/sound/soc/fsl/imx-pcm-dma.c
index f3c0a5e..48f9d88 100644
--- a/sound/soc/fsl/imx-pcm-dma.c
+++ b/sound/soc/fsl/imx-pcm-dma.c
@@ -141,7 +141,7 @@ static struct snd_pcm_ops imx_pcm_ops = {
 	.ioctl		= snd_pcm_lib_ioctl,
 	.hw_params	= snd_imx_pcm_hw_params,
 	.trigger	= snd_dmaengine_pcm_trigger,
-	.pointer	= snd_dmaengine_pcm_pointer,
+	.pointer	= snd_dmaengine_pcm_pointer_no_residue,
 	.mmap		= snd_imx_pcm_mmap,
 };
 
diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index 373dec9..f82d766 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -141,7 +141,7 @@ static struct snd_pcm_ops mxs_pcm_ops = {
 	.ioctl		= snd_pcm_lib_ioctl,
 	.hw_params	= snd_mxs_pcm_hw_params,
 	.trigger	= snd_dmaengine_pcm_trigger,
-	.pointer	= snd_dmaengine_pcm_pointer,
+	.pointer	= snd_dmaengine_pcm_pointer_no_residue,
 	.mmap		= snd_mxs_pcm_mmap,
 };
 
diff --git a/sound/soc/soc-dmaengine-pcm.c b/sound/soc/soc-dmaengine-pcm.c
index 4756952..7c0877e 100644
--- a/sound/soc/soc-dmaengine-pcm.c
+++ b/sound/soc/soc-dmaengine-pcm.c
@@ -200,18 +200,18 @@ int snd_dmaengine_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_trigger);
 
 /**
- * snd_dmaengine_pcm_pointer - dmaengine based PCM pointer implementation
+ * snd_dmaengine_pcm_pointer_no_residue - dmaengine based PCM pointer implementation
  * @substream: PCM substream
  *
- * This function can be used as the PCM pointer callback for dmaengine based PCM
- * driver implementations.
+ * This function is deprecated and should not be used by new drivers, as its
+ * results may be unreliable.
  */
-snd_pcm_uframes_t snd_dmaengine_pcm_pointer(struct snd_pcm_substream *substream)
+snd_pcm_uframes_t snd_dmaengine_pcm_pointer_no_residue(struct snd_pcm_substream *substream)
 {
 	struct dmaengine_pcm_runtime_data *prtd = substream_to_prtd(substream);
 	return bytes_to_frames(substream->runtime, prtd->pos);
 }
-EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_pointer);
+EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_pointer_no_residue);
 
 static int dmaengine_pcm_request_channel(struct dmaengine_pcm_runtime_data *prtd,
 	dma_filter_fn filter_fn, void *filter_data)
diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index 66b080e..f8bb9d3 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -261,7 +261,7 @@ static struct snd_pcm_ops ux500_pcm_ops = {
 	.hw_params	= ux500_pcm_hw_params,
 	.hw_free	= ux500_pcm_hw_free,
 	.trigger	= snd_dmaengine_pcm_trigger,
-	.pointer	= snd_dmaengine_pcm_pointer,
+	.pointer	= snd_dmaengine_pcm_pointer_no_residue,
 	.mmap		= ux500_pcm_mmap
 };
 
-- 
1.7.10

