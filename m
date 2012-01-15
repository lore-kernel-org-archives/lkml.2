Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab2AONWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 08:22:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2AONWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 08:22:53 -0500
Date: Sun, 15 Jan 2012 15:24:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <20120115132455.GC31012@redhat.com>
References: <cover.1318358229.git.mst@redhat.com>
 <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
 <4F0EE98D.1090704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0EE98D.1090704@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 04:09:17PM +0200, Avi Kivity wrote:
> On 10/11/2011 08:38 PM, Michael S. Tsirkin wrote:
> > To forward an interrupt to a vcpu that runs on
> > a host cpu different from the current one,
> > we need an ipi which likely will cost us as much
> > as delivering the interrupt directly to that cpu would.
> >
> > Set irq affinity hint to point there, irq balancer
> > can then take this into accound and balance
> > interrupts accordingly.
> >
> >  
> > +static void kvm_vcpu_host_irq_hint(struct kvm_vcpu *vcpu, int host_irq)
> > +{
> > +	const struct cpumask *mask;
> > +	/* raw_smp_processor_id() is ok here: if we get preempted we can get a
> > +	 * wrong value but we don't mind much. */
> > +	if (host_irq >= 0 && unlikely(vcpu->cpu != raw_smp_processor_id())) {
> > +		mask = get_cpu_mask(vcpu->cpu);
> > +		irq_set_affinity_hint(host_irq, mask);
> > +	}
> > +}
> > +	
> >  int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> >  		struct kvm_lapic_irq *irq, int host_irq)
> >  {
> > @@ -102,6 +114,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> >  			if (r < 0)
> >  				r = 0;
> >  			r += kvm_apic_set_irq(vcpu, irq);
> > +			kvm_vcpu_host_irq_hint(vcpu, host_irq);
> 
> Doing this every time seems excessive.

Please note this doesn't modify the mapping in the hardware:
it only updates the hint for the irqbalancer,
and only if we target a CPU which is different
from the current one.

> How about doing it every N interrupts?

That's certainly easy.

> We can even collect information about which vcpus were
> targeted, and then use a mask instead of just one vcpu.

Yes, we can, but it certainly becomes much more complex.
The motivatin behind using the same host cpu is reducing the
number of IPIs. If the interrupt is bouncing between
guest VCPUs, this optimizaion won't work, so what's the
theory behind using a mask?
How about detecting an unstable vcpu mapping and
completely disabling the optimization, instead?

> -- 
> error compiling committee.c: too many arguments to function
