Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab2KNFul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:50:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594Ab2KNFue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:34 -0500
Message-Id: <20121114053942.402525152@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 62/82] ALSA: Fix card refcount unbalance
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/oss/mixer_oss.c |    1 +
 sound/core/oss/pcm_oss.c   |    1 +
 sound/core/pcm_native.c    |    6 ++++--
 sound/core/sound.c         |    2 +-
 sound/core/sound_oss.c     |    2 +-
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index a9a2e63..e8a1d18 100644
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
index 6e8872d..f9ddecf 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2122,7 +2122,8 @@ static int snd_pcm_playback_open(struct inode *inode, struct file *file)
 	pcm = snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_PLAYBACK);
 	err = snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_PLAYBACK);
-	snd_card_unref(pcm->card);
+	if (pcm)
+		snd_card_unref(pcm->card);
 	return err;
 }
 
@@ -2135,7 +2136,8 @@ static int snd_pcm_capture_open(struct inode *inode, struct file *file)
 	pcm = snd_lookup_minor_data(iminor(inode),
 				    SNDRV_DEVICE_TYPE_PCM_CAPTURE);
 	err = snd_pcm_open(file, pcm, SNDRV_PCM_STREAM_CAPTURE);
-	snd_card_unref(pcm->card);
+	if (pcm)
+		snd_card_unref(pcm->card);
 	return err;
 }
 
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 89780c3..70ccdab 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -114,7 +114,7 @@ void *snd_lookup_minor_data(unsigned int minor, int type)
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


