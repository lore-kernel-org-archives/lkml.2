Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2JUM5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:57:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48860 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2JUM53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:57:29 -0400
Date: Sun, 21 Oct 2012 05:57:12 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-aef6f4048d7467d2d805c6c9edc6dab37597becb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        akpm@linux-foundation.org, aarcange@redhat.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] sched, numa: Add NUMA_MIGRATION feature flag
Git-Commit-ID: aef6f4048d7467d2d805c6c9edc6dab37597becb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 21 Oct 2012 05:57:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aef6f4048d7467d2d805c6c9edc6dab37597becb
Gitweb:     http://git.kernel.org/tip/aef6f4048d7467d2d805c6c9edc6dab37597becb
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 20 Oct 2012 22:20:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 21 Oct 2012 14:40:41 +0200

sched, numa: Add NUMA_MIGRATION feature flag

After this patch, doing:

   # echo NO_NUMA_MIGRATION > /sys/kernel/debug/sched_features

Will turn off the NUMA placement logic/policy - but keeps the
working set sampling faults in place.

This allows the debugging of the WSS facility, by using it
but keeping vanilla, non-NUMA CPU and memory placement
policies.

Default enabled. Generates on extra code on !CONFIG_SCHED_DEBUG.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-xjt7bqjlphxRfjXxasqm4cdv@git.kernel.org
---
 kernel/sched/core.c     |    3 +++
 kernel/sched/features.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ef24c7b..67221c0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6002,6 +6002,9 @@ void sched_setnode(struct task_struct *p, int node)
 	int on_rq, running;
 	struct rq *rq;
 
+	if (!sched_feat(NUMA_MIGRATION))
+		return;
+
 	rq = task_rq_lock(p, &flags);
 	on_rq = p->on_rq;
 	running = task_current(rq, p);
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index f8a7aeb..1d11f6c 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -63,7 +63,10 @@ SCHED_FEAT(RT_RUNTIME_SHARE, true)
 SCHED_FEAT(LB_MIN, false)
 
 #ifdef CONFIG_SCHED_NUMA
+/* Do the working set probing faults: */
 SCHED_FEAT(NUMA,           true)
+/* Do actual migration/placement based on the working set information: */
+SCHED_FEAT(NUMA_MIGRATION, true)
 SCHED_FEAT(NUMA_HOT,       true)
 SCHED_FEAT(NUMA_TTWU_BIAS, false)
 SCHED_FEAT(NUMA_TTWU_TO,   false)
