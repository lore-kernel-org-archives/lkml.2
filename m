Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486Ab1EAN10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:27:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48545 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab1EANWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 84/86] ipc,rcu: convert call_rcu(ipc_immediate_free) to kfree_rcu()
Date: Sun,  1 May 2011 06:22:04 -0700
Message-Id: <1304256126-26015-84-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback ipc_immediate_free() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(ipc_immediate_free).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 ipc/util.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 5c0d289..75261a3 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -579,19 +579,6 @@ static void ipc_schedule_free(struct rcu_head *head)
 	schedule_work(&sched->work);
 }
 
-/**
- * ipc_immediate_free - free ipc + rcu space
- * @head: RCU callback structure that contains pointer to be freed
- *
- * Free from the RCU callback context.
- */
-static void ipc_immediate_free(struct rcu_head *head)
-{
-	struct ipc_rcu_grace *free =
-		container_of(head, struct ipc_rcu_grace, rcu);
-	kfree(free);
-}
-
 void ipc_rcu_putref(void *ptr)
 {
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
@@ -601,8 +588,7 @@ void ipc_rcu_putref(void *ptr)
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
-		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
-				ipc_immediate_free);
+		kfree_rcu(container_of(ptr, struct ipc_rcu_grace, data), rcu);
 	}
 }
 
-- 
1.7.3.2

