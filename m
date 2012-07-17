Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2GQOnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:43:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55931 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2GQOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:43:22 -0400
Message-ID: <50057A01.9010401@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:43:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 05/10] KVM: reorganize hva_to_pfn
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-8256-0000-0000-00000359A43F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do too many things in hva_to_pfn, this patch reorganize the code,
let it be better readable

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |  161 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 99 insertions(+), 62 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a89c7b8..54fb47b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1096,84 +1096,121 @@ static inline int check_user_page_hwpoison(unsigned long addr)
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
+
+		if (writable)
+			*writable = true;
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * The slow path to get the pfn of the specified host virtual address,
+ * 1 indicates success, -errno is returned if error is detected.
+ */
+static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
+			   bool *writable, pfn_t *pfn)
+{
+	struct page *page[1];
+	int npages = 0;
+
+	might_sleep();

 	if (writable)
-		*writable = true;
+		*writable = write_fault;

-	if (atomic || async)
-		npages = __get_user_pages_fast(addr, 1, 1, page);
+	if (async) {
+		down_read(&current->mm->mmap_sem);
+		npages = get_user_page_nowait(current, current->mm,
+					      addr, write_fault, page);
+		up_read(&current->mm->mmap_sem);
+	} else
+		npages = get_user_pages_fast(addr, 1, write_fault,
+					     page);

-	if (unlikely(npages != 1) && !atomic) {
-		might_sleep();
+	if (npages != 1)
+		return npages;

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

-	if (unlikely(npages != 1)) {
-		struct vm_area_struct *vma;
+static pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool *async,
+			bool write_fault, bool *writable)
+{
+	struct vm_area_struct *vma;
+	pfn_t pfn = 0;
+	int npages;

-		if (atomic)
-			return get_fault_pfn();
+	/* we can do it either atomically or asynchronously, not both */
+	BUG_ON(atomic && async);

-		down_read(&current->mm->mmap_sem);
-		if (npages == -EHWPOISON ||
-			(!async && check_user_page_hwpoison(addr))) {
-			up_read(&current->mm->mmap_sem);
-			get_page(hwpoison_page);
-			return page_to_pfn(hwpoison_page);
-		}
+	BUG_ON(!write_fault && !writable);

-		vma = find_vma_intersection(current->mm, addr, addr+1);
-
-		if (vma == NULL)
-			pfn = get_fault_pfn();
-		else if ((vma->vm_flags & VM_PFNMAP)) {
-			pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) +
-				vma->vm_pgoff;
-			BUG_ON(!kvm_is_mmio_pfn(pfn));
-		} else {
-			if (async && (vma->vm_flags & VM_WRITE))
-				*async = true;
-			pfn = get_fault_pfn();
-		}
-		up_read(&current->mm->mmap_sem);
-	} else
-		pfn = page_to_pfn(page[0]);
+	if (hva_to_pfn_fast(addr, atomic, async, write_fault, writable, &pfn))
+		return pfn;

+	if (atomic)
+		return get_fault_pfn();
+
+	npages = hva_to_pfn_slow(addr, async, write_fault, writable, &pfn);
+	if (npages == 1)
+		return pfn;
+
+	down_read(&current->mm->mmap_sem);
+	if (npages == -EHWPOISON ||
+	      (!async && check_user_page_hwpoison(addr))) {
+		get_page(hwpoison_page);
+		pfn = page_to_pfn(hwpoison_page);
+		goto exit;
+	}
+
+	vma = find_vma_intersection(current->mm, addr, addr + 1);
+
+	if (vma == NULL)
+		pfn = get_fault_pfn();
+	else if ((vma->vm_flags & VM_PFNMAP)) {
+		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) +
+			vma->vm_pgoff;
+		BUG_ON(!kvm_is_mmio_pfn(pfn));
+	} else {
+		if (async && (vma->vm_flags & VM_WRITE))
+			*async = true;
+		pfn = get_fault_pfn();
+	}
+
+exit:
+	up_read(&current->mm->mmap_sem);
 	return pfn;
 }

-- 
1.7.7.6

