Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab2JKAo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:44:29 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51948 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757647Ab2JKAoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:44:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/FF/mSA2YOWFUjF+X100+r
Date: Wed, 10 Oct 2012 17:44:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux@arm.linux.org.uk, b-cousson@ti.com, arnd@arndb.de, olof@lixom.net,
        rdunlap@xenotime.net, balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: OMAP4: add _dev_attr_ to ocp2scp for
 representing usb_phy
Message-ID: <20121011004413.GW12552@atomide.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349675983-23803-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> In order to reflect devices(usb_phy) attached to ocp2scp bus, ocp2scp
> is assigned a device attribute to represent the attached devices.
...

> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -21,6 +21,7 @@
>  #include <linux/io.h>
>  #include <linux/platform_data/gpio-omap.h>
>  #include <linux/power/smartreflex.h>
> +#include <linux/platform_data/omap_ocp2scp.h>
>  
>  #include <plat/omap_hwmod.h>
>  #include <plat/i2c.h>
> @@ -2681,6 +2682,32 @@ static struct omap_hwmod_class omap44xx_ocp2scp_hwmod_class = {
>  	.sysc	= &omap44xx_ocp2scp_sysc,
>  };
>  
> +/* ocp2scp dev_attr */
> +static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
> +	{
> +		.name		= "usb_phy",
> +		.start		= 0x4a0ad080,
> +		.end		= 0x4a0ae000,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{
> +		/* XXX: Remove this once control module driver is in place */
> +		.name		= "ctrl_dev",
> +		.start		= 0x4a002300,
> +		.end		= 0x4a002303,
> +		.flags		= IORESOURCE_MEM,
> +	},
> +	{ }
> +};

Why don't you set the CONTROL_DEV_CONF as a fixed regulator?

That way you can define the fixed regulator in mach-omap2/control.c
and the driver can just pick it up by name.

The 4470 TRM says that this register "power down entire USB
PHY" and "controls USB2PHYCORE.PD pin".

That way you can also get rid of the mysterious mdelay(200)
in omap_usb_phy_power() in omap-usb2.c driver.

However one thing needs to be checked first.

If CONTROL_DEV_CONF is not a regulator but is a signal mux,
then you can map the register with mux framework using the
pinctrl-single. See the pinctrl-single,bits binding that
was recently merged to mainline.

In the mux case you can set up the named states "default" and
"disabled" that the PHY driver can then manipulate with
pinctrl_select_state().

Note that for the mux case we don't have a non-device tree
pinctrl framework solution available, so you're probably
better off setting it up as a fixed regulator with comments
in case it really is a mux.

BTW, the reason I'm thinking CONTROL_DEV_CONF may be a mux
is because omap3 has registers named CONTROL_DEVCONF0 and
CONTROL_DEVCONF1 that mux signals for various devices.
But maybe that naming is just a coincidence.

Regards,

Tony
