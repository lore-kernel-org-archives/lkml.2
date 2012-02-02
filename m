Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2BBFk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:40:28 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59065 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2BBFk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:40:27 -0500
Date: Thu, 2 Feb 2012 14:46:33 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: [test result] dirty logging without srcu update -- Re: [RFC][PATCH]
 srcu: Implement call_srcu()
Message-Id: <20120202144633.1fc9b997.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F293D14.5030008@redhat.com>
References: <1328016724.2446.229.camel@twins>
	<4F27F0E6.1040309@redhat.com>
	<1328017807.2446.230.camel@twins>
	<20120131222447.GH2391@linux.vnet.ibm.com>
	<1328091749.2760.34.camel@laptop>
	<4F29178A.1090306@redhat.com>
	<4F2918D5.4050104@redhat.com>
	<4F291B56.30600@oss.ntt.co.jp>
	<4F291B92.8070402@redhat.com>
	<4F291E1F.3030505@oss.ntt.co.jp>
	<4F293D14.5030008@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> >> That'll be great, numbers are better than speculation.
> >>
> >
> >
> > Yes, I already have some good numbers to show (and some patches).
> 
> Looking forward.

I made a patch to see if Avi's suggestion of getting rid of srcu
update for dirty logging is practical;  tested with my unit-test.

(I used a function to write protect a range of pages using rmap,
 which is itself useful for optimizing the current code.)

1. test result

on 32bit host (core i3 box)   // just for the unit-test ...
slot size: 256K pages (1GB memory)


Measured by dirty-log-perf (executed only once for each case)

Note: dirty pages are completely distributed
      (no locality: worst case for my patch?)

=========================================================
# of dirty pages:  kvm.git (ns),  with this patch (ns)
1:         102,077 ns      10,105 ns
2:          47,197 ns       9,395 ns
4:          43,563 ns       9,938 ns
8:          41,239 ns      10,618 ns
16:         42,988 ns      12,299 ns
32:         45,503 ns      14,298 ns
64:         50,915 ns      19,895 ns
128:        61,087 ns      29,260 ns
256:        81,007 ns      49,023 ns
512:       132,776 ns      86,670 ns
1024:      939,299 ns     131,496 ns
2048:      992,209 ns     250,429 ns
4096:      891,809 ns     479,280 ns
8192:    1,027,280 ns     906,971 ns
(until now pretty good)

(ah, for every 32-bit atomic clear mask ...)
16384:   1,270,972 ns   6,661,741 ns    //  1  1  1 ...  1
32768:   1,581,335 ns   9,673,985 ns    //  ...
65536:   2,161,604 ns  11,466,134 ns    //  ...
131072:  3,253,027 ns  13,412,954 ns    //  ...
262144:  5,663,002 ns  16,309,924 ns    // 31 31 31 ... 31
=========================================================

According to a 2005 usenix paper, WWS with a 8sec window was
about 50,000 pages for a high dirtying rate program.

Taking into acount of another possible gains from the WWS locality
of real workloads, these numbers are not so bad IMO.

Furthermore the code has been made for initial test only and I did
not do any optimization:  I know what I should try.

So this seems worth more testing.


The new code also makes it possible to do find-grained get dirty log.
Live migration can be done like this ??? (not sure yet):

	until the dirty rate becomes enough low
		get dirty log for the first 32K pages (partial return is OK)
		while sending
		get dirty log for the next 32K pages  (partial return is OK)
		while sending
		...
		get dirty log for the last 32K pages  (partial return is OK)

	stop the guest and get dirty log (but no need to write protect now)
	send the remaining pages

New API is needed for this as discussed before!


Thanks,
	Takuya



2. test patch

[PATCH for test only] KVM: dirty logging: avoid srcu and ...

VGA works normally but not tested enough yet.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/mmu.c              |   48 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |   55 ++++++++++++++++----------------------
 include/linux/kvm_host.h        |    7 +++++
 virt/kvm/kvm_main.c             |    7 +----
 5 files changed, 79 insertions(+), 40 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4610166..e9bbef1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -684,6 +684,8 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
+void kvm_mmu_write_protect_range(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t start, gfn_t end);
 int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
 			       struct kvm_memory_slot *slot);
 void kvm_mmu_zap_all(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ae76cc3..62cc3a9 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -688,8 +688,7 @@ static struct kvm_lpage_info *lpage_info_slot(gfn_t gfn,
 {
 	unsigned long idx;
 
-	idx = (gfn >> KVM_HPAGE_GFN_SHIFT(level)) -
-	      (slot->base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
+	idx = gfn_to_index(gfn, slot->base_gfn, level);
 	return &slot->lpage_info[level - 2][idx];
 }
 
@@ -1011,6 +1010,51 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
 		rmap_remove(kvm, sptep);
 }
 
+static void write_protect_range(struct kvm *kvm,
+				struct kvm_memory_slot *slot, int level,
+				gfn_t start, gfn_t end)
+{
+	unsigned long *rmapp;
+	u64 *spte;
+	gfn_t gfn;
+
+	if (level == PT_PAGE_TABLE_LEVEL) {
+		for (gfn = start; gfn < end; gfn++) {
+			rmapp = __gfn_to_rmap(gfn, level, slot);
+			spte = rmap_next(rmapp, NULL);
+			while (spte) {
+				if (is_writable_pte(*spte))
+					mmu_spte_update(spte, *spte & ~PT_WRITABLE_MASK);
+				spte = rmap_next(rmapp, spte);
+			}
+		}
+	} else {
+		for (gfn = start; gfn < end; gfn++) {
+			rmapp = __gfn_to_rmap(gfn, level, slot);
+			spte = rmap_next(rmapp, NULL);
+			while (spte) {
+				if (is_writable_pte(*spte)) {
+					drop_spte(kvm, spte);
+					--kvm->stat.lpages;
+					spte = NULL;
+				}
+				spte = rmap_next(rmapp, spte);
+			}
+		}
+	}
+}
+
+void kvm_mmu_write_protect_range(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t start, gfn_t end)
+{
+	int i;
+
+	for (i = PT_PAGE_TABLE_LEVEL;
+	     i < PT_PAGE_TABLE_LEVEL + KVM_NR_PAGE_SIZES; ++i) {
+		write_protect_range(kvm, slot, i, start, end);
+	}
+}
+
 int kvm_mmu_rmap_write_protect(struct kvm *kvm, u64 gfn,
 			       struct kvm_memory_slot *slot)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2bd77a3..becb571 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3049,7 +3049,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 {
 	int r;
 	struct kvm_memory_slot *memslot;
-	unsigned long n, nr_dirty_pages;
+	unsigned long n, i;
+	unsigned bits;
+	unsigned *dirty_bitmap;
+	unsigned __user *dirty_bitmap_user;
 
 	mutex_lock(&kvm->slots_lock);
 
@@ -3063,44 +3066,32 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		goto out;
 
 	n = kvm_dirty_bitmap_bytes(memslot);
-	nr_dirty_pages = memslot->nr_dirty_pages;
+	r = -EFAULT;
+	if (clear_user(log->dirty_bitmap, n))
+		goto out;
 
-	/* If nothing is dirty, don't bother messing with page tables. */
-	if (nr_dirty_pages) {
-		struct kvm_memslots *slots, *old_slots;
-		unsigned long *dirty_bitmap, *dirty_bitmap_head;
+	dirty_bitmap = (unsigned *)memslot->dirty_bitmap;
+	dirty_bitmap_user = (unsigned __user *)log->dirty_bitmap;
 
-		dirty_bitmap = memslot->dirty_bitmap;
-		dirty_bitmap_head = memslot->dirty_bitmap_head;
-		if (dirty_bitmap == dirty_bitmap_head)
-			dirty_bitmap_head += n / sizeof(long);
-		memset(dirty_bitmap_head, 0, n);
+	for (i = 0; i < n / sizeof(unsigned); i++) {
+		gfn_t start, end;
 
-		r = -ENOMEM;
-		slots = kmemdup(kvm->memslots, sizeof(*kvm->memslots), GFP_KERNEL);
-		if (!slots)
-			goto out;
-
-		memslot = id_to_memslot(slots, log->slot);
-		memslot->nr_dirty_pages = 0;
-		memslot->dirty_bitmap = dirty_bitmap_head;
-		update_memslots(slots, NULL);
+		if (!(bits = dirty_bitmap[i]))
+			continue;
 
-		old_slots = kvm->memslots;
-		rcu_assign_pointer(kvm->memslots, slots);
-		synchronize_srcu_expedited(&kvm->srcu);
-		kfree(old_slots);
+		start = memslot->base_gfn + 8 * sizeof(unsigned) * i;
+		end   = start;
+		start += __ffs(bits);
+		end   += __fls(bits) + 1;
+		atomic_clear_mask(bits, &dirty_bitmap[i]);
 
-		write_protect_slot(kvm, memslot, dirty_bitmap, nr_dirty_pages);
+		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_write_protect_range(kvm, memslot, start, end);
+		spin_unlock(&kvm->mmu_lock);
 
-		r = -EFAULT;
-		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n))
-			goto out;
-	} else {
-		r = -EFAULT;
-		if (clear_user(log->dirty_bitmap, n))
-			goto out;
+		__put_user(bits, &dirty_bitmap_user[i]);
 	}
+	kvm_flush_remote_tlbs(kvm);
 
 	r = 0;
 out:
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eada8e6..06d4e41 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -656,6 +656,13 @@ static inline int memslot_id(struct kvm *kvm, gfn_t gfn)
 	return gfn_to_memslot(kvm, gfn)->id;
 }
 
+static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
+{
+	/* KVM_HPAGE_GFN_SHIFT(PT_PAGE_TABLE_LEVEL) must be 0. */
+	return (gfn >> KVM_HPAGE_GFN_SHIFT(level)) -
+		(base_gfn >> KVM_HPAGE_GFN_SHIFT(level));
+}
+
 static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
 					       gfn_t gfn)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f32bff..e483ae4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -797,15 +797,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		int lpages;
 		int level = i + 2;
 
-		/* Avoid unused variable warning if no large pages */
-		(void)level;
-
 		if (new.lpage_info[i])
 			continue;
 
-		lpages = 1 + ((base_gfn + npages - 1)
-			     >> KVM_HPAGE_GFN_SHIFT(level));
-		lpages -= base_gfn >> KVM_HPAGE_GFN_SHIFT(level);
+		lpages = gfn_to_index(base_gfn + npages - 1, base_gfn, level) + 1;
 
 		new.lpage_info[i] = vzalloc(lpages * sizeof(*new.lpage_info[i]));
 
-- 
1.7.5.4
