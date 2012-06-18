Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2FRIwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:52:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40421 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2FRIwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:52:11 -0400
Date: Mon, 18 Jun 2012 01:51:49 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-5323ce71e4b4e1f188ebbc0cc7776885ea6c75fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154328.GA9571@redhat.com>
References: <20120615154328.GA9571@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Write_opcode()->__replace_page()
  can race with try_to_unmap()
Git-Commit-ID: 5323ce71e4b4e1f188ebbc0cc7776885ea6c75fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:51:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5323ce71e4b4e1f188ebbc0cc7776885ea6c75fb
Gitweb:     http://git.kernel.org/tip/5323ce71e4b4e1f188ebbc0cc7776885ea6c75fb
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:28 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:42 +0200

uprobes: Write_opcode()->__replace_page() can race with try_to_unmap()

write_opcode() gets old_page via get_user_pages() and then calls
__replace_page() which assumes that this old_page is still
mapped after pte_offset_map_lock().

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
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154328.GA9571@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   41 +++++++++++++----------------------------
 1 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 604930b..3ccdb29 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -129,33 +129,17 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
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
@@ -174,10 +158,8 @@ static int __replace_page(struct vm_area_struct *vma, struct page *page, struct
 		try_to_free_swap(page);
 	put_page(page);
 	pte_unmap_unlock(ptep, ptl);
-	err = 0;
 
-out:
-	return err;
+	return 0;
 }
 
 /**
@@ -222,9 +204,10 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
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
@@ -269,9 +252,9 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
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
@@ -291,6 +274,8 @@ unlock_out:
 put_out:
 	put_page(old_page);
 
+	if (unlikely(ret == -EAGAIN))
+		goto retry;
 	return ret;
 }
 
