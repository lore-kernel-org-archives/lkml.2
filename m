Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0IJPiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:38:16 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:35586 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab0IJPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:41 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-02-JQ4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/29] KVM: MMU: Make walk_addr_generic capable for two-level walking
Date: Fri, 10 Sep 2010 17:30:52 +0200
Message-ID: <1284132667-18620-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
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
 arch/x86/kvm/paging_tmpl.h |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index eefe363..f4e09d3 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -124,6 +124,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	unsigned index, pt_access, uninitialized_var(pte_access);
 	gpa_t pte_gpa;
 	bool eperm, present, rsvd_fault;
+	int offset;
+	u32 access = 0;
 
 	trace_kvm_mmu_pagetable_walk(addr, write_fault, user_fault,
 				     fetch_fault);
@@ -153,12 +155,14 @@ walk:
 		index = PT_INDEX(addr, walker->level);
 
 		table_gfn = gpte_to_gfn(pte);
-		pte_gpa = gfn_to_gpa(table_gfn);
-		pte_gpa += index * sizeof(pt_element_t);
+		offset    = index * sizeof(pt_element_t);
+		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		walker->pte_gpa[walker->level - 1] = pte_gpa;
 
-		if (kvm_read_guest(vcpu->kvm, pte_gpa, &pte, sizeof(pte))) {
+		if (kvm_read_guest_page_mmu(vcpu, mmu, table_gfn, &pte,
+					    offset, sizeof(pte),
+					    PFERR_USER_MASK|PFERR_WRITE_MASK)) {
 			present = false;
 			break;
 		}
@@ -209,15 +213,27 @@ walk:
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
+			access |= write_fault ? PFERR_WRITE_MASK : 0;
+			access |= fetch_fault ? PFERR_FETCH_MASK : 0;
+			access |= user_fault  ? PFERR_USER_MASK  : 0;
+
+			real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn),
+						      access);
+			if (real_gpa == UNMAPPED_GVA)
+				return 0;
+
+			walker->gfn = real_gpa >> PAGE_SHIFT;
 
 			break;
 		}
-- 
1.7.0.4


