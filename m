Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2E2Tan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab2E2Tam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:30:42 -0400
Date: Tue, 29 May 2012 21:28:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: introduce find_active_uprobe() helper
Message-ID: <20120529192857.GC8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Move the "find uprobe" code from
handle_swbp() to the new helper, find_active_uprobe().

Note: with or without this change, the find-active-uprobe logic
is not exactly right. We can race with another thread which unmaps
the memory with the valid uprobe before we take mm->mmap_sem. We
can't find this uprobe simply because find_vma() fails. In this
case we wrongly assume that this trap was not caused by uprobe
and send the erroneous SIGTRAP. See the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   47 ++++++++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index a0dbc87..eaf4d55 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1489,38 +1489,47 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 	return false;
 }
 
-/*
- * Run handler and ask thread to singlestep.
- * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
- */
-static void handle_swbp(struct pt_regs *regs)
+static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
 {
+	struct mm_struct *mm = current->mm;
+	struct uprobe *uprobe = NULL;
 	struct vm_area_struct *vma;
-	struct uprobe_task *utask;
-	struct uprobe *uprobe;
-	struct mm_struct *mm;
-	unsigned long bp_vaddr;
 
-	uprobe = NULL;
-	bp_vaddr = uprobe_get_swbp_addr(regs);
-	mm = current->mm;
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, bp_vaddr);
 
-	if (vma && vma->vm_start <= bp_vaddr && valid_vma(vma, false)) {
-		struct inode *inode;
-		loff_t offset;
+	if (vma && vma->vm_start <= bp_vaddr) {
+		if (valid_vma(vma, false)) {
+			struct inode *inode;
+			loff_t offset;
 
-		inode = vma->vm_file->f_mapping->host;
-		offset = bp_vaddr - vma->vm_start;
-		offset += (vma->vm_pgoff << PAGE_SHIFT);
-		uprobe = find_uprobe(inode, offset);
+			inode = vma->vm_file->f_mapping->host;
+			offset = bp_vaddr - vma->vm_start;
+			offset += (vma->vm_pgoff << PAGE_SHIFT);
+			uprobe = find_uprobe(inode, offset);
+		}
 	}
 
 	srcu_read_unlock_raw(&uprobes_srcu, current->uprobe_srcu_id);
 	current->uprobe_srcu_id = -1;
 	up_read(&mm->mmap_sem);
 
+	return uprobe;
+}
+
+/*
+ * Run handler and ask thread to singlestep.
+ * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
+ */
+static void handle_swbp(struct pt_regs *regs)
+{
+	struct uprobe_task *utask;
+	struct uprobe *uprobe;
+	unsigned long bp_vaddr;
+
+	bp_vaddr = uprobe_get_swbp_addr(regs);
+	uprobe = find_active_uprobe(bp_vaddr);
+
 	if (!uprobe) {
 		/* No matching uprobe; signal SIGTRAP. */
 		send_sig(SIGTRAP, current, 0);
-- 
1.5.5.1


