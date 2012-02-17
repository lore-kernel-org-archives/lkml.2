Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2BQBAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:00:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38307 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757072Ab2BQBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 20:00:38 -0500
X-Sasl-enc: 4mSRGsPXYGDnfNvbvEY0xGOYz6p/Zc+DoG2kBVrgtFaJ 1329440435
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:37 2012
Message-Id: <20120217005537.359940911@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [25/28] ALSA: hda - Fix silent speaker output on Acer Aspire 6935
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 02a237b24d57e2e2d5402c92549e9e792aa24359 upstream.

Since 3.2 kernel, the driver starts trying to assign the multi-io DACs
before the speaker, thus it assigns DAC2/3 for multi-io and DAC4 for
the speaker for a standard laptop setup like a HP, a speaker, a mic-in
and a line-in.  However, on Acer Aspire 6935, it seems that the
speaker pin 0x14 must be connected with either DAC1 or 2; otherwise it
results in silence by some reason, although the codec itself allows
the routing to DAC3/4.

As a workaround, the connection list of each pin is reduced to be
mapped to either only DAC1/2 or DAC3/4, so that the compatible
assignment as in kernel 3.1 is achieved.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42740

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4213,8 +4213,26 @@ enum {
 	PINFIX_PB_M5210,
 	PINFIX_ACER_ASPIRE_7736,
 	PINFIX_ASUS_W90V,
+	ALC889_FIXUP_DAC_ROUTE,
 };
 
+/* Fix the connection of some pins for ALC889:
+ * At least, Acer Aspire 5935 shows the connections to DAC3/4 don't
+ * work correctly (bko#42740)
+ */
+static void alc889_fixup_dac_route(struct hda_codec *codec,
+				   const struct alc_fixup *fix, int action)
+{
+	if (action == ALC_FIXUP_ACT_PRE_PROBE) {
+		hda_nid_t conn1[2] = { 0x0c, 0x0d };
+		hda_nid_t conn2[2] = { 0x0e, 0x0f };
+		snd_hda_override_conn_list(codec, 0x14, 2, conn1);
+		snd_hda_override_conn_list(codec, 0x15, 2, conn1);
+		snd_hda_override_conn_list(codec, 0x18, 2, conn2);
+		snd_hda_override_conn_list(codec, 0x1a, 2, conn2);
+	}
+}
+
 static const struct alc_fixup alc882_fixups[] = {
 	[PINFIX_ABIT_AW9D_MAX] = {
 		.type = ALC_FIXUP_PINS,
@@ -4251,10 +4269,15 @@ static const struct alc_fixup alc882_fix
 			{ }
 		}
 	},
+	[ALC889_FIXUP_DAC_ROUTE] = {
+		.type = ALC_FIXUP_FUNC,
+		.v.func = alc889_fixup_dac_route,
+	},
 };
 
 static const struct snd_pci_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0155, "Packard-Bell M5120", PINFIX_PB_M5210),
+	SND_PCI_QUIRK(0x1025, 0x0259, "Acer Aspire 5935", ALC889_FIXUP_DAC_ROUTE),
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", PINFIX_ASUS_W90V),
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Y530", PINFIX_LENOVO_Y530),
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", PINFIX_ABIT_AW9D_MAX),


