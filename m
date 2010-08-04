Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500Ab0HDDgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:36:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab0HDDgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:36:05 -0400
Message-ID: <4C58DF26.3060305@cn.fujitsu.com>
Date: Wed, 04 Aug 2010 11:31:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: [PATCH v6 2/3] KVM: MMU: introduce hva_to_pfn_atomic function
References: <4C58DE49.1020705@cn.fujitsu.com>
In-Reply-To: <4C58DE49.1020705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce hva_to_pfn_atomic(), it's the fast path and can used in atomic
context, the later patch will use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    7 +++++++
 virt/kvm/kvm_main.c      |   30 +++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c13cc48..307d0e2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -296,6 +296,7 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
+pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
@@ -518,6 +519,12 @@ static inline void kvm_guest_exit(void)
 	current->flags &= ~PF_VCPU;
 }
 
+static inline unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot,
+					       gfn_t gfn)
+{
+	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
+}
+
 static inline gpa_t gfn_to_gpa(gfn_t gfn)
 {
 	return (gpa_t)gfn << PAGE_SHIFT;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b78b794..2dc0c18 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -927,11 +927,6 @@ int memslot_id(struct kvm *kvm, gfn_t gfn)
 	return memslot - slots->memslots;
 }
 
-static unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
-}
-
 unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
@@ -943,19 +938,25 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
-static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
+static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic)
 {
 	struct page *page[1];
 	int npages;
 	pfn_t pfn;
 
-	might_sleep();
-
-	npages = get_user_pages_fast(addr, 1, 1, page);
+	if (atomic)
+		npages = __get_user_pages_fast(addr, 1, 1, page);
+	else {
+		might_sleep();
+		npages = get_user_pages_fast(addr, 1, 1, page);
+	}
 
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
+		if (atomic)
+			goto return_fault_page;
+
 		down_read(&current->mm->mmap_sem);
 		if (is_hwpoison_address(addr)) {
 			up_read(&current->mm->mmap_sem);
@@ -968,6 +969,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 		if (vma == NULL || addr < vma->vm_start ||
 		    !(vma->vm_flags & VM_PFNMAP)) {
 			up_read(&current->mm->mmap_sem);
+return_fault_page:
 			get_page(fault_page);
 			return page_to_pfn(fault_page);
 		}
@@ -981,6 +983,12 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 	return pfn;
 }
 
+pfn_t hva_to_pfn_atomic(struct kvm *kvm, unsigned long addr)
+{
+	return hva_to_pfn(kvm, addr, true);
+}
+EXPORT_SYMBOL_GPL(hva_to_pfn_atomic);
+
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned long addr;
@@ -991,7 +999,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	return hva_to_pfn(kvm, addr);
+	return hva_to_pfn(kvm, addr, false);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
@@ -999,7 +1007,7 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(kvm, addr);
+	return hva_to_pfn(kvm, addr, false);
 }
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
-- 
1.6.1.2


