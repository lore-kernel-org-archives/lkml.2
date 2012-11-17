Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2KQBWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 20:22:38 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:18965 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651Ab2KQBWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 20:22:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wGHm6Dhq5wo5Xj5ouIGSE
Date: Fri, 16 Nov 2012 17:22:32 -0800
From: Tony Lindgren <tony@atomide.com>
To: oleg.matcovschi@ti.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP2+: mux: Fixed gpio mux mode analysis.
Message-ID: <20121117012231.GQ6801@atomide.com>
References: <1353015597-22703-1-git-send-email-oleg.matcovschi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353015597-22703-1-git-send-email-oleg.matcovschi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* oleg.matcovschi@ti.com <oleg.matcovschi@ti.com> [121115 13:42]:
> From: Oleg Matcovschi <oleg.matcovschi@ti.com>
> 
> OMAP_MODE_GPIO() macro verified only OMAP_MUX_MODE4.

Indeed, that needs to be fixed.

> It is not correct for following platforms:
>     2430 - gpio mux mode 3
>     44xx - gpio mux mode 3

Looks like these are set properly to GPIO_IN_MODE3 with
omap_mux_init().

>     54xx - gpio mux mode 6

This will be only using pinctrl-single.c, so we don't
really have to worrry about this one. But I guess we might
as well fix that too while at it if somebody backports omap5
support to some older kernel..
 
> Patch reserves first 3 bits in partition flags for storing gpio mux
> mode in same format as stored in control pad register.
> Modified OMAP_MODE_GPIO() macro handles all possible cases of gpio mux mode.
> Modified omap_mux_init() flags of omap34xx to include OMAP_MUX_GPIO_IN_MODE4.

Why don't you just add int gpio to struct omap_mux_partition?

You're not saving many bytes as at most we have two partitions
so far per SoC.
 
> --- a/arch/arm/mach-omap2/mux34xx.c
> +++ b/arch/arm/mach-omap2/mux34xx.c
> @@ -2053,7 +2053,7 @@ int __init omap3_mux_init(struct omap_board_mux *board_subset, int flags)
>  		return -EINVAL;
>  	}
>  
> -	return omap_mux_init("core", 0,
> +	return omap_mux_init("core", OMAP_MUX_GPIO_IN_MODE4,
>  			     OMAP3_CONTROL_PADCONF_MUX_PBASE,
>  			     OMAP3_CONTROL_PADCONF_MUX_SIZE,
>  			     omap3_muxmodes, package_subset, board_subset,

The default is GPIO_IN_MODE4, but that seems to be a bad
default choice as only omap3 uses it. So yeah, might as well
initialize that too and not assume any defaults GPIO mode.

Regards,

Tony
