Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1GGIvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1GGIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:51:28 -0400
Date: Thu, 7 Jul 2011 05:49:06 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 18/19] KVM: MMU: mmio page fault support
Message-ID: <20110707084906.GD8334@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C3375.6010500@cn.fujitsu.com>
 <20110706185252.GC9820@amt.cnet>
 <4E14BE90.8070508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14BE90.8070508@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:59:12AM +0800, Xiao Guangrong wrote:
> On 07/07/2011 02:52 AM, Marcelo Tosatti wrote:
> 
> >> +/*
> >> + * If it is a real mmio page fault, return 1 and emulat the instruction
> >> + * directly, return 0 to let CPU fault again on the address, -1 is
> >> + * returned if bug is detected.
> >> + */
> >> +int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
> >> +{
> >> +	u64 spte;
> >> +
> >> +	if (quickly_check_mmio_pf(vcpu, addr, direct))
> >> +		return 1;
> >> +
> >> +	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
> >> +
> >> +	if (is_mmio_spte(spte)) {
> >> +		gfn_t gfn = get_mmio_spte_gfn(spte);
> >> +		unsigned access = get_mmio_spte_access(spte);
> >> +
> >> +		if (direct)
> >> +			addr = 0;
> >> +		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
> >> +		return 1;
> >> +	}
> >> +
> >> +	/*
> >> +	 * It's ok if the gva is remapped by other cpus on shadow guest,
> >> +	 * it's a BUG if the gfn is not a mmio page.
> >> +	 */
> >> +	if (direct && is_shadow_present_pte(spte))
> >> +		return -1;
> > 
> 
> Marcelo,
> 
> > This is only going to generate an spte dump, for a genuine EPT
> > misconfig, if the present bit is set.
> > 
> > Should be:
> > 
> > /*
> >  * Page table zapped by other cpus, let CPU fault again on
> >  * the address.
> >  */
> > if (*spte == 0ull)
> >     return 0;
> 
> Can not use "*spte == 0ull" here, it should use !is_shadow_present_pte(spte)
> instead, since on x86-32 host, we can get the high 32 bit is set, and the present
> bit is cleared.

OK, then check for 0ull on x86-64, and low 32-bit zeroed but high 32-bit with mmio
pattern on x86-32.

It is not acceptable to disable spte dump for sptes without present bit.

> > /* BUG if gfn is not an mmio page */
> > return -1;
> 
> We can not detect bug for soft-mmu, since the shadow page can be changed anytime,
> for example:
> 
> VCPU 0                            VCPU1
> mmio page is intercepted
>                               change the guest page table and map the virtual
>                               address to the RAM region
> walk shadow page table, and
> detect the gfn is RAM, spurious
> BUG is reported
> 
> In theory, it can be happened.

Yes, with TDP only assigning a memory slot can change an spte from mmio
to valid, which can only happen under SRCU, so this path is protected.

> >> +static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
> >> +			   int *nr_present)
> >> +{
> >> +	if (unlikely(is_mmio_spte(*sptep))) {
> >> +		if (gfn != get_mmio_spte_gfn(*sptep)) {
> >> +			mmu_spte_clear_no_track(sptep);
> >> +			return true;
> >> +		}
> >> +
> >> +		(*nr_present)++;
> > 
> > Can increase nr_present in the caller.
> > 
> 
> Yes, we should increase it to avoid the unsync shadow page to be freed.
> 
> >> @@ -6481,6 +6506,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
> >>  	if (!kvm->arch.n_requested_mmu_pages)
> >>  		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
> >>  
> >> +	/*
> >> +	 * If the new memory slot is created, we need to clear all
> >> +	 * mmio sptes.
> >> +	 */
> >> +	if (npages && old.base_gfn != mem->guest_phys_addr >> PAGE_SHIFT)
> >> +		kvm_arch_flush_shadow(kvm);
> >> +
> > 
> > This should be in __kvm_set_memory_region.
> > 
> 
> Um, __kvm_set_memory_region is a common function, and only x86 support mmio spte,
> it seems no need to do this for all architecture?

Please do it in __kvm_set_memory_region, after
kvm_arch_prepare_memory_region (other arches won't mind the flush).

