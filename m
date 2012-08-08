Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067Ab2HHRlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:41:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759049Ab2HHRlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:41:02 -0400
Date: Wed, 8 Aug 2012 19:37:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uprobes: change uprobe_mmap() to ignore the errors but
	check fatal_signal_pending()
Message-ID: <20120808173742.GA13262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808173659.GA13220@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once install_breakpoint() fails uprobe_mmap() "ignores" all other
uprobes and returns the error.

It was never really needed to to stop after the first error, and
in fact it was always wrong at least in -ENOTSUPP case.

Change uprobe_mmap() to ignore the errors and always return 0.
This is not what we want in the long term, but until we teach
the callers to handle the failure it would be better to remove
the pointless complications. And this doesn't look too bad, the
only "reasonable" error is ENOMEM but in this case the caller
should be oom-killed in the likely case or the system has more
serious problems.

However it makes sense to stop if fatal_signal_pending() == T.
In particular this helps if the task was oom-killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   27 ++++++---------------------
 1 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 08ea627..2e269d1 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -996,23 +996,16 @@ static void build_probe_list(struct inode *inode,
 }
 
 /*
- * Called from mmap_region.
- * called with mm->mmap_sem acquired.
+ * Called from mmap_region/vma_adjust with mm->mmap_sem acquired.
  *
- * Return -ve no if we fail to insert probes and we cannot
- * bail-out.
- * Return 0 otherwise. i.e:
- *
- *	- successful insertion of probes
- *	- (or) no possible probes to be inserted.
- *	- (or) insertion of probes failed but we can bail-out.
+ * Currently we ignore all errors and always return 0, the callers
+ * can't handle the failure anyway.
  */
 int uprobe_mmap(struct vm_area_struct *vma)
 {
 	struct list_head tmp_list;
 	struct uprobe *uprobe, *u;
 	struct inode *inode;
-	int ret;
 
 	if (!atomic_read(&uprobe_events) || !valid_vma(vma, true))
 		return 0;
@@ -1024,24 +1017,16 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	mutex_lock(uprobes_mmap_hash(inode));
 	build_probe_list(inode, vma, vma->vm_start, vma->vm_end, &tmp_list);
 
-	ret = 0;
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
-		if (!ret) {
+		if (!fatal_signal_pending(current)) {
 			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
-
-			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
-			/*
-			 * We can race against uprobe_register(), see the
-			 * comment near uprobe_hash().
-			 */
-			if (ret == -EEXIST)
-				ret = 0;
+			install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 		}
 		put_uprobe(uprobe);
 	}
 	mutex_unlock(uprobes_mmap_hash(inode));
 
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.5.5.1

