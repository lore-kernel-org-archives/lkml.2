Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0EAO1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:27:55 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63139 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab0EAO04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:26:56 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v21 032/100] c/r: Save and restore the [compat_]robust_list member of the task struct
Date: Sat,  1 May 2010 10:15:14 -0400
Message-Id: <1272723382-19470-33-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Helsley <matthltc@us.ibm.com>

These lists record which futexes the task holds. To keep the overhead of
robust futexes low the list is kept in userspace. When the task exits the
kernel carefully walks these lists to recover held futexes that
other tasks may be attempting to acquire with FUTEX_WAIT.

Because they point to userspace memory that is saved/restored by
checkpoint/restart saving the list pointers themselves is safe.

While saving the pointers is safe during checkpoint, restart is tricky
because the robust futex ABI contains provisions for changes based on
checking the size of the list head. So we need to save the length of
the list head too in order to make sure that the kernel used during
restart is capable of handling that ABI. Since there is only one ABI
supported at the moment taking the list head's size is simple. Should
the ABI change we will need to use the same size as specified during
sys_set_robust_list() and hence some new means of determining the length
of this userspace structure in sys_checkpoint would be required.

Rather than rewrite the logic that checks and handles the ABI we reuse
sys_set_robust_list() by factoring out the body of the function and
calling it during restart.

Changelog [v19]:
  - Keep __u32s in even groups for 32-64 bit compatibility

Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/checkpoint_hdr.h |    5 ++++
 include/linux/compat.h         |    3 +-
 include/linux/futex.h          |    1 +
 kernel/checkpoint/process.c    |   49 ++++++++++++++++++++++++++++++++++++++++
 kernel/futex.c                 |   19 +++++++++-----
 kernel/futex_compat.c          |   13 ++++++++--
 6 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 68ee0f3..c7d34a6 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -167,6 +167,11 @@ struct ckpt_hdr_task {
 	__u32 exit_signal;
 	__u32 pdeath_signal;
 
+	__u32 compat_robust_futex_head_len;
+	__u32 compat_robust_futex_list; /* a compat __user ptr */
+	__u32 robust_futex_head_len;
+	__u64 robust_futex_list; /* a __user ptr */
+
 	__u64 set_child_tid;
 	__u64 clear_child_tid;
 } __attribute__((aligned(8)));
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 717c691..89125dd 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -210,7 +210,8 @@ struct compat_robust_list_head {
 };
 
 extern void compat_exit_robust_list(struct task_struct *curr);
-
+extern long do_compat_set_robust_list(struct compat_robust_list_head __user *head,
+				      compat_size_t len);
 asmlinkage long
 compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 			   compat_size_t len);
diff --git a/include/linux/futex.h b/include/linux/futex.h
index ae755f6..c825790 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -185,6 +185,7 @@ union futex_key {
 #define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = NULL } }
 
 #ifdef CONFIG_FUTEX
+extern long do_set_robust_list(struct robust_list_head __user *head, size_t len);
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
 extern int futex_cmpxchg_enabled;
diff --git a/kernel/checkpoint/process.c b/kernel/checkpoint/process.c
index ce009cb..aabefb6 100644
--- a/kernel/checkpoint/process.c
+++ b/kernel/checkpoint/process.c
@@ -14,9 +14,56 @@
 #include <linux/sched.h>
 #include <linux/posix-timers.h>
 #include <linux/futex.h>
+#include <linux/compat.h>
 #include <linux/poll.h>
 #include <linux/checkpoint.h>
 
+
+#ifdef CONFIG_FUTEX
+static void save_task_robust_futex_list(struct ckpt_hdr_task *h,
+					struct task_struct *t)
+{
+	/*
+	 * These are __user pointers and thus can be saved without
+	 * the objhash.
+	 */
+	h->robust_futex_list = (unsigned long)t->robust_list;
+	h->robust_futex_head_len = sizeof(*t->robust_list);
+#ifdef CONFIG_COMPAT
+	h->compat_robust_futex_list = ptr_to_compat(t->compat_robust_list);
+	h->compat_robust_futex_head_len = sizeof(*t->compat_robust_list);
+#endif
+}
+
+static void restore_task_robust_futex_list(struct ckpt_hdr_task *h)
+{
+	/* Since we restore the memory map the address remains the same and
+	 * this is safe. This is the same as [compat_]sys_set_robust_list() */
+	if (h->robust_futex_list) {
+		struct robust_list_head __user *rfl;
+		rfl = (void __user *)(unsigned long) h->robust_futex_list;
+		do_set_robust_list(rfl, h->robust_futex_head_len);
+	}
+#ifdef CONFIG_COMPAT
+	if (h->compat_robust_futex_list) {
+		struct compat_robust_list_head __user *crfl;
+		crfl = compat_ptr(h->compat_robust_futex_list);
+		do_compat_set_robust_list(crfl, h->compat_robust_futex_head_len);
+	}
+#endif
+}
+#else /* !CONFIG_FUTEX */
+static inline void save_task_robust_futex_list(struct ckpt_hdr_task *h,
+					       struct task_struct *t)
+{
+}
+
+static inline void restore_task_robust_futex_list(struct ckpt_hdr_task *h)
+{
+}
+#endif /* CONFIG_FUTEX */
+
+
 /***********************************************************************
  * Checkpoint
  */
@@ -45,6 +92,7 @@ static int checkpoint_task_struct(struct ckpt_ctx *ctx, struct task_struct *t)
 
 		h->set_child_tid = (unsigned long) t->set_child_tid;
 		h->clear_child_tid = (unsigned long) t->clear_child_tid;
+		save_task_robust_futex_list(h, t);
 	}
 
 	ret = ckpt_write_obj(ctx, &h->h);
@@ -248,6 +296,7 @@ static int restore_task_struct(struct ckpt_ctx *ctx)
 			(int __user *) (unsigned long) h->set_child_tid;
 		t->clear_child_tid =
 			(int __user *) (unsigned long) h->clear_child_tid;
+		restore_task_robust_futex_list(h);
 	}
 
 	memset(t->comm, 0, TASK_COMM_LEN);
diff --git a/kernel/futex.c b/kernel/futex.c
index 23419c9..baaecb4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2342,13 +2342,7 @@ out:
  * the list. There can only be one such pending lock.
  */
 
-/**
- * sys_set_robust_list() - Set the robust-futex list head of a task
- * @head:	pointer to the list-head
- * @len:	length of the list-head, as userspace expects
- */
-SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
-		size_t, len)
+long do_set_robust_list(struct robust_list_head __user *head, size_t len)
 {
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -2364,6 +2358,17 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 }
 
 /**
+ * sys_set_robust_list() - Set the robust-futex list head of a task
+ * @head:	pointer to the list-head
+ * @len:	length of the list-head, as userspace expects
+ */
+SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
+		size_t, len)
+{
+	return do_set_robust_list(head, len);
+}
+
+/**
  * sys_get_robust_list() - Get the robust-futex list head of a task
  * @pid:	pid of the process [zero for current task]
  * @head_ptr:	pointer to a list-head pointer, the kernel fills it in
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index d49afb2..900bb2b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -114,9 +114,9 @@ void compat_exit_robust_list(struct task_struct *curr)
 	}
 }
 
-asmlinkage long
-compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
-			   compat_size_t len)
+long
+do_compat_set_robust_list(struct compat_robust_list_head __user *head,
+			  compat_size_t len)
 {
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
@@ -130,6 +130,13 @@ compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
 }
 
 asmlinkage long
+compat_sys_set_robust_list(struct compat_robust_list_head __user *head,
+			   compat_size_t len)
+{
+	return do_compat_set_robust_list(head, len);
+}
+
+asmlinkage long
 compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 			   compat_size_t __user *len_ptr)
 {
-- 
1.6.3.3

