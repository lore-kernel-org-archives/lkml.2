Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab1CUXmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:42:06 -0400
Received: from kroah.org ([198.145.64.141]:49556 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab1CUXQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:15 2011
Message-Id: <20110321230715.703755511@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [63/87] ALSA: aloop - Fix possible IRQ lock inversion
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 98d21df431ad55281e1abf780f8d51e3391900b2 upstream.

loopback_pos_update() can be called in the timer callback, thus the lock
held should be irq-safe.  Otherwise you'll get AB/BA deadlock together
with substream->self_group.lock.

Reported-and-tested-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/drivers/aloop.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -482,8 +482,9 @@ static unsigned int loopback_pos_update(
 			cable->streams[SNDRV_PCM_STREAM_CAPTURE];
 	unsigned long delta_play = 0, delta_capt = 0;
 	unsigned int running;
+	unsigned long flags;
 
-	spin_lock(&cable->lock);	
+	spin_lock_irqsave(&cable->lock, flags);
 	running = cable->running ^ cable->pause;
 	if (running & (1 << SNDRV_PCM_STREAM_PLAYBACK)) {
 		delta_play = jiffies - dpcm_play->last_jiffies;
@@ -495,10 +496,8 @@ static unsigned int loopback_pos_update(
 		dpcm_capt->last_jiffies += delta_capt;
 	}
 
-	if (delta_play == 0 && delta_capt == 0) {
-		spin_unlock(&cable->lock);
-		return running;
-	}
+	if (delta_play == 0 && delta_capt == 0)
+		goto unlock;
 		
 	if (delta_play > delta_capt) {
 		loopback_bytepos_update(dpcm_play, delta_play - delta_capt,
@@ -510,14 +509,14 @@ static unsigned int loopback_pos_update(
 		delta_capt = delta_play;
 	}
 
-	if (delta_play == 0 && delta_capt == 0) {
-		spin_unlock(&cable->lock);
-		return running;
-	}
+	if (delta_play == 0 && delta_capt == 0)
+		goto unlock;
+
 	/* note delta_capt == delta_play at this moment */
 	loopback_bytepos_update(dpcm_capt, delta_capt, BYTEPOS_UPDATE_COPY);
 	loopback_bytepos_update(dpcm_play, delta_play, BYTEPOS_UPDATE_POSONLY);
-	spin_unlock(&cable->lock);
+ unlock:
+	spin_unlock_irqrestore(&cable->lock, flags);
 	return running;
 }
 


