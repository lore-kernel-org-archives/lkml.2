Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab0FQOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 10:12:50 -0400
Received: from www.tglx.de ([62.245.132.106]:36458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0FQOMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 10:12:49 -0400
Date: Thu, 17 Jun 2010 16:11:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Mike Galbraith <efault@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
       Brian Bloniarz <bmb@athenacr.com>, Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
In-Reply-To: <1276781044.27822.309.camel@twins>
Message-ID: <alpine.LFD.2.00.1006171606170.4290@localhost.localdomain>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>  <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>  <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>  <1276701411.30669.6.camel@marge.simson.net> 
 <1276756770.8248.20.camel@marge.simson.net>  <1276758038.9628.1.camel@marge.simson.net>  <1276771844.8121.14.camel@marge.simson.net> <1276781044.27822.309.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Peter Zijlstra wrote:

> On Thu, 2010-06-17 at 12:50 +0200, Mike Galbraith wrote:
> 
> > sched: do not ratelimit NOHZ when the tick is stopped.
> > 
> > Chris Wedgwood reports that 39c0cbe sched: Rate-limit nohz causes a serial
> > console regression, unresponsiveness, and indeed it does.  The below fixes
> > it by not skipping out when the tick has been stopped.
> > 
> > Tested that the throughput benefit of ratelimiting is still intact.  It is.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Reported-by: Chris Wedgwood <cw@f00f.org>
> 
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 5f171f0..83c5129 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -315,7 +315,7 @@ void tick_nohz_stop_sched_tick(int inidle)
> >  		goto end;
> >  	}
> >  
> > -	if (nohz_ratelimit(cpu))
> > +	if (!ts->tick_stopped && nohz_ratelimit(cpu))
> >  		goto end;
> >  
> >  	ts->idle_calls++;
> >  
> 
> 
> Humm,. the code around there suggests something like the below, but I
> must admit its been a while since I really read all that nohz stuff,
> Thomas, any preferences?

The version below is better as it solves the problem and follows the
nohz_ratelimit() advise even in the case where it changes after the
tick has been stopped.

Thanks,

	tglx
> ---
>  kernel/time/tick-sched.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 5f171f0..e0707ea 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -315,9 +315,6 @@ void tick_nohz_stop_sched_tick(int inidle)
>  		goto end;
>  	}
>  
> -	if (nohz_ratelimit(cpu))
> -		goto end;
> -
>  	ts->idle_calls++;
>  	/* Read jiffies and the time when jiffies were updated last */
>  	do {
> @@ -328,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {
> 
> 
