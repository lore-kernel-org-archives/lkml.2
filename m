Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2DRKIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:08:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:60854 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2DRKIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:08:45 -0400
Date: Wed, 18 Apr 2012 12:08:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven Joachim <svenjoac@gmx.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: kernel panic after suspend/resume
In-Reply-To: <87hawhtpo9.fsf@turtle.gmx.de>
Message-ID: <alpine.LFD.2.02.1204181205540.2542@ionos>
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com> <87pqb6fkji.fsf@turtle.gmx.de> <CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com> <201204172321.41095.rjw@sisk.pl> <87hawhtpo9.fsf@turtle.gmx.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2012, Sven Joachim wrote:

> On 2012-04-17 23:21 +0200, Rafael J. Wysocki wrote:
> 
> > Well, commit fa4da365bc7772c kind of looks like it might be the source of
> > this trouble.  Sven, can you try to revert it, please?
> 
> This seems to do the trick, thanks.

Can you try the following patch instead?

Thanks,

	tglx


diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index bf57abd..119aca5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -531,7 +531,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
-		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 
 		/* Take the do_timer update */
 		tick_do_timer_cpu = cpu;
@@ -549,6 +548,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			   to_cpumask(tmpmask));
 
 		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
+			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
 			tick_broadcast_init_next_event(to_cpumask(tmpmask),
 						       tick_next_period);
 			tick_broadcast_set_event(tick_next_period, 1);
@@ -577,15 +577,10 @@ void tick_broadcast_switch_to_oneshot(void)
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
-
-	if (cpumask_empty(tick_get_broadcast_mask()))
-		goto end;
-
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
 
-end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
