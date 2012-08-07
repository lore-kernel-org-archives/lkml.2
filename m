Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191Ab2HGDmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:42:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964843Ab2HGDi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:59 -0400
Message-Id: <20120807032800.381511317@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:24 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 29/70] ALSA: hda - Fix invalid D3 of headphone DAC on VT202x codecs
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6162552b0de6ba80937c3dd53e084967851cd199 upstream.

We've got a bug report about the silent output from the headphone on a
mobo with VT2021, and spotted out that this was because of the wrong
D3 state on the DAC for the headphone output.  The bug is triggered by
the incomplete check for this DAC in set_widgets_power_state_vt1718S().
It checks only the connectivity of the primary output (0x27) but
doesn't consider the path from the headphone pin (0x28).

Now this patch fixes the problem by checking both pins for DAC 0x0b.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: keep using snd_hda_codec_write() as
 update_power_state() is missing]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3227,7 +3227,7 @@ static void set_widgets_power_state_vt17
 {
 	struct via_spec *spec = codec->spec;
 	int imux_is_smixer;
-	unsigned int parm;
+	unsigned int parm, parm2;
 	/* MUX6 (1eh) = stereo mixer */
 	imux_is_smixer =
 	snd_hda_codec_read(codec, 0x1e, 0, AC_VERB_GET_CONNECT_SEL, 0x00) == 5;
@@ -3250,7 +3250,7 @@ static void set_widgets_power_state_vt17
 	parm = AC_PWRST_D3;
 	set_pin_power_state(codec, 0x27, &parm);
 	snd_hda_codec_write(codec, 0x1a, 0, AC_VERB_SET_POWER_STATE, parm);
-	snd_hda_codec_write(codec, 0xb, 0, AC_VERB_SET_POWER_STATE, parm);
+	parm2 = parm; /* for pin 0x0b */
 
 	/* PW2 (26h), AOW2 (ah) */
 	parm = AC_PWRST_D3;
@@ -3265,6 +3265,9 @@ static void set_widgets_power_state_vt17
 	if (!spec->hp_independent_mode) /* check for redirected HP */
 		set_pin_power_state(codec, 0x28, &parm);
 	snd_hda_codec_write(codec, 0x8, 0, AC_VERB_SET_POWER_STATE, parm);
+	if (!spec->hp_independent_mode && parm2 != AC_PWRST_D3)
+		parm = parm2;
+	snd_hda_codec_write(codec, 0xb, 0, AC_VERB_SET_POWER_STATE, parm);
 	/* MW9 (21h), Mw2 (1ah), AOW0 (8h) */
 	snd_hda_codec_write(codec, 0x21, 0, AC_VERB_SET_POWER_STATE,
 			    imux_is_smixer ? AC_PWRST_D0 : parm);


