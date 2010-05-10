Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab0EJSBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 14:01:45 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:37106 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab0EJSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 14:01:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v3 01/11] rlimits: security, add task_struct to setrlimit
Date: Mon, 10 May 2010 20:00:41 +0200
Message-Id: <1273514451-28894-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Andrew, could you pick them up, please?

In this version I fixed up commit logs and added rationale in 10/11.

--

Add task_struct to task_setrlimit of security_operations to be able to set
rlimit of different task than current.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Eric Paris <eparis@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---
 include/linux/security.h |    9 ++++++---
 kernel/sys.c             |    2 +-
 security/capability.c    |    3 ++-
 security/security.c      |    5 +++--
 security/selinux/hooks.c |    7 ++++---
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 24fc295..2c6a756 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1502,7 +1502,8 @@ struct security_operations {
 	int (*task_setnice) (struct task_struct *p, int nice);
 	int (*task_setioprio) (struct task_struct *p, int ioprio);
 	int (*task_getioprio) (struct task_struct *p);
-	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
+	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
+			struct rlimit *new_rlim);
 	int (*task_setscheduler) (struct task_struct *p, int policy,
 				  struct sched_param *lp);
 	int (*task_getscheduler) (struct task_struct *p);
@@ -1752,7 +1753,8 @@ void security_task_getsecid(struct task_struct *p, u32 *secid);
 int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
-int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
+int security_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim);
 int security_task_setscheduler(struct task_struct *p,
 				int policy, struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
@@ -2314,7 +2316,8 @@ static inline int security_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static inline int security_task_setrlimit(unsigned int resource,
+static inline int security_task_setrlimit(struct task_struct *p,
+					  unsigned int resource,
 					  struct rlimit *new_rlim)
 {
 	return 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index e83ddbb..1ba4522 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1290,7 +1290,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
-	retval = security_task_setrlimit(resource, &new_rlim);
+	retval = security_task_setrlimit(current, resource, &new_rlim);
 	if (retval)
 		return retval;
 
diff --git a/security/capability.c b/security/capability.c
index 7f093d5..33a16d6 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -412,7 +412,8 @@ static int cap_task_getioprio(struct task_struct *p)
 	return 0;
 }
 
-static int cap_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index a525e01..3ed1719 100644
--- a/security/security.c
+++ b/security/security.c
@@ -781,9 +781,10 @@ int security_task_getioprio(struct task_struct *p)
 	return security_ops->task_getioprio(p);
 }
 
-int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+int security_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	return security_ops->task_setrlimit(resource, new_rlim);
+	return security_ops->task_setrlimit(p, resource, new_rlim);
 }
 
 int security_task_setscheduler(struct task_struct *p,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ebee467..674992f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3393,16 +3393,17 @@ static int selinux_task_getioprio(struct task_struct *p)
 	return current_has_perm(p, PROCESS__GETSCHED);
 }
 
-static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
+static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
+		struct rlimit *new_rlim)
 {
-	struct rlimit *old_rlim = current->signal->rlim + resource;
+	struct rlimit *old_rlim = p->signal->rlim + resource;
 
 	/* Control the ability to change the hard limit (whether
 	   lowering or raising it), so that the hard limit can
 	   later be used as a safe reset point for the soft limit
 	   upon context transitions.  See selinux_bprm_committing_creds. */
 	if (old_rlim->rlim_max != new_rlim->rlim_max)
-		return current_has_perm(current, PROCESS__SETRLIMIT);
+		return current_has_perm(p, PROCESS__SETRLIMIT);
 
 	return 0;
 }
-- 
1.7.1


