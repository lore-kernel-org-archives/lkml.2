Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab2EWJDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:03:19 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43842 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2EWJDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:03:17 -0400
Message-ID: <4FBCA555.5020303@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 16:52:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 2/9] KVM: MMU: abstract spte write-protect
References: <4FBCA4FB.8050501@linux.vnet.ibm.com>
In-Reply-To: <4FBCA4FB.8050501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052222-5490-0000-0000-0000017173DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common function to abstract spte write-protect to
cleanup the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   58 +++++++++++++++++++++++++++------------------------
 1 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ddbf89f..337ff0a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1051,36 +1051,48 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+/* Return true if the spte is dropped. */
+static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
+{
+	u64 spte = *sptep;
+
+	if (!is_writable_pte(spte))
+		return false;
+
+	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
+
+	*flush |= true;
+	if (is_large_pte(spte)) {
+		WARN_ON(page_header(__pa(sptep))->role.level ==
+		       PT_PAGE_TABLE_LEVEL);
+		drop_spte(kvm, sptep);
+		--kvm->stat.lpages;
+		return true;
+	}
+
+	spte = spte & ~PT_WRITABLE_MASK;
+	mmu_spte_update(sptep, spte);
+	return false;
+}
+
 static bool
 __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
-	bool write_protected = false;
+	bool flush = false;

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
 		BUG_ON(!(*sptep & PT_PRESENT_MASK));
-		rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
-
-		if (!is_writable_pte(*sptep)) {
-			sptep = rmap_get_next(&iter);
-			continue;
-		}
-
-		if (level == PT_PAGE_TABLE_LEVEL) {
-			mmu_spte_update(sptep, *sptep & ~PT_WRITABLE_MASK);
-			sptep = rmap_get_next(&iter);
-		} else {
-			BUG_ON(!is_large_pte(*sptep));
-			drop_spte(kvm, sptep);
-			--kvm->stat.lpages;
+		if (spte_write_protect(kvm, sptep, &flush)) {
 			sptep = rmap_get_first(*rmapp, &iter);
+			continue;
 		}

-		write_protected = true;
+		sptep = rmap_get_next(&iter);
 	}

-	return write_protected;
+	return flush;
 }

 /**
@@ -3887,6 +3899,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
+	bool flush = false;

 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
@@ -3901,16 +3914,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 			      !is_last_spte(pt[i], sp->role.level))
 				continue;

-			if (is_large_pte(pt[i])) {
-				drop_spte(kvm, &pt[i]);
-				--kvm->stat.lpages;
-				continue;
-			}
-
-			/* avoid RMW */
-			if (is_writable_pte(pt[i]))
-				mmu_spte_update(&pt[i],
-						pt[i] & ~PT_WRITABLE_MASK);
+			spte_write_protect(kvm, &pt[i], &flush);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

