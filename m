Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1K1Mm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:42:29 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43312 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1K1Mm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:42:26 -0500
Message-ID: <4ED381A8.8070402@linux.vnet.ibm.com>
Date: Mon, 28 Nov 2011 20:42:16 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/5] KVM: MMU: move the relevant mmu code to mmu.c
References: <4ED3811F.1070101@linux.vnet.ibm.com>
In-Reply-To: <4ED3811F.1070101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11112802-7014-0000-0000-0000002A3FD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the mmu code in kvm_arch_vcpu_init() to kvm_mmu_create()

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    6 ++++++
 arch/x86/kvm/mmu.c              |    6 +++++-
 arch/x86/kvm/x86.c              |   11 +----------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1769f3d..020413a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -752,6 +752,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
 void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access);
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 			      struct x86_exception *exception);
 gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
@@ -773,6 +774,11 @@ void kvm_disable_tdp(void);
 int complete_pio(struct kvm_vcpu *vcpu);
 bool kvm_check_iopl(struct kvm_vcpu *vcpu);

+static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
+{
+	return gpa;
+}
+
 static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 {
 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 62f69db..262a3af 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3839,7 +3839,11 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
-	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
+
+	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
+	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.translate_gpa = translate_gpa;
+	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;

 	return alloc_mmu_pages(vcpu);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b6fd72..45c8640 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3427,12 +3427,7 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->get_segment(vcpu, var, seg);
 }

-static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
-{
-	return gpa;
-}
-
-static gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
+gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
 {
 	gpa_t t_gpa;
 	struct x86_exception exception;
@@ -5912,10 +5907,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	kvm = vcpu->kvm;

 	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
-	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
-	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
-	vcpu->arch.mmu.translate_gpa = translate_gpa;
-	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
 	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
-- 
1.7.7.3

