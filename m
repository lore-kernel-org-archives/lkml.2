Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2IWUTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:19:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab2IWUSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:09 -0400
Date: Sun, 23 Sep 2012 22:19:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] uprobes: Simplify is_swbp_at_addr(), remove stale
	comments
Message-ID: <20120923201953.GA27463@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923201921.GA27424@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous change is_swbp_at_addr() is always called with
current->mm. Remove this check and move it close to its single caller.

Also, remove the obsolete comment about is_swbp_at_addr() and
uprobe_state.count.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   73 +++++++++++++++-------------------------------
 1 files changed, 24 insertions(+), 49 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 17454fb..a741ba7 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -282,32 +282,6 @@ put_old:
 	return ret;
 }
 
-static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
-{
-	struct page *page;
-	uprobe_opcode_t opcode;
-	int result;
-
-	if (current->mm == mm) {
-		pagefault_disable();
-		result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
-								sizeof(opcode));
-		pagefault_enable();
-
-		if (likely(result == 0))
-			goto out;
-	}
-
-	result = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
-	if (result < 0)
-		return result;
-
-	copy_opcode(page, vaddr, &opcode);
-	put_page(page);
- out:
-	return is_swbp_insn(&opcode);
-}
-
 /**
  * set_swbp - store breakpoint at a given address.
  * @auprobe: arch specific probepoint information.
@@ -589,29 +563,6 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
 }
 
-/*
- * How mm->uprobes_state.count gets updated
- * uprobe_mmap() increments the count if
- * 	- it successfully adds a breakpoint.
- * 	- it cannot add a breakpoint, but sees that there is a underlying
- * 	  breakpoint (via a is_swbp_at_addr()).
- *
- * uprobe_munmap() decrements the count if
- * 	- it sees a underlying breakpoint, (via is_swbp_at_addr)
- * 	  (Subsequent uprobe_unregister wouldnt find the breakpoint
- * 	  unless a uprobe_mmap kicks in, since the old vma would be
- * 	  dropped just after uprobe_munmap.)
- *
- * uprobe_register increments the count if:
- * 	- it successfully adds a breakpoint.
- *
- * uprobe_unregister decrements the count if:
- * 	- it sees a underlying breakpoint and removes successfully.
- * 	  (via is_swbp_at_addr)
- * 	  (Subsequent uprobe_munmap wouldnt find the breakpoint
- * 	  since there is no underlying breakpoint after the
- * 	  breakpoint removal.)
- */
 static int
 install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long vaddr)
@@ -1389,6 +1340,30 @@ static void mmf_recalc_uprobes(struct mm_struct *mm)
 	clear_bit(MMF_HAS_UPROBES, &mm->flags);
 }
 
+static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
+{
+	struct page *page;
+	uprobe_opcode_t opcode;
+	int result;
+
+	pagefault_disable();
+	result = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
+							sizeof(opcode));
+	pagefault_enable();
+
+	if (likely(result == 0))
+		goto out;
+
+	result = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
+	if (result < 0)
+		return result;
+
+	copy_opcode(page, vaddr, &opcode);
+	put_page(page);
+ out:
+	return is_swbp_insn(&opcode);
+}
+
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 {
 	struct mm_struct *mm = current->mm;
-- 
1.5.5.1

