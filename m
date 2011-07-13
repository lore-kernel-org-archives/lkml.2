Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1GMPdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:33:21 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33763 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab1GMPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37C-01-0C8-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 5/7] KVM: SVM: Remove nested.hsave state
Date: Wed, 13 Jul 2011 17:32:23 +0200
Message-ID: <1310571145-28930-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>

All state is keept in svm->host_vmcb so the hsave is not
necessary anymore, so remote it.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/svm.c |  151 ++++++++++++++--------------------------------------
 1 files changed, 41 insertions(+), 110 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6dacf59..f2cca2c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -82,7 +82,6 @@ static const u32 host_save_user_msrs[] = {
 struct kvm_vcpu;
 
 struct nested_state {
-	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb;
@@ -247,8 +246,8 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
-	c = &svm->vmcb->control;
-	h = &svm->nested.hsave->control;
+	c = &svm->nested.n_vmcb->control;
+	h = &svm->host_vmcb->control;
 	g = &svm->nested;
 
 	c->intercept_cr = h->intercept_cr | g->intercept_cr;
@@ -257,17 +256,9 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept = h->intercept | g->intercept;
 }
 
-static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
-{
-	if (is_guest_mode(&svm->vcpu))
-		return svm->nested.hsave;
-	else
-		return svm->vmcb;
-}
-
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_cr |= (1U << bit);
 
@@ -276,7 +267,7 @@ static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_cr &= ~(1U << bit);
 
@@ -285,14 +276,14 @@ static inline void clr_cr_intercept(struct vcpu_svm *svm, int bit)
 
 static inline bool is_cr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	return vmcb->control.intercept_cr & (1U << bit);
 }
 
 static inline void set_dr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_dr |= (1U << bit);
 
@@ -301,7 +292,7 @@ static inline void set_dr_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void clr_dr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_dr &= ~(1U << bit);
 
@@ -310,7 +301,7 @@ static inline void clr_dr_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_exceptions |= (1U << bit);
 
@@ -319,7 +310,7 @@ static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept_exceptions &= ~(1U << bit);
 
@@ -328,7 +319,7 @@ static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void set_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept |= (1ULL << bit);
 
@@ -337,7 +328,7 @@ static inline void set_intercept(struct vcpu_svm *svm, int bit)
 
 static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 {
-	struct vmcb *vmcb = get_host_vmcb(svm);
+	struct vmcb *vmcb = svm->host_vmcb;
 
 	vmcb->control.intercept &= ~(1ULL << bit);
 
@@ -947,9 +938,9 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	u64 g_tsc_offset = 0;
 
 	if (is_guest_mode(vcpu)) {
-		g_tsc_offset = svm->vmcb->control.tsc_offset -
-			       svm->nested.hsave->control.tsc_offset;
-		svm->nested.hsave->control.tsc_offset = offset;
+		g_tsc_offset = svm->host_vmcb->control.tsc_offset -
+			       svm->nested.n_vmcb->control.tsc_offset;
+		svm->nested.n_vmcb->control.tsc_offset = offset;
 	}
 
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
@@ -963,7 +954,7 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 
 	svm->vmcb->control.tsc_offset += adjustment;
 	if (is_guest_mode(vcpu))
-		svm->nested.hsave->control.tsc_offset += adjustment;
+		svm->nested.n_vmcb->control.tsc_offset += adjustment;
 	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
@@ -1154,7 +1145,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	struct vcpu_svm *svm;
 	struct page *page;
 	struct page *msrpm_pages;
-	struct page *hsave_page;
 	struct page *nested_msrpm_pages;
 	int err;
 
@@ -1183,12 +1173,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!nested_msrpm_pages)
 		goto free_page2;
 
-	hsave_page = alloc_page(GFP_KERNEL);
-	if (!hsave_page)
-		goto free_page3;
-
-	svm->nested.hsave = page_address(hsave_page);
-
 	svm->msrpm = page_address(msrpm_pages);
 	svm_vcpu_init_msrpm(svm->msrpm);
 
@@ -1206,7 +1190,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	err = fx_init(&svm->vcpu);
 	if (err)
-		goto free_page4;
+		goto free_page3;
 
 	svm->vcpu.arch.apic_base = 0xfee00000 | MSR_IA32_APICBASE_ENABLE;
 	if (kvm_vcpu_is_bsp(&svm->vcpu))
@@ -1214,8 +1198,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	return &svm->vcpu;
 
-free_page4:
-	__free_page(hsave_page);
 free_page3:
 	__free_pages(nested_msrpm_pages, MSRPM_ALLOC_ORDER);
 free_page2:
@@ -1238,7 +1220,6 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 		__free_page(virt_to_page(svm->nested.n_vmcb));
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
-	__free_page(virt_to_page(svm->nested.hsave));
 	__free_pages(virt_to_page(svm->nested.msrpm), MSRPM_ALLOC_ORDER);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
@@ -2169,40 +2150,9 @@ static int nested_svm_exit_handled(struct vcpu_svm *svm)
 	return vmexit;
 }
 
-static inline void copy_vmcb_control_area(struct vmcb *dst_vmcb, struct vmcb *from_vmcb)
-{
-	struct vmcb_control_area *dst  = &dst_vmcb->control;
-	struct vmcb_control_area *from = &from_vmcb->control;
-
-	dst->intercept_cr         = from->intercept_cr;
-	dst->intercept_dr         = from->intercept_dr;
-	dst->intercept_exceptions = from->intercept_exceptions;
-	dst->intercept            = from->intercept;
-	dst->iopm_base_pa         = from->iopm_base_pa;
-	dst->msrpm_base_pa        = from->msrpm_base_pa;
-	dst->tsc_offset           = from->tsc_offset;
-	dst->asid                 = from->asid;
-	dst->tlb_ctl              = from->tlb_ctl;
-	dst->int_ctl              = from->int_ctl;
-	dst->int_vector           = from->int_vector;
-	dst->int_state            = from->int_state;
-	dst->exit_code            = from->exit_code;
-	dst->exit_code_hi         = from->exit_code_hi;
-	dst->exit_info_1          = from->exit_info_1;
-	dst->exit_info_2          = from->exit_info_2;
-	dst->exit_int_info        = from->exit_int_info;
-	dst->exit_int_info_err    = from->exit_int_info_err;
-	dst->nested_ctl           = from->nested_ctl;
-	dst->event_inj            = from->event_inj;
-	dst->event_inj_err        = from->event_inj_err;
-	dst->nested_cr3           = from->nested_cr3;
-	dst->lbr_ctl              = from->lbr_ctl;
-}
-
 static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
-	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->nested.n_vmcb;
 	struct page *page;
 
@@ -2280,38 +2230,30 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->vmcb = svm->host_vmcb;
 	svm->vmcb_pa = __pa(svm->host_vmcb);
 
-	/* Restore the original control entries */
-	copy_vmcb_control_area(svm->host_vmcb, hsave);
-
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
 	svm->nested.nested_cr3 = 0;
 
 	/* Restore selected save entries */
-	svm->vmcb->save.es = hsave->save.es;
-	svm->vmcb->save.cs = hsave->save.cs;
-	svm->vmcb->save.ss = hsave->save.ss;
-	svm->vmcb->save.ds = hsave->save.ds;
-	svm->vmcb->save.gdtr = hsave->save.gdtr;
-	svm->vmcb->save.idtr = hsave->save.idtr;
-	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
-	svm_set_efer(&svm->vcpu, hsave->save.efer);
-	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
-	svm_set_cr4(&svm->vcpu, hsave->save.cr4);
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = hsave->save.cr3;
-		svm->vcpu.arch.cr3 = hsave->save.cr3;
-	} else {
-		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
-	}
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, hsave->save.rax);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
+	kvm_set_rflags(&svm->vcpu, svm->host_vmcb->save.rflags);
+	svm_set_efer(&svm->vcpu, svm->host_vmcb->save.efer);
+	svm_set_cr0(&svm->vcpu, svm->host_vmcb->save.cr0 | X86_CR0_PE);
+	svm_set_cr4(&svm->vcpu, svm->host_vmcb->save.cr4);
+
+	if (npt_enabled)
+		svm->vcpu.arch.cr3 = svm->host_vmcb->save.cr3;
+	else
+		kvm_set_cr3(&svm->vcpu, svm->host_vmcb->save.cr3);
+
 	svm->vmcb->save.dr7 = 0;
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
 
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RAX, svm->host_vmcb->save.rax);
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, svm->host_vmcb->save.rsp);
+	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, svm->host_vmcb->save.rip);
+
 	mark_all_dirty(svm->vmcb);
 
 	nested_svm_unmap(page);
@@ -2373,8 +2315,6 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 static bool nested_svm_vmrun(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
-	struct vmcb *hsave = svm->nested.hsave;
-	struct vmcb *vmcb = svm->vmcb;
 	struct page *page;
 	u64 vmcb_gpa;
 
@@ -2414,25 +2354,16 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	 * Save the old vmcb, so we don't need to pick what we save, but can
 	 * restore everything when a VMEXIT occurs
 	 */
-	hsave->save.es     = vmcb->save.es;
-	hsave->save.cs     = vmcb->save.cs;
-	hsave->save.ss     = vmcb->save.ss;
-	hsave->save.ds     = vmcb->save.ds;
-	hsave->save.gdtr   = vmcb->save.gdtr;
-	hsave->save.idtr   = vmcb->save.idtr;
-	hsave->save.efer   = svm->vcpu.arch.efer;
-	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	hsave->save.cr4    = svm->vcpu.arch.cr4;
-	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
-	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
-	hsave->save.rsp    = vmcb->save.rsp;
-	hsave->save.rax    = vmcb->save.rax;
-	if (npt_enabled)
-		hsave->save.cr3    = vmcb->save.cr3;
-	else
-		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
+	svm->host_vmcb->save.efer   = svm->vcpu.arch.efer;
+	svm->host_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
+	svm->host_vmcb->save.cr4    = svm->vcpu.arch.cr4;
+	svm->host_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
+	svm->host_vmcb->save.rax    = svm->vcpu.arch.regs[VCPU_REGS_RAX];
+	svm->host_vmcb->save.rsp    = svm->vcpu.arch.regs[VCPU_REGS_RSP];
+	svm->host_vmcb->save.rip    = svm->vcpu.arch.regs[VCPU_REGS_RIP];
 
-	copy_vmcb_control_area(hsave, vmcb);
+	if (!npt_enabled)
+		svm->host_vmcb->save.cr3 = kvm_read_cr3(&svm->vcpu);
 
 	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
 		svm->vcpu.arch.hflags |= HF_HIF_MASK;
@@ -2478,7 +2409,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
 		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
 	} else
-		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+		kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
@@ -2942,7 +2873,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		struct vmcb *vmcb = get_host_vmcb(svm);
+		struct vmcb *vmcb = svm->host_vmcb;
 
 		*data = vmcb->control.tsc_offset +
 			svm_scale_tsc(vcpu, native_read_tsc());
-- 
1.7.4.1


