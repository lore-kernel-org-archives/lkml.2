Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3AHKmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:42:54 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:57321 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab3AHKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:42:53 -0500
Date: Tue, 8 Jan 2013 19:43:28 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] KVM: Write protect the updated slot only when dirty
 logging is enabled
Message-Id: <20130108194328.af8c13ce.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20130108194238.09ebc8bd.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling kvm_mmu_slot_remove_write_access() for a deleted slot does
nothing but search for non-existent mmu pages which have mappings to
that deleted memory; this is safe but a waste of time.

Since we want to make the function rmap based in a later patch, in a
manner which makes it unsafe to be called for a deleted slot, we makes
the caller see if the slot is non-zero and being dirty logged.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/x86.c  |    8 +++++++-
 virt/kvm/kvm_main.c |    1 -
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1c9c834..add5e48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6897,7 +6897,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (nr_mmu_pages)
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
-	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+	/*
+	 * Write protect all pages for dirty logging.
+	 * Existing largepage mappings are destroyed here and new ones will
+	 * not be created until the end of the logging.
+	 */
+	if (npages && (mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	spin_unlock(&kvm->mmu_lock);
 	/*
 	 * If memory slot is created, or moved, we need to clear all
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e45c20c..f689a6d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -817,7 +817,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
-		/* destroy any largepage mappings for dirty tracking */
 	}
 
 	if (!npages || base_gfn != old.base_gfn) {
-- 
1.7.5.4

