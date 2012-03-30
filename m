Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab2C3WPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:15:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:41573 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936522Ab2C3WPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:15:14 -0400
Date: Sat, 31 Mar 2012 00:15:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] Core locking updates for 3.4
Message-ID: <alpine.LFD.2.02.1203310013330.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-locking-for-linus

Thanks,

	tglx

------------------>
Kees Cook (2):
      futex: Do not leak robust list to unprivileged process
      futex: Mark get_robust_list as deprecated


 Documentation/feature-removal-schedule.txt |   10 +++++++
 kernel/futex.c                             |   38 +++++++++++-----------------
 kernel/futex_compat.c                      |   38 +++++++++++-----------------
 3 files changed, 40 insertions(+), 46 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..c1be806 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -529,3 +529,13 @@ When:	3.5
 Why:	The old kmap_atomic() with two arguments is deprecated, we only
 	keep it for backward compatibility for few cycles and then drop it.
 Who:	Cong Wang <amwang@redhat.com>
+
+----------------------------
+
+What:	get_robust_list syscall
+When:	2013
+Why:	There appear to be no production users of the get_robust_list syscall,
+	and it runs the risk of leaking address locations, allowing the bypass
+	of ASLR. It was only ever intended for debugging, so it should be
+	removed.
+Who:	Kees Cook <keescook@chromium.org>
diff --git a/kernel/futex.c b/kernel/futex.c
index 72efa1e..e2b0fb9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -59,6 +59,7 @@
 #include <linux/magic.h>
 #include <linux/pid.h>
 #include <linux/nsproxy.h>
+#include <linux/ptrace.h>
 
 #include <asm/futex.h>
 
@@ -2443,40 +2444,31 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
 {
 	struct robust_list_head __user *head;
 	unsigned long ret;
-	const struct cred *cred = current_cred(), *pcred;
+	struct task_struct *p;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
+	rcu_read_lock();
+
+	ret = -ESRCH;
 	if (!pid)
-		head = current->robust_list;
+		p = current;
 	else {
-		struct task_struct *p;
-
-		ret = -ESRCH;
-		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
-		ret = -EPERM;
-		pcred = __task_cred(p);
-		/* If victim is in different user_ns, then uids are not
-		   comparable, so we must have CAP_SYS_PTRACE */
-		if (cred->user->user_ns != pcred->user->user_ns) {
-			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-				goto err_unlock;
-			goto ok;
-		}
-		/* If victim is in same user_ns, then uids are comparable */
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid &&
-		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-			goto err_unlock;
-ok:
-		head = p->robust_list;
-		rcu_read_unlock();
 	}
 
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ))
+		goto err_unlock;
+
+	head = p->robust_list;
+	rcu_read_unlock();
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(head, head_ptr);
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 5f9e689..83e368b 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/nsproxy.h>
 #include <linux/futex.h>
+#include <linux/ptrace.h>
 
 #include <asm/uaccess.h>
 
@@ -136,40 +137,31 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 {
 	struct compat_robust_list_head __user *head;
 	unsigned long ret;
-	const struct cred *cred = current_cred(), *pcred;
+	struct task_struct *p;
 
 	if (!futex_cmpxchg_enabled)
 		return -ENOSYS;
 
+	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
+
+	rcu_read_lock();
+
+	ret = -ESRCH;
 	if (!pid)
-		head = current->compat_robust_list;
+		p = current;
 	else {
-		struct task_struct *p;
-
-		ret = -ESRCH;
-		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
-		ret = -EPERM;
-		pcred = __task_cred(p);
-		/* If victim is in different user_ns, then uids are not
-		   comparable, so we must have CAP_SYS_PTRACE */
-		if (cred->user->user_ns != pcred->user->user_ns) {
-			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-				goto err_unlock;
-			goto ok;
-		}
-		/* If victim is in same user_ns, then uids are comparable */
-		if (cred->euid != pcred->euid &&
-		    cred->euid != pcred->uid &&
-		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
-			goto err_unlock;
-ok:
-		head = p->compat_robust_list;
-		rcu_read_unlock();
 	}
 
+	ret = -EPERM;
+	if (!ptrace_may_access(p, PTRACE_MODE_READ))
+		goto err_unlock;
+
+	head = p->compat_robust_list;
+	rcu_read_unlock();
+
 	if (put_user(sizeof(*head), len_ptr))
 		return -EFAULT;
 	return put_user(ptr_to_compat(head), head_ptr);
