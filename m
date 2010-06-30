Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0F3IIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:08:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab0F3IIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:08:47 -0400
Message-ID: <4C2AFAAC.8040308@cn.fujitsu.com>
Date: Wed, 30 Jun 2010 16:05:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v3 5/11] KVM: MMU: cleanup FNAME(fetch)() functions
References: <4C2AF9FA.9020601@cn.fujitsu.com>
In-Reply-To: <4C2AF9FA.9020601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup this function that we are already get the direct sp's access

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/paging_tmpl.h |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f28f09d..3350c02 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -306,12 +306,18 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	gfn_t table_gfn;
 	int r;
 	int level;
+	bool dirty = is_dirty_gpte(gw->ptes[gw->level - 1]);
+	unsigned direct_access;
 	pt_element_t curr_pte;
 	struct kvm_shadow_walk_iterator iterator;
 
 	if (!is_present_gpte(gw->ptes[gw->level - 1]))
 		return NULL;
 
+	direct_access = gw->pt_access & gw->pte_access;
+	if (!dirty)
+		direct_access &= ~ACC_WRITE_MASK;
+
 	for_each_shadow_entry(vcpu, addr, iterator) {
 		level = iterator.level;
 		sptep = iterator.sptep;
@@ -319,15 +325,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			mmu_set_spte(vcpu, sptep, access,
 				     gw->pte_access & access,
 				     user_fault, write_fault,
-				     is_dirty_gpte(gw->ptes[gw->level-1]),
-				     ptwrite, level,
+				     dirty, ptwrite, level,
 				     gw->gfn, pfn, false, true);
 			break;
 		}
 
 		if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
 			struct kvm_mmu_page *child;
-			unsigned direct_access;
 
 			if (level != gw->level)
 				continue;
@@ -339,10 +343,6 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			 * so we should update the spte at this point to get
 			 * a new sp with the correct access.
 			 */
-			direct_access = gw->pt_access & gw->pte_access;
-			if (!is_dirty_gpte(gw->ptes[gw->level - 1]))
-				direct_access &= ~ACC_WRITE_MASK;
-
 			child = page_header(*sptep & PT64_BASE_ADDR_MASK);
 			if (child->role.access == direct_access)
 				continue;
@@ -359,11 +359,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		}
 
 		if (level <= gw->level) {
-			int delta = level - gw->level + 1;
 			direct = 1;
-			if (!is_dirty_gpte(gw->ptes[level - delta]))
-				access &= ~ACC_WRITE_MASK;
-			access &= gw->pte_access;
+			access = direct_access;
 
 			/*
 			 * It is a large guest pages backed by small host pages,
-- 
1.6.1.2


