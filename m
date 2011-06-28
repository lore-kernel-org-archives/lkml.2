Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1F1GvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:51:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45973 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab1F1Guo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:50:44 -0400
Date: Tue, 28 Jun 2011 16:50:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound tree
 related)
Message-Id: <20110628165039.7e1fa073.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

sound/pci/hda/patch_via.c:185:28: error: field 'loopback' has incomplete type
sound/pci/hda/patch_via.c:187:22: error: array type has incomplete element type
sound/pci/hda/patch_via.c: In function 'is_aa_path_mute':
sound/pci/hda/patch_via.c:891:39: error: dereferencing pointer to incomplete type
sound/pci/hda/patch_via.c:891:51: error: dereferencing pointer to incomplete type
sound/pci/hda/patch_via.c:892:11: error: dereferencing pointer to incomplete type
sound/pci/hda/patch_via.c: In function 'add_loopback_list':
sound/pci/hda/patch_via.c:2004:29: warning: type defaults to 'int' in type name
sound/pci/hda/patch_via.c:2004:29: warning: type defaults to 'int' in type name
sound/pci/hda/patch_via.c:2004:29: error: negative width in bit-field '<anonymous>'
sound/pci/hda/patch_via.c:2007:6: error: dereferencing pointer to incomplete type
sound/pci/hda/patch_via.c:2008:6: error: dereferencing pointer to incomplete type
sound/pci/hda/patch_via.c:2009:6: error: dereferencing pointer to incomplete type

Caused by commit ada509ec00e4 ("ALSA: hda - Simplify analog-low-current
mode check for VIA codecs") which removed the CONFIG_SND_HDA_POWER_SAVE
protection of the usage, but not the definition in
sound/pci/hda/hda_local.h.

I have added the below patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 28 Jun 2011 16:46:09 +1000
Subject: [PATCH] ALSA: hda - remove SND_HDA_POWER_SAVE protection of struct
 hda_loopback_check

to fix build problems when it is disabled.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/pci/hda/hda_local.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_local.h b/sound/pci/hda/hda_local.h
index b333bf4..88b277e 100644
--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -565,7 +565,6 @@ int snd_hda_get_bool_hint(struct hda_codec *codec, const char *key)
  * power-management
  */
 
-#ifdef CONFIG_SND_HDA_POWER_SAVE
 void snd_hda_schedule_power_save(struct hda_codec *codec);
 
 struct hda_amp_list {
@@ -582,7 +581,6 @@ struct hda_loopback_check {
 int snd_hda_check_amp_list_power(struct hda_codec *codec,
 				 struct hda_loopback_check *check,
 				 hda_nid_t nid);
-#endif /* CONFIG_SND_HDA_POWER_SAVE */
 
 /*
  * AMP control callbacks
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
