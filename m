Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0JYPqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:46:04 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47458 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab0JYPqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:46:03 -0400
Date: Mon, 25 Oct 2010 08:43:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Question about synchronize_sched_expedited()
Message-ID: <20101025154358.GA6919@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tejun,

I was taking another look at synchronize_sched_expedited(), and was
concerned about the scenario listed out in the following commit.
Is this scenario a real problem, or am I missing the synchronization
that makes it safe?

(If my concerns are valid, I should also be able to change this
to non-atomically increment synchronize_sched_expedited_count, but
one step at a time...)

						Thanx, Paul

------------------------------------------------------------------------

commit 1c2f788a742b87f8fae692b0b3014732124ee3c6
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Oct 25 07:39:22 2010 -0700

    rcu: fix race condition in synchronize_sched_expedited()
    
    The new (early 2010) implementation of synchronize_sched_expedited() uses
    try_stop_cpu() to force a context switch on every CPU.  It also permits
    concurrent calls to synchronize_sched_expedited() to share a single call
    to try_stop_cpu() through use of an atomically incremented
    synchronize_sched_expedited_count variable.  Unfortunately, this is
    subject to failure as follows:
    
    o	Task A invokes synchronize_sched_expedited(), try_stop_cpus()
    	succeeds, but Task A is preempted before getting to the atomic
    	increment of synchronize_sched_expedited_count.
    
    o	Task B also invokes synchronize_sched_expedited(), with exactly
    	the same outcome as Task A.
    
    o	Task C also invokes synchronize_sched_expedited(), again with
    	exactly the same outcome as Tasks A and B.
    
    o	Task D also invokes synchronize_sched_expedited(), but only
    	gets as far as acquiring the mutex within try_stop_cpus()
    	before being preempted, interrupted, or otherwise delayed.
    
    o	Task E also invokes synchronize_sched_expedited(), but only
    	gets to the snapshotting of synchronize_sched_expedited_count.
    
    o	Tasks A, B, and C all increment synchronize_sched_expedited_count.
    
    o	Task E fails to get the mutex, so checks the new value
    	of synchronize_sched_expedited_count.  It finds that the
    	value has increased, so (wrongly) assumes that its work
    	has been done, returning despite there having been no
    	expedited grace period since it began.
    
    The solution is to have the lowest-numbered CPU atomically increment
    the synchronize_sched_expedited_count variable within the
    synchronize_sched_expedited_cpu_stop() function, which is under
    the protection of the mutex acquired by try_stop_cpus().
    
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 32e76d4..16bf339 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1041,6 +1041,8 @@ static int synchronize_sched_expedited_cpu_stop(void *data)
 	 * robustness against future implementation changes.
 	 */
 	smp_mb(); /* See above comment block. */
+	if (cpumask_first(cpu_online_mask) == smp_processor_id())
+		atomic_inc(&synchronize_sched_expedited_count);
 	return 0;
 }
 
@@ -1077,7 +1079,6 @@ void synchronize_sched_expedited(void)
 		}
 		get_online_cpus();
 	}
-	atomic_inc(&synchronize_sched_expedited_count);
 	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
 }
