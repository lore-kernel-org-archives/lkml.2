Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1CZAbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:31:21 -0400
Received: from kroah.org ([198.145.64.141]:44171 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab1CYXwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:52:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:45:08 2011
Message-Id: <20110325234508.171725891@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:43:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [03/63] ALSA: hda - VIA: Fix independent headphone no sound issue
In-Reply-To: <20110325234526.GA18017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit ce0e5a9e81fbb153ee15ca60246c6722f07fc546 upstream.

Modify via_independent_hp_put() function to support VT1718S and VT1812
codecs, and fix independent headphone no sound issue.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1191,8 +1191,16 @@ static int via_independent_hp_put(struct
 	/* Get Independent Mode index of headphone pin widget */
 	spec->hp_independent_mode = spec->hp_independent_mode_index == pinsel
 		? 1 : 0;
-	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CONNECT_SEL, pinsel);
+	if (spec->codec_type == VT1718S)
+		snd_hda_codec_write(codec, nid, 0,
+				    AC_VERB_SET_CONNECT_SEL, pinsel ? 2 : 0);
+	else
+		snd_hda_codec_write(codec, nid, 0,
+				    AC_VERB_SET_CONNECT_SEL, pinsel);
 
+	if (spec->codec_type == VT1812)
+		snd_hda_codec_write(codec, 0x35, 0,
+				    AC_VERB_SET_CONNECT_SEL, pinsel);
 	if (spec->multiout.hp_nid && spec->multiout.hp_nid
 	    != spec->multiout.dac_nids[HDA_FRONT])
 		snd_hda_codec_setup_stream(codec, spec->multiout.hp_nid,
@@ -1211,6 +1219,8 @@ static int via_independent_hp_put(struct
 		activate_ctl(codec, "Headphone Playback Switch",
 			     spec->hp_independent_mode);
 	}
+	/* update jack power state */
+	set_jack_power_state(codec);
 	return 0;
 }
 


