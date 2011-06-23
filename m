Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1FWQjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:39:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736Ab1FWQjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:39:00 -0400
Date: Thu, 23 Jun 2011 11:21:34 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
Message-ID: <20110623142134.GA12181@amt.cnet>
References: <4E01FBC9.3020009@cn.fujitsu.com>
 <4E01FDE0.5080800@cn.fujitsu.com>
 <20110622215940.GA30064@amt.cnet>
 <4E02B0BE.7070003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E02B0BE.7070003@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 11:19:26AM +0800, Xiao Guangrong wrote:
> Marcelo,
> 
> Thanks for your review!
> 
> On 06/23/2011 05:59 AM, Marcelo Tosatti wrote:
> 
> >>  static int is_large_pte(u64 pte)
> >> @@ -2123,6 +2158,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >>  	u64 spte, entry = *sptep;
> >>  	int ret = 0;
> >>  
> >> +	if (set_mmio_spte(sptep, gfn, pfn, pte_access))
> >> +		return 0;
> >> +
> > 
> > 
> > Should zap all mmio sptes when creating new memory slots (current qemu
> > never exhibits that pattern, but its not an unsupported scenario).
> > Easier to zap all mmu in that case.
> > 
> 
> OK, will do it in the next version.
> 
> > For shadow you need to remove mmio sptes on invlpg and all mmio sptes
> > under CR3 (mmu_sync_roots), other than clearing the gva/gpa variables.
> > 
> 
> Oh, kvm_mmu_pte_write and invlpg do not zap mmio spte, i will
> fix these, thanks for your point it out.
> 
> For mmu_sync_roots, we properly do it in FNAME(sync_page) in this patch:
> 
> static bool sync_mmio_spte(u64 *sptep, gfn_t gfn, unsigned access,
> 			   int *nr_present)
> {
> 	if (unlikely(is_mmio_spte(*sptep))) {
> 		if (gfn != get_mmio_spte_gfn(*sptep)) {
> 			mmu_spte_clear_no_track(sptep);
> 			return true;
> 		}
> 
> 		(*nr_present)++;
> 		mark_mmio_spte(sptep, gfn, access);
> 		return true;
> 	}
> 
> 	return false;
> }
> 
> > Otherwise you can move the mmio info from an mmio spte back to
> > mmio_gva/mmio_gfn after a TLB flush, without rereading the guest
> > pagetable.
> > 
> 
> We do not read the guest page table when mmio page fault occurred,
> we just do it as you say:
> - Firstly, walk the shadow page table to get the mmio spte
> - Then, cache the mmio spte info to mmio_gva/mmio_gfn
> 
> I missed your meaning?

I meant that guest pagetables must be read again on CR3 switch or invlpg
(GVA->GPA can change in that case), which only happens if mmio sptes are
zapped.

> >> +	struct kvm_shadow_walk_iterator iterator;
> >> +	u64 spte, ret = 0ull;
> >> +
> >> +	walk_shadow_page_lockless_begin(vcpu);
> >> +	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
> >> +		if (iterator.level == 1) {
> >> +			ret = spte;
> >> +			break;
> >> +		}
> > 
> > Have you verified it is safe to walk sptes with parallel modifications
> > to them? Other than shadow page deletion which is in theory covered by
> > RCU. It would be good to have all cases written down.
> > 
> 
> Um, i think it is safe, when spte is being write, we can get the old spte
> or the new spte, both cases are ok for us: it is just like the page structure
> cache on the real machine, the cpu can fetch the old spte even if the page
> structure is changed by other cpus.
> >> +
> >> +		if (!is_shadow_present_pte(spte))
> >> +			break;
> >> +	}
> >> +	walk_shadow_page_lockless_end(vcpu);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/*
> >> + * If it is a real mmio page fault, return 1 and emulat the instruction
> >> + * directly, return 0 if it needs page fault path to fix it, -1 is
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
> > 
> > If the gva is remapped there should be no mmio page fault in the first
> > place.
> > 
> 
> For example, as follow case:
> 
> VCPU 0                                     VCPU 1
> gva is mapped to a mmio region
>                                         access gva
> remap gva to other page
>                                        emulate mmio access by kvm
>                                        (*the point we are discussing*)
> flush all tlb
> 
> In theory, it can happen.
> 
> >> +	if (direct && is_shadow_present_pte(spte))
> >> +		return -1;
> > 
> > An spte does not have to contain the present bit to generate a valid EPT
> > misconfiguration (and an spte dump is still required in that case).
> > Use !is_mmio_spte() instead.
> > 
> 
> We can not use !is_mmio_spte() here, since the shadow page can be zapped anytime,
> for example:
> 
> sp.spt[i] = mmio-spte
> 
>           VCPU 0                                    VCPU 1    
> Access sp.spte[i], ept misconfig is occurred
>                                                    delete sp
>                                    (if the number of shadow page is out of the limit
>                                     or page shrink is required, and other events...)
> 
> Walk shadow page out of the lock and get the
> non-present spte
> (*the point we are discussing*)

Then is_mmio_spte(non-present spte) == false, right? Point is that it
only sptes with precise mmio spte pattern should be considered mmio
sptes, otherwise consider a genuine EPT misconfiguration error (which
must be reported).

What about using fault code instead of spte as Avi suggested instead?

> So, the bug we can detect is: it is the mmio access but the spte is point to the normal
> page.
> 
> > 
> >> +
> >> +	/*
> >> +	 * If the page table is zapped by other cpus, let the page
> >> +	 * fault path to fix it.
> >> +	 */
> >> +	return 0;
> >> +}
> > 
> > I don't understand when would this happen, can you please explain?
> > 
> 
> The case is above :-)

No need to jump to page fault handler, can let CPU fault again on non
present spte.


