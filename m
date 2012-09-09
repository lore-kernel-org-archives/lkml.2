Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2IIXXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:23:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51495 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379Ab2IIXRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:11 -0400
Message-Id: <20120909224156.568086441@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christop Fritz <chf.fritz@googlemail.com>
Subject: [ 42/95] ASoC: wm9712: Fix microphone source selection
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit ccf795847a38235ee4a56a24129ce75147d6ba8f upstream.

Currently the microphone input source is not selectable as while there is
a DAPM widget it's not connected to anything so it won't be properly
instantiated. Add something more correct for the input structure to get
things going, even though it's not hooked into the rest of the routing
map and so won't actually achieve anything except allowing the relevant
register bits to be written.

Reported-by: Christop Fritz <chf.fritz@googlemail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/soc/codecs/wm9712.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm9712.c b/sound/soc/codecs/wm9712.c
index f16fb36..fd74b88 100644
--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -272,7 +272,7 @@ SOC_DAPM_ENUM("Route", wm9712_enum[9]);
 
 /* Mic select */
 static const struct snd_kcontrol_new wm9712_mic_src_controls =
-SOC_DAPM_ENUM("Route", wm9712_enum[7]);
+SOC_DAPM_ENUM("Mic Source Select", wm9712_enum[7]);
 
 /* diff select */
 static const struct snd_kcontrol_new wm9712_diff_sel_controls =
@@ -291,7 +291,9 @@ SND_SOC_DAPM_MUX("Left Capture Select", SND_SOC_NOPM, 0, 0,
 	&wm9712_capture_selectl_controls),
 SND_SOC_DAPM_MUX("Right Capture Select", SND_SOC_NOPM, 0, 0,
 	&wm9712_capture_selectr_controls),
-SND_SOC_DAPM_MUX("Mic Select Source", SND_SOC_NOPM, 0, 0,
+SND_SOC_DAPM_MUX("Left Mic Select Source", SND_SOC_NOPM, 0, 0,
+	&wm9712_mic_src_controls),
+SND_SOC_DAPM_MUX("Right Mic Select Source", SND_SOC_NOPM, 0, 0,
 	&wm9712_mic_src_controls),
 SND_SOC_DAPM_MUX("Differential Source", SND_SOC_NOPM, 0, 0,
 	&wm9712_diff_sel_controls),
@@ -319,6 +321,7 @@ SND_SOC_DAPM_PGA("Out 3 PGA", AC97_INT_PAGING, 5, 1, NULL, 0),
 SND_SOC_DAPM_PGA("Line PGA", AC97_INT_PAGING, 2, 1, NULL, 0),
 SND_SOC_DAPM_PGA("Phone PGA", AC97_INT_PAGING, 1, 1, NULL, 0),
 SND_SOC_DAPM_PGA("Mic PGA", AC97_INT_PAGING, 0, 1, NULL, 0),
+SND_SOC_DAPM_PGA("Differential Mic", SND_SOC_NOPM, 0, 0, NULL, 0),
 SND_SOC_DAPM_MICBIAS("Mic Bias", AC97_INT_PAGING, 10, 1),
 SND_SOC_DAPM_OUTPUT("MONOOUT"),
 SND_SOC_DAPM_OUTPUT("HPOUTL"),
@@ -379,6 +382,18 @@ static const struct snd_soc_dapm_route wm9712_audio_map[] = {
 	{"Mic PGA", NULL, "MIC1"},
 	{"Mic PGA", NULL, "MIC2"},
 
+	/* microphones */
+	{"Differential Mic", NULL, "MIC1"},
+	{"Differential Mic", NULL, "MIC2"},
+	{"Left Mic Select Source", "Mic 1", "MIC1"},
+	{"Left Mic Select Source", "Mic 2", "MIC2"},
+	{"Left Mic Select Source", "Stereo", "MIC1"},
+	{"Left Mic Select Source", "Differential", "Differential Mic"},
+	{"Right Mic Select Source", "Mic 1", "MIC1"},
+	{"Right Mic Select Source", "Mic 2", "MIC2"},
+	{"Right Mic Select Source", "Stereo", "MIC2"},
+	{"Right Mic Select Source", "Differential", "Differential Mic"},
+
 	/* left capture selector */
 	{"Left Capture Select", "Mic", "MIC1"},
 	{"Left Capture Select", "Speaker Mixer", "Speaker Mixer"},


