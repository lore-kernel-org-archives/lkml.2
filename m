Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965900Ab1KJDrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965870Ab1KJDrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:01 2011
Message-Id: <20111109213201.758625776@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [193/264] ALSA: hda - Fix silent output regression with ALC861
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 43dea228a3ba5463392281535dfb3d3fe56f4c2c upstream.

The 3.1 kernel has a regression for ALC861 codec where no sound output
is heard with the default setup.  It's because the amps in DACs aren't
properly unmuted while the output mixers are assigned only to pins.

This patch fixes the missing initialization of DACs when no mixer is
assigned to them.

Tested-by: Andrea Iob <andrea_iob@yahoo.it>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3077,6 +3077,12 @@ static void alc_auto_set_output_and_unmu
 	if (nid)
 		snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_AMP_GAIN_MUTE,
 				    AMP_OUT_ZERO);
+
+	/* unmute DAC if it's not assigned to a mixer */
+	nid = alc_look_for_out_mute_nid(codec, pin, dac);
+	if (nid == mix && nid_has_mute(codec, dac, HDA_OUTPUT))
+		snd_hda_codec_write(codec, dac, 0, AC_VERB_SET_AMP_GAIN_MUTE,
+				    AMP_OUT_ZERO);
 }
 
 static void alc_auto_init_multi_out(struct hda_codec *codec)


