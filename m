Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2BAVh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:37:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56192 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260Ab2BAVJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:50 -0500
X-Sasl-enc: wq3T7Q49/0YiyDD+nwzI6/WpY/zVj+puxlfNf0WTqhUa 1328130589
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:46 2012
Message-Id: <20120201210046.393778399@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [28/89] ALSA: hda - Fix silent output on ASUS A6Rp
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 3b25eb690e8c7424eecffe1458c02b87b32aa001 upstream.

The refactoring of Realtek codec driver in 3.2 kernel caused a
regression for ASUS A6Rp laptop; it doesn't give any output.
The reason was that this machine has a secret master mute (or EAPD)
control via NID 0x0f VREF.  Setting VREF50 on this node makes the
sound working again.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42588

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -5223,6 +5223,7 @@ static const struct hda_amp_list alc861_
 /* Pin config fixes */
 enum {
 	PINFIX_FSC_AMILO_PI1505,
+	PINFIX_ASUS_A6RP,
 };
 
 static const struct alc_fixup alc861_fixups[] = {
@@ -5234,9 +5235,18 @@ static const struct alc_fixup alc861_fix
 			{ }
 		}
 	},
+	[PINFIX_ASUS_A6RP] = {
+		.type = ALC_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* node 0x0f VREF seems controlling the master output */
+			{ 0x0f, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF50 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc861_fixup_tbl[] = {
+	SND_PCI_QUIRK(0x1043, 0x1393, "ASUS A6Rp", PINFIX_ASUS_A6RP),
 	SND_PCI_QUIRK(0x1734, 0x10c7, "FSC Amilo Pi1505", PINFIX_FSC_AMILO_PI1505),
 	{}
 };


