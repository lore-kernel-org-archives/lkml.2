Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0LQP1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:27:19 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:51221
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753006Ab0LQP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:27:17 -0500
Date: Fri, 17 Dec 2010 15:27:37 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
Subject: [RFC 5/5] user namespaces: Allow ptrace from non-init user
 namespaces
Message-ID: <20101217152737.GE11162@mail.hallyn.com>
References: <20101217152246.GA8221@mail.hallyn.com>
 <20101217152458.GA11162@mail.hallyn.com>
 <20101217152547.GB11162@mail.hallyn.com>
 <20101217152625.GC11162@mail.hallyn.com>
 <20101217152659.GD11162@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217152659.GD11162@mail.hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace is allowed to tasks in the same user namespace according to
the usual rules (i.e. the same rules as for two tasks in the init
user namespace).  ptrace is also allowed to a user namespace to
which the current task the has CAP_SYS_PTRACE capability.

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
---
 include/linux/capability.h |    2 ++
 kernel/ptrace.c            |   40 ++++++++++++++++++++++++++++------------
 security/commoncap.c       |   26 +++++++++++++++++++++-----
 3 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index cc3e976..777a166 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -543,6 +543,8 @@ extern const kernel_cap_t __cap_init_eff_set;
  */
 #define has_capability(t, cap) (security_real_capable((t), &init_user_ns, (cap)) == 0)
 
+#define has_ns_capability(t, ns, cap) (security_real_capable((t), (ns), (cap)) == 0)
+
 /**
  * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
  * @t: The task in question
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 99bbaa3..aed24eb 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -116,6 +116,19 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
+static inline int may_ptrace_ns(struct task_struct *t)
+{
+	struct user_namespace *ns;
+	int ret;
+
+	rcu_read_lock();
+	ns = task_cred_xxx(t, user)->user_ns;
+	ret = ns_capable(ns, CAP_SYS_PTRACE);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	const struct cred *cred = current_cred(), *tcred;
@@ -134,21 +147,24 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 		return 0;
 	rcu_read_lock();
 	tcred = __task_cred(task);
-	if ((cred->uid != tcred->euid ||
-	     cred->uid != tcred->suid ||
-	     cred->uid != tcred->uid  ||
-	     cred->gid != tcred->egid ||
-	     cred->gid != tcred->sgid ||
-	     cred->gid != tcred->gid) &&
-	    !capable(CAP_SYS_PTRACE)) {
-		rcu_read_unlock();
-		return -EPERM;
-	}
+	if (cred->user->user_ns == tcred->user->user_ns &&
+	    (cred->uid == tcred->euid ||
+	     cred->uid == tcred->suid ||
+	     cred->uid == tcred->uid  ||
+	     cred->gid == tcred->egid ||
+	     cred->gid == tcred->sgid ||
+	     cred->gid == tcred->gid))
+		goto ok;
+	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+		goto ok;
+	rcu_read_unlock();
+	return -EPERM;
+ok:
 	rcu_read_unlock();
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable && !capable(CAP_SYS_PTRACE))
+	if (!dumpable && !may_ptrace_ns(task))
 		return -EPERM;
 
 	return security_ptrace_access_check(task, mode);
@@ -198,7 +214,7 @@ int ptrace_attach(struct task_struct *task)
 		goto unlock_tasklist;
 
 	task->ptrace = PT_PTRACED;
-	if (capable(CAP_SYS_PTRACE))
+	if (may_ptrace_ns(task))
 		task->ptrace |= PT_PTRACE_CAP;
 
 	__ptrace_link(task, current);
diff --git a/security/commoncap.c b/security/commoncap.c
index 9d910e6..bd0bcc6 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -136,12 +136,20 @@ int cap_settime(struct timespec *ts, struct timezone *tz)
 int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 {
 	int ret = 0;
+	struct cred *cred, *tcred;
 
 	rcu_read_lock();
-	if (!cap_issubset(__task_cred(child)->cap_permitted,
-			  current_cred()->cap_permitted) &&
+	cred = current_cred();
+	tcred = __task_cred(child);
+	if (cred->user->user_ns != tcred->user->user_ns) {
+		if (!ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
+			ret = -EPERM;
+		goto out;
+	}
+	if (!cap_issubset(tcred->cap_permitted, cred->cap_permitted) &&
 	    !capable(CAP_SYS_PTRACE))
 		ret = -EPERM;
+out:
 	rcu_read_unlock();
 	return ret;
 }
@@ -156,12 +164,20 @@ int cap_ptrace_access_check(struct task_struct *child, unsigned int mode)
 int cap_ptrace_traceme(struct task_struct *parent)
 {
 	int ret = 0;
+	struct cred *cred, *tcred;
 
 	rcu_read_lock();
-	if (!cap_issubset(current_cred()->cap_permitted,
-			  __task_cred(parent)->cap_permitted) &&
-	    !has_capability(parent, CAP_SYS_PTRACE))
+	cred = __task_cred(parent);
+	tcred = current_cred();
+	if (cred->user->user_ns != tcred->user->user_ns) {
+		if (!has_ns_capability(parent, tcred->user->user_ns, CAP_SYS_PTRACE))
+			ret = -EPERM;
+		goto out;
+	}
+	if (!cap_issubset(tcred->cap_permitted, cred->cap_permitted) &&
+	    !has_ns_capability(parent, tcred->user->user_ns, CAP_SYS_PTRACE))
 		ret = -EPERM;
+out:
 	rcu_read_unlock();
 	return ret;
 }
-- 
1.7.0.4

