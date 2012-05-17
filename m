Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406Ab2EQJMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519Ab2EQJMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:12:53 -0400
Date: Thu, 17 May 2012 12:12:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120517091250.GA10209@redhat.com>
References: <20120516175856.GD10769@redhat.com>
 <20120516181500.GA23791@amt.cnet>
 <20120516182520.GH28798@redhat.com>
 <20120516182948.GF10769@redhat.com>
 <20120516183822.GI28798@redhat.com>
 <20120516190757.GA12113@redhat.com>
 <20120517072841.GW32036@redhat.com>
 <20120517074946.GA27995@redhat.com>
 <4FB4AF6D.9080305@redhat.com>
 <20120517091054.GE27995@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517091054.GE27995@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 12:10:55PM +0300, Michael S. Tsirkin wrote:
> On Thu, May 17, 2012 at 10:57:33AM +0300, Avi Kivity wrote:
> > On 05/17/2012 10:49 AM, Michael S. Tsirkin wrote:
> > > On Thu, May 17, 2012 at 10:28:41AM +0300, Gleb Natapov wrote:
> > > > On Wed, May 16, 2012 at 10:07:58PM +0300, Michael S. Tsirkin wrote:
> > > > > > This code is reached from kvm_cpu_get_interrupt(), but this function will
> > > > > > not be called in above scenario.
> > > > > 
> > > > > I think I see. So this shall fix it also makes code cleaner
> > > > > (no -2 hack). Right? kvm_apic_has_interrupt is called correct?
> > > > > 
> > > > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > > > index b4f7013..5a38e34 100644
> > > > > --- a/arch/x86/kvm/lapic.c
> > > > > +++ b/arch/x86/kvm/lapic.c
> > > > > @@ -1273,8 +1273,12 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
> > > > >  	highest_irr = apic_find_highest_irr(apic);
> > > > >  	if (highest_irr == -1)
> > > > >  		return -1;
> > > > > -	if (((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)))
> > > > > -		return -2;
> > > > > +	/* Detect interrupt nesting and disable EOI optimization */
> > > > > +	if ((highest_irr & 0xF0) <= apic_get_reg(apic, APIC_PROCPRI)) {
> > > > > +		if (pv_eoi_enabled(vcpu))
> > > > > +			pv_eoi_clr_pending(vcpu);
> > > > > +		return -1;
> > > > > +	}
> > > > >  	return highest_irr;
> > > > >  }
> > > > >  
> > > > I do not like it. kvm_apic_has_interrupt() does not suppose to mutate
> > > > state.
> > >
> > > OK, so let's rename it so it's clear it can mutate state?
> > >
> > 
> > No, let's refactor this so it makes sense.  The {has|get}_interrupt
> > split is the cause of the problem, I think.  We need a single function,
> > with callbacks that are called when an event happens.  The callbacks can
> > request an irq window exit, inject an interrupt, play with pveoi, or
> > cause a #vmexit.
> 
> OK will look into this next week.
> 
What about looking into my suggestion with setting vcpu->request bit? I
think totally refactoring irq handling path should not be done as part
of this series.

--
			Gleb.
