Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2IWUTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab2IWUSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:03 -0400
Date: Sun, 23 Sep 2012 22:19:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] uprobes: Introduce copy_opcode(), kill read_opcode()
Message-ID: <20120923201948.GA27453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923201921.GA27424@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparations.

1. Extract the kmap-and-memcpy code from read_opcode() into the
   new trivial helper, copy_opcode(). The next patch will add
   another user.

2. read_opcode() becomes really trivial, fold it into its single
   caller, is_swbp_at_addr().

3. Remove "auprobe" argument from write_opcode(), it is not used
   since f403072c6.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   63 ++++++++++++++--------------------------------
 1 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 04f3259..100a920 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -183,19 +183,25 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
 	return *insn == UPROBE_SWBP_INSN;
 }
 
+static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *opcode)
+{
+	void *kaddr = kmap_atomic(page);
+	memcpy(opcode, kaddr + (vaddr & ~PAGE_MASK), UPROBE_SWBP_INSN_SIZE);
+	kunmap_atomic(kaddr);
+}
+
 /*
  * NOTE:
  * Expect the breakpoint instruction to be the smallest size instruction for
  * the architecture. If an arch has variable length instruction and the
  * breakpoint instruction is not of the smallest length instruction
- * supported by that architecture then we need to modify read_opcode /
+ * supported by that architecture then we need to modify is_swbp_at_addr and
  * write_opcode accordingly. This would never be a problem for archs that
  * have fixed length instructions.
  */
 
 /*
  * write_opcode - write the opcode at a given virtual address.
- * @auprobe: arch breakpointing information.
  * @mm: the probed process address space.
  * @vaddr: the virtual address to store the opcode.
  * @opcode: opcode to be written at @vaddr.
@@ -206,8 +212,8 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
  * For mm @mm, write the opcode at @vaddr.
  * Return 0 (success) or a negative errno.
  */
-static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
-			unsigned long vaddr, uprobe_opcode_t opcode)
+static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
+			uprobe_opcode_t opcode)
 {
 	struct page *old_page, *new_page;
 	void *vaddr_old, *vaddr_new;
@@ -253,40 +259,9 @@ put_old:
 	return ret;
 }
 
-/**
- * read_opcode - read the opcode at a given virtual address.
- * @mm: the probed process address space.
- * @vaddr: the virtual address to read the opcode.
- * @opcode: location to store the read opcode.
- *
- * Called with mm->mmap_sem held (for read and with a reference to
- * mm.
- *
- * For mm @mm, read the opcode at @vaddr and store it in @opcode.
- * Return 0 (success) or a negative errno.
- */
-static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_t *opcode)
-{
-	struct page *page;
-	void *vaddr_new;
-	int ret;
-
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
-	if (ret <= 0)
-		return ret;
-
-	vaddr_new = kmap_atomic(page);
-	vaddr &= ~PAGE_MASK;
-	memcpy(opcode, vaddr_new + vaddr, UPROBE_SWBP_INSN_SIZE);
-	kunmap_atomic(vaddr_new);
-
-	put_page(page);
-
-	return 0;
-}
-
 static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
 {
+	struct page *page;
 	uprobe_opcode_t opcode;
 	int result;
 
@@ -300,14 +275,14 @@ static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
 			goto out;
 	}
 
-	result = read_opcode(mm, vaddr, &opcode);
-	if (result)
+	result = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
+	if (result < 0)
 		return result;
-out:
-	if (is_swbp_insn(&opcode))
-		return 1;
 
-	return 0;
+	copy_opcode(page, vaddr, &opcode);
+	put_page(page);
+ out:
+	return is_swbp_insn(&opcode);
 }
 
 /**
@@ -321,7 +296,7 @@ out:
  */
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	return write_opcode(auprobe, mm, vaddr, UPROBE_SWBP_INSN);
+	return write_opcode(mm, vaddr, UPROBE_SWBP_INSN);
 }
 
 /**
@@ -345,7 +320,7 @@ set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long v
 	if (result != 1)
 		return result;
 
-	return write_opcode(auprobe, mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
+	return write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
 }
 
 static int match_uprobe(struct uprobe *l, struct uprobe *r)
-- 
1.5.5.1

