Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2APSrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:47:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2APSry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:47:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.859292055@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [13/48] ALSA: hda - Fix the detection of "Loopback Mixing" control for VIA codecs
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4808d12d1dddb046ec86425e5f6766f02e950292 upstream.

Currently the driver checks only the out_mix_path[] for the primary
output route for judging whether to create the loopback-mixing control
or not.  But, there are cases where aamix-routing is available only on
headphone or speaker paths but not on the primary output path.  So, the
driver ignores such cases inappropriately.

This patch fixes the check of the loopback-mixing control by testing
all mix-routing paths.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_via.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -2187,7 +2187,10 @@ static int via_auto_create_loopback_swit
 {
 	struct via_spec *spec = codec->spec;
 
-	if (!spec->aa_mix_nid || !spec->out_mix_path.depth)
+	if (!spec->aa_mix_nid)
+		return 0; /* no loopback switching available */
+	if (!(spec->out_mix_path.depth || spec->hp_mix_path.depth ||
+	      spec->speaker_path.depth))
 		return 0; /* no loopback switching available */
 	if (!via_clone_control(spec, &via_aamix_ctl_enum))
 		return -ENOMEM;


