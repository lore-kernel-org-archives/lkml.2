Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2DXWrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:47:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2DXWhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:16 -0400
Message-Id: <20120424223253.800054268@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 04/42] ALSA: hda/conexant - Dont set HP pin-control bit unconditionally
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ca3649de026ff95c6f2847e8d096cf2f411c02b3 upstream.

Some output pins on Conexant chips have no HP control bit, but the
auto-parser initializes these pins unconditionally with PIN_HP.

Check the pin-capability and avoid the HP bit if not supported.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4003,9 +4003,14 @@ static void cx_auto_init_output(struct h
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


