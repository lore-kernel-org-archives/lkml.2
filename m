Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab2C2J0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:26:05 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48620 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2C2JZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:25:56 -0400
Message-ID: <4F742A97.6030308@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:25:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 09/13] KVM: MMU: get expected spte out of mmu-lock
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-2000-0000-0000-000006F45584
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It depends on PTE_LIST_WRITE_PROTECT bit in rmap which let us quickly know
whether the page is writable out of mmu-lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   17 +++++++++++++----
 arch/x86/kvm/paging_tmpl.h |    2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3887a07..c029185 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1148,6 +1148,12 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)

 	*rmapp |= PTE_LIST_WRITE_PROTECT;

+	/*
+	 * Setting PTE_LIST_WRITE_PROTECT bit before doing page
+	 * write-protect.
+	 */
+	smp_mb();
+
 	write_protected |= __rmap_write_protect(kvm, rmapp,
 						PT_PAGE_TABLE_LEVEL);

@@ -2264,7 +2270,7 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 }

 static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
-				  bool can_unsync)
+				  bool can_unsync, bool unlock)
 {
 	struct kvm_mmu_page *s;
 	struct hlist_node *node;
@@ -2278,6 +2284,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!(*rmap & PTE_LIST_WRITE_PROTECT))
 		return 0;

+	if (unlock)
+		return 1;
+
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (!can_unsync)
 			return 1;
@@ -2301,7 +2310,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int user_fault,
 		    int write_fault, int level,
 		    gfn_t gfn, pfn_t pfn, bool speculative,
-		    bool can_unsync, bool host_writable)
+		    bool can_unsync, bool host_writable, bool unlock)
 {
 	u64 spte, entry = *sptep;
 	int ret = 0;
@@ -2367,7 +2376,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		if (!can_unsync && is_writable_pte(*sptep))
 			goto set_pte;

-		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
+		if (mmu_need_write_protect(vcpu, gfn, can_unsync, unlock)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret = 1;
@@ -2433,7 +2442,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,

 	if (set_spte(vcpu, sptep, pte_access, user_fault, write_fault,
 		      level, gfn, pfn, speculative, true,
-		      host_writable)) {
+		      host_writable, false)) {
 		if (write_fault)
 			*emulate = 1;
 		kvm_mmu_flush_tlb(vcpu);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index f0fbde3..e2af5a5 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -820,7 +820,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		set_spte(vcpu, &sp->spt[i], pte_access, 0, 0,
 			 PT_PAGE_TABLE_LEVEL, gfn,
 			 spte_to_pfn(sp->spt[i]), true, false,
-			 host_writable);
+			 host_writable, false);
 	}

 	return !nr_present;
-- 
1.7.7.6

