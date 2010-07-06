Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0GFKvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 06:51:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0GFKvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 06:51:40 -0400
Message-ID: <4C3309D3.6010109@cn.fujitsu.com>
Date: Tue, 06 Jul 2010 18:47:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH v5 4/9] KVM: MMU: introduce gfn_to_pfn_atomic() function
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce gfn_to_pfn_atomic(), it's the fast path and can used in atomic
context, the later patch will use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e796326..e0fb543 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -295,6 +295,7 @@ void kvm_release_page_dirty(struct page *page);
 void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
 pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a60b6b0..5467fe5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -934,19 +934,25 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
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
+			goto return_bad_page;
+
 		down_read(&current->mm->mmap_sem);
 		if (is_hwpoison_address(addr)) {
 			up_read(&current->mm->mmap_sem);
@@ -959,6 +965,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 		if (vma == NULL || addr < vma->vm_start ||
 		    !(vma->vm_flags & VM_PFNMAP)) {
 			up_read(&current->mm->mmap_sem);
+return_bad_page:
 			get_page(bad_page);
 			return page_to_pfn(bad_page);
 		}
@@ -972,7 +979,7 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 	return pfn;
 }
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic)
 {
 	unsigned long addr;
 
@@ -982,7 +989,18 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		return page_to_pfn(bad_page);
 	}
 
-	return hva_to_pfn(kvm, addr);
+	return hva_to_pfn(kvm, addr, atomic);
+}
+
+pfn_t gfn_to_pfn_atomic(struct kvm *kvm, gfn_t gfn)
+{
+	return __gfn_to_pfn(kvm, gfn, true);
+}
+EXPORT_SYMBOL_GPL(gfn_to_pfn_atomic);
+
+pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+{
+	return __gfn_to_pfn(kvm, gfn, false);
 }
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
@@ -990,7 +1008,7 @@ pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
 			 struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
-	return hva_to_pfn(kvm, addr);
+	return hva_to_pfn(kvm, addr, false);
 }
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
-- 
1.6.1.2


