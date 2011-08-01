Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1HAXYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:24:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38160 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1HAXY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:52 2011
Message-Id: <20110801232052.003994154@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [14/70] ASoC: Fix Blackfin I2S _pointer() implementation return in bounds values
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e999dc50404d401150a5429b6459473a691fd1a0 upstream.

The Blackfin DMA controller can report one frame beyond the end of the
buffer in the wraparound case but ALSA requires that the pointer always
be in the buffer. Do the wraparound to handle this. A similar bug is
likely to apply to the other Blackfin PCM drivers but the code is less
obvious to inspection and I don't have a user to test.

Reported-by: Kieran O'Leary <Kieran.O'Leary@wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/blackfin/bf5xx-i2s-pcm.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -138,11 +138,20 @@ static snd_pcm_uframes_t bf5xx_pcm_point
 	pr_debug("%s enter\n", __func__);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		diff = sport_curr_offset_tx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	} else {
 		diff = sport_curr_offset_rx(sport);
-		frames = bytes_to_frames(substream->runtime, diff);
 	}
+
+	/*
+	 * TX at least can report one frame beyond the end of the
+	 * buffer if we hit the wraparound case - clamp to within the
+	 * buffer as the ALSA APIs require.
+	 */
+	if (diff == snd_pcm_lib_buffer_bytes(substream))
+		diff = 0;
+
+	frames = bytes_to_frames(substream->runtime, diff);
+
 	return frames;
 }
 


