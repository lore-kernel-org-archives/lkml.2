Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1CXJd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:33:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab1CXJd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:33:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 18:26:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 2/5] forkbomb: mm tracking subsystem
Message-Id: <20110324182659.ca1f4847.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a subsystem for recording a history of mm.
This patch records relation ship of each mm_structs and
preserve them in a tree. New record is added at fork()
and exec(). If all children disapperas at exit(), the record
will be removed.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/exec.c                |    1 
 include/linux/mm_types.h |    3 +
 include/linux/oom.h      |   14 ++++++++
 kernel/fork.c            |    3 +
 mm/oom_kill.c            |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+)

Index: mm-work2/include/linux/oom.h
===================================================================
--- mm-work2.orig/include/linux/oom.h
+++ mm-work2/include/linux/oom.h
@@ -72,5 +72,19 @@ extern struct task_struct *find_lock_tas
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
 extern int sysctl_panic_on_oom;
+
+#ifdef CONFIG_FORKBOMB_KILLER
+extern void track_mm_history(struct mm_struct *new, struct mm_struct *old);
+extern void delete_mm_history(struct mm_struct *mm);
+#else
+static inline void
+track_mm_history(struct mm_struct *new, struct mm_struct *old)
+{
+}
+static inline void delete_mm_history(struct mm_struct *mm)
+{
+}
+#endif
+
 #endif /* __KERNEL__*/
 #endif /* _INCLUDE_LINUX_OOM_H */
Index: mm-work2/mm/oom_kill.c
===================================================================
--- mm-work2.orig/mm/oom_kill.c
+++ mm-work2/mm/oom_kill.c
@@ -761,3 +761,78 @@ void pagefault_out_of_memory(void)
 	if (!test_thread_flag(TIF_MEMDIE))
 		schedule_timeout_uninterruptible(1);
 }
+
+#ifdef CONFIG_FORKBOMB_KILLER
+
+struct mm_history {
+	spinlock_t	lock;
+	struct mm_struct *mm;
+	struct mm_history *parent;
+	struct list_head siblings;
+	struct list_head children;
+	/* scores */
+	unsigned long start_time;
+	unsigned long score;
+	unsigned int family;
+	int           need_to_kill;
+};
+
+struct mm_history init_hist = {
+	.parent	= &init_hist,
+	.lock = __SPIN_LOCK_UNLOCKED(init_hist.lock),
+	.siblings = LIST_HEAD_INIT(init_hist.siblings),
+	.children = LIST_HEAD_INIT(init_hist.children),
+};
+
+void track_mm_history(struct mm_struct *new, struct mm_struct *parent)
+{
+	struct mm_history *hist, *phist;
+
+	hist = kmalloc(sizeof(*hist), GFP_KERNEL);
+	if (!hist)
+		return;
+	spin_lock_init(&hist->lock);
+	INIT_LIST_HEAD(&hist->children);
+	hist->mm = new;
+	hist->start_time = jiffies;
+	if (parent)
+		phist = parent->history;
+	else
+		phist = NULL;
+	if (!phist)
+		phist = &init_hist;
+	new->history = hist;
+	hist->parent = phist;
+	spin_lock(&phist->lock);
+	list_add_tail(&hist->siblings, &phist->children);
+	spin_unlock(&phist->lock);
+	return;
+}
+
+void delete_mm_history(struct mm_struct *mm)
+{
+	struct mm_history *hist, *phist;
+	bool nochild;
+
+	if (!mm->history)
+		return;
+	hist = mm->history;
+	spin_lock(&hist->lock);
+	nochild = list_empty(&hist->children);
+	mm->history = NULL;
+	hist->mm = NULL;
+	spin_unlock(&hist->lock);
+	/* delete if we have no child */
+	while (nochild && hist != &init_hist) {
+		phist = hist->parent;
+		spin_lock(&phist->lock);
+		list_del(&hist->siblings);
+		/* delete parent if it's dead & no more child other than me.*/
+		nochild = (phist->mm == NULL && list_empty(&phist->children));
+		spin_unlock(&phist->lock);
+		kfree(hist);
+		hist = phist;
+	}
+}
+
+#endif
Index: mm-work2/fs/exec.c
===================================================================
--- mm-work2.orig/fs/exec.c
+++ mm-work2/fs/exec.c
@@ -802,6 +802,7 @@ static int exec_mmap(struct mm_struct *m
 	}
 	task_unlock(tsk);
 	arch_pick_mmap_layout(mm);
+	track_mm_history(mm, old_mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
Index: mm-work2/kernel/fork.c
===================================================================
--- mm-work2.orig/kernel/fork.c
+++ mm-work2/kernel/fork.c
@@ -559,6 +559,7 @@ void mmput(struct mm_struct *mm)
 		ksm_exit(mm);
 		khugepaged_exit(mm); /* must run before exit_mmap */
 		exit_mmap(mm);
+		delete_mm_history(mm);
 		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
@@ -706,6 +707,8 @@ struct mm_struct *dup_mm(struct task_str
 	if (mm->binfmt && !try_module_get(mm->binfmt->module))
 		goto free_pt;
 
+	track_mm_history(mm, oldmm);
+
 	return mm;
 
 free_pt:
Index: mm-work2/include/linux/mm_types.h
===================================================================
--- mm-work2.orig/include/linux/mm_types.h
+++ mm-work2/include/linux/mm_types.h
@@ -317,6 +317,9 @@ struct mm_struct {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
+#ifdef CONFIG_FORKBOMB_KILLER
+	struct mm_history *history;
+#endif
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */

