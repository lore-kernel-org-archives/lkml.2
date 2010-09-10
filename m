Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0IJPhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:37:06 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57198 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab0IJPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:42 -0400
X-SpamScore: 0
X-BigFish: VS0(zz10d1Izz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF41-02-JQ6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/29] KVM: MMU: Introduce init_kvm_nested_mmu()
Date: Fri, 10 Sep 2010 17:30:54 +0200
Message-ID: <1284132667-18620-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the init_kvm_nested_mmu() function
which is used to re-initialize the nested mmu when the l2
guest changes its paging mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |   37 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/x86.c              |   17 +++++++++++++++++
 4 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5d9e0bb..87734cc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -811,3 +811,4 @@ void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
 #endif /* _ASM_X86_KVM_HOST_H */
+
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e215e8..a26f13b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2784,11 +2784,46 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
+
+	g_context->get_cr3           = get_cr3;
+	g_context->inject_page_fault = kvm_inject_page_fault;
+
+	/*
+	 * Note that arch.mmu.gva_to_gpa translates l2_gva to l1_gpa. The
+	 * translation of l2_gpa to l1_gpa addresses is done using the
+	 * arch.nested_mmu.gva_to_gpa function. Basically the gva_to_gpa
+	 * functions between mmu and nested_mmu are swapped.
+	 */
+	if (!is_paging(vcpu)) {
+		g_context->root_level = 0;
+		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
+	} else if (is_long_mode(vcpu)) {
+		reset_rsvds_bits_mask(vcpu, g_context, PT64_ROOT_LEVEL);
+		g_context->root_level = PT64_ROOT_LEVEL;
+		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else if (is_pae(vcpu)) {
+		reset_rsvds_bits_mask(vcpu, g_context, PT32E_ROOT_LEVEL);
+		g_context->root_level = PT32E_ROOT_LEVEL;
+		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else {
+		reset_rsvds_bits_mask(vcpu, g_context, PT32_ROOT_LEVEL);
+		g_context->root_level = PT32_ROOT_LEVEL;
+		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
+	}
+
+	return 0;
+}
+
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.update_pte.pfn = bad_pfn;
 
-	if (tdp_enabled)
+	if (mmu_is_nested(vcpu))
+		return init_kvm_nested_mmu(vcpu);
+	else if (tdp_enabled)
 		return init_kvm_tdp_mmu(vcpu);
 	else
 		return init_kvm_softmmu(vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 7086ca8..513abbb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -47,6 +47,7 @@
 #define PFERR_USER_MASK (1U << 2)
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
+#define PFERR_NESTED_MASK (1U << 31)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 540255d..307599d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3475,6 +3475,22 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
 	return gpa;
 }
 
+static gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
+{
+	gpa_t t_gpa;
+	u32 error;
+
+	BUG_ON(!mmu_is_nested(vcpu));
+
+	/* NPT walks are always user-walks */
+	access |= PFERR_USER_MASK;
+	t_gpa  = vcpu->arch.mmu.gva_to_gpa(vcpu, gpa, access, &error);
+	if (t_gpa == UNMAPPED_GVA)
+		vcpu->arch.fault.error_code |= PFERR_NESTED_MASK;
+
+	return t_gpa;
+}
+
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
@@ -5690,6 +5706,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	vcpu->arch.walk_mmu = &vcpu->arch.mmu;
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.translate_gpa = translate_gpa;
+	vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;
 	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
-- 
1.7.0.4


