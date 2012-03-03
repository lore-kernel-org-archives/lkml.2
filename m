Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2CCFVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 00:21:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62855 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2CCFVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 00:21:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of takuya.yoshikawa@gmail.com designates 10.68.136.234 as permitted sender) smtp.mail=takuya.yoshikawa@gmail.com; dkim=pass header.i=takuya.yoshikawa@gmail.com
Date: Sat, 3 Mar 2012 14:21:48 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
In-Reply-To: <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have seen some problems of the current implementation of
get_dirty_log() which uses synchronize_srcu_expedited() for updating
dirty bitmaps; e.g. it is noticeable that this sometimes gives us ms
order of latency when we use VGA displays.

Furthermore the recent discussion on the following thread
    "srcu: Implement call_srcu()"
    http://lkml.org/lkml/2012/1/31/211
also motivated us to implement get_dirty_log() without SRCU.

This patch achieves this goal without sacrificing the performance of
both VGA and live migration: in practice the new code is much faster
than the old one unless we have too many dirty pages.

Implementation:

The key part of the implementation is the use of xchg() operation for
clearing dirty bits atomically.  Since this allows us to update only
BITS_PER_LONG pages at once, we need to iterate over the dirty bitmap
until every dirty bit is cleared again for the next call.

Although some people may worry about the problem of using the atomic
memory instruction many times to the concurrently accessible bitmap,
it is usually accessed with mmu_lock held and we rarely see concurrent
accesses: so what we need to care about is the pure xchg() overheads.

Another point to note is that we do not use for_each_set_bit() to check
which ones in each BITS_PER_LONG pages are actually dirty.  Instead we
simply use __ffs() in a loop.  This is much faster than repeatedly call
find_next_bit().

Performance:

The dirty-log-perf unit test showed nice improvements, some times faster
than before, except for some extreme cases; for such cases the speed of
getting dirty page information is much faster than we process it in the
userspace.

For real workloads, both VGA and live migration, we have observed pure
improvements: when the guest was reading a file during live migration,
we originally saw a few ms of latency, but with the new method the
latency was less than 200us.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/kvm/x86.c |  116 +++++++++++++++++++--------------------------------
 1 files changed, 43 insertions(+), 73 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3bc1922..0748bab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3041,55 +3041,32 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 }
 
 /**
- * write_protect_slot - write protect a slot for dirty logging
- * @kvm: the kvm instance
- * @memslot: the slot we protect
- * @dirty_bitmap: the bitmap indicating which pages are dirty
- * @nr_dirty_pages: the number of dirty pages
+ * kvm_vm_ioctl_get_dirty_log - get and clear the log of dirty pages in a slot
+ * @kvm: kvm instance
+ * @log: slot id and address to which we copy the log
  *
- * We have two ways to find all sptes to protect:
- * 1. Use kvm_mmu_slot_remove_write_access() which walks all shadow pages and
- *    checks ones that have a spte mapping a page in the slot.
- * 2. Use kvm_mmu_rmap_write_protect() for each gfn found in the bitmap.
+ * We need to keep it in mind that VCPU threads can write to the bitmap
+ * concurrently.  So, to avoid losing data, we keep the following order for
+ * each bit:
  *
- * Generally speaking, if there are not so many dirty pages compared to the
- * number of shadow pages, we should use the latter.
+ *   1. Take a snapshot of the bit and clear it if needed.
+ *   2. Write protect the corresponding page.
+ *   3. Flush TLB's if needed.
+ *   4. Copy the snapshot to the userspace.
  *
- * Note that letting others write into a page marked dirty in the old bitmap
- * by using the remaining tlb entry is not a problem.  That page will become
- * write protected again when we flush the tlb and then be reported dirty to
- * the user space by copying the old bitmap.
+ * Between 2 and 3, the guest may write to the page using the remaining TLB
+ * entry.  This is not a problem because the page will be reported dirty at
+ * step 4 using the snapshot taken before and step 3 ensures that successive
+ * writes will be logged for the next call.
  */
-static void write_protect_slot(struct kvm *kvm,
-			       struct kvm_memory_slot *memslot,
-			       unsigned long *dirty_bitmap,
-			       unsigned long nr_dirty_pages)
-{
-	spin_lock(&kvm->mmu_lock);
-
-	/* Not many dirty pages compared to # of shadow pages. */
-	if (nr_dirty_pages < kvm->arch.n_used_mmu_pages) {
-		gfn_t offset;
-
-		for_each_set_bit(offset, dirty_bitmap, memslot->npages)
-			kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, 1);
-
-		kvm_flush_remote_tlbs(kvm);
-	} else
-		kvm_mmu_slot_remove_write_access(kvm, memslot->id);
-
-	spin_unlock(&kvm->mmu_lock);
-}
-
-/*
- * Get (and clear) the dirty memory log for a memory slot.
- */
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
-				      struct kvm_dirty_log *log)
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
 	int r;
 	struct kvm_memory_slot *memslot;
-	unsigned long n, nr_dirty_pages;
+	unsigned long n, i;
+	unsigned long *dirty_bitmap;
+	unsigned long *dirty_bitmap_buffer;
+	bool is_dirty = false;
 
 	mutex_lock(&kvm->slots_lock);
 
@@ -3098,49 +3075,42 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		goto out;
 
 	memslot = id_to_memslot(kvm->memslots, log->slot);
+
+	dirty_bitmap = memslot->dirty_bitmap;
 	r = -ENOENT;
-	if (!memslot->dirty_bitmap)
+	if (!dirty_bitmap)
 		goto out;
 
 	n = kvm_dirty_bitmap_bytes(memslot);
-	nr_dirty_pages = memslot->nr_dirty_pages;
 
-	/* If nothing is dirty, don't bother messing with page tables. */
-	if (nr_dirty_pages) {
-		struct kvm_memslots *slots, *old_slots;
-		unsigned long *dirty_bitmap, *dirty_bitmap_head;
+	dirty_bitmap_buffer = dirty_bitmap + n / sizeof(long);
+	memset(dirty_bitmap_buffer, 0, n);
 
-		dirty_bitmap = memslot->dirty_bitmap;
-		dirty_bitmap_head = memslot->dirty_bitmap_head;
-		if (dirty_bitmap == dirty_bitmap_head)
-			dirty_bitmap_head += n / sizeof(long);
-		memset(dirty_bitmap_head, 0, n);
+	spin_lock(&kvm->mmu_lock);
 
-		r = -ENOMEM;
-		slots = kmemdup(kvm->memslots, sizeof(*kvm->memslots), GFP_KERNEL);
-		if (!slots)
-			goto out;
+	for (i = 0; i < n / sizeof(long); i++) {
+		unsigned long mask;
+		gfn_t offset;
 
-		memslot = id_to_memslot(slots, log->slot);
-		memslot->nr_dirty_pages = 0;
-		memslot->dirty_bitmap = dirty_bitmap_head;
-		update_memslots(slots, NULL);
+		if (!dirty_bitmap[i])
+			continue;
 
-		old_slots = kvm->memslots;
-		rcu_assign_pointer(kvm->memslots, slots);
-		synchronize_srcu_expedited(&kvm->srcu);
-		kfree(old_slots);
+		is_dirty = true;
 
-		write_protect_slot(kvm, memslot, dirty_bitmap, nr_dirty_pages);
+		mask = xchg(&dirty_bitmap[i], 0);
+		dirty_bitmap_buffer[i] = mask;
 
-		r = -EFAULT;
-		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
-			goto out;
-	} else {
-		r = -EFAULT;
-		if (clear_user(log->dirty_bitmap, n))
-			goto out;
+		offset = i * BITS_PER_LONG;
+		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
 	}
+	if (is_dirty)
+		kvm_flush_remote_tlbs(kvm);
+
+	spin_unlock(&kvm->mmu_lock);
+
+	r = -EFAULT;
+	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
+		goto out;
 
 	r = 0;
 out:
-- 
1.7.5.4

--
To unsubscribe from this list: send the line "unsubscribe kvm" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
