Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab2BTAcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:32:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34141 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2BTAct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:32:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.216.225 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F4194AB.40403@gmail.com>
Date: Mon, 20 Feb 2012 11:32:43 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] ARM: at91/rtc-at91sam9: each SoC can select the
 RTT device to use
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <9d1120bd8f1cf0615ff5044745b00fd3988397a7.1329500622.git.nicolas.ferre@atmel.com>
In-Reply-To: <9d1120bd8f1cf0615ff5044745b00fd3988397a7.1329500622.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/12 04:50, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> For the RTT as RTC driver rtc-at91sam9, the platform_device structure
> is filled during SoC initialization. This will allow to convert this
> RTC driver as a standard platform driver.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9260_devices.c |   11 +++++
>  arch/arm/mach-at91/at91sam9261_devices.c |   10 +++++
>  arch/arm/mach-at91/at91sam9263_devices.c |   25 ++++++++++++
>  arch/arm/mach-at91/at91sam9g45_devices.c |   10 +++++
>  arch/arm/mach-at91/at91sam9rl_devices.c  |   10 +++++
>  drivers/rtc/rtc-at91sam9.c               |   61 ++++-------------------------
>  6 files changed, 75 insertions(+), 52 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index b93a337..2071017 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -728,8 +728,19 @@ static struct platform_device at91sam9260_rtt_device = {
>  	.num_resources	= ARRAY_SIZE(rtt_resources),
>  };
>  
> +
> +#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	at91sam9260_rtt_device.name = "rtc-at91sam9";
> +}


Nitpickish: This function doesn't _add_ anything. It would probably be
better called at91_init_device_rtt_rtc. Same goes for the other "add"
functions in this patch.

> +#else
> +static void __init at91_add_device_rtt_rtc(void) {}
> +#endif
> +
>  static void __init at91_add_device_rtt(void)
>  {
> +	at91_add_device_rtt_rtc();
>  	platform_device_register(&at91sam9260_rtt_device);
>  }


Does this work by setting the rtt device name iff
CONFIG_RTC_DRV_AT91SAM9 is set? If so, it seems a bit ugly. Why bother
doing the platform_device_register at all if you know it isn't going to
do anything? Shouldn't the at91sam9260_rrt_device struct declaration and
the platform_device_register all be conditional on CONFIG_RTC_DRV_AT91SAM9?

~Ryan


