Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038Ab2CGUCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:02:55 -0500
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:42431 "EHLO
	homiemail-a6.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754897Ab2CGUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:02:54 -0500
Subject: [PATCH] KVM: x86: add paging gcc optimization
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 07 Mar 2012 21:02:49 +0100
Message-ID: <1331150569.25969.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Since most guests will have paging enabled for memory management, add likely() and unlikely()
optimizations around is_paging() checks.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 arch/x86/kvm/mmu.c |    6 +++---
 arch/x86/kvm/svm.c |    6 +++---
 arch/x86/kvm/vmx.c |   16 ++++++++--------
 arch/x86/kvm/x86.c |    8 ++++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4cb1642..84f1e95 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3320,7 +3320,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 
-	if (!is_paging(vcpu)) {
+	if (unlikely(!is_paging(vcpu))) {
 		context->nx = false;
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
@@ -3351,7 +3351,7 @@ int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
 
-	if (!is_paging(vcpu))
+	if (unlikely(!is_paging(vcpu)))
 		r = nonpaging_init_context(vcpu, context);
 	else if (is_long_mode(vcpu))
 		r = paging64_init_context(vcpu, context);
@@ -3395,7 +3395,7 @@ static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * arch.nested_mmu.gva_to_gpa function. Basically the gva_to_gpa
 	 * functions between mmu and nested_mmu are swapped.
 	 */
-	if (!is_paging(vcpu)) {
+	if (unlikely(!is_paging(vcpu))) {
 		g_context->nx = false;
 		g_context->root_level = 0;
 		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 53efd59..3887fca 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1555,12 +1555,12 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
+		if (unlikely(!is_paging(vcpu)) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
 		}
 
-		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
+		if (likely(is_paging(vcpu)) && !(cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer &= ~EFER_LMA;
 			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
 		}
@@ -1991,7 +1991,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
 	if (!(svm->vcpu.arch.efer & EFER_SVME)
-	    || !is_paging(&svm->vcpu)) {
+	    || unlikely(!is_paging(&svm->vcpu))) {
 		kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 		return 1;
 	}
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c22fc7..f3144de 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2879,7 +2879,7 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 
 static void vmx_decache_cr3(struct kvm_vcpu *vcpu)
 {
-	if (enable_ept && is_paging(vcpu))
+	if (enable_ept && likely(is_paging(vcpu)))
 		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
 }
@@ -2898,7 +2898,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (likely(is_paging(vcpu)) && is_pae(vcpu) && !is_long_mode(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, vcpu->arch.mmu.pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, vcpu->arch.mmu.pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, vcpu->arch.mmu.pdptrs[2]);
@@ -2908,7 +2908,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 
 static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (likely(is_paging(vcpu)) && is_pae(vcpu) && !is_long_mode(vcpu)) {
 		vcpu->arch.mmu.pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		vcpu->arch.mmu.pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		vcpu->arch.mmu.pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
@@ -2937,7 +2937,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 			      CPU_BASED_CR3_STORE_EXITING));
 		vcpu->arch.cr0 = cr0;
 		vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-	} else if (!is_paging(vcpu)) {
+	} else if (unlikely(!is_paging(vcpu))) {
 		/* From nonpaging to paging */
 		vmcs_write32(CPU_BASED_VM_EXEC_CONTROL,
 			     vmcs_read32(CPU_BASED_VM_EXEC_CONTROL) &
@@ -2970,9 +2970,9 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
+		if (unlikely(!is_paging(vcpu)) && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
-		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
+		if (likely(is_paging(vcpu)) && !(cr0 & X86_CR0_PG))
 			exit_lmode(vcpu);
 	}
 #endif
@@ -3010,7 +3010,7 @@ static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (enable_ept) {
 		eptp = construct_eptp(cr3);
 		vmcs_write64(EPT_POINTER, eptp);
-		guest_cr3 = is_paging(vcpu) ? kvm_read_cr3(vcpu) :
+		guest_cr3 = likely(is_paging(vcpu)) ? kvm_read_cr3(vcpu) :
 			vcpu->kvm->arch.ept_identity_map_addr;
 		ept_load_pdptrs(vcpu);
 	}
@@ -3038,7 +3038,7 @@ static int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	vcpu->arch.cr4 = cr4;
 	if (enable_ept) {
-		if (!is_paging(vcpu)) {
+		if (unlikely(!is_paging(vcpu))) {
 			hw_cr4 &= ~X86_CR4_PAE;
 			hw_cr4 |= X86_CR4_PSE;
 		} else if (!(cr4 & X86_CR4_PAE)) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ce5878..84100d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -510,7 +510,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if ((cr0 & X86_CR0_PG) && !(cr0 & X86_CR0_PE))
 		return 1;
 
-	if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
+	if (unlikely(!is_paging(vcpu)) && (cr0 & X86_CR0_PG)) {
 #ifdef CONFIG_X86_64
 		if ((vcpu->arch.efer & EFER_LME)) {
 			int cs_db, cs_l;
@@ -597,7 +597,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE))
 			return 1;
-	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
+	} else if (likely(is_paging(vcpu)) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & pdptr_bits)
 		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
 				   kvm_read_cr3(vcpu)))
@@ -631,7 +631,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		if (is_pae(vcpu)) {
 			if (cr3 & CR3_PAE_RESERVED_BITS)
 				return 1;
-			if (is_paging(vcpu) &&
+			if (likely(is_paging(vcpu)) &&
 			    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 				return 1;
 		}
@@ -818,7 +818,7 @@ static int set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (efer & efer_reserved_bits)
 		return 1;
 
-	if (is_paging(vcpu)
+	if (likely(is_paging(vcpu))
 	    && (vcpu->arch.efer & EFER_LME) != (efer & EFER_LME))
 		return 1;
 
-- 
1.7.4.1



