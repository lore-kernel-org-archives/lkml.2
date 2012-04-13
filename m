Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127Ab2DMKOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:14:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:38255 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935090Ab2DMKOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:14:32 -0400
Message-ID: <4F87FC82.2050302@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:14:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 10/16] KVM: MMU: fask check whether page is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-5140-0000-0000-0000010FAD5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using bit 1 (PTE_LIST_WP_BIT) in rmap store the write-protect status
to avoid unnecessary shadow page walking

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0c6e92d..8b71908 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -796,7 +796,9 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 	return level - 1;
 }

-#define PTE_LIST_DESC		(0x1ull)
+#define PTE_LIST_DESC_BIT	0
+#define PTE_LIST_WP_BIT	1
+#define PTE_LIST_DESC		(1 << PTE_LIST_DESC_BIT)
 #define PTE_LIST_FLAG_MASK	(0x3ull)

 static void
@@ -1067,6 +1069,12 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 	return mmu_memory_cache_free_objects(cache);
 }

+static void host_page_write_protect(u64 *spte, unsigned long *rmapp)
+{
+	if (!(*spte & SPTE_HOST_WRITEABLE))
+		__test_and_set_bit(PTE_LIST_WP_BIT, rmapp);
+}
+
 static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
@@ -1074,7 +1082,10 @@ static int rmap_add(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)

 	sp = page_header(__pa(spte));
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
+
 	rmapp = gfn_to_rmap(vcpu->kvm, gfn, sp->role.level);
+	host_page_write_protect(spte, rmapp);
+
 	return pte_list_add(vcpu, spte, rmapp);
 }

@@ -1164,16 +1175,23 @@ static bool rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long *rmapp;
-	int i;
+	int i = PT_PAGE_TABLE_LEVEL;
 	bool write_protected = false;

 	slot = gfn_to_memslot(kvm, gfn);
+	rmapp = __gfn_to_rmap(gfn, i, slot);
+
+	if (__test_and_set_bit(PTE_LIST_WP_BIT, rmapp))
+		return false;
+
+	do {
+		write_protected |= __rmap_write_protect(kvm, rmapp, i++);
+
+		if (i >= PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES)
+			break;

-	for (i = PT_PAGE_TABLE_LEVEL;
-	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
 		rmapp = __gfn_to_rmap(gfn, i, slot);
-		write_protected |= __rmap_write_protect(kvm, rmapp, i);
-	}
+	} while (true);

 	return write_protected;
 }
@@ -1225,6 +1243,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,

 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
+			host_page_write_protect(sptep, rmapp);
 		}
 	}

@@ -2291,9 +2310,15 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 {
 	struct kvm_mmu_page *s;
 	struct hlist_node *node;
+	unsigned long *rmap;
 	bool need_unsync = false;

+	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
+
 	if (!vcpu->kvm->arch.indirect_shadow_pages)
+		goto write_free;
+
+	if (!test_bit(PTE_LIST_WP_BIT, rmap))
 		return 0;

 	for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
@@ -2309,6 +2334,9 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	}
 	if (need_unsync)
 		kvm_unsync_pages(vcpu, gfn);
+
+write_free:
+	__clear_bit(PTE_LIST_WP_BIT, rmap);
 	return 0;
 }

-- 
1.7.7.6

