Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2FXPCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2FXPCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:02:38 -0400
Date: Sun, 24 Jun 2012 17:00:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] uprobes: __replace_page() should not use
	page_address_in_vma()
Message-ID: <20120624150021.GB23277@redhat.com>
References: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624145936.GA23269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_address_in_vma(old_page) in __replace_page() is ugly and wrong.
The caller already knows the correct virtual address, this page was
found by get_user_pages(vaddr).

However, page_address_in_vma() can actually fail if page->mapping was
cleared by __delete_from_page_cache() after get_user_pages() returns.
But this means the race with page reclaim, write_opcode() should not
fail, it should retry and read this page again. Not sure this race is
really possible though, page_freeze_refs() logic should prevent it.

We could change __replace_page() to return -EAGAIN in this case, but
it would be better to simply use the caller's vaddr and rely on
page_check_address().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a2b32a5..6fda799 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -127,22 +127,19 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
  * based on replace_page in mm/ksm.c
  *
  * @vma:      vma that holds the pte pointing to page
+ * @addr:     address the old @page is mapped at
  * @page:     the cowed page we are replacing by kpage
  * @kpage:    the modified page we replace page by
  *
  * Returns 0 on success, -EFAULT on failure.
  */
-static int __replace_page(struct vm_area_struct *vma, struct page *page, struct page *kpage)
+static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
+				struct page *page, struct page *kpage)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr;
 	spinlock_t *ptl;
 	pte_t *ptep;
 
-	addr = page_address_in_vma(page, vma);
-	if (addr == -EFAULT)
-		return -EFAULT;
-
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
 		return -EAGAIN;
@@ -243,7 +240,7 @@ retry:
 		goto unlock_out;
 
 	lock_page(new_page);
-	ret = __replace_page(vma, old_page, new_page);
+	ret = __replace_page(vma, vaddr, old_page, new_page);
 	unlock_page(new_page);
 
 unlock_out:
-- 
1.5.5.1


