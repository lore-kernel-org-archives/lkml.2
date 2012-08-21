Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab2HUDDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 23:03:15 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:45159 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2HUDDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 23:03:07 -0400
Message-ID: <5032FA5B.5040308@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 11:02:51 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 11/12] KVM: introduce readonly memslot
References: <5032F8FD.2020306@linux.vnet.ibm.com>
In-Reply-To: <5032F8FD.2020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082103-8878-0000-0000-000003AE2226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, if we map a readonly memory space from host to guest
and the page is not currently mapped in the host, we will get a fault
pfn and async is not allowed, then the vm will crash

We introduce readonly memory region to map ROM/ROMD to the guest, read access
is happy for readonly memslot, write access on readonly memslot will cause
KVM_EXIT_MMIO exit

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/api.txt |   10 +++-
 arch/x86/include/asm/kvm.h        |    1 +
 arch/x86/kvm/mmu.c                |    9 ++++
 arch/x86/kvm/x86.c                |    1 +
 include/linux/kvm.h               |    6 ++-
 include/linux/kvm_host.h          |    7 +--
 virt/kvm/kvm_main.c               |   96 ++++++++++++++++++++++++++++++-------
 7 files changed, 102 insertions(+), 28 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index bf33aaa..b91bfd4 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -857,7 +857,8 @@ struct kvm_userspace_memory_region {
 };

 /* for kvm_memory_region::flags */
-#define KVM_MEM_LOG_DIRTY_PAGES  1UL
+#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
+#define KVM_MEM_READONLY	(1UL << 1)

 This ioctl allows the user to create or modify a guest physical memory
 slot.  When changing an existing slot, it may be moved in the guest
@@ -873,9 +874,12 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.

-The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
+The flags field supports two flag, KVM_MEM_LOG_DIRTY_PAGES, which
 instructs kvm to keep track of writes to memory within the slot.  See
-the KVM_GET_DIRTY_LOG ioctl.
+the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READONLY when the
+KVM_CAP_READONLY_MEM capability, it indicates the guest memory is read-only,
+that means, guest is only allowed to read it. Writes will be posted to
+userspace as KVM_EXIT_MMIO exits.

 When the KVM_CAP_SYNC_MMU capability, changes in the backing of the memory
 region are automatically reflected into the guest.  For example, an mmap()
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 246617e..521bf25 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -25,6 +25,7 @@
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
+#define __KVM_HAVE_READONLY_MEM

 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5548971..8e312a2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2647,6 +2647,15 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *

 static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
 {
+	/*
+	 * Do not cache the mmio info caused by writing the readonly gfn
+	 * into the spte otherwise read access on readonly gfn also can
+	 * caused mmio page fault and treat it as mmio access.
+	 * Return 1 to tell kvm to emulate it.
+	 */
+	if (pfn == KVM_PFN_ERR_RO_FAULT)
+		return 1;
+
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
 		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
 		return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 704680d..42bbf41 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2175,6 +2175,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+	case KVM_CAP_READONLY_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 2de335d..d808694 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -106,7 +106,8 @@ struct kvm_userspace_memory_region {
  * other bits are reserved for kvm internal use which are defined in
  * include/linux/kvm_host.h.
  */
-#define KVM_MEM_LOG_DIRTY_PAGES  1UL
+#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
+#define KVM_MEM_READONLY	(1UL << 1)

 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -621,6 +622,9 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#ifdef __KVM_HAVE_READONLY_MEM
+#define KVM_CAP_READONLY_MEM 81
+#endif

 #ifdef KVM_CAP_IRQ_ROUTING

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a913ac7..5972c98 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -465,6 +465,7 @@ int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,

 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
+unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
@@ -792,12 +793,6 @@ hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)
 	return slot->base_gfn + gfn_offset;
 }

-static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
-					       gfn_t gfn)
-{
-	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
-}
-
 static inline gpa_t gfn_to_gpa(gfn_t gfn)
 {
 	return (gpa_t)gfn << PAGE_SHIFT;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e3e1658..3416f8a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -680,7 +680,13 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)

 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 {
-	if (mem->flags & ~KVM_MEM_LOG_DIRTY_PAGES)
+	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+
+#ifdef KVM_CAP_READONLY_MEM
+	valid_flags |= KVM_MEM_READONLY;
+#endif
+
+	if (mem->flags & ~valid_flags)
 		return -EINVAL;

 	return 0;
@@ -973,18 +979,45 @@ out:
 	return size;
 }

-static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
-				     gfn_t *nr_pages)
+static bool memslot_is_readonly(struct kvm_memory_slot *slot)
+{
+	return slot->flags & KVM_MEM_READONLY;
+}
+
+static unsigned long __gfn_to_hva_memslot(struct kvm_memory_slot *slot,
+					  gfn_t gfn)
+{
+	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
+}
+
+static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				       gfn_t *nr_pages, bool write)
 {
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return KVM_HVA_ERR_BAD;

+	if (memslot_is_readonly(slot) && write)
+		return KVM_HVA_ERR_RO_BAD;
+
 	if (nr_pages)
 		*nr_pages = slot->npages - (gfn - slot->base_gfn);

-	return gfn_to_hva_memslot(slot, gfn);
+	return __gfn_to_hva_memslot(slot, gfn);
 }

+static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				     gfn_t *nr_pages)
+{
+	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
+}
+
+unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
+				 gfn_t gfn)
+{
+	return gfn_to_hva_many(slot, gfn, NULL);
+}
+EXPORT_SYMBOL_GPL(gfn_to_hva_memslot);
+
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
@@ -997,7 +1030,7 @@ EXPORT_SYMBOL_GPL(gfn_to_hva);
  */
 static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
+	return __gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL, false);
 }

 static int kvm_read_hva(void *data, void __user *hva, int len)
@@ -1106,6 +1139,17 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 	return npages;
 }

+static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
+{
+	if (unlikely(!(vma->vm_flags & VM_READ)))
+		return false;
+
+	if (write_fault && (unlikely(!(vma->vm_flags & VM_WRITE))))
+		return false;
+
+	return true;
+}
+
 /*
  * Pin guest page in memory and return its pfn.
  * @addr: host virtual address which maps memory to the guest
@@ -1130,8 +1174,6 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);

-	BUG_ON(!write_fault && !writable);
-
 	if (hva_to_pfn_fast(addr, atomic, async, write_fault, writable, &pfn))
 		return pfn;

@@ -1158,7 +1200,7 @@ static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
 			vma->vm_pgoff;
 		BUG_ON(!kvm_is_mmio_pfn(pfn));
 	} else {
-		if (async && (vma->vm_flags & VM_WRITE))
+		if (async && vma_is_valid(vma, write_fault))
 			*async = true;
 		pfn = KVM_PFN_ERR_FAULT;
 	}
@@ -1167,19 +1209,40 @@ exit:
 	return pfn;
 }

+static pfn_t
+__gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn, bool atomic,
+		     bool *async, bool write_fault, bool *writable)
+{
+	unsigned long addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);
+
+	if (addr == KVM_HVA_ERR_RO_BAD)
+		return KVM_PFN_ERR_RO_FAULT;
+
+	if (kvm_is_error_hva(addr))
+		return KVM_PFN_ERR_BAD;
+
+	/* Do not map writable pfn in the readonly memslot. */
+	if (writable && memslot_is_readonly(slot)) {
+		*writable = false;
+		writable = NULL;
+	}
+
+	return hva_to_pfn(addr, atomic, async, write_fault,
+			  writable);
+}
+
 static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 			  bool write_fault, bool *writable)
 {
-	unsigned long addr;
+	struct kvm_memory_slot *slot;

 	if (async)
 		*async = false;

-	addr = gfn_to_hva(kvm, gfn);
-	if (kvm_is_error_hva(addr))
-		return KVM_PFN_ERR_BAD;
+	slot = gfn_to_memslot(kvm, gfn);

-	return hva_to_pfn(addr, atomic, async, write_fault, writable);
+	return __gfn_to_pfn_memslot(slot, gfn, atomic, async, write_fault,
+				    writable);
 }

 pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
@@ -1210,15 +1273,12 @@ EXPORT_SYMBOL_GPL(gfn_to_pfn_prot);

 pfn_t gfn_to_pfn_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(addr, false, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, false, NULL, true, NULL);
 }

 pfn_t gfn_to_pfn_memslot_atomic(struct kvm_memory_slot *slot, gfn_t gfn)
 {
-	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-
-	return hva_to_pfn(addr, true, NULL, true, NULL);
+	return __gfn_to_pfn_memslot(slot, gfn, true, NULL, true, NULL);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn_memslot_atomic);

-- 
1.7.7.6

