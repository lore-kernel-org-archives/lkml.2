Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246Ab2FFQHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:07:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2FFQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:07:51 -0400
Date: Wed, 6 Jun 2012 09:07:27 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-3a9ea0520f38def4a3915b91f82455b749f07d88@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192857.GC8057@redhat.com>
References: <20120529192857.GC8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Introduce find_active_uprobe() helper
Git-Commit-ID: 3a9ea0520f38def4a3915b91f82455b749f07d88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:07:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a9ea0520f38def4a3915b91f82455b749f07d88
Gitweb:     http://git.kernel.org/tip/3a9ea0520f38def4a3915b91f82455b749f07d88
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:28:57 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:15:17 +0200

uprobes: Introduce find_active_uprobe() helper

No functional changes. Move the "find uprobe" code from
handle_swbp() to the new helper, find_active_uprobe().

Note: with or without this change, the find-active-uprobe logic
is not exactly right. We can race with another thread which
unmaps the memory with the valid uprobe before we take
mm->mmap_sem. We can't find this uprobe simply because
find_vma() fails. In this case we wrongly assume that this trap
was not caused by uprobe and send the erroneous SIGTRAP. See the
next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192857.GC8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
