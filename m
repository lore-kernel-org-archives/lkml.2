Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab0LHBsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:48:50 -0500
Received: from kroah.org ([198.145.64.141]:48689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab0LHBAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:04 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:28 2010
Message-Id: <20101208005728.436932860@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jaroslav Kysela <perex@perex.cz>
Subject: [071/289] ALSA: OSS mixer emulation - fix locking
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jaroslav Kysela <perex@perex.cz>

commit 838c364ff05c143fd1810e8ad1469935d6c23a7a upstream.

Fix mutex release and cleanup some locking code.

Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/oss/mixer_oss.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
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


