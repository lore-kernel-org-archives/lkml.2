Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0IFPFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:05:47 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:49630 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0IFPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:51 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2N-02-4WJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/27] KVM: MMU: Make walk_addr_generic capable for two-level walking
Date: Mon, 6 Sep 2010 17:01:49 +0200
Message-ID: <1283785322-26898-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses kvm_read_guest_page_tdp to make the
walk_addr_generic functions suitable for two-level page
table walking.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index cd59af1..a5b5759 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -124,6 +124,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	unsigned index, pt_access, uninitialized_var(pte_access);
 	gpa_t pte_gpa;
 	bool eperm, present, rsvd_fault;
+	int offset;
+	u32 error = 0;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
@@ -153,12 +155,13 @@ walk:
 		index = PT_INDEX(addr, walker->level);
 
 		table_gfn = gpte_to_gfn(pte);
-		pte_gpa = gfn_to_gpa(table_gfn);
-		pte_gpa += index * sizeof(pt_element_t);
+		offset    = index * sizeof(pt_element_t);
+		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte))) {
+		if (kvm_read_guest_page_mmu(vcpu, mmu, table_gfn, &pte, offset,
+					    sizeof(pte), &error)) {
 			present = false;
 			break;
 		}
@@ -209,15 +212,25 @@ walk:
 				is_large_pte(pte) &&
 				mmu->root_level == PT64_ROOT_LEVEL)) {
 			int lvl = walker->level;
+			gpa_t real_gpa;
+			gfn_t gfn;
 
-			walker->gfn = gpte_to_gfn_lvl(pte, lvl);
-			walker->gfn += (addr & PT_LVL_OFFSET_MASK(lvl))
-					>> PAGE_SHIFT;
+			gfn = gpte_to_gfn_lvl(pte, lvl);
+			gfn += (addr & PT_LVL_OFFSET_MASK(lvl)) >> PAGE_SHIFT;
 
 			if (PTTYPE == 32 &&
 			    walker->level == PT_DIRECTORY_LEVEL &&
 			    is_cpuid_PSE36())
-				walker->gfn += pse36_gfn_delta(pte);
+				gfn += pse36_gfn_delta(pte);
+
+			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
+						      &error);
+			if (real_gpa == UNMAPPED_GVA) {
+				walker->error_code = error;
+				return 0;
+			}
+
+			walker->gfn = real_gpa >> PAGE_SHIFT;
 
 			break;
 		}
-- 
1.7.0.4


