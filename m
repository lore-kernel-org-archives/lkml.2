Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827Ab2HGWlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:41:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030810Ab2HGWlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:41:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 098/109] ALSA: hda - Fix invalid D3 of headphone DAC on VT202x codecs
Date: Tue,  7 Aug 2012 15:35:57 -0700
Message-Id: <20120807222051.668177324@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3233,7 +3233,7 @@ static void set_widgets_power_state_vt17
 {
 	struct via_spec *spec = codec->spec;
 	int imux_is_smixer;
-	unsigned int parm;
+	unsigned int parm, parm2;
 	/* MUX6 (1eh) = stereo mixer */
 	imux_is_smixer =
 	snd_hda_codec_read(codec, 0x1e, 0, AC_VERB_GET_CONNECT_SEL, 0x00) == 5;
@@ -3256,7 +3256,7 @@ static void set_widgets_power_state_vt17
 	parm = AC_PWRST_D3;
 	set_pin_power_state(codec, 0x27, &parm);
 	update_power_state(codec, 0x1a, parm);
-	update_power_state(codec, 0xb, parm);
+	parm2 = parm; /* for pin 0x0b */
 
 	/* PW2 (26h), AOW2 (ah) */
 	parm = AC_PWRST_D3;
@@ -3271,6 +3271,9 @@ static void set_widgets_power_state_vt17
 	if (!spec->hp_independent_mode) /* check for redirected HP */
 		set_pin_power_state(codec, 0x28, &parm);
 	update_power_state(codec, 0x8, parm);
+	if (!spec->hp_independent_mode && parm2 != AC_PWRST_D3)
+		parm = parm2;
+	update_power_state(codec, 0xb, parm);
 	/* MW9 (21h), Mw2 (1ah), AOW0 (8h) */
 	update_power_state(codec, 0x21, imux_is_smixer ? AC_PWRST_D0 : parm);
 


