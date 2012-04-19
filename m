Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab2DSPiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:38:16 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:49128 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2DSPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:38:14 -0400
Date: Thu, 19 Apr 2012 11:33:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        konrad <konrad@localhost.localdomain>
Subject: Re: [PATCH] xen/xenbus: Add quirk to deal with misconfigured
 backends.
Message-ID: <20120419153306.GA2814@phenom.dumpdata.com>
References: <1334773144-2394-1-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.00.1204191232590.26786@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204191232590.26786@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F90315F.00A8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 12:37:42PM +0100, Stefano Stabellini wrote:
> On Wed, 18 Apr 2012, Konrad Rzeszutek Wilk wrote:
> > From: konrad <konrad@localhost.localdomain>
> 
> wrong email address

Yeah :-)
> 
> 
> > A rather annoying and common case is when booting a PVonHVM guest
> > and exposing the PV KBD and PV VFB - as both of those do not
> > make any sense.
> 
> I would rather write: "as broken toolstacks don't always initialize the
> backends correctly."

OK.
> 
> 
> > The HVM guest is using the VGA driver and the emulated
> > keyboard for this. So we provide a very basic quirk framework
> > (can be expanded in the future) to not wait for 6 minutes for those devices
> > to initialize - they never wont.
> > 
> > To trigger this, put this in your guest config:
> > 
> > vfb = [ 'vnc=1, vnclisten=0.0.0.0 ,vncunused=1']
> > 
> > instead of this:
> > vnc=1
> > vnclisten="0.0.0.0"
> > 
> > [v3: Split delay in non-essential (30 seconds) and essential
> >  devices per Ian and Stefano suggestion]
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>quirk
> > ---
> >  drivers/xen/xenbus/xenbus_probe_frontend.c |   69 +++++++++++++++++++++------
> >  1 files changed, 53 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
> > index f20c5f1..7422913 100644
> > --- a/drivers/xen/xenbus/xenbus_probe_frontend.c
> > +++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
> > @@ -135,7 +135,7 @@ static int read_backend_details(struct xenbus_device *xendev)
> >  	return xenbus_read_otherend_details(xendev, "backend-id", "backend");
> >  }
> >  
> > -static int is_device_connecting(struct device *dev, void *data)
> > +static int is_device_connecting(struct device *dev, void *data, bool ignore_vkbd)
> >  {
> >  	struct xenbus_device *xendev = to_xenbus_device(dev);
> >  	struct device_driver *drv = data;
> > @@ -152,16 +152,41 @@ static int is_device_connecting(struct device *dev, void *data)
> >  	if (drv && (dev->driver != drv))
> >  		return 0;
> >  
> > +	if (ignore_vkbd) {
> 
> I would name the parameter ignore_nonessential, just to make it clearer
> that is not just about vkbd

OK.
> 
> 
> > +		/* With older QEMU, for PVonHVM guests the guest config files
> > +		 * could contain: vfb = [ 'vnc=1, vnclisten=0.0.0.0']
> > +		 * which is nonsensical as there is no PV FB (there can be
> > +		 * a PVKB) running as HVM guest. */
> > +
> > +		if ((strncmp(xendev->nodename, "device/vkbd", 11) == 0))
> > +			return 0;
> > +
> > +		if ((strncmp(xendev->nodename, "device/vfb", 10) == 0))
> > +			return 0;
> > +	}
> >  	xendrv = to_xenbus_driver(dev->driver);
> >  	return (xendev->state < XenbusStateConnected ||
> >  		(xendev->state == XenbusStateConnected &&
> >  		 xendrv->is_ready && !xendrv->is_ready(xendev)));
> >  }
> > +static int essential_device_connecting(struct device *dev, void *data)
> > +{
> > +	return is_device_connecting(dev, data, true /* ignore PVKB+PVDB */);
> > +}
> 
> the comment is wrong

Oh, PVKBD + PVFB. Right.

> 
> 
> > +static int non_essential_device_connecting(struct device *dev, void *data)
> > +{
> > +	return is_device_connecting(dev, data, false);
> > +}
> >  
> > -static int exists_connecting_device(struct device_driver *drv)
> > +static int exists_essential_connecting_device(struct device_driver *drv)
> >  {
> >  	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
> > -				is_device_connecting);
> > +				essential_device_connecting);
> > +}
> > +static int exists_non_essential_connecting_device(struct device_driver *drv)
> > +{
> > +	return bus_for_each_dev(&xenbus_frontend.bus, NULL, drv,
> > +				non_essential_device_connecting);
> >  }
> >  
> >  static int print_device_status(struct device *dev, void *data)
> > @@ -192,6 +217,23 @@ static int print_device_status(struct device *dev, void *data)
> >  /* We only wait for device setup after most initcalls have run. */
> >  static int ready_to_wait_for_devices;
> >  
> > +static bool wait_loop(unsigned long start, unsigned int max_delay,
> > +		     unsigned int *seconds_waited)
> > +{
> > +	if (time_after(jiffies, start + (*seconds_waited+5)*HZ)) {
> > +		if (!*seconds_waited)
> > +			printk(KERN_WARNING "XENBUS: Waiting for "
> > +			       "devices to initialise: ");
> > +		*seconds_waited += 5;
> > +		printk("%us...", max_delay - *seconds_waited);
> > +		if (*seconds_waited == max_delay)
> > +			return true;
> > +	}
> > +
> > +	schedule_timeout_interruptible(HZ/10);
> > +
> > +	return false;
> > +}
> >  /*
> >   * On a 5-minute timeout, wait for all devices currently configured.  We need
> >   * to do this to guarantee that the filesystems and / or network devices
> > @@ -215,19 +257,14 @@ static void wait_for_devices(struct xenbus_driver *xendrv)
> >  	if (!ready_to_wait_for_devices || !xen_domain())
> >  		return;
> >  
> > -	while (exists_connecting_device(drv)) {
> > -		if (time_after(jiffies, start + (seconds_waited+5)*HZ)) {
> > -			if (!seconds_waited)
> > -				printk(KERN_WARNING "XENBUS: Waiting for "
> > -				       "devices to initialise: ");
> > -			seconds_waited += 5;
> > -			printk("%us...", 300 - seconds_waited);
> > -			if (seconds_waited == 300)
> > -				break;
> > -		}
> > -
> > -		schedule_timeout_interruptible(HZ/10);
> > -	}
> > +	while (exists_non_essential_connecting_device(drv))
> > +		if (wait_loop(start, 30, &seconds_waited))
> > +			break;
> > +
> > +	/* Skips PVKB and PVFB check.*/
> > +	while (exists_essential_connecting_device(drv))
> > +		if (wait_loop(start, 270, &seconds_waited))
> > +			break;
> >  
> >  	if (seconds_waited)
> >  		printk("\n");
> > -- 
> > 1.7.7.5
> > 
> 
> Other than the comments I wrote above, I think the patch is good

Sweet. thx!
