Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab2D0XIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:08:13 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42465 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523Ab2D0XIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:08:11 -0400
Message-ID: <4F9B26D3.1030100@linaro.org>
Date: Fri, 27 Apr 2012 16:08:03 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 4/5] timekeeping: Offer an interface to manipulate
 leap seconds.
References: <cover.1335510125.git.richardcochran@gmail.com> <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <52e139c98370c405288cbbb4ac76c435dc36731f.1335510125.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042723-1976-0000-0000-00000CB8027E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:12 AM, Richard Cochran wrote:
> This patch adds a new internal interface to be used by the NTP code in
> order to set the next leap second event. Also, it adds a kernel command
> line option that can be used to dial the TAI - UTC offset at boot.
>
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
> ---
>   kernel/time/leap-seconds.h |   23 ++++++
>   kernel/time/timekeeping.c  |  175 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 198 insertions(+), 0 deletions(-)
>   create mode 100644 kernel/time/leap-seconds.h
[snip]
>   /* Structure holding internal timekeeping values. */
>   struct timekeeper {
>   	/* Current clocksource used for timekeeping. */
> @@ -50,6 +53,16 @@ struct timekeeper {
>
>   	/* The current time */
>   	struct timespec xtime;
> +	/* The Kernel Time Scale (KTS) value of the next leap second. */
> +	time_t next_leapsecond;

I'm not a big fan of this new Kernel Time Scale. I don't think we really 
need a new time domain, and it only muddles things.
Why not have next_leapsecond be specified in CLOCK_MONOTONIC time?

> +	/* The current difference KTS - UTC. */
> +	int kts_utc_offset;
> +	/* The current difference TAI - KTS. */
> +	int tai_kts_offset;
Again, get rid of KTS and we can simplify these as:
CLOCK_TAI = CLOCK_MONOTONIC + mono_to_tai;
UTC/CLOCK_REALTIME = CLOCK_TAI + utc_offset;

This basically requires changing the timekeeping core from keeping track 
of CLOCK_REALTIME as its time base, and instead having it use 
CLOCK_MONOTONIC. This actually is something I proposed a long time ago, 
but was deferred because folks were concerned that the extra addition 
would slow gettimeofday() down.  However, that was back when everything 
internally used jiffies. These days ktime_get() is probably called 
internally more frequently, and so optimizing for CLOCK_MONOTONIC makes 
sense.



> +#ifdef CONFIG_DELETE_LEAP_SECONDS
> +	/* Remembers whether to insert or to delete. */
> +	int insert_leapsecond;
> +#endif

I'm not a big fan of this additional config option.  The maintenance 
burden for the extra condition is probably not worth the code size 
trade-off.  Or it needs way more justification.

>   	/*
>   	 * wall_to_monotonic is what we need to add to xtime (or xtime corrected
>   	 * for sub jiffie times) to get to monotonic time.  Monotonic is pegged
> @@ -87,6 +100,30 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
>   int __read_mostly timekeeping_suspended;
>
>
> +static int __init tai_offset_setup(char *str)
> +{
> +	get_option(&str,&timekeeper.kts_utc_offset);
> +	return 1;
> +}
> +__setup("tai_offset=", tai_offset_setup);
> +
Oooof.. Yuck.  I really don't like the boot time tai_offset argument. 
What sysadmin wants to change their grub settings after a leapsecond so 
that the next reboot its set properly?  I'd suggest tai_offset be set to 
zero until userland updates it at boot time.  CLOCK_TAI is not 
CLOCK_MONOTONIC, and it can jump around if the user calls 
settimeofday(), so I don't see a major reason for it to be initialized 
via a boot argument.  Its true that right now there's no userland 
infrastructure to set it (other then ntp, but I've never verified it 
actually gets set), but there also aren't any users consuming it either.

thanks
-john

