Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1C3VFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:05:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:46799 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab1C3VFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673446997"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: fzu@wemgehoertderstaat.de, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [10/275] ALSA: snd-usb-us122l: Fix missing NULL checks
Message-Id: <20110330210404.3B3213E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

commit cdce2db74e156fbd9a2dc3c7b246166f8b70955b upstream.

Fix missing NULL checks in usb_stream_hwdep_poll() and usb_stream_hwdep_ioctl().
Wake up poll waiters before returning from usb_stream_hwdep_ioctl().

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/usb/usx2y/us122l.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

Index: linux-2.6.35.y/sound/usb/usx2y/us122l.c
===================================================================
--- linux-2.6.35.y.orig/sound/usb/usx2y/us122l.c	2011-03-29 22:52:03.697093319 -0700
+++ linux-2.6.35.y/sound/usb/usx2y/us122l.c	2011-03-29 23:02:58.442340027 -0700
@@ -273,29 +273,26 @@
 					  struct file *file, poll_table *wait)
 {
 	struct us122l	*us122l = hw->private_data;
-	struct usb_stream *s = us122l->sk.s;
 	unsigned	*polled;
 	unsigned int	mask;
 
 	poll_wait(file, &us122l->sk.sleep, wait);
 
-	switch (s->state) {
-	case usb_stream_ready:
-		if (us122l->first == file)
-			polled = &s->periods_polled;
-		else
-			polled = &us122l->second_periods_polled;
-		if (*polled != s->periods_done) {
-			*polled = s->periods_done;
-			mask = POLLIN | POLLOUT | POLLWRNORM;
-			break;
+	mask = POLLIN | POLLOUT | POLLWRNORM | POLLERR;
+	if (mutex_trylock(&us122l->mutex)) {
+		struct usb_stream *s = us122l->sk.s;
+		if (s && s->state == usb_stream_ready) {
+			if (us122l->first == file)
+				polled = &s->periods_polled;
+			else
+				polled = &us122l->second_periods_polled;
+			if (*polled != s->periods_done) {
+				*polled = s->periods_done;
+				mask = POLLIN | POLLOUT | POLLWRNORM;
+			} else
+				mask = 0;
 		}
-		/* Fall through */
-		mask = 0;
-		break;
-	default:
-		mask = POLLIN | POLLOUT | POLLWRNORM | POLLERR;
-		break;
+		mutex_unlock(&us122l->mutex);
 	}
 	return mask;
 }
@@ -381,6 +378,7 @@
 {
 	struct usb_stream_config *cfg;
 	struct us122l *us122l = hw->private_data;
+	struct usb_stream *s;
 	unsigned min_period_frames;
 	int err = 0;
 	bool high_speed;
@@ -426,18 +424,18 @@
 	snd_power_wait(hw->card, SNDRV_CTL_POWER_D0);
 
 	mutex_lock(&us122l->mutex);
+	s = us122l->sk.s;
 	if (!us122l->master)
 		us122l->master = file;
 	else if (us122l->master != file) {
-		if (memcmp(cfg, &us122l->sk.s->cfg, sizeof(*cfg))) {
+		if (!s || memcmp(cfg, &s->cfg, sizeof(*cfg))) {
 			err = -EIO;
 			goto unlock;
 		}
 		us122l->slave = file;
 	}
-	if (!us122l->sk.s ||
-	    memcmp(cfg, &us122l->sk.s->cfg, sizeof(*cfg)) ||
-	    us122l->sk.s->state == usb_stream_xrun) {
+	if (!s || memcmp(cfg, &s->cfg, sizeof(*cfg)) ||
+	    s->state == usb_stream_xrun) {
 		us122l_stop(us122l);
 		if (!us122l_start(us122l, cfg->sample_rate, cfg->period_frames))
 			err = -EIO;
@@ -448,6 +446,7 @@
 	mutex_unlock(&us122l->mutex);
 free:
 	kfree(cfg);
+	wake_up_all(&us122l->sk.sleep);
 	return err;
 }
 
