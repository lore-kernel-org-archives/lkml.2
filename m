Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2GSJhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:37:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33531 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2GSJhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:37:09 -0400
Date: Thu, 19 Jul 2012 11:37:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] jiffies: Allow CLOCK_TICK_RATE to be undefined
Message-ID: <20120719093704.GB27086@gmail.com>
References: <1342660753-10382-1-git-send-email-john.stultz@linaro.org>
 <1342660753-10382-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342660753-10382-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> CLOCK_TICK_RATE is a legacy constant that defines the timer
> device's granularity. On hardware with particularly coarse
> granularity, this constant is used to reduce accumulated
> time error when using jiffies as a clocksource, by calculating
> the hardware's actual tick length rather then just assuming
> it is 1sec/HZ.
> 
> However, for the most part this is unnecessary, as most modern
> systems don't use jiffies for their clocksource, and their
> tick device is sufficiently fine grained to avoid major error.
> 
> Thus, this patch allows an architecture to not define
> CLOCK_TICK_RATE, in which case ACTHZ defaults to (HZ << 8).
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> [jstultz: commit log tweaks]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/jiffies.h |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index 265e2c3..a2134be 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -39,9 +39,6 @@
>  # error Invalid value of HZ.
>  #endif
>  
> -/* LATCH is used in the interval timer and ftape setup. */
> -#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
> -
>  /* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we can
>   * improve accuracy by shifting LSH bits, hence calculating:
>   *     (NOM << LSH) / DEN
> @@ -54,8 +51,15 @@
>  #define SH_DIV(NOM,DEN,LSH) (   (((NOM) / (DEN)) << (LSH))              \
>                               + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
>  
> +#ifdef CLOCK_TICK_RATE
> +/* LATCH is used in the interval timer and ftape setup. */
> +#define LATCH ((CLOCK_TICK_RATE + HZ/2) / HZ)	/* For divider */
> +
>  /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
>  #define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
> +#else
> +#define ACTHZ (HZ << 8)
> +#endif

The ACTHZ naming ugliness slipped past me. 'ACT' can mean so 
many things - please improve it to something more obvious, like 
'REAL_HZ' or 'KERNEL_HZ'.

Also, we tend to write such #if/#else/#endif patterns as:

#if FOO
# define BAR 
#else
# define BAZ
#endif

Thanks,

	Ingo
