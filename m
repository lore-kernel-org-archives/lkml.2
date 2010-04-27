Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0D0Kmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:51 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20551 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab0D0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:53 -0400
X-SpamScore: 17
X-BigFish: VPS17(zzab9bhb0c3ihzz1202hzz6ff19hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WN-01-32T-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/22] KVM: MMU: Make walk_addr_generic capable for two-level walking
Date: Tue, 27 Apr 2010 12:38:24 +0200
Message-ID: <1272364712-17425-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0980 (UTC) FILETIME=[CA7390C0:01CAE5F5]
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
 arch/x86/kvm/paging_tmpl.h |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7819a6f..8b27026 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -121,8 +121,9 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn_t table_gfn;
 	unsigned index, pt_access, pte_access;
 	gpa_t pte_gpa;
+	int offset;
 	int rsvd_fault = 0;
-	u32 error;
+	u32 error = 0;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
@@ -149,13 +150,16 @@ walk:
 		index = PT_INDEX(addr, walker->level);
 
 		table_gfn = gpte_to_gfn(pte);
-		pte_gpa = gfn_to_gpa(table_gfn);
-		pte_gpa += index * sizeof(pt_element_t);
+		offset    = index * sizeof(pt_element_t);
+		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte)))
-			goto not_present;
+		if (kvm_read_guest_page_tdp(vcpu, mmu, table_gfn, &pte, offset,
+					    sizeof(pte), &error)) {
+			walker->error_code = error;
+			return 0;
+		}
 
 		trace_kvm_mmu_paging_element(pte, walker->level);
 
@@ -200,15 +204,25 @@ walk:
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
@@ -237,7 +251,7 @@ walk:
 	return 1;
 
 not_present:
-	walker->error_code = 0;
+	walker->error_code = error;
 	goto err;
 
 access_error:
-- 
1.7.0.4


