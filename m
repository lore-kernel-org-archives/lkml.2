Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0LPKBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:01:54 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39356 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab0LPKBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:51 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:29:12 +0530
Message-Id: <20101216095912.23751.63180.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 10/20] 10: uprobes: task specific information.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Uprobes needs to maintain some task specific information include if a
task is currently uprobed, the currently handing uprobe, any arch
specific information (for example to handle rip relative instructions),
the per-task slot where the original instruction is copied to before
single-stepping.

Provides routines to create/manage and free the task specific
information.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/sched.h   |    3 +++
 include/linux/uprobes.h |   25 +++++++++++++++++++++++++
 kernel/fork.c           |    4 ++++
 kernel/uprobes.c        |   37 +++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f4e90b6..5a3ebea 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1523,6 +1523,9 @@ struct task_struct {
 		unsigned long memsw_bytes; /* uncharged mem+swap usage */
 	} memcg_batch;
 #endif
+#ifdef CONFIG_UPROBES
+	struct uprobe_task *utask;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 0d4f5e3..14a4fce 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -26,12 +26,14 @@
 #include <linux/rbtree.h>
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 #include <asm/uprobes.h>
+struct uprobe_task_arch_info;	/* arch specific task info */
 #else
 /*
  * ARCH_SUPPORTS_UPROBES has not be defined.
  */
 typedef u8 uprobe_opcode_t;
 struct uprobe_arch_info	{};		/* arch specific info*/
+struct uprobe_task_arch_info {};	/* arch specific task info */
 
 /* Post-execution fixups.  Some architectures may define others. */
 #endif /* CONFIG_ARCH_SUPPORTS_UPROBES */
@@ -85,6 +87,27 @@ struct uprobe {
 	u8			insn[MAX_UINSN_BYTES];	/* orig instruction */
 };
 
+enum uprobe_task_state {
+	UTASK_RUNNING,
+	UTASK_BP_HIT,
+	UTASK_SSTEP
+};
+
+/*
+ * uprobe_utask -- not a user-visible struct.
+ * Corresponds to a thread in a probed process.
+ * Guarded by uproc->mutex.
+ */
+struct uprobe_task {
+	unsigned long xol_vaddr;
+	unsigned long vaddr;
+
+	enum uprobe_task_state state;
+	struct uprobe_task_arch_info tskinfo;
+
+	struct uprobe *active_uprobe;
+};
+
 /*
  * Most architectures can use the default versions of @read_opcode(),
  * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn();
@@ -108,6 +131,7 @@ extern int register_uprobe(struct inode *inode, unsigned long offset,
 				struct uprobe_consumer *consumer);
 extern void unregister_uprobe(struct inode *inode, unsigned long offset,
 				struct uprobe_consumer *consumer);
+extern void uprobe_free_utask(struct task_struct *tsk);
 
 struct vm_area_struct;
 extern void uprobe_mmap(struct vm_area_struct *vma);
@@ -126,6 +150,7 @@ static inline void uprobe_dup_mmap(struct mm_struct *old_mm,
 		struct mm_struct *mm)
 {
 }
+static inline void uprobe_free_utask(struct task_struct *tsk) {}
 static inline void uprobe_mmap(struct vm_area_struct *vma) { }
 #endif /* CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index b135d1b..ae99239 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -191,6 +191,7 @@ void __put_task_struct(struct task_struct *tsk)
 	delayacct_tsk_free(tsk);
 	put_signal_struct(tsk->signal);
 
+	uprobe_free_utask(tsk);
 	if (!profile_handoff_task(tsk))
 		free_task(tsk);
 }
@@ -1202,6 +1203,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	INIT_LIST_HEAD(&p->pi_state_list);
 	p->pi_state_cache = NULL;
 #endif
+#ifdef CONFIG_UPROBES
+	p->utask = NULL;
+#endif
 	/*
 	 * sigaltstack should be cleared when sharing the same VM
 	 */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 31867a6..f182fe6 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -745,3 +745,40 @@ void uprobe_mmap(struct vm_area_struct *vma)
 	down_write(&mm->mmap_sem);
 }
 
+/*
+ * Called with no locks held.
+ * Called in context of a exiting or a exec-ing thread.
+ */
+void uprobe_free_utask(struct task_struct *tsk)
+{
+	struct uprobe_task *utask = tsk->utask;
+
+	if (!utask)
+		return;
+
+	if (utask->active_uprobe)
+		put_uprobe(utask->active_uprobe);
+	kfree(utask);
+	tsk->utask = NULL;
+}
+
+/*
+ * Allocate a uprobe_task object for the task.
+ * Called when the thread hits a breakpoint for the first time.
+ *
+ * Returns:
+ * - pointer to new uprobe_task on success
+ * - negative errno otherwise
+ */
+static struct uprobe_task *add_utask(void)
+{
+	struct uprobe_task *utask;
+
+	utask = kzalloc(sizeof *utask, GFP_KERNEL);
+	if (unlikely(utask == NULL))
+		return ERR_PTR(-ENOMEM);
+
+	utask->active_uprobe = NULL;
+	current->utask = utask;
+	return utask;
+}
