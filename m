Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab1D0TMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:12:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44532 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab1D0TMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:12:06 -0400
Subject: Re: [RFC][PATCH 1/4] clock_rtoffset: new syscall
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <alpine.LFD.2.02.1104271359580.3323@ionos>
References: <alpine.LFD.2.00.1103102040190.2787@localhost6.localdomain6>
	 <1303901023-11568-1-git-send-email-virtuoso@slind.org>
	 <alpine.LFD.2.02.1104271359580.3323@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 12:11:40 -0700
Message-ID: <1303931500.2971.14.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 16:02 +0200, Thomas Gleixner wrote:
> On Wed, 27 Apr 2011, Alexander Shishkin wrote:
> 
> > In order to keep track of system time changes, we introduce a new
> > syscall which returns the offset of CLOCK_MONOTONIC clock against
> > CLOCK_REALTIME. The caller is to store this value and use it in
> > system calls (like clock_nanosleep or timerfd_settime) that will
> > compare it against the effective offset in order to ensure that
> > the caller's notion of the system time corresponds to the effective
> > system time at the moment of the action being carried out. If it
> > has changed, these system calls will return an error and the caller
> > will have to obtain this offset again.
> 
> No, we do not expose kernel internals like this to user space. The
> kernel internal representation of time is subject to change.
> 
> Also abusing the reminder argument of clock_nanosleep for handing back
> the offset is a horrible hack including the non standard -ECANCELED
> return value. No, we don't change posix interfaces that way.
> 
> We can add something to timerfd, but definitly not with another
> syscall and by bloating hrtimer and sprinkling cancellation calls all
> over the place. clock_was_set() should be enough and it already calls
> into the hrtimer code, the resume path calls into it as well, so
> there is no need to introduce such a mess.
> 
> The completely untested patch below should solve the same problem in a
> sane way. Restricted to timerfd, but that really should be sufficient.


Overall looks good. I flinched a little bit at adding an internal only
clockid but trying to avoid that would really make it messy.

Few minor nits below, but just my opinion, so you can ignore.

Otherwise:
Acked-by: John Stultz <johnstul@us.ibm.com>


> Index: linux-2.6-tip/include/linux/time.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/time.h
> +++ linux-2.6-tip/include/linux/time.h
> @@ -295,6 +295,11 @@ struct itimerval {
>  #define CLOCK_MONOTONIC_COARSE		6
>  #define CLOCK_BOOTTIME			7
> 
> +#ifdef __KERNEL__
> +/* This clock is not exposed to user space */
> +#define CLOCK_REALTIME_COS		8
> +#endif

Would something like INTERNAL_CLOCK_REALTIME_COS be more explicit?



> @@ -1221,6 +1231,22 @@ static void __run_hrtimer(struct hrtimer
>  	timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }
> 
> +static void
> +hrtimer_expire_cancelable(struct hrtimer_cpu_base *cpu_base, ktime_t now)
> +{
> +	struct timerqueue_node *node;
> +	struct hrtimer_clock_base *base;
> +
> +	base = cpu_base->clock_base + HRTIMER_BASE_REALTIME_COS;

I know its the same thing, but for some reason the above makes me think
that the clock_base could be non-zero. 

	base = &cpu_base->clock_base[HRTIMER_BASE_REALTIME_COS];

seems more straight forward to me. But its not a huge deal.




