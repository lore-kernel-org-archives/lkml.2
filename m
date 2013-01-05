Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3AERs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 12:48:57 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53156 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab3AERsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 12:48:55 -0500
Date: Sat, 5 Jan 2013 09:48:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/14] RCU idle/no-CB changes for 3.9
Message-ID: <20130105174844.GA14172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010517-4834-0000-0000-0000023FCA6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This series contains changes to RCU_FAST_NO_HZ idle entry/exit and also
removes restrictions on no-CBs CPUs.  This series contains some commits
that are still rather experimental, so you should avoid using these patches
unless you would like to help debug them.  ;-)

1.	Tag callback lists with the grace-period number that they are
	waiting for.  This change enables a number of optimizations
	for RCU_FAST_NO_HZ, and though it add a bit of code, it greatly
	simplifies RCU's callback handling.
2.	Trace callback acceleration (which is when RCU notices that a
	group of callbacks doesn't actually need to wait as long as it
	previously thought).
3.	Remove restrictions on no-CBs CPUs.  This patch is probably the
	highest-risk of the group.
4.	Allow some control of no-CBs CPUs at kernel-build time.  The option
	of most interest is probably the one that makes -all- CPUs be
	no-CBs CPUs.
5.	Distinguish the no-CBs kthreads for the various RCU flavors.
	Without this patch, CPU 0 would have up to three kthreads all
	named "rcuo0", which is less than optimal.
6.	Export RCU_FAST_NO_HZ parameters to sysfs to allow run-time
	adjustment.
7.	Re-introduce callback acceleration during grace-period cleanup.
	Now that the callbacks are associated with specific grace periods,
	such acceleration is idempotent, and it is now safe to accelerate
	more than needed.  (In contrast, in the past, too-frequent callback
	acceleration resulted in infrequent RCU failures.)
8.	Use the newly numbered callbacks to greatly reduce the CPU overhead
	incurred at idle entry by RCU_FAST_NO_HZ.  The fact that the
	callbacks are now numbered means that instead of repeatedly
	cranking the RCU state machine to try to get all callbacks
	invoked, we can instead rely on the numbering so that the CPU
	can take full advantage of any grace periods that elapse while
	it is asleep.  CPUs with callbacks still have limited sleep times,
	especially if they have at least one non-lazy callback queued.
9-14.	Allow CPUs to make known their need for future grace periods,
	which is also used to reduce the need for frenetic RCU
	state-machine cranking upon RCU_FAST_NO_HZ entry to idle.
	9.	Move the release of the root rcu_node structure's ->lock
		to then end of rcu_start_gp().
	10.	Repurpose no-CB's grace-period event tracing to that of
		future grace periods, which share no-CB's grace-period
		mechanism.
	11.	Move the release of the root rcu_node structure's ->lock
		to rcu_start_gp()'s callers.
	12.	Rename the rcu_node ->n_nocb_gp_requests field to
		->need_future_gp.
	13.	Abstract rcu_start_future_gp() from rcu_nocb_wait_gp()
		to that RCU_FAST_NO_HZ can use the no-CB CPUs mechanism
		for allowing a CPU to record its need for future grace
		periods.
	14.	Make rcu_accelerate_cbs() note the need for future
		grace periods, thus avoiding delays in starting grace
		periods that currently happen due to the CPUs needing
		those grace periods being out of action when the previous
		grace period ends.

								Thanx, Paul


 b/include/linux/rcupdate.h   |    1 
 b/include/trace/events/rcu.h |   77 +++
 b/init/Kconfig               |   17 
 b/kernel/rcutree.c           |  475 ++++++++++++++++++-----
 b/kernel/rcutree.h           |   39 -
 b/kernel/rcutree_plugin.h    |  859 ++++++++++++++++++-------------------------
 b/kernel/rcutree_trace.c     |    2 
 7 files changed, 848 insertions(+), 622 deletions(-)

