Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2FTH5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:57:55 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38508 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2FTH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:57:52 -0400
Message-ID: <4FE18273.10802@linux.vnet.ibm.com>
Date: Wed, 20 Jun 2012 15:57:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v7 03/10] KVM: MMU: cleanup spte_write_protect
References: <4FE1822D.8010002@linux.vnet.ibm.com>
In-Reply-To: <4FE1822D.8010002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062007-5816-0000-0000-0000033A35AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __drop_large_spte to cleanup this function and comment spte_write_protect

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   45 +++++++++++++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 334dc54..a0ea746 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1051,7 +1051,33 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }

-/* Return true if the spte is dropped. */
+
+static bool __drop_large_spte(struct kvm *kvm, u64 *sptep)
+{
+	if (is_large_pte(*sptep)) {
+		WARN_ON(page_header(__pa(sptep))->role.level ==
+			PT_PAGE_TABLE_LEVEL);
+		drop_spte(kvm, sptep);
+		--kvm->stat.lpages;
+		return true;
+	}
+
+	return false;
+}
+
+static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
+{
+	if (__drop_large_spte(vcpu->kvm, sptep))
+		kvm_flush_remote_tlbs(vcpu->kvm);
+}
+
+/*
+ * Write-protect on the specified @sptep due to dirty page logging or
+ * protecting shadow page table. @flush indicates whether tlb need be
+ * flushed.
+ *
+ * Return true if the spte is dropped.
+ */
 static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
 {
 	u64 spte = *sptep;
@@ -1062,13 +1088,9 @@ static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool *flush)
 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

 	*flush |= true;
-	if (is_large_pte(spte)) {
-		WARN_ON(page_header(__pa(sptep))->role.level ==
-		       PT_PAGE_TABLE_LEVEL);
-		drop_spte(kvm, sptep);
-		--kvm->stat.lpages;
+
+	if (__drop_large_spte(kvm, sptep))
 		return true;
-	}

 	spte = spte & ~PT_WRITABLE_MASK;
 	mmu_spte_update(sptep, spte);
@@ -1881,15 +1903,6 @@ static void link_shadow_page(u64 *sptep, struct kvm_mmu_page *sp)
 	mmu_spte_set(sptep, spte);
 }

-static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
-{
-	if (is_large_pte(*sptep)) {
-		drop_spte(vcpu->kvm, sptep);
-		--vcpu->kvm->stat.lpages;
-		kvm_flush_remote_tlbs(vcpu->kvm);
-	}
-}
-
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
-- 
1.7.7.6

