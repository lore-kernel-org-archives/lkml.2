Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab2LLTke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:40:34 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63024 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab2LLTka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:40:30 -0500
Message-ID: <50C8DDAA.5010101@linaro.org>
Date: Wed, 12 Dec 2012 11:40:26 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
References: <20121212055643.GA18078@obsidianresearch.com>
In-Reply-To: <20121212055643.GA18078@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 09:56 PM, Jason Gunthorpe wrote:
> The purpose of this option is to allow ARM/etc systems that rely on the
> class RTC subsystem to have the same kind of automatic NTP based
> synchronization that we have on PC platforms. Today ARM does not
> implement update_persistent_clock and makes extensive use of the
> class RTC system.
>
> When enabled CONFIG_RTC_SYSTOHC will provide a generic
> rtc_update_persistent_clock that stores the current time in the RTC
> and is intended complement the existing CONFIG_RTC_HCTOSYS option that
> loads the RTC at boot.
>
> The option also overrides the call to any platform update_persistent_clock
> so that the RTC subsystem completely and generically replaces this
> functionality.
>
> Tested on ARM kirkwood and PPC405
So I'm initially mixed on this, as it feels a little redundant (esp 
given it may override a higher precision arch-specific function). But 
from the perspective of this being a generic RTC function, instead of an 
per-arch implementation, it does seem reasonable.

Some further notes below.


> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>   drivers/rtc/Kconfig   |    8 ++++++++
>   drivers/rtc/Makefile  |    1 +
>   drivers/rtc/systohc.c |   30 ++++++++++++++++++++++++++++++
>   include/linux/time.h  |    1 +
>   kernel/time/ntp.c     |   12 ++++++++++--
>   5 files changed, 50 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/rtc/systohc.c
>
> I saw on Google an older version of a similar patch to this, but I
> couldn't find any indication what happened to it. So here is a
> slightly different take, tested on 3.7.
>
> I've been running basically this idea buried in PPC platform specific
> code since 2.6.16..
>
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 19c03ab..30a866a 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -48,6 +48,14 @@ config RTC_HCTOSYS_DEVICE
>   	  sleep states. Do not specify an RTC here unless it stays powered
>   	  during all this system's supported sleep states.
>
> +config RTC_SYSTOHC
> +	bool "Set the RTC time based on NTP synchronization"
> +	default y
> +	help
> +	  If you say yes here, the system time (wall clock) will be stored
> +          in the RTC specified by RTC_HCTOSYS_DEVICE approximately every 11
> +  	  minutes if the NTP status is synchronized.
> +
Nit: Does this need to depend on RTC_HCTOSYS_DEVICE being set?

Hrm. So on architectures that support GENERIC_CMOS_UPDATE already, this 
creates a duplicated code path that is slightly different. I'd like to 
avoid this if possible.  Since you're plugging 
rtc_update_persistent_clock into the GENERIC_CMOS_UPDATE code, we can't 
just have this option depend on !GENERIC_CMOS_UPDATE.

So this might need a slightly deeper rework?
I'd suggest the following:
1) Convert GENERIC_CMOS_UPDATE into SUPPORTS_UPDATE_PERSISTENT_CLOCK.
2) Add RTC_SYSTOHC but make it depend on !SUPPORTS_UPDATE_PERSISTENT_CLOCK


> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 24174b4..f79ab16 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -483,7 +483,15 @@ out:
>   	return leap;
>   }
>
> -#ifdef CONFIG_GENERIC_CMOS_UPDATE
> +#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
> +
> +/* Only do one, if using CONFIG_RTC_SYSTOHC then the platform function
> + * might be mapped to the RTC code already. */
> +#ifdef CONFIG_RTC_SYSTOHC
> +#define __update_persistent_clock rtc_update_persistent_clock
> +#else
> +#define __update_persistent_clock update_persistent_clock
> +#endif
Also, maybe this could be simplified, using a weak function that calls 
rtc_update_persistent_clock by default?
That way if there is an arch specific implementation, we will prioritize 
that one with less ifdef logic.

thanks
-john

