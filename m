Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2E2Tb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672Ab2E2Tbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:31:52 -0400
Date: Tue, 29 May 2012 21:30:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120529193008.GG8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill the no longer needed uprobes_srcu/uprobe_srcu_id code.

It doesn't really work anyway. synchronize_srcu() can only synchronize
with the code "inside" the srcu_read_lock/srcu_read_unlock section,
while uprobe_pre_sstep_notifier() does srcu_read_lock() _after_ we
already hit the breakpoint.

I guess this probably works "in practice". synchronize_srcu() is slow
and it implies synchronize_sched(), and the probed task enters the non-
preemptible section at the start of exception handler. Still this is not
right at least in theory, and task->uprobe_srcu_id blows task_struct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h   |    1 -
 kernel/events/uprobes.c |   22 +++-------------------
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f45c0b2..411827e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1574,7 +1574,6 @@ struct task_struct {
 #endif
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
-	int uprobe_srcu_id;
 #endif
 };
 
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 1f02e3b..8c5e043 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -38,7 +38,6 @@
 #define UINSNS_PER_PAGE			(PAGE_SIZE/UPROBE_XOL_SLOT_BYTES)
 #define MAX_UPROBE_XOL_SLOTS		UINSNS_PER_PAGE
 
-static struct srcu_struct uprobes_srcu;
 static struct rb_root uprobes_tree = RB_ROOT;
 
 static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
@@ -738,20 +737,14 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, loff_t vaddr)
 }
 
 /*
- * There could be threads that have hit the breakpoint and are entering the
- * notifier code and trying to acquire the uprobes_treelock. The thread
- * calling delete_uprobe() that is removing the uprobe from the rb_tree can
- * race with these threads and might acquire the uprobes_treelock compared
- * to some of the breakpoint hit threads. In such a case, the breakpoint
- * hit threads will not find the uprobe. The current unregistering thread
- * waits till all other threads have hit a breakpoint, to acquire the
- * uprobes_treelock before the uprobe is removed from the rbtree.
+ * There could be threads that have already hit the breakpoint. They
+ * will recheck the current insn and restart if find_uprobe() fails.
+ * See find_active_uprobe().
  */
 static void delete_uprobe(struct uprobe *uprobe)
 {
 	unsigned long flags;
 
-	synchronize_srcu(&uprobes_srcu);
 	spin_lock_irqsave(&uprobes_treelock, flags);
 	rb_erase(&uprobe->rb_node, &uprobes_tree);
 	spin_unlock_irqrestore(&uprobes_treelock, flags);
@@ -1388,9 +1381,6 @@ void uprobe_free_utask(struct task_struct *t)
 {
 	struct uprobe_task *utask = t->utask;
 
-	if (t->uprobe_srcu_id != -1)
-		srcu_read_unlock_raw(&uprobes_srcu, t->uprobe_srcu_id);
-
 	if (!utask)
 		return;
 
@@ -1408,7 +1398,6 @@ void uprobe_free_utask(struct task_struct *t)
 void uprobe_copy_process(struct task_struct *t)
 {
 	t->utask = NULL;
-	t->uprobe_srcu_id = -1;
 }
 
 /*
@@ -1513,9 +1502,6 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	} else {
 		*is_swbp = -EFAULT;
 	}
-
-	srcu_read_unlock_raw(&uprobes_srcu, current->uprobe_srcu_id);
-	current->uprobe_srcu_id = -1;
 	up_read(&mm->mmap_sem);
 
 	return uprobe;
@@ -1656,7 +1642,6 @@ int uprobe_pre_sstep_notifier(struct pt_regs *regs)
 		utask->state = UTASK_BP_HIT;
 
 	set_thread_flag(TIF_UPROBE);
-	current->uprobe_srcu_id = srcu_read_lock_raw(&uprobes_srcu);
 
 	return 1;
 }
@@ -1691,7 +1676,6 @@ static int __init init_uprobes(void)
 		mutex_init(&uprobes_mutex[i]);
 		mutex_init(&uprobes_mmap_mutex[i]);
 	}
-	init_srcu_struct(&uprobes_srcu);
 
 	return register_die_notifier(&uprobe_exception_nb);
 }
-- 
1.5.5.1


