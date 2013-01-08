Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3AHKoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:44:15 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:36786 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab3AHKoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:44:13 -0500
Date: Tue, 8 Jan 2013 19:44:48 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] KVM: MMU: Make kvm_mmu_slot_remove_write_access() rmap
 based
Message-Id: <20130108194448.379044ce.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to release mmu_lock and reschedule conditionally
in a later patch.  Although this may increase the time needed to protect
the whole slot when we start dirty logging, the kernel should not allow
the userspace to trigger something that will hold a spinlock for such a
long time as tens of milliseconds: actually there is no limit since it
is roughly proportional to the number of guest pages.

Another point to note is that this patch removes the only user of
slot_bitmap which will cause some problems when we increase the number
of slots further.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bee3509..b4d4fd1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4198,25 +4198,27 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 {
-	struct kvm_mmu_page *sp;
-	bool flush = false;
+	struct kvm_memory_slot *memslot;
+	gfn_t last_gfn;
+	int i;
 
-	list_for_each_entry(sp, &kvm->arch.active_mmu_pages, link) {
-		int i;
-		u64 *pt;
+	memslot = id_to_memslot(kvm->memslots, slot);
+	last_gfn = memslot->base_gfn + memslot->npages - 1;
 
-		if (!test_bit(slot, sp->slot_bitmap))
-			continue;
+	for (i = PT_PAGE_TABLE_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		unsigned long *rmapp;
+		unsigned long last_index, index;
 
-		pt = sp->spt;
-		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			if (!is_shadow_present_pte(pt[i]) ||
-			      !is_last_spte(pt[i], sp->role.level))
-				continue;
+		rmapp = memslot->arch.rmap[i - PT_PAGE_TABLE_LEVEL];
+		last_index = gfn_to_index(last_gfn, memslot->base_gfn, i);
 
-			spte_write_protect(kvm, &pt[i], &flush, false);
+		for (index = 0; index <= last_index; ++index, ++rmapp) {
+			if (*rmapp)
+				__rmap_write_protect(kvm, rmapp, false);
 		}
 	}
+
 	kvm_flush_remote_tlbs(kvm);
 }
 
-- 
1.7.5.4

