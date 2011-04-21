Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1DUKCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 06:02:25 -0400
Received: from mail.aknet.ru ([78.158.192.28]:49226 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab1DUKCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 06:02:24 -0400
Message-ID: <4DB000A6.5060409@aknet.ru>
Date: Thu, 21 Apr 2011 14:02:14 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
References: <20110404160351.GA23655@redhat.com> <4D9A24A0.5050105@aknet.ru> <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com>
In-Reply-To: <20110420165023.GA24455@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010603060406030308010506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010603060406030308010506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oleg.

Attaching the fixed patch.
Changes:
- in wait_task_consider(), pr_detach hides the process
only in !ptrace case
- reparenting within the group is no longer re-enables detaching
- in do_notify_parent_cldstop(), do not allow notifications of
real_parent (still allow for ptrace parent)
- scared by your question about reparenting, I reserved the
flags argument for the future extensions. :) Reparenting may
depend on a flag.

The attached patch implements the PR_DETACH prctl
command. It detaches the entire process group from
its parent, allowing the parent to still read the detach
code with normal wait().
Can be used to daemonize process with threads.

--------------010603060406030308010506
Content-Type: text/plain;
 name="pr_detach6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pr_detach6.diff"

commit 0654195220b22090ed8f0648ce7d176374932dfa
Author: Stas <stas@stas.(none)>
Date:   Thu Apr 21 13:48:48 2011 +0400

    implement PR_DETACH

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
index e74882f..7515e62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1260,6 +1260,9 @@ struct task_struct {
 /* task state */
 	int exit_state;
 	int exit_code, exit_signal;
+	uint8_t detach_code;
+	uint8_t detaching;
+	int pr_detached:1;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
 	/* ??? */
 	unsigned int personality;
diff --git a/kernel/exit.c b/kernel/exit.c
index f9a45eb..d1de141 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -761,6 +761,9 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	if (same_thread_group(p->real_parent, father))
 		return;
 
+	/* detached process re-attaches to new parent */
+	p->pr_detached = 0;
+
 	/* We don't want people slaying init.  */
 	p->exit_signal = SIGCHLD;
 
@@ -1309,8 +1312,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
-	status = (p->signal->flags & SIGNAL_GROUP_EXIT)
-		? p->signal->group_exit_code : p->exit_code;
+	if (!p->pr_detached)
+		status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+			? p->signal->group_exit_code : p->exit_code;
+	else
+		status = p->detach_code << 8;
 	if (!retval && wo->wo_stat)
 		retval = put_user(status, wo->wo_stat);
 
@@ -1322,7 +1328,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	if (!retval && infop) {
 		int why;
 
-		if ((status & 0x7f) == 0) {
+		if (p->pr_detached) {
+			why = CLD_DETACHED;
+			status >>= 8;
+		} else if ((status & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status >>= 8;
 		} else {
@@ -1472,9 +1481,6 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 	if (!unlikely(wo->wo_flags & WCONTINUED))
 		return 0;
 
-	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
-		return 0;
-
 	spin_lock_irq(&p->sighand->siglock);
 	/* Re-check with the lock held.  */
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED)) {
@@ -1507,6 +1513,45 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
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
+			p->detach_code);
+	}
+
+	dt = xchg(&p->detaching, 0);
+	if (!dt)
+		return 0;
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
+	if (wo->wo_stat)
+		retval = put_user(p->detach_code << 8, wo->wo_stat);
+
+	if (!retval) {
+		pid = task_pid_vnr(p);
+		uid = __task_cred(p)->uid;
+		retval = wait_noreap_copyout(wo, p, pid, uid, CLD_DETACHED,
+			p->detach_code);
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
@@ -1555,6 +1600,14 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
 		return wait_task_zombie(wo, p);
 
+	if (unlikely(p->pr_detached)) {
+		if (p->detaching)
+			return wait_task_detached(wo, p);
+		/* pr_detached tasks are hidden from parent */
+		if (!ptrace)
+			return 0;
+	}
+
 	/*
 	 * It's stopped or running now, so it might
 	 * later continue, exit, or stop again.
@@ -1564,7 +1617,10 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (task_stopped_code(p, ptrace))
 		return wait_task_stopped(wo, ptrace, p);
 
-	return wait_task_continued(wo, p);
+	if (p->signal->flags & SIGNAL_STOP_CONTINUED)
+		return wait_task_continued(wo, p);
+
+	return 0;
 }
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 25e4291..d3c3991 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1233,6 +1233,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->exit_signal = (clone_flags & CLONE_THREAD) ? -1 : (clone_flags & CSIGNAL);
 	p->pdeath_signal = 0;
 	p->exit_state = 0;
+	p->pr_detached = 0;
 
 	/*
 	 * Ok, make it visible to the rest of the system.
diff --git a/kernel/signal.c b/kernel/signal.c
index 3e71e27..5c64bd9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1518,6 +1518,15 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 {
 	int sicode, sistatus, ret;
 
+	if (tsk->pr_detached) {
+		/* if parent did not read detach code, promote to zombie */
+		if (tsk->detaching)
+			return sig;
+		/* otherwise terminate */
+		tsk->exit_signal = -1;
+		return DEATH_REAP;
+	}
+
 	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
@@ -1547,6 +1556,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	if (task_ptrace(tsk))
 		parent = tsk->parent;
 	else {
+		/* pr_detached task is hidden from real_parent */
+		if (tsk->pr_detached)
+			return;
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
 	}
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..acf2f69 100644
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
@@ -1736,6 +1737,39 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_DETACH: {
+			int notif;
+			struct task_struct *leader;
+			struct pid_namespace *pid_ns;
+			unsigned long flags = arg3;
+			error = -EPERM;
+			if (arg2 & ~0x7f)
+				break;
+			/* reserve flags for the future extensions */
+			if (flags)
+				break;
+			write_lock_irq(&tasklist_lock);
+			pid_ns = task_active_pid_ns(me);
+			leader = me->group_leader;
+			if (leader->pr_detached)
+				goto unlock;
+			/* not detaching from init */
+			if (same_thread_group(leader->real_parent,
+					pid_ns->child_reaper))
+				goto unlock;
+			leader->detach_code = arg2;
+			notif = do_signal_parent(leader, leader->exit_signal,
+					CLD_DETACHED, arg2);
+			if (notif != DEATH_REAP)
+				leader->detaching = 1;
+			else
+				leader->detaching = 0;
+			leader->pr_detached = 1;
+			error = 0;
+unlock:
+			write_unlock_irq(&tasklist_lock);
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;

--------------010603060406030308010506--
