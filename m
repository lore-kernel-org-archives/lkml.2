Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152Ab2B1B05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:26:57 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab2B1BLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.134 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.658724342@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [ 48/72] ALSA: hda/realtek - Fix surround output regression on Acer Aspire 5935
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ef8d60fb79614a86a82720dc2402631dbcafb315 upstream.

The previous fix for the speaker on Acer Aspire 59135 introduced
another problem for surround outputs.  It changed the connections on
the line-in/mic pins for limiting the routes, but it left the modified
connections.  Thus wrong connection indices were written when set to
4ch or 6ch mode.

This patch fixes it by restoring the right connections just after
parsing the tree but before the initialization.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=42740

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4229,12 +4229,20 @@ static void alc889_fixup_dac_route(struc
 				   const struct alc_fixup *fix, int action)
 {
 	if (action == ALC_FIXUP_ACT_PRE_PROBE) {
+		/* fake the connections during parsing the tree */
 		hda_nid_t conn1[2] = { 0x0c, 0x0d };
 		hda_nid_t conn2[2] = { 0x0e, 0x0f };
 		snd_hda_override_conn_list(codec, 0x14, 2, conn1);
 		snd_hda_override_conn_list(codec, 0x15, 2, conn1);
 		snd_hda_override_conn_list(codec, 0x18, 2, conn2);
 		snd_hda_override_conn_list(codec, 0x1a, 2, conn2);
+	} else if (action == ALC_FIXUP_ACT_PROBE) {
+		/* restore the connections */
+		hda_nid_t conn[5] = { 0x0c, 0x0d, 0x0e, 0x0f, 0x26 };
+		snd_hda_override_conn_list(codec, 0x14, 5, conn);
+		snd_hda_override_conn_list(codec, 0x15, 5, conn);
+		snd_hda_override_conn_list(codec, 0x18, 5, conn);
+		snd_hda_override_conn_list(codec, 0x1a, 5, conn);
 	}
 }
 


