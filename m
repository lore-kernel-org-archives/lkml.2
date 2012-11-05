Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2KEMKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:10:20 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47565 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2KEMKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:10:17 -0500
Message-ID: <5097ACA0.7080408@linux.vnet.ibm.com>
Date: Mon, 05 Nov 2012 20:10:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/5] KVM: MMU: simplify mmu_set_spte
References: <5097AC70.1080904@linux.vnet.ibm.com>
In-Reply-To: <5097AC70.1080904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12110512-7014-0000-0000-000002251E51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to detecting spte remapping, we can simply check whether the
spte has already been pointing to the pfn even if the spte is not the
last spte for middle spte is pointing to the kernel pfn which can not
be mapped to userspace

Also, update slot and stat.lpages iff the spte is not remapped

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   40 +++++++++++++---------------------------
 1 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 692ebb1..4ea731e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2420,8 +2420,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			 pfn_t pfn, bool speculative,
 			 bool host_writable)
 {
-	int was_rmapped = 0;
-	int rmap_count;
+	bool was_rmapped = false;

 	pgprintk("%s: spte %llx access %x write_fault %d"
 		 " user_fault %d gfn %llx\n",
@@ -2429,25 +2428,13 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 write_fault, user_fault, gfn);

 	if (is_rmap_spte(*sptep)) {
-		/*
-		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
-		 * the parent of the now unreachable PTE.
-		 */
-		if (level > PT_PAGE_TABLE_LEVEL &&
-		    !is_large_pte(*sptep)) {
-			struct kvm_mmu_page *child;
-			u64 pte = *sptep;
+		if (pfn != spte_to_pfn(*sptep)) {
+			struct kvm_mmu_page *sp = page_header(__pa(sptep));

-			child = page_header(pte & PT64_BASE_ADDR_MASK);
-			drop_parent_pte(child, sptep);
-			kvm_flush_remote_tlbs(vcpu->kvm);
-		} else if (pfn != spte_to_pfn(*sptep)) {
-			pgprintk("hfn old %llx new %llx\n",
-				 spte_to_pfn(*sptep), pfn);
-			drop_spte(vcpu->kvm, sptep);
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (mmu_page_zap_pte(vcpu->kvm, sp, sptep))
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		} else
-			was_rmapped = 1;
+			was_rmapped = true;
 	}

 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
@@ -2466,16 +2453,15 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 is_large_pte(*sptep)? "2MB" : "4kB",
 		 *sptep & PT_PRESENT_MASK ?"RW":"R", gfn,
 		 *sptep, sptep);
-	if (!was_rmapped && is_large_pte(*sptep))
-		++vcpu->kvm->stat.lpages;

-	if (is_shadow_present_pte(*sptep)) {
+	if (is_shadow_present_pte(*sptep) && !was_rmapped) {
+		if (is_large_pte(*sptep))
+			++vcpu->kvm->stat.lpages;
+
 		page_header_update_slot(vcpu->kvm, sptep, gfn);
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
+
+		if (rmap_add(vcpu, sptep, gfn) > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
 	}

 	kvm_release_pfn_clean(pfn);
-- 
1.7.7.6

