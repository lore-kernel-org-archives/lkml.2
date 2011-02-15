Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1BOR1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:27:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:50331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1BOR1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:27:07 -0500
Date: Tue, 15 Feb 2011 09:25:00 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH ]:Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110215172500.GC18437@suse.de>
References: <1297782937-24082-1-git-send-email-kys@microsoft.com>
 <20110215155954.GA32313@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E07085DA1@TK5EX14MBXC104.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 04:53:41PM +0000, KY Srinivasan wrote:
> > > @@ -518,19 +534,23 @@ static int vmbus_bus_init(void)
> > >  	}
> > >
> > >  	/* Get the interrupt resource */
> > > -	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> > > -			  driver->name, NULL);
> > > -
> > > -	if (ret != 0) {
> > > -		DPRINT_ERR(VMBUS_DRV, "ERROR - Unable to request IRQ %d",
> > > -			   vmbus_irq);
> > > -
> > > +get_irq_again:
> > > +	vmbus_irq = vmbus_get_irq();
> > > +	if ((vmbus_irq < 0) || (prev_irq == vmbus_irq)) {
> > > +		printk(KERN_WARNING "VMBUS_DRV: Failed to allocate IRQ\n");
> > >  		bus_unregister(&vmbus_drv_ctx->bus);
> > > -
> > >  		ret = -1;
> > 
> > Please provide a "real" error code.
> 
> Will do.
> > 
> > >  		goto cleanup;
> > >  	}
> > > -	vector = VMBUS_IRQ_VECTOR;
> > > +	prev_irq = vmbus_irq;
> > > +
> > > +	ret = request_irq(vmbus_irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
> > > +			  driver->name, NULL);
> > > +
> > > +	if (ret != 0)
> > > +		goto get_irq_again;
> > 
> > You just set up the potential for an endless loop.  You almost _never_
> > want to goto backwards in a function.  Please don't do this.
> 
> The loop is not endless. We need to take care of two conditions here:
> 1) From the point we selected an irq line to the point where we call
> request_irq(), it is possible that someone else could have requested
> the same line and so we need to close this window.
> 2) request_irq() may fail for reasons other than the fact that we
> may have lost the line that we thought we got.
> 
> So, while we loopback, we check to see if the irq line we got is the same 
> that we got before (refer to the check soon after the call
> to vmbus_get_irq()). This check would ensure that we would not loop
> endlessly.

That's very subtle, and easy to overlook.  So please don't do it.  Make
it obvious that you will not constantly loop, and again, don't call goto
backwards.  goto is for error handling only, unless you are writing
scheduler code, and you aren't doing that here.

Please rework your logic before resending this.

thanks,

greg k-h
