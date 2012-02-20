Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2BTPHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:07:20 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BTPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:07:19 -0500
Date: Mon, 20 Feb 2012 15:06:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: rmallon@gmail.com, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91/rtc-at91sam9: rework resources assignment
Message-ID: <20120220150648.GE26840@n2100.arm.linux.org.uk>
References: <20120220100437.GD22562@n2100.arm.linux.org.uk> <1329749142-6965-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329749142-6965-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 03:45:42PM +0100, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Russell, Ryan,
> 
> As I do think that these changes need explanation, here is my rework of Jean's
> patch. I would like to know if the little comment and general rework of
> resources assignment sound ok...

Nicolas, thanks for this.

This is way better by miles than Jean's patch, and shows how it should
have been done in the first place.

> I plan to merge this patch with the one discussed previously:
> "[PATCH 13/18] ARM: at91/rtc-at91sam9: pass the GPBR to use via ressources"
> 
> If you agree, I will repost the whole series afterwards.
> 
> 
>  arch/arm/mach-at91/at91sam9260_devices.c |   13 ++++++++++---
>  arch/arm/mach-at91/at91sam9261_devices.c |   13 ++++++++++---
>  arch/arm/mach-at91/at91sam9263_devices.c |   22 ++++++++++++++++------
>  arch/arm/mach-at91/at91sam9g45_devices.c |   13 ++++++++++---
>  arch/arm/mach-at91/at91sam9rl_devices.c  |   13 ++++++++++---
>  5 files changed, 56 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index f8a88fb..df487ce 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -727,7 +727,6 @@ static struct platform_device at91sam9260_rtt_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt_resources,
> -	.num_resources	= 1,
>  };
>  
>  
> @@ -735,13 +734,21 @@ static struct platform_device at91sam9260_rtt_device = {
>  static void __init at91_add_device_rtt_rtc(void)
>  {
>  	at91sam9260_rtt_device.name = "rtc-at91sam9";
> -	at91sam9260_rtt_device.num_resources++;
> +	/*
> +	 * The second resource is needed:
> +	 * GPBR will serve as the storage for RTC time offset
> +	 */
> +	at91sam9260_rtt_device.num_resources = 2;
>  	rtt_resources[1].start = AT91SAM9260_BASE_GPBR +
>  				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>  	rtt_resources[1].end = rtt_resources[1].start + 3;
>  }
>  #else
> -static void __init at91_add_device_rtt_rtc(void) {}
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	/* Only one resource is needed: RTT not used as RTC */
> +	at91sam9260_rtt_device.num_resources = 1;
> +}
>  #endif
>  
>  static void __init at91_add_device_rtt(void)
> diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
> index 32a20ef..3bd10ce 100644
> --- a/arch/arm/mach-at91/at91sam9261_devices.c
> +++ b/arch/arm/mach-at91/at91sam9261_devices.c
> @@ -613,20 +613,27 @@ static struct platform_device at91sam9261_rtt_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt_resources,
> -	.num_resources	= 1,
>  };
>  
>  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>  static void __init at91_add_device_rtt_rtc(void)
>  {
>  	at91sam9261_rtt_device.name = "rtc-at91sam9";
> -	at91sam9261_rtt_device.num_resources++;
> +	/*
> +	 * The second resource is needed:
> +	 * GPBR will serve as the storage for RTC time offset
> +	 */
> +	at91sam9261_rtt_device.num_resources = 2;
>  	rtt_resources[1].start = AT91SAM9261_BASE_GPBR +
>  				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>  	rtt_resources[1].end = rtt_resources[1].start + 3;
>  }
>  #else
> -static void __init at91_add_device_rtt_rtc(void) {}
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	/* Only one resource is needed: RTT not used as RTC */
> +	at91sam9261_rtt_device.num_resources = 1;
> +}
>  #endif
>  
>  static void __init at91_add_device_rtt(void)
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index 28cb074..7792de5 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -976,7 +976,6 @@ static struct platform_device at91sam9263_rtt0_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt0_resources,
> -	.num_resources	= 1,
>  };
>  
>  static struct resource rtt1_resources[] = {
> @@ -993,7 +992,6 @@ static struct platform_device at91sam9263_rtt1_device = {
>  	.name		= "at91_rtt",
>  	.id		= 1,
>  	.resource	= rtt1_resources,
> -	.num_resources	= 1,
>  };
>  
>  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> @@ -1004,26 +1002,38 @@ static void __init at91_add_device_rtt_rtc(void)
>  
>  	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
>  	case 0:
> +		/*
> +		 * The second resource is needed only for the chosen RTT:
> +		 * GPBR will serve as the storage for RTC time offset
> +		 */
> +		at91sam9263_rtt0_device.num_resources = 2;
> +		at91sam9263_rtt1_device.num_resources = 1;
>  		pdev = &at91sam9263_rtt0_device;
>  		r = rtt0_resources;
>  		break;
>  	case 1:
> +		at91sam9263_rtt0_device.num_resources = 1;
> +		at91sam9263_rtt1_device.num_resources = 2;
>  		pdev = &at91sam9263_rtt1_device;
>  		r = rtt1_resources;
>  		break;
>  	default:
> -		pr_err("at91sam9263: support only 2 RTT (%d)\n",
> +		pr_err("at91sam9263: only supports 2 RTT (%d)\n",
>  		       CONFIG_RTC_DRV_AT91SAM9_RTT);
>  		return;
>  	}
>  
> +	pdev->name = "rtc-at91sam9";
>  	r[1].start = AT91SAM9263_BASE_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>  	r[1].end = r[1].start + 3;
> -	pdev->name = "rtc-at91sam9";
> -	pdev->num_resources++;
>  }
>  #else
> -static void __init at91_add_device_rtt_rtc(void) {}
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	/* Only one resource is needed: RTT not used as RTC */
> +	at91sam9263_rtt0_device.num_resources = 1;
> +	at91sam9263_rtt1_device.num_resources = 1;
> +}
>  #endif
>  
>  static void __init at91_add_device_rtt(void)
> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index bb7e2ce..4108295 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -1203,20 +1203,27 @@ static struct platform_device at91sam9g45_rtt_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt_resources,
> -	.num_resources	= 1,
>  };
>  
>  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>  static void __init at91_add_device_rtt_rtc(void)
>  {
>  	at91sam9g45_rtt_device.name = "rtc-at91sam9";
> -	at91sam9g45_rtt_device.num_resources++;
> +	/*
> +	 * The second resource is needed:
> +	 * GPBR will serve as the storage for RTC time offset
> +	 */
> +	at91sam9g45_rtt_device.num_resources = 2;
>  	rtt_resources[1].start = AT91SAM9G45_BASE_GPBR +
>  				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>  	rtt_resources[1].end = rtt_resources[1].start + 3;
>  }
>  #else
> -static void __init at91_add_device_rtt_rtc(void) {}
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	/* Only one resource is needed: RTT not used as RTC */
> +	at91sam9g45_rtt_device.num_resources = 1;
> +}
>  #endif
>  
>  static void __init at91_add_device_rtt(void)
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> index 16fd20b..eda72e8 100644
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ b/arch/arm/mach-at91/at91sam9rl_devices.c
> @@ -692,20 +692,27 @@ static struct platform_device at91sam9rl_rtt_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt_resources,
> -	.num_resources	= 1,
>  };
>  
>  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>  static void __init at91_add_device_rtt_rtc(void)
>  {
>  	at91sam9rl_rtt_device.name = "rtc-at91sam9";
> -	at91sam9rl_rtt_device.num_resources++;
> +	/*
> +	 * The second resource is needed:
> +	 * GPBR will serve as the storage for RTC time offset
> +	 */
> +	at91sam9rl_rtt_device.num_resources = 2;
>  	rtt_resources[1].start = AT91SAM9RL_BASE_GPBR +
>  				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
>  	rtt_resources[1].end = rtt_resources[1].start + 3;
>  }
>  #else
> -static void __init at91_add_device_rtt_rtc(void) {}
> +static void __init at91_add_device_rtt_rtc(void)
> +{
> +	/* Only one resource is needed: RTT not used as RTC */
> +	at91sam9rl_rtt_device.num_resources = 1;
> +}
>  #endif
>  
>  static void __init at91_add_device_rtt(void)
> -- 
> 1.7.9
> 
