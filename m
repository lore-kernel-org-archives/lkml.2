Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab0IFPDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:03:17 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31082 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab0IFPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:45 -0400
X-SpamScore: 9
X-BigFish: VS9(zz78fbpzz1202hzz8275bhz32i2a8h87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2N-01-ANX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/27] KVM: MMU: Make set_cr3 a function pointer in kvm_mmu
Date: Mon, 6 Sep 2010 17:01:38 +0200
Message-ID: <1283785322-26898-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
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
index bfb3f23..2ac3851 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2711,6 +2711,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	context->direct_map = true;
+	context->set_cr3 = kvm_x86_ops->set_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2751,6 +2752,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
 	vcpu->arch.mmu.base_role.cr0_wp = is_write_protection(vcpu);
 	vcpu->arch.mmu.direct_map        = false;
+	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 
 	return r;
 }
@@ -2794,7 +2796,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
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


