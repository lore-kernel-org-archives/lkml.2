Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab2LRH0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:26:18 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:53432 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2LRH0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:26:17 -0500
Date: Tue, 18 Dec 2012 16:26:47 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] KVM: Write protect the updated slot only when we start
 dirty logging
Message-Id: <20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to make kvm_mmu_slot_remove_write_access() rmap based:
otherwise we may end up using invalid rmap's.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/x86.c  |    9 ++++++++-
 virt/kvm/kvm_main.c |    1 -
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1c9c834..9451efa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6897,7 +6897,14 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	if (nr_mmu_pages)
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
-	kvm_mmu_slot_remove_write_access(kvm, mem->slot);
+	/*
+	 * Write protect all pages for dirty logging.
+	 * Existing largepage mappings are destroyed here and new ones will
+	 * not be created until the end of the logging.
+	 */
+	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
+	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
+		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
 	spin_unlock(&kvm->mmu_lock);
 	/*
 	 * If memory slot is created, or moved, we need to clear all
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bd31096..0ef5daa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -805,7 +805,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		if (kvm_create_dirty_bitmap(&new) < 0)
 			goto out_free;
-		/* destroy any largepage mappings for dirty tracking */
 	}
 
 	if (!npages || base_gfn != old.base_gfn) {
-- 
1.7.5.4

