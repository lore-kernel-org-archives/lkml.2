Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab2LMVuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:50:00 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:18247 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755851Ab2LMVt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:49:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ncD7rofWOA8jiPjKqatph
Date: Thu, 13 Dec 2012 13:49:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: sameo@linux.intel.com
Cc: balbi@ti.com, sameo@linux.intel.com, paul@pwsan.com, keshava_mgowda@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH v4 01/23] mfd: omap-usb-host: get rid of
 cpu_is_omap..() macros
Message-ID: <20121213214949.GH4989@atomide.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
 <1355134833-5199-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355134833-5199-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

* Roger Quadros <rogerq@ti.com> [121210 02:23]:
> Instead of using cpu_is_omap..() macros in the device driver we
> rely on information provided in the platform data.
> 
> The only information we need is whether the USB Host module has
> a single ULPI bypass control bit for all ports or individual bypass
> control bits for each port. OMAP3 REV2.1 and earlier have the former.

I'd like to apply this patch as a fix so I can finally nuke plat/cpu.h
for omaps by -rc1 before more drivers start using it again.

That is assuming nobody else is planning on merging this series for
v3.8 presumably. Want to ack this one?

Regards,

Tony


> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/usb-host.c         |    4 ++++
>  drivers/mfd/omap-usb-host.c            |    2 +-
>  include/linux/platform_data/usb-omap.h |    3 +++
>  3 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
> index d1dbe12..2e44e8a 100644
> --- a/arch/arm/mach-omap2/usb-host.c
> +++ b/arch/arm/mach-omap2/usb-host.c
> @@ -508,6 +508,10 @@ void __init usbhs_init(const struct usbhs_omap_board_data *pdata)
>  	if (cpu_is_omap34xx()) {
>  		setup_ehci_io_mux(pdata->port_mode);
>  		setup_ohci_io_mux(pdata->port_mode);
> +
> +		if (omap_rev() <= OMAP3430_REV_ES2_1)
> +			usbhs_data.single_ulpi_bypass = true;
> +
>  	} else if (cpu_is_omap44xx()) {
>  		setup_4430ehci_io_mux(pdata->port_mode);
>  		setup_4430ohci_io_mux(pdata->port_mode);
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index cebfe0a..fe7906b 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -384,7 +384,7 @@ static void omap_usbhs_init(struct device *dev)
>  			reg &= ~OMAP_UHH_HOSTCONFIG_P3_CONNECT_STATUS;
>  
>  		/* Bypass the TLL module for PHY mode operation */
> -		if (cpu_is_omap3430() && (omap_rev() <= OMAP3430_REV_ES2_1)) {
> +		if (pdata->single_ulpi_bypass) {
>  			dev_dbg(dev, "OMAP3 ES version <= ES2.1\n");
>  			if (is_ehci_phy_mode(pdata->port_mode[0]) ||
>  				is_ehci_phy_mode(pdata->port_mode[1]) ||
> diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
> index 8570bcf..ef65b67 100644
> --- a/include/linux/platform_data/usb-omap.h
> +++ b/include/linux/platform_data/usb-omap.h
> @@ -59,6 +59,9 @@ struct usbhs_omap_platform_data {
>  
>  	struct ehci_hcd_omap_platform_data	*ehci_data;
>  	struct ohci_hcd_omap_platform_data	*ohci_data;
> +
> +	/* OMAP3 <= ES2.1 have a single ulpi bypass control bit */
> +	unsigned				single_ulpi_bypass:1;
>  };
>  
>  /*-------------------------------------------------------------------------*/
> -- 
> 1.7.4.1
> 
