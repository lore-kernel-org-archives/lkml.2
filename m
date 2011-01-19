Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1ASTTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:19:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:49547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab1ASTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:19:25 -0500
Date: Wed, 19 Jan 2011 19:18:41 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, roland@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, roland@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <20110119182207.GB12183@redhat.com>
References: <20110119182207.GB12183@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix find_get_context() vs perf_event_exit_task() race
Message-ID: <tip-dbe08d82ce3967ccdf459f7951d02589cf967300@git.kernel.org>
Git-Commit-ID: dbe08d82ce3967ccdf459f7951d02589cf967300
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 19 Jan 2011 19:18:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbe08d82ce3967ccdf459f7951d02589cf967300
Gitweb:     http://git.kernel.org/tip/dbe08d82ce3967ccdf459f7951d02589cf967300
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 19 Jan 2011 19:22:07 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Jan 2011 20:04:27 +0100

perf: Fix find_get_context() vs perf_event_exit_task() race

find_get_context() must not install the new perf_event_context
if the task has already passed perf_event_exit_task().

If nothing else, this means the memory leak. Initially
ctx->refcount == 2, it is supposed that
perf_event_exit_task_context() should participate and do the
necessary put_ctx().

find_lively_task_by_vpid() checks PF_EXITING but this buys
nothing, by the time we call find_get_context() this task can be
already dead. To the point, cmpxchg() can succeed when the task
has already done the last schedule().

Change find_get_context() to populate task->perf_event_ctxp[]
under task->perf_event_mutex, this way we can trust PF_EXITING
because perf_event_exit_task() takes the same mutex.

Also, change perf_event_exit_task_context() to use
rcu_dereference(). Probably this is not strictly needed, but
with or without this change find_get_context() can race with
setup_new_exec()->perf_event_exit_task(), rcu_dereference()
looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
LKML-Reference: <20110119182207.GB12183@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   34 ++++++++++++++++++++--------------
 1 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 84522c7..4ec55ef 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2201,13 +2201,6 @@ find_lively_task_by_vpid(pid_t vpid)
 	if (!task)
 		return ERR_PTR(-ESRCH);
 
-	/*
-	 * Can't attach events to a dying task.
-	 */
-	err = -ESRCH;
-	if (task->flags & PF_EXITING)
-		goto errout;
-
 	/* Reuse ptrace permission checks for now. */
 	err = -EACCES;
 	if (!ptrace_may_access(task, PTRACE_MODE_READ))
@@ -2268,14 +2261,27 @@ retry:
 
 		get_ctx(ctx);
 
-		if (cmpxchg(&task->perf_event_ctxp[ctxn], NULL, ctx)) {
-			/*
-			 * We raced with some other task; use
-			 * the context they set.
-			 */
+		err = 0;
+		mutex_lock(&task->perf_event_mutex);
+		/*
+		 * If it has already passed perf_event_exit_task().
+		 * we must see PF_EXITING, it takes this mutex too.
+		 */
+		if (task->flags & PF_EXITING)
+			err = -ESRCH;
+		else if (task->perf_event_ctxp[ctxn])
+			err = -EAGAIN;
+		else
+			rcu_assign_pointer(task->perf_event_ctxp[ctxn], ctx);
+		mutex_unlock(&task->perf_event_mutex);
+
+		if (unlikely(err)) {
 			put_task_struct(task);
 			kfree(ctx);
-			goto retry;
+
+			if (err == -EAGAIN)
+				goto retry;
+			goto errout;
 		}
 	}
 
@@ -6127,7 +6133,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = child->perf_event_ctxp[ctxn];
+	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
 	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*
