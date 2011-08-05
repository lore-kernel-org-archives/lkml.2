Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1HEKVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:21:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33950 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1HEKVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:21:19 -0400
Subject: Re: [PATCH] Remove CLOCK_TICK_RATE from ACTHZ definition
From: john stultz <johnstul@us.ibm.com>
To: dsaxena@plexity.net
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, patches@linaro.org
In-Reply-To: <20110804000046.GA23503@plexity.net>
References: <20110804000046.GA23503@plexity.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Aug 2011 03:21:12 -0700
Message-ID: <1312539672.2764.41.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 17:00 -0700, Deepak Saxena wrote:
> As per https://lkml.org/lkml/2011/2/21/323, we remove
> CLOCK_TICK_RATE from the definition of ACTHZ as the
> majority of CLOCK_TICK_RATE values are no longer valid
> or needed for proper operation of the time code.
> 
> Signed-off-by: Deepak Saxena <dsaxena@linaro.org>
> ---
>  include/linux/jiffies.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index f97672a..d232f00 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -55,7 +55,7 @@
>                               + ((((NOM) % (DEN)) << (LSH)) + (DEN) / 2) / (DEN))
> 
>  /* HZ is the requested value. ACTHZ is actual HZ ("<< 8" is for accuracy) */
> -#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
> +#define ACTHZ (HZ << 8)
> 
>  /* TICK_NSEC is the time between ticks in nsec assuming real ACTHZ */
>  #define TICK_NSEC (SH_DIV (1000000UL * 1000, ACTHZ, 8))

So I'm hesitant about this patch, since the whole point of ACTHZ is to
provide a higher precision value for the actual irq frequency (as
hardware won't be able to do exactly 100/250/300/1000HZ).

One could argue that with highres timers, jiffies is usually updated by
the timekeeping code, which for the most part isn't affected by irq freq
error. So we could reasonably forgo this minor error correction, only
hurting systems that use the jiffies clocksource, or require
ARCH_USES_GETTIMEOFFSET.

However, we would probably want to kill off all the ACTHZ usage as well
since we're at that point gaining nothing from the extra complexity.

thanks
-john




