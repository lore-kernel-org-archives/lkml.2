Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab1EANcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:32:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38387 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756810Ab1EANWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:33 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 53/86] net,rcu: convert call_rcu(free_dm_hw_stat) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:33 -0700
Message-Id: <1304256126-26015-53-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_dm_hw_stat() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_dm_hw_stat).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 net/core/drop_monitor.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 706502f..7f36b38 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -207,14 +207,6 @@ static void trace_napi_poll_hit(void *ignore, struct napi_struct *napi)
 	rcu_read_unlock();
 }
 
-
-static void free_dm_hw_stat(struct rcu_head *head)
-{
-	struct dm_hw_stat_delta *n;
-	n = container_of(head, struct dm_hw_stat_delta, rcu);
-	kfree(n);
-}
-
 static int set_all_monitor_traces(int state)
 {
 	int rc = 0;
@@ -245,7 +237,7 @@ static int set_all_monitor_traces(int state)
 		list_for_each_entry_safe(new_stat, temp, &hw_stats_list, list) {
 			if (new_stat->dev == NULL) {
 				list_del_rcu(&new_stat->list);
-				call_rcu(&new_stat->rcu, free_dm_hw_stat);
+				kfree_rcu(new_stat, rcu);
 			}
 		}
 		break;
@@ -314,7 +306,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				new_stat->dev = NULL;
 				if (trace_state == TRACE_OFF) {
 					list_del_rcu(&new_stat->list);
-					call_rcu(&new_stat->rcu, free_dm_hw_stat);
+					kfree_rcu(new_stat, rcu);
 					break;
 				}
 			}
-- 
1.7.3.2

