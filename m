Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab1IEQqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 12:46:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:50125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab1IEQqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 12:46:30 -0400
Date: Mon, 5 Sep 2011 09:49:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, perex@perex.cz,
        tiwai@suse.de
Subject: [PATCH] sound: Fix race condition in the pcm_lib "wait for space
 loop
Message-ID: <20110905094947.6ece87c2@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2e37f0a4b2289962e1a45d8e02f8a7f7adad619f Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 5 Sep 2011 09:40:18 -0700
Subject: [PATCH] sound: Fix race condition in the pcm_lib "wait for space" loop

The wait_for_avail() function in pcm_lib.c has a race in it (observed in
practice by an Intel validation group).

The function is supposed to return once space in the buffer has become
available, or if some timeout happens.  The entity that creates space (irq
handler of sound driver and some such) will do a wake up on a waitqueue that
this function registers for.

However there are two races in the existing code
1) If space became available between the caller noticing there was no space and
   this function actually sleeping, the wakeup is missed and the timeout
   condition will happen instead
2) If a wakeup happened but not sufficient space became available, the code will loop
   again and wait for more space. However, if the second wake comes in prior
   to hitting the schedule_timeout_interruptible(), it will be missed, and
   potentially you'll wait out until the timeout happens.

The fix consists of using more careful setting of the current state (so that
if a wakeup happens in the main loop window, the schedule_timeout() falls
through) and by checking for available space prior to going into the
schedule_timeout() loop, but after being on the waitqueue and having the
state set to interruptible.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: Jaroslav Kysela <perex@perex.cz>
CC: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org
CC: linux-kernel@vger.kernel.org
---
 sound/core/pcm_lib.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 86d0caf..8848080 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -1761,6 +1761,10 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 	snd_pcm_uframes_t avail = 0;
 	long wait_time, tout;
 
+	init_waitqueue_entry(&wait, current);
+	add_wait_queue(&runtime->tsleep, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
 	if (runtime->no_period_wakeup)
 		wait_time = MAX_SCHEDULE_TIMEOUT;
 	else {
@@ -1771,16 +1775,34 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 		}
 		wait_time = msecs_to_jiffies(wait_time * 1000);
 	}
-	init_waitqueue_entry(&wait, current);
-	add_wait_queue(&runtime->tsleep, &wait);
+
+	/*
+	 * We need to check if space became available already (and thus the
+	 * wakeup happened already) prior to going into the sleep loop to
+	 * close the race of space already having become available.
+	 * This check must happen after been added to the waitqueue and
+	 * having current state be INTERRUPTIBLE.
+	 */
+
+	if (is_playback)
+		avail = snd_pcm_playback_avail(runtime);
+	else
+		avail = snd_pcm_capture_avail(runtime);
+	if (avail >= runtime->twake)
+		goto _endloop;
+
+
 	for (;;) {
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			break;
 		}
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
@@ -1814,6 +1836,7 @@ static int wait_for_avail(struct snd_pcm_substream *substream,
 			break;
 	}
  _endloop:
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&runtime->tsleep, &wait);
 	*availp = avail;
 	return err;
-- 
1.7.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
