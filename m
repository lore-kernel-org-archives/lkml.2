Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2FMJCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:02:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2FMJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:02:23 -0400
Date: Wed, 13 Jun 2012 12:02:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 2/8] kvm: optimize ISR lookups
Message-ID: <20120613090242.GA17357@redhat.com>
References: <cover.1338474301.git.mst@redhat.com>
 <d054c34a0765aee4e4f751bde73615befa33cc87.1338474301.git.mst@redhat.com>
 <20120612210833.GA639@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612210833.GA639@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 06:08:33PM -0300, Marcelo Tosatti wrote:
> On Sun, Jun 03, 2012 at 10:27:59AM +0300, Michael S. Tsirkin wrote:
> > We perform ISR lookups twice: during interrupt
> > injection and on EOI. Typical workloads only have
> > a single bit set there. So we can avoid ISR scans by
> > 1. counting bits as we set/clear them in ISR
> > 2. on set, caching the injected vector number
> > 3. on clear, invalidating the cache
> > 
> > The real purpose of this is enabling PV EOI
> > which needs to quickly validate the vector.
> > But non PV guests also benefit: with this patch,
> > and without interrupt nesting, apic_find_highest_isr
> > will always return immediately without scanning ISR.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > This revision is slightly reworked from the last version
> > I sent: I don't invalidate the cache when there is more
> > than one bit set in ISR. This makes the code simpler,
> > makes cache valid in more cases and avoids a branch on data path.
> > 
> > Otherwise this is basically the same as v2: this revision does not
> > yet address Thomas's idea of reworking the APIC page handling.
> > 
> >  arch/x86/kvm/lapic.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  arch/x86/kvm/lapic.h |    4 ++++
> >  2 files changed, 50 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 93c1574..db54e63 100644
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
> > +
> >  static inline int apic_test_and_set_irr(int vec, struct kvm_lapic *apic)
> >  {
> >  	apic->irr_pending = true;
> > @@ -242,6 +262,22 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
> >  		apic->irr_pending = true;
> >  }
> >  
> > +static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> > +{
> > +	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> > +		++apic->isr_count;
> > +	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> > +	apic->isr_cache = vec;
> > +}
> > +
> > +static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> > +{
> > +	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> > +		--apic->isr_count;
> > +	BUG_ON(apic->isr_count < 0);
> > +	apic->isr_cache = -1;
> > +}
> > +
> >  int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
> >  {
> >  	struct kvm_lapic *apic = vcpu->arch.apic;
> > @@ -273,6 +309,10 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
> >  static inline int apic_find_highest_isr(struct kvm_lapic *apic)
> >  {
> >  	int result;
> > +	if (!apic->isr_count)
> > +		return -1;
> > +	if (likely(apic->isr_cache != -1))
> > +		return apic->isr_cache;
> 
> What about TPR updates that modify highest ISR available? They are not
> fully covered. Ex: writes to TPR register not via CR8.

Sorry, I don't yet understand what you are saying.

Why would TPR/PPR updates need to affect any of this:
TPR affects the injection of interrupts but if we don't inject
and interrupt we don't set ISR, right?

Maybe I misunderstand, I'm going to look more at the spec, but maybe
you could point out an example where this logic is wrong?

> 
> apic_update_ppr should reset cache?

I think this would kill the optimization as we call this all the time.
With this patch applied ISR was searched in less than 1% of the cases
in my testing, it almost always was either a cache hit or count == 0.

> Instead of isr_cache what about a highest_isr field?

> 
> When setting ISR:
> 
> if (apic->highest_isr < me)
> 	apic->highest_isr = me;
> 
> To be invalidated on TPR updates properly.
> 
> Its more meaningful.

OK, I'll rename it highest_isr but we do not need the if:

IIUC, ISR (in service register) bit is only set when we inject an
interrupt.  So the latest bit we set tells us exactly which isr is the
highest: it would not be set if it was not the highest.  We are simply
caching this last bit which to me looks cleaner than adding logic here:
if we did we'd also need to special-case the invalid value, so it
becomes tricky.

I'll add a comment here that explains the above.

As I said I don't yet understand why we need to invalidate on TPR updates.

-- 
MST
