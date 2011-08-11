Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1HKUZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:25:00 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:41736 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1HKUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:24:45 -0400
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: oleg@tv-sign.ru, bonbons@linux-vserver.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com
Subject: [PATCH 2/2] Notify container-init parent a 'reboot' occured
Date: Thu, 11 Aug 2011 22:24:01 +0200
Message-Id: <1313094241-3674-3-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the reboot syscall is called and the pid namespace where the calling
process belongs to is not from the init pidns, we send a SIGCHLD with CLD_REBOOTED
to the parent of this pid namespace.

Signed-off-by: Daniel Lezcano <daniel.lezcano@free.fr>
---
 include/asm-generic/siginfo.h |    3 ++-
 include/linux/sched.h         |    1 +
 kernel/signal.c               |   40 ++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                  |   20 ++++++++++++++++++--
 4 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 0dd4e87..9bff4a2 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -218,7 +218,8 @@ typedef struct siginfo {
 #define CLD_TRAPPED	(__SI_CHLD|4)	/* traced child has trapped */
 #define CLD_STOPPED	(__SI_CHLD|5)	/* child has stopped */
 #define CLD_CONTINUED	(__SI_CHLD|6)	/* stopped child has continued */
-#define NSIGCHLD	6
+#define CLD_REBOOTED    (__SI_CHLD|7)   /* process was killed by a reboot */
+#define NSIGCHLD	7
 
 /*
  * SIGPOLL si_codes
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 20b03bf..c62dc9e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2170,6 +2170,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern __must_check bool do_notify_parent(struct task_struct *, int);
+extern void do_notify_parent_cldreboot(struct task_struct *, int, char *);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..7d3d44c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1668,6 +1668,46 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	return autoreap;
 }
 
+void do_notify_parent_cldreboot(struct task_struct *tsk, int why, char *buffer)
+{
+	struct siginfo info = { };
+	struct task_struct *parent;
+	struct sighand_struct *sighand;
+	unsigned long flags;
+
+	if (tsk->ptrace)
+		parent = tsk->parent;
+	else {
+		tsk = tsk->group_leader;
+		parent = tsk->real_parent;
+	}
+
+	info.si_signo = SIGCHLD;
+	info.si_errno = 0;
+	info.si_status = why;
+
+	rcu_read_lock();
+	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
+	info.si_uid = __task_cred(tsk)->uid;
+	rcu_read_unlock();
+
+	info.si_utime = cputime_to_clock_t(tsk->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime);
+
+	info.si_code = CLD_REBOOTED;
+
+	sighand = parent->sighand;
+	spin_lock_irqsave(&sighand->siglock, flags);
+	if (sighand->action[SIGCHLD-1].sa.sa_handler != SIG_IGN &&
+	    sighand->action[SIGCHLD-1].sa.sa_flags & SA_CLDREBOOT)
+		__group_send_sig_info(SIGCHLD, &info, parent);
+	/*
+	 * Even if SIGCHLD is not generated, we must wake up wait4 calls.
+	 */
+	__wake_up_parent(tsk, parent);
+	spin_unlock_irqrestore(&sighand->siglock, flags);
+}
+
 /**
  * do_notify_parent_cldstop - notify parent of stopped/continued state change
  * @tsk: task reporting the state change
diff --git a/kernel/sys.c b/kernel/sys.c
index a101ba3..8f7a9ed 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -42,6 +42,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/sched.h>
 
 #include <linux/kmsg_dump.h>
 
@@ -411,6 +412,13 @@ void kernel_power_off(void)
 }
 EXPORT_SYMBOL_GPL(kernel_power_off);
 
+static void pid_namespace_reboot(struct pid_namespace *pid_ns,
+				int cmd, char *buffer)
+{
+	struct task_struct *tsk = pid_ns->child_reaper;
+	do_notify_parent_cldreboot(tsk, cmd, buffer);
+}
+
 static DEFINE_MUTEX(reboot_mutex);
 
 /*
@@ -426,10 +434,18 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 {
 	char buffer[256];
 	int ret = 0;
+	struct pid_namespace *pid_ns = current->nsproxy->pid_ns;
+
+        /* We only trust the superuser with rebooting the system. */
+	if (!capable(CAP_SYS_BOOT)) {
+		/* If we are not in the initial pid namespace, we send a signal
+		 * to the parent of this init pid namespace, notifying a shutdown
+		 * occured */
+		if (pid_ns != &init_pid_ns)
+			pid_namespace_reboot(pid_ns, cmd, buffer);
 
-	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
 		return -EPERM;
+	}
 
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
-- 
1.7.4.1

