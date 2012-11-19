Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KSPN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:13:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50441 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2KSPNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:13:21 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Date: Mon, 19 Nov 2012 07:12:33 -0800
Message-Id: <1353337961-12962-8-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/cII4Fq63k+QistiYoFvDbBwr6T3dkJdQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0529]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 08/16] userns: Kill task_user_ns
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The task_user_ns function hides the fact that it is getting the user
namespace from struct cred on the task.  struct cred may go away as
soon as the rcu lock is released.  This leads to a race where we
can dereference a stale user namespace pointer.

To make it obvious a struct cred is involved kill task_user_ns.

To kill the race modify the users of task_user_ns to only
reference the user namespace while the rcu lock is held.

Cc: Kees Cook <keescook@chromium.org>
Cc: James Morris <james.l.morris@oracle.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/cred.h     |    2 --
 kernel/ptrace.c          |   10 ++++++++--
 kernel/sched/core.c      |   10 ++++++++--
 security/yama/yama_lsm.c |   12 +++++++++---
 4 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index ebbed2c..856d262 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -357,10 +357,8 @@ static inline void put_cred(const struct cred *_cred)
 extern struct user_namespace init_user_ns;
 #ifdef CONFIG_USER_NS
 #define current_user_ns()	(current_cred_xxx(user_ns))
-#define task_user_ns(task)	(task_cred_xxx((task), user_ns))
 #else
 #define current_user_ns()	(&init_user_ns)
-#define task_user_ns(task)	(&init_user_ns)
 #endif
 
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1f5e55d..7b09b88 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -215,8 +215,12 @@ ok:
 	smp_rmb();
 	if (task->mm)
 		dumpable = get_dumpable(task->mm);
-	if (!dumpable  && !ptrace_has_cap(task_user_ns(task), mode))
+	rcu_read_lock();
+	if (!dumpable && !ptrace_has_cap(__task_cred(task)->user_ns, mode)) {
+		rcu_read_unlock();
 		return -EPERM;
+	}
+	rcu_read_unlock();
 
 	return security_ptrace_access_check(task, mode);
 }
@@ -280,8 +284,10 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	if (seize)
 		flags |= PT_SEIZED;
-	if (ns_capable(task_user_ns(task), CAP_SYS_PTRACE))
+	rcu_read_lock();
+	if (ns_capable(__task_cred(task)->user_ns, CAP_SYS_PTRACE))
 		flags |= PT_PTRACE_CAP;
+	rcu_read_unlock();
 	task->ptrace = flags;
 
 	__ptrace_link(task, current);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d8927f..2f5eb18 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4029,8 +4029,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
 		goto out_free_cpus_allowed;
 	}
 	retval = -EPERM;
-	if (!check_same_owner(p) && !ns_capable(task_user_ns(p), CAP_SYS_NICE))
-		goto out_unlock;
+	if (!check_same_owner(p)) {
+		rcu_read_lock();
+		if (!ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE)) {
+			rcu_read_unlock();
+			goto out_unlock;
+		}
+		rcu_read_unlock();
+	}
 
 	retval = security_task_setscheduler(p);
 	if (retval)
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index b4c2984..0e72239 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -262,14 +262,18 @@ int yama_ptrace_access_check(struct task_struct *child,
 			/* No additional restrictions. */
 			break;
 		case YAMA_SCOPE_RELATIONAL:
+			rcu_read_lock();
 			if (!task_is_descendant(current, child) &&
 			    !ptracer_exception_found(current, child) &&
-			    !ns_capable(task_user_ns(child), CAP_SYS_PTRACE))
+			    !ns_capable(__task_cred(child)->user_ns, CAP_SYS_PTRACE))
 				rc = -EPERM;
+			rcu_read_unlock();
 			break;
 		case YAMA_SCOPE_CAPABILITY:
-			if (!ns_capable(task_user_ns(child), CAP_SYS_PTRACE))
+			rcu_read_lock();
+			if (!ns_capable(__task_cred(child)->user_ns, CAP_SYS_PTRACE))
 				rc = -EPERM;
+			rcu_read_unlock();
 			break;
 		case YAMA_SCOPE_NO_ATTACH:
 		default:
@@ -307,8 +311,10 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	/* Only disallow PTRACE_TRACEME on more aggressive settings. */
 	switch (ptrace_scope) {
 	case YAMA_SCOPE_CAPABILITY:
-		if (!ns_capable(task_user_ns(parent), CAP_SYS_PTRACE))
+		rcu_read_lock();
+		if (!ns_capable(__task_cred(parent)->user_ns, CAP_SYS_PTRACE))
 			rc = -EPERM;
+		rcu_read_unlock();
 		break;
 	case YAMA_SCOPE_NO_ATTACH:
 		rc = -EPERM;
-- 
1.7.5.4

