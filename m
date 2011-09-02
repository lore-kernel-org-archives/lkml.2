Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1IBT4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:56:52 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39505 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755282Ab1IBT4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:56:00 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH 15/15] make kernel/signal.c user ns safe (v2)
Date: Fri,  2 Sep 2011 19:56:40 +0000
Message-Id: <1314993400-6910-18-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge Hallyn <serge.hallyn@canonical.com>

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 kernel/signal.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 291c970..c07b970 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -27,6 +27,7 @@
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
+#include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/signal.h>
@@ -1073,7 +1074,8 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 			q->info.si_code = SI_USER;
 			q->info.si_pid = task_tgid_nr_ns(current,
 							task_active_pid_ns(t));
-			q->info.si_uid = current_uid();
+			q->info.si_uid = user_ns_map_uid(task_cred_xxx(t, user_ns),
+					current_cred(), current_uid());
 			break;
 		case (unsigned long) SEND_SIG_PRIV:
 			q->info.si_signo = sig;
@@ -1363,6 +1365,11 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		goto out_unlock;
 	}
 	pcred = __task_cred(p);
+	/*
+	 * this is called (only) from drivers/usb/core/devio.c.
+	 * Do we need to add user_ns to urb and usb_device, so
+	 * we can pass them in here?
+	 */
 	if (si_fromuser(info) &&
 	    euid != pcred->suid && euid != pcred->uid &&
 	    uid  != pcred->suid && uid  != pcred->uid) {
@@ -1618,7 +1625,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	info.si_uid = user_ns_map_uid(task_cred_xxx(tsk->parent, user_ns),
+				      __task_cred(tsk), __task_cred(tsk)->uid);
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
@@ -1688,6 +1696,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	unsigned long flags;
 	struct task_struct *parent;
 	struct sighand_struct *sighand;
+	const struct cred *cred;
 
 	if (for_ptracer) {
 		parent = tsk->parent;
@@ -1703,7 +1712,9 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	 */
 	rcu_read_lock();
 	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
-	info.si_uid = __task_cred(tsk)->uid;
+	cred = __task_cred(tsk);
+	info.si_uid = user_ns_map_uid(task_cred_xxx(parent, user_ns),
+				cred, cred->uid);
 	rcu_read_unlock();
 
 	info.si_utime = cputime_to_clock_t(tsk->utime);
@@ -2122,7 +2133,10 @@ static int ptrace_signal(int signr, siginfo_t *info,
 		info->si_errno = 0;
 		info->si_code = SI_USER;
 		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		/* we can cache cred if this performs poorly */
+		info->si_uid = user_ns_map_uid(current_user_ns(),
+			__task_cred(current->parent),
+			task_uid(current->parent));
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
@@ -2552,6 +2566,10 @@ SYSCALL_DEFINE2(rt_sigpending, sigset_t __user *, set, size_t, sigsetsize)
 
 #ifndef HAVE_ARCH_COPY_SIGINFO_TO_USER
 
+/*
+ * send_signal has converted the sender's uid to the receiver
+ * task user namespace, so no need to convert here
+ */
 int copy_siginfo_to_user(siginfo_t __user *to, siginfo_t *from)
 {
 	int err;
-- 
1.7.5.4

