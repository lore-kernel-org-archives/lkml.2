Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KSXfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:35:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:50834 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2KSXfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:35:11 -0500
Date: Mon, 19 Nov 2012 15:34:59 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Subject: [PATCH] Yama: remove locking from delete path
Message-ID: <20121119233459.GA9524@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of locking the list during a delete, mark entries as invalid
and trigger a workqueue to clean them up. This lets us easily handle
task_free from interrupt context.

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/yama/yama_lsm.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 17da6ca..1cba901 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -17,6 +17,7 @@
 #include <linux/ptrace.h>
 #include <linux/prctl.h>
 #include <linux/ratelimit.h>
+#include <linux/workqueue.h>
 
 #define YAMA_SCOPE_DISABLED	0
 #define YAMA_SCOPE_RELATIONAL	1
@@ -29,6 +30,7 @@ static int ptrace_scope = YAMA_SCOPE_RELATIONAL;
 struct ptrace_relation {
 	struct task_struct *tracer;
 	struct task_struct *tracee;
+	bool invalid;
 	struct list_head node;
 	struct rcu_head rcu;
 };
@@ -36,6 +38,27 @@ struct ptrace_relation {
 static LIST_HEAD(ptracer_relations);
 static DEFINE_SPINLOCK(ptracer_relations_lock);
 
+static void yama_relation_cleanup(struct work_struct *work);
+static DECLARE_WORK(yama_relation_work, yama_relation_cleanup);
+
+/**
+ * yama_relation_cleanup - remove invalid entries from the relation list
+ *
+ */
+static void yama_relation_cleanup(struct work_struct *work)
+{
+	struct ptrace_relation *relation;
+
+	spin_lock(&ptracer_relations_lock);
+	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
+		if (relation->invalid) {
+			list_del_rcu(&relation->node);
+			kfree_rcu(relation, rcu);
+		}
+	}
+	spin_unlock(&ptracer_relations_lock);
+}
+
 /**
  * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
  * @tracer: the task_struct of the process doing the ptrace
@@ -57,9 +80,12 @@ static int yama_ptracer_add(struct task_struct *tracer,
 
 	added->tracee = tracee;
 	added->tracer = tracer;
+	added->invalid = false;
 
-	spin_lock_bh(&ptracer_relations_lock);
+	spin_lock(&ptracer_relations_lock);
 	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
+		if (relation->invalid)
+			continue;
 		if (relation->tracee == tracee) {
 			list_replace_rcu(&relation->node, &added->node);
 			kfree_rcu(relation, rcu);
@@ -70,7 +96,7 @@ static int yama_ptracer_add(struct task_struct *tracer,
 	list_add_rcu(&added->node, &ptracer_relations);
 
 out:
-	spin_unlock_bh(&ptracer_relations_lock);
+	spin_unlock(&ptracer_relations_lock);
 	return 0;
 }
 
@@ -84,15 +110,15 @@ static void yama_ptracer_del(struct task_struct *tracer,
 {
 	struct ptrace_relation *relation;
 
-	spin_lock_bh(&ptracer_relations_lock);
 	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
+		if (relation->invalid)
+			continue;
 		if (relation->tracee == tracee ||
 		    (tracer && relation->tracer == tracer)) {
-			list_del_rcu(&relation->node);
-			kfree_rcu(relation, rcu);
+			relation->invalid = true;
+			schedule_work(&yama_relation_work);
 		}
 	}
-	spin_unlock_bh(&ptracer_relations_lock);
 }
 
 /**
@@ -219,12 +245,15 @@ static int ptracer_exception_found(struct task_struct *tracer,
 	rcu_read_lock();
 	if (!thread_group_leader(tracee))
 		tracee = rcu_dereference(tracee->group_leader);
-	list_for_each_entry_rcu(relation, &ptracer_relations, node)
+	list_for_each_entry_rcu(relation, &ptracer_relations, node) {
+		if (relation->invalid)
+			continue;
 		if (relation->tracee == tracee) {
 			parent = relation->tracer;
 			found = true;
 			break;
 		}
+	}
 
 	if (found && (parent == NULL || task_is_descendant(parent, tracer)))
 		rc = 1;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
