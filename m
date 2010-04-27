Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0D0KjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:08 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:3909 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754698Ab0D0KjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:04 -0400
X-SpamScore: 0
X-BigFish: VPS0(zz10d1Iab9bhzz1202hzz6ff19hz32i2a8h87h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WQ-01-32Y-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/22] KVM: MMU: Introduce init_kvm_nested_mmu()
Date: Tue, 27 Apr 2010 12:38:29 +0200
Message-ID: <1272364712-17425-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0183 (UTC) FILETIME=[CA928A70:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the init_kvm_nested_mmu() function
which is used to re-initialize the nested mmu when the l2
guest changes its paging mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 54 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8bd40b5..af89e71 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2136,6 +2136,25 @@ static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
 	return gpa;
 }
 
+static gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
+{
+	gpa_t t_gpa;
+	u32 access;
+	u32 err;
+
+	BUG_ON(!vcpu->arch.mmu.nested);
+
+	/* NPT walks are treated as user writes */
+	access = PFERR_WRITE_MASK | PFERR_USER_MASK;
+	t_gpa  = vcpu->arch.nested_mmu.gva_to_gpa(vcpu, gpa, access, &err);
+	if (t_gpa == UNMAPPED_GVA) {
+		vcpu->arch.fault_address    = gpa;
+		vcpu->arch.fault_error_code = err | PFERR_NESTED_MASK;
+	}
+
+	return t_gpa;
+}
+
 static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 				  u32 access, u32 *error)
 {
@@ -2465,11 +2484,45 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
+	struct kvm_mmu *h_context = &vcpu->arch.mmu;
+
+	g_context->get_cr3           = get_cr3;
+	g_context->translate_gpa     = translate_nested_gpa;
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
+		h_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
+	} else if (is_long_mode(vcpu)) {
+		g_context->root_level = PT64_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else if (is_pae(vcpu)) {
+		g_context->root_level = PT32E_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+	} else {
+		g_context->root_level = PT32_ROOT_LEVEL;
+		h_context->gva_to_gpa = paging32_gva_to_gpa_nested;
+	}
+
+	return 0;
+}
+
 static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.update_pte.pfn = bad_pfn;
 
-	if (tdp_enabled)
+	if (vcpu->arch.mmu.nested)
+		return init_kvm_nested_mmu(vcpu);
+	else if (tdp_enabled)
 		return init_kvm_tdp_mmu(vcpu);
 	else
 		return init_kvm_softmmu(vcpu);
-- 
1.7.0.4


