Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0LFQ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:58:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:59735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0LFQ6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:58:46 -0500
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/16] ptrace: reorganize __ptrace_unlink() and ptrace_untrace()
Date: Mon,  6 Dec 2010 17:57:01 +0100
Message-Id: <1291654624-6230-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291654624-6230-1-git-send-email-tj@kernel.org>
References: <1291654624-6230-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Dec 2010 16:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Collapse ptrace_untrace() into __ptrace_unlink().

* Always do the whole unlinking inside siglock.

* Untracing is done before unlinking.

This is to prepare for further changes.  As the whole
unlinking/tracing is done inside both tasklist lock and siglock, the
reordering doesn't cause any visible behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 kernel/ptrace.c |   40 ++++++++++++++++++----------------------
 1 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 5191301..6ac12f4 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -38,45 +38,41 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 }
 
 /*
- * Turn a tracing stop into a normal stop now, since with no tracer there
- * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
- * signal sent that would resume the child, but didn't because it was in
- * TASK_TRACED, resume it now.
- * Requires that irqs be disabled.
+ * unptrace a task: move it back to its original parent and remove it
+ * from the ptrace list.
+ *
+ * Turn a tracing stop into a normal stop now, since with no tracer
+ * there would be no way to wake it up with SIGCONT or SIGKILL.  If
+ * there was a signal sent that would resume the child, but didn't
+ * because it was in TASK_TRACED, resume it now.  Requires that irqs
+ * be disabled.
+ *
+ * Must be called with the tasklist lock write-held.
  */
-static void ptrace_untrace(struct task_struct *child)
+void __ptrace_unlink(struct task_struct *child)
 {
+	struct signal_struct *sig = child->signal;
+
+	BUG_ON(!child->ptrace);
+
 	spin_lock(&child->sighand->siglock);
+
 	if (task_is_traced(child)) {
 		/*
 		 * If group stop is completed or in progress, it should
 		 * participate in the group stop.  Set GROUP_STOP_PENDING
 		 * before kicking it.
 		 */
-		if (child->signal->flags & SIGNAL_STOP_STOPPED ||
-		    child->signal->group_stop_count)
+		if (sig->flags & SIGNAL_STOP_STOPPED || sig->group_stop_count)
 			child->group_stop |= GROUP_STOP_PENDING;
 		signal_wake_up(child, 1);
 	}
-	spin_unlock(&child->sighand->siglock);
-}
-
-/*
- * unptrace a task: move it back to its original parent and
- * remove it from the ptrace list.
- *
- * Must be called with the tasklist lock write-held.
- */
-void __ptrace_unlink(struct task_struct *child)
-{
-	BUG_ON(!child->ptrace);
 
 	child->ptrace = 0;
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
-	if (task_is_traced(child))
-		ptrace_untrace(child);
+	spin_unlock(&child->sighand->siglock);
 }
 
 static int ptrace_wait_trap(void *flags)
-- 
1.7.1

