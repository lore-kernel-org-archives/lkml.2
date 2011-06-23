Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab1FWRV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:21:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:62669 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756Ab1FWRVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:21:51 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Karsten Wiese <fzu@wemgehoertderstaat.de>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 004/247] ALSA: snd-usb-us122l: Fix missing NULL checks
Date: Thu, 23 Jun 2011 13:17:27 -0400
Message-Id: <1308849690-14530-5-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cdce2db74e156fbd9a2dc3c7b246166f8b70955b upstream.

Fix missing NULL checks in usb_stream_hwdep_poll() and usb_stream_hwdep_ioctl().
Wake up poll waiters before returning from usb_stream_hwdep_ioctl().

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/usb/usx2y/us122l.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 9ca9a13..886427b 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -272,29 +272,26 @@ static unsigned int usb_stream_hwdep_poll(struct snd_hwdep *hw,
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
@@ -380,6 +377,7 @@ static int usb_stream_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
 {
 	struct usb_stream_config *cfg;
 	struct us122l *us122l = hw->private_data;
+	struct usb_stream *s;
 	unsigned min_period_frames;
 	int err = 0;
 	bool high_speed;
@@ -425,18 +423,18 @@ static int usb_stream_hwdep_ioctl(struct snd_hwdep *hw, struct file *file,
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
@@ -447,6 +445,7 @@ unlock:
 	mutex_unlock(&us122l->mutex);
 free:
 	kfree(cfg);
+	wake_up_all(&us122l->sk.sleep);
 	return err;
 }
 
-- 
1.7.4.4

