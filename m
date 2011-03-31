Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab1CaQK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:10:56 -0400
Received: from mail.aknet.ru ([78.158.192.28]:57402 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593Ab1CaQKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:10:53 -0400
Message-ID: <4D94A788.1050806@aknet.ru>
Date: Thu, 31 Mar 2011 20:10:48 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com>
In-Reply-To: <20110224153221.GA22770@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020702070905000100050602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020702070905000100050602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oleg.

I found some time to get back to that patch and
to address all of the problems you pointed.
What do you think about the attached patch?
I didn't expect it would became that big.

--------------020702070905000100050602
Content-Type: text/plain;
 name="pr_detach.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pr_detach.diff"

commit 1a19a1ed5f1ab86e3fb029f201383627a6b2bbd5
Author: Stas <stas@stas.(none)>
Date:   Thu Mar 31 19:58:17 2011 +0400

    implement PR_DETACH

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 7c99c1c..77df70d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -139,9 +139,10 @@ static const char *task_state_array[] = {
 	"t (tracing stop)",	/*   8 */
 	"Z (zombie)",		/*  16 */
 	"X (dead)",		/*  32 */
-	"x (dead)",		/*  64 */
-	"K (wakekill)",		/* 128 */
-	"W (waking)",		/* 256 */
+	"d (detached)",		/*  64 */
+	"x (dead)",		/* 128 */
+	"K (wakekill)",		/* 256 */
+	"W (waking)",		/* 512 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 942d30b..1da9c20 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -218,7 +218,8 @@ typedef struct siginfo {
 #define CLD_TRAPPED	(__SI_CHLD|4)	/* traced child has trapped */
 #define CLD_STOPPED	(__SI_CHLD|5)	/* child has stopped */
 #define CLD_CONTINUED	(__SI_CHLD|6)	/* stopped child has continued */
-#define NSIGCHLD	6
+#define CLD_DETACHED	(__SI_CHLD|7)	/* child has detached */
+#define NSIGCHLD	7
 
 /*
  * SIGPOLL si_codes
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..fdf71a9 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -158,6 +158,8 @@ extern struct cred init_cred;
 	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
+	.detached_children	= LIST_HEAD_INIT(tsk.detached_children),\
+	.detached_sibling	= LIST_HEAD_INIT(tsk.detached_sibling),	\
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..fbd2451 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,6 @@
 
 #define PR_MCE_KILL_GET 34
 
+#define PR_DETACH 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..eb99afb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -186,13 +186,14 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 /* in tsk->exit_state */
 #define EXIT_ZOMBIE		16
 #define EXIT_DEAD		32
+#define EXIT_DETACHED		64
 /* in tsk->state again */
-#define TASK_DEAD		64
-#define TASK_WAKEKILL		128
-#define TASK_WAKING		256
-#define TASK_STATE_MAX		512
+#define TASK_DEAD		128
+#define TASK_WAKEKILL		256
+#define TASK_WAKING		512
+#define TASK_STATE_MAX		1024
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXdxKW"
 
 extern char ___assert_task_state[1 - 2*!!(
 		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
@@ -1260,6 +1261,8 @@ struct task_struct {
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
+	int exit_flags;
+	int detach_code;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
 	unsigned int personality;
@@ -1292,7 +1295,10 @@ struct task_struct {
 	 */
 	struct list_head children;	/* list of my children */
 	struct list_head sibling;	/* linkage in my parent's children list */
+	struct list_head detached_children;	/* list of my detached children */
+	struct list_head detached_sibling;	/* linkage in my parent's detached children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
+	int num_waiters;			/* detached task may have 2 */
 
 	/*
 	 * ptraced is the list of tasks this task is using ptrace on.
@@ -1747,6 +1753,10 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezable */
 #define PF_FREEZER_NOSIG 0x80000000	/* Freezer won't send signals to it */
 
+/* exit flags */
+#define EF_RETCODE_READ	0x00000001	/* parent read(ed) exit code */
+#define EF_DCODE_READ	0x00000002	/* parent read(ed) detach code */
+
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
  * tasks can access tsk->flags in readonly mode for example
@@ -2096,6 +2106,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern int do_signal_parent(struct task_struct *, int, int, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..26d162e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -69,6 +69,7 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
+		list_del_init(&p->detached_sibling);
 		__this_cpu_dec(process_counts);
 	}
 	list_del_rcu(&p->thread_group);
@@ -804,12 +805,28 @@ static void forget_original_parent(struct task_struct *father)
 		} while_each_thread(p, t);
 		reparent_leader(father, p, &dead_children);
 	}
+	list_for_each_entry(p, &father->detached_children, detached_sibling) {
+		BUG_ON(p->num_waiters == 0);
+		/* see if original parent didn't care to read detach code */
+		if (!(p->exit_flags & EF_DCODE_READ))
+			p->num_waiters--;
+		if (p->exit_state == EXIT_DETACHED) {
+			BUG_ON(p->num_waiters != 1);
+			/* continue as normal task */
+			p->exit_state = 0;
+		} else if (p->exit_state == EXIT_ZOMBIE && !p->num_waiters) {
+			BUG_ON(!(p->exit_flags & EF_RETCODE_READ));
+			p->exit_state = EXIT_DEAD;
+			list_move_tail(&p->sibling, &dead_children);
+		}
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	BUG_ON(!list_empty(&father->children));
 
 	list_for_each_entry_safe(p, n, &dead_children, sibling) {
 		list_del_init(&p->sibling);
+		list_del_init(&p->detached_sibling);
 		release_task(p);
 	}
 }
@@ -861,7 +878,11 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	if (signal >= 0)
 		signal = do_notify_parent(tsk, signal);
 
-	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
+	/* EXIT_DETACHED case means that the previous parent still alive */
+	if (tsk->exit_state == EXIT_DETACHED || signal != DEATH_REAP)
+		tsk->exit_state = EXIT_ZOMBIE;
+	else
+		tsk->exit_state = EXIT_DEAD;
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
@@ -1195,14 +1216,25 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
  * the lock and this task is uninteresting.  If we return nonzero, we have
  * released the lock and the system call should return.
  */
-static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
+static int _wait_task_zombie(struct wait_opts *wo, struct task_struct *p,
+	int dcode)
 {
 	unsigned long state;
-	int retval, status, traced;
+	int retval, status, traced, keep_task;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = __task_cred(p)->uid;
 	struct siginfo __user *infop;
 
+	/* see if already waited */
+	if (p->exit_flags & (dcode ? EF_DCODE_READ : EF_RETCODE_READ))
+		return 0;
+
+	/*
+	 * We don't reap group leaders with subthreads.
+	 */
+	if (delay_group_leader(p))
+		return 0;
+
 	if (!likely(wo->wo_flags & WEXITED))
 		return 0;
 
@@ -1309,8 +1341,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
-	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
-		? p->signal->group_exit_code : p->exit_code;
+	if (!dcode)
+		status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+			? p->signal->group_exit_code : p->exit_code;
+	else
+		status = p->detach_code;
 	if (!retval && wo->wo_stat)
 		retval = put_user(status, wo->wo_stat);
 
@@ -1340,8 +1375,18 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	if (!retval)
 		retval = pid;
 
+	keep_task = 0;
+	write_lock_irq(&tasklist_lock);
+	p->exit_flags |= (dcode ? EF_DCODE_READ : EF_RETCODE_READ);
+	p->num_waiters--;
+
+	if (p->num_waiters > 0) {
+		/* not all waiters are satisfied yet */
+		p->exit_state = EXIT_ZOMBIE;
+		keep_task = 1;
+	}
+
 	if (traced) {
-		write_lock_irq(&tasklist_lock);
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
 		/*
@@ -1353,17 +1398,23 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			do_notify_parent(p, p->exit_signal);
 			if (!task_detached(p)) {
 				p->exit_state = EXIT_ZOMBIE;
-				p = NULL;
+				keep_task = 1;
 			}
 		}
-		write_unlock_irq(&tasklist_lock);
 	}
-	if (p != NULL)
+	write_unlock_irq(&tasklist_lock);
+
+	if (!keep_task)
 		release_task(p);
 
 	return retval;
 }
 
+static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
+{
+	return _wait_task_zombie(wo, p, 0);
+}
+
 static int *task_stopped_code(struct task_struct *p, bool ptrace)
 {
 	if (ptrace) {
@@ -1507,21 +1558,61 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	return retval;
 }
 
-/*
- * Consider @p for a wait by @parent.
- *
- * -ECHILD should be in ->notask_error before the first call.
- * Returns nonzero for a final return, when we have unlocked tasklist_lock.
- * Returns zero if the search for a child should continue;
- * then ->notask_error is 0 if @p is an eligible child,
- * or another error from security_task_wait(), or still -ECHILD.
- */
-static int wait_consider_task(struct wait_opts *wo, int ptrace,
-				struct task_struct *p)
+static int wait_task_detached(struct wait_opts *wo, struct task_struct *p)
+{
+	int retval = 0;
+	unsigned long state;
+	pid_t pid;
+	uid_t uid;
+
+	if (p->exit_flags & EF_DCODE_READ)
+		return 0;
+
+	if (!likely(wo->wo_flags & WEXITED))
+		return 0;
+
+	if (unlikely(wo->wo_flags & WNOWAIT)) {
+		get_task_struct(p);
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		read_unlock(&tasklist_lock);
+		return wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code >> 8);
+	}
+
+	state = xchg(&p->exit_state, 0);
+	/* check for race because of read_lock(&tasklist_lock) */
+	if (state != EXIT_DETACHED) {
+		BUG_ON(state != 0);
+		return 0;
+	}
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+	if (wo->wo_stat)
+		retval = put_user(p->detach_code, wo->wo_stat);
+
+	if (!retval) {
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		retval = wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code >> 8);
+	} else {
+		put_task_struct(p);
+	}
+
+	write_lock_irq(&tasklist_lock);
+	p->num_waiters--;
+	p->exit_flags |= EF_DCODE_READ;
+	write_unlock_irq(&tasklist_lock);
+
+	return retval;
+}
+
+static int can_wait_task_common(struct wait_opts *wo, struct task_struct *p)
 {
 	int ret = eligible_child(wo, p);
 	if (!ret)
-		return ret;
+		return 0;
 
 	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
@@ -1537,7 +1628,25 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (likely(!ptrace) && unlikely(task_ptrace(p))) {
+	if (p->exit_state == EXIT_DEAD)
+		return 0;
+
+	return 1;
+}
+
+static int can_wait_task_ptrace(struct wait_opts *wo, struct task_struct *p)
+{
+	/* don't worry, gcc will optimize away this function :) */
+	return can_wait_task_common(wo, p);
+}
+
+static int can_wait_task(struct wait_opts *wo, struct task_struct *p)
+{
+	int ret = can_wait_task_common(wo, p);
+	if (!ret)
+		return 0;
+
+	if (unlikely(task_ptrace(p))) {
 		/*
 		 * This child is hidden by ptrace.
 		 * We aren't allowed to see it now, but eventually we will.
@@ -1546,13 +1655,22 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	if (p->exit_state == EXIT_DEAD)
-		return 0;
+	return 1;
+}
 
-	/*
-	 * We don't reap group leaders with subthreads.
-	 */
-	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
+/*
+ * Consider @p for a wait by @parent.
+ *
+ * -ECHILD should be in ->notask_error before the first call.
+ * Returns nonzero for a final return, when we have unlocked tasklist_lock.
+ * Returns zero if the search for a child should continue;
+ * then ->notask_error is 0 if @p is an eligible child,
+ * or another error from security_task_wait(), or still -ECHILD.
+ */
+static int wait_consider_task(struct wait_opts *wo, int ptrace,
+				struct task_struct *p)
+{
+	if (p->exit_state == EXIT_ZOMBIE)
 		return wait_task_zombie(wo, p);
 
 	/*
@@ -1578,10 +1696,29 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
  */
 static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
 {
+	int ret;
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		int ret = wait_consider_task(wo, 0, p);
+		ret = can_wait_task(wo, p);
+		if (!ret)
+			continue;
+		ret = wait_consider_task(wo, 0, p);
+		if (ret)
+			return ret;
+	}
+
+	list_for_each_entry(p, &tsk->detached_children, detached_sibling) {
+		if (p->exit_state != EXIT_DETACHED &&
+				p->exit_state != EXIT_ZOMBIE)
+			continue;
+		ret = can_wait_task(wo, p);
+		if (!ret)
+			continue;
+		if (p->exit_state == EXIT_ZOMBIE)
+			ret = _wait_task_zombie(wo, p, 1);
+		else
+			ret = wait_task_detached(wo, p);
 		if (ret)
 			return ret;
 	}
@@ -1594,7 +1731,10 @@ static int ptrace_do_wait(struct wait_opts *wo, struct task_struct *tsk)
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
-		int ret = wait_consider_task(wo, 1, p);
+		int ret = can_wait_task_ptrace(wo, p);
+		if (!ret)
+			continue;
+		ret = wait_consider_task(wo, 1, p);
 		if (ret)
 			return ret;
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..60166dc 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1070,6 +1070,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
+	INIT_LIST_HEAD(&p->detached_children);
+	INIT_LIST_HEAD(&p->detached_sibling);
 	rcu_copy_process(p);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
@@ -1233,6 +1235,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
+	p->exit_flags = 0;
+	p->num_waiters = 1;
 
 	/*
 	 * Ok, make it visible to the rest of the system.
diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..54b93c7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1434,14 +1434,8 @@ ret:
 	return ret;
 }
 
-/*
- * Let a parent know about the death of a child.
- * For a stopped/continued status change, use do_notify_parent_cldstop instead.
- *
- * Returns -1 if our parent ignored us and so we've switched to
- * self-reaping, or else @sig.
- */
-int do_notify_parent(struct task_struct *tsk, int sig)
+int do_signal_parent(struct task_struct *tsk, int sig, int sicode,
+	int sistatus)
 {
 	struct siginfo info;
 	unsigned long flags;
@@ -1450,11 +1444,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
-
-	BUG_ON(!task_ptrace(tsk) &&
-	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	info.si_signo = sig;
 	info.si_errno = 0;
@@ -1480,15 +1471,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
 				tsk->signal->stime));
 
-	info.si_status = tsk->exit_code & 0x7f;
-	if (tsk->exit_code & 0x80)
-		info.si_code = CLD_DUMPED;
-	else if (tsk->exit_code & 0x7f)
-		info.si_code = CLD_KILLED;
-	else {
-		info.si_code = CLD_EXITED;
-		info.si_status = tsk->exit_code >> 8;
-	}
+	info.si_code = sicode;
+	info.si_status = sistatus;
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
@@ -1510,9 +1494,11 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 		 * is implementation-defined: we do (if you don't want
 		 * it, just use SIG_IGN instead).
 		 */
-		ret = tsk->exit_signal = -1;
+		tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = -1;
+		/* reap process now, rather than promoting to zombie */
+		ret = DEATH_REAP;
 	}
 	if (valid_signal(sig) && sig > 0)
 		__group_send_sig_info(sig, &info, tsk->parent);
@@ -1522,6 +1508,33 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	return ret;
 }
 
+/*
+ * Let a parent know about the death of a child.
+ * For a stopped/continued status change, use do_notify_parent_cldstop instead.
+ *
+ * Returns -1 if our parent ignored us and so we've switched to
+ * self-reaping, or else @sig.
+ */
+int do_notify_parent(struct task_struct *tsk, int sig)
+{
+	int sicode, sistatus;
+
+	BUG_ON(!task_ptrace(tsk) &&
+	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
+
+	sistatus = tsk->exit_code & 0x7f;
+	if (tsk->exit_code & 0x80)
+		sicode = CLD_DUMPED;
+	else if (tsk->exit_code & 0x7f)
+		sicode = CLD_KILLED;
+	else {
+		sicode = CLD_EXITED;
+		sistatus = tsk->exit_code >> 8;
+	}
+
+	return do_signal_parent(tsk, sig, sicode, sistatus);
+}
+
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..e5d6332 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/tty.h>
 #include <linux/signal.h>
+#include <linux/tracehook.h>
 #include <linux/cn_proc.h>
 #include <linux/getcpu.h>
 #include <linux/task_io_accounting_ops.h>
@@ -1736,6 +1737,50 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_DETACH: {
+			struct task_struct *p, *old_parent;
+			int notif = DEATH_REAP;
+			error = -EPERM;
+			/* not detaching from init */
+			if (me->real_parent == init_pid_ns.child_reaper)
+				break;
+			if (arg2 & ~0x7f)
+				break;
+			write_lock_irq(&tasklist_lock);
+			old_parent = me->real_parent;
+			me->detach_code = arg2 << 8;
+			if (!task_detached(me))
+				notif = do_signal_parent(me, me->exit_signal,
+					CLD_DETACHED, arg2);
+			if (notif != DEATH_REAP) {
+				list_add_tail(&me->detached_sibling,
+					&me->real_parent->detached_children);
+				me->exit_state = EXIT_DETACHED;
+				me->num_waiters++;
+			} else {
+				me->exit_state = 0;
+			}
+			if (!ptrace_reparented(me))
+				me->parent = init_pid_ns.child_reaper;
+			me->real_parent = init_pid_ns.child_reaper;
+			list_move_tail(&me->sibling,
+					&me->real_parent->children);
+			/* detaching makes us a group leader */
+			me->group_leader = me;
+			/* reparent threads */
+			p = me;
+			while_each_thread(me, p) {
+				if (p->real_parent != old_parent)
+					continue;
+				if (!ptrace_reparented(p))
+					p->parent = init_pid_ns.child_reaper;
+				p->real_parent = init_pid_ns.child_reaper;
+			}
+			me->exit_signal = SIGCHLD;
+			write_unlock_irq(&tasklist_lock);
+			error = 0;
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;

--------------020702070905000100050602--
