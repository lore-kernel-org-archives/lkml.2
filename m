Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2DMKLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:11:55 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46251 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2DMKLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:11:52 -0400
Message-ID: <4F87FBE1.200@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:11:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 05/16] KVM: MMU: abstract spte write-protect
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-1618-0000-0000-0000014CB1D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common function to abstract spte write-protect to
cleanup the code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   60 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7589e56..a1c3628 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1052,6 +1052,34 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+/* Return true if the spte is dropped. */
+static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
+			       bool *flush)
+{
+	u64 spte = *sptep;
+
+	if (!is_writable_pte(spte))
+		return false;
+
+	*flush |= true;
+
+	if (large) {
+		pgprintk("rmap_write_protect(large): spte %p %llx\n",
+			 spte, *spte);
+		BUG_ON(!is_large_pte(spte));
+
+		drop_spte(kvm, sptep);
+		--kvm->stat.lpages;
+		return true;
+	}
+
+	rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
+	spte = spte & ~PT_WRITABLE_MASK;
+	mmu_spte_update(sptep, spte);
+
+	return false;
+}
+
 static bool
 __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
@@ -1060,24 +1088,13 @@ __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 	bool write_protected = false;

 	for (sptep = rmap_get_first(*rmapp, &iter); sptep;) {
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
+		if (spte_write_protect(kvm, sptep, level > PT_PAGE_TABLE_LEVEL,
+			  &write_protected)) {
 			sptep = rmap_get_first(*rmapp, &iter);
+			continue;
 		}

-		write_protected = true;
+		sptep = rmap_get_next(&iter);
 	}

 	return write_protected;
@@ -3898,6 +3915,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
+	bool flush = false;

 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
@@ -3912,16 +3930,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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
+			spte_write_protect(kvm, &pt[i],
+					   is_large_pte(pt[i]), &flush);
 		}
 	}
 	kvm_flush_remote_tlbs(kvm);
-- 
1.7.7.6

