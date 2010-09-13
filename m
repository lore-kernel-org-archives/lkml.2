Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0IMUBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:01:38 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43613 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab0IMUBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:01:36 -0400
From: Matt Helsley <matthltc@us.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: containers@lists.linux-foundation.org, Matt Helsley <matthltc@us.ibm.com>,
        Robin Green <greenrd@greenrd.org>, linux-kernel@vger.kernel.org,
        Prasad <prasad@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Will Deacon <will.deacon@arm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: [PATCH 2/3] perf events: Split out task search into helper
Date: Mon, 13 Sep 2010 13:01:19 -0700
Message-Id: <561205417b450b8a4bf7488374541d64b4690431.1284407762.git.matthltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
References: <1284408080-2135-1-git-send-email-matthltc@us.ibm.com>
 <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
In-Reply-To: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
References: <f63454af09fb1915717251570423eb9ddd338340.1284407762.git.matthltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the code which searches for non-exiting tasks into its own
helper. Creating this helper not only makes the code slightly more
readable it prepares to move the search out of find_get_context() in
a subsequent commit.

Cc: Robin Green <greenrd@greenrd.org>
Cc: linux-kernel@vger.kernel.org
Cc: containers@lists.linux-foundation.org
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/perf_event.c |   63 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 40 insertions(+), 23 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 440f9ca..3f5309d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2015,6 +2015,43 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 	return ctx;
 }
 
+static struct task_struct *
+find_lively_task_by_vpid(pid_t vpid)
+{
+	struct task_struct *task;
+	int err;
+
+	rcu_read_lock();
+	if (!vpid)
+		task = current;
+	else
+		task = find_task_by_vpid(vpid);
+	if (task)
+		get_task_struct(task);
+	rcu_read_unlock();
+
+	if (!task)
+		return ERR_PTR(-ESRCH);
+
+	/*
+	 * Can't attach events to a dying task.
+	 */
+	err = -ESRCH;
+	if (task->flags & PF_EXITING)
+		goto errout;
+
+	/* Reuse ptrace permission checks for now. */
+	err = -EACCES;
+	if (!ptrace_may_access(task, PTRACE_MODE_READ))
+		goto errout;
+
+	return task;
+errout:
+	put_task_struct(task);
+	return ERR_PTR(err);
+
+}
+
 static struct perf_event_context *
 find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 {
@@ -2047,29 +2084,9 @@ find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 		return ctx;
 	}
 
-	rcu_read_lock();
-	if (!pid)
-		task = current;
-	else
-		task = find_task_by_vpid(pid);
-	if (task)
-		get_task_struct(task);
-	rcu_read_unlock();
-
-	if (!task)
-		return ERR_PTR(-ESRCH);
-
-	/*
-	 * Can't attach events to a dying task.
-	 */
-	err = -ESRCH;
-	if (task->flags & PF_EXITING)
-		goto errout;
-
-	/* Reuse ptrace permission checks for now. */
-	err = -EACCES;
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto errout;
+	task = find_lively_task_by_vpid(pid);
+	if (IS_ERR(task))
+		return (void*)task;
 
 	err = -EINVAL;
 	ctxn = pmu->task_ctx_nr;
-- 
1.6.3.3

