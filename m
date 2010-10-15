Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0JOOav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:30:51 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60873 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab0JOOau convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:30:50 -0400
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing
 ioremap() on RAM
From: Catalin Marinas <catalin.marinas@arm.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>
In-Reply-To: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 15 Oct 2010 15:30:21 +0100
Message-ID: <1287153021.27165.6.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 15 Oct 2010 14:30:30.0189 (UTC) FILETIME=[849A9DD0:01CB6C75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Fri, 2010-10-15 at 15:15 +0100, Felipe Contreras wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Drivers have been relying on this behavior, but done so wrongly.
> However, rather than breaking drivers from .35 to .36, we should warn on
> .36 and only break on .37. This way we give a chance for contributors to
> fix the issues.
> 
> According to ARM, the behavior of having multiple mappings is
> unspecified from ARMv6+. This causes real issues specially on modern
> hardware, and specially with speculative prefetching. So drivers need to
> be fixed.
> 
> Also, since current hardware has palliative meassures to deal with
> multiple mappings with the same memory type but diferent cacheability
> attributes, ensure that such restriction is taking place.
> 
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Richard Woodruff <r-woodruff2@ti.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

I just showed a partial workaround but I did not sign off my patch. Not
sure if just posting a code snippet counts as an explicit signed-off-by.

> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -202,10 +202,14 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>                 return NULL;
> 
>         /*
> -        * Don't allow RAM to be mapped - this causes problems with ARMv6+
> +        * This causes problems with ARMv6+. Will be disallowed soon.
> +        * Also avoid a second mapping with different shareability, which is
> +        * not supposed to work anyway.
>          */
>         if (WARN_ON(pfn_valid(pfn)))
> -               return NULL;
> +               if (__LINUX_ARM_ARCH__ >= 6 &&
> +                   (mtype != MT_DEVICE_CACHED && mtype != MT_DEVICE_WC))
> +                       mtype = MT_DEVICE_WC;
> 
>         type = get_mem_type(mtype);
>         if (!type)

And one of the reasons is that this patch is incomplete. You still
create a mapping alias (though now with the same memory type and
different cacheability attributes) but there isn't anything to take care
of the potential dirty cache lines in the original alias (e.g. kernel
linear mapping). You can easily end up with data corruption.

-- 
Catalin

