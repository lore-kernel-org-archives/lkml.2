Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab2GRMGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2GRMGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:06:34 -0400
Date: Wed, 18 Jul 2012 15:07:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120718120705.GB5184@redhat.com>
References: <20120716203344.1752.14606.stgit@bling.home>
 <20120718104114.GC4700@redhat.com>
 <20120718104429.GD26120@redhat.com>
 <20120718104844.GF4700@redhat.com>
 <20120718104906.GE26120@redhat.com>
 <20120718105311.GH4700@redhat.com>
 <20120718105530.GG26120@redhat.com>
 <20120718112219.GJ4700@redhat.com>
 <20120718113910.GA5135@redhat.com>
 <20120718114844.GH26120@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718114844.GH26120@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 02:48:44PM +0300, Gleb Natapov wrote:
> On Wed, Jul 18, 2012 at 02:39:10PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jul 18, 2012 at 02:22:19PM +0300, Michael S. Tsirkin wrote:
> > > > > > > > > So as was discussed kvm_set_irq under spinlock is bad for scalability
> > > > > > > > > with multiple VCPUs.  Why do we need a spinlock simply to protect
> > > > > > > > > level_asserted?  Let's use an atomic test and set/test and clear and the
> > > > > > > > > problem goes away.
> > > > > > > > > 
> > > > > > > > That sad reality is that for level interrupt we already scan all vcpus
> > > > > > > > under spinlock.
> > > > > > > 
> > > > > > > Where?
> > > > > > > 
> > > > > > ioapic
> > > > > 
> > > > > $ grep kvm_for_each_vcpu virt/kvm/ioapic.c
> > > > > $
> > > > > 
> > > > > ?
> > > > > 
> > > > 
> > > > Come on Michael. You can do better than grep and actually look at what
> > > > code does. The code that loops over all vcpus while delivering an irq is
> > > > in kvm_irq_delivery_to_apic(). Now grep for that.
> > > 
> > > Hmm, I see, it's actually done for edge if injected from ioapic too,
> > > right?
> > > 
> > > So set_irq does a linear scan, and for each matching CPU it calls
> > > kvm_irq_delivery_to_apic which is another scan?
> > > So it's actually N^2 worst case for a broadcast?
> > 
> > No it isn't, I misread the code.
> > 
> > 
> > Anyway, maybe not trivially but this looks fixable to me: we could drop
> > the ioapic lock before calling kvm_irq_delivery_to_apic.
> > 
> May be, may be not. Just saying "lets drop lock whenever we don't feel
> like holding one" does not cut it.

One thing we do is set remote_irr if interrupt was injected.
I agree these things are tricky.

One other question:

static int ioapic_service(struct kvm_ioapic *ioapic, unsigned int idx)
{
        union kvm_ioapic_redirect_entry *pent;
        int injected = -1;

        pent = &ioapic->redirtbl[idx];

        if (!pent->fields.mask) {
                injected = ioapic_deliver(ioapic, idx);
                if (injected && pent->fields.trig_mode == IOAPIC_LEVEL_TRIG)
                        pent->fields.remote_irr = 1;
        }

        return injected;
}


This if (injected) looks a bit strange since ioapic_deliver returns
-1 if no matching destinations. Should be if (injected > 0)?



> Back to original point though current
> situation is that calling kvm_set_irq() under spinlock is not worse for
> scalability than calling it not under one.

Yes. Still the specific use can just use an atomic flag,
lock+bool is not needed, and we won't need to undo it later.

> --
> 			Gleb.
