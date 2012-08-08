Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab2HHRlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:41:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759055Ab2HHRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:41:08 -0400
Date: Wed, 8 Aug 2012 19:37:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes: fold uprobe_reset_state() into
	uprobe_dup_mmap()
Message-ID: <20120808173749.GA13275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808173659.GA13220@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have uprobe_dup_mmap() we can fold uprobe_reset_state()
into the new hook and remove it. mmput()->uprobe_clear_state() can't
be called before dup_mmap().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    4 ----
 kernel/events/uprobes.c |   10 ++--------
 kernel/fork.c           |    2 --
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 4a37ab1..30297f9 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -118,7 +118,6 @@ extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
 extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
-extern void uprobe_reset_state(struct mm_struct *mm);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
 };
@@ -163,8 +162,5 @@ static inline void uprobe_copy_process(struct task_struct *t)
 static inline void uprobe_clear_state(struct mm_struct *mm)
 {
 }
-static inline void uprobe_reset_state(struct mm_struct *mm)
-{
-}
 #endif /* !CONFIG_UPROBES */
 #endif	/* _LINUX_UPROBES_H */
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2a42319..81fb2d8 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1150,16 +1150,10 @@ void uprobe_clear_state(struct mm_struct *mm)
 	kfree(area);
 }
 
-/*
- * uprobe_reset_state - Free the area allocated for slots.
- */
-void uprobe_reset_state(struct mm_struct *mm)
-{
-	mm->uprobes_state.xol_area = NULL;
-}
-
 void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
+	newmm->uprobes_state.xol_area = NULL;
+
 	if (test_bit(MMF_HAS_UPROBES, &oldmm->flags))
 		set_bit(MMF_HAS_UPROBES, &newmm->flags);
 }
diff --git a/kernel/fork.c b/kernel/fork.c
index ab970c3..5555f51 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -836,8 +836,6 @@ struct mm_struct *dup_mm(struct task_struct *tsk)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
 #endif
-	uprobe_reset_state(mm);
-
 	if (!mm_init(mm, tsk))
 		goto fail_nomem;
 
-- 
1.5.5.1

