Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab2JLL1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:27:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab2JLL1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:27:00 -0400
Date: Fri, 12 Oct 2012 04:26:47 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3pzp0o6gemhb8t7fj8shscpo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Fix NUMA_PULL_BIAS
Git-Commit-ID: 5b1e7a5858fd9cbf5b2062d845db54b1750c6ca6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:26:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5b1e7a5858fd9cbf5b2062d845db54b1750c6ca6
Gitweb:     http://git.kernel.org/tip/5b1e7a5858fd9cbf5b2062d845db54b1750c6ca6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Oct 2012 15:57:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:17 +0200

sched/numa: Fix NUMA_PULL_BIAS

PULL_BIAS is broken, the intent was to only attempt a small bias when
the machine was otherwise balanced, hence the out_balanced label.

The problem is that a number of branches that decide we're completely
unbalanced also jump to the out_balanced label, causing undue numa
bias. The end result was that an unbalanced system of 8:1 would try
and move the 1 task towards the 8.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-3pzp0o6gemhb8t7fj8shscpo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 62d77ef..60be6bf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4569,7 +4569,7 @@ find_busiest_group(struct lb_env *env, int *balance)
 
 	/* There is no busy sibling group to pull tasks from */
 	if (!sds.busiest || sds.busiest_nr_running == 0)
-		goto out_balanced;
+		goto ret;
 
 	sds.avg_load = (SCHED_POWER_SCALE * sds.total_load) / sds.total_pwr;
 
@@ -4591,14 +4591,14 @@ find_busiest_group(struct lb_env *env, int *balance)
 	 * don't try and pull any tasks.
 	 */
 	if (sds.this_load >= sds.max_load)
-		goto out_balanced;
+		goto ret;
 
 	/*
 	 * Don't pull any tasks if this group is already above the domain
 	 * average load.
 	 */
 	if (sds.this_load >= sds.avg_load)
-		goto out_balanced;
+		goto ret;
 
 	if (env->idle == CPU_IDLE) {
 		/*
