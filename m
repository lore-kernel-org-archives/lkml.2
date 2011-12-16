Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab1LPTuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:50:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601Ab1LPTto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:55 2011
Message-Id: <20111216194555.612089493@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [10/53] ASoC: Provide a more complete DMA driver stub
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit cefcc03ffc9527dde56807339edb1719c8dbae5f upstream.

Allow userspace applications to do more parameter setting by providing a
more complete stub DMA driver specifying a wildcard set of formats and
channels and essentially random values for the DMA parameters. This is
required for useful runtime operation of the dummy DMA driver until we
are able to figure out how to power up links and do hw_params() from DAPM.

Sending to stable as without this the dummy driver is not terribly
useful.

Reported-by: Kyung-Kwee Ryu <Kyung-Kwee.Ryu@wolfsonmicro.com>
Tested-by: Kyung-Kwee Ryu <Kyung-Kwee.Ryu@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/soc-utils.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -57,7 +57,36 @@ int snd_soc_params_to_bclk(struct snd_pc
 }
 EXPORT_SYMBOL_GPL(snd_soc_params_to_bclk);
 
-static struct snd_soc_platform_driver dummy_platform;
+static const struct snd_pcm_hardware dummy_dma_hardware = {
+	.formats		= 0xffffffff,
+	.channels_min		= 1,
+	.channels_max		= UINT_MAX,
+
+	/* Random values to keep userspace happy when checking constraints */
+	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+				  SNDRV_PCM_INFO_BLOCK_TRANSFER,
+	.buffer_bytes_max	= 128*1024,
+	.period_bytes_min	= PAGE_SIZE,
+	.period_bytes_max	= PAGE_SIZE*2,
+	.periods_min		= 2,
+	.periods_max		= 128,
+};
+
+static int dummy_dma_open(struct snd_pcm_substream *substream)
+{
+	snd_soc_set_runtime_hwparams(substream, &dummy_dma_hardware);
+
+	return 0;
+}
+
+static struct snd_pcm_ops dummy_dma_ops = {
+	.open		= dummy_dma_open,
+	.ioctl		= snd_pcm_lib_ioctl,
+};
+
+static struct snd_soc_platform_driver dummy_platform = {
+	.ops = &dummy_dma_ops,
+};
 
 static __devinit int snd_soc_dummy_probe(struct platform_device *pdev)
 {


