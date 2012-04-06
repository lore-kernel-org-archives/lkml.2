Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2DFNe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 09:34:27 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:52761 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753843Ab2DFNeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 09:34:25 -0400
From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
        Stephen Warren <swarren@nvidia.com>,
        Vitaliy Kulikov <Vitaliy.Kulikov@idt.com>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] ALSA: hda - Fix proc output for ADC amp values of CX20549
Date: Fri,  6 Apr 2012 15:34:15 +0200
Message-Id: <1333719260-14504-2-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
References: <s5hk41ufe2j.wl%tiwai@suse.de>
 <1333719260-14504-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de>
X-Originating-IP: 87.123.69.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CX20549 has only one single input amp on it's input converter
widget. Fix printing of values in the codec file in /proc/asound.

Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
---
 sound/pci/hda/hda_codec.h      |    3 +++
 sound/pci/hda/hda_proc.c       |   13 ++++++++++---
 sound/pci/hda/patch_conexant.c |    8 ++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/sound/pci/hda/hda_codec.h b/sound/pci/hda/hda_codec.h
index 9a9f372..56b4f74 100644
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -851,6 +851,9 @@ struct hda_codec {
 	unsigned int pin_amp_workaround:1; /* pin out-amp takes index
 					    * (e.g. Conexant codecs)
 					    */
+	unsigned int single_adc_amp:1; /* adc in-amp takes no index
+					* (e.g. CX20549 codec)
+					*/
 	unsigned int no_sticky_stream:1; /* no sticky-PCM stream assignment */
 	unsigned int pins_shutup:1;	/* pins are shut up */
 	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
diff --git a/sound/pci/hda/hda_proc.c b/sound/pci/hda/hda_proc.c
index 254ab52..8c1715a 100644
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -651,9 +651,16 @@ static void print_codec_info(struct snd_info_entry *entry,
 			snd_iprintf(buffer, "  Amp-In caps: ");
 			print_amp_caps(buffer, codec, nid, HDA_INPUT);
 			snd_iprintf(buffer, "  Amp-In vals: ");
-			print_amp_vals(buffer, codec, nid, HDA_INPUT,
-				       wid_caps & AC_WCAP_STEREO,
-				       wid_type == AC_WID_PIN ? 1 : conn_len);
+			if (wid_type == AC_WID_PIN ||
+			    (codec->single_adc_amp &&
+			     wid_type == AC_WID_AUD_IN))
+                                print_amp_vals(buffer, codec, nid, HDA_INPUT,
+                                               wid_caps & AC_WCAP_STEREO,
+                                               1);
+                        else
+                                print_amp_vals(buffer, codec, nid, HDA_INPUT,
+                                               wid_caps & AC_WCAP_STEREO,
+                                               conn_len);
 		}
 		if (wid_caps & AC_WCAP_OUT_AMP) {
 			snd_iprintf(buffer, "  Amp-Out caps: ");
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8c6523b..60890ef 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -141,7 +141,6 @@ struct conexant_spec {
 	unsigned int hp_laptop:1;
 	unsigned int asus:1;
 	unsigned int pin_eapd_ctrls:1;
-	unsigned int single_adc_amp:1;
 
 	unsigned int adc_switching:1;
 
@@ -1111,6 +1110,7 @@ static int patch_cxt5045(struct hda_codec *codec)
 		return -ENOMEM;
 	codec->spec = spec;
 	codec->pin_amp_workaround = 1;
+	codec->single_adc_amp = 1;
 
 	spec->multiout.max_channels = 2;
 	spec->multiout.num_dacs = ARRAY_SIZE(cxt5045_dac_nids);
@@ -4220,7 +4220,7 @@ static int cx_auto_add_capture_volume(struct hda_codec *codec, hda_nid_t nid,
 		int idx = get_input_connection(codec, adc_nid, nid);
 		if (idx < 0)
 			continue;
-		if (spec->single_adc_amp)
+		if (codec->single_adc_amp)
 			idx = 0;
 		return cx_auto_add_volume_idx(codec, label, pfx,
 					      cidx, adc_nid, HDA_INPUT, idx);
@@ -4275,7 +4275,7 @@ static int cx_auto_build_input_controls(struct hda_codec *codec)
 		if (cidx < 0)
 			continue;
 		input_conn[i] = spec->imux_info[i].adc;
-		if (!spec->single_adc_amp)
+		if (!codec->single_adc_amp)
 			input_conn[i] |= cidx << 8;
 		if (i > 0 && input_conn[i] != input_conn[0])
 			multi_connection = 1;
@@ -4470,7 +4470,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
 
 	switch (codec->vendor_id) {
 	case 0x14f15045:
-		spec->single_adc_amp = 1;
+		codec->single_adc_amp = 1;
 		break;
 	case 0x14f15051:
 		add_cx5051_fake_mutes(codec);
-- 
1.7.9.1

