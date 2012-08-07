Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2HGJvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:51:37 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59078 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2HGJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:51:36 -0400
Message-ID: <5020E509.8070901@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:51:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 05/12] KVM: reorganize hva_to_pfn
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-2000-0000-0000-000008A059E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do too many things in hva_to_pfn, this patch reorganize the code,
let it be better readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |  159 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 97 insertions(+), 62 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 26ffc87..dd01bcb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1043,83 +1043,118 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 	return rc == -EHWPOISON;
 }

-static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
-			bool write_fault, bool *writable)
+/*
+ * The atomic path to get the writable pfn which will be stored in @pfn,
+ * true indicates success, otherwise false is returned.
+ */
+static bool hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
+			    bool write_fault, bool *writable, pfn_t *pfn)
 {
 	struct page *page[1];
-	int npages = 0;
-	pfn_t pfn;
+	int npages;

-	/* we can do it either atomically or asynchronously, not both */
-	BUG_ON(atomic && async);
+	if (!(async || atomic))
+		return false;

-	BUG_ON(!write_fault && !writable);
+	npages = __get_user_pages_fast(addr, 1, 1, page);
+	if (npages == 1) {
+		*pfn = page_to_pfn(page[0]);

-	if (writable)
-		*writable = true;
+		if (writable)
+			*writable = true;
+		return true;
+	}
+
+	return false;
+}

-	if (atomic || async)
-		npages = __get_user_pages_fast(addr, 1, 1, page);
+/*
+ * The slow path to get the pfn of the specified host virtual address,
+ * 1 indicates success, -errno is returned if error is detected.
+ */
+static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
+			   bool *writable, pfn_t *pfn)
+{
+	struct page *page[1];
+	int npages = 0;

-	if (unlikely(npages != 1) && !atomic) {
-		might_sleep();
+	might_sleep();

-		if (writable)
-			*writable = write_fault;
-
-		if (async) {
-			down_read(&current->mm->mmap_sem);
-			npages = get_user_page_nowait(current, current->mm,
-						     addr, write_fault, page);
-			up_read(&current->mm->mmap_sem);
-		} else
-			npages = get_user_pages_fast(addr, 1, write_fault,
-						     page);
-
-		/* map read fault as writable if possible */
-		if (unlikely(!write_fault) && npages == 1) {
-			struct page *wpage[1];
-
-			npages = __get_user_pages_fast(addr, 1, 1, wpage);
-			if (npages == 1) {
-				*writable = true;
-				put_page(page[0]);
-				page[0] = wpage[0];
-			}
-			npages = 1;
+	if (writable)
+		*writable = write_fault;
+
+	if (async) {
+		down_read(&current->mm->mmap_sem);
+		npages = get_user_page_nowait(current, current->mm,
+					      addr, write_fault, page);
+		up_read(&current->mm->mmap_sem);
+	} else
+		npages = get_user_pages_fast(addr, 1, write_fault,
+					     page);
+	if (npages != 1)
+		return npages;
+
+	/* map read fault as writable if possible */
+	if (unlikely(!write_fault)) {
+		struct page *wpage[1];
+
+		npages = __get_user_pages_fast(addr, 1, 1, wpage);
+		if (npages == 1) {
+			*writable = true;
+			put_page(page[0]);
+			page[0] = wpage[0];
 		}
+
+		npages = 1;
 	}
+	*pfn = page_to_pfn(page[0]);
+	return npages;
+}
+
+static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+			bool write_fault, bool *writable)
+{
+	struct vm_area_struct *vma;
+	pfn_t pfn = 0;
+	int npages;

-	if (unlikely(npages != 1)) {
-		struct vm_area_struct *vma;
+	/* we can do it either atomically or asynchronously, not both */
+	BUG_ON(atomic && async);

-		if (atomic)
-			return KVM_PFN_ERR_FAULT;
+	BUG_ON(!write_fault && !writable);

-		down_read(&current->mm->mmap_sem);
-		if (npages == -EHWPOISON ||
-			(!async && check_user_page_hwpoison(addr))) {
-			up_read(&current->mm->mmap_sem);
-			return KVM_PFN_ERR_HWPOISON;
-		}
+	if (hva_to_pfn_fast(addr, atomic, async, write_fault, writable, &pfn))
+		return pfn;

-		vma = find_vma_intersection(current->mm, addr, addr+1);
-
-		if (vma == NULL)
-			pfn = KVM_PFN_ERR_FAULT;
-		else if ((vma->vm_flags & VM_PFNMAP)) {
-			pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) +
-				vma->vm_pgoff;
-			BUG_ON(!kvm_is_mmio_pfn(pfn));
-		} else {
-			if (async && (vma->vm_flags & VM_WRITE))
-				*async = true;
-			pfn = KVM_PFN_ERR_FAULT;
-		}
-		up_read(&current->mm->mmap_sem);
-	} else
-		pfn = page_to_pfn(page[0]);
+	if (atomic)
+		return KVM_PFN_ERR_FAULT;

+	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	if (npages == 1)
+		return pfn;
+
+	down_read(&current->mm->mmap_sem);
+	if (npages == -EHWPOISON ||
+	      (!async && check_user_page_hwpoison(addr))) {
+		pfn = KVM_PFN_ERR_HWPOISON;
+		goto exit;
+	}
+
+	vma = find_vma_intersection(current->mm, addr, addr + 1);
+
+	if (vma == NULL)
+		pfn = KVM_PFN_ERR_FAULT;
+	else if ((vma->vm_flags & VM_PFNMAP)) {
+		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
+		BUG_ON(!kvm_is_mmio_pfn(pfn));
+	} else {
+		if (async && (vma->vm_flags & VM_WRITE))
+			*async = true;
+		pfn = KVM_PFN_ERR_FAULT;
+	}
+exit:
+	up_read(&current->mm->mmap_sem);
 	return pfn;
 }

-- 
1.7.7.6

