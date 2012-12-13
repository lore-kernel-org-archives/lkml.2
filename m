Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2LMOGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab2LMOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 095/241] ALSA: usb-audio: Fix mutex deadlock at disconnection
Date: Thu, 13 Dec 2012 11:57:40 -0200
Message-Id: <1355407206-17100-96-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 10e44239f67d0b6fb74006e61a7e883b8075247a upstream.

The recent change for USB-audio disconnection race fixes introduced a
mutex deadlock again.  There is a circular dependency between
chip->shutdown_rwsem and pcm->open_mutex, depicted like below, when a
device is opened during the disconnection operation:

A. snd_usb_audio_disconnect() ->
     card.c::register_mutex ->
       chip->shutdown_rwsem (write) ->
         snd_card_disconnect() ->
           pcm.c::register_mutex ->
             pcm->open_mutex

B. snd_pcm_open() ->
     pcm->open_mutex ->
       snd_usb_pcm_open() ->
         chip->shutdown_rwsem (read)

Since the chip->shutdown_rwsem protection in the case A is required
only for turning on the chip->shutdown flag and it doesn't have to be
taken for the whole operation, we can reduce its window in
snd_usb_audio_disconnect().

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/usb/card.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 486b4a6..b3f5ad4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -559,9 +559,11 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
 		return;
 
 	card = chip->card;
-	mutex_lock(&register_mutex);
 	down_write(&chip->shutdown_rwsem);
 	chip->shutdown = 1;
+	up_write(&chip->shutdown_rwsem);
+
+	mutex_lock(&register_mutex);
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
 		snd_card_disconnect(card);
@@ -582,11 +584,9 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
 			snd_usb_mixer_disconnect(p);
 		}
 		usb_chip[chip->index] = NULL;
-		up_write(&chip->shutdown_rwsem);
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);
 	} else {
-		up_write(&chip->shutdown_rwsem);
 		mutex_unlock(&register_mutex);
 	}
 }
-- 
1.7.9.5

