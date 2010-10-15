Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0JOOXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:23:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47943 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0JOOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:23:13 -0400
Date: Fri, 15 Oct 2010 16:23:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing
	ioremap() on RAM
Message-ID: <20101015142310.GD16893@pengutronix.de>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 05:15:20PM +0300, Felipe Contreras wrote:
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
> ---
>  arch/arm/mm/ioremap.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index ab50627..7dfd6dd 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -202,10 +202,14 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  		return NULL;
>  
>  	/*
> -	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
> +	 * This causes problems with ARMv6+. Will be disallowed soon.
s/soon/for 2.6.37/ ?

> +	 * Also avoid a second mapping with different shareability, which is
> +	 * not supposed to work anyway.
>  	 */
>  	if (WARN_ON(pfn_valid(pfn)))
> -		return NULL;
> +		if (__LINUX_ARM_ARCH__ >= 6 &&
> +		    (mtype != MT_DEVICE_CACHED && mtype != MT_DEVICE_WC))
> +			mtype = MT_DEVICE_WC;
>  
>  	type = get_mem_type(mtype);
>  	if (!type)
> -- 
> 1.7.3.1.2.g7fe2b
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
