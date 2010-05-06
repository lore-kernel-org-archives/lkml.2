Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab0EFJfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 05:35:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57713 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab0EFJe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 05:34:59 -0400
Message-ID: <4BE28C86.5050801@cn.fujitsu.com>
Date: Thu, 06 May 2010 17:31:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 9/9] KVM MMU: optimize sync/update unsync-page
References: <4BE2818A.5000301@cn.fujitsu.com>
In-Reply-To: <4BE2818A.5000301@cn.fujitsu.com>
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
 arch/x86/kvm/paging_tmpl.h |   12 ++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5e32751..7ea551c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2731,7 +2731,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 
 restart:
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid)
+		if (sp->gfn != gfn || sp->role.direct || sp->role.invalid ||
+		      sp->unsync)
 			continue;
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index ceaac55..5687c0e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -475,10 +475,15 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 		level = iterator.level;
 		sptep = iterator.sptep;
 
+		sp = page_header(__pa(sptep));
 		if (is_last_spte(*sptep, level)) {
 			int shift;
 
-			sp = page_header(__pa(sptep));
+			if (!sp->unsync)
+				break;
+
+			WARN_ON(level != PT_PAGE_TABLE_LEVEL);
+
 			shift = PAGE_SHIFT -
 				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
 			gfn = sp->gfn;
@@ -496,7 +501,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			break;
 		}
 
-		if (!is_shadow_present_pte(*sptep))
+		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
 			break;
 	}
 
@@ -523,8 +528,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 			kvm_mmu_free_page(vcpu->kvm, sp);
 		goto unlock_exit;
 	}
-	if (vcpu->kvm->arch.invlpg_counter == invlpg_counter &&
-			sp->role.level == PT_PAGE_TABLE_LEVEL) {
+	if (vcpu->kvm->arch.invlpg_counter == invlpg_counter) {
 		++vcpu->kvm->stat.mmu_pte_updated;
 		FNAME(update_pte)(vcpu, sp, sptep, &gentry);
 	}
-- 
1.6.1.2





