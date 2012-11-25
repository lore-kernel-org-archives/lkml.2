Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2KYWea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:34:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2KYWd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:33:56 -0500
Date: Sun, 25 Nov 2012 23:33:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] uprobes: Kill uprobe_events, use RB_EMPTY_ROOT()
	instead
Message-ID: <20121125223344.GA24801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125223331.GA24788@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_events counts the number of uprobes in uprobes_tree but
it is used as a boolean. We can use RB_EMPTY_ROOT() instead.

Probably no_uprobe_events() added by this patch can have more
callers, say, mmf_recalc_uprobes().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 1e047f8..53dc2eb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -41,6 +41,11 @@
 #define MAX_UPROBE_XOL_SLOTS		UINSNS_PER_PAGE
 
 static struct rb_root uprobes_tree = RB_ROOT;
+/*
+ * allows us to skip the uprobe_mmap if there are no uprobe events active
+ * at this time.  Probably a fine grained per inode count is better?
+ */
+#define no_uprobe_events()	RB_EMPTY_ROOT(&uprobes_tree)
 
 static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
 
@@ -74,13 +79,6 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 
 static struct percpu_rw_semaphore dup_mmap_sem;
 
-/*
- * uprobe_events allows us to skip the uprobe_mmap if there are no uprobe
- * events active at this time.  Probably a fine grained per inode count is
- * better?
- */
-static atomic_t uprobe_events = ATOMIC_INIT(0);
-
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
 /* Can skip singlestep */
@@ -460,8 +458,6 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 		kfree(uprobe);
 		uprobe = cur_uprobe;
 		iput(inode);
-	} else {
-		atomic_inc(&uprobe_events);
 	}
 
 	return uprobe;
@@ -685,7 +681,6 @@ static void delete_uprobe(struct uprobe *uprobe)
 	spin_unlock(&uprobes_treelock);
 	iput(uprobe->inode);
 	put_uprobe(uprobe);
-	atomic_dec(&uprobe_events);
 }
 
 struct map_info {
@@ -975,7 +970,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	struct uprobe *uprobe, *u;
 	struct inode *inode;
 
-	if (!atomic_read(&uprobe_events) || !valid_vma(vma, true))
+	if (no_uprobe_events() || !valid_vma(vma, true))
 		return 0;
 
 	inode = vma->vm_file->f_mapping->host;
@@ -1021,7 +1016,7 @@ vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long e
  */
 void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
-	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
+	if (no_uprobe_events() || !valid_vma(vma, false))
 		return;
 
 	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput() ? */
-- 
1.5.5.1

