Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945948Ab2LNXlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:41:16 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:62838 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab2LNXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:41:14 -0500
Message-ID: <50CBB917.7090502@linaro.org>
Date: Fri, 14 Dec 2012 15:41:11 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] NTP: Add a CONFIG_RTC_SYSTOHC configuration
References: <20121214231933.GA15796@obsidianresearch.com>
In-Reply-To: <20121214231933.GA15796@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 03:19 PM, Jason Gunthorpe wrote:
> The purpose of this option is to allow ARM/etc systems that rely on the
> class RTC subsystem to have the same kind of automatic NTP based
> synchronization that we have on PC platforms. Today ARM does not
> implement update_persistent_clock and makes extensive use of the class
> RTC system.
>
> When enabled CONFIG_RTC_SYSTOHC will provide a generic
> rtc_update_persistent_clock that stores the current time in the RTC and
> is intended complement the existing CONFIG_RTC_HCTOSYS option that loads
> the RTC at boot.
>
> Like with RTC_HCTOSYS the platform's update_persistent_clock is used
> first, if it works. Platforms with mixed class RTC and non-RTC drivers
> need to return ENODEV when class RTC should be used. Such an update for
> PPC is included in this patch.
>
> Long term, implementations of update_persistent_clock should migrate to
> proper class RTC drivers and use CONFIG_RTC_SYSTOHC instead.

Ok. This all sounds good.


Still one minor question below.
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 19c03ab..7b3702b 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -28,6 +28,7 @@ config RTC_HCTOSYS
>   config RTC_HCTOSYS_DEVICE
>   	string "RTC used to set the system time"
>   	depends on RTC_HCTOSYS = y
> +	depends on RTC_SYSTOHC = y

Is this right?

This should probably be a depends on RTC_HCTOSYS OR RTC_SYSTOCH.. 
Otherwise you have to select both in order to change the default device.

> diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
> new file mode 100644
> index 0000000..a625740
> --- /dev/null
> +++ b/drivers/rtc/systohc.c
> @@ -0,0 +1,44 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + */
> +#include <linux/rtc.h>
> +#include <linux/time.h>
> +
> +/**
> + * rtc_update_persistent_clock - Save NTP synchronized time to the RTC
> + * @now: Current time of day
> + *
> + * Replacement for the NTP platform function update_persistent_clock
> + * that stores time for later retrieval by rtc_hctosys
> + *
> + * Returns 0 on successful RTC update, -ENODEV if a RTC update is not
> + * possible at all, and various other -errno for specific temporary failure
> + * cases.
> + *
> + * If temporary failure is indicated the caller should try again 'soon'
> + */
> +int rtc_update_persistent_clock(struct timespec now)

If we're going to move away from update_persistent_clock across the 
board (and as the update path doesn't have the same constraints of the 
read_persistent_clock interface), might it be better just to name this: 
rtc_update_clock()  (or something similar)?

That way if/when we do finally remove the other users of 
update_persistent_clock() and move them to an RTC driver, we will avoid 
any confusion between read/update.

This is in the similar vein of your suggestion of changing 
update_persistent_clock to platform_save_ntp_time_to_rtc()..

Sorry for the last minute nit! Other then these two issues, I'm happy to 
queue this (if Alessandro doesn't object).  Although with the merge 
window already open it may have to wait to 3.9, but I'll see what Thomas 
says.

thanks
-john

