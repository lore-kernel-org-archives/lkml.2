Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2KNGKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:10:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54933 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752058Ab2KNFt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:49:58 -0500
Message-Id: <20121114053935.090465011@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:39:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>,
        Matthieu CASTET <matthieu.castet@parrot.com>
Subject: [ 09/82] ALSA: usb-audio: Use rwsem for disconnect protection
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

commit 34f3c89fda4fba9fe689db22253ca8db2f5e6386 upstream.

Replace mutex with rwsem for codec->shutdown protection so that
concurrent accesses are allowed.

Also add the protection to snd_usb_autosuspend() and
snd_usb_autoresume(), too.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/card.c     | 12 ++++++++----
 sound/usb/mixer.c    | 12 ++++++------
 sound/usb/pcm.c      | 12 ++++++------
 sound/usb/usbaudio.h |  2 +-
 4 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 0f6dc0d..7003c13 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -336,7 +336,7 @@ static int snd_usb_audio_create(struct usb_device *dev, int idx,
 		return -ENOMEM;
 	}
 
-	mutex_init(&chip->shutdown_mutex);
+	init_rwsem(&chip->shutdown_rwsem);
 	chip->index = idx;
 	chip->dev = dev;
 	chip->card = card;
@@ -556,7 +556,7 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
 
 	card = chip->card;
 	mutex_lock(&register_mutex);
-	mutex_lock(&chip->shutdown_mutex);
+	down_write(&chip->shutdown_rwsem);
 	chip->shutdown = 1;
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
@@ -574,11 +574,11 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
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
@@ -610,16 +610,20 @@ int snd_usb_autoresume(struct snd_usb_audio *chip)
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
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 51a81ef..6730a33 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -292,7 +292,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request, int v
 	err = snd_usb_autoresume(cval->mixer->chip);
 	if (err < 0)
 		return -EIO;
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	while (timeout-- > 0) {
 		if (chip->shutdown)
 			break;
@@ -310,7 +310,7 @@ static int get_ctl_value_v1(struct usb_mixer_elem_info *cval, int request, int v
 	err = -EINVAL;
 
  out:
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(cval->mixer->chip);
 	return err;
 }
@@ -337,7 +337,7 @@ static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request, int v
 	if (ret)
 		goto error;
 
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	if (chip->shutdown)
 		ret = -ENODEV;
 	else {
@@ -346,7 +346,7 @@ static int get_ctl_value_v2(struct usb_mixer_elem_info *cval, int request, int v
 			      USB_RECIP_INTERFACE | USB_TYPE_CLASS | USB_DIR_IN,
 			      validx, idx, buf, size);
 	}
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(chip);
 
 	if (ret < 0) {
@@ -453,7 +453,7 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 	err = snd_usb_autoresume(chip);
 	if (err < 0)
 		return -EIO;
-	mutex_lock(&chip->shutdown_mutex);
+	down_read(&chip->shutdown_rwsem);
 	while (timeout-- > 0) {
 		if (chip->shutdown)
 			break;
@@ -471,7 +471,7 @@ int snd_usb_mixer_set_ctl_value(struct usb_mixer_elem_info *cval,
 	err = -EINVAL;
 
  out:
-	mutex_unlock(&chip->shutdown_mutex);
+	up_read(&chip->shutdown_rwsem);
 	snd_usb_autosuspend(chip);
 	return err;
 }
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 9a11fae..983e071 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -376,7 +376,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		subs->period_bytes != params_period_bytes(hw_params) ||
 		subs->cur_rate != rate;
 
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	if (subs->stream->chip->shutdown) {
 		ret = -ENODEV;
 		goto unlock;
@@ -406,7 +406,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	}
 
 unlock:
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return ret;
 }
 
@@ -422,9 +422,9 @@ static int snd_usb_hw_free(struct snd_pcm_substream *substream)
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	snd_usb_release_substream_urbs(subs, 0);
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return snd_pcm_lib_free_vmalloc_buffer(substream);
 }
 
@@ -444,7 +444,7 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 		return -ENXIO;
 	}
 
-	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	down_read(&subs->stream->chip->shutdown_rwsem);
 	if (subs->stream->chip->shutdown) {
 		ret = -ENODEV;
 		goto unlock;
@@ -463,7 +463,7 @@ static int snd_usb_pcm_prepare(struct snd_pcm_substream *substream)
 
 	ret = snd_usb_substream_prepare(subs, runtime);
  unlock:
-	mutex_unlock(&subs->stream->chip->shutdown_mutex);
+	up_read(&subs->stream->chip->shutdown_rwsem);
 	return ret;
 }
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 3e2b035..6c805a5 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -36,7 +36,7 @@ struct snd_usb_audio {
 	struct snd_card *card;
 	struct usb_interface *pm_intf;
 	u32 usb_id;
-	struct mutex shutdown_mutex;
+	struct rw_semaphore shutdown_rwsem;
 	unsigned int shutdown:1;
 	unsigned int probing:1;
 	unsigned int autosuspended:1;	


