Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1DTNO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:14:56 -0400
Received: from mail.aknet.ru ([78.158.192.28]:41178 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab1DTNOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:14:45 -0400
Message-ID: <4DAEDC3F.5010208@aknet.ru>
Date: Wed, 20 Apr 2011 17:14:39 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
References: <20110224132906.GA15733@redhat.com>	<4D6675B0.2010700@aknet.ru>	<20110224153221.GA22770@redhat.com>	<4D94A788.1050806@aknet.ru>	<20110331170244.GA13271@redhat.com>	<4D99D6E6.4070008@aknet.ru>	<20110404160351.GA23655@redhat.com>	<4D9A24A0.5050105@aknet.ru>	<20110405151549.GB17490@redhat.com>	<4D9B4265.6080403@aknet.ru>	<20110405164557.GA23248@redhat.com>	<4DADA22A.1010205@aknet.ru>	<20110419155830.7ad33312@lxorguk.ukuu.org.uk>	<4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------070007000708080007020202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070007000708080007020202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attached patch implements the PR_DETACH prctl
command. It detaches the entire process group from
its parent, allowing the parent to still read the detach
code with normal wait().
Can be used to daemonize process with threads.

--------------070007000708080007020202
Content-Type: text/plain;
 name="pr_detach5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pr_detach5.diff"

commit fede2db736225c61f3b60031e1b967b622e532af
Author: Stas <stas@stas.(none)>
Date:   Wed Apr 20 17:04:50 2011 +0400

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
index f9a45eb..8dafa02 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -751,6 +751,7 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
 	list_move_tail(&p->sibling, &p->real_parent->children);
+	p->pr_detached = 0;
 
 	if (task_detached(p))
 		return;
@@ -1309,8 +1310,11 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 
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
 
@@ -1322,7 +1326,10 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
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
@@ -1507,6 +1514,45 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
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
@@ -1555,6 +1601,12 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 	if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
 		return wait_task_zombie(wo, p);
 
+	if (p->pr_detached) {
+		if (p->detaching)
+			return wait_task_detached(wo, p);
+		return 0;
+	}
+
 	/*
 	 * It's stopped or running now, so it might
 	 * later continue, exit, or stop again.
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
index 3e71e27..125a3c0 100644
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
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..5b6a5ea 100644
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
@@ -1736,6 +1737,35 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_DETACH: {
+			int notif;
+			struct task_struct *leader;
+			struct pid_namespace *pid_ns;
+			error = -EPERM;
+			if (arg2 & ~0x7f)
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

--------------070007000708080007020202--
