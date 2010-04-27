Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0D0Kjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:51 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:15849
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755016Ab0D0Kjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:48 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WI-02-NOT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/22] KVM: MMU: Implement nested gva_to_gpa functions
Date: Tue, 27 Apr 2010 12:38:22 +0200
Message-ID: <1272364712-17425-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0933 (UTC) FILETIME=[CA6C64D0:01CAE5F5]
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
 arch/x86/include/asm/kvm_host.h |    4 ++++
 arch/x86/kvm/mmu.c              |    8 ++++++++
 arch/x86/kvm/paging_tmpl.h      |   31 +++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccdbd2f..3cbfb51 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -287,6 +287,10 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
+
+	/* Used for two dimensional paging emulation */
+	struct kvm_mmu nested_mmu;
+
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4e0bfdb..8bd40b5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2144,6 +2144,14 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vaddr;
 }
 
+static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
+					 u32 access, u32 *error)
+{
+	if (error)
+		*error = 0;
+	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, error);
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code)
 {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 101849a..7819a6f 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -264,6 +264,16 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
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
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			      u64 *spte, const void *pte)
 {
@@ -544,6 +554,27 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
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
+				    !!(access & PFERR_WRITE_MASK),
+				    !!(access & PFERR_USER_MASK),
+				    !!(access & PFERR_FETCH_MASK));
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
-- 
1.7.0.4


