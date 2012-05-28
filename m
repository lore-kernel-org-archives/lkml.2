Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2E1Qt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 12:49:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52594 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2E1QtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 12:49:25 -0400
Date: Mon, 28 May 2012 18:49:14 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 5/5] timekeeping: Use a continuous timescale to
 tell time.
Message-ID: <20120528164913.GA2285@netboy.at.omicron.at>
References: <cover.1335510125.git.richardcochran@gmail.com>
 <35c0c03617503dba8cb4001350c57a6db1be6d29.1335510125.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35c0c03617503dba8cb4001350c57a6db1be6d29.1335510125.git.richardcochran@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 10:12:44AM +0200, Richard Cochran wrote:
> This patch converts the core time keeping code to use a continuous
> timescale called the Kernel Time Scale (KTS). KTS is based on the
> TAI timescale but can be offset from it by an integral number of seconds.
> Every function that returns UTC time now coverts the seconds by adding
> the current KTS - UTC offset.
> 
> As a result of this change, the NTP leap second code is considerably
> simplified and hopefully more robust.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  include/linux/timex.h     |    2 +-
>  kernel/time/ntp.c         |   81 ++++++++++----------------------------------
>  kernel/time/timekeeping.c |   73 ++++++++++++++++++++++++++++++++--------
>  3 files changed, 79 insertions(+), 77 deletions(-)
> 
> diff --git a/include/linux/timex.h b/include/linux/timex.h
> index 99bc88b..9461e6f 100644
> --- a/include/linux/timex.h
> +++ b/include/linux/timex.h
> @@ -252,7 +252,7 @@ extern void ntp_clear(void);
>  /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
>  extern u64 ntp_tick_length(void);
>  
> -extern int second_overflow(unsigned long secs);
> +void second_overflow(void);
>  extern int do_adjtimex(struct timex *);
>  extern void hardpps(const struct timespec *, const struct timespec *);
>  
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index d0a2183..91de2f8 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -16,6 +16,7 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  
> +#include "leap-seconds.h"
>  #include "tick-internal.h"
>  
>  /*
> @@ -24,6 +25,7 @@
>  
>  DEFINE_SPINLOCK(ntp_lock);
>  
> +#define STA_LEAP		(STA_INS | STA_DEL)
>  
>  /* USER_HZ period (usecs): */
>  unsigned long			tick_usec = TICK_USEC;
> @@ -42,19 +44,9 @@ static u64			tick_length_base;
>   * phase-lock loop variables
>   */
>  
> -/*
> - * clock synchronization status
> - *
> - * (TIME_ERROR prevents overwriting the CMOS clock)
> - */
> -static int			time_state = TIME_OK;
> -
>  /* clock status bits:							*/
>  static int			time_status = STA_UNSYNC;
>  
> -/* TAI offset (secs):							*/
> -static long			time_tai;
> -
>  /* time adjustment (nsecs):						*/
>  static s64			time_offset;
>  
> @@ -386,57 +378,14 @@ u64 ntp_tick_length(void)
>   * They were originally developed for SUN and DEC kernels.
>   * All the kudos should go to Dave for this stuff.
>   *
> - * Also handles leap second processing, and returns leap offset
>   */
> -int second_overflow(unsigned long secs)
> +void second_overflow(void)
>  {
>  	s64 delta;
> -	int leap = 0;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ntp_lock, flags);
>  
> -	/*
> -	 * Leap second processing. If in leap-insert state at the end of the
> -	 * day, the system clock is set back one second; if in leap-delete
> -	 * state, the system clock is set ahead one second.
> -	 */
> -	switch (time_state) {
> -	case TIME_OK:
> -		if (time_status & STA_INS)
> -			time_state = TIME_INS;
> -		else if (time_status & STA_DEL)
> -			time_state = TIME_DEL;
> -		break;
> -	case TIME_INS:
> -		if (secs % 86400 == 0) {
> -			leap = -1;
> -			time_state = TIME_OOP;
> -			printk(KERN_NOTICE
> -				"Clock: inserting leap second 23:59:60 UTC\n");
> -		}
> -		break;
> -	case TIME_DEL:
> -		if ((secs + 1) % 86400 == 0) {
> -			leap = 1;
> -			time_tai--;
> -			time_state = TIME_WAIT;
> -			printk(KERN_NOTICE
> -				"Clock: deleting leap second 23:59:59 UTC\n");
> -		}
> -		break;
> -	case TIME_OOP:
> -		time_tai++;
> -		time_state = TIME_WAIT;
> -		break;
> -
> -	case TIME_WAIT:
> -		if (!(time_status & (STA_INS | STA_DEL)))
> -			time_state = TIME_OK;
> -		break;
> -	}
> -
> -
>  	/* Bump the maxerror field */
>  	time_maxerror += MAXFREQ / NSEC_PER_USEC;
>  	if (time_maxerror > NTP_PHASE_LIMIT) {
> @@ -475,8 +424,6 @@ int second_overflow(unsigned long secs)
>  
>  out:
>  	spin_unlock_irqrestore(&ntp_lock, flags);
> -
> -	return leap;
>  }
>  
>  #ifdef CONFIG_GENERIC_CMOS_UPDATE
> @@ -541,7 +488,6 @@ static inline void notify_cmos_timer(void) { }
>  static inline void process_adj_status(struct timex *txc, struct timespec *ts)
>  {
>  	if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
> -		time_state = TIME_OK;
>  		time_status = STA_UNSYNC;
>  		/* restart PPS frequency calibration */
>  		pps_reset_freq_interval();
> @@ -554,6 +500,18 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
>  	if (!(time_status & STA_PLL) && (txc->status & STA_PLL))
>  		time_reftime = get_seconds();
>  
> +	/*
> +	 * Check for new leap second commands.
> +	 */
> +	if (!(time_status & STA_INS) && (txc->status & STA_INS))
> +		timekeeper_insert_leap_second();
> +
> +	else if (!(time_status & STA_DEL) && (txc->status & STA_DEL))
> +		timekeeper_delete_leap_second();
> +
> +	else if ((time_status & STA_LEAP) && !(txc->status & STA_LEAP))
> +		timekeeper_finish_leap_second();
> +
>  	/* only set allowed bits */
>  	time_status &= STA_RONLY;
>  	time_status |= txc->status & ~STA_RONLY;

Just for the record, this hunk and the following violate the (unspoken
but mentioned in the discussion on V2 series) locking rules for
ntp_lock and timekeerer.lock.

> @@ -597,7 +555,7 @@ static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts
>  	}
>  
>  	if (txc->modes & ADJ_TAI && txc->constant > 0)
> -		time_tai = txc->constant;
> +		timekeeper_tai_offset(txc->constant);
>  
>  	if (txc->modes & ADJ_OFFSET)
>  		ntp_update_offset(txc->offset);

Thanks,
Richard
