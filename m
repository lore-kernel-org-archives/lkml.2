Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0G3Sih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:38:37 -0400
Received: from kroah.org ([198.145.64.141]:57936 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab0G3Ryd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:33 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175136.127970228@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [028/205] ALSA: hda - Restore cleared pin controls on resume
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ac0547dc62e67a3e0b0c1628b6e49efba8f517db upstream.

Many codecs now clear the pin controls at suspend via snd_hda_shutup_pins()
for reducing the click noise at power-off.  But this leaves some pins
uninitialized, and they'll be never recovered after resume.

This patch adds the proper recovery of cleared pin controls on resume.
Also it adds a check of bus->shutdown so that pins won't be cleared at
module unloading.

Reference: Kernel bug 16339
	http://bugzilla.kernel.org/show_bug.cgi?id=16339

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_codec.c |   27 +++++++++++++++++++++++++++
 sound/pci/hda/hda_codec.h |    5 ++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -784,6 +784,9 @@ static int read_pin_defaults(struct hda_
 		pin->nid = nid;
 		pin->cfg = snd_hda_codec_read(codec, nid, 0,
 					      AC_VERB_GET_CONFIG_DEFAULT, 0);
+		pin->ctrl = snd_hda_codec_read(codec, nid, 0,
+					       AC_VERB_GET_PIN_WIDGET_CONTROL,
+					       0);
 	}
 	return 0;
 }
@@ -912,15 +915,38 @@ static void restore_pincfgs(struct hda_c
 void snd_hda_shutup_pins(struct hda_codec *codec)
 {
 	int i;
+	/* don't shut up pins when unloading the driver; otherwise it breaks
+	 * the default pin setup at the next load of the driver
+	 */
+	if (codec->bus->shutdown)
+		return;
 	for (i = 0; i < codec->init_pins.used; i++) {
 		struct hda_pincfg *pin = snd_array_elem(&codec->init_pins, i);
 		/* use read here for syncing after issuing each verb */
 		snd_hda_codec_read(codec, pin->nid, 0,
 				   AC_VERB_SET_PIN_WIDGET_CONTROL, 0);
 	}
+	codec->pins_shutup = 1;
 }
 EXPORT_SYMBOL_HDA(snd_hda_shutup_pins);
 
+/* Restore the pin controls cleared previously via snd_hda_shutup_pins() */
+static void restore_shutup_pins(struct hda_codec *codec)
+{
+	int i;
+	if (!codec->pins_shutup)
+		return;
+	if (codec->bus->shutdown)
+		return;
+	for (i = 0; i < codec->init_pins.used; i++) {
+		struct hda_pincfg *pin = snd_array_elem(&codec->init_pins, i);
+		snd_hda_codec_write(codec, pin->nid, 0,
+				    AC_VERB_SET_PIN_WIDGET_CONTROL,
+				    pin->ctrl);
+	}
+	codec->pins_shutup = 0;
+}
+
 static void init_hda_cache(struct hda_cache_rec *cache,
 			   unsigned int record_size);
 static void free_hda_cache(struct hda_cache_rec *cache);
@@ -2858,6 +2884,7 @@ static void hda_call_codec_resume(struct
 			    codec->afg ? codec->afg : codec->mfg,
 			    AC_PWRST_D0);
 	restore_pincfgs(codec); /* restore all current pin configs */
+	restore_shutup_pins(codec);
 	hda_exec_init_verbs(codec);
 	if (codec->patch_ops.resume)
 		codec->patch_ops.resume(codec);
--- a/sound/pci/hda/hda_codec.h
+++ b/sound/pci/hda/hda_codec.h
@@ -821,6 +821,7 @@ struct hda_codec {
 	unsigned int pin_amp_workaround:1; /* pin out-amp takes index
 					    * (e.g. Conexant codecs)
 					    */
+	unsigned int pins_shutup:1;	/* pins are shut up */
 	unsigned int no_trigger_sense:1; /* don't trigger at pin-sensing */
 #ifdef CONFIG_SND_HDA_POWER_SAVE
 	unsigned int power_on :1;	/* current (global) power-state */
@@ -894,7 +895,9 @@ void snd_hda_codec_resume_cache(struct h
 /* the struct for codec->pin_configs */
 struct hda_pincfg {
 	hda_nid_t nid;
-	unsigned int cfg;
+	unsigned char ctrl;	/* current pin control value */
+	unsigned char pad;	/* reserved */
+	unsigned int cfg;	/* default configuration */
 };
 
 unsigned int snd_hda_codec_get_pincfg(struct hda_codec *codec, hda_nid_t nid);


