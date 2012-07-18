Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab2GRLim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2GRLij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:38:39 -0400
Date: Wed, 18 Jul 2012 14:39:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v5 1/4] kvm: Extend irqfd to support level interrupts
Message-ID: <20120718113910.GA5135@redhat.com>
References: <20120716202711.1752.71007.stgit@bling.home>
 <20120716203344.1752.14606.stgit@bling.home>
 <20120718104114.GC4700@redhat.com>
 <20120718104429.GD26120@redhat.com>
 <20120718104844.GF4700@redhat.com>
 <20120718104906.GE26120@redhat.com>
 <20120718105311.GH4700@redhat.com>
 <20120718105530.GG26120@redhat.com>
 <20120718112219.GJ4700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718112219.GJ4700@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 02:22:19PM +0300, Michael S. Tsirkin wrote:
> > > > > > > So as was discussed kvm_set_irq under spinlock is bad for scalability
> > > > > > > with multiple VCPUs.  Why do we need a spinlock simply to protect
> > > > > > > level_asserted?  Let's use an atomic test and set/test and clear and the
> > > > > > > problem goes away.
> > > > > > > 
> > > > > > That sad reality is that for level interrupt we already scan all vcpus
> > > > > > under spinlock.
> > > > > 
> > > > > Where?
> > > > > 
> > > > ioapic
> > > 
> > > $ grep kvm_for_each_vcpu virt/kvm/ioapic.c
> > > $
> > > 
> > > ?
> > > 
> > 
> > Come on Michael. You can do better than grep and actually look at what
> > code does. The code that loops over all vcpus while delivering an irq is
> > in kvm_irq_delivery_to_apic(). Now grep for that.
> 
> Hmm, I see, it's actually done for edge if injected from ioapic too,
> right?
> 
> So set_irq does a linear scan, and for each matching CPU it calls
> kvm_irq_delivery_to_apic which is another scan?
> So it's actually N^2 worst case for a broadcast?

No it isn't, I misread the code.


Anyway, maybe not trivially but this looks fixable to me: we could drop
the ioapic lock before calling kvm_irq_delivery_to_apic.

> > --
> > 			Gleb.
