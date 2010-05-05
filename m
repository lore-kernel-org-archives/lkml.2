Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab0EEUb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:31:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60763 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986Ab0EEUbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:31:55 -0400
Date: Wed, 5 May 2010 13:31:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 3/4 UPDATED] scheduler: replace migration_thread with
 cpu_stop
Message-ID: <20100505203149.GA2439@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1272980864-27235-1-git-send-email-tj@kernel.org>
 <1272980864-27235-4-git-send-email-tj@kernel.org>
 <20100505013351.GN2639@linux.vnet.ibm.com>
 <4BE11E29.6040106@kernel.org>
 <20100505174725.GA6783@linux.vnet.ibm.com>
 <4BE1B49F.2020404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE1B49F.2020404@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 08:10:39PM +0200, Tejun Heo wrote:
> Currently migration_thread is serving three purposes - migration
> pusher, context to execute active_load_balance() and forced context
> switcher for expedited RCU synchronize_sched.  All three roles are
> hardcoded into migration_thread() and determining which job is
> scheduled is slightly messy.
> 
> This patch kills migration_thread and replaces all three uses with
> cpu_stop.  The three different roles of migration_thread() are
> splitted into three separate cpu_stop callbacks -
> migration_cpu_stop(), active_load_balance_cpu_stop() and
> synchronize_sched_expedited_cpu_stop() - and each use case now simply
> asks cpu_stop to execute the callback as necessary.
> 
> synchronize_sched_expedited() was implemented with private
> preallocated resources and custom multi-cpu queueing and waiting
> logic, both of which are provided by cpu_stop.
> synchronize_sched_expedited_count is made atomic and all other shared
> resources along with the mutex are dropped.
> 
> synchronize_sched_expedited() also implemented a check to detect cases
> where not all the callback got executed on their assigned cpus and
> fall back to synchronize_sched().  If called with cpu hotplug blocked,
> cpu_stop already guarantees that and the condition cannot happen;
> otherwise, stop_machine() would break.  However, this patch preserves
> the paranoid check using a cpumask to record on which cpus the stopper
> ran so that it can serve as a bisection point if something actually
> goes wrong theree.
> 
> Because the internal execution state is no longer visible,
> rcu_expedited_torture_stats() is removed.
> 
> This patch also renames cpu_stop threads to from "stopper/%d" to
> "migration/%d".  The names of these threads ultimately don't matter
> and there's no reason to make unnecessary userland visible changes.
> 
> With this patch applied, stop_machine() and sched now share the same
> resources.  stop_machine() is faster without wasting any resources and
> sched migration users are much cleaner.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: Josh Triplett <josh@freedesktop.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Dimitri Sivanich <sivanich@sgi.com>
> ---
> Alright, smp_mb() and comments added.  Paul, can you please ack this?

Almost.  With the following patch, I am good with it.

							Thanx, Paul

------------------------------------------------------------------------

commit ab3e147752b1edab4588abd7a66f2505b7b433ed
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Wed May 5 13:28:37 2010 -0700

    sched: correctly place paranioa memory barriers in synchronize_sched_expedited()
    
    The memory barriers must be in the SMP case, not in the !SMP case.
    Also add a barrier after the atomic_inc() in order to ensure that other
    CPUs see post-synchronize_sched_expedited() actions as following the
    expedited grace period.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index e9c6d79..155a16d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8932,6 +8932,15 @@ struct cgroup_subsys cpuacct_subsys = {
 
 void synchronize_sched_expedited(void)
 {
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#else /* #ifndef CONFIG_SMP */
+
+static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
+
+static int synchronize_sched_expedited_cpu_stop(void *data)
+{
 	/*
 	 * There must be a full memory barrier on each affected CPU
 	 * between the time that try_stop_cpus() is called and the
@@ -8943,16 +8952,7 @@ void synchronize_sched_expedited(void)
 	 * necessary.  Do smp_mb() anyway for documentation and
 	 * robustness against future implementation changes.
 	 */
-	smp_mb();
-}
-EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
-
-#else /* #ifndef CONFIG_SMP */
-
-static atomic_t synchronize_sched_expedited_count = ATOMIC_INIT(0);
-
-static int synchronize_sched_expedited_cpu_stop(void *data)
-{
+	smp_mb(); /* See above comment block. */
 	return 0;
 }
 
@@ -8990,6 +8990,7 @@ void synchronize_sched_expedited(void)
 		get_online_cpus();
 	}
 	atomic_inc(&synchronize_sched_expedited_count);
+	smp_mb__after_atomic_inc(); /* ensure post-GP actions seen after GP. */
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
