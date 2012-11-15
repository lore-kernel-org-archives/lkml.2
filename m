Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993009Ab2KOELn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:11:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:49226 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933434Ab2KOELi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 39/66] ALSA: usb-audio: Use rwsem for disconnect protection
Date: Wed, 14 Nov 2012 20:10:44 -0800
Message-Id: <20121115040941.814536695@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 34f3c89fda4fba9fe689db22253ca8db2f5e6386 upstream.

Replace mutex with rwsem for codec->shutdown protection so that
concurrent accesses are allowed.

Also add the protection to snd_usb_autosuspend() and
snd_usb_autoresume(), too.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.c     |   12 ++++++++----
 sound/usb/mixer.c    |   12 ++++++------
 sound/usb/pcm.c      |   12 ++++++------
 sound/usb/usbaudio.h |    2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -339,7 +339,7 @@ static int snd_usb_audio_create(struct u
 	}
 
 	mutex_init(&chip->mutex);
-	mutex_init(&chip->shutdown_mutex);
+	init_rwsem(&chip->shutdown_rwsem);
 	chip->index = idx;
 	chip->dev = dev;
 	chip->card = card;
@@ -560,7 +560,7 @@ static void snd_usb_audio_disconnect(str
 
 	card = chip->card;
 	mutex_lock(&register_mutex);
-	mutex_lock(&chip->shutdown_mutex);
+	down_write(&chip->shutdown_rwsem);
 	chip->shutdown = 1;
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
@@ -582,11 +582,11 @@ static void snd_usb_audio_disconnect(str
 			snd_usb_mixer_disconnect(p);
 		}
 		usb_chip[chip->index] = NULL;
-		mutex_unlock(&chip->shutdown_mutex);
+		up_write(&chip->shutdown_rwsem);
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
 	} else {
-		mutex_unlock(&chip->shutdown_mutex);
+		up_write(&chip->shutdown_rwsem);
 		mutex_unlock(&register_mutex);
 	}
 }
@@ -618,16 +618,20 @@ int snd_usb_autoresume(struct snd_usb_au
 {
 	int err = -ENODEV;
 
+	down_read(&chip->shutdown_rwsem);
 	if (!chip->shutdown && !chip->probing)
 		err = usb_autopm_get_interface(chip->pm_intf);
+	up_read(&chip->shutdown_rwsem);
 
 	return err;
 }
 
 void snd_usb_autosuspend(struct snd_usb_audio *chip)
 {
+	down_read(&chip->shutdown_rwsem);
 	if (!chip->shutdown && !chip->probing)
 		usb_autopm_put_interface(chip->pm_intf);
+	up_read(&chip->shutdown_rwsem);
 }
 
 static int usb_audio_suspend(struct usb_interface *intf, pm_message_t message)
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -292,7 +292,7 @@ static int get_ctl_value_v1(struct usb_m
 	err = snd_usb_autoresume(cval->mixer->chip);
 	if (err < 0)
 		return -EIO;
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	while (timeout-- > 0) {
 		if (chip->shutdown)
 			break;
@@ -310,7 +310,7 @@ static int get_ctl_value_v1(struct usb_m
 	err = -EINVAL;
 
  out:
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(cval->mixer->chip);
 	return err;
 }
@@ -337,7 +337,7 @@ static int get_ctl_value_v2(struct usb_m
 	if (ret)
 		goto error;
 
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	if (chip->shutdown)
 		ret = -ENODEV;
 	else {
@@ -346,7 +346,7 @@ static int get_ctl_value_v2(struct usb_m
 			      USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 			      validx, idx, buf, size);
 	}
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(chip);
 
 	if (ret < 0) {
@@ -453,7 +453,7 @@ int snd_usb_mixer_set_ctl_value(struct u
 	err = snd_usb_autoresume(chip);
 	if (err < 0)
 		return -EIO;
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	while (timeout-- > 0) {
 		if (chip->shutdown)
 			break;
@@ -471,7 +471,7 @@ int snd_usb_mixer_set_ctl_value(struct u
 	err = -EINVAL;
 
  out:
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(chip);
 	return err;
 }
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -474,7 +474,7 @@ static int snd_usb_hw_params(struct snd_
 		subs->period_bytes != params_period_bytes(hw_params) ||
 		subs->cur_rate != rate;
 
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	if (subs->stream->chip->shutdown) {
 		ret = -ENODEV;
 		goto unlock;
@@ -512,7 +512,7 @@ static int snd_usb_hw_params(struct snd_
 	}
 
 unlock:
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return ret;
 }
 
@@ -528,12 +528,12 @@ static int snd_usb_hw_free(struct snd_pc
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	if (!subs->stream->chip->shutdown) {
 		stop_endpoints(subs, 0, 1, 1);
 		deactivate_endpoints(subs);
 	}
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return snd_pcm_lib_free_vmalloc_buffer(substream);
 }
 
@@ -553,7 +553,7 @@ static int snd_usb_pcm_prepare(struct sn
 		return -ENXIO;
 	}
 
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	if (subs->stream->chip->shutdown) {
 		ret = -ENODEV;
 		goto unlock;
@@ -582,7 +582,7 @@ static int snd_usb_pcm_prepare(struct sn
 		ret = start_endpoints(subs, 1);
 
  unlock:
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return ret;
 }
 
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -37,7 +37,7 @@ struct snd_usb_audio {
 	struct usb_interface *pm_intf;
 	u32 usb_id;
 	struct mutex mutex;
-	struct mutex shutdown_mutex;
+	struct rw_semaphore shutdown_rwsem;
 	unsigned int shutdown:1;
 	unsigned int probing:1;
 	unsigned int autosuspended:1;	


