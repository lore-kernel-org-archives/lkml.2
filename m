Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1KVOao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:30:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab1KVO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:29:12 -0500
Subject: [patch 2/7] sched: save some hrtick_start_fair cycles
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321971445.6855.14.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 15:20:07 +0100
Message-ID: <1321971607.6855.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hrtick_start_fair() shows up in profiles even when disabled.

v3.0.6

taskset -c 3 pipe-test

   PerfTop:     997 irqs/sec  kernel:89.5%  exact:  0.0% [1000Hz cycles],  (all, CPU: 3)
------------------------------------------------------------------------------------------------

             Virgin                                    Patched
             samples  pcnt function                    samples  pcnt function
             _______ _____ ___________________________ _______ _____ ___________________________

             2880.00 10.2% __schedule                  3136.00 11.3% __schedule
             1634.00  5.8% pipe_read                   1615.00  5.8% pipe_read
             1458.00  5.2% system_call                 1534.00  5.5% system_call
             1382.00  4.9% _raw_spin_lock_irqsave      1412.00  5.1% _raw_spin_lock_irqsave
             1202.00  4.3% pipe_write                  1255.00  4.5% copy_user_generic_string
             1164.00  4.1% copy_user_generic_string    1241.00  4.5% __switch_to
             1097.00  3.9% __switch_to                  929.00  3.3% mutex_lock
              872.00  3.1% mutex_lock                   846.00  3.0% mutex_unlock
              687.00  2.4% mutex_unlock                 804.00  2.9% pipe_write
              682.00  2.4% native_sched_clock           713.00  2.6% native_sched_clock
              643.00  2.3% system_call_after_swapgs     653.00  2.3% _raw_spin_unlock_irqrestore
              617.00  2.2% sched_clock_local            633.00  2.3% fsnotify
              612.00  2.2% fsnotify                     605.00  2.2% sched_clock_local
              596.00  2.1% _raw_spin_unlock_irqrestore  593.00  2.1% system_call_after_swapgs
              542.00  1.9% sysret_check                 559.00  2.0% sysret_check
              467.00  1.7% fget_light                   472.00  1.7% fget_light
              462.00  1.6% finish_task_switch           461.00  1.7% finish_task_switch
              437.00  1.5% vfs_write                    442.00  1.6% vfs_write
              431.00  1.5% do_sync_write                428.00  1.5% do_sync_write
              413.00  1.5% select_task_rq_fair          404.00  1.5% _raw_spin_lock_irq
              386.00  1.4% update_curr                  402.00  1.4% update_curr
              385.00  1.4% rw_verify_area               389.00  1.4% do_sync_read
              377.00  1.3% _raw_spin_lock_irq           378.00  1.4% vfs_read
              369.00  1.3% do_sync_read                 340.00  1.2% pipe_iov_copy_from_user
              360.00  1.3% vfs_read                     316.00  1.1% __wake_up_sync_key
*             342.00  1.2% hrtick_start_fair            313.00  1.1% __wake_up_common

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/fair.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-3.0-tip/kernel/sched/fair.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/fair.c
+++ linux-3.0-tip/kernel/sched/fair.c
@@ -2135,7 +2135,7 @@ static void hrtick_start_fair(struct rq
 
 	WARN_ON(task_rq(p) != rq);
 
-	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
+	if (cfs_rq->nr_running > 1) {
 		u64 slice = sched_slice(cfs_rq, se);
 		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
 		s64 delta = slice - ran;
@@ -2166,7 +2166,7 @@ static void hrtick_update(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class)
+	if (!hrtick_enabled(rq) || curr->sched_class != &fair_sched_class)
 		return;
 
 	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
@@ -3017,7 +3017,8 @@ static struct task_struct *pick_next_tas
 	} while (cfs_rq);
 
 	p = task_of(se);
-	hrtick_start_fair(rq, p);
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
 
 	return p;
 }


