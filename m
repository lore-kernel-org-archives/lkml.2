Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2EIFwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752884Ab2EIFwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:12 -0400
Message-Id: <20120509055030.051275955@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 003/167] [PATCH] ALSA: hda/conexant - Dont set HP pin-control bit
 unconditionally
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ca3649de026ff95c6f2847e8d096cf2f411c02b3 upstream.

Some output pins on Conexant chips have no HP control bit, but the
auto-parser initializes these pins unconditionally with PIN_HP.

Check the pin-capability and avoid the HP bit if not supported.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index d29d6d3..f52c9ef 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3951,9 +3951,14 @@ static void cx_auto_init_output(struct hda_codec *codec)
 	int i;
 
 	mute_outputs(codec, spec->multiout.num_dacs, spec->multiout.dac_nids);
-	for (i = 0; i < cfg->hp_outs; i++)
+	for (i = 0; i < cfg->hp_outs; i++) {
+		unsigned int val = PIN_OUT;
+		if (snd_hda_query_pin_caps(codec, cfg->hp_pins[i]) &
+		    AC_PINCAP_HP_DRV)
+			val |= AC_PINCTL_HP_EN;
 		snd_hda_codec_write(codec, cfg->hp_pins[i], 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP);
+				    AC_VERB_SET_PIN_WIDGET_CONTROL, val);
+	}
 	mute_outputs(codec, cfg->hp_outs, cfg->hp_pins);
 	mute_outputs(codec, cfg->line_outs, cfg->line_out_pins);
 	mute_outputs(codec, cfg->speaker_outs, cfg->speaker_pins);
-- 
1.7.10



