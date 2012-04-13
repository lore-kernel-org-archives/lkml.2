Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935161Ab2DMKQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:16:05 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51608 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921Ab2DMKQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:16:02 -0400
Message-ID: <4F87FCDB.3050008@linux.vnet.ibm.com>
Date: Fri, 13 Apr 2012 18:15:55 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 13/16] KVM: MMU: break sptes write-protect if gfn is writable
References: <4F87FA69.5060106@linux.vnet.ibm.com>
In-Reply-To: <4F87FA69.5060106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041300-1396-0000-0000-000000F95C6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make all sptes to be writable if the gfn become write-free to reduce
the later page fault

The idea is from Avi

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 578a1e2..efa5d59 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2323,15 +2323,45 @@ static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 	}
 }

+/*
+ * If the gfn become write-free, we make all sptes which point to this
+ * gfn to be writable.
+ * Note: we should call mark_page_dirty for the gfn later.
+ */
+static void rmap_break_page_table_wp(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct spte_iterator iter;
+	u64 *sptep;
+	int i;
+
+	for (i = PT_PAGE_TABLE_LEVEL;
+	      i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; i++) {
+		unsigned long *rmap = __gfn_to_rmap(gfn, i, slot);
+
+		for_each_rmap_spte(rmap, &iter, sptep) {
+			u64 spte = *sptep;
+
+			if (!is_writable_pte(spte) &&
+			      (spte & SPTE_ALLOW_WRITE)) {
+				spte &= ~SPTE_WRITE_PROTECT;
+				spte |= PT_WRITABLE_MASK;
+				mmu_spte_update(sptep, spte);
+			}
+		}
+	}
+}
+
 static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 				  bool can_unsync)
 {
+	struct kvm_memory_slot *slot;
 	struct kvm_mmu_page *s;
 	struct hlist_node *node;
 	unsigned long *rmap;
 	bool need_unsync = false;

-	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	rmap =	__gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);

 	if (!vcpu->kvm->arch.indirect_shadow_pages)
 		goto write_free;
@@ -2353,6 +2383,8 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (need_unsync)
 		kvm_unsync_pages(vcpu, gfn);

+	rmap_break_page_table_wp(slot, gfn);
+
 write_free:
 	__clear_bit(PTE_LIST_WP_BIT, rmap);
 	return 0;
-- 
1.7.7.6

