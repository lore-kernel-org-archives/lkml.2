Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab2D1GKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:10:43 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59534 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2D1GKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:10:40 -0400
Message-ID: <4F9B89D9.9060307@linux.vnet.ibm.com>
Date: Sat, 28 Apr 2012 14:10:33 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet>
In-Reply-To: <20120427145213.GB28796@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042806-8878-0000-0000-000002352412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 10:52 PM, Marcelo Tosatti wrote:


>> Actually, in this patch, all the spte update is under mmu-lock, and we
>> lockless-ly read spte , but the spte will be verified again after holding
>> mmu-lock.
> 
> Yes but the objective you are aiming for is to read and write sptes
> without mmu_lock. That is, i am not talking about this patch. 
> Please read carefully the two examples i gave (separated by "example)").
> 


Thanks for your patience, Marcelo!

>> +	spin_lock(&vcpu->kvm->mmu_lock);
>> +
>> +	/* The spte has been changed. */
>> +	if (*sptep != spte)
>> +		goto exit;
>> +
>> +	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
>> +
>> +	*sptep = spte | PT_WRITABLE_MASK;
>> +	mark_page_dirty(vcpu->kvm, gfn);
>> +
>> +exit:
>> +	spin_unlock(&vcpu->kvm->mmu_lock);
>>
>> Is not the same as both read/update spte under mmu-lock?
>>
>> Hmm, this is what you want?
> 
> The rules for code under mmu_lock should be:
> 
> 1) Spte updates under mmu lock must always be atomic and 
> with locked instructions.


How about treating the spte is 'volatile' if the spte can be
updated out of mmu-lock? In this case, the update is always
atomic.

The piece of code:

+static bool spte_can_be_writable(u64 spte)
+{
+	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
+
+	return (spte & mask) == mask;
+}
+
+static bool spte_can_lockless_update(u64 spte)
+{
+	return  !is_writable_pte(spte) && spte_can_be_writable(spte);
+}
+
 static bool spte_has_volatile_bits(u64 spte)
 {
+	/*
+	 * Always atomicly update spte if it can be updated
+	 * out of mmu-lock.
+	 */
+	if (spte_can_lockless_update(spte))
+		return true;
+

> 2) Spte values must be read once, and appropriate action
> must be taken when writing them back in case their value 
> has changed (remote TLB flush might be required).
> 


Okay, may be i get your idea now. :)

I will fix mmu_spte_update, let it to return the latest old value which
will be checked in the caller before it is updated.

> The maintenance of:
> 
> - gpte writable bit 
> - protected by dirty log
> 
> Bits is tricky. We should think of a way to simplify things 
> and get rid of them (or at least one of them), if possible.
> 

Maybe SPTE_MMU_WRITEABLE is sufficient, the second bit will be dropped.

Marcelo, do you satisfied with this patch?

[PATCH 6/6] KVM: MMU: fast path of handling guest page fault

If the the present bit of page fault error code is set, it indicates
the shadow page is populated on all levels, it means what we do is
only modify the access bit which can be done out of mmu-lock

Currently, in order to simplify the code, we only fix the page fault
caused by write-protect on the fast path

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |  259 +++++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/paging_tmpl.h |    3 +
 2 files changed, 209 insertions(+), 53 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e7d8ffe..2c248b5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -446,8 +446,27 @@ static bool __check_direct_spte_mmio_pf(u64 spte)
 }
 #endif

+static bool spte_can_be_writable(u64 spte)
+{
+	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
+
+	return (spte & mask) == mask;
+}
+
+static bool spte_can_lockless_update(u64 spte)
+{
+	return  !is_writable_pte(spte) && spte_can_be_writable(spte);
+}
+
 static bool spte_has_volatile_bits(u64 spte)
 {
+	/*
+	 * Always atomicly update spte if it can be updated
+	 * out of mmu-lock.
+	 */
+	if (spte_can_lockless_update(spte))
+		return true;
+
 	if (!shadow_accessed_mask)
 		return false;

@@ -480,34 +499,38 @@ static void mmu_spte_set(u64 *sptep, u64 new_spte)

 /* Rules for using mmu_spte_update:
  * Update the state bits, it means the mapped pfn is not changged.
+ *
+ * Note: it returns the latest old value before it is updated, if
+ * the caller deponds on the old spte value, it should use the return
+ * value to check since the spte may be changed on the fast page fault
+ * path which is out of mmu-lock.
  */
-static void mmu_spte_update(u64 *sptep, u64 new_spte)
+static u64 mmu_spte_update(u64 *sptep, u64 new_spte)
 {
-	u64 mask, old_spte = *sptep;
+	u64 old_spte = *sptep;

 	WARN_ON(!is_rmap_spte(new_spte));

-	if (!is_shadow_present_pte(old_spte))
-		return mmu_spte_set(sptep, new_spte);
-
-	new_spte |= old_spte & shadow_dirty_mask;
-
-	mask = shadow_accessed_mask;
-	if (is_writable_pte(old_spte))
-		mask |= shadow_dirty_mask;
+	if (!is_shadow_present_pte(old_spte)) {
+		mmu_spte_set(sptep, new_spte);
+		goto exit;
+	}

-	if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
+	if (!spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, new_spte);
 	else
 		old_spte = __update_clear_spte_slow(sptep, new_spte);

 	if (!shadow_accessed_mask)
-		return;
+		goto exit;

 	if (spte_is_bit_cleared(old_spte, new_spte, shadow_accessed_mask))
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 	if (spte_is_bit_cleared(old_spte, new_spte, shadow_dirty_mask))
 		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+
+exit:
+	return old_spte;
 }

 /*
@@ -1043,48 +1066,37 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-static bool spte_wp_by_dirty_log(u64 spte)
-{
-	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
-
-	WARN_ON(is_writable_pte(spte));
-
-	return ((spte & mask) == mask) && !(spte & SPTE_WRITE_PROTECT);
-}
-
 /* Return true if the spte is dropped. */
 static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
 			       bool *flush, bool page_table_protect)
 {
 	u64 spte = *sptep;

-	if (is_writable_pte(spte)) {
-		*flush |= true;
+	if (!spte_can_be_writable(spte))
+		return false;

-		if (large) {
-			pgprintk("rmap_write_protect(large): spte %p %llx\n",
-				 spte, *spte);
-			BUG_ON(!is_large_pte(spte));
+	if (large) {
+		pgprintk("rmap_write_protect(large): spte %p %llx\n",
+			 spte, *spte);
+		BUG_ON(!is_large_pte(spte));

-			drop_spte(kvm, sptep);
-			--kvm->stat.lpages;
-			return true;
-		}
-
-		goto reset_spte;
+		*flush |= true;
+		drop_spte(kvm, sptep);
+		--kvm->stat.lpages;
+		return true;
 	}

-	if (page_table_protect && spte_wp_by_dirty_log(spte))
-		goto reset_spte;
-
-	return false;
-
-reset_spte:
 	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-	spte = spte & ~PT_WRITABLE_MASK;
+
 	if (page_table_protect)
-		spte |= SPTE_WRITE_PROTECT;
-	mmu_spte_update(sptep, spte);
+		spte &= ~SPTE_MMU_WRITEABLE;
+	spte &= ~PT_WRITABLE_MASK;
+
+	spte = mmu_spte_update(sptep, spte);
+
+	if (is_writable_pte(spte))
+		*flush |= true;
+
 	return false;
 }

@@ -2313,9 +2325,6 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (pte_access & ACC_USER_MASK)
 		spte |= shadow_user_mask;

-	if (pte_access & ACC_WRITE_MASK)
-		spte |= SPTE_MMU_WRITEABLE;
-
 	if (level > PT_PAGE_TABLE_LEVEL)
 		spte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
@@ -2340,7 +2349,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			goto done;
 		}

-		spte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;

 		if (!vcpu->arch.mmu.direct_map
 		    && !(pte_access & ACC_WRITE_MASK)) {
@@ -2369,8 +2378,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				 __func__, gfn);
 			ret = 1;
 			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~PT_WRITABLE_MASK;
-			spte |= SPTE_WRITE_PROTECT;
+			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}

@@ -2378,7 +2386,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		mark_page_dirty(vcpu->kvm, gfn);

 set_pte:
-	mmu_spte_update(sptep, spte);
+	entry = mmu_spte_update(sptep, spte);
 	/*
 	 * If we overwrite a writable spte with a read-only one we
 	 * should flush remote TLBs. Otherwise rmap_write_protect
@@ -2683,18 +2691,157 @@ exit:
 	return ret;
 }

+static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
+				   u32 error_code)
+{
+	/*
+	 * #PF can be fast only if the shadow page table is present and it
+	 * is caused by write-protect, that means we just need change the
+	 * W bit of the spte which can be done out of mmu-lock.
+	 */
+	if (!(error_code & PFERR_PRESENT_MASK) ||
+	      !(error_code & PFERR_WRITE_MASK))
+		return false;
+
+	return true;
+}
+
+static bool
+fast_pf_fix_indirect_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			  u64 *sptep, u64 spte, gfn_t gfn)
+{
+	pfn_t pfn;
+	bool ret = false;
+
+	/*
+	 * For the indirect spte, it is hard to get a stable gfn since
+	 * we just use a cmpxchg to avoid all the races which is not
+	 * enough to avoid the ABA problem: the host can arbitrarily
+	 * change spte and the mapping from gfn to pfn.
+	 *
+	 * What we do is call gfn_to_pfn_atomic to bind the gfn and the
+	 * pfn because after the call:
+	 * - we have held the refcount of pfn that means the pfn can not
+	 *   be freed and be reused for another gfn.
+	 * - the pfn is writable that means it can not be shared by different
+	 *   gfn.
+	 */
+	pfn = gfn_to_pfn_atomic(vcpu->kvm, gfn);
+
+	/* The host page is swapped out or merged. */
+	if (mmu_invalid_pfn(pfn))
+		goto exit;
+
+	ret = true;
+
+	if (pfn != spte_to_pfn(spte))
+		goto exit;
+
+	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
+		mark_page_dirty(vcpu->kvm, gfn);
+
+exit:
+	kvm_release_pfn_clean(pfn);
+	return ret;
+}
+
+static bool
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+			u64 *sptep, u64 spte)
+{
+	gfn_t gfn;
+
+	WARN_ON(!sp->role.direct);
+
+	/*
+	 * The gfn of direct spte is stable since it is calculated
+	 * by sp->gfn.
+	 */
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+
+	if (cmpxchg64(sptep, spte, spte | PT_WRITABLE_MASK) == spte)
+		mark_page_dirty(vcpu->kvm, gfn);
+
+	return true;
+}
+
+/*
+ * Return value:
+ * - true: let the vcpu to access on the same address again.
+ * - false: let the real page fault path to fix it.
+ */
+static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
+			    int level, u32 error_code)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_mmu_page *sp;
+	bool ret = false;
+	u64 spte = 0ull;
+
+	if (!page_fault_can_be_fast(vcpu, gfn, error_code))
+		return false;
+
+	walk_shadow_page_lockless_begin(vcpu);
+	for_each_shadow_entry_lockless(vcpu, gva, iterator, spte)
+		if (!is_shadow_present_pte(spte) || iterator.level < level)
+			break;
+
+	/*
+	 * If the mapping has been changed, let the vcpu fault on the
+	 * same address again.
+	 */
+	if (!is_rmap_spte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	if (!is_last_spte(spte, level))
+		goto exit;
+
+	/*
+	 * Check if it is a spurious fault caused by TLB lazily flushed.
+	 *
+	 * Need not check the access of upper level table entries since
+	 * they are always ACC_ALL.
+	 */
+	 if (is_writable_pte(spte)) {
+		ret = true;
+		goto exit;
+	}
+
+	/*
+	 * Currently, to simplify the code, only the spte write-protected
+	 * by dirty-log can be fast fixed.
+	 */
+	if (!spte_can_be_writable(spte))
+		goto exit;
+
+	sp = page_header(__pa(iterator.sptep));
+
+	if (sp->role.direct)
+		ret = fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte);
+	else
+		ret = fast_pf_fix_indirect_spte(vcpu, sp, iterator.sptep,
+						spte, gfn);
+
+exit:
+	walk_shadow_page_lockless_end(vcpu);
+
+	return ret;
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);

-static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
-			 bool prefault)
+static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
+			 gfn_t gfn, bool prefault)
 {
 	int r;
 	int level;
 	int force_pt_level;
 	pfn_t pfn;
 	unsigned long mmu_seq;
-	bool map_writable;
+	bool map_writable, write = error_code & PFERR_WRITE_MASK;

 	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
 	if (likely(!force_pt_level)) {
@@ -2711,6 +2858,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, v, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

@@ -3099,7 +3249,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	gfn = gva >> PAGE_SHIFT;

 	return nonpaging_map(vcpu, gva & PAGE_MASK,
-			     error_code & PFERR_WRITE_MASK, gfn, prefault);
+			     error_code, gfn, prefault);
 }

 static int kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn)
@@ -3179,6 +3329,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	} else
 		level = PT_PAGE_TABLE_LEVEL;

+	if (fast_page_fault(vcpu, gpa, gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index df5a703..80493fb 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -617,6 +617,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}

+	if (fast_page_fault(vcpu, addr, walker.gfn, level, error_code))
+		return 0;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();

-- 
1.7.7.6


