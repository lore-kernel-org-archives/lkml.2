Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab0DMEGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:06:44 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52126 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0DMEGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:06:43 -0400
Subject: Re: [PATCH] time: remove xtime_cache (take 2)
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Petr =?UTF-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100412210044.2ebbc058.akpm@linux-foundation.org>
References: <1270589451-30773-1-git-send-email-johnstul@us.ibm.com>
	 <20100412210044.2ebbc058.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 21:06:40 -0700
Message-ID: <1271131600.3469.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 21:00 -0400, Andrew Morton wrote:
> On Tue,  6 Apr 2010 14:30:51 -0700 John Stultz <johnstul@us.ibm.com> wrote:
> 
> > Thomas: Mind queueing this up for 2.6.35?
> > 
> > With the earlier logarithmic time accumulation patch, xtime will now
> > always be within one "tick" of the current time, instead of possibly
> > half a second off.
> > 
> > This removes the need for the xtime_cache value, which always stored the
> > time at the last interrupt, so this patch cleans that up removing the
> > xtime_cache related code.
> > 
> > This patch also addresses an issue with an earlier version of this change,
> > where xtime_cache was normalizing xtime, which could in some cases be
> > not valid (ie: tv_nsec == NSEC_PER_SEC). This is fixed by handling
> > the edge case in update_wall_time().
> > 
> > ...
> >
> > --- a/kernel/time.c
> > +++ b/kernel/time.c
> > @@ -135,7 +135,6 @@ static inline void warp_clock(void)
> >  	write_seqlock_irq(&xtime_lock);
> >  	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
> >  	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
> > -	update_xtime_cache(0);
> >  	write_sequnlock_irq(&xtime_lock);
> >  	clock_was_set();
> >  }
> 
> This conflicts with your time-clean-up-warp_clock.patch, below.
> 
> Shrug, I simply ignored the rejected hunk.

Yep. That should be fine. We're just dropping the update_xtime_cache
call, so if it doesn't exist, its not a problem.

thanks
-john

