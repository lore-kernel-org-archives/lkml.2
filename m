Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030933Ab2HGWmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:42:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63163 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030918Ab2HGWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:42:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 099/109] ALSA: hda - Fix mute-LED GPIO setup for HP Mini 210
Date: Tue,  7 Aug 2012 15:35:58 -0700
Message-Id: <20120807222051.752668201@linuxfoundation.org>
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

commit a3e199732b8e2b272e82cc1ccc49c35239ed6c5a upstream.

BIOS on HP Mini 210 doesn't provide the proper "HP_Mute_LED" DMI
string, thus the driver doesn't initialize the GPIO, too.  In the
earlier kernel, the driver falls back to GPIO1, but since 3.3 we've
stopped this due to other wrongly advertised machines.

For fixing this particular case, add a new model type to specify the
default polarity explicitly so that the fallback to GPIO1 is handled.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=772923

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_sigmatel.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -100,6 +100,7 @@ enum {
 	STAC_92HD83XXX_HP_cNB11_INTQUAD,
 	STAC_HP_DV7_4000,
 	STAC_HP_ZEPHYR,
+	STAC_92HD83XXX_HP_LED,
 	STAC_92HD83XXX_MODELS
 };
 
@@ -1672,6 +1673,7 @@ static const char * const stac92hd83xxx_
 	[STAC_92HD83XXX_HP_cNB11_INTQUAD] = "hp_cNB11_intquad",
 	[STAC_HP_DV7_4000] = "hp-dv7-4000",
 	[STAC_HP_ZEPHYR] = "hp-zephyr",
+	[STAC_92HD83XXX_HP_LED] = "hp-led",
 };
 
 static const struct snd_pci_quirk stac92hd83xxx_cfg_tbl[] = {
@@ -1726,6 +1728,8 @@ static const struct snd_pci_quirk stac92
 			  "HP", STAC_92HD83XXX_HP_cNB11_INTQUAD),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x3561,
 			  "HP", STAC_HP_ZEPHYR),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x3660,
+			  "HP Mini", STAC_92HD83XXX_HP_LED),
 	{} /* terminator */
 };
 
@@ -5528,6 +5532,7 @@ static void stac92hd8x_fill_auto_spec(st
 static int patch_stac92hd83xxx(struct hda_codec *codec)
 {
 	struct sigmatel_spec *spec;
+	int default_polarity = -1; /* no default cfg */
 	int err;
 
 	spec  = kzalloc(sizeof(*spec), GFP_KERNEL);
@@ -5576,9 +5581,12 @@ again:
 	case STAC_HP_ZEPHYR:
 		spec->init = stac92hd83xxx_hp_zephyr_init;
 		break;
+	case STAC_92HD83XXX_HP_LED:
+		default_polarity = 1;
+		break;
 	}
 
-	if (find_mute_led_cfg(codec, -1/*no default cfg*/))
+	if (find_mute_led_cfg(codec, default_polarity))
 		snd_printd("mute LED gpio %d polarity %d\n",
 				spec->gpio_led,
 				spec->gpio_led_polarity);


