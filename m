Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab2FFPM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:12:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756272Ab2FFPMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:12:24 -0400
Date: Wed, 6 Jun 2012 08:10:56 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-183085e74a7faf3654c3a7c243b67b5cb76fa708@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192914.GD8057@redhat.com>
References: <20120529192914.GD8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Teach find_active_uprobe()
  to provide the %22is_swbp%22 info
Git-Commit-ID: 183085e74a7faf3654c3a7c243b67b5cb76fa708
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:11:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  183085e74a7faf3654c3a7c243b67b5cb76fa708
Gitweb:     http://git.kernel.org/tip/183085e74a7faf3654c3a7c243b67b5cb76fa708
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:29:14 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:30:56 +0200

uprobes: Teach find_active_uprobe() to provide the %22is_swbp%22 info

A separate patch to simplify the review, and for the
documentation.

The patch adds another "int *is_swbp" argument to
find_active_uprobe(), so far its only caller doesn't use this
info.

With this patch find_active_uprobe() additionally does:

	- if find_vma() + ->vm_start check fails, *is_swbp = -EFAULT

	- otherwise, if valid_vma() + find_uprobe() fails, it holds
	  the result of is_swbp_at_addr(), can be negative too. The
	  latter is only possible if we raced with another thread
	  which did munmap/etc after we hit this bp.

IOW. If find_active_uprobe(&is_swbp) returns NULL, the caller
can look at is_swbp to figure out whether the current insn is bp
or not, or detect the race with another thread if it is
negative.

Note: I think that performance-wise this change is fine. This
adds is_swbp_at_addr(), but only if we raced with
uprobe_unregister() or if we hit the "normal" int3 but this mm
has uprobes as well. And even in this case the slow
read_opcode() path is very unlikely, this insn recently
triggered do_int3(), __copy_from_user_inatomic() shouldn't fail
in the likely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192914.GD8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index eaf4d55..ee3df70 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1489,7 +1489,7 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 	return false;
 }
 
-static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
+static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 {
 	struct mm_struct *mm = current->mm;
 	struct uprobe *uprobe = NULL;
@@ -1497,7 +1497,6 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
 
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, bp_vaddr);
-
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
 			struct inode *inode;
@@ -1508,6 +1507,11 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
 			offset += (vma->vm_pgoff << PAGE_SHIFT);
 			uprobe = find_uprobe(inode, offset);
 		}
+
+		if (!uprobe)
+			*is_swbp = is_swbp_at_addr(mm, bp_vaddr);
+	} else {
+		*is_swbp = -EFAULT;
 	}
 
 	srcu_read_unlock_raw(&uprobes_srcu, current->uprobe_srcu_id);
@@ -1526,9 +1530,10 @@ static void handle_swbp(struct pt_regs *regs)
 	struct uprobe_task *utask;
 	struct uprobe *uprobe;
 	unsigned long bp_vaddr;
+	int is_swbp;
 
 	bp_vaddr = uprobe_get_swbp_addr(regs);
-	uprobe = find_active_uprobe(bp_vaddr);
+	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
 
 	if (!uprobe) {
 		/* No matching uprobe; signal SIGTRAP. */
