Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012Ab0KRNs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab0KRNs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:48:56 -0500
Date: Thu, 18 Nov 2010 15:48:43 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118134843.GC8247@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118105741.GA31261@redhat.com>
 <4CE50810.3090502@redhat.com>
 <20101118111037.GB31261@redhat.com>
 <4CE51C17.4000108@redhat.com>
 <20101118130337.GA2254@redhat.com>
 <20101118131453.GO7948@redhat.com>
 <20101118132027.GB8247@redhat.com>
 <20101118133501.GQ7948@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118133501.GQ7948@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:35:01PM +0200, Gleb Natapov wrote:
> On Thu, Nov 18, 2010 at 03:20:27PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Nov 18, 2010 at 03:14:53PM +0200, Gleb Natapov wrote:
> > > On Thu, Nov 18, 2010 at 03:03:37PM +0200, Michael S. Tsirkin wrote:
> > > > > >+static inline void kvm_irq_routing_update(struct kvm *kvm,
> > > > > >+					  struct kvm_irq_routing_table *irq_rt)
> > > > > >+{
> > > > > >+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
> > > > > >+}
> > > > > >+
> > > > > >  static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> > > > > >  {
> > > > > >  	return -ENOSYS;
> > > > > 
> > > > > Apart from these minor issues, looks good.
> > > > 
> > > > 
> > > > Something we should consider improving is the loop over all VCPUs that
> > > > kvm_irq_delivery_to_apic invokes.  I think that (for non-broadcast
> > > > interrupts) it should be possible to precompute an store the CPU
> > > > in question as part of the routing entry.
> > > > 
> > > > Something for a separate patch ... comments?
> > > > 
> > > I do not think this info should be part of routing entry. Routing entry
> > > is more about describing wires on the board.
> > 
> > Not for msi. kvm_kernel_irq_routing_entry seems to just keep an
> > address/data pair in that case. So
> > 
> Yeah. Using routing_entry for MSI was miss design. We discussed that too :)
> 
> > 	union {
> > 		struct {
> > 			unsigned irqchip;
> > 			unsigned pin;
> > 		} irqchip;
> > 		struct msi_msg msi;
> > 	};
> > 
> > would become
> > 
> > 	union {
> > 		struct {
> > 			unsigned irqchip;
> > 			unsigned pin;
> > 		} irqchip;
> > 		struct {
> > 			struct msi_msg msi;
> > 			struct kvm_vpcu *dest;
> > 		} msi;
> > 	};
> > 
> > or something like this.
> Ah so you want to do it only for MSI? For MSI it makes sense. Remember
> though that sometimes destination depend on message itself (specifically
> on delivery mode).

Of course. We'll take message/data and precompute destination.
Set to NULL for e.g. broadcast and recompute at injection time
in that case.  BTW SELF doesn't work for MSI at the moment, not sure
whether it's relevant or when is it used.

> > 
> > > Other then that
> > > this is a good idea that, IIRC, we already discussed once.
> > > 
> > > --
> > > 			Gleb.
> 
> --
> 			Gleb.
