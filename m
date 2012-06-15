Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2FOVIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:08:52 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42211 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab2FOVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:08:48 -0400
Date: Fri, 15 Jun 2012 14:05:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/15] Improvements to rcu_barrier() and RT
 response on big systems
Message-ID: <20120615210550.GA27506@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-4242-0000-0000-000001FB32DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains improvements to the rcu_barrier() family of
primitives and to latency for large systems.  These are in a single
series due to conflicts that would otherwise occur.  The individual
patches are as follows:

1.	Allow the value for RCU_FANOUT_LEAF to be increased (but not
	decreased!) via a boot-time parameter, in turn allowing a
	default kernel build to be adjusted for low RCU grace-period
	initialization latency on a large system.
2.	Work around the new default NR_CPUS=4096 by checking the
	boot-time-computed nr_cpu_ids, allowing this to override
	NR_CPUS.  This again reduces RCU grace-period initialization
	latency for kernels built with large NR_CPUS running on small
	systems.
3.	Shrink a macro argument to keep lines under 80 characters.
4.	Add a pointer in the rcu_state structure to the corresponding
	member of the call_rcu() family of functions in preparation
	for increasing rcu_barrier() concurrency.
5.	Move _rcu_barrier()'s rcu_head structures to the per-CPU
	per-RCU-flavor rcu_data structures so that different flavors
	of rcu_barrier() do not need to contend for the rcu_head
	structures.
6.	Move rcu_barrier()'s rcu_barrier_cpu_count global variable to
	a new ->barrier_cpu_count field in the rcu_state structure, so
	that different flavors of rcu_barrier() do not need to contend
	for this variable.
7.	Move rcu_barrier()'s rcu_barrier_completion global variable to
	a new ->barrier_completion field in the rcu_state structure, so
	that different flavors of rcu_barrier() do not need to contend
	for this variable.
8.	Move rcu_barrier()'s rcu_barrier_mutex global variable to
	a new ->barrier_mutex field in the rcu_state structure, so that
	different flavors of rcu_barrier() do not need to contend for
	this variable.
9.	Introduce counter scheme to allow multiple concurrent executions
	of a given flavor of rcu_barrier() to share work.
10.	Add event tracing for _rcu_barrier().
11.	Add debugfs tracing for _rcu_barrier().
12.	Remove unnecessary per-CPU variable argument from
	__rcu_process_callbacks().
13.	Introduce for_each_rcu_flavor() iterator and use it.  This provides
	a nicer way to iterate through the RCU flavors to do per-flavor
	processing.
14.	Apply the for_each_rcu_flavor() iterator to debugfs tracing.
15.	Remove dead-code gcc helper from code that is no longer ever dead.

							Thanx, Paul

 b/Documentation/kernel-parameters.txt |    4 
 b/include/trace/events/rcu.h          |   45 +++++++
 b/kernel/rcutree.c                    |   97 +++++++++++++--
 b/kernel/rcutree.h                    |   23 ++-
 b/kernel/rcutree_plugin.h             |    4 
 b/kernel/rcutree_trace.c              |    2 
 kernel/rcutree.c                      |  213 +++++++++++++++++++++-------------
 kernel/rcutree.h                      |   22 ++-
 kernel/rcutree_plugin.h               |  126 --------------------
 kernel/rcutree_trace.c                |  134 ++++++++++++---------
 10 files changed, 379 insertions(+), 291 deletions(-)

