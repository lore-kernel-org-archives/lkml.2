Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615Ab1EAN37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:29:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44631 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240Ab1EANWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:36 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 65/86] perf,rcu: convert call_rcu(free_ctx) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:45 -0700
Message-Id: <1304256126-26015-65-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_ctx() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_ctx).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/perf_event.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 27960f1..865c6f7 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -585,14 +585,6 @@ static void get_ctx(struct perf_event_context *ctx)
 	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
 }
 
-static void free_ctx(struct rcu_head *head)
-{
-	struct perf_event_context *ctx;
-
-	ctx = container_of(head, struct perf_event_context, rcu_head);
-	kfree(ctx);
-}
-
 static void put_ctx(struct perf_event_context *ctx)
 {
 	if (atomic_dec_and_test(&ctx->refcount)) {
@@ -600,7 +592,7 @@ static void put_ctx(struct perf_event_context *ctx)
 			put_ctx(ctx->parent_ctx);
 		if (ctx->task)
 			put_task_struct(ctx->task);
-		call_rcu(&ctx->rcu_head, free_ctx);
+		kfree_rcu(ctx, rcu_head);
 	}
 }
 
-- 
1.7.3.2

