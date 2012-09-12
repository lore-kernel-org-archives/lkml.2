Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2IMAZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:25:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab2ILXfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:35:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Daniel Mack <zonque@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 075/108] ALSA: snd-usb: restore delay information
Date: Wed, 12 Sep 2012 16:29:13 -0700
Message-Id: <20120912232458.372832234@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Mack <zonque@gmail.com>

commit fbcfbf5f673847657ccd98afb4d8e13af7fdc372 upstream.

Parts of commit 294c4fb8 ("ALSA: usb: refine delay information with USB
frame counter") were unfortunately lost during the refactoring of the
snd-usb driver in 3.5.

This patch adds them back, restoring the correct delay information
behaviour.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/pcm.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1091,7 +1091,16 @@ static void prepare_playback_urb(struct
 	subs->hwptr_done += bytes;
 	if (subs->hwptr_done >= runtime->buffer_size * stride)
 		subs->hwptr_done -= runtime->buffer_size * stride;
+
+	/* update delay with exact number of samples queued */
+	runtime->delay = subs->last_delay;
 	runtime->delay += frames;
+	subs->last_delay = runtime->delay;
+
+	/* realign last_frame_number */
+	subs->last_frame_number = usb_get_current_frame_number(subs->dev);
+	subs->last_frame_number &= 0xFF; /* keep 8 LSBs */
+
 	spin_unlock_irqrestore(&subs->lock, flags);
 	urb->transfer_buffer_length = bytes;
 	if (period_elapsed)
@@ -1109,12 +1118,26 @@ static void retire_playback_urb(struct s
 	struct snd_pcm_runtime *runtime = subs->pcm_substream->runtime;
 	int stride = runtime->frame_bits >> 3;
 	int processed = urb->transfer_buffer_length / stride;
+	int est_delay;
 
 	spin_lock_irqsave(&subs->lock, flags);
-	if (processed > runtime->delay)
-		runtime->delay = 0;
+	est_delay = snd_usb_pcm_delay(subs, runtime->rate);
+	/* update delay with exact number of samples played */
+	if (processed > subs->last_delay)
+		subs->last_delay = 0;
 	else
-		runtime->delay -= processed;
+		subs->last_delay -= processed;
+	runtime->delay = subs->last_delay;
+
+	/*
+	 * Report when delay estimate is off by more than 2ms.
+	 * The error should be lower than 2ms since the estimate relies
+	 * on two reads of a counter updated every ms.
+	 */
+	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
+		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
+			est_delay, subs->last_delay);
+
 	spin_unlock_irqrestore(&subs->lock, flags);
 }
 


