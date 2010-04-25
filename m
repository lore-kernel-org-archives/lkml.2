Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0DYHFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 03:05:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59888 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0DYHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 03:05:32 -0400
Message-ID: <4BD3E900.7030909@cn.fujitsu.com>
Date: Sun, 25 Apr 2010 15:02:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 10/10] KVM MMU: optimize sync/update unsync-page
References: <4BD3E306.4020202@cn.fujitsu.com>
In-Reply-To: <4BD3E306.4020202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

invlpg only need update unsync page, sp->unsync and sp->unsync_children
can help us to find it

Now, a gfn may have many shadow pages, when one sp need be synced, we
write protect sp->gfn and sync this sp but we keep other shadow pages
asynchronous

So, while gfn happen page fault, let it not touch unsync page, the unsync
page only updated at invlpg/flush TLB time

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    3 ++-
 arch/x86/kvm/paging_tmpl.h |   23 +++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index add4658..3886207 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2697,7 +2697,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
+		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid ||
+		      sp->unsync)
 			continue;
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 38b4d23..b4fb737 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -474,16 +474,16 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
+		sp = page_header(__pa(sptep));
 		if (is_last_spte(*sptep, level)) {
-			sp = page_header(__pa(sptep));
-
-			if (PTTYPE == 32) {
-				if (level == PT_DIRECTORY_LEVEL)
-					offset = PAGE_SHIFT - 4;
-				else
-					offset = PT64_LEVEL_BITS;
-				offset = sp->role.quadrant << offset;
-			}
+			if (!sp->unsync)
+				break;
+
+			WARN_ON(level != PT_PAGE_TABLE_LEVEL);
+
+			if (PTTYPE == 32)
+				offset = sp->role.quadrant << PT64_LEVEL_BITS;
+
 			gfn = sp->gfn;
 			offset = (sptep - sp->spt + offset) *
 					sizeof(pt_element_t);
@@ -498,7 +498,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			break;
 		}
 
-		if (!is_shadow_present_pte(*sptep))
+		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
 
@@ -520,8 +520,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
 	spin_lock(&vcpu->kvm->mmu_lock);
-	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter &&
-		sp->role.level == PT_PAGE_TABLE_LEVEL) {
+	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter) {
 		++vcpu->kvm->stat.mmu_pte_updated;
 		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
 	}
-- 
1.6.1.2


