Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2JJXDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:03:39 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48515 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932630Ab2JJXDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:03:34 -0400
X-Sasl-enc: 6NH6TIrPtuO7NhQJM3y2jGW5QhE9J8aTfcuGKtRDhYqX 1349910213
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 069/122] ALSA: hda/realtek - Fix detection of ALC271X codec
Date: Thu, 11 Oct 2012 07:53:55 +0900
Message-Id: <20121010225350.545722250@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 9f720bb9409ea5923361fbd3fdbc505ca36cf012 upstream.

In commit af741c1 ("ALSA: hda/realtek - Call alc_auto_parse_customize_define()
always after fixup"), alc_auto_parse_customize_define was moved after
detection of ALC271X.

The problem is that detection of ALC271X relies on spec->cdefine.platform_type,
and it's set on alc_auto_parse_customize_define.

Move the alc_auto_parse_customize_define and its required fixup setup
before the block doing the ALC271X and other codec setup.

BugLink: https://bugs.launchpad.net/bugs/1006690
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Reviewed-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6334,6 +6334,12 @@ static int patch_alc269(struct hda_codec
 
 	spec = codec->spec;
 
+	alc_pick_fixup(codec, alc269_fixup_models,
+		       alc269_fixup_tbl, alc269_fixups);
+	alc_apply_fixup(codec, ALC_FIXUP_ACT_PRE_PROBE);
+
+	alc_auto_parse_customize_define(codec);
+
 	if (codec->vendor_id == 0x10ec0269) {
 		spec->codec_variant = ALC269_TYPE_ALC269VA;
 		switch (alc_get_coef0(codec) & 0x00f0) {
@@ -6361,12 +6367,6 @@ static int patch_alc269(struct hda_codec
 		alc269_fill_coef(codec);
 	}
 
-	alc_pick_fixup(codec, alc269_fixup_models,
-		       alc269_fixup_tbl, alc269_fixups);
-	alc_apply_fixup(codec, ALC_FIXUP_ACT_PRE_PROBE);
-
-	alc_auto_parse_customize_define(codec);
-
 	/* automatic parse from the BIOS config */
 	err = alc269_parse_auto_config(codec);
 	if (err < 0)


