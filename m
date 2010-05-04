Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab0EDMkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:40:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab0EDMjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:39:46 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/12] sched: relocate fire_sched_notifiers_out() and trace_sched_switch()
Date: Tue,  4 May 2010 14:38:38 +0200
Message-Id: <1272976724-14312-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1272976724-14312-1-git-send-email-tj@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 12:38:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relocate fire_sched_notifiers_out() from prepare_task_switch() and
trace_sched_switch() from context_switch() to schedule() so that
trace_sched_switch(), perf_event_task_sched_out() and
fire_sched_notifiers_out() are colocated.

Both are now called before switch counts and rq->curr are updated and
in addition trace_sched_switch() is called before
prepare_lock/arch_switch(); however, this shouldn't make any visible
different for either.

This will help unifying notifiers in sched.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index df6e0af..0b753f0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2753,7 +2753,6 @@ static inline void
 prepare_task_switch(struct rq *rq, struct task_struct *prev,
 		    struct task_struct *next)
 {
-	fire_sched_notifiers_out(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
 }
@@ -2882,7 +2881,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_sched_switch(rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
@@ -3714,7 +3712,9 @@ need_resched_nonpreemptible:
 
 	if (likely(prev != next)) {
 		sched_info_switch(prev, next);
+		trace_sched_switch(rq, prev, next);
 		perf_event_task_sched_out(rq, prev, next);
+		fire_sched_notifiers_out(prev, next);
 
 		rq->nr_switches++;
 		rq->curr = next;
-- 
1.6.4.2

