Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2EaKLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:11:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2EaKLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:11:17 -0400
Date: Thu, 31 May 2012 13:11:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 5/5] kvm: host side for eoi optimization
Message-ID: <20120531101111.GA15836@redhat.com>
References: <cover.1337695416.git.mst@redhat.com>
 <f434b6864a1af1f813e6ead964026553cd879c38.1337695416.git.mst@redhat.com>
 <20120531095710.GM2311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531095710.GM2311@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:57:10PM +0300, Gleb Natapov wrote:
> > @@ -1345,17 +1437,40 @@ void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu)
> >  	apic_set_tpr(vcpu->arch.apic, data & 0xff);
> >  }
> >  
> > +/*
> > + * apic_sync_pv_eoi_to_guest - called before vmentry
> > + *
> > + * Detect whether it's safe to enable PV EOI and
> > + * if yes do so.
> > + */
> > +static void apic_sync_pv_eoi_to_guest(struct kvm_vcpu *vcpu,
> > +					struct kvm_lapic *apic)
> > +{
> > +	if (!pv_eoi_enabled(vcpu) ||
> > +	    /* IRR set or many bits in ISR: could be nested. */
> > +	    unlikely(apic->irr_pending) ||
> > +	    unlikely(apic->isr_count != 1) ||
> Remind me why pv_eoi should not be set if there is more than one isr?

There's a comment below: it might be safe but
we do not bother: no easy way to know which interrupt
has higher priority.

In my testing more than one bit almost never happens in practice so not
worth optimizing for.


> 
> > +	    /* Cache not set: safe but we don't bother. */
> > +	    unlikely(apic->isr_cache == -1) ||
> > +	    /* Need EOI to update ioapic. */
> > +	    unlikely(kvm_ioapic_handles_vector(vcpu->kvm, apic->isr_cache)))
> > +		return;
> > +
> > +	pv_eoi_set_pending(apic->vcpu);
> > +}
> > +
> apic_sync_pv_eoi_to_guest() is not paired with
> apic_sync_pv_eoi_from_guest() if event injection is canceled.
> You can enter guest with stale pv_eoi bit.

Never. The pv_eoi bit is cleared on each exit.
It will stay cleared unless we set it here.
I will add a comment.

