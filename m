Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1CEBMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:12:46 -0500
Received: from kroah.org ([198.145.64.141]:50281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760416Ab1CEBAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.208651500@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [37/73] ALSA: usb-audio: fix oops due to cleanup race when disconnecting
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 382225e62bdb8059b7f915b133426425516dd300 upstream.

When a USB audio device is disconnected, snd_usb_audio_disconnect()
kills all audio URBs.  At the same time, the application, after being
notified of the disconnection, might close the device, in which case
ALSA calls the .hw_free callback, which should free the URBs too.

Commit de1b8b93a0ba "[ALSA] Fix hang-up at disconnection of usb-audio"
prevented snd_usb_hw_free() from freeing the URBs to avoid a hang that
resulted from this race, but this introduced another race because the
URB callbacks could now be executed after snd_usb_hw_free() has
returned, and try to access already freed data.

Fix the first race by introducing a mutex to serialize the disconnect
callback and all PCM callbacks that manage URBs (hw_free and hw_params).

Reported-and-tested-by: Pierre-Louis Bossart <pierre-louis.bossart@intel.com>
[CL: also serialize hw_params callback]
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/card.c     |    4 ++++
 sound/usb/pcm.c      |    7 +++++--
 sound/usb/usbaudio.h |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -323,6 +323,7 @@ static int snd_usb_audio_create(struct u
 		return -ENOMEM;
 	}
 
+	mutex_init(&chip->shutdown_mutex);
 	chip->index = idx;
 	chip->dev = dev;
 	chip->card = card;
@@ -531,6 +532,7 @@ static void snd_usb_audio_disconnect(str
 	chip = ptr;
 	card = chip->card;
 	mutex_lock(&register_mutex);
+	mutex_lock(&chip->shutdown_mutex);
 	chip->shutdown = 1;
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
@@ -548,9 +550,11 @@ static void snd_usb_audio_disconnect(str
 			snd_usb_mixer_disconnect(p);
 		}
 		usb_chip[chip->index] = NULL;
+		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
 	} else {
+		mutex_unlock(&chip->shutdown_mutex);
 		mutex_unlock(&register_mutex);
 	}
 }
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -361,6 +361,7 @@ static int snd_usb_hw_params(struct snd_
 	}
 
 	if (changed) {
+		mutex_lock(&subs->stream->chip->shutdown_mutex);
 		/* format changed */
 		snd_usb_release_substream_urbs(subs, 0);
 		/* influenced: period_bytes, channels, rate, format, */
@@ -368,6 +369,7 @@ static int snd_usb_hw_params(struct snd_
 						  params_rate(hw_params),
 						  snd_pcm_format_physical_width(params_format(hw_params)) *
 							params_channels(hw_params));
+		mutex_unlock(&subs->stream->chip->shutdown_mutex);
 	}
 
 	return ret;
@@ -385,8 +387,9 @@ static int snd_usb_hw_free(struct snd_pc
 	subs->cur_audiofmt = NULL;
 	subs->cur_rate = 0;
 	subs->period_bytes = 0;
-	if (!subs->stream->chip->shutdown)
-		snd_usb_release_substream_urbs(subs, 0);
+	mutex_lock(&subs->stream->chip->shutdown_mutex);
+	snd_usb_release_substream_urbs(subs, 0);
+	mutex_unlock(&subs->stream->chip->shutdown_mutex);
 	return snd_pcm_lib_free_vmalloc_buffer(substream);
 }
 
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -36,6 +36,7 @@ struct snd_usb_audio {
 	struct snd_card *card;
 	u32 usb_id;
 	int shutdown;
+	struct mutex shutdown_mutex;
 	unsigned int txfr_quirk:1; /* Subframe boundaries on transfers */
 	int num_interfaces;
 	int num_suspended_intf;


