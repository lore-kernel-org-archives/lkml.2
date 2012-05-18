Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762732Ab2ERKjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:39:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760701Ab2ERKjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:39:20 -0400
Date: Fri, 18 May 2012 03:38:48 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-yhxhkcnevwerp7qzejirdmgv@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        aarcange@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bharata.rao@gmail.com, Lee.Schermerhorn@hp.com, danms@us.ibm.com,
        mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, bharata.rao@gmail.com,
        akpm@linux-foundation.org, Lee.Schermerhorn@hp.com,
        aarcange@redhat.com, danms@us.ibm.com, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Only migrate long-running entities
Git-Commit-ID: 28a5d43566d3c72a75eb07051833901eec6e2602
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:38:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28a5d43566d3c72a75eb07051833901eec6e2602
Gitweb:     http://git.kernel.org/tip/28a5d43566d3c72a75eb07051833901eec6e2602
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 9 Mar 2012 11:52:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 08:16:24 +0200

sched/numa: Only migrate long-running entities

It doesn't make much sense to memory migrate short running things.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dan Smith <danms@us.ibm.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-yhxhkcnevwerp7qzejirdmgv@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/numa.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
index 6088165..7712744 100644
--- a/kernel/sched/numa.c
+++ b/kernel/sched/numa.c
@@ -27,6 +27,8 @@ struct numa_ops {
 	void		(*mem_migrate)(struct numa_entity *ne, int node);
 	void		(*cpu_migrate)(struct numa_entity *ne, int node);
 
+	u64		(*cpu_runtime)(struct numa_entity *ne);
+
 	bool		(*tryget)(struct numa_entity *ne);
 	void		(*put)(struct numa_entity *ne);
 };
@@ -208,6 +210,21 @@ static void process_mem_migrate(struct numa_entity *ne, int node)
 	lazy_migrate_process(ne_mm(ne), node);
 }
 
+static u64 process_cpu_runtime(struct numa_entity *ne)
+{
+	struct task_struct *p, *t;
+	u64 runtime = 0;
+
+	rcu_read_lock();
+	t = p = ne_owner(ne);
+	if (p) do {
+		runtime += t->se.sum_exec_runtime; // @#$#@ 32bit
+	} while ((t = next_thread(t)) != p);
+	rcu_read_unlock();
+
+	return runtime;
+}
+
 static bool process_tryget(struct numa_entity *ne)
 {
 	/*
@@ -231,6 +248,8 @@ static const struct numa_ops process_numa_ops = {
 	.mem_migrate	= process_mem_migrate,
 	.cpu_migrate	= process_cpu_migrate,
 
+	.cpu_runtime	= process_cpu_runtime,
+
 	.tryget		= process_tryget,
 	.put		= process_put,
 };
@@ -611,6 +630,14 @@ static bool can_move_ne(struct numa_entity *ne)
 	 * XXX: consider mems_allowed, stinking cpusets has mems_allowed
 	 * per task and it can actually differ over a whole process, la-la-la.
 	 */
+
+	/*
+	 * Don't bother migrating memory if there's less than 1 second
+	 * of runtime on the tasks.
+	 */
+	if (ne->nops->cpu_runtime(ne) < NSEC_PER_SEC)
+		return false;
+
 	return true;
 }
 
