Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2JXJjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:39:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54747 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab2JXJjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:39:02 -0400
Date: Wed, 24 Oct 2012 02:37:49 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-b6fc69b9e76352786cd945ce3175780fffb467f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, riel@redhat.com, akpm@linux-foundation.org,
        aarcange@redhat.com, tglx@linutronix.de
Reply-To: riel@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, aarcange@redhat.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:numa/core] numa, sched: Eliminate unused functions
Git-Commit-ID: b6fc69b9e76352786cd945ce3175780fffb467f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 02:37:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b6fc69b9e76352786cd945ce3175780fffb467f0
Gitweb:     http://git.kernel.org/tip/b6fc69b9e76352786cd945ce3175780fffb467f0
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 24 Oct 2012 09:04:41 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 09:11:16 +0200

numa, sched: Eliminate unused functions

Andrew Morton reported these allnoconfig warnings:

  kernel/sched/fair.c:800: warning: 'task_h_load' declared 'static' but never defined
  kernel/sched/fair.c:1004: warning: 'account_numa_enqueue' defined but not used

These are only used on CONFIG_SMP - fix it.

We should eventually resolve the Kconfig complexities here by turning
SMP (and NUMA) scheduling either into a separate source code file, or
by creating a single-model scheduler, which happens to build to a small
object file on !CONFIG_SMP or !CONFIG_NUMA kernels not via #ifdefs but
via more clever build time code elimination and zero-size data fields.

That's not a simple patch.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/n/tip-wyctbug9qKulTs0umsxjyixi@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dea3ca6..41ad458 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -797,7 +797,9 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * have.
  */
 
+#ifdef CONFIG_SMP
 static unsigned long task_h_load(struct task_struct *p);
+#endif
 
 #ifdef CONFIG_SCHED_NUMA
 static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
@@ -995,10 +997,12 @@ void task_tick_numa(struct rq *rq, struct task_struct *curr)
 	}
 }
 #else
+#ifdef CONFIG_SMP
 static struct list_head *account_numa_enqueue(struct rq *rq, struct task_struct *p)
 {
 	return NULL;
 }
+#endif
 
 static void account_numa_dequeue(struct rq *rq, struct task_struct *p)
 {
@@ -3760,12 +3764,13 @@ static inline void update_shares(int cpu)
 static inline void update_h_load(long cpu)
 {
 }
-
+#ifdef CONFIG_SMP
 static unsigned long task_h_load(struct task_struct *p)
 {
 	return p->se.load.weight;
 }
 #endif
+#endif
 
 /********** Helpers for find_busiest_group ************************/
 /*
