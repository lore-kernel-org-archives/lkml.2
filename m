Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2LLT3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 14:29:30 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36324 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab2LLT33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 14:29:29 -0500
Message-ID: <50C8DB11.5050204@linux.vnet.ibm.com>
Date: Thu, 13 Dec 2012 03:29:21 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: x86: improve reexecute_instruction
References: <50C5A747.1020105@linux.vnet.ibm.com> <50C5A807.4070301@linux.vnet.ibm.com> <20121212010951.GB2898@amt.cnet>
In-Reply-To: <20121212010951.GB2898@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121219-1396-0000-0000-0000024A2BF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 09:09 AM, Marcelo Tosatti wrote:
> On Mon, Dec 10, 2012 at 05:14:47PM +0800, Xiao Guangrong wrote:
>> The current reexecute_instruction can not well detect the failed instruction
>> emulation. It allows guest to retry all the instructions except it accesses
>> on error pfn
>>
>> For example, some cases are nested-write-protect - if the page we want to
>> write is used as PDE but it chains to itself. Under this case, we should
>> stop the emulation and report the case to userspace
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    2 +
>>  arch/x86/kvm/paging_tmpl.h      |    2 +
>>  arch/x86/kvm/x86.c              |   82 +++++++++++++++++++++++++++++----------
>>  3 files changed, 65 insertions(+), 21 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index dc87b65..8d01c02 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -575,6 +575,8 @@ struct kvm_arch {
>>  	u64 hv_guest_os_id;
>>  	u64 hv_hypercall;
>>
>> +	/* synchronizing reexecute_instruction and page fault path. */
>> +	u64 page_fault_count;
>>  	#ifdef CONFIG_KVM_MMU_AUDIT
>>  	int audit_point;
>>  	#endif
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index 32d77ff..85b8e0e 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -614,6 +614,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>>  	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
>>  		goto out_unlock;
>>
>> +	vcpu->kvm->arch.page_fault_count++;
>> +
>>  	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
>>  	kvm_mmu_free_some_pages(vcpu);
>>  	if (!force_pt_level)
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 3796f8c..5677869 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4756,29 +4756,27 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
>>  static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  {
>>  	gpa_t gpa = cr2;
>> +	gfn_t gfn;
>>  	pfn_t pfn;
>> -	unsigned int indirect_shadow_pages;
>> -
>> -	spin_lock(&vcpu->kvm->mmu_lock);
>> -	indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
>> -	spin_unlock(&vcpu->kvm->mmu_lock);
>> -
>> -	if (!indirect_shadow_pages)
>> -		return false;
>> +	u64 page_fault_count;
>> +	int emulate;
>>
>>  	if (!vcpu->arch.mmu.direct_map) {
>> -		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
>> +		/*
>> +		 * Write permission should be allowed since only
>> +		 * write access need to be emulated.
>> +		 */
>> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
>> +
>> +		/*
>> +		 * If the mapping is invalid in guest, let cpu retry
>> +		 * it to generate fault.
>> +		 */
>>  		if (gpa == UNMAPPED_GVA)
>> -			return true; /* let cpu generate fault */
>> +			return true;
>>  	}
>>
>> -	/*
>> -	 * if emulation was due to access to shadowed page table
>> -	 * and it failed try to unshadow page and re-enter the
>> -	 * guest to let CPU execute the instruction.
>> -	 */
>> -	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
>> -		return true;
>> +	gfn = gpa_to_gfn(gpa);
>>
>>  	/*
>>  	 * Do not retry the unhandleable instruction if it faults on the
>> @@ -4786,13 +4784,55 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  	 * retry instruction -> write #PF -> emulation fail -> retry
>>  	 * instruction -> ...
>>  	 */
>> -	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
>> -	if (!is_error_noslot_pfn(pfn)) {
>> -		kvm_release_pfn_clean(pfn);
>> +	pfn = gfn_to_pfn(vcpu->kvm, gfn);
>> +
>> +	/*
>> +	 * If the instruction failed on the error pfn, it can not be fixed,
>> +	 * report the error to userspace.
>> +	 */
>> +	if (is_error_noslot_pfn(pfn))
>> +		return false;
>> +
>> +	kvm_release_pfn_clean(pfn);
>> +
>> +	/* The instructions are well-emulated on direct mmu. */
>> +	if (vcpu->arch.mmu.direct_map) {
>> +		unsigned int indirect_shadow_pages;
>> +
>> +		spin_lock(&vcpu->kvm->mmu_lock);
>> +		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
>> +		spin_unlock(&vcpu->kvm->mmu_lock);
>> +
>> +		if (indirect_shadow_pages)
>> +			kvm_mmu_unprotect_page(vcpu->kvm, gfn);
>> +
>>  		return true;
>>  	}
>>
>> -	return false;
>> +again:
>> +	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
>> +
>> +	/*
>> +	 * The instruction emulation is caused by fault access on cr2.
>> +	 * After unprotect the target page, we call
>> +	 * vcpu->arch.mmu.page_fault to fix the mapping of cr2. If it
>> +	 * return 1, mmu can not fix the mapping, we should report the
>> +	 * error, otherwise it is good to return to guest and let it
>> +	 * re-execute the instruction again.
>> +	 *
>> +	 * page_fault_count is used to avoid the race on other vcpus,
>> +	 * since after we unprotect the target page, other cpu can enter
>> +	 * page fault path and let the page be write-protected again.
>> +	 */
>> +	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
>> +	emulate = vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, false);
>> +
>> +	/* The page fault path called above can increase the count. */
>> +	if (page_fault_count + 1 !=
>> +		  ACCESS_ONCE(vcpu->kvm->arch.page_fault_count))
>> +		goto again;
>> +
>> +	return !emulate;
>>  }
>>
>>  static bool retry_instruction(struct x86_emulate_ctxt *ctxt,\
> 
> Same comment as before: the only case where it should not attempt to 
> emulate is when there is a condition which makes it impossible to fix
> (the information is available to detect that condition).
> 
> The earlier suggestion
> 
> 	"How about recording the gfn number for shadow pages that have been
> shadowed in the current pagefault run?"
> 
> Was about that.

I think we can have a try. Is this change good to you, Marcelo?

[eric@localhost kvm]$ git diff
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 01d7c2a..e3d0001 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4359,24 +4359,34 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
        return nr_mmu_pages;
 }

-int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
+void kvm_mmu_get_sp_hierarchy(struct kvm_vcpu *vcpu, u64 addr,
+                             struct kvm_mmu_sp_hierarchy *hierarchy)
 {
        struct kvm_shadow_walk_iterator iterator;
        u64 spte;
-       int nr_sptes = 0;
+
+       hierarchy->max_level = hierarchy->nr_levels = 0;

        walk_shadow_page_lockless_begin(vcpu);
        for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
-               sptes[iterator.level-1] = spte;
-               nr_sptes++;
+               struct kvm_mmu_page *sp =  page_header(__pa(iterator.sptep));
+
+               if (hierarchy->indirect_only && sp->role.direct)
+                       break;
+
+               if (!hierarchy->max_level)
+                       hierarchy->max_level = iterator.level;
+
+               hierarchy->shadow_gfns[iterator.level-1] = sp->gfn;
+               hierarchy->sptes[iterator.level-1] = spte;
+               hierarchy->nr_levels++;
+
                if (!is_shadow_present_pte(spte))
                        break;
        }
        walk_shadow_page_lockless_end(vcpu);
-
-       return nr_sptes;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_get_spte_hierarchy);
+EXPORT_SYMBOL_GPL(kvm_mmu_get_sp_hierarchy);

 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6987108..d7ba397 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -50,7 +50,17 @@
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)

-int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
+struct kvm_mmu_sp_hierarchy {
+       int max_level;
+       int nr_levels;
+       bool indirect_only;
+
+       u64 sptes[PT64_ROOT_LEVEL];
+       gfn_t shadow_gfns[PT64_ROOT_LEVEL];
+};
+
+void kvm_mmu_get_sp_hierarchy(struct kvm_vcpu *vcpu, u64 addr,
+                             struct kvm_mmu_sp_hierarchy *hierarchy);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d14bb12..9c60f8c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4984,8 +4984,8 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,

 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
 {
-       u64 sptes[4];
-       int nr_sptes, i, ret;
+       struct kvm_mmu_sp_hierarchy hierarchy;
+       int i, ret;
        gpa_t gpa;

        gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
@@ -5001,10 +5001,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
        printk(KERN_ERR "EPT: Misconfiguration.\n");
        printk(KERN_ERR "EPT: GPA: 0x%llx\n", gpa);

-       nr_sptes = kvm_mmu_get_spte_hierarchy(vcpu, gpa, sptes);
-
-       for (i = PT64_ROOT_LEVEL; i > PT64_ROOT_LEVEL - nr_sptes; --i)
-               ept_misconfig_inspect_spte(vcpu, sptes[i-1], i);
+       kvm_mmu_get_sp_hierarchy(vcpu, gpa, &hierarchy);
+
+       for (i = hierarchy.max_level; hierarchy.nr_levels; hierarchy.nr_levels--, i--)
+                       ept_misconfig_inspect_spte(vcpu, hierarchy.sptes[i-1], i);

        vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
        vcpu->run->hw.hardware_exit_reason = EXIT_REASON_EPT_MISCONFIG;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1056106..cee6242 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4755,11 +4755,11 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)

 static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 {
+       struct kvm_mmu_sp_hierarchy hierarchy;
        gpa_t gpa = cr2;
        gfn_t gfn;
        pfn_t pfn;
-       u64 page_fault_count;
-       int emulate;
+       int level;

        if (!vcpu->arch.mmu.direct_map) {
                /*
@@ -4809,30 +4809,14 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
                return true;
        }

-again:
-       page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
+       hierarchy.indirect_only = true;
+       kvm_mmu_get_sp_hierarchy(vcpu, cr2, &hierarchy);

-       /*
-        * The instruction emulation is caused by fault access on cr2.
-        * After unprotect the target page, we call
-        * vcpu->arch.mmu.page_fault to fix the mapping of cr2. If it
-        * return 1, mmu can not fix the mapping, we should report the
-        * error, otherwise it is good to return to guest and let it
-        * re-execute the instruction again.
-        *
-        * page_fault_count is used to avoid the race on other vcpus,
-        * since after we unprotect the target page, other cpu can enter
-        * page fault path and let the page be write-protected again.
-        */
-       kvm_mmu_unprotect_page(vcpu->kvm, gfn);
-       emulate = vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, false);
-
-       /* The page fault path called above can increase the count. */
-       if (page_fault_count + 1 !=
-                 ACCESS_ONCE(vcpu->kvm->arch.page_fault_count))
-               goto again;
+       for (level = hierarchy.max_level; hierarchy.nr_levels > 0; level--, hierarchy.nr_levels--)
+               if (hierarchy.shadow_gfns[level - 1] == gfn)
+                       return false;

-       return !emulate;
+       return true;
 }


