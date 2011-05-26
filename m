Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1EZQBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:01:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55131 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1EZQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oU6+jvUR0OPc1EU9qYl1PVeOcXC7woZaXVVMFJnCTWtHQz8DyvK865KMsu8nIPnK1S
         uVqKg55+0Cwljsy+7nDnI2D6l/Mlr8Z8W/bdeLavvSq6A6nXETGr/M3r+O8NPw23jhNu
         HN3SPwqjZW7/A+B43mmktd2kZ1Bdk7yYN+WfI=
Date: Thu, 26 May 2011 19:01:37 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched_rt: RCU-protect for_each_domain() within
 find_lowest_rq()
Message-ID: <20110526160137.GA5716@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect for_each_domain() within find_lowest_rq() with RCU read-side critical 
section, suppressing suspicious rcu_dereference_check():

[ 2752.503488] ===================================================
[ 2752.503494] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 2752.503497] ---------------------------------------------------
[ 2752.503501] kernel/sched_rt.c:1266 invoked rcu_dereference_check() without protection!
[ 2752.503504] 
[ 2752.503505] other info that might help us debug this:
[ 2752.503506] 
[ 2752.503510] rcu_scheduler_active = 1, debug_locks = 0
[ 2752.503514] 3 locks held by rcub0/9:
[ 2752.503517]  #0:  (&lock->wait_lock){+.+...}, at: [<ffffffff81479294>] rt_mutex_slowlock+0x34/0x154
[ 2752.503534]  #1:  (&p->pi_lock){-.-.-.}, at: [<ffffffff810768ab>] task_blocks_on_rt_mutex+0x124/0x1d1
[ 2752.503547]  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff8103844b>] rt_mutex_setprio+0x5f/0x252
[ 2752.503559] 
[ 2752.503569] Call Trace:
[ 2752.503579]  [<ffffffff8106e5ab>] lockdep_rcu_dereference+0xa7/0xaf
[ 2752.503587]  [<ffffffff8102b089>] find_lowest_rq+0x131/0x1ad
[ 2752.503593]  [<ffffffff810370d4>] push_rt_task.part.133+0x89/0x247
[ 2752.503599]  [<ffffffff810372bc>] switched_to_rt+0x2a/0x65
[ 2752.503605]  [<ffffffff810385b4>] rt_mutex_setprio+0x1c8/0x252
[ 2752.503610]  [<ffffffff81076398>] __rt_mutex_adjust_prio+0x1d/0x21
[ 2752.503616]  [<ffffffff810768e7>] task_blocks_on_rt_mutex+0x160/0x1d1
[ 2752.503622]  [<ffffffff8147931c>] rt_mutex_slowlock+0xbc/0x154
[ 2752.503629]  [<ffffffff814793c6>] rt_mutex_lock+0x12/0x14
[ 2752.503637]  [<ffffffff810a4402>] rcu_boost+0xad/0xe1
[ 2752.503644]  [<ffffffff81479fe2>] ? _raw_spin_unlock_irqrestore+0x56/0x74
[ 2752.503652]  [<ffffffff8105d883>] ? finish_wait+0x5e/0x67
[ 2752.503657]  [<ffffffff810a4509>] rcu_boost_kthread+0xd3/0xfc
[ 2752.503663]  [<ffffffff8105d7c6>] ? __init_waitqueue_head+0x46/0x46
[ 2752.503669]  [<ffffffff810a4436>] ? rcu_boost+0xe1/0xe1
[ 2752.503675]  [<ffffffff8105cf6e>] kthread+0x9a/0xa2
[ 2752.503683]  [<ffffffff814810e4>] kernel_thread_helper+0x4/0x10
[ 2752.503689]  [<ffffffff8102d80c>] ? finish_task_switch+0x76/0xf0
[ 2752.503695]  [<ffffffff8147a4d8>] ? retint_restore_args+0x13/0x13
[ 2752.503701]  [<ffffffff8105ced4>] ? __init_kthread_worker+0x53/0x53
[ 2752.503707]  [<ffffffff814810e0>] ? gs_change+0x13/0x13


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 kernel/sched_rt.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 64b2a37..242e476 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1263,6 +1263,7 @@ static int find_lowest_rq(struct task_struct *task)
 	if (!cpumask_test_cpu(this_cpu, lowest_mask))
 		this_cpu = -1; /* Skip this_cpu opt if not among lowest */
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
 			int best_cpu;
@@ -1272,15 +1273,20 @@ static int find_lowest_rq(struct task_struct *task)
 			 * remote processor.
 			 */
 			if (this_cpu != -1 &&
-			    cpumask_test_cpu(this_cpu, sched_domain_span(sd)))
-				return this_cpu;
+			    cpumask_test_cpu(this_cpu, sched_domain_span(sd))) {
+				cpu = this_cpu;
+				goto out_unlock;
+			}
 
 			best_cpu = cpumask_first_and(lowest_mask,
 						     sched_domain_span(sd));
-			if (best_cpu < nr_cpu_ids)
-				return best_cpu;
+			if (best_cpu < nr_cpu_ids) {
+				cpu = best_cpu;
+				goto out_unlock;
+			}
 		}
 	}
+	rcu_read_unlock();
 
 	/*
 	 * And finally, if there were no matches within the domains
@@ -1294,6 +1300,10 @@ static int find_lowest_rq(struct task_struct *task)
 	if (cpu < nr_cpu_ids)
 		return cpu;
 	return -1;
+
+out_unlock:
+	rcu_read_unlock();
+	return cpu;
 }
 
 /* Will lock the rq it finds */

