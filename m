Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab1KRPWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:22:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37322 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756772Ab1KRPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:22:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18uGb89f5YuwYK2N6IuOcmZWumnr2Kac5ObHVWsTc
	ULnjN/djarhVFz
Subject: [patch 5/6] sched: save some hrtick_start_fair cycles
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321629267.7080.13.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:22:06 +0100
Message-ID: <1321629726.7080.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
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
 kernel/sched_fair.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-3.2.git/kernel/sched_fair.c
===================================================================
--- linux-3.2.git.orig/kernel/sched_fair.c
+++ linux-3.2.git/kernel/sched_fair.c
@@ -1853,7 +1853,7 @@ static void hrtick_start_fair(struct rq
 
 	WARN_ON(task_rq(p) != rq);
 
-	if (hrtick_enabled(rq) && cfs_rq->nr_running > 1) {
+	if (cfs_rq->nr_running > 1) {
 		u64 slice = sched_slice(cfs_rq, se);
 		u64 ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
 		s64 delta = slice - ran;
@@ -1884,7 +1884,7 @@ static void hrtick_update(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
 
-	if (curr->sched_class != &fair_sched_class)
+	if (!hrtick_enabled(rq) || curr->sched_class != &fair_sched_class)
 		return;
 
 	if (cfs_rq_of(&curr->se)->nr_running < sched_nr_latency)
@@ -2643,7 +2643,8 @@ static struct task_struct *pick_next_tas
 	} while (cfs_rq);
 
 	p = task_of(se);
-	hrtick_start_fair(rq, p);
+	if (hrtick_enabled(rq))
+		hrtick_start_fair(rq, p);
 
 	return p;
 }


