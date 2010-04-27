Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab0D0KmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:44498
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754719Ab0D0KjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:00 -0400
X-SpamScore: 9
X-BigFish: VPS9(zzab9bh78fbpzz1202hzz6ff19hz32i87h2a8h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WR-01-32Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/22] KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
Date: Tue, 27 Apr 2010 12:38:13 +0200
Message-ID: <1272364712-17425-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0589 (UTC) FILETIME=[CA37E750:01CAE5F5]
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
 arch/x86/kvm/mmu.c              |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44eda9b..04834b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -233,6 +233,7 @@ struct kvm_pio_request {
  */
 struct kvm_mmu {
 	void (*new_cr3)(struct kvm_vcpu *vcpu);
+	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 618d25f..6eedcdd 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2386,6 +2386,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.direct_map = true;
+	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2425,6 +2426,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.direct_map        = false;
+	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 
 	return r;
 }
@@ -2470,7 +2472,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
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


