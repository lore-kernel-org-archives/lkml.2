Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab2LRHyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 02:54:35 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:41749 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2LRHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 02:53:37 -0500
X-Greylist: delayed 1593 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 02:53:30 EST
Date: Tue, 18 Dec 2012 16:29:26 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: mtosatti@redhat.com, gleb@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] KVM: Make kvm_mmu_change_mmu_pages() take mmu_lock by
 itself
Message-Id: <20121218162926.9e826d90.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No reason to make callers take mmu_lock since we do not need to protect
kvm_mmu_change_mmu_pages() and kvm_mmu_slot_remove_write_access()
together by mmu_lock in kvm_arch_commit_memory_region(): the former
calls kvm_mmu_commit_zap_page() and flushes TLBs by itself.

Note: we do not need to protect kvm->arch.n_requested_mmu_pages by
mmu_lock as can be seen from the fact that it is read locklessly.

Signed-off-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
---
 arch/x86/kvm/mmu.c |    4 ++++
 arch/x86/kvm/x86.c |    9 ++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bb964b3..fc7d84a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2143,6 +2143,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 	 * change the value
 	 */
 
+	spin_lock(&kvm->mmu_lock);
+
 	if (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages) {
 		while (kvm->arch.n_used_mmu_pages > goal_nr_mmu_pages &&
 			!list_empty(&kvm->arch.active_mmu_pages)) {
@@ -2157,6 +2159,8 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 	}
 
 	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
+
+	spin_unlock(&kvm->mmu_lock);
 }
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9451efa..d9d0f6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3270,12 +3270,10 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
-	spin_lock(&kvm->mmu_lock);
 
 	kvm_mmu_change_mmu_pages(kvm, kvm_nr_mmu_pages);
 	kvm->arch.n_requested_mmu_pages = kvm_nr_mmu_pages;
 
-	spin_unlock(&kvm->mmu_lock);
 	mutex_unlock(&kvm->slots_lock);
 	return 0;
 }
@@ -6894,7 +6892,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	if (!kvm->arch.n_requested_mmu_pages)
 		nr_mmu_pages = kvm_mmu_calculate_mmu_pages(kvm);
 
-	spin_lock(&kvm->mmu_lock);
 	if (nr_mmu_pages)
 		kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
 	/*
@@ -6903,9 +6900,11 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 * not be created until the end of the logging.
 	 */
 	if ((mem->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES))
+	    !(old.flags & KVM_MEM_LOG_DIRTY_PAGES)) {
+		spin_lock(&kvm->mmu_lock);
 		kvm_mmu_slot_remove_write_access(kvm, mem->slot);
-	spin_unlock(&kvm->mmu_lock);
+		spin_unlock(&kvm->mmu_lock);
+	}
 	/*
 	 * If memory slot is created, or moved, we need to clear all
 	 * mmio sptes.
-- 
1.7.5.4

