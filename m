Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1FHTdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:33:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38154 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab1FHTaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:30:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH tip/core/rcu 22/28] ipc,rcu: Convert call_rcu(free_un) to kfree_rcu()
Date: Wed,  8 Jun 2011 12:30:01 -0700
Message-Id: <1307561407-13809-22-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110608192943.GA13211@linux.vnet.ibm.com>
References: <20110608192943.GA13211@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback free_un() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_un).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 ipc/sem.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 34193ed..8b929e6 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -689,12 +689,6 @@ static int count_semzcnt (struct sem_array * sma, ushort semnum)
 	return semzcnt;
 }
 
-static void free_un(struct rcu_head *head)
-{
-	struct sem_undo *un = container_of(head, struct sem_undo, rcu);
-	kfree(un);
-}
-
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
@@ -714,7 +708,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1612,7 +1606,7 @@ void exit_sem(struct task_struct *tsk)
 		sem_unlock(sma);
 		wake_up_sem_queue_do(&tasks);
 
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
-- 
1.7.3.2

