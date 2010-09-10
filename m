Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0IJPcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:32:43 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34481 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0IJPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:39 -0400
X-SpamScore: 9
X-BigFish: VS9(zz78fbpzz1202hzz8275bhz32i87h2a8h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF3Y-02-JPR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/29] KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
Date: Fri, 10 Sep 2010 17:30:40 +0200
Message-ID: <1284132667-18620-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary to implement Nested Nested Paging. As a
side effect this allows some cleanups in the SVM nested
paging code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 53cdf39..43c8db0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -236,6 +236,7 @@ struct kvm_pio_request {
  */
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
+	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5c28e97..c8acb96 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2714,6 +2714,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
+	context->set_cr3 = kvm_x86_ops->set_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2752,7 +2753,8 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 		r = paging32_init_context(vcpu);
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
-	vcpu->arch.mmu.base_role.cr0_wp = is_write_protection(vcpu);
+	vcpu->arch.mmu.base_role.cr0_wp  = is_write_protection(vcpu);
+	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 
 	return r;
 }
@@ -2796,7 +2798,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	/* set_cr3() should ensure TLB has been flushed */
-	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
+	vcpu->arch.mmu.set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 out:
 	return r;
 }
-- 
1.7.0.4


