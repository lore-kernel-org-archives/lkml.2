Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0KDHw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 03:52:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48711 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0KDHw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 03:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YM13MHFXvmYeXftgdRMDIo2j2O52gAG+YRllb5tCGy4wEjPEEkbpwLfUE2r3QrEEAa
         FhMjNNdHEeOHn2m9zKA/Iq7cX4vvn1Nl2Pvn5VYvaJ3OXxQMK/48NjCkhGV55d1LRG4Q
         PlleBC9Ylcj5hmzFTLQHCEItYxafWTnT2nFvw=
Date: Thu, 4 Nov 2010 08:52:29 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 7/7] [RFC] Introduce Alarm (hybrid) timers
Message-ID: <20101104075229.GA28086@riccoc20.at.omicron.at>
References: <1288809079-14663-1-git-send-email-john.stultz@linaro.org>
 <1288809079-14663-8-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288809079-14663-8-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 11:31:19AM -0700, John Stultz wrote:

> Another large distinction is that while the in-kernel interface
> is pretty similar, the user-space interface for android alarm
> timers is via ioctls. I've instead chosen to export this
> functionality via the posix interface, as it seemed a little
> simpler and avoids creating duplicate interfaces to things like
> CLOCK_REALTIME and CLOCK_MONOTONIC under alternate names (ie:
> RTC and ELAPSED_REALTIME). Instead, if one wants to use a
> alarm timer, simply create a posix timer against either
> CLOCK_REALTIME_ALARM or CLOCK_MONOTONIC_ALARM.

I have a comment on this, below ...

> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index e6b46b5..9d1ace6 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -5,6 +5,7 @@
>  #include <linux/list.h>
>  #include <linux/sched.h>
>  #include <linux/rtc.h>
> +#include <linux/alarmtimer.h>
>  
>  union cpu_time_count {
>  	cputime_t cpu;
> @@ -65,6 +66,7 @@ struct k_itimer {
>  			unsigned long expires;
>  		} mmtimer;
>  		struct rtc_timer rtctimer;
> +		struct alarm alarmtimer;
>  	} it;
>  };

I have an initial dynamic clock patch set ready for review and will
post it later today if I can. In implementing the timer_ calls, I
began to wonder about this 'it' union. If we really allow and
implement many kinds of dynamic clocks, then it would seem ugly to me
to simply add yet another union member for each new clock. Wouldn't it
be better to provide a private void pointer for the underlying
driver's use?

> diff --git a/include/linux/time.h b/include/linux/time.h
> index 914c48d..4791858 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -290,6 +290,8 @@ struct itimerval {
>  #define CLOCK_MONOTONIC_RAW		4
>  #define CLOCK_REALTIME_COARSE		5
>  #define CLOCK_MONOTONIC_COARSE		6
> +#define CLOCK_REALTIME_ALARM		7
> +#define CLOCK_MONOTONIC_ALARM		8

I have thought about and have taken Alan Cox's anti-SYS5.4/SuS/POSIX
enumeration arguments to heart. If you need a really good example of
the weaknesses of that way, take a look at clock_getcpuclockid,
pthread_getcpuclockid, and their implementation in posix-cpu-timers.c

If we are serious about dynamic clocks, then we will never again touch
the CLOCK_ list. I hope that, after reviewing the coming patch set,
you will also agree ;)

Richard

