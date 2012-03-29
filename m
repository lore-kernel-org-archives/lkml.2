Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab2C2JZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:25:25 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60842 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2C2JZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:25:18 -0400
Message-ID: <4F742A74.1050304@linux.vnet.ibm.com>
Date: Thu, 29 Mar 2012 17:25:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 08/13] KVM: MMU: fask check whether page is writable
References: <4F742951.7080003@linux.vnet.ibm.com>
In-Reply-To: <4F742951.7080003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12032909-5564-0000-0000-000002034E42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PTE_LIST_WRITE_PROTECT bit in rmap store the write-protect status to
avoid unnecessary shadow page walking

Also if no shadow page is indirect, the page is write-free

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 84b9775..3887a07 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -797,6 +797,7 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 }

 #define PTE_LIST_DESC		(0x1ull)
+#define PTE_LIST_WRITE_PROTECT	(0x2ull)
 #define PTE_LIST_FLAG_MASK	(0x3ull)

 static void
@@ -1016,6 +1017,13 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return mmu_memory_cache_free_objects(cache);
 }

+static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
+{
+	if (!(*spte & SPTE_HOST_WRITEABLE) &&
+	      !(*rmapp & PTE_LIST_WRITE_PROTECT))
+		*rmapp |= PTE_LIST_WRITE_PROTECT;
+}
+
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
@@ -1023,7 +1031,10 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)

 	sp = page_header(__pa(spte));
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	host_page_write_protect(spte, rmapp);
+
 	return pte_list_add(vcpu, spte, rmapp);
 }

@@ -1130,8 +1141,17 @@ static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 	int write_protected = 0;

 	slot = gfn_to_memslot(kvm, gfn);
+	rmapp = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);

-	for (i = PT_PAGE_TABLE_LEVEL;
+	if (*rmapp & PTE_LIST_WRITE_PROTECT)
+		return 0;
+
+	*rmapp |= PTE_LIST_WRITE_PROTECT;
+
+	write_protected |= __rmap_write_protect(kvm, rmapp,
+						PT_PAGE_TABLE_LEVEL);
+
+	for (i = PT_DIRECTORY_LEVEL;
 	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmapp, i);
@@ -1180,6 +1200,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
 			new_spte &= ~shadow_accessed_mask;
 			mmu_spte_clear_track_bits(spte);
 			mmu_spte_set(spte, new_spte);
+			host_page_write_protect(spte, rmapp);
 			spte = rmap_next(rmapp, spte);
 		}
 	}
@@ -2247,8 +2268,16 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_mmu_page *s;
 	struct hlist_node *node;
+	unsigned long *rmap;
 	bool need_unsync = false;

+	if (!vcpu->kvm->arch.indirect_shadow_pages)
+		return 0;
+
+	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
+	if (!(*rmap & PTE_LIST_WRITE_PROTECT))
+		return 0;
+
 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
 		if (!can_unsync)
 			return 1;
@@ -2262,6 +2291,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	}
 	if (need_unsync)
 		kvm_unsync_pages(vcpu, gfn);
+
+	*rmap &= ~PTE_LIST_WRITE_PROTECT;
+
 	return 0;
 }

-- 
1.7.7.6

