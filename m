Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0L3I7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:59:44 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58378 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0L3I7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:59:43 -0500
Date: Thu, 30 Dec 2010 01:59:40 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH 13/15] x86/rtc: don't register rtc if we have an OF
 node for it
Message-ID: <20101230085940.GG11721@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-14-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292600033-12271-14-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:33:51PM +0100, Sebastian Andrzej Siewior wrote:
> or we end up with two of those things.

More generically, rather than searching for an rtc node, I imagine
simply the presence of a device tree blob means that the rtc
registration should be suppressed.

g.

> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kernel/rtc.c |   23 +++++++++++++++++++++++
>  1 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 1cfbbfc..382c6cb 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -6,6 +6,7 @@
>  #include <linux/acpi.h>
>  #include <linux/bcd.h>
>  #include <linux/pnp.h>
> +#include <linux/of.h>
>  
>  #include <asm/vsyscall.h>
>  #include <asm/x86_init.h>
> @@ -218,6 +219,25 @@ static struct platform_device rtc_device = {
>  	.num_resources	= ARRAY_SIZE(rtc_resources),
>  };
>  
> +#ifdef CONFIG_OF
> +static __init int have_rtc_of_node(void)
> +{
> +	struct device_node *n;
> +
> +	n = of_find_compatible_node(NULL, NULL, "motorola,mc146818");
> +	if (n) {
> +		of_node_put(n);
> +		return 1;
> +	}
> +	return 0;
> +}
> +#else
> +static inline int have_rtc_of_node(void)
> +{
> +	return 0;
> +}
> +#endif
> +
>  static __init int add_rtc_cmos(void)
>  {
>  #ifdef CONFIG_PNP
> @@ -237,6 +257,9 @@ static __init int add_rtc_cmos(void)
>  	}
>  #endif
>  
> +	if (have_rtc_of_node())
> +		return 0;
> +
>  	platform_device_register(&rtc_device);
>  	dev_info(&rtc_device.dev,
>  		 "registered platform RTC device (no PNP device found)\n");
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
