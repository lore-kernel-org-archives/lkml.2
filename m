Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2JKCPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:15:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37206 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964898Ab2JKCPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:40 -0400
X-Sasl-enc: VVj8Et2cOPEjTv98YmIzT3FaPwSq8ScHn+74W0xNnzyG 1349921739
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 53/84] ALSA: aloop - add locking to timer access
Date: Thu, 11 Oct 2012 11:03:37 +0900
Message-Id: <20121011015426.598384623@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>

commit d4f1e48bd11e3df6a26811f7a1f06c4225d92f7d upstream.

When the loopback timer handler is running, calling del_timer() (for STOP
trigger) will not wait for the handler to complete before deactivating the
timer. The timer gets rescheduled in the handler as usual. Then a subsequent
START trigger will try to start the timer using add_timer() with a timer pending
leading to a kernel panic.

Serialize the calls to add_timer() and del_timer() using a spin lock to avoid
this.

Signed-off-by: Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/drivers/aloop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -119,6 +119,7 @@ struct loopback_pcm {
 	unsigned int period_size_frac;
 	unsigned long last_jiffies;
 	struct timer_list timer;
+	spinlock_t timer_lock;
 };
 
 static struct platform_device *devices[SNDRV_CARDS];
@@ -169,6 +170,7 @@ static void loopback_timer_start(struct
 	unsigned long tick;
 	unsigned int rate_shift = get_rate_shift(dpcm);
 
+	spin_lock(&dpcm->timer_lock);
 	if (rate_shift != dpcm->pcm_rate_shift) {
 		dpcm->pcm_rate_shift = rate_shift;
 		dpcm->period_size_frac = frac_pos(dpcm, dpcm->pcm_period_size);
@@ -181,12 +183,15 @@ static void loopback_timer_start(struct
 	tick = (tick + dpcm->pcm_bps - 1) / dpcm->pcm_bps;
 	dpcm->timer.expires = jiffies + tick;
 	add_timer(&dpcm->timer);
+	spin_unlock(&dpcm->timer_lock);
 }
 
 static inline void loopback_timer_stop(struct loopback_pcm *dpcm)
 {
+	spin_lock(&dpcm->timer_lock);
 	del_timer(&dpcm->timer);
 	dpcm->timer.expires = 0;
+	spin_unlock(&dpcm->timer_lock);
 }
 
 #define CABLE_VALID_PLAYBACK	(1 << SNDRV_PCM_STREAM_PLAYBACK)
@@ -658,6 +663,7 @@ static int loopback_open(struct snd_pcm_
 	dpcm->substream = substream;
 	setup_timer(&dpcm->timer, loopback_timer_function,
 		    (unsigned long)dpcm);
+	spin_lock_init(&dpcm->timer_lock);
 
 	cable = loopback->cables[substream->number][dev];
 	if (!cable) {


