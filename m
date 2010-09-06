Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0IFPFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:05:34 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31256 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0IFPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:52 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2M-02-4WB-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/27] KVM: MMU: Introduce inject_page_fault function pointer
Date: Mon, 6 Sep 2010 17:01:41 +0200
Message-ID: <1283785322-26898-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
index d2213fa..5b55451 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2570,7 +2570,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_inject_page_fault(vcpu, addr, err_code);
+	vcpu->arch.mmu.inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
@@ -2718,6 +2718,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->direct_map = true;
 	context->set_cr3 = kvm_x86_ops->set_tdp_cr3;
 	context->get_cr3 = get_cr3;
+	context->inject_page_fault = kvm_inject_page_fault;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2760,6 +2761,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.direct_map        = false;
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
+	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
 
 	return r;
 }
-- 
1.7.0.4


