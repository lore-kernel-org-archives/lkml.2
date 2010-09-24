Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0IXQbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:31:06 -0400
Received: from kroah.org ([198.145.64.141]:38567 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab0IXQ24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:21 2010
Message-Id: <20100924162621.031130025@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-15?q?=D8=A3=D8=AD=D9=85=D8=AF=20=D8=A7=D9=84=D9=85=D8=AD=D9=85=D9=88=D8=AF=D9=8A?= 
	<aelmahmoudy@sabily.org>
Subject: [70/80] ALSA: hda - Fix beep frequency on IDT 92HD73xx and 92HD71Bxx codecs
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel J Blueman <daniel.blueman@gmail.com>

commit 1b0e372d7b52c9fc96348779015a6db7df7f286e upstream.

Fix HDA beep frequency on IDT 92HD73xx and 92HD71Bxx codecs.
These codecs use the standard beep frequency calculation although the
datasheet says it's linear frequency.

Other IDT/STAC codecs might have the same problem.  They should be
fixed individually later.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: أحمد المحمودي <aelmahmoudy@sabily.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -202,6 +202,7 @@ struct sigmatel_spec {
 	unsigned int spdif_mute: 1;
 	unsigned int check_volume_offset:1;
 	unsigned int auto_mic:1;
+	unsigned int linear_tone_beep:1;
 
 	/* gpio lines */
 	unsigned int eapd_mask;
@@ -3802,7 +3803,7 @@ static int stac92xx_parse_auto_config(st
 			return err;
 		if (codec->beep) {
 			/* IDT/STAC codecs have linear beep tone parameter */
-			codec->beep->linear_tone = 1;
+			codec->beep->linear_tone = spec->linear_tone_beep;
 			/* if no beep switch is available, make its own one */
 			caps = query_amp_caps(codec, nid, HDA_OUTPUT);
 			if (!(caps & AC_AMPCAP_MUTE)) {
@@ -5005,6 +5006,7 @@ static int patch_stac9200(struct hda_cod
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	spec->num_pins = ARRAY_SIZE(stac9200_pin_nids);
 	spec->pin_nids = stac9200_pin_nids;
 	spec->board_config = snd_hda_check_board_config(codec, STAC_9200_MODELS,
@@ -5068,6 +5070,7 @@ static int patch_stac925x(struct hda_cod
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	spec->num_pins = ARRAY_SIZE(stac925x_pin_nids);
 	spec->pin_nids = stac925x_pin_nids;
 
@@ -5153,6 +5156,7 @@ static int patch_stac92hd73xx(struct hda
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 0;
 	codec->slave_dig_outs = stac92hd73xx_slave_dig_outs;
 	spec->num_pins = ARRAY_SIZE(stac92hd73xx_pin_nids);
 	spec->pin_nids = stac92hd73xx_pin_nids;
@@ -5300,6 +5304,7 @@ static int patch_stac92hd83xxx(struct hd
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	codec->slave_dig_outs = stac92hd83xxx_slave_dig_outs;
 	spec->digbeep_nid = 0x21;
 	spec->mux_nids = stac92hd83xxx_mux_nids;
@@ -5522,6 +5527,7 @@ static int patch_stac92hd71bxx(struct hd
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 0;
 	codec->patch_ops = stac92xx_patch_ops;
 	spec->num_pins = STAC92HD71BXX_NUM_PINS;
 	switch (codec->vendor_id) {
@@ -5779,6 +5785,7 @@ static int patch_stac922x(struct hda_cod
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	spec->num_pins = ARRAY_SIZE(stac922x_pin_nids);
 	spec->pin_nids = stac922x_pin_nids;
 	spec->board_config = snd_hda_check_board_config(codec, STAC_922X_MODELS,
@@ -5883,6 +5890,7 @@ static int patch_stac927x(struct hda_cod
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	codec->slave_dig_outs = stac927x_slave_dig_outs;
 	spec->num_pins = ARRAY_SIZE(stac927x_pin_nids);
 	spec->pin_nids = stac927x_pin_nids;
@@ -6018,6 +6026,7 @@ static int patch_stac9205(struct hda_cod
 
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	spec->num_pins = ARRAY_SIZE(stac9205_pin_nids);
 	spec->pin_nids = stac9205_pin_nids;
 	spec->board_config = snd_hda_check_board_config(codec, STAC_9205_MODELS,
@@ -6174,6 +6183,7 @@ static int patch_stac9872(struct hda_cod
 		return -ENOMEM;
 	codec->no_trigger_sense = 1;
 	codec->spec = spec;
+	spec->linear_tone_beep = 1;
 	spec->num_pins = ARRAY_SIZE(stac9872_pin_nids);
 	spec->pin_nids = stac9872_pin_nids;
 


