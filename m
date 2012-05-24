Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2EXJjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:39:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42591 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2EXJjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:39:52 -0400
Message-ID: <4FBDFE52.5090902@linux.vnet.ibm.com>
Date: Thu, 24 May 2012 17:24:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: introduce readonly memory region
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052409-2674-0000-0000-000004AA3816
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
 Documentation/virtual/kvm/api.txt |    9 +++++--
 include/linux/kvm.h               |    5 ++-
 virt/kvm/kvm_main.c               |   43 ++++++++++++++++++++++++++++++-------
 3 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 9301266..e2a82c3 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -857,7 +857,8 @@ struct kvm_userspace_memory_region {
 };

 /* for kvm_memory_region::flags */
-#define KVM_MEM_LOG_DIRTY_PAGES  1UL
+#define KVM_MEM_LOG_DIRTY_PAGES		1UL
+#define KVM_MEM_READ_ONLY		(1UL << 2)

 This ioctl allows the user to create or modify a guest physical memory
 slot.  When changing an existing slot, it may be moved in the guest
@@ -873,9 +874,11 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.

-The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
+The flags field supports two flags, KVM_MEM_LOG_DIRTY_PAGES, which
 instructs kvm to keep track of writes to memory within the slot.  See
-the KVM_GET_DIRTY_LOG ioctl.
+the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READ_ONLY, which
+indicates the guest memory is read-only, that means, guest is only allowed
+to read it.

 When the KVM_CAP_SYNC_MMU capability, changes in the backing of the memory
 region are automatically reflected into the guest.  For example, an mmap()
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 09f2b3a..d178e3d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -102,8 +102,9 @@ struct kvm_userspace_memory_region {
 };

 /* for kvm_memory_region::flags */
-#define KVM_MEM_LOG_DIRTY_PAGES  1UL
-#define KVM_MEMSLOT_INVALID      (1UL << 1)
+#define KVM_MEM_LOG_DIRTY_PAGES		1UL
+#define KVM_MEMSLOT_INVALID		(1UL << 1)
+#define KVM_MEM_READ_ONLY		(1UL << 2)

 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7e14068..27283e4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1009,10 +1009,11 @@ out:
 	return size;
 }

-static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
-				     gfn_t *nr_pages)
+static unsigned long __gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				       gfn_t *nr_pages, bool write)
 {
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
+	      ((slot->flags & KVM_MEM_READ_ONLY) && write))
 		return bad_hva();

 	if (nr_pages)
@@ -1021,6 +1022,17 @@ static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
 	return gfn_to_hva_memslot(slot, gfn);
 }

+static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,
+				     gfn_t *nr_pages)
+{
+	return __gfn_to_hva_many(slot, gfn, nr_pages, true);
+}
+
+unsigned long gfn_to_hva_prot(struct kvm *kvm, gfn_t gfn, bool write)
+{
+	return __gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL, write);
+}
+
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
@@ -1053,6 +1065,21 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }

+static bool vma_is_avalid(struct vm_area_struct *vma, bool write_fault)
+{
+	if (write_fault) {
+		if (unlikely(!(vma->vm_flags & VM_WRITE)))
+			return false;
+
+		return true;
+	}
+
+	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
+		return false;
+
+	return true;
+}
+
 static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 			bool *async, bool write_fault, bool *writable)
 {
@@ -1076,7 +1103,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,

 		if (writable)
 			*writable = write_fault;
-
 		if (async) {
 			down_read(&current->mm->mmap_sem);
 			npages = get_user_page_nowait(current, current->mm,
@@ -1123,8 +1149,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
 				vma->vm_pgoff;
 			BUG_ON(!kvm_is_mmio_pfn(pfn));
 		} else {
-			if (async && (vma->vm_flags & VM_WRITE))
+			if (async && vma_is_avalid(vma, write_fault))
 				*async = true;
+
 			pfn = get_fault_pfn();
 		}
 		up_read(&current->mm->mmap_sem);
@@ -1148,7 +1175,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
 	if (async)
 		*async = false;

-	addr = gfn_to_hva(kvm, gfn);
+	addr = gfn_to_hva_prot(kvm, gfn, write_fault);
 	if (kvm_is_error_hva(addr)) {
 		get_page(bad_page);
 		return page_to_pfn(bad_page);
@@ -1293,7 +1320,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 	int r;
 	unsigned long addr;

-	addr = gfn_to_hva(kvm, gfn);
+	addr = gfn_to_hva_prot(kvm, gfn, false);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	r = __copy_from_user(data, (void __user *)addr + offset, len);
@@ -1331,7 +1358,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	int offset = offset_in_page(gpa);

-	addr = gfn_to_hva(kvm, gfn);
+	addr = gfn_to_hva_prot(kvm, gfn, false);
 	if (kvm_is_error_hva(addr))
 		return -EFAULT;
 	pagefault_disable();
-- 
1.7.7.6

