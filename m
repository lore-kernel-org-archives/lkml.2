Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab2C3VFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:05:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36741 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934883Ab2C3VF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:27 -0400
Message-Id: <20120330195728.699604322@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Mack <zonque@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 046/108] ASoC: pxa-ssp: atomically set stream active masks
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit 273b72c8ce6b28df6b49423d775c3e59072c73c5 upstream.

PXA's SSP engine fails to take its current channel phase into account
when enabling a stream while the engine is already running. This
results in randomly swapped left/right channels on either the record
or the playback side, depending on which one was enabled first.

The following patch fixes this by factoring out the bit field
modifications in question to a separate function that pauses the
engine temporarily, modifies the bits and kicks it off again
afterwards. Appearantly, a transition of SSCR0_SSE syncs both
directions properly.

The patch has been rolled out to quite a number of devices over the
last weeks and seems to fix the issue reliably.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Reported-and-tested-by: Sven Neumann <s.neumann@raumfeld.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/pxa/pxa-ssp.c |   61 ++++++++++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

--- a/sound/soc/pxa/pxa-ssp.c
+++ b/sound/soc/pxa/pxa-ssp.c
@@ -668,6 +668,38 @@ static int pxa_ssp_hw_params(struct snd_
 	return 0;
 }
 
+static void pxa_ssp_set_running_bit(struct snd_pcm_substream *substream,
+				    struct ssp_device *ssp, int value)
+{
+	uint32_t sscr0 = pxa_ssp_read_reg(ssp, SSCR0);
+	uint32_t sscr1 = pxa_ssp_read_reg(ssp, SSCR1);
+	uint32_t sspsp = pxa_ssp_read_reg(ssp, SSPSP);
+	uint32_t sssr = pxa_ssp_read_reg(ssp, SSSR);
+
+	if (value && (sscr0 & SSCR0_SSE))
+		pxa_ssp_write_reg(ssp, SSCR0, sscr0 & ~SSCR0_SSE);
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		if (value)
+			sscr1 |= SSCR1_TSRE;
+		else
+			sscr1 &= ~SSCR1_TSRE;
+	} else {
+		if (value)
+			sscr1 |= SSCR1_RSRE;
+		else
+			sscr1 &= ~SSCR1_RSRE;
+	}
+
+	pxa_ssp_write_reg(ssp, SSCR1, sscr1);
+
+	if (value) {
+		pxa_ssp_write_reg(ssp, SSSR, sssr);
+		pxa_ssp_write_reg(ssp, SSPSP, sspsp);
+		pxa_ssp_write_reg(ssp, SSCR0, sscr0 | SSCR0_SSE);
+	}
+}
+
 static int pxa_ssp_trigger(struct snd_pcm_substream *substream, int cmd,
 			   struct snd_soc_dai *cpu_dai)
 {
@@ -681,42 +713,21 @@ static int pxa_ssp_trigger(struct snd_pc
 		pxa_ssp_enable(ssp);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		val = pxa_ssp_read_reg(ssp, SSCR1);
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			val |= SSCR1_TSRE;
-		else
-			val |= SSCR1_RSRE;
-		pxa_ssp_write_reg(ssp, SSCR1, val);
+		pxa_ssp_set_running_bit(substream, ssp, 1);
 		val = pxa_ssp_read_reg(ssp, SSSR);
 		pxa_ssp_write_reg(ssp, SSSR, val);
 		break;
 	case SNDRV_PCM_TRIGGER_START:
-		val = pxa_ssp_read_reg(ssp, SSCR1);
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			val |= SSCR1_TSRE;
-		else
-			val |= SSCR1_RSRE;
-		pxa_ssp_write_reg(ssp, SSCR1, val);
-		pxa_ssp_enable(ssp);
+		pxa_ssp_set_running_bit(substream, ssp, 1);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		val = pxa_ssp_read_reg(ssp, SSCR1);
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			val &= ~SSCR1_TSRE;
-		else
-			val &= ~SSCR1_RSRE;
-		pxa_ssp_write_reg(ssp, SSCR1, val);
+		pxa_ssp_set_running_bit(substream, ssp, 0);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		pxa_ssp_disable(ssp);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		val = pxa_ssp_read_reg(ssp, SSCR1);
-		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-			val &= ~SSCR1_TSRE;
-		else
-			val &= ~SSCR1_RSRE;
-		pxa_ssp_write_reg(ssp, SSCR1, val);
+		pxa_ssp_set_running_bit(substream, ssp, 0);
 		break;
 
 	default:


