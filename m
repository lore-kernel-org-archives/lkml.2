Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab1C3VGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:17267 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238Ab1C3VG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132875"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: clemens@ladisch.de, ak@linux.intel.com, tiwai@suse.de, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [48/275] ALSA: hrtimer: handle delayed timer interrupts
Message-Id: <20110330210444.3A55F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/hrtimer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/sound/core/hrtimer.c
===================================================================
--- linux-2.6.35.y.orig/sound/core/hrtimer.c	2011-03-29 22:51:50.260437129 -0700
+++ linux-2.6.35.y/sound/core/hrtimer.c	2011-03-29 23:02:59.176321246 -0700
@@ -45,12 +45,13 @@
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
