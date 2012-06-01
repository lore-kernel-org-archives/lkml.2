Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab2FARIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 13:08:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab2FARI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 13:08:29 -0400
Message-ID: <1338570192.23475.25.camel@bling.home>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
From: Alex Williamson <alex.williamson@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>, tglx@linutronix.de
Date: Fri, 01 Jun 2012 11:03:12 -0600
In-Reply-To: <4FC8F042.5050600@siemens.com>
References: <20120601161521.26935.25606.stgit@bling.home>
	 <4FC8F042.5050600@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 18:39 +0200, Jan Kiszka wrote:
> On 2012-06-01 18:16, Alex Williamson wrote:
> > The kernel no longer allows us to pass NULL for a hard interrupt
> > handler without IRQF_ONESHOT.  Should have been using this flag
> > anyway.
> 
> This make the IRQ handling tail a bit slower (due to
> irq_finalize_oneshot). MSIs are edge-triggered, so there was no need for
> masking in theory.

Aren't these asynchronous since we can theoretically do
irq_finalize_oneshot while the guest is servicing the device?

>  Hmm, can't we trust the information that an IRQ
> grabbed here is really a MSI type?


Apparently not, comment added with this check (1c6c6952):

       * The interrupt was requested with handler = NULL, so
       * we use the default primary handler for it. But it
       * does not have the oneshot flag set. In combination
       * with level interrupts this is deadly, because the
       * default primary handler just wakes the thread, then
       * the irq lines is reenabled, but the device still
       * has the level irq asserted. Rinse and repeat....
       *
       * While this works for edge type interrupts, we play
       * it safe and reject unconditionally because we can't
       * say for sure which type this interrupt really
       * has. The type flags are unreliable as the
       * underlying chip implementation can override them.

Thanks,

Alex

> > 
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43328
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> > 
> >  virt/kvm/assigned-dev.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > index 01f572c..e804d14 100644
> > --- a/virt/kvm/assigned-dev.c
> > +++ b/virt/kvm/assigned-dev.c
> > @@ -347,7 +347,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
> >  
> >  	dev->host_irq = dev->dev->irq;
> >  	if (request_threaded_irq(dev->host_irq, NULL,
> > -				 kvm_assigned_dev_thread_msi, 0,
> > +				 kvm_assigned_dev_thread_msi, IRQF_ONESHOT,
> >  				 dev->irq_name, dev)) {
> >  		pci_disable_msi(dev->dev);
> >  		return -EIO;
> > @@ -375,7 +375,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
> >  	for (i = 0; i < dev->entries_nr; i++) {
> >  		r = request_threaded_irq(dev->host_msix_entries[i].vector,
> >  					 NULL, kvm_assigned_dev_thread_msix,
> > -					 0, dev->irq_name, dev);
> > +					 IRQF_ONESHOT, dev->irq_name, dev);
> >  		if (r)
> >  			goto err;
> >  	}
> > 
> 



