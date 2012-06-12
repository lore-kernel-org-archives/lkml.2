Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2FLCtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:49:43 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:54773 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2FLCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:49:41 -0400
Message-ID: <4FD6AE3B.9020508@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:49:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 6/6] KVM: introduce readonly memslot
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
In-Reply-To: <4FD6ADA6.40008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061116-1618-0000-0000-000001CF72BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, if we map a readonly memory space from host to guest
and the page is not currently mapped in the host, we will get a fault-pfn
and async is not allowed, then the vm will crash

Address Avi's idea, we introduce readonly memory region to map ROM/ROMD
to the guest

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/api.txt |    9 ++++--
 arch/x86/kvm/x86.c                |    1 +
 include/linux/kvm.h               |    4 ++-
 virt/kvm/kvm_main.c               |   61 ++++++++++++++++++++++++++++--------
 4 files changed, 57 insertions(+), 18 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 310fe50..a97ee90 100644
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
@@ -873,9 +874,11 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.

-The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
+The flags field supports two flag, KVM_MEM_LOG_DIRTY_PAGES, which
 instructs kvm to keep track of writes to memory within the slot.  See
-the KVM_GET_DIRTY_LOG ioctl.
+the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READONLY, which
++indicates the guest memory is read-only, that means, guest is only allowed
++to read it. Writes will be posted to userspace as KVM_EXIT_MMIO exits.

 When the KVM_CAP_SYNC_MMU capability, changes in the backing of the memory
 region are automatically reflected into the guest.  For example, an mmap()
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a01a424..994f47b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2148,6 +2148,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_GET_TSC_KHZ:
 	case KVM_CAP_PCI_2_3:
 	case KVM_CAP_KVMCLOCK_CTRL:
+	case KVM_CAP_READONLY_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index dc3aa2a..892d673 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -102,7 +102,8 @@ struct kvm_userspace_memory_region {
 };

 /* for kvm_memory_region::flags */
-#define KVM_MEM_LOG_DIRTY_PAGES  1UL
+#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
+#define KVM_MEM_READONLY	(1UL << 1)

 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -617,6 +618,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_GET_SMMU_INFO 78
 #define KVM_CAP_S390_COW 79
 #define KVM_CAP_PPC_ALLOC_HTAB 80
+#define KVM_CAP_READONLY_MEM 81

 #ifdef KVM_CAP_IRQ_ROUTING

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4b96bc2..b551db1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -688,7 +688,7 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)

 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 {
-	if (mem->flags & ~KVM_MEM_LOG_DIRTY_PAGES)
+	if (mem->flags & ~(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY))
 		return -EINVAL;

 	return 0;
@@ -1033,10 +1033,11 @@ out:
 	return size;
 }

-static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
-				     gfn_t *nr_pages)
+static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				     gfn_t *nr_pages, bool write)
 {
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
+	      ((slot->flags & KVM_MEM_READONLY) && write))
 		return bad_hva();

 	if (nr_pages)
@@ -1045,6 +1046,12 @@ static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 	return gfn_to_hva_memslot(slot, gfn);
 }

+static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				     gfn_t *nr_pages)
+{
+	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
+}
+
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
@@ -1057,7 +1064,7 @@ EXPORT_SYMBOL_GPL(gfn_to_hva);
  */
 static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
+	return __gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL, false);
 }

 static int kvm_read_hva(void *data, void *hva, int len)
@@ -1098,6 +1105,34 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
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
+static int hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
+			bool slot_writable, bool *writable, struct page **page)
+{
+	int npages = 0;
+
+	if (!slot_writable)
+		return 0;
+
+	if (writable)
+		*writable = true;
+
+	if (atomic || async)
+		npages = __get_user_pages_fast(addr, 1, 1, page);
+
+	return npages;
+}
+
 static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			unsigned long addr, bool atomic, bool *async,
 			bool write_fault, bool *writable)
@@ -1105,18 +1140,16 @@ static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	struct page *page[1];
 	int npages = 0;
 	pfn_t pfn;
+	bool slot_writable = !(slot->flags & KVM_MEM_READONLY);

 	/* we can do it either atomically or asynchronously, not both */
 	BUG_ON(atomic && async);

 	BUG_ON(!write_fault && !writable);
+	BUG_ON(write_fault && !slot_writable);

-	if (writable)
-		*writable = true;
-
-	if (atomic || async)
-		npages = __get_user_pages_fast(addr, 1, 1, page);
-
+	npages = hva_to_pfn_fast(addr, atomic, async, slot_writable,
+				 writable, page);
 	if (unlikely(npages != 1) && !atomic) {
 		might_sleep();

@@ -1133,7 +1166,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 						     page);

 		/* map read fault as writable if possible */
-		if (unlikely(!write_fault) && npages == 1) {
+		if (unlikely(!write_fault) && npages == 1 && slot_writable) {
 			struct page *wpage[1];

 			npages = __get_user_pages_fast(addr, 1, 1, wpage);
@@ -1169,7 +1202,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 				vma->vm_pgoff;
 			BUG_ON(!kvm_is_mmio_pfn(pfn));
 		} else {
-			if (async && (vma->vm_flags & VM_WRITE))
+			if (async && vma_is_valid(vma, write_fault))
 				*async = true;
 			pfn = get_fault_pfn();
 		}
@@ -1190,7 +1223,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 		*async = false;

 	slot = gfn_to_memslot(kvm, gfn);
-	addr = gfn_to_hva_many(slot, gfn, NULL);
+	addr = __gfn_to_hva_many(slot, gfn, NULL, write_fault);

 	if (kvm_is_error_hva(addr)) {
 		get_page(bad_page);
-- 
1.7.7.6

