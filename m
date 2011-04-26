Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab1DZVPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:15:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:62270 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab1DZVPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738832056"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: lydiawang@viatech.com.cn, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [100/106] ALSA: hda - VIA: Fix stereo mixer recording no sound issue
Message-Id: <20110426211422.DDBD33E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Lydia Wang <lydiawang@viatech.com.cn>

commit bff5fbf50bd498c217994bd2d41a53ac3141185a upstream.

Modify function via_mux_enum_put() to fix stereo mixer recording
no sound issue.

Signed-off-by: Lydia Wang <lydiawang@viatech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/pci/hda/patch_via.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/sound/pci/hda/patch_via.c
===================================================================
--- linux-2.6.35.y.orig/sound/pci/hda/patch_via.c
+++ linux-2.6.35.y/sound/pci/hda/patch_via.c
@@ -1091,6 +1091,7 @@ static int via_mux_enum_put(struct snd_k
 	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct via_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
+	int ret;
 
 	if (!spec->mux_nids[adc_idx])
 		return -EINVAL;
@@ -1099,12 +1100,14 @@ static int via_mux_enum_put(struct snd_k
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
