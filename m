Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2LMOCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:02:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab2LMOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:02:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 026/241] ALSA: Avoid endless sleep after disconnect
Date: Thu, 13 Dec 2012 11:56:31 -0200
Message-Id: <1355407206-17100-27-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0914f7961babbf28aaa2f19b453951fb4841c03f upstream.

When disconnect callback is called, each component should wake up
sleepers and check card->shutdown flag for avoiding the endless sleep
blocking the proper resource release.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/core/control.c     |    2 ++
 sound/core/hwdep.c       |    7 +++++++
 sound/core/oss/pcm_oss.c |    4 ++++
 sound/core/pcm.c         |    6 +++++-
 sound/core/pcm_native.c  |    8 ++++++++
 sound/core/rawmidi.c     |   20 ++++++++++++++++++++
 6 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 151597b..daa4fc8 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1436,6 +1436,8 @@ static ssize_t snd_ctl_read(struct file *file, char __user *buffer,
 			spin_unlock_irq(&ctl->read_lock);
 			schedule();
 			remove_wait_queue(&ctl->change_sleep, &wait);
+			if (ctl->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return -ERESTARTSYS;
 			spin_lock_irq(&ctl->read_lock);
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 53a6ba5..3f7f662 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -131,6 +131,10 @@ static int snd_hwdep_open(struct inode *inode, struct file * file)
 		mutex_unlock(&hw->open_mutex);
 		schedule();
 		mutex_lock(&hw->open_mutex);
+		if (hw->card->shutdown) {
+			err = -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
@@ -462,12 +466,15 @@ static int snd_hwdep_dev_disconnect(struct snd_device *device)
 		mutex_unlock(&register_mutex);
 		return -EINVAL;
 	}
+	mutex_lock(&hwdep->open_mutex);
+	wake_up(&hwdep->open_wait);
 #ifdef CONFIG_SND_OSSEMUL
 	if (hwdep->ossreg)
 		snd_unregister_oss_device(hwdep->oss_type, hwdep->card, hwdep->device);
 #endif
 	snd_unregister_device(SNDRV_DEVICE_TYPE_HWDEP, hwdep->card, hwdep->device);
 	list_del_init(&hwdep->list);
+	mutex_unlock(&hwdep->open_mutex);
 	mutex_unlock(&register_mutex);
 	return 0;
 }
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index 2529e01..f337b66 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2441,6 +2441,10 @@ static int snd_pcm_oss_open(struct inode *inode, struct file *file)
 		mutex_unlock(&pcm->open_mutex);
 		schedule();
 		mutex_lock(&pcm->open_mutex);
+		if (pcm->card->shutdown) {
+			err = -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
diff --git a/sound/core/pcm.c b/sound/core/pcm.c
index 099f3fd..e30e1be 100644
--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -1087,12 +1087,16 @@ static int snd_pcm_dev_disconnect(struct snd_device *device)
 		goto unlock;
 
 	mutex_lock(&pcm->open_mutex);
+	wake_up(&pcm->open_wait);
 	list_del_init(&pcm->list);
 	for (cidx = 0; cidx < 2; cidx++)
 		for (substream = pcm->streams[cidx].substream; substream; substream = substream->next) {
 			snd_pcm_stream_lock_irq(substream);
-			if (substream->runtime)
+			if (substream->runtime) {
 				substream->runtime->status->state = SNDRV_PCM_STATE_DISCONNECTED;
+				wake_up(&substream->runtime->sleep);
+				wake_up(&substream->runtime->tsleep);
+			}
 			snd_pcm_stream_unlock_irq(substream);
 		}
 	list_for_each_entry(notify, &snd_pcm_notify_list, list) {
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 95043e3..d15e5be 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1518,6 +1518,10 @@ static int snd_pcm_drain(struct snd_pcm_substream *substream,
 		down_read(&snd_pcm_link_rwsem);
 		snd_pcm_stream_lock_irq(substream);
 		remove_wait_queue(&to_check->sleep, &wait);
+		if (card->shutdown) {
+			result = -ENODEV;
+			break;
+		}
 		if (tout == 0) {
 			if (substream->runtime->status->state == SNDRV_PCM_STATE_SUSPENDED)
 				result = -ESTRPIPE;
@@ -2168,6 +2172,10 @@ static int snd_pcm_open(struct file *file, struct snd_pcm *pcm, int stream)
 		mutex_unlock(&pcm->open_mutex);
 		schedule();
 		mutex_lock(&pcm->open_mutex);
+		if (pcm->card->shutdown) {
+			err = -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 7d4f62a..1bb95ae 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -424,6 +424,10 @@ static int snd_rawmidi_open(struct inode *inode, struct file *file)
 		mutex_unlock(&rmidi->open_mutex);
 		schedule();
 		mutex_lock(&rmidi->open_mutex);
+		if (rmidi->card->shutdown) {
+			err = -ENODEV;
+			break;
+		}
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
@@ -995,6 +999,8 @@ static ssize_t snd_rawmidi_read(struct file *file, char __user *buf, size_t coun
 			spin_unlock_irq(&runtime->lock);
 			schedule();
 			remove_wait_queue(&runtime->sleep, &wait);
+			if (rfile->rmidi->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
 			if (!runtime->avail)
@@ -1238,6 +1244,8 @@ static ssize_t snd_rawmidi_write(struct file *file, const char __user *buf,
 			spin_unlock_irq(&runtime->lock);
 			timeout = schedule_timeout(30 * HZ);
 			remove_wait_queue(&runtime->sleep, &wait);
+			if (rfile->rmidi->card->shutdown)
+				return -ENODEV;
 			if (signal_pending(current))
 				return result > 0 ? result : -ERESTARTSYS;
 			if (!runtime->avail && !timeout)
@@ -1613,9 +1621,20 @@ static int snd_rawmidi_dev_register(struct snd_device *device)
 static int snd_rawmidi_dev_disconnect(struct snd_device *device)
 {
 	struct snd_rawmidi *rmidi = device->device_data;
+	int dir;
 
 	mutex_lock(&register_mutex);
+	mutex_lock(&rmidi->open_mutex);
+	wake_up(&rmidi->open_wait);
 	list_del_init(&rmidi->list);
+	for (dir = 0; dir < 2; dir++) {
+		struct snd_rawmidi_substream *s;
+		list_for_each_entry(s, &rmidi->streams[dir].substreams, list) {
+			if (s->runtime)
+				wake_up(&s->runtime->sleep);
+		}
+	}
+
 #ifdef CONFIG_SND_OSSEMUL
 	if (rmidi->ossreg) {
 		if ((int)rmidi->device == midi_map[rmidi->card->number]) {
@@ -1630,6 +1649,7 @@ static int snd_rawmidi_dev_disconnect(struct snd_device *device)
 	}
 #endif /* CONFIG_SND_OSSEMUL */
 	snd_unregister_device(SNDRV_DEVICE_TYPE_RAWMIDI, rmidi->card, rmidi->device);
+	mutex_unlock(&rmidi->open_mutex);
 	mutex_unlock(&register_mutex);
 	return 0;
 }
-- 
1.7.9.5

