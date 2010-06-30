Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0F3Akc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:40:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:45352 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab0F3Ak2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:40:28 -0400
Date: Tue, 29 Jun 2010 17:40:27 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630004027.GG4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100630003844.GE4837@outflux.net>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some application suites have external crash handlers that depend on
being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
Since the inferior process generally knows the PID of the debugger,
it can use PR_SET_PTRACER to allow a specific PID and its descendants
to perform the PTRACE instead of only a direct ancestor.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 include/linux/prctl.h    |    6 ++
 security/yama/yama_lsm.c |  205 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 193 insertions(+), 18 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..e435624 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Set specific pid that is allowed to PTRACE the current task.
+ * A value of 0 mean "no process".
+ */
+#define PR_SET_PTRACER 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 72929d2..0e989c4 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -14,15 +14,187 @@
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
+static spinlock_t ptracer_relations_lock;
+
+/**
+ * yama_ptracer_add - add an exception for this tracer/tracee pair
+ * @tracer: the task_struct of the process doing the PTRACE
+ * @tracee: the task_struct of the process to be PTRACEd
+ *
+ * Returns 0 if relationship was added, -ve on error.
+ */
+static int yama_ptracer_add(struct task_struct *tracer,
+			    struct task_struct *tracee)
+{
+	struct ptrace_relation *relation;
+
+	relation = kzalloc(sizeof(*relation), GFP_KERNEL);
+	if (!relation)
+		return -ENOMEM;
+	relation->tracer = tracer;
+	relation->tracee = tracee;
+	spin_lock(&ptracer_relations_lock);
+	list_add(&relation->node, &ptracer_relations);
+	spin_unlock(&ptracer_relations_lock);
+
+	return 0;
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
+	spin_lock(&ptracer_relations_lock);
+	list_for_each_safe(list, safe, &ptracer_relations) {
+		relation = list_entry(list, struct ptrace_relation, node);
+		if (relation->tracee == tracee ||
+		    relation->tracer == tracer) {
+			list_del(&relation->node);
+			kfree(relation);
+		}
+	}
+	spin_unlock(&ptracer_relations_lock);
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
+
+	rc = cap_task_prctl(option, arg2, arg3, arg4, arg5);
+	if (rc != -ENOSYS)
+		return rc;
+
+	switch (option) {
+	case PR_SET_PTRACER:
+		if (arg2 == 0) {
+			yama_ptracer_del(NULL, current);
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
+				rc = yama_ptracer_add(tracer, current);
+				put_task_struct(tracer);
+			}
+		}
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
+	while (walker->pid > 0) {
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
+	spin_lock(&ptracer_relations_lock);
+	list_for_each_entry(relation, &ptracer_relations, node)
+		if (relation->tracee == tracee) {
+			parent = relation->tracer;
+			break;
+		}
+	if (task_is_descendant(parent, tracer))
+		rc = 1;
+	spin_unlock(&ptracer_relations_lock);
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
@@ -32,27 +204,20 @@ static int yama_ptrace_access_check(struct task_struct *child,
 {
 	int rc;
 
+	/* If standard caps disallows it, so does Yama.  We should
+	 * should only tighten restrictions further.
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
@@ -170,6 +335,8 @@ static struct security_operations yama_ops = {
 	.ptrace_access_check =	yama_ptrace_access_check,
 	.inode_follow_link =	yama_inode_follow_link,
 	.path_link =		yama_path_link,
+	.task_prctl =		yama_task_prctl,
+	.task_free =		yama_task_free,
 };
 
 #ifdef CONFIG_SYSCTL
@@ -221,6 +388,8 @@ static __init int yama_init(void)
 
 	printk(KERN_INFO "Yama: becoming mindful.\n");
 
+	spin_lock_init(&ptracer_relations_lock);
+
 	if (register_security(&yama_ops))
 		panic("Yama: kernel registration failed.\n");
 
-- 
1.7.1


-- 
Kees Cook
Ubuntu Security Team
