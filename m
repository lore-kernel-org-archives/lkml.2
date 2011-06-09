Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1FIVgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:36:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:37463 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1FIVgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:36:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="16383404"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 08/10] NOTIFIER: Take over TIF_MCE_NOTIFY and implement task return notifier
Date: Thu, 09 Jun 2011 14:36:42 -0700
Message-Id: <4df13cea27302b7ccf@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

Existing user return notifier mechanism is designed to catch a specific
cpu just as it returns to run any task in user mode.  We also need a
machanism to catch a specific task.

N.B. This version is not fit for use - it uses normal Linux lists (which
are not NMI safe).  Once Ying's NMI-safe single threaded lists are merged,
it should be updated to use them.

NOT-Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/thread_info.h   |    8 +++---
 arch/x86/kernel/signal.c             |    3 ++
 include/linux/sched.h                |    3 ++
 include/linux/user-return-notifier.h |   14 +++++++++++++
 kernel/fork.c                        |    1 +
 kernel/user-return-notifier.c        |   36 ++++++++++++++++++++++++++++++++++
 6 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 1f2e61e..5574f96 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -82,7 +82,7 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+#define TIF_TASK_RETURN_NOTIFY	10	/* notify kernel of return to task */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
@@ -105,7 +105,7 @@ struct thread_info {
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
+#define _TIF_TASK_RETURN_NOTIFY	(1 << TIF_TASK_RETURN_NOTIFY)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
@@ -139,8 +139,8 @@ struct thread_info {
 	((0x0000FFFF & ~_TIF_SECCOMP) | _TIF_SYSCALL_TRACEPOINT)
 
 /* Only used for 64 bit */
-#define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\
+#define _TIF_DO_NOTIFY_MASK							\
+	(_TIF_SIGPENDING | _TIF_TASK_RETURN_NOTIFY | _TIF_NOTIFY_RESUME |	\
 	 _TIF_USER_RETURN_NOTIFY)
 
 /* flags to check in __switch_to() */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 44efc22..f0f45b1 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -838,6 +838,9 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
+	if (thread_info_flags & _TIF_TASK_RETURN_NOTIFY)
+		fire_task_return_notifiers();
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 781abd1..ec7a581 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1540,6 +1540,9 @@ struct task_struct {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 	atomic_t ptrace_bp_refcnt;
 #endif
+#ifdef CONFIG_USER_RETURN_NOTIFIER
+	struct hlist_head return_notifier_list;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/include/linux/user-return-notifier.h b/include/linux/user-return-notifier.h
index 9c4a445..6114b25 100644
--- a/include/linux/user-return-notifier.h
+++ b/include/linux/user-return-notifier.h
@@ -15,6 +15,9 @@ struct user_return_notifier {
 void user_return_notifier_register(struct user_return_notifier *urn);
 void user_return_notifier_unregister(struct user_return_notifier *urn);
 
+void task_return_notifier_register(struct user_return_notifier *urn);
+void task_return_notifier_unregister(struct user_return_notifier *urn);
+
 static inline void propagate_user_return_notify(struct task_struct *prev,
 						struct task_struct *next)
 {
@@ -26,11 +29,18 @@ static inline void propagate_user_return_notify(struct task_struct *prev,
 
 void fire_user_return_notifiers(void);
 
+void fire_task_return_notifiers(void);
+
 static inline void clear_user_return_notifier(struct task_struct *p)
 {
 	clear_tsk_thread_flag(p, TIF_USER_RETURN_NOTIFY);
 }
 
+static inline void clear_task_return_notifier(struct task_struct *p)
+{
+	clear_tsk_thread_flag(p, TIF_TASK_RETURN_NOTIFY);
+}
+
 #else
 
 struct user_return_notifier {};
@@ -42,8 +52,12 @@ static inline void propagate_user_return_notify(struct task_struct *prev,
 
 static inline void fire_user_return_notifiers(void) {}
 
+static inline void fire_task_return_notifiers(void) {}
+
 static inline void clear_user_return_notifier(struct task_struct *p) {}
 
+static inline void clear_task_return_notifier(struct task_struct *p) {}
+
 #endif
 
 #endif
diff --git a/kernel/fork.c b/kernel/fork.c
index e7548de..1af37c2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -282,6 +282,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
+	clear_task_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index 92cb706..7c9389e 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -42,3 +42,39 @@ void fire_user_return_notifiers(void)
 		urn->on_user_return(urn);
 	put_cpu_var(return_notifier_list);
 }
+
+/*
+ * Request a notification when the current task returns to userspace.  Must be
+ * called in atomic context.  The notifier will also be called in atomic
+ * context.
+ */
+void task_return_notifier_register(struct user_return_notifier *urn)
+{
+	set_tsk_thread_flag(current, TIF_TASK_RETURN_NOTIFY);
+	hlist_add_head(&urn->link, &(current->return_notifier_list));
+}
+EXPORT_SYMBOL_GPL(task_return_notifier_register);
+
+/*
+ * Removes a registered user return notifier.  Must be called from atomic
+ * context, and from the same cpu registration occurred in.
+ */
+void task_return_notifier_unregister(struct user_return_notifier *urn)
+{
+	hlist_del(&urn->link);
+	if (hlist_empty(&(current->return_notifier_list)))
+		clear_tsk_thread_flag(current, TIF_TASK_RETURN_NOTIFY);
+}
+EXPORT_SYMBOL_GPL(task_return_notifier_unregister);
+
+/* Calls registered user return notifiers */
+void fire_task_return_notifiers(void)
+{
+	struct user_return_notifier *urn;
+	struct hlist_node *tmp1, *tmp2;
+	struct hlist_head *head;
+
+	head = &(current->return_notifier_list);
+	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
+		urn->on_user_return(urn);
+}
-- 
1.7.3.1

