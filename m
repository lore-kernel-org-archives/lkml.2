Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab1CZAMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:12:55 -0400
Received: from kroah.org ([198.145.64.141]:35836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab1CZAGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 20:06:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 17:04:56 2011
Message-Id: <20110326000456.781738887@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 17:03:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lydia Wang <lydiawang@viatech.com.cn>, Takashi Iwai <tiwai@suse.de>
Subject: [09/35] ALSA: hda - VIA: Fix stereo mixer recording no sound issue
In-Reply-To: <20110326000509.GA29736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Lydia Wang <lydiawang@viatech.com.cn>

commit bff5fbf50bd498c217994bd2d41a53ac3141185a upstream.

Modify function via_mux_enum_put() to fix stereo mixer recording
no sound issue.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -1060,6 +1060,7 @@ static int via_mux_enum_put(struct snd_k
 	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct via_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
+	int ret;
 
 	if (!spec->mux_nids[adc_idx])
 		return -EINVAL;
@@ -1068,12 +1069,14 @@ static int via_mux_enum_put(struct snd_k
 			       AC_VERB_GET_POWER_STATE, 0x00) != AC_PWRST_D0)
 		snd_hda_codec_write(codec, spec->mux_nids[adc_idx], 0,
 				    AC_VERB_SET_POWER_STATE, AC_PWRST_D0);
-	/* update jack power state */
-	set_jack_power_state(codec);
 
-	return snd_hda_input_mux_put(codec, spec->input_mux, ucontrol,
+	ret = snd_hda_input_mux_put(codec, spec->input_mux, ucontrol,
 				     spec->mux_nids[adc_idx],
 				     &spec->cur_mux[adc_idx]);
+	/* update jack power state */
+	set_jack_power_state(codec);
+
+	return ret;
 }
 
 static int via_independent_hp_info(struct snd_kcontrol *kcontrol,


