Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2E3VCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:02:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab2E3VCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:02:00 -0400
Date: Wed, 30 May 2012 17:54:42 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] kvm: optimize ISR lookups
Message-ID: <20120530205442.GA8937@amt.cnet>
References: <20120522125456.GA4337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120522125456.GA4337@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 03:54:56PM +0300, Michael S. Tsirkin wrote:
> We perform ISR lookups twice: during interrupt
> injection and on EOI. Typical workloads only have
> a single bit set there. So we can avoid ISR scans by
> 1. counting bits as we set/clear them in ISR
> 2. if count is 1, caching the vector number
> 3. if count != 1, invalidating the cache
> 
> The real purpose of this is enabling PV EOI
> which needs to quickly validate the vector.
> But non PV guests might also benefit.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> I am well aware of Thomas and Peter's suggestion of reworking APIC
> register handling in kvm instead of adding a cache like this patch does.
> 
> This revision does *not* address that comment yet: it only corrects a
> bug in the original patch.
> 
> Posting in this form for ease of testing.
> 
> Changes from v1:
> 	replace ASSERT by BUG_ON, correcting inverted logic
> 
>  arch/x86/kvm/lapic.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/lapic.h |    2 +
>  2 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 93c1574..0d2985d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -107,6 +107,16 @@ static inline void apic_clear_vector(int vec, void *bitmap)
>  	clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
>  }
>  
> +static inline int __apic_test_and_set_vector(int vec, void *bitmap)
> +{
> +	return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> +}
> +
> +static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> +{
> +	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> +}
> +
>  static inline int apic_hw_enabled(struct kvm_lapic *apic)
>  {
>  	return (apic)->vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE;
> @@ -210,6 +220,16 @@ static int find_highest_vector(void *bitmap)
>  		return fls(word[word_offset << 2]) - 1 + (word_offset << 5);
>  }
>  
> +static u8 count_vectors(void *bitmap)
> +{
> +	u32 *word = bitmap;
> +	int word_offset;
> +	u8 count = 0;
> +	for (word_offset = 0; word_offset < MAX_APIC_VECTOR >> 5; ++word_offset)
> +		count += hweight32(word[word_offset << 2]);
> +	return count;
> +}
> +
>  static inline int apic_test_and_set_irr(int vec, struct kvm_lapic *apic)
>  {
>  	apic->irr_pending = true;
> @@ -242,6 +262,25 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
>  		apic->irr_pending = true;
>  }
>  
> +static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
> +{
> +	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
> +		++apic->isr_count;
> +	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> +	if (likely(apic->isr_count == 1))
> +		apic->isr_cache = vec;
> +	else
> +		apic->isr_cache = -1;
> +}
> +
> +static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> +{
> +	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> +		--apic->isr_count;
> +	BUG_ON(apic->isr_count < 0);
> +	apic->isr_cache = -1;
> +}
> +
>  int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> @@ -273,6 +312,10 @@ int kvm_apic_set_irq(struct kvm_vcpu *vcpu, struct kvm_lapic_irq *irq)
>  static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>  {
>  	int result;
> +	if (!apic->isr_count)
> +		return -1;
> +	if (likely(apic->isr_cache != -1))

assert(isr_count == 1).

Looks fine otherwise. Gleb can you review please?

