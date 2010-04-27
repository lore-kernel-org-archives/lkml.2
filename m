Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009Ab0D0Kjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:45 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7844 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0D0Kjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:41 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h63h)
X-Spam-TCS-SCL: 2:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WH-02-NOP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/22] KVM: MMU: Introduce inject_page_fault function pointer
Date: Tue, 27 Apr 2010 12:38:16 +0200
Message-ID: <1272364712-17425-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0746 (UTC) FILETIME=[CA4FDC20:01CAE5F5]
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
index 47d1755..f1d46e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -236,6 +236,9 @@ struct kvm_mmu {
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
index a25a72e..114c522 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2245,7 +2245,7 @@ static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
 {
-	kvm_inject_page_fault(vcpu, addr, err_code);
+	vcpu->arch.mmu.inject_page_fault(vcpu, addr, err_code);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
@@ -2393,6 +2393,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.direct_map = true;
 	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_tdp_cr3;
 	vcpu->arch.mmu.get_cr3 = get_cr3;
+	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -2434,6 +2435,7 @@ static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.direct_map        = false;
 	vcpu->arch.mmu.set_cr3           = kvm_x86_ops->set_cr3;
 	vcpu->arch.mmu.get_cr3           = get_cr3;
+	vcpu->arch.mmu.inject_page_fault = kvm_inject_page_fault;
 
 	return r;
 }
-- 
1.7.0.4


