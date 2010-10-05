Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab0JEBzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:55:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51647 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0JEBzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:55:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: James Morris <jmorris@namei.org>
Subject: Re: [patch 1/2] security: add const to security_task_setscheduler()
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
        linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1010050929340.28702@tundra.namei.org>
References: <201010012119.o91LJMwQ021365@imap1.linux-foundation.org> <alpine.LRH.2.00.1010050929340.28702@tundra.namei.org>
Message-Id: <20101005095725.28C0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Oct 2010 10:55:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 1 Oct 2010, akpm@linux-foundation.org wrote:
> 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > All security modules shouldn't change sched_param parameter of
> > security_task_setscheduler().  This is not only meaningless, but also make
> > harmful result if caller pass static variable.
> 
> Nobody's using this parameter, so probably best to just get rid of it in 
> the LSM API.

To be honest, I don't like completely remove this parameter because
security_task_setscheduler(struct task_struct *p) seems not so useful.

But, you are maintainer. OK, I've reworked this as you requested :-)

Thanks.



>From 10bfd5279260f650d489a85c3cca7d35f0529dbb Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 15 Oct 2010 04:21:18 +0900
Subject: [PATCH] security: remove unused parameter from security_task_setscheduler()

All security modules shouldn't change sched_param parameter of
security_task_setscheduler().  This is not only meaningless, but also
make a harmful result if caller pass a static variable.

This patch remove policy and sched_param parameter from
security_task_setscheduler() becuase none of security module is
using it.

Cc: James Morris <jmorris@namei.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 arch/mips/kernel/mips-mt-fpaff.c |    2 +-
 include/linux/security.h         |   14 +++++---------
 kernel/cpuset.c                  |    4 ++--
 kernel/sched.c                   |    4 ++--
 security/commoncap.c             |    5 +----
 security/security.c              |    5 ++---
 security/selinux/hooks.c         |    4 ++--
 security/smack/smack_lsm.c       |    5 ++---
 8 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index 2340f11..9a526ba 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -103,7 +103,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
-	retval = security_task_setscheduler(p, 0, NULL);
+	retval = security_task_setscheduler(p)
 	if (retval)
 		goto out_unlock;
 
diff --git a/include/linux/security.h b/include/linux/security.h
index a22219a..294a0b2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -74,7 +74,7 @@ extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
-extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setscheduler(struct task_struct *p);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_syslog(int type, bool from_file);
@@ -1501,8 +1501,7 @@ struct security_operations {
 	int (*task_getioprio) (struct task_struct *p);
 	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
 			struct rlimit *new_rlim);
-	int (*task_setscheduler) (struct task_struct *p, int policy,
-				  struct sched_param *lp);
+	int (*task_setscheduler) (struct task_struct *p);
 	int (*task_getscheduler) (struct task_struct *p);
 	int (*task_movememory) (struct task_struct *p);
 	int (*task_kill) (struct task_struct *p,
@@ -1752,8 +1751,7 @@ int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 		struct rlimit *new_rlim);
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp);
+int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
@@ -2320,11 +2318,9 @@ static inline int security_task_setrlimit(struct task_struct *p,
 	return 0;
 }
 
-static inline int security_task_setscheduler(struct task_struct *p,
-					     int policy,
-					     struct sched_param *lp)
+static inline int security_task_setscheduler(struct task_struct *p)
 {
-	return cap_task_setscheduler(p, policy, lp);
+	return cap_task_setscheduler(p);
 }
 
 static inline int security_task_getscheduler(struct task_struct *p)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b23c097..51b143e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1397,7 +1397,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	if (tsk->flags & PF_THREAD_BOUND)
 		return -EINVAL;
 
-	ret = security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk);
 	if (ret)
 		return ret;
 	if (threadgroup) {
@@ -1405,7 +1405,7 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			ret = security_task_setscheduler(c, 0, NULL);
+			ret = security_task_setscheduler(c);
 			if (ret) {
 				rcu_read_unlock();
 				return ret;
diff --git a/kernel/sched.c b/kernel/sched.c
index dc85ceb..df6579d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4645,7 +4645,7 @@ recheck:
 	}
 
 	if (user) {
-		retval = security_task_setscheduler(p, policy, param);
+		retval = security_task_setscheduler(p);
 		if (retval)
 			return retval;
 	}
@@ -4887,7 +4887,7 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
-	retval = security_task_setscheduler(p, 0, NULL);
+	retval = security_task_setscheduler(p);
 	if (retval)
 		goto out_unlock;
 
diff --git a/security/commoncap.c b/security/commoncap.c
index 9d172e6..5e632b4 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -719,14 +719,11 @@ static int cap_safe_nice(struct task_struct *p)
 /**
  * cap_task_setscheduler - Detemine if scheduler policy change is permitted
  * @p: The task to affect
- * @policy: The policy to effect
- * @lp: The parameters to the scheduling policy
  *
  * Detemine if the requested scheduler policy change is permitted for the
  * specified task, returning 0 if permission is granted, -ve if denied.
  */
-int cap_task_setscheduler(struct task_struct *p, int policy,
-			   struct sched_param *lp)
+int cap_task_setscheduler(struct task_struct *p)
 {
 	return cap_safe_nice(p);
 }
diff --git a/security/security.c b/security/security.c
index c53949f..34a3f2c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -786,10 +786,9 @@ int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 	return security_ops->task_setrlimit(p, resource, new_rlim);
 }
 
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp)
+int security_task_setscheduler(struct task_struct *p)
 {
-	return security_ops->task_setscheduler(p, policy, lp);
+	return security_ops->task_setscheduler(p);
 }
 
 int security_task_getscheduler(struct task_struct *p)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4796ddd..db2b331 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3354,11 +3354,11 @@ static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
 	return 0;
 }
 
-static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
+static int selinux_task_setscheduler(struct task_struct *p)
 {
 	int rc;
 
-	rc = cap_task_setscheduler(p, policy, lp);
+	rc = cap_task_setscheduler(p);
 	if (rc)
 		return rc;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c448d57..174aec4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1281,12 +1281,11 @@ static int smack_task_getioprio(struct task_struct *p)
  *
  * Return 0 if read access is permitted
  */
-static int smack_task_setscheduler(struct task_struct *p, int policy,
-				   struct sched_param *lp)
+static int smack_task_setscheduler(struct task_struct *p)
 {
 	int rc;
 
-	rc = cap_task_setscheduler(p, policy, lp);
+	rc = cap_task_setscheduler(p);
 	if (rc == 0)
 		rc = smk_curacc_on_task(p, MAY_WRITE);
 	return rc;
-- 
1.6.5.2



