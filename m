Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2BTAnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:43:52 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37566 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab2BTAnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:43:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.226.231 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F419742.70200@gmail.com>
Date: Mon, 20 Feb 2012 11:43:46 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] ARM: at91/rtc-at91sam9: pass the GPBR to use via
 ressources
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <8187feb330895bf9e077ede21e68cc81a72438cc.1329500622.git.nicolas.ferre@atmel.com>
In-Reply-To: <8187feb330895bf9e077ede21e68cc81a72438cc.1329500622.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/02/12 04:50, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> The GPBR registers are used for storing RTC values. The GPBR registers
> to use are now provided using standard resource entry. The array is
> filled in SoC specific code.
> rtc-at91sam9 RTT as RTC driver is modified to retrieve this information.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9260_devices.c      |   10 +++++++-
>  arch/arm/mach-at91/at91sam9261_devices.c      |    8 ++++++-
>  arch/arm/mach-at91/at91sam9263_devices.c      |   16 +++++++++++--
>  arch/arm/mach-at91/at91sam9g45_devices.c      |    8 ++++++-
>  arch/arm/mach-at91/at91sam9rl_devices.c       |    8 ++++++-
>  arch/arm/mach-at91/include/mach/at91sam9260.h |    5 +--
>  arch/arm/mach-at91/include/mach/at91sam9261.h |    5 +--
>  arch/arm/mach-at91/include/mach/at91sam9263.h |    5 +--
>  arch/arm/mach-at91/include/mach/at91sam9g45.h |    5 +--
>  arch/arm/mach-at91/include/mach/at91sam9rl.h  |    2 +-
>  drivers/rtc/rtc-at91sam9.c                    |   29 +++++++++++++++++++++---
>  11 files changed, 76 insertions(+), 25 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> index 2071017..ae2b648 100644
> --- a/arch/arm/mach-at91/at91sam9260_devices.c
> +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> @@ -718,14 +718,16 @@ static struct resource rtt_resources[] = {
>  		.start	= AT91SAM9260_BASE_RTT,
>  		.end	= AT91SAM9260_BASE_RTT + SZ_16 - 1,
>  		.flags	= IORESOURCE_MEM,
> -	}
> +	}, {
> +		.flags	= IORESOURCE_MEM,
> +	},
>  };
>  
>  static struct platform_device at91sam9260_rtt_device = {
>  	.name		= "at91_rtt",
>  	.id		= 0,
>  	.resource	= rtt_resources,
> -	.num_resources	= ARRAY_SIZE(rtt_resources),
> +	.num_resources	= 1,


Why this change? The device has two resources, and the rtc driver
request both of them, so why are you saying there is only one resource
here. It either needs to be changed back to use ARRAY_SIZE, or needs a
comment explaining what magic is in use.

<snip>

>  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
>  static void __init at91_add_device_rtt_rtc(void)
>  {
>  	struct platform_device *pdev;
> +	struct resource *r;
>  
>  	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
>  	case 0:
>  		pdev = &at91sam9263_rtt0_device;
> +		r = rtt0_resources;
>  		break;
>  	case 1:
>  		pdev = &at91sam9263_rtt1_device;
> +		r = rtt1_resources;
>  		break;
>  	default:
>  		pr_err("at91sam9263: support only 2 RTT (%d)\n",
> -			 CONFIG_RTC_DRV_AT91SAM9_RTT);
> +		       CONFIG_RTC_DRV_AT91SAM9_RTT);
>  		return;
>  	}

>  
> +	r[1].start = AT91SAM9263_BASE_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
> +	r[1].end = r[1].start + 3;
>  	pdev->name = "rtc-at91sam9";
> +	pdev->num_resources++;


Okay, makes a little more sense now. I really think it needs a comment
explaining how the resources are being managed, since it is a bit
non-obvious.

Also, can only one of the RTT's can be used as an RTC at a time?

~Ryan
