Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab2C2LPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:15:01 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:51978 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2C2LOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:14:54 -0400
X-IronPort-AV: E=Sophos;i="4.75,337,1330905600"; 
   d="scan'208";a="11638535"
Date: Thu, 29 Mar 2012 12:16:11 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen/xenbus: Add quirk to deal with misconfigured
 backends.
In-Reply-To: <20120328194540.GA11825@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1203291210540.15151@kaball-desktop>
References: <1332385189-29029-1-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1203221040030.15151@kaball-desktop> <1332413546.8817.64.camel@zakaz.uk.xensource.com> <20120322132102.GA22545@phenom.dumpdata.com> <alpine.DEB.2.00.1203221511380.15151@kaball-desktop>
 <20120328194540.GA11825@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012, Konrad Rzeszutek Wilk wrote:
> Please take a look:
> 
> >From 85c9c09c69e3b4a277b2c930ca0a295f5bacc696 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 28 Mar 2012 14:55:45 -0400
> Subject: [PATCH] xen/xenbus: Add quirk to deal with misconfigured backends.
> 
> A rather annoying and common case is when booting a PVonHVM guest
> and exposing the PV KBD and PV VFB - as both of those do not
> make any sense. The HVM guest is using the VGA driver and the emulated
> keyboard for this (in Xen 4.2 and lower). We provide a very basic quirk
> framework to not wait for 6 minutes for those devices to initialize.
> 
> To trigger this, put this in your guest config:
> 
> vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> 
> instead of this:
> vnc=1
> vnclisten="0.0.0.0"
> 
> Note: The upstream QEMU can do PV KBD, so we can't just outright ignore
> the keyboard driver. Instead we change the timeout for that particular
> device to be much less.
> 
> [v1: Redo with timeout per Ian and Stefano suggestion]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/xenbus/xenbus_probe_frontend.c |   39 ++++++++++++++++++++++++++-
>  1 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
> index f20c5f1..09da9cf 100644
> --- a/drivers/xen/xenbus/xenbus_probe_frontend.c
> +++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
> @@ -157,7 +157,40 @@ static int is_device_connecting(struct device *dev, void *data)
>  		(xendev->state == XenbusStateConnected &&
>  		 xendrv->is_ready && !xendrv->is_ready(xendev)));
>  }
> +static int check_for_quirks(struct device *dev, void *data)
> +{
> +	struct xenbus_device *xendev = to_xenbus_device(dev);
> +	struct device_driver *drv = data;
> +
> +	/* Is this operation limited to a particular driver? */
> +	if (drv && (dev->driver != drv))
> +		return false;
> +
> +	if (xen_pv_domain())
> +		return false;
>  
> +	/* With older QEMU, for PVonHVM guests the guest config files could
> +	 * contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> +	 * which is nonsensical as there is no PV FB (or PV KBD) when
> +	 * running as HVM guest - at least with Xen 4.1 and Xen 4.2. */
> +
> +	if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
> +		return true;
> +
> +	if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
> +		return true;
> +
> +	return false;
> +}
> +#define QUIRKS_TIMEOUT		30
> +#define DEFAULT_TIMEOUT		300
> +static unsigned int check_for_timeout_quirks(struct device_driver *drv, unsigned int timeout)
> +{
> +	if (bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
> +				check_for_quirks))
> +		return QUIRKS_TIMEOUT;
> +	return timeout;
> +}
>  static int exists_connecting_device(struct device_driver *drv)
>  {
>  	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
> @@ -211,18 +244,20 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
>  	unsigned long start = jiffies;
>  	struct device_driver *drv = xendrv ? &xendrv->driver : NULL;
>  	unsigned int seconds_waited = 0;
> +	unsigned int max_delay = DEFAULT_TIMEOUT;
>  
>  	if (!ready_to_wait_for_devices || !xen_domain())
>  		return;
>  
> +	max_delay = min(check_for_timeout_quirks(drv, max_delay), max_delay);
>  	while (exists_connecting_device(drv)) {
>  		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
>  			if (!seconds_waited)
>  				printk(KERN_WARNING "XENBUS: Waiting for "
>  				       "devices to initialise: ");
>  			seconds_waited += 5;
> -			printk("%us...", 300 - seconds_waited);
> -			if (seconds_waited == 300)
> +			printk("%us...", max_delay - seconds_waited);
> +			if (seconds_waited == max_delay)
>  				break;
>  		}

This patch would reduce the timeout to 30 in case the guest is PV on HVM
and vkbd and/or vfb are present.
It is an improvement over the current situation but it doesn't directly
address the fact that critical PV devices, like PV disk and network,
could be slow and we actually need to wait for them.  Could we just have
two wait loops, one for critical devices and one for non-critical
devices?
First, with a timeout of 300, we would wait for disk and network, then
we would checkout if everything else is connected. If some other PV
devices, like VFB/VKBD, are not yet connected, we could decide whether
to continue anyway or wait for them some more.
