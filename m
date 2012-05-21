Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab2EUXGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:06:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2EUXGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:06:30 -0400
Date: Tue, 22 May 2012 02:06:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120521230623.GO17031@redhat.com>
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
> On Mon, 21 May 2012, Michael S. Tsirkin wrote:
> 
> > We perform ISR lookups twice: during interrupt
> > injection and on EOI. Typical workloads only have
> > a single bit set there. So we can avoid ISR scans by
> > 1. counting bits as we set/clear them in ISR
> > 2. if count is 1, caching the vector number
> > 3. if count != 1, invalidating the cache
> > 
> > The real purpose of this is enabling PV EOI
> > which needs to quickly validate the vector.
> > But non PV guests also benefit.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/lapic.h |    2 +
> >  2 files changed, 51 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 93c1574..232950a 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -107,6 +107,16 @@ static inline void apic_clear_vector(int vec, void *bitmap)
> >  	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> >  }
> >  
> > +static inline int __apic_test_and_set_vector(int vec, void *bitmap)
> > +{
> > +	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> > +}
> > +
> > +static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> > +{
> > +	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> > +}
> > +
> >  static inline int apic_hw_enabled(struct kvm_lapic *apic)
> >  {
> >  	return (apic)->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
> > @@ -210,6 +220,16 @@ static int find_highest_vector(void *bitmap)
> >  		return fls(word[word_offset << 2]) - 1 + (word_offset << 5);
> >  }
> >  
> > +static u8 count_vectors(void *bitmap)
> > +{
> > +	u32 *word = bitmap;
> > +	int word_offset;
> > +	u8 count = 0;
> > +	for (word_offset = 0; word_offset < MAX_APIC_VECTOR >> 5; ++word_offset)
> > +		count += hweight32(word[word_offset << 2]);
> > +	return count;
> > +}
> 
> Why do you need to reimplement bitmap_weight()?
> 
> Because your bitmap is not a bitmap,

It's an existing "bitmap". It's not my bitmap :)

> but a set of 32bit registers
> which have an offset of 4 words each. I really had to twist my brain
> around this function and the test_and_clr/set ones above just because
> the name bitmap is so horribly misleading. Add an extra bonus for
> using void pointers.
> 
> Yes, I know, the existing code is full of this, but that's not an
> excuse to add more of it.

There's no other way to use existing code. If current code
is reworked to use bitmap.h then my patch can use it too.


> This emulation is just silly. Nothing in an emulation where the access
> to the emulated hardware is implemented with vmexits is requiring a
> 1:1 memory layout. It's completely irrelevant whether the hardware has
> an ISR regs offset of 0x10 or not. Nothing prevents the emulation to
> use a consecutive bitmap for the vector bits instead of reimplementing
> a boatload of bitmap operations.
> 
> The only justification for having the same layout as the actual
> hardware is when you are going to map the memory into the guest space,
> which is not the case here.

I think the reason is __apic_read which now simply copies the registers
out to guest, this code will become less straight-forward if it's not
1:1.

> And if you look deeper, then you'll notice that _ALL_ APIC registers
> are on a 16 byte boundary (thanks Peter for pointing that out).
> 
> So it's even more silly to have a 1:1 representation instead of
> implementing the default emulated apic_read/write functions to access
> (offset >> 2).
> 
> And of course, that design decision causes lookups to be slow.

Yes, it might be one of the reasons why my patch helps so
much: it adds a cache in front of this data structure.

> It's
> way faster to scan a consecutive bitmap than iterating through eight
> 32bit words with an offset of 0x10, especially on a 64 bit host.
>
> >  static inline int apic_test_and_set_irr(int vec, struct kvm_lapic *apic)
> >  {
> >  	apic->irr_pending = true;
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
> 
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


So what you propose is in fact to rework apic registers at least for
ISR,IRR,TMR to use a bitmap.
I am fine with this suggestion but would like some feedback from kvm
maintainers on where they want to go before I spend time on that.

-- 
MST
