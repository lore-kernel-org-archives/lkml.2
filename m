Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1BOQxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:53:45 -0500
Received: from mailb.microsoft.com ([131.107.115.215]:41517 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1BOQxn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:53:43 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: RE: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzSITk3u3GOCeg0WgYewl8DvZjZQDPp0A//+A0dA=
Date: Tue, 15 Feb 2011 16:53:41 +0000
Message-ID: <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
In-Reply-To: <20110215155954.GA32313@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Tuesday, February 15, 2011 11:00 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org; Haiyang Zhang; Hank Janssen
> Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
> 
> On Tue, Feb 15, 2011 at 07:15:37AM -0800, K. Y. Srinivasan wrote:
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> >
> > ---
> >  drivers/staging/hv/vmbus_drv.c |   49 +++++++++++++++++++++++++++------
> ------
> >  1 files changed, 34 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> > index 459c707..f279e6a 100644
> > --- a/drivers/staging/hv/vmbus_drv.c
> > +++ b/drivers/staging/hv/vmbus_drv.c
> > @@ -36,9 +36,7 @@
> >  #include "vmbus_private.h"
> >
> >
> > -/* FIXME! We need to do this dynamically for PIC and APIC system */
> > -#define VMBUS_IRQ		0x5
> > -#define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
> > +static int vmbus_irq;
> >
> >  /* Main vmbus driver data structure */
> >  struct vmbus_driver_context {
> > @@ -57,6 +55,25 @@ struct vmbus_driver_context {
> >  	struct vm_device device_ctx;
> >  };
> >
> > +/*
> > + * Find an un-used IRQ that the VMBUS can use. If none is available; return -1.
> > + */
> > +
> > +static int vmbus_get_irq(void)
> 
> No extra blank line between function comment and function.

I will take care of this.
> 
> > +{
> > +	unsigned int avail_irq_mask;
> > +	int irq = -1;
> > +	/*
> 
> Put an extra blank line after your variables please.

Will do.
> 
> > +	 * Pick the first unused interrupt. HyperV can
> > +	 * interrupt us on any interrupt line we specify.
> > +	 */
> > +	avail_irq_mask = probe_irq_on();
> > +	if (avail_irq_mask != 0)
> > +		irq = ffs(avail_irq_mask);
> > +	probe_irq_off(avail_irq_mask);
> > +	return irq;
> > +}
> > +
> >  static int vmbus_match(struct device *device, struct device_driver *driver);
> >  static int vmbus_probe(struct device *device);
> >  static int vmbus_remove(struct device *device);
> > @@ -80,7 +97,6 @@ EXPORT_SYMBOL(vmbus_loglevel);
> >  	/* (ALL_MODULES << 16 | DEBUG_LVL_ENTEREXIT); */
> >  	/* (((VMBUS | VMBUS_DRV)<<16) | DEBUG_LVL_ENTEREXIT); */
> >
> > -static int vmbus_irq = VMBUS_IRQ;
> >
> >  /* Set up per device attributes in /sys/bus/vmbus/devices/<bus device> */
> >  static struct device_attribute vmbus_device_attrs[] = {
> > @@ -466,7 +482,7 @@ static int vmbus_bus_init(void)
> >  	struct hv_driver *driver = &vmbus_drv.drv_obj;
> >  	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
> >  	int ret;
> > -	unsigned int vector;
> > +	unsigned int vector, prev_irq = ~0;
> >
> >  	DPRINT_INFO(VMBUS, "+++++++ HV Driver version = %s +++++++",
> >  		    HV_DRV_VERSION);
> > @@ -518,19 +534,23 @@ static int vmbus_bus_init(void)
> >  	}
> >
> >  	/* Get the interrupt resource */
> > -	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> > -			  driver->name, NULL);
> > -
> > -	if (ret != 0) {
> > -		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
> > -			   vmbus_irq);
> > -
> > +get_irq_again:
> > +	vmbus_irq = vmbus_get_irq();
> > +	if ((vmbus_irq < 0) || (prev_irq == vmbus_irq)) {
> > +		printk(KERN_WARNING "VMBUS_DRV: Failed to allocate IRQ\n");
> >  		bus_unregister(&vmbus_drv_ctx->bus);
> > -
> >  		ret = -1;
> 
> Please provide a "real" error code.

Will do.
> 
> >  		goto cleanup;
> >  	}
> > -	vector = VMBUS_IRQ_VECTOR;
> > +	prev_irq = vmbus_irq;
> > +
> > +	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> > +			  driver->name, NULL);
> > +
> > +	if (ret != 0)
> > +		goto get_irq_again;
> 
> You just set up the potential for an endless loop.  You almost _never_
> want to goto backwards in a function.  Please don't do this.

The loop is not endless. We need to take care of two conditions here:
1) From the point we selected an irq line to the point where we call
request_irq(), it is possible that someone else could have requested
the same line and so we need to close this window.
2) request_irq() may fail for reasons other than the fact that we
may have lost the line that we thought we got.

So, while we loopback, we check to see if the irq line we got is the same 
that we got before (refer to the check soon after the call
to vmbus_get_irq()). This check would ensure that we would not loop
endlessly.

> 
> > +
> > +	vector = IRQ0_VECTOR + vmbus_irq;
> 
> What's this for?
This is what gets passed to the hypervisor - refer to vmbus_dev_add(). 
This is existing code.
> 
> >  	DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);
> 
> And why are you still printing this out for the whole world to see?
Greg, this patch addressed a specific comment with regards dynamically allocate the irq. 
Hank is working on a patch to address the various DPRINTS in the code.

Regards,

K. Y
> 
> thanks,
> 
> greg k-h

