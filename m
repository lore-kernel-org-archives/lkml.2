Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab2G3OLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:11:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2G3OLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:11:19 -0400
Date: Mon, 30 Jul 2012 07:10:33 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-c517ee744b96e441d9c731e245f83c6d08dc0a19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182216.GA20311@redhat.com>
References: <20120729182216.GA20311@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: __replace_page()
  should not use page_address_in_vma()
Git-Commit-ID: c517ee744b96e441d9c731e245f83c6d08dc0a19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:10:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c517ee744b96e441d9c731e245f83c6d08dc0a19
Gitweb:     http://git.kernel.org/tip/c517ee744b96e441d9c731e245f83c6d08dc0a19
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:19 +0200

uprobes: __replace_page() should not use page_address_in_vma()

page_address_in_vma(old_page) in __replace_page() is ugly and
wrong. The caller already knows the correct virtual address,
this page was found by get_user_pages(vaddr).

However, page_address_in_vma() can actually fail if
page->mapping was cleared by __delete_from_page_cache() after
get_user_pages() returns. But this means the race with page
reclaim, write_opcode() should not fail, it should retry and
read this page again. Probably the race with remove_mapping() is
not possible due to page_freeze_refs() logic, but afaics at
least shmem_writepage()->shmem_delete_from_page_cache() can
clear ->mapping.

We could change __replace_page() to return -EAGAIN in this case,
but it would be better to simply use the caller's vaddr and rely
on page_check_address().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182216.GA20311@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
