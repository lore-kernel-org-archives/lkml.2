Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3AHGiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 01:38:10 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45030 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3AHGiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 01:38:08 -0500
Message-ID: <50EBBEC5.9040008@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2013 14:37:57 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 4/5] KVM: x86: let reexecute_instruction work for tdp
References: <50EBBE54.1040007@linux.vnet.ibm.com>
In-Reply-To: <50EBBE54.1040007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010806-7014-0000-0000-0000026E1725
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, reexecute_instruction refused to retry all instructions if
tdp is enabled. If nested npt is used, the emulation may be caused by
shadow page, it can be fixed by dropping the shadow page. And the only
condition that tdp can not retry the instruction is the access fault
on error pfn

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   61 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08cacd9..6f13e03 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4753,25 +4753,25 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2)
 {
-	gpa_t gpa;
+	gpa_t gpa = cr2;
 	pfn_t pfn;

-	if (tdp_enabled)
-		return false;
-
-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
-	if (gpa == UNMAPPED_GVA)
-		return true; /* let cpu generate fault */
+	if (!vcpu->arch.mmu.direct_map) {
+		/*
+		 * Write permission should be allowed since only
+		 * write access need to be emulated.
+		 */
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);

-	/*
-	 * if emulation was due to access to shadowed page table
-	 * and it failed try to unshadow page and re-enter the
-	 * guest to let CPU execute the instruction.
-	 */
-	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
-		return true;
+		/*
+		 * If the mapping is invalid in guest, let cpu retry
+		 * it to generate fault.
+		 */
+		if (gpa == UNMAPPED_GVA)
+			return true;
+	}

 	/*
 	 * Do not retry the unhandleable instruction if it faults on the
@@ -4780,12 +4780,37 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	 * instruction -> ...
 	 */
 	pfn = gfn_to_pfn(vcpu->kvm, gpa_to_gfn(gpa));
-	if (!is_error_noslot_pfn(pfn)) {
-		kvm_release_pfn_clean(pfn);
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
+			kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+
 		return true;
 	}

-	return false;
+	/*
+	 * if emulation was due to access to shadowed page table
+	 * and it failed try to unshadow page and re-enter the
+	 * guest to let CPU execute the instruction.
+	 */
+	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	return true;
 }

 static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
-- 
1.7.7.6

