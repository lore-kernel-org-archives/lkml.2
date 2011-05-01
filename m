Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab1EAN1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60598 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757473Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>
Subject: [PATCH tip/core/rcu 75/86] security,rcu: convert call_rcu(whitelist_item_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:21:55 -0700
Message-Id: <1304256126-26015-75-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback whitelist_item_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(whitelist_item_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>
---
 security/device_cgroup.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 8d9c48f..e886ab5 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -126,14 +126,6 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 	return 0;
 }
 
-static void whitelist_item_free(struct rcu_head *rcu)
-{
-	struct dev_whitelist_item *item;
-
-	item = container_of(rcu, struct dev_whitelist_item, rcu);
-	kfree(item);
-}
-
 /*
  * called under devcgroup_mutex
  */
@@ -156,7 +148,7 @@ remove:
 		walk->access &= ~wh->access;
 		if (!walk->access) {
 			list_del_rcu(&walk->list);
-			call_rcu(&walk->rcu, whitelist_item_free);
+			kfree_rcu(walk, rcu);
 		}
 	}
 }
-- 
1.7.3.2

