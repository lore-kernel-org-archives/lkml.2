Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab2JJXGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:06:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36644 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932634Ab2JJXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:36 -0400
X-Sasl-enc: dmz1gqSU0oWGxE6w1FhiOwuArddN2z42IgwLTgRyOio4 1349910215
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 070/122] ALSA: hda - limit internal mic boost for Asus X202E
Date: Thu, 11 Oct 2012 07:53:56 +0900
Message-Id: <20121010225350.724538909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit 4b527b6516ab1f0af8aaedd02dbf71ee2c1180f4 upstream.

When the input gain for the internal mic is set to its maximum level,
the background noise becomes so high - and any relevant signal clipped -
that the setting becomes unusable. It is better to limit the amplification.

BugLink: https://bugs.launchpad.net/bugs/1052460
Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3670,6 +3670,32 @@ static void set_widgets_power_state_vt20
 		update_power_state(codec, 0x21, AC_PWRST_D3);
 }
 
+/*
+ * pin fix-up
+ */
+enum {
+	VIA_FIXUP_INTMIC_BOOST,
+};
+
+static void via_fixup_intmic_boost(struct hda_codec *codec,
+				  const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		override_mic_boost(codec, 0x30, 0, 2, 40);
+}
+
+static const struct hda_fixup via_fixups[] = {
+	[VIA_FIXUP_INTMIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = via_fixup_intmic_boost,
+	},
+};
+
+static const struct snd_pci_quirk vt2002p_fixups[] = {
+	SND_PCI_QUIRK(0x1043, 0x8532, "Asus X202E", VIA_FIXUP_INTMIC_BOOST),
+	{}
+};
+
 /* patch for vt2002P */
 static int patch_vt2002P(struct hda_codec *codec)
 {
@@ -3686,6 +3712,9 @@ static int patch_vt2002P(struct hda_code
 	override_mic_boost(codec, 0x29, 0, 3, 40);
 	add_secret_dac_path(codec);
 
+	snd_hda_pick_fixup(codec, NULL, vt2002p_fixups, via_fixups);
+	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
+
 	/* automatic parse from the BIOS config */
 	err = via_parse_auto_config(codec);
 	if (err < 0) {


