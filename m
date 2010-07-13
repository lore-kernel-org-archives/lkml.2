Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0GMRdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:33:42 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49046 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0GMRdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:33:40 -0400
Date: Tue, 13 Jul 2010 10:33:39 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Yama: turn process ancestry check into function
Message-ID: <20100713173339.GA6104@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the ancestry check by separating it out into its own
function, which makes the code a bit more readable.  Additionally, it
now checks for and uses the thread group leader since otherwise we may
end up missing potential matches on attaches to threads.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 security/yama/yama_lsm.c |   55 ++++++++++++++++++++++++++++++++-------------
 1 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 72929d2..3b76386 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -21,6 +21,40 @@ static int protected_sticky_symlinks = 1;
 static int protected_nonaccess_hardlinks = 1;
 
 /**
+ * task_is_descendant - walk up a process family tree looking for a match
+ * @parent: the process to compare against while walking up from child
+ * @child: the process to start from while looking upwards for parent
+ *
+ * Returns 1 if child is a descendant of parent, 0 if not.
+ */
+static int task_is_descendant(struct task_struct *parent,
+			      struct task_struct *child)
+{
+	int rc = 0;
+	struct task_struct *walker = child;
+
+	if (!parent || !child)
+		return 0;
+
+	rcu_read_lock();
+	read_lock(&tasklist_lock);
+	while (walker->pid > 0) {
+		if (!thread_group_leader(walker))
+			walker = walker->group_leader;
+		if (walker == parent) {
+			rc = 1;
+			break;
+		}
+		walker = walker->real_parent;
+	}
+	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
+
+	return rc;
+}
+
+
+/**
  * yama_ptrace_access_check - validate PTRACE_ATTACH calls
  * @child: child task pointer
  * @mode: ptrace attach mode
@@ -37,22 +71,11 @@ static int yama_ptrace_access_check(struct task_struct *child,
 		return rc;
 
 	/* require ptrace target be a child of ptracer on attach */
-	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
-	    !capable(CAP_SYS_PTRACE)) {
-		struct task_struct *walker = child;
-
-		rcu_read_lock();
-		read_lock(&tasklist_lock);
-		while (walker->pid > 0) {
-			if (walker == current)
-				break;
-			walker = walker->real_parent;
-		}
-		if (walker->pid == 0)
-			rc = -EPERM;
-		read_unlock(&tasklist_lock);
-		rcu_read_unlock();
-	}
+	if (mode == PTRACE_MODE_ATTACH &&
+	    ptrace_scope &&
+	    !task_is_descendant(current, child) &&
+	    !capable(CAP_SYS_PTRACE))
+		rc = -EPERM;
 
 	if (rc) {
 		char name[sizeof(current->comm)];
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
