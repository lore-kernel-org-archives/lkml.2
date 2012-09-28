Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2I1H76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:59:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38053 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2I1H74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:59:56 -0400
Date: Fri, 28 Sep 2012 00:59:30 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-lfpez319yryvdhwqfqrh99f2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, pjt@google.com,
        cl@linux.com, riel@redhat.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched: Make find_busiest_queue() a method
Git-Commit-ID: 6aee56c2e1f3e90f5867cf3fd995b0e3f368d229
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 00:59:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6aee56c2e1f3e90f5867cf3fd995b0e3f368d229
Gitweb:     http://git.kernel.org/tip/6aee56c2e1f3e90f5867cf3fd995b0e3f368d229
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 3 Mar 2012 16:56:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Sep 2012 14:46:04 +0200

sched: Make find_busiest_queue() a method

Its a bit awkward but it was the least painful means of modifying the
queue selection. Used in a later patch to conditionally use a random
queue.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-lfpez319yryvdhwqfqrh99f2@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index de596a2..ffa10d6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3049,6 +3049,9 @@ struct lb_env {
 	unsigned int		loop;
 	unsigned int		loop_break;
 	unsigned int		loop_max;
+
+	struct rq *		(*find_busiest_queue)(struct lb_env *,
+						      struct sched_group *);
 };
 
 /*
@@ -4222,13 +4225,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
 
 	struct lb_env env = {
-		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
-		.dst_grpmask    = sched_group_cpus(sd->groups),
-		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
-		.cpus		= cpus,
+		.sd		    = sd,
+		.dst_cpu	    = this_cpu,
+		.dst_rq		    = this_rq,
+		.dst_grpmask        = sched_group_cpus(sd->groups),
+		.idle		    = idle,
+		.loop_break	    = sched_nr_migrate_break,
+		.cpus		    = cpus,
+		.find_busiest_queue = find_busiest_queue,
 	};
 
 	cpumask_copy(cpus, cpu_active_mask);
@@ -4247,7 +4251,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(&env, group);
+	busiest = env.find_busiest_queue(&env, group);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
