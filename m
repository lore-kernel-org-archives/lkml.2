Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0IJPdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:33:07 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36348 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab0IJPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:33:00 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-01-7ON-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/29] KVM: MMU: Introduce inject_page_fault function pointer
Date: Fri, 10 Sep 2010 17:30:43 +0200
Message-ID: <1284132667-18620-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces an inject_page_fault function pointer
into struct kvm_mmu which will be used to inject a page
fault. This will be used later when Nested Nested Paging is
implemented.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/mmu.c              |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ab708ee..3fefcd8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -239,6 +239,9 @@ struct kvm_mmu {
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
+				  unsigned long addr,
+				  u32 error_code);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e4a7de4..a751dfc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2571,7 +2571,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_inject_page_fault(vcpu, addr, err_code);
+	vcpu->arch.mmu.inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
@@ -2721,6 +2721,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
 	context->get_cr3 = get_cr3;
+	context->inject_page_fault = kvm_inject_page_fault;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2762,6 +2763,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.base_role.cr0_wp  = is_write_protection(vcpu);
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
+	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
 
 	return r;
 }
-- 
1.7.0.4


