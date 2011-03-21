Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab1CUXS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:28 -0400
Received: from kroah.org ([198.145.64.141]:52665 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab1CUXSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:26 2011
Message-Id: <20110321230326.124854632@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [43/78] ALSA: hda - Initialize special cases for input src in init phase
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 584c0c4c359bdac37d94157f8d7fc513d26c8328 upstream.

Currently some special handling for the unusual case like dual-ADCs
or a single-input-src is done in the tree-parse time in
set_capture_mixer().  But this setup could be overwritten by static
init verbs.

This patch moves the initialization into the init phase so that
such input-src setup won't be lost.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -394,6 +394,7 @@ struct alc_spec {
 	/* other flags */
 	unsigned int no_analog :1; /* digital I/O only */
 	unsigned int dual_adc_switch:1; /* switch ADCs (for ALC275) */
+	unsigned int single_input_src:1;
 	int init_amp;
 	int codec_variant;	/* flag for other variants */
 
@@ -3919,6 +3920,8 @@ static struct hda_amp_list alc880_lg_loo
  * Common callbacks
  */
 
+static void alc_init_special_input_src(struct hda_codec *codec);
+
 static int alc_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -3929,6 +3932,7 @@ static int alc_init(struct hda_codec *co
 
 	for (i = 0; i < spec->num_init_verbs; i++)
 		snd_hda_sequence_write(codec, spec->init_verbs[i]);
+	alc_init_special_input_src(codec);
 
 	if (spec->init_hook)
 		spec->init_hook(codec);
@@ -5590,6 +5594,7 @@ static void fixup_single_adc(struct hda_
 			spec->capsrc_nids += i;
 		spec->adc_nids += i;
 		spec->num_adc_nids = 1;
+		spec->single_input_src = 1;
 	}
 }
 
@@ -5601,6 +5606,16 @@ static void fixup_dual_adc_switch(struct
 	init_capsrc_for_pin(codec, spec->int_mic.pin);
 }
 
+/* initialize some special cases for input sources */
+static void alc_init_special_input_src(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	if (spec->dual_adc_switch)
+		fixup_dual_adc_switch(codec);
+	else if (spec->single_input_src)
+		init_capsrc_for_pin(codec, spec->autocfg.inputs[0].pin);
+}
+
 static void set_capture_mixer(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -5616,7 +5631,7 @@ static void set_capture_mixer(struct hda
 		int mux = 0;
 		int num_adcs = spec->num_adc_nids;
 		if (spec->dual_adc_switch)
-			fixup_dual_adc_switch(codec);
+			num_adcs = 1;
 		else if (spec->auto_mic)
 			fixup_automic_adc(codec);
 		else if (spec->input_mux) {
@@ -5625,8 +5640,6 @@ static void set_capture_mixer(struct hda
 			else if (spec->input_mux->num_items == 1)
 				fixup_single_adc(codec);
 		}
-		if (spec->dual_adc_switch)
-			num_adcs = 1;
 		spec->cap_mixer = caps[mux][num_adcs - 1];
 	}
 }


