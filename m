Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0IFP6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:58:18 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:45379
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754454Ab0IFP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:29 -0400
X-SpamScore: 8
X-BigFish: VS8(z1039ozzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-01-D1C-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/27] KVM: MMU: Introduce generic walk_addr function
Date: Mon, 6 Sep 2010 17:55:48 +0200
Message-ID: <1283788566-29186-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first patch in the series towards a generic
walk_addr implementation which could walk two-dimensional
page tables in the end. In this first step the walk_addr
function is renamed into walk_addr_generic which takes a
mmu context as an additional parameter.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 68ee1b7..f26fee9 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -114,9 +114,10 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 /*
  * Fetch a guest pte for a guest virtual address
  */
-static int FNAME(walk_addr)(struct guest_walker *walker,
-			    struct kvm_vcpu *vcpu, gva_t addr,
-			    int write_fault, int user_fault, int fetch_fault)
+static int FNAME(walk_addr_generic)(struct guest_walker *walker,
+				    struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+				    gva_t addr, int write_fault,
+				    int user_fault, int fetch_fault)
 {
 	pt_element_t pte;
 	gfn_t table_gfn;
@@ -129,10 +130,11 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 walk:
 	present = true;
 	eperm = rsvd_fault = false;
-	walker->level = vcpu->arch.mmu.root_level;
-	pte = vcpu->arch.mmu.get_cr3(vcpu);
+	walker->level = mmu->root_level;
+	pte           = mmu->get_cr3(vcpu);
+
 #if PTTYPE == 64
-	if (vcpu->arch.mmu.root_level == PT32E_ROOT_LEVEL) {
+	if (walker->level == PT32E_ROOT_LEVEL) {
 		pte = kvm_pdptr_read(vcpu, (addr >> 30) & 3);
 		trace_kvm_mmu_paging_element(pte, walker->level);
 		if (!is_present_gpte(pte)) {
@@ -143,7 +145,7 @@ walk:
 	}
 #endif
 	ASSERT((!is_long_mode(vcpu) && is_pae(vcpu)) ||
-	       (vcpu->arch.mmu.get_cr3(vcpu) & CR3_NONPAE_RESERVED_BITS) == 0);
+	       (mmu->get_cr3(vcpu) & CR3_NONPAE_RESERVED_BITS) == 0);
 
 	pt_access = ACC_ALL;
 
@@ -205,7 +207,7 @@ walk:
 				(PTTYPE == 64 || is_pse(vcpu))) ||
 		    ((walker->level == PT_PDPE_LEVEL) &&
 				is_large_pte(pte) &&
-				vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL)) {
+				mmu->root_level == PT64_ROOT_LEVEL)) {
 			int lvl = walker->level;
 
 			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
@@ -262,6 +264,14 @@ error:
 	return 0;
 }
 
+static int FNAME(walk_addr)(struct guest_walker *walker,
+			    struct kvm_vcpu *vcpu, gva_t addr,
+			    int write_fault, int user_fault, int fetch_fault)
+{
+	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.mmu, addr,
+					write_fault, user_fault, fetch_fault);
+}
+
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			      u64 *spte, const void *pte)
 {
-- 
1.7.0.4


