Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab0DVTbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:31:10 -0400
Received: from kroah.org ([198.145.64.141]:41635 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab0DVTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:30:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:24 2010
Message-Id: <20100422190924.604166444@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: [192/197] KVM: fix the handling of dirty bitmaps to avoid overflows
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

(Cherry-picked from commit 87bf6e7de1134f48681fd2ce4b7c1ec45458cb6d)

Int is not long enough to store the size of a dirty bitmap.

This patch fixes this problem with the introduction of a wrapper
function to calculate the sizes of dirty bitmaps.

Note: in mark_page_dirty(), we have to consider the fact that
  __set_bit() takes the offset as int, not long.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kvm/kvm-ia64.c |    9 +++++----
 arch/x86/kvm/x86.c       |    4 ++--
 include/linux/kvm_host.h |    5 +++++
 virt/kvm/kvm_main.c      |   13 ++++++++-----
 4 files changed, 20 insertions(+), 11 deletions(-)

--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1797,7 +1797,8 @@ static int kvm_ia64_sync_dirty_log(struc
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
-	long n, base;
+	long base;
+	unsigned long n;
 	unsigned long *dirty_bitmap = (unsigned long *)(kvm->arch.vm_base +
 			offsetof(struct kvm_vm_data, kvm_mem_dirty_log));
 
@@ -1810,7 +1811,7 @@ static int kvm_ia64_sync_dirty_log(struc
 	if (!memslot->dirty_bitmap)
 		goto out;
 
-	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+	n = kvm_dirty_bitmap_bytes(memslot);
 	base = memslot->base_gfn / BITS_PER_LONG;
 
 	for (i = 0; i < n/sizeof(long); ++i) {
@@ -1826,7 +1827,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		struct kvm_dirty_log *log)
 {
 	int r;
-	int n;
+	unsigned long n;
 	struct kvm_memory_slot *memslot;
 	int is_dirty = 0;
 
@@ -1844,7 +1845,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 	if (is_dirty) {
 		kvm_flush_remote_tlbs(kvm);
 		memslot = &kvm->memslots[log->slot];
-		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+		n = kvm_dirty_bitmap_bytes(memslot);
 		memset(memslot->dirty_bitmap, 0, n);
 	}
 	r = 0;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2133,7 +2133,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 				      struct kvm_dirty_log *log)
 {
 	int r;
-	int n;
+	unsigned long n;
 	struct kvm_memory_slot *memslot;
 	int is_dirty = 0;
 
@@ -2149,7 +2149,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		kvm_mmu_slot_remove_write_access(kvm, log->slot);
 		spin_unlock(&kvm->mmu_lock);
 		memslot = &kvm->memslots[log->slot];
-		n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+		n = kvm_dirty_bitmap_bytes(memslot);
 		memset(memslot->dirty_bitmap, 0, n);
 	}
 	r = 0;
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -116,6 +116,11 @@ struct kvm_memory_slot {
 	int user_alloc;
 };
 
+static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
+{
+	return ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+}
+
 struct kvm_kernel_irq_routing_entry {
 	u32 gsi;
 	u32 type;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1226,7 +1226,7 @@ skip_lpage:
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
-		unsigned dirty_bytes = ALIGN(npages, BITS_PER_LONG) / 8;
+		unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(&new);
 
 		new.dirty_bitmap = vmalloc(dirty_bytes);
 		if (!new.dirty_bitmap)
@@ -1309,7 +1309,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 {
 	struct kvm_memory_slot *memslot;
 	int r, i;
-	int n;
+	unsigned long n;
 	unsigned long any = 0;
 
 	r = -EINVAL;
@@ -1321,7 +1321,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	if (!memslot->dirty_bitmap)
 		goto out;
 
-	n = ALIGN(memslot->npages, BITS_PER_LONG) / 8;
+	n = kvm_dirty_bitmap_bytes(memslot);
 
 	for (i = 0; !any && i < n/sizeof(long); ++i)
 		any = memslot->dirty_bitmap[i];
@@ -1663,10 +1663,13 @@ void mark_page_dirty(struct kvm *kvm, gf
 	memslot = gfn_to_memslot_unaliased(kvm, gfn);
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
+		unsigned long *p = memslot->dirty_bitmap +
+					rel_gfn / BITS_PER_LONG;
+		int offset = rel_gfn % BITS_PER_LONG;
 
 		/* avoid RMW */
-		if (!test_bit(rel_gfn, memslot->dirty_bitmap))
-			set_bit(rel_gfn, memslot->dirty_bitmap);
+		if (!test_bit(offset, p))
+			set_bit(offset, p);
 	}
 }
 


