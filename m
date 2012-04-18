Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2DRLDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 07:03:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57252 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752868Ab2DRLDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 07:03:45 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19dyLQiRT9djH9auuqaZYbTjcBvPp5/kXurrHydOj
	41UPeJYQf9Pa9J
From: Sven Joachim <svenjoac@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: kernel panic after suspend/resume
References: <CA+55aFzsjpJt09b6e4NA0T50M3w0xtASSYXz_=UWVDqKRywo=A@mail.gmail.com>
	<87pqb6fkji.fsf@turtle.gmx.de>
	<CA+55aFxhb6hriqHHwVtNeYHmtcy5JCEJX-zABBcG2Zjw_gawPw@mail.gmail.com>
	<201204172321.41095.rjw@sisk.pl> <87hawhtpo9.fsf@turtle.gmx.de>
	<alpine.LFD.2.02.1204181205540.2542@ionos>
Date: Wed, 18 Apr 2012 13:03:34 +0200
In-Reply-To: <alpine.LFD.2.02.1204181205540.2542@ionos> (Thomas Gleixner's
	message of "Wed, 18 Apr 2012 12:08:23 +0200 (CEST)")
Message-ID: <87pqb55mk9.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 18.04.2012 um 12:08 schrieb Thomas Gleixner:

> On Wed, 18 Apr 2012, Sven Joachim wrote:
>
>> On 2012-04-17 23:21 +0200, Rafael J. Wysocki wrote:
>> 
>> > Well, commit fa4da365bc7772c kind of looks like it might be the source of
>> > this trouble.  Sven, can you try to revert it, please?
>> 
>> This seems to do the trick, thanks.
>
> Can you try the following patch instead?

Appears to work fine, thanks.

> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index bf57abd..119aca5 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -531,7 +531,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>  		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
>  
>  		bc->event_handler = tick_handle_oneshot_broadcast;
> -		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>  
>  		/* Take the do_timer update */
>  		tick_do_timer_cpu = cpu;
> @@ -549,6 +548,7 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
>  			   to_cpumask(tmpmask));
>  
>  		if (was_periodic && !cpumask_empty(to_cpumask(tmpmask))) {
> +			clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
>  			tick_broadcast_init_next_event(to_cpumask(tmpmask),
>  						       tick_next_period);
>  			tick_broadcast_set_event(tick_next_period, 1);
> @@ -577,15 +577,10 @@ void tick_broadcast_switch_to_oneshot(void)
>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>  
>  	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
> -
> -	if (cpumask_empty(tick_get_broadcast_mask()))
> -		goto end;
> -
>  	bc = tick_broadcast_device.evtdev;
>  	if (bc)
>  		tick_broadcast_setup_oneshot(bc);
>  
> -end:
>  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
