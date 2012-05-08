Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2EHNIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:08:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39473 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2EHNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:08:19 -0400
Subject: [PATCH bugfix v3.4] ALSA: hda - fix "silence after S3" regression
To: Takashi Iwai <tiwai@suse.de>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Jaroslav Kysela <perex@perex.cz>
Date: Tue, 08 May 2012 17:08:10 +0400
Message-ID: <20120508130810.17396.27499.stgit@zurg>
In-Reply-To: <4FA91A27.3030801@openvz.org>
References: <4FA91A27.3030801@openvz.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes regression in shd-hda-codec after 785f857d1cb0856b612b46a0545b74aa2
("ALSA: hda - Set codec to D3 forcibly even if not used")

hda_set_power_state() call must be explicitly protected against recursive
snd_hda_power_up/down() calls, otherwise it accidentally switches device into
D0 right before suspend. As result after resume sound device stays in D3 state
and does not works because driver believes that the device is on already.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 sound/pci/hda/hda_codec.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 7a8fcc4..a0ea9d6 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -5444,10 +5444,14 @@ int snd_hda_suspend(struct hda_bus *bus)
 	list_for_each_entry(codec, &bus->codec_list, list) {
 		if (hda_codec_is_power_on(codec))
 			hda_call_codec_suspend(codec);
-		else /* forcibly change the power to D3 even if not used */
+		else {
+			/* forcibly change the power to D3 even if not used */
+			codec->power_transition = 1;
 			hda_set_power_state(codec,
 					    codec->afg ? codec->afg : codec->mfg,
 					    AC_PWRST_D3);
+			codec->power_transition = 0;
+		}
 		if (codec->patch_ops.post_suspend)
 			codec->patch_ops.post_suspend(codec);
 	}

