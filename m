Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3AEIQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 03:16:48 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47601 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3AEIQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 03:16:47 -0500
Message-ID: <50E7E165.6000107@linux.vnet.ibm.com>
Date: Sat, 05 Jan 2013 16:16:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] KVM: x86: improve reexecute_instruction
References: <50E6DEDC.7040800@linux.vnet.ibm.com> <50E6DFAB.6050008@linux.vnet.ibm.com> <20130104224432.GB13481@amt.cnet>
In-Reply-To: <20130104224432.GB13481@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010508-5490-0000-0000-000002C068C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 06:44 AM, Marcelo Tosatti wrote:

>> index b0a3678..44c6992 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4756,15 +4756,8 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
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
> 
> This renders the previous patch obsolete, pretty much (please fold).

Will try.

> 
>>  	if (!vcpu->arch.mmu.direct_map) {
>>  		/*
>> @@ -4781,13 +4774,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  			return true;
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
>> @@ -4795,13 +4782,38 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
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
> 
> !direct_map?

No. This logic is, if it is direct mmu, we just unprotect the page shadowed by
nested mmu, then let guest retry the instruction, no need to detect unhandlable
instruction.

> 
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
>> +	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
>> +
>> +	/* If the target gfn is used as page table, the fault can
>> +	 * not be avoided by unprotecting shadow page and it will
>> +	 * be reported to userspace.
>> +	 */
>> +	return !vcpu->arch.target_gfn_is_pt;
>>  }
> 
> The idea was
> 
> How about recording the gfn number for shadow pages that have been
> shadowed in the current pagefault run? (which is cheap, compared to
> shadowing these pages).
> 
> If failed instruction emulation is write to one of these gfns, then
> fail.

If i understood correctly, i do not think it is simpler than the way in this
patch.

There is the change to apply the idea:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c431b33..2163de8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -502,6 +502,8 @@ struct kvm_vcpu_arch {
 		u64 msr_val;
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
+
+	gfn_t pt_gfns[4];
 };

 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 0453fa0..ac4210f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -523,6 +523,18 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
 	return false;
 }

+static void FNAME(cache_pt_gfns)(struct kvm_vcpu *vcpu, struct guest_walker *walker)
+{
+	int level;
+
+	/* Reset all gfns to -1, then we can detect the levels which is not used in guest. */
+	for (level = 0; level < 4; level++)
+		vcpu->arch.pt_gfns[level] = (gfn_t)(-1);
+
+	for (level = walker->level; level <= walker->max_level; level++)
+		vcpu->arch.pt_gfns[level - 1] = walker->table_gfn[level - 1];
+}
+
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -576,6 +588,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		return 0;
 	}

+	 FNAME(cache_pt_gfns)(vcpu, &walker);
+
 	if (walker.level >= PT_DIRECTORY_LEVEL)
 		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn)
 		   || FNAME(is_self_change_mapping)(vcpu, &walker, user_fault);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0a3678..b86ee24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4753,18 +4753,25 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

+static bool is_gfn_used_as_pt(struct kvm_vcpu *vcpu, gfn_t gfn)
+{
+	int level;
+
+	for (level = 0; level < 4; level++) {
+		if (vcpu->arch.pt_gfns[level] == (gfn_t)-1)
+			continue;
+		if (gfn == vcpu->arch.pt_gfns[level])
+			return true;
+	}
+
+	return false;
+}
+
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 {
 	gpa_t gpa = cr2;
+	gfn_t gfn;
 	pfn_t pfn;
-	unsigned int indirect_shadow_pages;
-
-	spin_lock(&vcpu->kvm->mmu_lock);
-	indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
-	spin_unlock(&vcpu->kvm->mmu_lock);
-
-	if (!indirect_shadow_pages)
-		return false;

 	if (!vcpu->arch.mmu.direct_map) {
 		/*
@@ -4781,13 +4788,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 			return true;
 	}

-	/*
-	 * if emulation was due to access to shadowed page table
-	 * and it failed try to unshadow page and re-enter the
-	 * guest to let CPU execute the instruction.
-	 */
-	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
-		return true;
+	gfn = gpa_to_gfn(gpa);

 	/*
 	 * Do not retry the unhandleable instruction if it faults on the
@@ -4795,13 +4796,38 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 	 * retry instruction -> write #PF -> emulation fail -> retry
 	 * instruction -> ...
 	 */
-	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-	if (!is_error_noslot_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
+	pfn = gfn_to_pfn(vcpu->kvm, gfn);
+
+	/*
+	 * If the instruction failed on the error pfn, it can not be fixed,
+	 * report the error to userspace.
+	 */
+	if (is_error_noslot_pfn(pfn))
+		return false;
+
+	kvm_release_pfn_clean(pfn);
+
+	/* The instructions are well-emulated on direct mmu. */
+	if (vcpu->arch.mmu.direct_map) {
+		unsigned int indirect_shadow_pages;
+
+		spin_lock(&vcpu->kvm->mmu_lock);
+		indirect_shadow_pages = vcpu->kvm->arch.indirect_shadow_pages;
+		spin_unlock(&vcpu->kvm->mmu_lock);
+
+		if (indirect_shadow_pages)
+			kvm_mmu_unprotect_page(vcpu->kvm, gfn);
+
 		return true;
 	}

-	return false;
+	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
+
+	/* If the target gfn is used as page table, the fault can
+	 * not be avoided by unprotecting shadow page and it will
+	 * be reported to userspace.
+	 */
+	return !is_gfn_used_as_pt(vcpu, gfn);
 }

 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,


You can see we need to record more things in the vcpu struct (bool vs. gfn_t [4])
and my patch can fold is_gfn_used_as_pt into a existed function FNAME(is_self_change_mapping).

Hmm?

