Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab0EDNAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:00:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47870 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab0EDNAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:00:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=xEOcBv8W+zLo9GAg8k+EDheqdJNryEKeY7ohllWVa+bZPR3tYHonvqB7w8ddLq3Hug
         5/6a6qWDchN1+Ay+vv6yuwvJjOfVxjq/qVyUHw5s3SS2BQyKFCmOgZHlpmTWIeRXKvHp
         /gbJeG6uUtrDNccJTp6i4arY85Op3wCN7Ybjo=
Date: Tue, 4 May 2010 22:00:11 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/12] KVM: introduce slot level dirty state management
Message-Id: <20100504220011.802c0b52.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces is_dirty member for each memory slot.
Using this member, we remove the dirty bitmap scans which are done in
get_dirty_log().

This is important for moving dirty bitmaps to user space because we don't
have any good ways to check bitmaps in user space with low cost and scanning
bitmaps to check memory slot dirtiness will not be acceptable.

When we mark a slot dirty:
 - x86 and ppc: at the timing of mark_page_dirty()
 - ia64: at the timing of kvm_ia64_sync_dirty_log()
ia64 uses a different place to store dirty logs and synchronize it with
the logs of memory slots right before the get_dirty_log(). So we use this
timing to update is_dirty.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>
---
 arch/ia64/kvm/kvm-ia64.c  |   11 +++++++----
 arch/powerpc/kvm/book3s.c |    9 ++++-----
 arch/x86/kvm/x86.c        |    9 +++------
 include/linux/kvm_host.h  |    4 ++--
 virt/kvm/kvm_main.c       |   13 +++----------
 5 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d5f4e91..17fd65c 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1824,6 +1824,9 @@ static int kvm_ia64_sync_dirty_log(struct kvm *kvm,
 	base = memslot->base_gfn / BITS_PER_LONG;
 
 	for (i = 0; i < n/sizeof(long); ++i) {
+		if (dirty_bitmap[base + i])
+			memslot->is_dirty = true;
+
 		memslot->dirty_bitmap[i] = dirty_bitmap[base + i];
 		dirty_bitmap[base + i] = 0;
 	}
@@ -1838,7 +1841,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	int r;
 	unsigned long n;
 	struct kvm_memory_slot *memslot;
-	int is_dirty = 0;
 
 	mutex_lock(&kvm->slots_lock);
 	spin_lock(&kvm->arch.dirty_log_lock);
@@ -1847,16 +1849,17 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (r)
 		goto out;
 
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log);
 	if (r)
 		goto out;
 
+	memslot = &kvm->memslots->memslots[log->slot];
 	/* If nothing is dirty, don't bother messing with page tables. */
-	if (is_dirty) {
+	if (memslot->is_dirty) {
 		kvm_flush_remote_tlbs(kvm);
-		memslot = &kvm->memslots->memslots[log->slot];
 		n = kvm_dirty_bitmap_bytes(memslot);
 		memset(memslot->dirty_bitmap, 0, n);
+		memslot->is_dirty = false;
 	}
 	r = 0;
 out:
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 28e785f..4b074f1 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -1191,20 +1191,18 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	struct kvm_memory_slot *memslot;
 	struct kvm_vcpu *vcpu;
 	ulong ga, ga_end;
-	int is_dirty = 0;
 	int r;
 	unsigned long n;
 
 	mutex_lock(&kvm->slots_lock);
 
-	r = kvm_get_dirty_log(kvm, log, &is_dirty);
+	r = kvm_get_dirty_log(kvm, log);
 	if (r)
 		goto out;
 
+	memslot = &kvm->memslots->memslots[log->slot];
 	/* If nothing is dirty, don't bother messing with page tables. */
-	if (is_dirty) {
-		memslot = &kvm->memslots->memslots[log->slot];
-
+	if (memslot->is_dirty) {
 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
 
@@ -1213,6 +1211,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 		n = kvm_dirty_bitmap_bytes(memslot);
 		memset(memslot->dirty_bitmap, 0, n);
+		memslot->is_dirty = false;
 	}
 
 	r = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b95a211..023c7f8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2740,10 +2740,9 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				      struct kvm_dirty_log *log)
 {
-	int r, i;
+	int r;
 	struct kvm_memory_slot *memslot;
 	unsigned long n;
-	unsigned long is_dirty = 0;
 
 	mutex_lock(&kvm->slots_lock);
 
@@ -2758,11 +2757,8 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 
 	n = kvm_dirty_bitmap_bytes(memslot);
 
-	for (i = 0; !is_dirty && i < n/sizeof(long); i++)
-		is_dirty = memslot->dirty_bitmap[i];
-
 	/* If nothing is dirty, don't bother messing with page tables. */
-	if (is_dirty) {
+	if (memslot->is_dirty) {
 		struct kvm_memslots *slots, *old_slots;
 		unsigned long *dirty_bitmap;
 
@@ -2784,6 +2780,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		}
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
+		slots->memslots[log->slot].is_dirty = false;
 
 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ce027d5..0aa6ecb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -117,6 +117,7 @@ struct kvm_memory_slot {
 	unsigned long flags;
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
+	bool is_dirty;
 	struct {
 		unsigned long rmap_pde;
 		int write_count;
@@ -335,8 +336,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 int kvm_dev_ioctl_check_extension(long ext);
 
-int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty);
+int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 				struct kvm_dirty_log *log);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9ab1a77..7ab6312 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -768,13 +768,11 @@ int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem, user_alloc);
 }
 
-int kvm_get_dirty_log(struct kvm *kvm,
-			struct kvm_dirty_log *log, int *is_dirty)
+int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
 {
 	struct kvm_memory_slot *memslot;
-	int r, i;
+	int r;
 	unsigned long n;
-	unsigned long any = 0;
 
 	r = -EINVAL;
 	if (log->slot >= KVM_MEMORY_SLOTS)
@@ -787,16 +785,10 @@ int kvm_get_dirty_log(struct kvm *kvm,
 
 	n = kvm_dirty_bitmap_bytes(memslot);
 
-	for (i = 0; !any && i < n/sizeof(long); ++i)
-		any = memslot->dirty_bitmap[i];
-
 	r = -EFAULT;
 	if (copy_to_user(log->dirty_bitmap, memslot->dirty_bitmap, n))
 		goto out;
 
-	if (any)
-		*is_dirty = 1;
-
 	r = 0;
 out:
 	return r;
@@ -1193,6 +1185,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
 		generic___set_le_bit(rel_gfn, memslot->dirty_bitmap);
+		memslot->is_dirty = true;
 	}
 }
 
-- 
1.7.0.4

