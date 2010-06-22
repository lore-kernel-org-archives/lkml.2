Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0FVGXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:23:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:20687 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098Ab0FVGXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:23:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,458,1272870000"; 
   d="scan'208";a="632434083"
Subject: [BUGFIX] kvm, Fix a race condition for usage of is_hwpoison_address
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 14:23:11 +0800
Message-ID: <1277187791.3004.149.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_hwpoison_address accesses the page table, so the caller must hold
current->mm->mmap_sem in read mode. So fix its usage in hav_to_pfn of
kvm accordingly.

Comments on is_hwpoison_address are added to remind other users.

Reported-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 mm/memory-failure.c |    3 +++
 virt/kvm/kvm_main.c |    3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1298,6 +1298,9 @@ done:
 	return ret;
 }
 
+/*
+ * The caller must hold current->mm->mmap_sem in read mode.
+ */
 int is_hwpoison_address(unsigned long addr)
 {
 	pgd_t *pgdp;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -955,12 +955,13 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
 	if (unlikely(npages != 1)) {
 		struct vm_area_struct *vma;
 
+		down_read(&current->mm->mmap_sem);
 		if (is_hwpoison_address(addr)) {
+			up_read(&current->mm->mmap_sem);
 			get_page(hwpoison_page);
 			return page_to_pfn(hwpoison_page);
 		}
 
-		down_read(&current->mm->mmap_sem);
 		vma = find_vma(current->mm, addr);
 
 		if (vma == NULL || addr < vma->vm_start ||


