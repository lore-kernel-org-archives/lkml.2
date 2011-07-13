Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1GMPdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:33:35 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:25205 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1GMPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:20 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37B-01-0C4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 4/7] KVM: SVM: Use seperate VMCB for L2 guests
Date: Wed, 13 Jul 2011 17:32:22 +0200
Message-ID: <1310571145-28930-5-git-send-email-joerg.roedel@amd.com>
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

Move torwards emulation of VMCB-clean-bits by using a
seperate VMCB when running L2 guests.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/svm.c |   43 ++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f81e35e..6dacf59 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -105,6 +105,8 @@ struct nested_state {
 
 	/* Nested Paging related state */
 	u64 nested_cr3;
+
+	struct vmcb *n_vmcb;
 };
 
 #define MSRPM_OFFSETS	16
@@ -974,6 +976,26 @@ static u64 svm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
 	return target_tsc - tsc;
 }
 
+static bool init_nested_vmcb(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *hc, *nc;
+
+	svm->nested.n_vmcb = (void *)get_zeroed_page(GFP_KERNEL);
+	if (svm->nested.n_vmcb == NULL)
+		return false;
+
+	nc = &svm->nested.n_vmcb->control;
+	hc = &svm->host_vmcb->control;
+
+	nc->iopm_base_pa		= hc->iopm_base_pa;
+	nc->msrpm_base_pa		= hc->msrpm_base_pa;
+	nc->nested_ctl			= hc->nested_ctl;
+	nc->pause_filter_count		= hc->pause_filter_count;
+	svm->nested.n_vmcb->save.g_pat	= svm->host_vmcb->save.g_pat;
+
+	return true;
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -1212,6 +1234,8 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (svm->nested.n_vmcb != NULL)
+		__free_page(virt_to_page(svm->nested.n_vmcb));
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
 	__free_page(virt_to_page(svm->nested.hsave));
@@ -2179,7 +2203,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
-	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb *vmcb = svm->nested.n_vmcb;
 	struct page *page;
 
 	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
@@ -2252,8 +2276,12 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
+	/* Switch VMCB back to host */
+	svm->vmcb = svm->host_vmcb;
+	svm->vmcb_pa = __pa(svm->host_vmcb);
+
 	/* Restore the original control entries */
-	copy_vmcb_control_area(vmcb, hsave);
+	copy_vmcb_control_area(svm->host_vmcb, hsave);
 
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
@@ -2431,6 +2459,10 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		nested_svm_init_mmu_context(&svm->vcpu);
 	}
 
+	/* Switch VMCB */
+	svm->vmcb    = svm->nested.n_vmcb;
+	svm->vmcb_pa = __pa(svm->nested.n_vmcb);
+
 	/* Load the nested guest state */
 	svm->vmcb->save.es = nested_vmcb->save.es;
 	svm->vmcb->save.cs = nested_vmcb->save.cs;
@@ -2477,7 +2509,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
-	svm->vmcb->control.tsc_offset += nested_vmcb->control.tsc_offset;
+	svm->vmcb->control.tsc_offset = svm->host_vmcb->control.tsc_offset + nested_vmcb->control.tsc_offset;
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
@@ -2566,6 +2598,11 @@ static int vmrun_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
+	if (unlikely(svm->nested.n_vmcb == NULL)) {
+		if (!init_nested_vmcb(svm))
+			goto failed;
+	}
+
 	/* Save rip after vmrun instruction */
 	kvm_rip_write(&svm->vcpu, kvm_rip_read(&svm->vcpu) + 3);
 
-- 
1.7.4.1


