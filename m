Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab1BPASE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:18:04 -0500
Received: from kroah.org ([198.145.64.141]:38577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab1BPASC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:25 2011
Message-Id: <20110216001425.763150498@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Karsten Wiese <fzu@wemgehoertderstaat.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [007/272] ALSA: snd-usb-us122l: Fix missing NULL checks
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

commit cdce2db74e156fbd9a2dc3c7b246166f8b70955b upstream.

Fix missing NULL checks in usb_stream_hwdep_poll() and usb_stream_hwdep_ioctl().
Wake up poll waiters before returning from usb_stream_hwdep_ioctl().

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usx2y/us122l.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -273,29 +273,26 @@ static unsigned int usb_stream_hwdep_pol
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
@@ -381,6 +378,7 @@ static int usb_stream_hwdep_ioctl(struct
 {
 	struct usb_stream_config *cfg;
 	struct us122l *us122l = hw->private_data;
+	struct usb_stream *s;
 	unsigned min_period_frames;
 	int err = 0;
 	bool high_speed;
@@ -426,18 +424,18 @@ static int usb_stream_hwdep_ioctl(struct
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
@@ -448,6 +446,7 @@ unlock:
 	mutex_unlock(&us122l->mutex);
 free:
 	kfree(cfg);
+	wake_up_all(&us122l->sk.sleep);
 	return err;
 }
 


