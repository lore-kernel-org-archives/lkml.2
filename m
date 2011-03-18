Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1CREH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:07:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab1CREHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:07:50 -0400
Message-ID: <4D82DAFF.3010401@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:09:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 29/36] ipc,rcu: convert call_rcu(free_un) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:06:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:06:27,
	Serialize complete at 2011-03-18 12:06:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback free_un() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(free_un).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 ipc/sem.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 0e0d49b..243437e 100644
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
@@ -1610,7 +1604,7 @@ void exit_sem(struct task_struct *tsk)
 		sem_unlock(sma);
 		wake_up_sem_queue_do(&tasks);
 
-		call_rcu(&un->rcu, free_un);
+		kfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }
-- 
1.7.4
