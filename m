Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1EFAtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:49:31 -0400
Received: from kroah.org ([198.145.64.141]:36983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1EFAZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:13 2011
Message-Id: <20110506002213.258510125@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rafael Avila de Espindola <rafael.espindola@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [082/143] ALSA: hda - Add support for the new 27 inch IMacs
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael Avila de Espindola <rafael.espindola@gmail.com>

commit 1a5ba2e9fc7999b8de2a71c7e7b9f58d752c05e4 upstream.

With the attached patch I am able to use the sound on a new IMac 27.
What works:

*) Internal speakers
*) Internal microphone
*) Headphone

I don't have an external mic or a SPDIF device to test the rest.

Signed-off-by: Rafael Avila de Espindola <rafael.espindola@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/sound/alsa/HD-Audio-Models.txt |    1 +
 sound/pci/hda/patch_cirrus.c                 |   22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

--- a/Documentation/sound/alsa/HD-Audio-Models.txt
+++ b/Documentation/sound/alsa/HD-Audio-Models.txt
@@ -401,4 +401,5 @@ STAC9872
 Cirrus Logic CS4206/4207
 ========================
   mbp55		MacBook Pro 5,5
+  imac27	IMac 27 Inch
   auto		BIOS setup (default)
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -66,6 +66,7 @@ struct cs_spec {
 /* available models */
 enum {
 	CS420X_MBP55,
+	CS420X_IMAC27,
 	CS420X_AUTO,
 	CS420X_MODELS
 };
@@ -832,7 +833,8 @@ static void cs_automute(struct hda_codec
 				    AC_VERB_SET_PIN_WIDGET_CONTROL,
 				    hp_present ? 0 : PIN_OUT);
 	}
-	if (spec->board_config == CS420X_MBP55) {
+	if (spec->board_config == CS420X_MBP55 ||
+	    spec->board_config == CS420X_IMAC27) {
 		unsigned int gpio = hp_present ? 0x02 : 0x08;
 		snd_hda_codec_write(codec, 0x01, 0,
 				    AC_VERB_SET_GPIO_DATA, gpio);
@@ -1078,12 +1080,14 @@ static int cs_parse_auto_config(struct h
 
 static const char *cs420x_models[CS420X_MODELS] = {
 	[CS420X_MBP55] = "mbp55",
+	[CS420X_IMAC27] = "imac27",
 	[CS420X_AUTO] = "auto",
 };
 
 
 static struct snd_pci_quirk cs420x_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x10de, 0xcb79, "MacBookPro 5,5", CS420X_MBP55),
+	SND_PCI_QUIRK(0x8086, 0x7270, "IMac 27 Inch", CS420X_IMAC27),
 	{} /* terminator */
 };
 
@@ -1106,8 +1110,23 @@ static struct cs_pincfg mbp55_pincfgs[]
 	{} /* terminator */
 };
 
+static struct cs_pincfg imac27_pincfgs[] = {
+	{ 0x09, 0x012b4050 },
+	{ 0x0a, 0x90100140 },
+	{ 0x0b, 0x90100142 },
+	{ 0x0c, 0x018b3020 },
+	{ 0x0d, 0x90a00110 },
+	{ 0x0e, 0x400000f0 },
+	{ 0x0f, 0x01cbe030 },
+	{ 0x10, 0x014be060 },
+	{ 0x12, 0x01ab9070 },
+	{ 0x15, 0x400000f0 },
+	{} /* terminator */
+};
+
 static struct cs_pincfg *cs_pincfgs[CS420X_MODELS] = {
 	[CS420X_MBP55] = mbp55_pincfgs,
+	[CS420X_IMAC27] = imac27_pincfgs,
 };
 
 static void fix_pincfg(struct hda_codec *codec, int model)
@@ -1137,6 +1156,7 @@ static int patch_cs420x(struct hda_codec
 		fix_pincfg(codec, spec->board_config);
 
 	switch (spec->board_config) {
+	case CS420X_IMAC27:
 	case CS420X_MBP55:
 		/* GPIO1 = headphones */
 		/* GPIO3 = speakers */


