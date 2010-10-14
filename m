Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0JNRgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:36:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65102 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab0JNRgx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Oct 2010 13:36:53 -0400
Date: Thu, 14 Oct 2010 13:35:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, Ryan Wilson <hap9@darnok.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 20/23] xen-pcifront: Xen PCI frontend
 driver.
Message-ID: <20101014173536.GA7312@dumpdata.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
 <1286898271-32018-21-git-send-email-konrad.wilk@oracle.com>
 <4CB599DB020000780001CC60@vpn.id2.novell.com>
 <201010130953.45283.konrad@darnok.org>
 <20101013161636.GA19872@dumpdata.com>
 <4CB6CA1A020000780001D161@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB6CA1A020000780001D161@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 08:15:06AM +0100, Jan Beulich wrote:
> >>> On 13.10.10 at 18:16, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Wed, Oct 13, 2010 at 09:53:44AM -0400, Konrad Rzeszutek Wilk wrote:
> >> Hey Jan,
> >> 
> >> Thank you for taking your time to look at this patch. Will fix up, test it, 
> >> and if there are no issues, have it ready tomorrow.
> > 
> > Attached (and inline) is the updated version of this patch. If I missed 
> > anything
> > please do point it out to me!
> 
> There's one more missing "static", and one incorrect change to
> free_pdev() you did.

Fixed.
> 
> Also, any word on the pdev_lock you dropped from the original
> implementation?

Yes. The reason for dropping it was that the xenwatch thread provides
the neccessary locking for the states. So no more need for this
spin_lock.

> 
> > If this is to your satisfaction, can I put a Reviewed-by tag on the patch?
> 
> Feel free to do so.

Thank you.
> 
> > --- /dev/null
> > +++ b/drivers/pci/xen-pcifront.c
> >...
> > +int __devinit pcifront_scan_bus(struct pcifront_device *pdev,
> 
> static?

Yup, done.
> 
> >...
> > +static void free_pdev(struct pcifront_device *pdev)
> > +{
> > +	dev_dbg(&pdev->xdev->dev, "freeing pdev @ 0x%p\n", pdev);
> > +
> > +	pcifront_free_roots(pdev);
> > +
> > +	/*For PCIE_AER error handling job*/
> > +	flush_scheduled_work();
> > +
> > +	if (pdev->irq)
> 
> 	if (pdev->irq > 0)
> 
> It gets initialized to -1 in alloc_pdev(). It may be debatable whether
> it should be >= 0 - I'm not sure if the pv-ops code allows IRQ 0 to
> be used. If it doesn't, initializing to 0 in alloc_pdev() would be an
> alternative.

I made it '>=' The Xen PCI (arch/x86/pci/xen.c) and Xen Events (riers/xen/events.c)
are both OK with an IRQ of zero. So lets be uniform and be OK here too.

> 
> > +		unbind_from_irqhandler(pdev->irq, pdev);
> > +
> > +	if (pdev->evtchn != INVALID_EVTCHN)
> > +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
> > +
> > +	if (pdev->gnt_ref != INVALID_GRANT_REF)
> > +		gnttab_end_foreign_access(pdev->gnt_ref, 0 /* r/w page */,
> > +					  (unsigned long)pdev->sh_info);
> > +	else
> > +		free_page((unsigned long)pdev->sh_info);
> > +
> > +	dev_set_drvdata(&pdev->xdev->dev, NULL);
> > +
> > +	kfree(pdev);
> > +}
> > +
> > +static int pcifront_publish_info(struct pcifront_device *pdev)
> > +{
> > +	int err = 0;
> > +	struct xenbus_transaction trans;
> > +
> > +	err = xenbus_grant_ring(pdev->xdev, virt_to_mfn(pdev->sh_info));
> > +	if (err < 0)
> > +		goto out;
> > +
> > +	pdev->gnt_ref = err;
> > +
> > +	err = xenbus_alloc_evtchn(pdev->xdev, &pdev->evtchn);
> > +	if (err)
> > +		goto out;
> > +
> > +	err = bind_evtchn_to_irqhandler(pdev->evtchn, pcifront_handler_aer,
> > +		0, "pcifront", pdev);
> > +	if (err < 0) {
> > +		/*
> > +		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
> > +		xenbus_dev_fatal(pdev->xdev, err, "Failed to bind evtchn to "
> > +				 "irqhandler.\n");
> > +		*/
> 
> Why are you commenting it out rather than removing it?

Umm. I was in a hurry to test it out and just in case it would fail I
made it a comment. And then forgot about it. Removed that comented out
section of code.
> 
> Jan
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
