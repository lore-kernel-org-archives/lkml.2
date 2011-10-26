Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab1JZX7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:59:33 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33059 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1JZX7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:59:04 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 19:59:03 EDT
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 3/3] security: Yama: add ptrace relationship tracking interface
Date: Wed, 26 Oct 2011 16:49:16 -0700
Message-Id: <1319672956-17114-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319672956-17114-1-git-send-email-keescook@chromium.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some application suites have external crash handlers that depend
on being able to use ptrace to generate crash reports (KDE, Wine,
Chromium, Firefox, etc). Since the inferior process has a defined
application-specific relationship with the debugger, allow the inferior
to express that relationship by declaring who can call PTRACE_ATTACH
against it. The inferior can use prctl() with PR_SET_PTRACER to allow a
specific PID and its descendants to perform the ptrace instead of only
a direct ancestor.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v5:
 - Use _bh spinlocks, thanks to Ming Lei.
v4:
 - make sure to use thread group leader when creating exceptions.
v3:
 - make sure to use thread group leader when searching for exceptions.
v2:
 - kmalloc, spinlock init, and doc typo corrections from Tetsuo Handa.
 - make sure to replace if possible on add, thanks to Eric Paris.
---
 Documentation/security/Yama.txt |   18 +++-
 include/linux/prctl.h           |    6 +
 security/yama/yama_lsm.c        |  240 ++++++++++++++++++++++++++++++++++++---
 3 files changed, 243 insertions(+), 21 deletions(-)

diff --git a/Documentation/security/Yama.txt b/Documentation/security/Yama.txt
index 1916742..9a83aa5 100644
--- a/Documentation/security/Yama.txt
+++ b/Documentation/security/Yama.txt
@@ -78,14 +78,26 @@ parent to a child process (i.e. direct "gdb EXE" and "strace EXE" still
 work), or with CAP_SYS_PTRACE (i.e. "gdb --pid=PID", and "strace -p PID"
 still work as root).
 
+For software that has defined application-specific relationships
+between a debugging process and its inferior (crash handlers, etc),
+prctl(PR_SET_PTRACER, pid, ...) can be used. An inferior can declare which
+other process (and its descendents) are allowed to call PTRACE_ATTACH
+against it. For example, this is used by KDE, Chromium, and Firefox's
+crash handlers, and by Wine for allowing only Wine processes to ptrace
+each other.
+
 0 - classic ptrace permissions: a process can PTRACE_ATTACH to any other
     process running under the same uid, as long as it is dumpable (i.e.
     did not transition uids, start privileged, or have called
     prctl(PR_SET_DUMPABLE...) already).
 
-1 - restricted ptrace: a process can only call PTRACE_ATTACH on its
-    descendants when the above classic criteria is also met.
+1 - restricted ptrace: a process must have a predefined relationship
+    with the inferior it wants to call PTRACE_ATTACH on. By default,
+    this relationship is that of only its descendants when the above
+    classic criteria is also met. To change the relationship, an
+    inferior can call prctl(PR_SET_PTRACER, debugger, ...) to declare
+    an allowed debugger PID to call PTRACE_ATTACH on the inferior.
 
-This protection is based on the restrictions in grsecurity.
+The original children-only logic was based on the restrictions in grsecurity.
 
 ==============================================================
diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..da7837b 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Set specific pid that is allowed to PTRACE the current task.
+ * A value of 0 mean "no process".
+ */
+#define PR_SET_PTRACER 0x59616d61
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 955e401..a92538c 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -14,15 +14,224 @@
 #include <linux/security.h>
 #include <linux/sysctl.h>
 #include <linux/ptrace.h>
+#include <linux/prctl.h>
 #include <linux/ratelimit.h>
 
 static int ptrace_scope = 1;
 static int protected_sticky_symlinks = 1;
 static int protected_nonaccess_hardlinks = 1;
 
+/* describe a PTRACE relationship for potential exception */
+struct ptrace_relation {
+	struct task_struct *tracer;
+	struct task_struct *tracee;
+	struct list_head node;
+};
+
+static LIST_HEAD(ptracer_relations);
+static DEFINE_SPINLOCK(ptracer_relations_lock);
+
+/**
+ * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
+ * @tracer: the task_struct of the process doing the PTRACE
+ * @tracee: the task_struct of the process to be PTRACEd
+ *
+ * Returns 0 if relationship was added, -ve on error.
+ */
+static int yama_ptracer_add(struct task_struct *tracer,
+			    struct task_struct *tracee)
+{
+	int rc = 0;
+	struct ptrace_relation *added;
+	struct ptrace_relation *entry, *relation = NULL;
+
+	added = kmalloc(sizeof(*added), GFP_KERNEL);
+	spin_lock_bh(&ptracer_relations_lock);
+	list_for_each_entry(entry, &ptracer_relations, node)
+		if (entry->tracee == tracee) {
+			relation = entry;
+			break;
+		}
+	if (!relation) {
+		relation = added;
+		if (!relation) {
+			rc = -ENOMEM;
+			goto unlock_out;
+		}
+		relation->tracee = tracee;
+		list_add(&relation->node, &ptracer_relations);
+	}
+	relation->tracer = tracer;
+
+unlock_out:
+	spin_unlock_bh(&ptracer_relations_lock);
+	if (added && added != relation)
+		kfree(added);
+
+	return rc;
+}
+
+/**
+ * yama_ptracer_del - remove exceptions related to the given tasks
+ * @tracer: remove any relation where tracer task matches
+ * @tracee: remove any relation where tracee task matches
+ */
+static void yama_ptracer_del(struct task_struct *tracer,
+			     struct task_struct *tracee)
+{
+	struct ptrace_relation *relation;
+	struct list_head *list, *safe;
+
+	spin_lock_bh(&ptracer_relations_lock);
+	list_for_each_safe(list, safe, &ptracer_relations) {
+		relation = list_entry(list, struct ptrace_relation, node);
+		if (relation->tracee == tracee ||
+		    relation->tracer == tracer) {
+			list_del(&relation->node);
+			kfree(relation);
+		}
+	}
+	spin_unlock_bh(&ptracer_relations_lock);
+}
+
+/**
+ * yama_task_free - check for task_pid to remove from exception list
+ * @task: task being removed
+ */
+static void yama_task_free(struct task_struct *task)
+{
+	yama_ptracer_del(task, task);
+}
+
+/**
+ * yama_task_prctl - check for Yama-specific prctl operations
+ * @option: operation
+ * @arg2: argument
+ * @arg3: argument
+ * @arg4: argument
+ * @arg5: argument
+ *
+ * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
+ * does not handle the given option.
+ */
+static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
+			   unsigned long arg4, unsigned long arg5)
+{
+	int rc;
+	struct task_struct *myself = current;
+
+	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (rc != -ENOSYS)
+		return rc;
+
+	switch (option) {
+	case PR_SET_PTRACER:
+		rcu_read_lock();
+		if (!thread_group_leader(myself))
+			myself = myself->group_leader;
+		get_task_struct(myself);
+		rcu_read_unlock();
+
+		if (arg2 == 0) {
+			yama_ptracer_del(NULL, myself);
+			rc = 0;
+		} else {
+			struct task_struct *tracer;
+
+			rcu_read_lock();
+			tracer = find_task_by_vpid(arg2);
+			if (tracer)
+				get_task_struct(tracer);
+			else
+				rc = -EINVAL;
+			rcu_read_unlock();
+
+			if (tracer) {
+				rc = yama_ptracer_add(tracer, myself);
+				put_task_struct(tracer);
+			}
+		}
+
+		put_task_struct(myself);
+		break;
+	}
+
+	return rc;
+}
+
+/**
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
+	if (!thread_group_leader(parent))
+		parent = parent->group_leader;
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
+/**
+ * ptracer_exception_found - tracer registered as exception for this tracee
+ * @tracer: the task_struct of the process attempting PTRACE
+ * @tracee: the task_struct of the process to be PTRACEd
+ *
+ * Returns 1 if tracer has is ptracer exception ancestor for tracee.
+ */
+static int ptracer_exception_found(struct task_struct *tracer,
+				   struct task_struct *tracee)
+{
+	int rc = 0;
+	struct ptrace_relation *relation;
+	struct task_struct *parent = NULL;
+
+	spin_lock_bh(&ptracer_relations_lock);
+
+	rcu_read_lock();
+	read_lock(&tasklist_lock);
+	if (!thread_group_leader(tracee))
+		tracee = tracee->group_leader;
+	list_for_each_entry(relation, &ptracer_relations, node)
+		if (relation->tracee == tracee) {
+			parent = relation->tracer;
+			break;
+		}
+	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
+
+	if (task_is_descendant(parent, tracer))
+		rc = 1;
+	spin_unlock_bh(&ptracer_relations_lock);
+
+	return rc;
+}
+
 /**
  * yama_ptrace_access_check - validate PTRACE_ATTACH calls
- * @child: child task pointer
+ * @child: task that current task is attempting to PTRACE
  * @mode: ptrace attach mode
  *
  * Returns 0 if following the ptrace is allowed, -ve on error.
@@ -32,27 +241,20 @@ static int yama_ptrace_access_check(struct task_struct *child,
 {
 	int rc;
 
+	/* If standard caps disallows it, so does Yama.  We should
+	 * only tighten restrictions further.
+	 */
 	rc = cap_ptrace_access_check(child, mode);
-	if (rc != 0)
+	if (rc)
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
+	    !capable(CAP_SYS_PTRACE) &&
+	    !task_is_descendant(current, child) &&
+	    !ptracer_exception_found(current, child))
+		rc = -EPERM;
 
 	if (rc) {
 		char name[sizeof(current->comm)];
@@ -185,6 +387,8 @@ static struct security_operations yama_ops = {
 	.ptrace_access_check =	yama_ptrace_access_check,
 	.inode_follow_link =	yama_inode_follow_link,
 	.path_link =		yama_path_link,
+	.task_prctl =		yama_task_prctl,
+	.task_free =		yama_task_free,
 };
 
 #ifdef CONFIG_SYSCTL
-- 
1.7.5.4

