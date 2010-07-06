Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0GFAuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:50:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33270 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab0GFAuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:50:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: James Morris <jmorris@namei.org>
Subject: [PATCH 1/2] security: add const to security_task_setscheduler()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
References: <20100702144941.8fa101c3.akpm@linux-foundation.org> <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
Message-Id: <20100706094913.CCD6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Jul 2010 09:50:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All security modules shouldn't change sched_param parameter of
security_task_setscheduler(). This is not only meaningless, but
also make harmful result if caller pass static variable.

This patch add const to it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/security.h   |    9 +++++----
 security/commoncap.c       |    2 +-
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    3 ++-
 security/smack/smack_lsm.c |    2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 5bcb395..07e94e5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -74,7 +74,8 @@ extern int cap_file_mmap(struct file *file, unsigned long reqprot,
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
-extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setscheduler(struct task_struct *p, int policy,
+				 const struct sched_param *lp);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_syslog(int type, bool from_file);
@@ -1501,7 +1502,7 @@ struct security_operations {
 	int (*task_getioprio) (struct task_struct *p);
 	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
 	int (*task_setscheduler) (struct task_struct *p, int policy,
-				  struct sched_param *lp);
+				  const struct sched_param *lp);
 	int (*task_getscheduler) (struct task_struct *p);
 	int (*task_movememory) (struct task_struct *p);
 	int (*task_kill) (struct task_struct *p,
@@ -1750,8 +1751,8 @@ int security_task_setnice(struct task_struct *p, int nice);
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
 int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp);
+int security_task_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
diff --git a/security/commoncap.c b/security/commoncap.c
index 4e01599..b74d460 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -726,7 +726,7 @@ static int cap_safe_nice(struct task_struct *p)
  * specified task, returning 0 if permission is granted, -ve if denied.
  */
 int cap_task_setscheduler(struct task_struct *p, int policy,
-			   struct sched_param *lp)
+			  const struct sched_param *lp)
 {
 	return cap_safe_nice(p);
 }
diff --git a/security/security.c b/security/security.c
index 7461b1b..6151322 100644
--- a/security/security.c
+++ b/security/security.c
@@ -785,8 +785,8 @@ int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
 	return security_ops->task_setrlimit(resource, new_rlim);
 }
 
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp)
+int security_task_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *lp)
 {
 	return security_ops->task_setscheduler(p, policy, lp);
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5c9f25b..dd136bd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3385,7 +3385,8 @@ static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim
 	return 0;
 }
 
-static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
+static int selinux_task_setscheduler(struct task_struct *p, int policy,
+				     const struct sched_param *lp)
 {
 	int rc;
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 07abc9c..c3336f1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1280,7 +1280,7 @@ static int smack_task_getioprio(struct task_struct *p)
  * Return 0 if read access is permitted
  */
 static int smack_task_setscheduler(struct task_struct *p, int policy,
-				   struct sched_param *lp)
+				   const struct sched_param *lp)
 {
 	int rc;
 
-- 
1.6.5.2



