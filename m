Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2FVP0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:31 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53480 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab2FVP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:25 -0400
Date: Fri, 22 Jun 2012 08:16:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/22] v2 Improvements to rcu_barrier() and RT
 response on big systems
Message-ID: <20120622151655.GA6249@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6BD0F
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150292; UDB=6.00034140; UTC=2012-06-22
 15:26:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains improvements to the rcu_barrier() family
of primitives and to latency for large systems.  These are in a
single series due to conflicts that would otherwise occur.  This is an
update from version 1 posted at: https://lkml.org/lkml/2012/6/15/509.
The individual patches are as follows:

1.	Allow the value for RCU_FANOUT_LEAF to be increased (but not
	decreased!) via a boot-time parameter, in turn allowing a
	default kernel build to be adjusted for low RCU grace-period
	initialization latency on a large system.
2.	Stop flagging a four-level rcu_node hierarchy as "experimental".
3.	Work around the new default NR_CPUS=4096 by checking the
	boot-time-computed nr_cpu_ids, allowing this to override
	NR_CPUS.  This again reduces RCU grace-period initialization
	latency for kernels built with large NR_CPUS running on small
	systems.
4.	Shrink a macro argument to keep lines under 80 characters.
5.	Add a pointer in the rcu_state structure to the corresponding
	member of the call_rcu() family of functions in preparation
	for increasing rcu_barrier() concurrency.
6.	Move _rcu_barrier()'s rcu_head structures to the per-CPU
	per-RCU-flavor rcu_data structures so that different flavors
	of rcu_barrier() do not need to contend for the rcu_head
	structures.
7.	Move rcu_barrier()'s rcu_barrier_cpu_count global variable to
	a new ->barrier_cpu_count field in the rcu_state structure, so
	that different flavors of rcu_barrier() do not need to contend
	for this variable.
8.	Move rcu_barrier()'s rcu_barrier_completion global variable to
	a new ->barrier_completion field in the rcu_state structure, so
	that different flavors of rcu_barrier() do not need to contend
	for this variable.
9.	Move rcu_barrier()'s rcu_barrier_mutex global variable to
	a new ->barrier_mutex field in the rcu_state structure, so that
	different flavors of rcu_barrier() do not need to contend for
	this variable.
10.	Remove redundant initialization to zero of the rcu_state structure's
	->n_force_qs and ->n_force_qs_ngp fields.
11.	Introduce counter scheme to allow multiple concurrent executions
	of a given flavor of rcu_barrier() to share work.
12.	Add event tracing for _rcu_barrier().
13.	Add debugfs tracing for _rcu_barrier().
14.	Remove unnecessary per-CPU variable argument from
	__rcu_process_callbacks().
15.	Introduce for_each_rcu_flavor() iterator and use it.  This provides
	a nicer way to iterate through the RCU flavors to do per-flavor
	processing.
16.	Apply the for_each_rcu_flavor() iterator to debugfs tracing.
17.	Remove dead-code gcc helper from code that is no longer ever dead.
18.	Move RCU grace-period initialization into a kthread.
19.	Allow RCU grace-period initialization to be preempted, including
	cond_resched() preemption points for CONFIG_PREEMPT=n systems.
20.	Move RCU grace-period cleanup into a kthread.
21.	Allow RCU grace-period cleanup to be preempted, including
	cond_resched() preemption points for CONFIG_PREEMPT=n systems.
22.	Prevent offline CPUs from executing RCU core code.

Changes from version 1:

o	Apply review comments from Josh Triplett and Steven Rostedt.
o	Added patches 18-22 to reduce scheduling-latency spikes from
	RCU initialization and cleanup on large systems.

							Thanx, Paul

 b/Documentation/kernel-parameters.txt |    5 
 b/include/trace/events/rcu.h          |   45 ++
 b/kernel/rcutree.c                    |   97 +++++
 b/kernel/rcutree.h                    |   23 -
 b/kernel/rcutree_plugin.h             |    2 
 b/kernel/rcutree_trace.c              |    2 
 kernel/rcutree.c                      |  555 +++++++++++++++++++++-------------
 kernel/rcutree.h                      |   25 +
 kernel/rcutree_plugin.h               |  128 -------
 kernel/rcutree_trace.c                |  155 +++++----
 10 files changed, 604 insertions(+), 433 deletions(-)

