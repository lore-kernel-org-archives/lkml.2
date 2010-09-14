Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0INPp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 11:45:59 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49166
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752923Ab0INPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 11:45:57 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8QUGB-02-AFQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] KVM: MMU: Don't track nested fault info in error-code
Date: Tue, 14 Sep 2010 17:46:12 +0200
Message-ID: <1284479173-4515-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the detection whether a page-fault was
nested or not out of the error code and moves it into a
separate variable in the fault struct.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.h              |    1 -
 arch/x86/kvm/x86.c              |   14 ++++----------
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a00741..8a83177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -322,6 +322,7 @@ struct kvm_vcpu_arch {
 	struct {
 		u64      address;
 		unsigned error_code;
+		bool     nested;
 	} fault;
 
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 513abbb..7086ca8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -47,7 +47,6 @@
 #define PFERR_USER_MASK (1U << 2)
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
-#define PFERR_NESTED_MASK (1U << 31)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ff0a8f..335519f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -340,18 +340,12 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu)
 
 void kvm_propagate_fault(struct kvm_vcpu *vcpu)
 {
-	u32 nested, error;
-
-	error   = vcpu->arch.fault.error_code;
-	nested  = error &  PFERR_NESTED_MASK;
-	error   = error & ~PFERR_NESTED_MASK;
-
-	vcpu->arch.fault.error_code = error;
-
-	if (mmu_is_nested(vcpu) && !nested)
+	if (mmu_is_nested(vcpu) && !vcpu->arch.fault.nested)
 		vcpu->arch.nested_mmu.inject_page_fault(vcpu);
 	else
 		vcpu->arch.mmu.inject_page_fault(vcpu);
+
+	vcpu->arch.fault.nested = false;
 }
 
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
@@ -3518,7 +3512,7 @@ static gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access)
 	access |= PFERR_USER_MASK;
 	t_gpa  = vcpu->arch.mmu.gva_to_gpa(vcpu, gpa, access, &error);
 	if (t_gpa == UNMAPPED_GVA)
-		vcpu->arch.fault.error_code |= PFERR_NESTED_MASK;
+		vcpu->arch.fault.nested = true;
 
 	return t_gpa;
 }
-- 
1.7.0.4


