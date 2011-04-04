Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1DDOeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:34:19 -0400
Received: from mail.aknet.ru ([78.158.192.28]:52325 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1DDOeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:34:18 -0400
Message-ID: <4D99D6E6.4070008@aknet.ru>
Date: Mon, 04 Apr 2011 18:34:14 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com>
In-Reply-To: <20110331170244.GA13271@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------090708080601030505020301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090708080601030505020301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oleg.

Here's the patch that addresses your concerns
about the late deleting from list.
Also, the patch is shrunk twice.
I think it is about to be trivial this time.
I still haven't solved the problems with checking
parent and checking ptrace, so ignore them for
now (or give me the hints:)
Do we still have other bugs here?

--------------090708080601030505020301
Content-Type: text/plain;
 name="01_sigpar.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="01_sigpar.diff"

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..e74882f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2096,6 +2096,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern int do_signal_parent(struct task_struct *, int, int, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
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

--------------090708080601030505020301
Content-Type: text/plain;
 name="pr_detach2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pr_detach2.diff"

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
index e74882f..2e2acba 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1260,6 +1260,8 @@ struct task_struct {
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
+	int detach_code;
+	int detaching;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
 	unsigned int personality;
diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..276b39f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -791,7 +791,14 @@ static void forget_original_parent(struct task_struct *father)
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		struct task_struct *t = p;
+		struct task_struct *t;
+		if (p->detaching) {
+			list_move_tail(&p->sibling,
+					&p->real_parent->children);
+			p->detaching = 0;
+			continue;
+		}
+		t = p;
 		do {
 			t->real_parent = reaper;
 			if (t->parent == father) {
@@ -1507,6 +1514,50 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	return retval;
 }
 
+static int wait_task_detached(struct wait_opts *wo, struct task_struct *p)
+{
+	int dt, retval = 0;
+	pid_t pid;
+	uid_t uid;
+
+	if (!likely(wo->wo_flags & WEXITED))
+		return 0;
+
+	if (unlikely(wo->wo_flags & WNOWAIT)) {
+		get_task_struct(p);
+		read_unlock(&tasklist_lock);
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		return wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code >> 8);
+	}
+
+	dt = xchg(&p->detaching, 0);
+	if (dt != 1)
+		return 0;
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
+	/* hand it over to init */
+	write_lock_irq(&tasklist_lock);
+	list_move_tail(&p->sibling, &p->real_parent->children);
+	write_unlock_irq(&tasklist_lock);
+
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
+	return retval;
+}
+
 /*
  * Consider @p for a wait by @parent.
  *
@@ -1549,6 +1600,9 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (p->exit_state == EXIT_DEAD)
 		return 0;
 
+	if (p->detaching)
+		return wait_task_detached(wo, p);
+
 	/*
 	 * We don't reap group leaders with subthreads.
 	 */
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..dd28aff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1233,6 +1233,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
+	p->detaching = 0;
 
 	/*
 	 * Ok, make it visible to the rest of the system.
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..e4dadd6 100644
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
@@ -1736,6 +1737,40 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_DETACH: {
+			struct task_struct *p;
+			struct pid_namespace *pid_ns = task_active_pid_ns(me);
+			int notif = DEATH_REAP;
+			error = -EPERM;
+			/* not detaching from init */
+			if (me->real_parent == pid_ns->child_reaper)
+				break;
+			if (arg2 & ~0x7f)
+				break;
+			write_lock_irq(&tasklist_lock);
+			me->detach_code = arg2 << 8;
+			notif = do_signal_parent(me, me->exit_signal,
+					CLD_DETACHED, arg2);
+			if (notif != DEATH_REAP)
+				me->detaching = 1;
+			else
+				list_move_tail(&me->sibling,
+					&me->real_parent->children);
+			if (!ptrace_reparented(me))
+				me->parent = pid_ns->child_reaper;
+			me->real_parent = pid_ns->child_reaper;
+			/* reparent threads */
+			p = me;
+			while_each_thread(me, p) {
+				if (!ptrace_reparented(p))
+					p->parent = pid_ns->child_reaper;
+				p->real_parent = pid_ns->child_reaper;
+			}
+			me->exit_signal = SIGCHLD;
+			write_unlock_irq(&tasklist_lock);
+			error = 0;
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;

--------------090708080601030505020301--
