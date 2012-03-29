Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2C2JVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:21:47 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50047 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758657Ab2C2JVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:21:37 -0400
Message-ID: <4F742999.9080001@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:21:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 02/13] KVM: MMU: abstract spte write-protect
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-4790-0000-0000-000001FDC257
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a common function to abstract spte write-protect to cleanup the
code

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   57 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c759e4f..ad40647 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1015,27 +1015,43 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

+/* Return true if the spte is dropped. */
+static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
+			       int *flush)
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
 static int __rmap_write_protect(struct kvm *kvm, unsigned long *rmapp, int level)
 {
 	u64 *spte = NULL;
 	int write_protected = 0;

 	while ((spte = rmap_next(rmapp, spte))) {
-		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-
-		if (!is_writable_pte(*spte))
-			continue;
-
-		if (level == PT_PAGE_TABLE_LEVEL) {
-			mmu_spte_update(spte, *spte & ~PT_WRITABLE_MASK);
-		} else {
-			BUG_ON(!is_large_pte(*spte));
-			drop_spte(kvm, spte);
-			--kvm->stat.lpages;
+		if (spte_write_protect(kvm, spte, level > PT_PAGE_TABLE_LEVEL,
+		      &write_protected))
 			spte = NULL;
-		}
-
-		write_protected = 1;
 	}

 	return write_protected;
@@ -3858,6 +3874,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
 	struct kvm_mmu_page *sp;
+	int flush = 0;

 	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
 		int i;
@@ -3872,16 +3889,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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

