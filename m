Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0IJPgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:36:48 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:35025 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab0IJPcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:43 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF42-01-7OS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/29] KVM: MMU: Implement nested gva_to_gpa functions
Date: Fri, 10 Sep 2010 17:30:50 +0200
Message-ID: <1284132667-18620-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to do a nested l2_gva to
l1_gpa page table walk.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |   10 ++++++++++
 arch/x86/kvm/mmu.c              |    8 ++++++++
 arch/x86/kvm/paging_tmpl.h      |   31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h              |    5 +++++
 4 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91c7d35..10a5ddd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -296,6 +296,16 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu mmu;
 
 	/*
+	 * Paging state of an L2 guest (used for nested npt)
+	 *
+	 * This context will save all necessary information to walk page tables
+	 * of the an L2 guest. This context is only initialized for page table
+	 * walking and not for faulting since we never handle l2 page faults on
+	 * the host.
+	 */
+	struct kvm_mmu nested_mmu;
+
+	/*
 	 * Pointer to the mmu context currently used for
 	 * gva_to_gpa translations.
 	 */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cb06ada..1e215e8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2466,6 +2466,14 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vaddr;
 }
 
+static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
+					 u32 access, u32 *error)
+{
+	if (error)
+		*error = 0;
+	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, access);
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code)
 {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a704a81..eefe363 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -276,6 +276,16 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 					write_fault, user_fault, fetch_fault);
 }
 
+static int FNAME(walk_addr_nested)(struct guest_walker *walker,
+				   struct kvm_vcpu *vcpu, gva_t addr,
+				   int write_fault, int user_fault,
+				   int fetch_fault)
+{
+	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
+					addr, write_fault, user_fault,
+					fetch_fault);
+}
+
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			      u64 *spte, const void *pte)
 {
@@ -660,6 +670,27 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	return gpa;
 }
 
+static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
+				      u32 access, u32 *error)
+{
+	struct guest_walker walker;
+	gpa_t gpa = UNMAPPED_GVA;
+	int r;
+
+	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr,
+				    access & PFERR_WRITE_MASK,
+				    access & PFERR_USER_MASK,
+				    access & PFERR_FETCH_MASK);
+
+	if (r) {
+		gpa = gfn_to_gpa(walker.gfn);
+		gpa |= vaddr & ~PAGE_MASK;
+	} else if (error)
+		*error = walker.error_code;
+
+	return gpa;
+}
+
 static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2d6385e..bf4dc2f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -50,6 +50,11 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 #endif
 }
 
+static inline bool mmu_is_nested(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.walk_mmu == &vcpu->arch.nested_mmu;
+}
+
 static inline int is_pae(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr4_bits(vcpu, X86_CR4_PAE);
-- 
1.7.0.4


