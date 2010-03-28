Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0C1DMA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 23:12:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53209 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab0C1DL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 23:11:59 -0400
Message-ID: <4BAEC91E.8000001@cn.fujitsu.com>
Date: Sun, 28 Mar 2010 11:12:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: move some code from macro to function
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cleanup: move some code from macro to function

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3ec8160..112edb5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1849,6 +1849,14 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 			INIT_LIST_HEAD(&rnp->blocked_tasks[3]);
 		}
 	}
+
+	rnp = rsp->level[NUM_RCU_LVLS - 1];
+	for_each_possible_cpu(i) {
+		if (i > rnp->grphi)
+			rnp++;
+		rsp->rda[i]->mynode = rnp;
+		rcu_boot_init_percpu_data(i, rsp);
+	}
 }
 
 /*
@@ -1859,19 +1867,11 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 #define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
 	int i; \
-	int j; \
-	struct rcu_node *rnp; \
 	\
-	rcu_init_one(rsp); \
-	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
-	j = 0; \
 	for_each_possible_cpu(i) { \
-		if (i > rnp[j].grphi) \
-			j++; \
-		per_cpu(rcu_data, i).mynode = &rnp[j]; \
 		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
-		rcu_boot_init_percpu_data(i, rsp); \
 	} \
+	rcu_init_one(rsp); \
 } while (0)
 
 void __init rcu_init(void)

