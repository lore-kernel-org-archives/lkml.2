Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2HHT7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:59:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54679 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2HHT7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:59:13 -0400
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20120807171859.GB3850@linux.vnet.ibm.com>
References: <20120807123305.GA7137@linux.vnet.ibm.com>
	 <1344347568.27828.122.camel@twins>
	 <20120807171859.GB3850@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 21:58:58 +0200
Message-ID: <1344455938.16728.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 22:49 +0530, Srikar Dronamraju wrote:
> Are you referring to this the commit 158e1645e (trim task_work: get rid of hlist)

No, to something like the below..

> I am also able to reproduce this on another 8 node machine too.

Ship me one ;-)

> Just to update, I had to revert commit: b9403130a5  sched/cleanups: Add
> load balance cpumask pointer to 'struct lb_env' so that your patches
> apply cleanly. (I dont think this should have caused any problem.. but)

Yeah, I've got a rebase on top of that.. just wanted fold this
page::last_nid thing into the page::flags before posting again.

---
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1539,6 +1539,7 @@ struct task_struct {
 #ifdef CONFIG_SMP
 	u64 node_stamp;			/* migration stamp  */
 	unsigned long numa_contrib;
+	struct callback_head numa_work;
 #endif /* CONFIG_SMP  */
 #endif /* CONFIG_NUMA */
 	struct rcu_head rcu;
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -816,7 +816,7 @@ void task_numa_work(struct callback_head
 	struct task_struct *t, *p = current;
 	int node = p->node_last;
 
-	WARN_ON_ONCE(p != container_of(work, struct task_struct, rcu));
+	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
 	/*
 	 * Who cares about NUMA placement when they're dying.
@@ -891,8 +891,8 @@ void task_tick_numa(struct rq *rq, struc
 			 * yet and exit_task_work() is called before
 			 * exit_notify().
 			 */
-			init_task_work(&curr->rcu, task_numa_work);
-			task_work_add(curr, &curr->rcu, true);
+			init_task_work(&curr->numa_work, task_numa_work);
+			task_work_add(curr, &curr->numa_work, true);
 		}
 		curr->node_last = node;
 	}


