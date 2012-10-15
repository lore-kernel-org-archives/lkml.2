Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2JOTJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 15:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2JOTJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 15:09:11 -0400
Date: Mon, 15 Oct 2012 21:10:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] uprobes: Use brw_mutex to fix register/unregister vs
	dup_mmap() race
Message-ID: <20121015191022.GA4823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015190958.GA4799@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was always racy, but 268720903f87e0b84b161626c4447b81671b5d18
"uprobes: Rework register_for_each_vma() to make it O(n)" should be
blamed anyway, it made everything worse and I didn't notice.

register/unregister call build_map_info() and then do install/remove
breakpoint for every mm which mmaps inode/offset. This can obviously
race with fork()->dup_mmap() in between and we can miss the child.

uprobe_register() could be easily fixed but unregister is much worse,
the new mm inherits "int3" from parent and there is no way to detect
this if uprobe goes away.

So this patch simply adds brw_start/end_read() around dup_mmap(), and
brw_start/end_write() into register_for_each_vma().

This adds 2 new hooks into dup_mmap() but we can kill uprobe_dup_mmap()
and fold it into uprobe_end_dup_mmap().

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    8 ++++++++
 kernel/events/uprobes.c |   26 +++++++++++++++++++++++---
 kernel/fork.c           |    2 ++
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 2459457..80913e3 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -97,6 +97,8 @@ extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_con
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
+extern void uprobe_start_dup_mmap(void);
+extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
 extern void uprobe_free_utask(struct task_struct *t);
 extern void uprobe_copy_process(struct task_struct *t);
@@ -129,6 +131,12 @@ static inline void
 uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 }
+static inline void uprobe_start_dup_mmap(void)
+{
+}
+static inline void uprobe_end_dup_mmap(void)
+{
+}
 static inline void
 uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6a5b5a4..7aeb096 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -33,6 +33,7 @@
 #include <linux/ptrace.h>	/* user_enable_single_step */
 #include <linux/kdebug.h>	/* notifier mechanism */
 #include "../../mm/internal.h"	/* munlock_vma_page */
+#include <linux/brw_mutex.h>
 
 #include <linux/uprobes.h>
 
@@ -71,6 +72,8 @@ static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
 static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
 #define uprobes_mmap_hash(v)	(&uprobes_mmap_mutex[((unsigned long)(v)) % UPROBES_HASH_SZ])
 
+static struct brw_mutex dup_mmap_mutex;
+
 /*
  * uprobe_events allows us to skip the uprobe_mmap if there are no uprobe
  * events active at this time.  Probably a fine grained per inode count is
@@ -766,10 +769,13 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 	struct map_info *info;
 	int err = 0;
 
+	brw_start_write(&dup_mmap_mutex);
 	info = build_map_info(uprobe->inode->i_mapping,
 					uprobe->offset, is_register);
-	if (IS_ERR(info))
-		return PTR_ERR(info);
+	if (IS_ERR(info)) {
+		err = PTR_ERR(info);
+		goto out;
+	}
 
 	while (info) {
 		struct mm_struct *mm = info->mm;
@@ -799,7 +805,8 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		mmput(mm);
 		info = free_map_info(info);
 	}
-
+ out:
+	brw_end_write(&dup_mmap_mutex);
 	return err;
 }
 
@@ -1131,6 +1138,16 @@ void uprobe_clear_state(struct mm_struct *mm)
 	kfree(area);
 }
 
+void uprobe_start_dup_mmap(void)
+{
+	brw_start_read(&dup_mmap_mutex);
+}
+
+void uprobe_end_dup_mmap(void)
+{
+	brw_end_read(&dup_mmap_mutex);
+}
+
 void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
 	newmm->uprobes_state.xol_area = NULL;
@@ -1605,6 +1622,9 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
 
+	if (brw_mutex_init(&dup_mmap_mutex))
+		return -ENOMEM;
+
 	return register_die_notifier(&uprobe_exception_nb);
 }
 module_init(init_uprobes);
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b20ab7..c497e57 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -352,6 +352,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	unsigned long charge;
 	struct mempolicy *pol;
 
+	uprobe_start_dup_mmap();
 	down_write(&oldmm->mmap_sem);
 	flush_cache_dup_mm(oldmm);
 	uprobe_dup_mmap(oldmm, mm);
@@ -469,6 +470,7 @@ out:
 	up_write(&mm->mmap_sem);
 	flush_tlb_mm(oldmm);
 	up_write(&oldmm->mmap_sem);
+	uprobe_end_dup_mmap();
 	return retval;
 fail_nomem_anon_vma_fork:
 	mpol_put(pol);
-- 
1.5.5.1

