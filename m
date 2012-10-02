Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2JBRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:20:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49560 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2JBRUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:20:30 -0400
Date: Tue, 2 Oct 2012 10:01:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
Message-ID: <20121002170149.GC2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100217-2876-0000-0000-000000AAE71C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 06:14:08PM +0200, Jiri Kosina wrote:
> Hi,
> 
> this commit:
> 
> ==
> 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is the first bad commit
> commit 1331e7a1bbe1f11b19c4327ba0853bee2a606543
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Thu Aug 2 17:43:50 2012 -0700
> 
>     rcu: Remove _rcu_barrier() dependency on __stop_machine()
>     
>     Currently, _rcu_barrier() relies on preempt_disable() to prevent
>     any CPU from going offline, which in turn depends on CPU hotplug's
>     use of __stop_machine().
>     
>     This patch therefore makes _rcu_barrier() use get_online_cpus() to
>     block CPU-hotplug operations.  This has the added benefit of removing
>     the need for _rcu_barrier() to adopt callbacks:  Because CPU-hotplug
>     operations are excluded, there can be no callbacks to adopt.  This
>     commit simplifies the code accordingly.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ==
> 
> is causing lockdep to complain (see the full trace below). I haven't yet 
> had time to analyze what exactly is happening, and probably will not have 
> time to do so until tomorrow, so just sending this as a heads-up in case 
> anyone sees the culprit immediately.

Hmmm...  Does the following patch help?  It swaps the order in which
rcu_barrier() acquires the hotplug and rcu_barrier locks.

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 2ad9e81..2c71d61 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2560,6 +2560,9 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	_rcu_barrier_trace(rsp, "Begin", -1, snap);
 
+	/* Exclude CPU-hotplug, ensuring that no offline CPU has callbacks. */
+	get_online_cpus();
+
 	/* Take mutex to serialize concurrent rcu_barrier() requests. */
 	mutex_lock(&rsp->barrier_mutex);
 
@@ -2581,6 +2584,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 		_rcu_barrier_trace(rsp, "EarlyExit", -1, snap_done);
 		smp_mb(); /* caller's subsequent code after above check. */
 		mutex_unlock(&rsp->barrier_mutex);
+		put_online_cpus();
 		return;
 	}
 
@@ -2597,8 +2601,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	/*
 	 * Initialize the count to one rather than to zero in order to
 	 * avoid a too-soon return to zero in case of a short grace period
-	 * (or preemption of this task).  Exclude CPU-hotplug operations
-	 * to ensure that no offline CPU has callbacks queued.
+	 * (or preemption of this task).
 	 */
 	init_completion(&rsp->barrier_completion);
 	atomic_set(&rsp->barrier_cpu_count, 1);
@@ -2620,7 +2623,6 @@ static void _rcu_barrier(struct rcu_state *rsp)
 					   rsp->n_barrier_done);
 		}
 	}
-	put_online_cpus();
 
 	/*
 	 * Now that we have an rcu_barrier_callback() callback on each
@@ -2639,8 +2641,9 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
 	wait_for_completion(&rsp->barrier_completion);
 
-	/* Other rcu_barrier() invocations can now safely proceed. */
+	/* Hotplug and rcu_barrier() invocations can now safely proceed. */
 	mutex_unlock(&rsp->barrier_mutex);
+	put_online_cpus();
 }
 
 /**

