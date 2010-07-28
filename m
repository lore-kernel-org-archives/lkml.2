Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0G1Jot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:44:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57821 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0G1Joq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:44:46 -0400
Date: Wed, 28 Jul 2010 10:44:14 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Israel Schlesinger <israels@codeaurora.org>,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] checkpatch: Add warnings for use of mdelay()
Message-ID: <20100728094414.GA3586@shadowen.org>
References: <4C4F132F.6020401@codeaurora.org>
 <20100727113133.1605c9fe@bike.lwn.net>
 <4C4F1846.3090103@codeaurora.org>
 <20100727121610.64b38cfa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727121610.64b38cfa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:16:10PM -0700, Andrew Morton wrote:
> On Tue, 27 Jul 2010 10:32:54 -0700
> Patrick Pannuto <ppannuto@codeaurora.org> wrote:
> 
> > On 07/27/2010 10:31 AM, Jonathan Corbet wrote:
> > > On Tue, 27 Jul 2010 10:11:11 -0700
> > > Israel Schlesinger <israels@codeaurora.org> wrote:
> > > 
> > >> mdelay is a busy-wait loop which is wasteful. If at all possible,
> > >> callers should use msleep instead of mdelay.
> > >>
> > >> The only time mdelay is really appropriate is in atomic context,
> > >> however, delays of 1ms+ in atomic context are rather expensive, so
> > >> a warning for this case is probably appropriate as well to encourage
> > >> people to move such expensive delays outside of atomic context
> > > 
> > > Once upon a time, msleep(1) would sleep for 20ms, while mdelay(1) gave
> > > a 1ms delay.  My patch to fix msleep() at that time didn't get in due
> > > to concerns about the cost of using hrtimers.  Perhaps msleep() has
> > > gotten better, but, if not, actually getting a 1ms delay remains a
> > > valid reason for using mdelay() instead IMO.  It made a difference of a
> > > few seconds at open time for a driver I was doing at the time.
> > > 
> > > jon
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > Check out the recently added usleep in -tip, and the checkpatch patch
> > pending in my queue that fixes that case (I'll send in a few hours ;) )
> > 
> 
> The message should point people at usleep_range(), I'd suggest.  It's a
> more power-friendly way of sleeping.
> 
> That assumes that the below patch gets merged - the people who handle
> timer-related things are presently, err, asleep.
> 
> 
> From: Patrick Pannuto <ppannuto@codeaurora.org>
> 
> usleep[_range] are finer precision implementations of msleep and are
> designed to be drop-in replacements for udelay where a precise sleep /
> busy-wait is unnecessary.  They also allow an easy interface to specify
> slack when a precise (ish) wakeup is unnecessary to help minimize wakeups
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/delay.h |    6 ++++++
>  kernel/timer.c        |   22 ++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff -puN include/linux/delay.h~timers-add-usleep-timer include/linux/delay.h
> --- a/include/linux/delay.h~timers-add-usleep-timer
> +++ a/include/linux/delay.h
> @@ -45,6 +45,12 @@ extern unsigned long lpj_fine;
>  void calibrate_delay(void);
>  void msleep(unsigned int msecs);
>  unsigned long msleep_interruptible(unsigned int msecs);
> +void usleep_range(unsigned long min, unsigned long max);
> +
> +static inline void usleep(unsigned long usecs)
> +{
> +	usleep_range(usecs, usecs);
> +}
>  
>  static inline void ssleep(unsigned int seconds)
>  {
> diff -puN kernel/timer.c~timers-add-usleep-timer kernel/timer.c
> --- a/kernel/timer.c~timers-add-usleep-timer
> +++ a/kernel/timer.c
> @@ -1763,3 +1763,25 @@ unsigned long msleep_interruptible(unsig
>  }
>  
>  EXPORT_SYMBOL(msleep_interruptible);
> +
> +static int __sched do_usleep_range(unsigned long min, unsigned long max)
> +{
> +	ktime_t kmin;
> +	unsigned long delta;
> +
> +	kmin = ktime_set(0, min * NSEC_PER_USEC);
> +	delta = max - min;

If this interface is taking a min and max in micro-seconds, then does
not the delta need also to be converted to nano-seconds?

schedule_hrtimeout_range seems to call hrtimer_set_expires_range_ns
which seems to generally be called with 'delta_ns'.  Something like:

delta = (max - min) * NSEC_PER_USEC;

> +	return schedule_hrtimeout_range(&kmin, delta, HRTIMER_MODE_REL);
> +}
> +
> +/**
> + * usleep_range - Drop in replacement for udelay where wakeup is flexible
> + * @min: Minimum time in usecs to sleep
> + * @max: Maximum time in usecs to sleep
> + */
> +void usleep_range(unsigned long min, unsigned long max)
> +{
> +	__set_current_state(TASK_UNINTERRUPTIBLE);
> +	do_usleep_range(min, max);
> +}
> +EXPORT_SYMBOL(usleep_range);

-apw
