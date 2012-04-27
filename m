Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2D0FxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:53:19 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34884 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab2D0FxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:53:16 -0400
Message-ID: <4F9A3445.2060305@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 13:53:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet>
In-Reply-To: <20120426234535.GA5057@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042705-5564-0000-0000-000002608AC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 07:45 AM, Marcelo Tosatti wrote:


>> +static bool
>> +fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>> +		  u64 *sptep, u64 spte)
>> +{
>> +	gfn_t gfn;
>> +
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
> 
> There was a misunderstanding. 


Sorry, Marcelo! It is still not clear for me now. :(

> The suggestion is to change codepaths that
> today assume that a side effect of holding mmu_lock is that sptes are
> not updated or read before attempting to introduce any lockless spte
> updates.
> 
> example)
> 
>         u64 mask, old_spte = *sptep;
> 
>         if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
>                 __update_clear_spte_fast(sptep, new_spte);
>         else
>                 old_spte = __update_clear_spte_slow(sptep, new_spte);
> 
> The local old_spte copy might be stale by the
> time "spte_has_volatile_bits(old_spte)" reads the writable bit.
> 
> example)
> 
> 
> VCPU0                                       VCPU1
> set_spte
> mmu_spte_update decides fast write 
> mov newspte to sptep
> (non-locked write instruction)
> newspte in store buffer
> 
>                                             lockless spte read path reads stale value
> 
> spin_unlock(mmu_lock) 
> 
> Depending on the what stale value CPU1 read and what decision it took
> this can be a problem, say the new bits (and we do not want to verify
> every single case). The spte write from inside mmu_lock should always be
> atomic now?
> 
> So these details must be exposed to the reader, they are hidden now
> (note mmu_spte_update is already a maze, its getting too deep).
> 


Actually, in this patch, all the spte update is under mmu-lock, and we
lockless-ly read spte , but the spte will be verified again after holding
mmu-lock.

+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	/* The spte has been changed. */
+	if (*sptep != spte)
+		goto exit;
+
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+
+	*sptep = spte | PT_WRITABLE_MASK;
+	mark_page_dirty(vcpu->kvm, gfn);
+
+exit:
+	spin_unlock(&vcpu->kvm->mmu_lock);

Is not the same as both read/update spte under mmu-lock?

Hmm, this is what you want?

+static bool
+fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		  u64 *sptep, u64 spte)
+{
+	gfn_t gfn;
+
+	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+	mmu_spte_update(sptep, spte | PT_WRITABLE_MASK);
+	mark_page_dirty(vcpu->kvm, gfn);
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
+	spin_lock(&vcpu->kvm->mmu_lock);
+
+	for_each_shadow_entry(vcpu, gva, iterator) {
+		spte = *iterator.sptep;
+
+		if (!is_shadow_present_pte(spte) || iterator.level < level)
+			break;
+	}
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
+	if (!spte_wp_by_dirty_log(spte))
+		goto exit;
+
+	sp = page_header(__pa(iterator.sptep));
+
+	ret = fast_pf_fix_spte(vcpu, sp, iterator.sptep, spte);
+
+exit:
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
+	return ret;
+}

