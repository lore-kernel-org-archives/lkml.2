Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0LMA1g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:27:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0LLXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:32 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: perex@perex.cz, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [35/223] ALSA: OSS mixer emulation - fix locking
Message-Id: <20101212234531.B3E34B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jaroslav Kysela <perex@perex.cz>

commit 838c364ff05c143fd1810e8ad1469935d6c23a7a upstream.

Fix mutex release and cleanup some locking code.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/core/oss/mixer_oss.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux/sound/core/oss/mixer_oss.c
===================================================================
--- linux.orig/sound/core/oss/mixer_oss.c
+++ linux/sound/core/oss/mixer_oss.c
@@ -618,8 +618,10 @@ static void snd_mixer_oss_put_volume1_vo
 	if (numid == ID_UNKNOWN)
 		return;
 	down_read(&card->controls_rwsem);
-	if ((kctl = snd_ctl_find_numid(card, numid)) == NULL)
+	if ((kctl = snd_ctl_find_numid(card, numid)) == NULL) {
+		up_read(&card->controls_rwsem);
 		return;
+	}
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
@@ -658,7 +660,7 @@ static void snd_mixer_oss_put_volume1_sw
 		return;
 	down_read(&card->controls_rwsem);
 	if ((kctl = snd_ctl_find_numid(card, numid)) == NULL) {
-		up_read(&fmixer->card->controls_rwsem);
+		up_read(&card->controls_rwsem);
 		return;
 	}
 	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
@@ -797,7 +799,7 @@ static int snd_mixer_oss_get_recsrc2(str
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL) {
 		err = -ENOMEM;
-		goto __unlock;
+		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
@@ -826,6 +828,7 @@ static int snd_mixer_oss_get_recsrc2(str
 	err = 0;
       __unlock:
      	up_read(&card->controls_rwsem);
+      __free_only:
       	kfree(uctl);
       	kfree(uinfo);
       	return err;
@@ -847,7 +850,7 @@ static int snd_mixer_oss_put_recsrc2(str
 	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL) {
 		err = -ENOMEM;
-		goto __unlock;
+		goto __free_only;
 	}
 	down_read(&card->controls_rwsem);
 	kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
@@ -880,6 +883,7 @@ static int snd_mixer_oss_put_recsrc2(str
 	err = 0;
       __unlock:
 	up_read(&card->controls_rwsem);
+      __free_only:
 	kfree(uctl);
 	kfree(uinfo);
 	return err;
