Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1ALACa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:02:30 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43530 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab1ALAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:02:28 -0500
Date: Tue, 11 Jan 2011 17:02:24 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 13/15] x86/rtc: don't register rtc if we the DT blob
Message-ID: <20110112000224.GI2131@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-14-git-send-email-bigeasy@linutronix.de>
 <20101230085940.GG11721@angua.secretlab.ca>
 <20110104132846.GC21359@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104132846.GC21359@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 02:28:46PM +0100, Sebastian Andrzej Siewior wrote:
> or we might end up with two device nodes for the same hardware.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/x86/kernel/rtc.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 1cfbbfc..0cfa138 100644
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
> @@ -218,6 +219,20 @@ static struct platform_device rtc_device = {
>  	.num_resources	= ARRAY_SIZE(rtc_resources),
>  };
>  
> +#ifdef CONFIG_OF
> +static __init int have_DTB(void)
> +{
> +	if (initial_boot_params)
> +		return 1;
> +	return 0;
> +}
> +#else
> +static inline int have_DTB(void)
> +{
> +	return 0;
> +}
> +#endif
> +

Not quite the right test.  For instance, OLPC has real openfirmware so
initial_boot_params will be zero even though there is a fully
populated device tree.  Should test the allnodes value instead.

Also, this test is useful to more than just rtc I'm sure.  It could
easily live in linux/of.h.

Finally one minor nit.  This is more verbose than it needs to be.  It
could instead be:  "return allnodes != NULL;", and the __init is
unnecessary on a static inline.

g.

>  static __init int add_rtc_cmos(void)
>  {
>  #ifdef CONFIG_PNP
> @@ -237,6 +252,9 @@ static __init int add_rtc_cmos(void)
>  	}
>  #endif
>  
> +	if (have_DTB())
> +		return 0;
> +
>  	platform_device_register(&rtc_device);
>  	dev_info(&rtc_device.dev,
>  		 "registered platform RTC device (no PNP device found)\n");
> -- 
> 1.7.3.2
> 
