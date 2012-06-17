Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab2FQSbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:31:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50303 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758291Ab2FQSWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:49 -0400
Message-Id: <20120617175947.247342534@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:23 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 42/69] ALSA: hda - Suppress auto-mute feature on some machines with ALC861
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e652f4c861fb7f1f59ff0828db0d85578471932d upstream.

A few machines with ALC861 & co are reported not to work properly with
the auto-mute feature in software.  The auto-mute feature is implemented
in the hardware level, and the jack-detection never works with them.

Also, rename the fixup index as ALC861_FIXUP_* to follow the standard.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_realtek.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4a2a49f..c630598 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5563,8 +5563,10 @@ static const struct hda_amp_list alc861_loopbacks[] = {
 
 /* Pin config fixes */
 enum {
-	PINFIX_FSC_AMILO_PI1505,
-	PINFIX_ASUS_A6RP,
+	ALC861_FIXUP_FSC_AMILO_PI1505,
+	ALC861_FIXUP_AMP_VREF_0F,
+	ALC861_FIXUP_NO_JACK_DETECT,
+	ALC861_FIXUP_ASUS_A6RP,
 };
 
 /* On some laptops, VREF of pin 0x0f is abused for controlling the main amp */
@@ -5586,8 +5588,16 @@ static void alc861_fixup_asus_amp_vref_0f(struct hda_codec *codec,
 	spec->keep_vref_in_automute = 1;
 }
 
+/* suppress the jack-detection */
+static void alc_fixup_no_jack_detect(struct hda_codec *codec,
+				     const struct alc_fixup *fix, int action)
+{
+	if (action == ALC_FIXUP_ACT_PRE_PROBE)
+		codec->no_jack_detect = 1;
+}	
+
 static const struct alc_fixup alc861_fixups[] = {
-	[PINFIX_FSC_AMILO_PI1505] = {
+	[ALC861_FIXUP_FSC_AMILO_PI1505] = {
 		.type = ALC_FIXUP_PINS,
 		.v.pins = (const struct alc_pincfg[]) {
 			{ 0x0b, 0x0221101f }, /* HP */
@@ -5595,17 +5605,29 @@ static const struct alc_fixup alc861_fixups[] = {
 			{ }
 		}
 	},
-	[PINFIX_ASUS_A6RP] = {
+	[ALC861_FIXUP_AMP_VREF_0F] = {
 		.type = ALC_FIXUP_FUNC,
 		.v.func = alc861_fixup_asus_amp_vref_0f,
 	},
+	[ALC861_FIXUP_NO_JACK_DETECT] = {
+		.type = ALC_FIXUP_FUNC,
+		.v.func = alc_fixup_no_jack_detect,
+	},
+	[ALC861_FIXUP_ASUS_A6RP] = {
+		.type = ALC_FIXUP_FUNC,
+		.v.func = alc861_fixup_asus_amp_vref_0f,
+		.chained = true,
+		.chain_id = ALC861_FIXUP_NO_JACK_DETECT,
+	}
 };
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
-	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", PINFIX_ASUS_A6RP),
-	SND_PCI_QUIRK(0x1584, 0x0000, "Uniwill ECS M31EI", PINFIX_ASUS_A6RP),	
-	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", PINFIX_ASUS_A6RP),
-	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
+	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", ALC861_FIXUP_ASUS_A6RP),
+	SND_PCI_QUIRK_VENDOR(0x1043, "ASUS laptop", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK(0x1462, 0x7254, "HP DX2200", ALC861_FIXUP_NO_JACK_DETECT),
+	SND_PCI_QUIRK(0x1584, 0x2b01, "Haier W18", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK(0x1584, 0x0000, "Uniwill ECS M31EI", ALC861_FIXUP_AMP_VREF_0F),
+	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", ALC861_FIXUP_FSC_AMILO_PI1505),
 	{}
 };
 


