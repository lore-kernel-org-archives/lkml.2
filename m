Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab0IFP65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:58:57 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25433
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754970Ab0IFP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:45 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-02-7A2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/27] KVM: X86: Introduce pointer to mmu context used for gva_to_gpa
Date: Mon, 6 Sep 2010 17:55:50 +0200
Message-ID: <1283788566-29186-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the walk_mmu pointer which points to
the mmu-context currently used for gva_to_gpa translations.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   14 ++++++++++++++
 arch/x86/kvm/mmu.c              |   10 +++++-----
 arch/x86/kvm/x86.c              |   17 ++++++++++-------
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index af8cce3..d797746 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -288,7 +288,21 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
 
+	/*
+	 * Paging state of the vcpu
+	 *
+	 * If the vcpu runs in guest mode with two level paging this still saves
+	 * the paging mode of the l1 guest. This context is always used to
+	 * handle faults.
+	 */
 	struct kvm_mmu mmu;
+
+	/*
+	 * Pointer to the mmu context currently used for
+	 * gva_to_gpa translations.
+	 */
+	struct kvm_mmu *walk_mmu;
+
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9668f91..a2cd2ce 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2707,7 +2707,7 @@ static int paging32E_init_context(struct kvm_vcpu *vcpu,
 
 static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = &vcpu->arch.mmu;
+	struct kvm_mmu *context = vcpu->arch.walk_mmu;
 
 	context->new_cr3 = nonpaging_new_cr3;
 	context->page_fault = tdp_page_fault;
@@ -2767,11 +2767,11 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
 static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
-	int r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
+	int r = kvm_init_shadow_mmu(vcpu, vcpu->arch.walk_mmu);
 
-	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
-	vcpu->arch.mmu.get_cr3           = get_cr3;
-	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
+	vcpu->arch.walk_mmu->set_cr3           = kvm_x86_ops->set_cr3;
+	vcpu->arch.walk_mmu->get_cr3           = get_cr3;
+	vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
 
 	return r;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 829efb0..e5dcf7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3441,27 +3441,27 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
-	return vcpu->arch.mmu.gva_to_gpa(vcpu, gva, access, error);
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, error);
 }
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_FETCH_MASK;
-	return vcpu->arch.mmu.gva_to_gpa(vcpu, gva, access, error);
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, error);
 }
 
 gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	access |= PFERR_WRITE_MASK;
-	return vcpu->arch.mmu.gva_to_gpa(vcpu, gva, access, error);
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, error);
 }
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
-	return vcpu->arch.mmu.gva_to_gpa(vcpu, gva, 0, error);
+	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, 0, error);
 }
 
 static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
@@ -3472,7 +3472,8 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 	int r = X86EMUL_CONTINUE;
 
 	while (bytes) {
-		gpa_t gpa = vcpu->arch.mmu.gva_to_gpa(vcpu, addr, access, error);
+		gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access,
+							    error);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
@@ -3527,8 +3528,9 @@ static int kvm_write_guest_virt_system(gva_t addr, void *val,
 	int r = X86EMUL_CONTINUE;
 
 	while (bytes) {
-		gpa_t gpa =  vcpu->arch.mmu.gva_to_gpa(vcpu, addr,
-						       PFERR_WRITE_MASK, error);
+		gpa_t gpa =  vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr,
+							     PFERR_WRITE_MASK,
+							     error);
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned towrite = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
@@ -5648,6 +5650,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	kvm = vcpu->kvm;
 
 	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
+	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.translate_gpa = translate_gpa;
 	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
-- 
1.7.0.4


