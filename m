Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1ASSaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:30:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1ASSaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:30:03 -0500
Date: Wed, 19 Jan 2011 19:22:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf: fix find_get_context() vs perf_event_exit_task()
	race
Message-ID: <20110119182207.GB12183@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145725.GA3434@redhat.com> <20110119182141.GA12183@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119182141.GA12183@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_get_context() must not install the new perf_event_context if the
task has already passed perf_event_exit_task().

If nothing else, this means the memory leak. Initially ctx->refcount == 2,
it is supposed that perf_event_exit_task_context() should participate and
do the necessary put_ctx().

find_lively_task_by_vpid() checks PF_EXITING but this buys nothing, by the
time we call find_get_context() this task can be already dead. To the point,
cmpxchg() can succeed when the task has already done the last schedule().

Change find_get_context() to populate task->perf_event_ctxp[] under
task->perf_event_mutex, this way we can trust PF_EXITING because
perf_event_exit_task() takes the same mutex.

Also, change perf_event_exit_task_context() to use rcu_dereference().
Probably this is not strictly needed, but with or without this change
find_get_context() can race with setup_new_exec()->perf_event_exit_task(),
rcu_dereference() looks better.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/perf_event.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

--- git/kernel/perf_event.c~3_find_get_context_vs_exit	2011-01-18 16:57:08.000000000 +0100
+++ git/kernel/perf_event.c	2011-01-19 17:41:16.000000000 +0100
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
 
@@ -6127,7 +6133,7 @@ static void perf_event_exit_task_context
 	 * scheduled, so we are now safe from rescheduling changing
 	 * our context.
 	 */
-	child_ctx = child->perf_event_ctxp[ctxn];
+	child_ctx = rcu_dereference(child->perf_event_ctxp[ctxn]);
 	task_ctx_sched_out(child_ctx, EVENT_ALL);
 
 	/*

