Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377Ab2EUVvf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:51:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759319Ab2EUVvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:51:33 -0400
Date: Tue, 22 May 2012 00:51:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120521215127.GH17031@redhat.com>
References: <20120521163727.GA13337@redhat.com>
 <alpine.LFD.2.02.1205211940030.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205211940030.3231@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:04:25PM +0200, Thomas Gleixner wrote:
> > @@ -242,6 +262,25 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
> >  		apic->irr_pending = true;
> >  }
> >  
> > +static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> > +{
> > +	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> > +		++apic->isr_count;
> > +	ASSERT(apic->isr_count > MAX_APIC_VECTOR);
> 
> I'm really curious what you observed when defining DEBUG in that file.
> 
> Clearly you never did.

Sorry :(
Yes clearly silly, thanks for pointing this out.

> > +	if (likely(apic->isr_count == 1))
> > +		apic->isr_cache = vec;
> > +	else
> > +		apic->isr_cache = -1;
> > +}
> > +
> > +static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> > +{
> > +	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> > +		--apic->isr_count;
> > +	ASSERT(apic->isr_count < 0);
> 
> Ditto.
> 
> >  	result = find_highest_vector(apic->regs + APIC_ISR);
> >  	ASSERT(result == -1 || result >= 16);
> 
> And obviously none of the folks who added this gem bothered to define
> DEBUG either.
> 
> So please instead of working around horrid design decisions and adding
> more mess to the existing one, can we please cleanup the stuff first
> and then decide whether it's worth to add the extra magic?
> 
> Thanks,
> 
> 	tglx
