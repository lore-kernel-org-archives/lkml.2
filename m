Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0IOKER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:04:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:39938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IOKEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:04:13 -0400
Date: Wed, 15 Sep 2010 10:03:29 GMT
From: tip-bot for Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, will.deacon@arm.com, a.p.zijlstra@chello.nl,
        matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu, greenrd@greenrd.org,
        prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        greenrd@greenrd.org, mingo@elte.hu
In-Reply-To: <561205417b450b8a4bf7488374541d64b4690431.1284407762.git.matthltc@us.ibm.com>
References: <561205417b450b8a4bf7488374541d64b4690431.1284407762.git.matthltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Split out task search into helper
Message-ID: <tip-2ebd4ffb6d0cb877787b1e42be8485820158857e@git.kernel.org>
Git-Commit-ID: 2ebd4ffb6d0cb877787b1e42be8485820158857e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:03:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ebd4ffb6d0cb877787b1e42be8485820158857e
Gitweb:     http://git.kernel.org/tip/2ebd4ffb6d0cb877787b1e42be8485820158857e
Author:     Matt Helsley <matthltc@us.ibm.com>
AuthorDate: Mon, 13 Sep 2010 13:01:19 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:00 +0200

perf events: Split out task search into helper

Split out the code which searches for non-exiting tasks into its own
helper. Creating this helper not only makes the code slightly more
readable it prepares to move the search out of find_get_context() in
a subsequent commit.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robin Green <greenrd@greenrd.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
LKML-Reference: <561205417b450b8a4bf7488374541d64b4690431.1284407762.git.matthltc@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
