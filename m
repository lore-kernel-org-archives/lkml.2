Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2LMOEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2LMOEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:32 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 062/241] ALSA: Fix card refcount unbalance
Date: Thu, 13 Dec 2012 11:57:07 -0200
Message-Id: <1355407206-17100-63-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8bb4d9ce08b0a92ca174e41d92c180328f86173f upstream.

There are uncovered cases whether the card refcount introduced by the
commit a0830dbd isn't properly increased or decreased:
- OSS PCM and mixer success paths
- When lookup function gets NULL

This patch fixes these places.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=50251

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/core/oss/mixer_oss.c |    1 +
 sound/core/oss/pcm_oss.c   |    1 +
 sound/core/pcm_native.c    |    6 ++++--
 sound/core/sound.c         |    2 +-
 sound/core/sound_oss.c     |    2 +-
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 05395aa..c353768 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -76,6 +76,7 @@ static int snd_mixer_oss_open(struct inode *inode, struct file *file)
 		snd_card_unref(card);
 		return -EFAULT;
 	}
+	snd_card_unref(card);
 	return 0;
 }
 
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index f337b66..4c1cc51 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2454,6 +2454,7 @@ static int snd_pcm_oss_open(struct inode *inode, struct file *file)
 	mutex_unlock(&pcm->open_mutex);
 	if (err < 0)
 		goto __error;
+	snd_card_unref(pcm->card);
 	return err;
 
       __error:
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index d15e5be..bf3bf43 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2121,7 +2121,8 @@ static int snd_pcm_playback_open(struct inode *inode, struct file *file)
 	pcm = snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_PLAYBACK);
 	err = snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_PLAYBACK);
-	snd_card_unref(pcm->card);
+	if (pcm)
+		snd_card_unref(pcm->card);
 	return err;
 }
 
@@ -2134,7 +2135,8 @@ static int snd_pcm_capture_open(struct inode *inode, struct file *file)
 	pcm = snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_CAPTURE);
 	err = snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_CAPTURE);
-	snd_card_unref(pcm->card);
+	if (pcm)
+		snd_card_unref(pcm->card);
 	return err;
 }
 
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 7c0640e..3700d96 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -115,7 +115,7 @@ void *snd_lookup_minor_data(unsigned int minor, int type)
 	mreg = snd_minors[minor];
 	if (mreg && mreg->type == type) {
 		private_data = mreg->private_data;
-		if (mreg->card_ptr)
+		if (private_data && mreg->card_ptr)
 			atomic_inc(&mreg->card_ptr->refcount);
 	} else
 		private_data = NULL;
diff --git a/sound/core/sound_oss.c b/sound/core/sound_oss.c
index e1d79ee..726a49a 100644
--- a/sound/core/sound_oss.c
+++ b/sound/core/sound_oss.c
@@ -54,7 +54,7 @@ void *snd_lookup_oss_minor_data(unsigned int minor, int type)
 	mreg = snd_oss_minors[minor];
 	if (mreg && mreg->type == type) {
 		private_data = mreg->private_data;
-		if (mreg->card_ptr)
+		if (private_data && mreg->card_ptr)
 			atomic_inc(&mreg->card_ptr->refcount);
 	} else
 		private_data = NULL;
-- 
1.7.9.5

