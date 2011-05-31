Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab1EaMcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:32:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:41675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab1EaMcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:32:52 -0400
Date: Tue, 31 May 2011 12:32:13 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-74c355fbdfedd3820046dba4f537876cea54c207@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, bblum@andrew.cmu.edu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        bblum@andrew.cmu.edu, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1306767651.1200.2990.camel@twins>
References: <1306767651.1200.2990.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, cgroups: Fix up for new API
Git-Commit-ID: 74c355fbdfedd3820046dba4f537876cea54c207
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 31 May 2011 12:32:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74c355fbdfedd3820046dba4f537876cea54c207
Gitweb:     http://git.kernel.org/tip/74c355fbdfedd3820046dba4f537876cea54c207
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 30 May 2011 16:48:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 31 May 2011 14:20:25 +0200

perf, cgroups: Fix up for new API

Ben changed the cgroup API in commit f780bdb7c1c (cgroups: add
per-thread subsystem callbacks) in an incompatible way, but
forgot to convert the perf cgroup bits.

Avoid compile warnings and runtime splats and convert perf too ;-)

Acked-by: Ben Blum <bblum@andrew.cmu.edu>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1306767651.1200.2990.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c09767f..8a15944 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7394,26 +7394,12 @@ static int __perf_cgroup_move(void *info)
 	return 0;
 }
 
-static void perf_cgroup_move(struct task_struct *task)
+static void
+perf_cgroup_attach_task(struct cgroup *cgrp, struct task_struct *task)
 {
 	task_function_call(task, __perf_cgroup_move, task);
 }
 
-static void perf_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		struct cgroup *old_cgrp, struct task_struct *task,
-		bool threadgroup)
-{
-	perf_cgroup_move(task);
-	if (threadgroup) {
-		struct task_struct *c;
-		rcu_read_lock();
-		list_for_each_entry_rcu(c, &task->thread_group, thread_group) {
-			perf_cgroup_move(c);
-		}
-		rcu_read_unlock();
-	}
-}
-
 static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 		struct cgroup *old_cgrp, struct task_struct *task)
 {
@@ -7425,7 +7411,7 @@ static void perf_cgroup_exit(struct cgroup_subsys *ss, struct cgroup *cgrp,
 	if (!(task->flags & PF_EXITING))
 		return;
 
-	perf_cgroup_move(task);
+	perf_cgroup_attach_task(cgrp, task);
 }
 
 struct cgroup_subsys perf_subsys = {
@@ -7434,6 +7420,6 @@ struct cgroup_subsys perf_subsys = {
 	.create		= perf_cgroup_create,
 	.destroy	= perf_cgroup_destroy,
 	.exit		= perf_cgroup_exit,
-	.attach		= perf_cgroup_attach,
+	.attach_task	= perf_cgroup_attach_task,
 };
 #endif /* CONFIG_CGROUP_PERF */
