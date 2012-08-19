Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2HSQoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab2HSQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:44:17 -0400
Date: Sun, 19 Aug 2012 18:40:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] uprobes: teach find_active_uprobe() to clear
	MMF_HAS_UPROBES
Message-ID: <20120819164042.GA25490@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819164008.GA25454@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong MMF_HAS_UPROBES doesn't really hurt, just it triggers
the "slow" and unnecessary handle_swbp() path if the task hits
the non-uprobe breakpoint.

So this patch changes find_active_uprobe() to check every valid
vma and clear MMF_HAS_UPROBES if no uprobes were found. This is
adds the slow O(n) path, but it is only called in unlikely case
when the task hits the normal breakpoint first time after
uprobe_unregister().

Note the "not strictly accurate" comment in mmf_recalc_uprobes().
We can fix this, we only need to teach vma_has_uprobes() to return
a bit more more info, but I am not sure this worth the trouble.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 176de8c..0b7918c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1397,6 +1397,25 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 	return false;
 }
 
+static void mmf_recalc_uprobes(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (!valid_vma(vma, false))
+			continue;
+		/*
+		 * This is not strictly accurate, we can race with
+		 * uprobe_unregister() and see the already removed
+		 * uprobe if delete_uprobe() was not yet called.
+		 */
+		if (vma_has_uprobes(vma, vma->vm_start, vma->vm_end))
+			return;
+	}
+
+	clear_bit(MMF_HAS_UPROBES, &mm->flags);
+}
+
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 {
 	struct mm_struct *mm = current->mm;
@@ -1418,6 +1437,9 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	} else {
 		*is_swbp = -EFAULT;
 	}
+
+	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
+		mmf_recalc_uprobes(mm);
 	up_read(&mm->mmap_sem);
 
 	return uprobe;
-- 
1.5.5.1

