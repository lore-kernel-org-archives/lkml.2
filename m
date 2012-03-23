Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2CWLgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 07:36:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2CWLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 07:36:36 -0400
Date: Fri, 23 Mar 2012 04:36:10 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-6c16a6dcb05e51ace340ff7bc6dbe647f1593528@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20120321200717.49BB4A024E@akpm.mtv.corp.google.com>
References: <20120321200717.49BB4A024E@akpm.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix compiler warning about declared inline after use
Git-Commit-ID: 6c16a6dcb05e51ace340ff7bc6dbe647f1593528
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 04:36:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c16a6dcb05e51ace340ff7bc6dbe647f1593528
Gitweb:     http://git.kernel.org/tip/6c16a6dcb05e51ace340ff7bc6dbe647f1593528
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 21 Mar 2012 13:07:16 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 23 Mar 2012 10:39:28 +0100

sched: Fix compiler warning about declared inline after use

kernel/sched/fair.c:420: warning: 'account_cfs_rq_runtime' declared inline after being called
kernel/sched/fair.c:420: warning: previous declaration of 'account_cfs_rq_runtime' was here
kernel/sched/fair.c:1165: warning: 'return_cfs_rq_runtime' declared inlineafter being called
kernel/sched/fair.c:1165: warning: previous declaration of 'return_cfs_rq_runtime' was here

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120321200717.49BB4A024E@akpm.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 11f3979..258f430 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -416,8 +416,8 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				   unsigned long delta_exec);
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec);
 
 /**************************************************************
  * Scheduling class tree data structure manipulation methods:
@@ -1162,7 +1162,7 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		__clear_buddies_skip(se);
 }
 
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
 static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
@@ -1546,8 +1546,8 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
 		resched_task(rq_of(cfs_rq)->curr);
 }
 
-static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-						   unsigned long delta_exec)
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec)
 {
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
@@ -2073,11 +2073,11 @@ void unthrottle_offline_cfs_rqs(struct rq *rq)
 }
 
 #else /* CONFIG_CFS_BANDWIDTH */
-static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
-				     unsigned long delta_exec) {}
+static __always_inline
+void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, unsigned long delta_exec) {}
 static void check_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq) {}
-static void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
+static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
 
 static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
 {
