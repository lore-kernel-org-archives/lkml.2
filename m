Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1BJMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab1BJMZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:29 -0500
From: stable-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 10 Feb 2011 10:23:29 +0100
Subject: [PATCH 25/28] sched: Fix cross-sched-class wakeup preemption
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: 1e5a74059f9059d330744eac84873b1b99657008 upstream
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sun Oct 31 12:37:04 2010 +0100

Instead of dealing with sched classes inside each check_preempt_curr()
implementation, pull out this logic into the generic wakeup preemption
path.

This fixes a hang in KVM (and others) where we are waiting for the
stop machine thread to run ...

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Marcelo Tosatti <mtosatti@redhat.com>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1288891946.2039.31.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 590d73b..445f2d1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -594,11 +594,7 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline
-void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
-{
-	rq->curr->sched_class->check_preempt_curr(rq, p, flags);
-}
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags);
 
 static inline int cpu_of(struct rq *rq)
 {
@@ -2392,6 +2388,24 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
+static void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
+{
+	const struct sched_class *class;
+
+	if (p->sched_class == rq->curr->sched_class) {
+		rq->curr->sched_class->check_preempt_curr(rq, p, flags);
+	} else {
+		for_each_class(class) {
+			if (class == rq->curr->sched_class)
+				break;
+			if (class == p->sched_class) {
+				resched_task(rq->curr);
+				break;
+			}
+		}
+	}
+}
+
 #ifdef CONFIG_SMP
 /*
  * ->cpus_allowed is protected by either TASK_WAKING or rq->lock held.
-- 
1.7.4


