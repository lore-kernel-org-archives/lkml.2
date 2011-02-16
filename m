Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1BPBuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:50:12 -0500
Received: from kroah.org ([198.145.64.141]:48927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab1BPBuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:58 2011
Message-Id: <20110216014658.819265532@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [045/115] ALSA: hrtimer: handle delayed timer interrupts
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit b1d4f7f4bdcf9915c41ff8cfc4425c84dabb1fde upstream.

If a timer interrupt was delayed too much, hrtimer_forward_now() will
forward the timer expiry more than once.  When this happens, the
additional number of elapsed ALSA timer ticks must be passed to
snd_timer_interrupt() to prevent the ALSA timer from falling behind.

This mostly fixes MIDI slowdown problems on highly-loaded systems with
badly behaved interrupt handlers.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -44,12 +44,13 @@ static enum hrtimer_restart snd_hrtimer_
 {
 	struct snd_hrtimer *stime = container_of(hrt, struct snd_hrtimer, hrt);
 	struct snd_timer *t = stime->timer;
+	unsigned long oruns;
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;
 
-	hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
-	snd_timer_interrupt(stime->timer, t->sticks);
+	oruns = hrtimer_forward_now(hrt, ns_to_ktime(t->sticks * resolution));
+	snd_timer_interrupt(stime->timer, t->sticks * oruns);
 
 	if (!atomic_read(&stime->running))
 		return HRTIMER_NORESTART;


