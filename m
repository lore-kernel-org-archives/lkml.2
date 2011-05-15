Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095Ab1EOP0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 11:26:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760068Ab1EOP0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 11:26:40 -0400
Message-ID: <4DCFF11D.10000@cn.fujitsu.com>
Date: Sun, 15 May 2011 23:28:29 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 7/7] KVM: MMU: cleanup for dropping parent pte
References: <4DCFEF3B.5060806@cn.fujitsu.com>
In-Reply-To: <4DCFEF3B.5060806@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:26:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-15 23:26:50,
	Serialize complete at 2011-05-15 23:26:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce drop_parent_pte to remove the rmap of parent pte and
clear parent pte

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3fab3c2..2d14434 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1084,6 +1084,13 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
 	pte_list_remove(parent_pte, &sp->parent_ptes);
 }
 
+static void drop_parent_pte(struct kvm_mmu_page *sp,
+			    u64 *parent_pte)
+{
+	mmu_page_remove_parent_pte(sp, parent_pte);
+	__set_spte(parent_pte, shadow_trap_nonpresent_pte);
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 					       u64 *parent_pte, int direct)
 {
@@ -1560,8 +1567,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (child->role.access == direct_access)
 			return;
 
-		mmu_page_remove_parent_pte(child, sptep);
-		__set_spte(sptep, shadow_trap_nonpresent_pte);
+		drop_parent_pte(child, sptep);
 		kvm_flush_remote_tlbs(vcpu->kvm);
 	}
 }
@@ -1578,7 +1584,7 @@ static void mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			drop_spte(kvm, spte, shadow_trap_nonpresent_pte);
 		else {
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			mmu_page_remove_parent_pte(child, spte);
+			drop_parent_pte(child, spte);
 		}
 	}
 	__set_spte(spte, shadow_trap_nonpresent_pte);
@@ -1613,10 +1619,8 @@ static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
 
-	while ((parent_pte = pte_list_next(&sp->parent_ptes, NULL))) {
-		kvm_mmu_put_page(sp, parent_pte);
-		__set_spte(parent_pte, shadow_trap_nonpresent_pte);
-	}
+	while ((parent_pte = pte_list_next(&sp->parent_ptes, NULL)))
+		drop_parent_pte(sp, parent_pte);
 }
 
 static int mmu_zap_unsync_children(struct kvm *kvm,
@@ -2046,8 +2050,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			u64 pte = *sptep;
 
 			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			mmu_page_remove_parent_pte(child, sptep);
-			__set_spte(sptep, shadow_trap_nonpresent_pte);
+			drop_parent_pte(child, sptep);
 			kvm_flush_remote_tlbs(vcpu->kvm);
 		} else if (pfn != spte_to_pfn(*sptep)) {
 			pgprintk("hfn old %llx new %llx\n",
-- 
1.7.4.4

