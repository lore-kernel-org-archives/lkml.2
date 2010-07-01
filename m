Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271Ab0GAVbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:31:33 -0400
Received: from kroah.org ([198.145.64.141]:33200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132Ab0GAVPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:15 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.562265553@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [178/200] KVM: SVM: Dont use kmap_atomic in nested_svm_map
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Use of kmap_atomic disables preemption but if we run in
shadow-shadow mode the vmrun emulation executes kvm_set_cr3
which might sleep or fault. So use kmap instead for
nested_svm_map.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 7597f129d8b6799da7a264e6d6f7401668d3a36d)
---
 arch/x86/kvm/svm.c |   47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1423,7 +1423,7 @@ static inline int nested_svm_intr(struct
 	return 0;
 }
 
-static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, enum km_type idx)
+static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
 {
 	struct page *page;
 
@@ -1431,7 +1431,9 @@ static void *nested_svm_map(struct vcpu_
 	if (is_error_page(page))
 		goto error;
 
-	return kmap_atomic(page, idx);
+	*_page = page;
+
+	return kmap(page);
 
 error:
 	kvm_release_page_clean(page);
@@ -1440,16 +1442,9 @@ error:
 	return NULL;
 }
 
-static void nested_svm_unmap(void *addr, enum km_type idx)
+static void nested_svm_unmap(struct page *page)
 {
-	struct page *page;
-
-	if (!addr)
-		return;
-
-	page = kmap_atomic_to_page(addr);
-
-	kunmap_atomic(addr, idx);
+	kunmap(page);
 	kvm_release_page_dirty(page);
 }
 
@@ -1457,6 +1452,7 @@ static bool nested_svm_exit_handled_msr(
 {
 	u32 param = svm->vmcb->control.exit_info_1 & 1;
 	u32 msr = svm->vcpu.arch.regs[VCPU_REGS_RCX];
+	struct page *page;
 	bool ret = false;
 	u32 t0, t1;
 	u8 *msrpm;
@@ -1464,7 +1460,7 @@ static bool nested_svm_exit_handled_msr(
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_MSR_PROT)))
 		return false;
 
-	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
 
 	if (!msrpm)
 		goto out;
@@ -1492,7 +1488,7 @@ static bool nested_svm_exit_handled_msr(
 	ret = msrpm[t1] & ((1 << param) << t0);
 
 out:
-	nested_svm_unmap(msrpm, KM_USER0);
+	nested_svm_unmap(page);
 
 	return ret;
 }
@@ -1615,6 +1611,7 @@ static int nested_svm_vmexit(struct vcpu
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
+	struct page *page;
 
 	trace_kvm_nested_vmexit_inject(vmcb->control.exit_code,
 				       vmcb->control.exit_info_1,
@@ -1622,7 +1619,7 @@ static int nested_svm_vmexit(struct vcpu
 				       vmcb->control.exit_int_info,
 				       vmcb->control.exit_int_info_err);
 
-	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->nested.vmcb, &page);
 	if (!nested_vmcb)
 		return 1;
 
@@ -1712,7 +1709,7 @@ static int nested_svm_vmexit(struct vcpu
 	/* Exit nested SVM mode */
 	svm->nested.vmcb = 0;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	kvm_mmu_reset_context(&svm->vcpu);
 	kvm_mmu_load(&svm->vcpu);
@@ -1723,9 +1720,10 @@ static int nested_svm_vmexit(struct vcpu
 static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
 {
 	u32 *nested_msrpm;
+	struct page *page;
 	int i;
 
-	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, KM_USER0);
+	nested_msrpm = nested_svm_map(svm, svm->nested.vmcb_msrpm, &page);
 	if (!nested_msrpm)
 		return false;
 
@@ -1734,7 +1732,7 @@ static bool nested_svm_vmrun_msrpm(struc
 
 	svm->vmcb->control.msrpm_base_pa = __pa(svm->nested.msrpm);
 
-	nested_svm_unmap(nested_msrpm, KM_USER0);
+	nested_svm_unmap(page);
 
 	return true;
 }
@@ -1744,8 +1742,9 @@ static bool nested_svm_vmrun(struct vcpu
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
 	struct vmcb *vmcb = svm->vmcb;
+	struct page *page;
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return false;
 
@@ -1857,7 +1856,7 @@ static bool nested_svm_vmrun(struct vcpu
 	svm->vmcb->control.event_inj = nested_vmcb->control.event_inj;
 	svm->vmcb->control.event_inj_err = nested_vmcb->control.event_inj_err;
 
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	enable_gif(svm);
 
@@ -1883,6 +1882,7 @@ static void nested_svm_vmloadsave(struct
 static int vmload_interception(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
+	struct page *page;
 
 	if (nested_svm_check_permissions(svm))
 		return 1;
@@ -1890,12 +1890,12 @@ static int vmload_interception(struct vc
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	return 1;
 }
@@ -1903,6 +1903,7 @@ static int vmload_interception(struct vc
 static int vmsave_interception(struct vcpu_svm *svm)
 {
 	struct vmcb *nested_vmcb;
+	struct page *page;
 
 	if (nested_svm_check_permissions(svm))
 		return 1;
@@ -1910,12 +1911,12 @@ static int vmsave_interception(struct vc
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
 	skip_emulated_instruction(&svm->vcpu);
 
-	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, KM_USER0);
+	nested_vmcb = nested_svm_map(svm, svm->vmcb->save.rax, &page);
 	if (!nested_vmcb)
 		return 1;
 
 	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
-	nested_svm_unmap(nested_vmcb, KM_USER0);
+	nested_svm_unmap(page);
 
 	return 1;
 }


