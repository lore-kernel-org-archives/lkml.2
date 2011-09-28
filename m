Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1I1Wpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:45:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab1I1Wpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:39 2011
Message-Id: <20110928220138.943289115@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arjan van de Ven <arjan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [129/244] ALSA: pcm - fix race condition in wait_for_avail()
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arjan van de Ven <arjan@infradead.org>

commit 763437a9e7737535b2fc72175ad4974048769be6 upstream.

wait_for_avail() in pcm_lib.c has a race in it (observed in practice by an
Intel validation group).

The function is supposed to return once space in the buffer has become
available, or if some timeout happens.  The entity that creates space (irq
handler of sound driver and some such) will do a wake up on a waitqueue
that this function registers for.

However there are two races in the existing code

1) If space became available between the caller noticing there was no
   space and this function actually sleeping, the wakeup is missed and the
   timeout condition will happen instead

2) If a wakeup happened but not sufficient space became available, the
   code will loop again and wait for more space.  However, if the second
   wake comes in prior to hitting the schedule_timeout_interruptible(), it
   will be missed, and potentially you'll wait out until the timeout
   happens.

The fix consists of using more careful setting of the current state (so
that if a wakeup happens in the main loop window, the schedule_timeout()
falls through) and by checking for available space prior to going into the
schedule_timeout() loop, but after being on the waitqueue and having the
state set to interruptible.

[tiwai: the following changes have been added to Arjan's original patch:
 - merged akpm's fix for waitqueue adding order into a single patch
 - reduction of duplicated code of avail check
]

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_lib.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1758,6 +1758,10 @@ static int wait_for_avail(struct snd_pcm
 	snd_pcm_uframes_t avail = 0;
 	long wait_time, tout;
 
+	init_waitqueue_entry(&wait, current);
+	set_current_state(TASK_INTERRUPTIBLE);
+	add_wait_queue(&runtime->tsleep, &wait);
+
 	if (runtime->no_period_wakeup)
 		wait_time = MAX_SCHEDULE_TIMEOUT;
 	else {
@@ -1768,16 +1772,32 @@ static int wait_for_avail(struct snd_pcm
 		}
 		wait_time = msecs_to_jiffies(wait_time * 1000);
 	}
-	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&runtime->tsleep, &wait);
+
 	for (;;) {
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
 		}
+
+		/*
+		 * We need to check if space became available already
+		 * (and thus the wakeup happened already) first to close
+		 * the race of space already having become available.
+		 * This check must happen after been added to the waitqueue
+		 * and having current state be INTERRUPTIBLE.
+		 */
+		if (is_playback)
+			avail = snd_pcm_playback_avail(runtime);
+		else
+			avail = snd_pcm_capture_avail(runtime);
+		if (avail >= runtime->twake)
+			break;
 		snd_pcm_stream_unlock_irq(substream);
-		tout = schedule_timeout_interruptible(wait_time);
+
+		tout = schedule_timeout(wait_time);
+
 		snd_pcm_stream_lock_irq(substream);
+		set_current_state(TASK_INTERRUPTIBLE);
 		switch (runtime->status->state) {
 		case SNDRV_PCM_STATE_SUSPENDED:
 			err = -ESTRPIPE;
@@ -1803,14 +1823,9 @@ static int wait_for_avail(struct snd_pcm
 			err = -EIO;
 			break;
 		}
-		if (is_playback)
-			avail = snd_pcm_playback_avail(runtime);
-		else
-			avail = snd_pcm_capture_avail(runtime);
-		if (avail >= runtime->twake)
-			break;
 	}
  _endloop:
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&runtime->tsleep, &wait);
 	*availp = avail;
 	return err;


