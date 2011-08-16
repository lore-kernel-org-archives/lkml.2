Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1HPCvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1HPCvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:04 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:54 2011
Message-Id: <20110816024454.835321979@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Warren <swarren@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [18/26] ASoC: Tegra: tegra_pcm_deallocate_dma_buffer: Dont OOPS
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit a96edd59b2bc88b3d1ea47e0ba48076d65db9302 upstream.

Not all PCM devices have all sub-streams. Specifically, the SPDIF driver
only supports playback and hence has no capture substream. Check whether
a substream exists before dereferencing it, when de-allocating DMA
buffers in tegra_pcm_deallocate_dma_buffer.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/tegra/tegra_pcm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -309,9 +309,14 @@ static int tegra_pcm_preallocate_dma_buf
 
 static void tegra_pcm_deallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 {
-	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
-	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
 
+	substream = pcm->streams[stream].substream;
+	if (!substream)
+		return;
+
+	buf = &substream->dma_buffer;
 	if (!buf->area)
 		return;
 


