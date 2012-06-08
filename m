Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979Ab2FHQ5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab2FHQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:57:53 -0400
Date: Fri, 8 Jun 2012 18:55:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes: write_opcode()->__replace_page() can race
	with try_to_unmap()
Message-ID: <20120608165551.GA30683@redhat.com>
References: <20120607165942.GA31966@redhat.com> <20120607170041.GC31974@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607170041.GC31974@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07, Oleg Nesterov wrote:
>
> The caller
> should notice this error code and retry.

Damn. But I didn't notice that the caller changes "vaddr" in the
middle.

> Note: write_opcode() asks for the cleanups, I'll try to do this
> in a separate patch.

Yes.


Please find v2 below. The only difference is that write_opcode()
uses the temporary variable instead of "vaddr &= ~PAGE_MASK".


---
Subject: [PATCH] uprobes: write_opcode()->__replace_page() can race with try_to_unmap()

write_opcode() gets old_page via get_user_pages() and then calls
__replace_page() which assumes that this old_page is still mapped
after pte_offset_map_lock().

This is not true if this old_page was already try_to_unmap()'ed,
and in this case everything __replace_page() does with old_page
is wrong. Just for example, put_page() is not balanced.

I think it is possible to teach __replace_page() to handle this
unlikely case correctly, but this patch simply changes it to use
page_check_address() and return -EAGAIN if it fails. The caller
should notice this error code and retry.

Note: write_opcode() asks for the cleanups, I'll try to do this
in a separate patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   41 +++++++++++++----------------------------
 1 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 9c53bc2..54c8780 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -135,33 +135,17 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
 static int __replace_page(struct vm_area_struct *vma, struct page *page, struct page *kpage)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep;
-	spinlock_t *ptl;
 	unsigned long addr;
-	int err = -EFAULT;
+	spinlock_t *ptl;
+	pte_t *ptep;
 
 	addr = page_address_in_vma(page, vma);
 	if (addr == -EFAULT)
-		goto out;
-
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		goto out;
-
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud))
-		goto out;
+		return -EFAULT;
 
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		goto out;
-
-	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
+	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
-		goto out;
+		return -EAGAIN;
 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
@@ -180,10 +164,8 @@ static int __replace_page(struct vm_area_struct *vma, struct page *page, struct
 		try_to_free_swap(page);
 	put_page(page);
 	pte_unmap_unlock(ptep, ptl);
-	err = 0;
 
-out:
-	return err;
+	return 0;
 }
 
 /**
@@ -228,9 +210,10 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	void *vaddr_old, *vaddr_new;
 	struct vm_area_struct *vma;
 	struct uprobe *uprobe;
+	unsigned long pgoff;
 	loff_t addr;
 	int ret;
-
+retry:
 	/* Read the page with vaddr into memory */
 	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
 	if (ret <= 0)
@@ -275,9 +258,9 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
 
 	/* poke the new insn in, ASSUMES we don't cross page boundary */
-	vaddr &= ~PAGE_MASK;
-	BUG_ON(vaddr + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
-	memcpy(vaddr_new + vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
+	pgoff = (vaddr & ~PAGE_MASK);
+	BUG_ON(pgoff + UPROBE_SWBP_INSN_SIZE > PAGE_SIZE);
+	memcpy(vaddr_new + pgoff, &opcode, UPROBE_SWBP_INSN_SIZE);
 
 	kunmap_atomic(vaddr_new);
 	kunmap_atomic(vaddr_old);
@@ -297,6 +280,8 @@ unlock_out:
 put_out:
 	put_page(old_page);
 
+	if (unlikely(ret == -EAGAIN))
+		goto retry;
 	return ret;
 }
 
-- 
1.5.5.1


