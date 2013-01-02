Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab3ABK73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 05:59:29 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43645 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3ABK71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 05:59:27 -0500
Date: Wed, 2 Jan 2013 10:59:20 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clockevents: Add generic timer broadcast
 receiver
Message-ID: <20130102105919.GA21978@e106331-lin.cambridge.arm.com>
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
 <1355832418-31692-3-git-send-email-mark.rutland@arm.com>
 <50D433AA.6070606@ti.com>
MIME-Version: 1.0
In-Reply-To: <50D433AA.6070606@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jan 2013 10:59:23.0597 (UTC) FILETIME=[39538FD0:01CDE8D8]
X-MC-Unique: 113010210592503701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 10:02:18AM +0000, Santosh Shilimkar wrote:
> On Tuesday 18 December 2012 05:36 PM, Mark Rutland wrote:
> > Currently the broadcast mechanism used for timers is abstracted by a
> > function pointer on struct clock_event_device. As the fundamental
> > mechanism for broadcast is architecture-specific, this ties each
> > clock_event_device driver to a single architecture, even where the
> > driver is otherwise generic.
> >
> > This patch adds a standard path for the receipt of timer broadcasts, so
> > drivers and/or architecture backends need not manage redundant lists of
> > timers for the purpose of routing broadcast timer ticks.
> >
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> >   include/linux/clockchips.h   |    4 ++++
> >   kernel/time/tick-broadcast.c |   15 +++++++++++++++
> >   2 files changed, 19 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> > index 8a7096f..e1089aa 100644
> > --- a/include/linux/clockchips.h
> > +++ b/include/linux/clockchips.h
> > @@ -161,6 +161,10 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
> >   extern void clockevents_suspend(void);
> >   extern void clockevents_resume(void);
> >
> > +#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> > +extern int tick_receive_broadcast(void);
> > +#endif
> > +
> As mentioned in earlier patch, CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
> isn't must for SMP kernel and hence when build with
> !GENERIC_CLOCKEVENTS_BROADCAST, $subject patch will break the build.

I'd assumed that the broadcast receive path would be ifdef'd on
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST, and thus this wouldn't be a problem.
Though I guess it probably makes arch/platform code a bit nicer if it doesn't
have to ifdef everything.

> Below is the fix for the same. Feel free to fold it if you agree.

Will do.

> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
> index 6634652..921568b 100644
> --- a/include/linux/clockchips.h
> +++ b/include/linux/clockchips.h
> @@ -168,6 +168,11 @@ extern void tick_broadcast(const struct cpumask *mask);
>   #define tick_broadcast	NULL
>   #endif
>   extern int tick_receive_broadcast(void);
> +#else
> +static inline int tick_receive_broadcast(void)
> +{
> +	return 0;
> +}
>   #endif
> 
>   #ifdef CONFIG_GENERIC_CLOCKEVENTS
> 

Thanks,
Mark.

