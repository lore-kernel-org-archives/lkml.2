Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1FHTiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:38:03 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44613 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1FHTaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH tip/core/rcu 12/28] block,rcu: Convert call_rcu(cfq_cfqd_free) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:29:51 -0700
Message-Id: <1307561407-13809-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback cfq_cfqd_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(cfq_cfqd_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 block/cfq-iosched.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5b52011..6f2a460 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3816,11 +3816,6 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
 		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
-static void cfq_cfqd_free(struct rcu_head *head)
-{
-	kfree(container_of(head, struct cfq_data, rcu));
-}
-
 static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
@@ -3854,7 +3849,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_unlock(&cic_index_lock);
 
 	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
-	call_rcu(&cfqd->rcu, cfq_cfqd_free);
+	kfree_rcu(cfqd, rcu);
 }
 
 static int cfq_alloc_cic_index(void)
-- 
1.7.3.2

