Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0KRKEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:04:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab0KRKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:04:39 -0500
Date: Thu, 18 Nov 2010 12:04:34 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118100434.GB7948@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118090522.GX7948@redhat.com>
 <20101118093426.GH16832@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118093426.GH16832@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:34:26AM +0200, Michael S. Tsirkin wrote:
> > > @@ -125,10 +129,18 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > >  {
> > >  	struct _irqfd *irqfd = container_of(wait, struct _irqfd, wait);
> > >  	unsigned long flags = (unsigned long)key;
> > > +	struct kvm_kernel_irq_routing_entry *irq;
> > >  
> > > -	if (flags & POLLIN)
> > > +	if (flags & POLLIN) {
> > > +		rcu_read_lock();
> > > +		irq = irqfd->irq_entry;
> > Why not rcu_dereference()?
> 
> Of course. Good catch, thanks.
> 
> > And why it can't be zero here?
> 
> It can, I check below.
> 
Yeah, missed that. Thanks.

> > >  		/* An event has been signaled, inject an interrupt */
> > > -		schedule_work(&irqfd->inject);
> > > +		if (irq)
> > > +			kvm_set_msi(irq, irqfd->kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1);
> > > +		else
> > > +			schedule_work(&irqfd->inject);
> > > +		rcu_read_unlock();
> > > +	}
> > >  

--
			Gleb.
