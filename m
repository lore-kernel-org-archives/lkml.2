Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2KVSk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:49630 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab2KVSkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Massimo Del Fedele <max@veneto.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 22/83] ALSA: hda - Fix invalid connections in VT1802 codec
Date: Wed, 21 Nov 2012 16:41:44 -0800
Message-Id: <20121122004214.975424880@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ef4da45828603df57e5e21b8aa21a66ce309f79b upstream.

VT1802 codec provides the invalid connection lists of NID 0x24 and
0x33 containing the routes to a non-exist widget 0x3e.  This confuses
the auto-parser.  Fix it up in the driver by overriding these
connections.

Reported-by: Massimo Del Fedele <max@veneto.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_via.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -3697,6 +3697,18 @@ static const struct snd_pci_quirk vt2002
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
@@ -3711,6 +3723,8 @@ static int patch_vt2002P(struct hda_code
 	spec->aa_mix_nid = 0x21;
 	override_mic_boost(codec, 0x2b, 0, 3, 40);
 	override_mic_boost(codec, 0x29, 0, 3, 40);
+	if (spec->codec_type == VT1802)
+		fix_vt1802_connections(codec);
 	add_secret_dac_path(codec);
 
 	snd_hda_pick_fixup(codec, NULL, vt2002p_fixups, via_fixups);


