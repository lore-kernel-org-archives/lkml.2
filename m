Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab2LMO7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:59:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab2LMOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 057/241] ALSA: hda - Fix invalid connections in VT1802 codec
Date: Thu, 13 Dec 2012 11:57:02 -0200
Message-Id: <1355407206-17100-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ef4da45828603df57e5e21b8aa21a66ce309f79b upstream.

VT1802 codec provides the invalid connection lists of NID 0x24 and
0x33 containing the routes to a non-exist widget 0x3e.  This confuses
the auto-parser.  Fix it up in the driver by overriding these
connections.

Reported-by: Massimo Del Fedele <max@veneto.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/pci/hda/patch_via.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index b601888..a0e708d 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3688,6 +3688,18 @@ static const struct snd_pci_quirk vt2002p_fixups[] = {
 	{}
 };
 
+/* NIDs 0x24 and 0x33 on VT1802 have connections to non-existing NID 0x3e
+ * Replace this with mixer NID 0x1c
+ */
+static void fix_vt1802_connections(struct hda_codec *codec)
+{
+	static hda_nid_t conn_24[] = { 0x14, 0x1c };
+	static hda_nid_t conn_33[] = { 0x1c };
+
+	snd_hda_override_conn_list(codec, 0x24, ARRAY_SIZE(conn_24), conn_24);
+	snd_hda_override_conn_list(codec, 0x33, ARRAY_SIZE(conn_33), conn_33);
+}
+
 /* patch for vt2002P */
 static int patch_vt2002P(struct hda_codec *codec)
 {
@@ -3702,6 +3714,8 @@ static int patch_vt2002P(struct hda_codec *codec)
 	spec->aa_mix_nid = 0x21;
 	override_mic_boost(codec, 0x2b, 0, 3, 40);
 	override_mic_boost(codec, 0x29, 0, 3, 40);
+	if (spec->codec_type == VT1802)
+		fix_vt1802_connections(codec);
 	add_secret_dac_path(codec);
 
 	snd_hda_pick_fixup(codec, NULL, vt2002p_fixups, via_fixups);
-- 
1.7.9.5

