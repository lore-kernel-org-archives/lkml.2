Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2LJJPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:15:00 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:37853 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2LJJO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:14:57 -0500
Message-ID: <50C5A807.4070301@linux.vnet.ibm.com>
Date: Mon, 10 Dec 2012 17:14:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/5] KVM: x86: improve reexecute_instruction
References: <50C5A747.1020105@linux.vnet.ibm.com>
In-Reply-To: <50C5A747.1020105@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121009-3864-0000-0000-000005EE8279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current reexecute_instruction can not well detect the failed instruction
emulation. It allows guest to retry all the instructions except it accesses
on error pfn

For example, some cases are nested-write-protect - if the page we want to
write is used as PDE but it chains to itself. Under this case, we should
stop the emulation and report the case to userspace

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/paging_tmpl.h      |    2 +
 arch/x86/kvm/x86.c              |   82 +++++++++++++++++++++++++++++----------
 3 files changed, 65 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dc87b65..8d01c02 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -575,6 +575,8 @@ struct kvm_arch {
 	u64 hv_guest_os_id;
 	u64 hv_hypercall;

+	/* synchronizing reexecute_instruction and page fault path. */
+	u64 page_fault_count;
 	#ifdef CONFIG_KVM_MMU_AUDIT
 	int audit_point;
 	#endif
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 32d77ff..85b8e0e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -614,6 +614,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;

+	vcpu->kvm->arch.page_fault_count++;
+
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
 	if (!force_pt_level)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3796f8c..5677869 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4756,29 +4756,27 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
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
+	u64 page_fault_count;
+	int emulate;

 	if (!vcpu->arch.mmu.direct_map) {
-		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
+		/*
+		 * Write permission should be allowed since only
+		 * write access need to be emulated.
+		 */
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
+
+		/*
+		 * If the mapping is invalid in guest, let cpu retry
+		 * it to generate fault.
+		 */
 		if (gpa == UNMAPPED_GVA)
-			return true; /* let cpu generate fault */
+			return true;
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
@@ -4786,13 +4784,55 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
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
+again:
+	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
+
+	/*
+	 * The instruction emulation is caused by fault access on cr2.
+	 * After unprotect the target page, we call
+	 * vcpu->arch.mmu.page_fault to fix the mapping of cr2. If it
+	 * return 1, mmu can not fix the mapping, we should report the
+	 * error, otherwise it is good to return to guest and let it
+	 * re-execute the instruction again.
+	 *
+	 * page_fault_count is used to avoid the race on other vcpus,
+	 * since after we unprotect the target page, other cpu can enter
+	 * page fault path and let the page be write-protected again.
+	 */
+	kvm_mmu_unprotect_page(vcpu->kvm, gfn);
+	emulate = vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, false);
+
+	/* The page fault path called above can increase the count. */
+	if (page_fault_count + 1 !=
+		  ACCESS_ONCE(vcpu->kvm->arch.page_fault_count))
+		goto again;
+
+	return !emulate;
 }

 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-- 
1.7.7.6

