Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2EUSog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:44:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab2EUSod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:44:33 -0400
Date: Mon, 21 May 2012 21:44:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: kvm@vger.kernel.org
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: optimize ISR lookups
Message-ID: <20120521184352.GA14463@redhat.com>
References: <20120521163727.GA13337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521163727.GA13337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 07:37:27PM +0300, Michael S. Tsirkin wrote:
> We perform ISR lookups twice: during interrupt
> injection and on EOI. Typical workloads only have
> a single bit set there. So we can avoid ISR scans by
> 1. counting bits as we set/clear them in ISR
> 2. if count is 1, caching the vector number
> 3. if count != 1, invalidating the cache
> 
> The real purpose of this is enabling PV EOI
> which needs to quickly validate the vector.
> But non PV guests also benefit.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

BTW host to guest netperf result (which is 100% CPU bound)
seems to increase pretty drastically:

before

TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 11.0.0.104
(11.0.0.104) port 0 AF_INET
Recv   Send    Send                          Utilization       Service
Demand
Socket Socket  Message  Elapsed              Send     Recv     Send
Recv
Size   Size    Size     Time     Throughput  local    remote   local
remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB
us/KB

 87380  16384  16384    10.01      7905.79   11.26    99.50    2.801 1.031  

after

TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 11.0.0.104
(11.0.0.104) port 0 AF_INET
Recv   Send    Send                          Utilization       Service
Demand
Socket Socket  Message  Elapsed              Send     Recv     Send
Recv
Size   Size    Size     Time     Throughput  local    remote   local
remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB
us/KB

 87380  16384  16384    10.01      8826.59   11.36    99.20    2.531 0.921  

> ---
>  arch/x86/kvm/lapic.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/lapic.h |    2 +
>  2 files changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 93c1574..232950a 100644
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
> +	ASSERT(apic->isr_count > MAX_APIC_VECTOR);
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
> +	ASSERT(apic->isr_count < 0);
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
> +		return apic->isr_cache;
>  
>  	result = find_highest_vector(apic->regs + APIC_ISR);
>  	ASSERT(result == -1 || result >= 16);
> @@ -492,7 +535,7 @@ static void apic_set_eoi(struct kvm_lapic *apic)
>  	if (vector == -1)
>  		return;
>  
> -	apic_clear_vector(vector, apic->regs + APIC_ISR);
> +	apic_clear_isr(vector, apic);
>  	apic_update_ppr(apic);
>  
>  	if (!(apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
> @@ -1081,6 +1124,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu)
>  		apic_set_reg(apic, APIC_TMR + 0x10 * i, 0);
>  	}
>  	apic->irr_pending = false;
> +	apic->isr_count = 0;
> +	apic->isr_cache = -1;
>  	update_divide_count(apic);
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  	if (kvm_vcpu_is_bsp(vcpu))
> @@ -1248,7 +1293,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>  	if (vector == -1)
>  		return -1;
>  
> -	apic_set_vector(vector, apic->regs + APIC_ISR);
> +	apic_set_isr(vector, apic);
>  	apic_update_ppr(apic);
>  	apic_clear_irr(vector, apic);
>  	return vector;
> @@ -1267,6 +1312,8 @@ void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu)
>  	update_divide_count(apic);
>  	start_apic_timer(apic);
>  	apic->irr_pending = true;
> +	apic->isr_count = count_vectors(apic->regs + APIC_ISR);
> +	apic->isr_cache = -1;
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  }
>  
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 6f4ce25..9f8deff 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -13,6 +13,8 @@ struct kvm_lapic {
>  	u32 divide_count;
>  	struct kvm_vcpu *vcpu;
>  	bool irr_pending;
> +	s16 isr_count;
> +	int isr_cache;
>  	void *regs;
>  	gpa_t vapic_addr;
>  	struct page *vapic_page;
> -- 
> MST
