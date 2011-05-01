Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab1EAN1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48548 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH tip/core/rcu 73/86] block,rcu: convert call_rcu(cfq_cfqd_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:53 -0700
Message-Id: <1304256126-26015-73-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback cfq_cfqd_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(cfq_cfqd_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/cfq-iosched.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3be881e..a157728 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3824,11 +3824,6 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
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
@@ -3862,7 +3857,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_unlock(&cic_index_lock);
 
 	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
-	call_rcu(&cfqd->rcu, cfq_cfqd_free);
+	kfree_rcu(cfqd, rcu);
 }
 
 static int cfq_alloc_cic_index(void)
-- 
1.7.3.2

