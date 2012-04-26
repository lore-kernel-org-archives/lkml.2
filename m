Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab2DZXpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 19:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759483Ab2DZXpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 19:45:50 -0400
Date: Thu, 26 Apr 2012 20:45:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120426234535.GA5057@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9777A4.208@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:03:48PM +0800, Xiao Guangrong wrote:
> If the the present bit of page fault error code is set, it indicates
> the shadow page is populated on all levels, it means what we do is
> only modify the access bit which can be done out of mmu-lock
> 
> Currently, in order to simplify the code, we only fix the page fault
> caused by write-protect on the fast path
> 
> In order to better review, we hold mmu-lock to update spte in this
> patch, the concurrent update will be introduced in the later patch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |  113 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/paging_tmpl.h |    3 +
>  2 files changed, 112 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e7d8ffe..96a9d5b 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2683,18 +2683,117 @@ exit:
>  	return ret;
>  }
> 
> +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
> +				   u32 error_code)
> +{
> +	/*
> +	 * #PF can be fast only if the shadow page table is present and it
> +	 * is caused by write-protect, that means we just need change the
> +	 * W bit of the spte which can be done out of mmu-lock.
> +	 */
> +	if (!(error_code & PFERR_PRESENT_MASK) ||
> +	      !(error_code & PFERR_WRITE_MASK))
> +		return false;
> +
> +	return true;
> +}
> +
> +static bool
> +fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> +		  u64 *sptep, u64 spte)
> +{
> +	gfn_t gfn;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	/* The spte has been changed. */
> +	if (*sptep != spte)
> +		goto exit;
> +
> +	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> +
> +	*sptep = spte | PT_WRITABLE_MASK;
> +	mark_page_dirty(vcpu->kvm, gfn);
> +
> +exit:
> +	spin_unlock(&vcpu->kvm->mmu_lock);

There was a misunderstanding. The suggestion is to change codepaths that
today assume that a side effect of holding mmu_lock is that sptes are
not updated or read before attempting to introduce any lockless spte
updates.

example)

        u64 mask, old_spte = *sptep;

        if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
                __update_clear_spte_fast(sptep, new_spte);
        else
                old_spte = __update_clear_spte_slow(sptep, new_spte);

The local old_spte copy might be stale by the
time "spte_has_volatile_bits(old_spte)" reads the writable bit.

example)


VCPU0                                       VCPU1
set_spte
mmu_spte_update decides fast write 
mov newspte to sptep
(non-locked write instruction)
newspte in store buffer

                                            lockless spte read path reads stale value

spin_unlock(mmu_lock) 

Depending on the what stale value CPU1 read and what decision it took
this can be a problem, say the new bits (and we do not want to verify
every single case). The spte write from inside mmu_lock should always be
atomic now?

So these details must be exposed to the reader, they are hidden now
(note mmu_spte_update is already a maze, its getting too deep).

> +
> +	return true;
> +}
> +
> +/*
> + * Return value:
> + * - true: let the vcpu to access on the same address again.
> + * - false: let the real page fault path to fix it.
> + */
> +static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> +			    int level, u32 error_code)
> +{
> +	struct kvm_shadow_walk_iterator iterator;
> +	struct kvm_mmu_page *sp;
> +	bool ret = false;
> +	u64 spte = 0ull;
> +
> +	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
> +		return false;
> +
> +	walk_shadow_page_lockless_begin(vcpu);
> +	for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
> +		if (!is_shadow_present_pte(spte) || iterator.level < level)
> +			break;
> +
> +	/*
> +	 * If the mapping has been changed, let the vcpu fault on the
> +	 * same address again.
> +	 */
> +	if (!is_rmap_spte(spte)) {
> +		ret = true;
> +		goto exit;
> +	}
> +
> +	if (!is_last_spte(spte, level))
> +		goto exit;
> +
> +	/*
> +	 * Check if it is a spurious fault caused by TLB lazily flushed.
> +	 *
> +	 * Need not check the access of upper level table entries since
> +	 * they are always ACC_ALL.
> +	 */
> +	 if (is_writable_pte(spte)) {
> +		ret = true;
> +		goto exit;
> +	}
> +
> +	/*
> +	 * Currently, to simplify the code, only the spte write-protected
> +	 * by dirty-log can be fast fixed.
> +	 */
> +	if (!spte_wp_by_dirty_log(spte))
> +		goto exit;
> +
> +	sp = page_header(__pa(iterator.sptep));
> +
> +	ret = fast_pf_fix_spte(vcpu, sp, iterator.sptep, spte);
> +
> +exit:
> +	walk_shadow_page_lockless_end(vcpu);
> +
> +	return ret;
> +}
> +
>  static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
> 
> -static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
> -			 bool prefault)
> +static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
> +			 gfn_t gfn, bool prefault)
>  {
>  	int r;
>  	int level;
>  	int force_pt_level;
>  	pfn_t pfn;
>  	unsigned long mmu_seq;
> -	bool map_writable;
> +	bool map_writable, write = error_code & PFERR_WRITE_MASK;
> 
>  	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
>  	if (likely(!force_pt_level)) {
> @@ -2711,6 +2810,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
>  	} else
>  		level = PT_PAGE_TABLE_LEVEL;
> 
> +	if (fast_page_fault(vcpu, v, gfn, level, error_code))
> +		return 0;
> +
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> 
> @@ -3099,7 +3201,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
>  	gfn = gva >> PAGE_SHIFT;
> 
>  	return nonpaging_map(vcpu, gva & PAGE_MASK,
> -			     error_code & PFERR_WRITE_MASK, gfn, prefault);
> +			     error_code, gfn, prefault);
>  }
> 
>  static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
> @@ -3179,6 +3281,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
>  	} else
>  		level = PT_PAGE_TABLE_LEVEL;
> 
> +	if (fast_page_fault(vcpu, gpa, gfn, level, error_code))
> +		return 0;
> +
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index df5a703..80493fb 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -617,6 +617,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>  		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
>  	}
> 
> +	if (fast_page_fault(vcpu, addr, walker.gfn, level, error_code))
> +		return 0;
> +
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	smp_rmb();
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
