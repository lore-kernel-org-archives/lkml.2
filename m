Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2ITSso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:48:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41907 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab2ITSsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:48:42 -0400
Date: Thu, 20 Sep 2012 11:47:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/23] v2 Improvements to RT response on big
 systems and expedited functions
Message-ID: <20120920184751.GA18657@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092018-5930-0000-0000-00000C4D6947
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch series contains additional improvements to latency for
large systems (beyond those in 3.6), along with improvements to
synchronize_rcu_expedited().  It also fixes one race introduced by the
latency improvements and another that was there to start with (but made
more probable by the latency improvements).  These are in a single
series due to conflicts that would otherwise occur.  The individual
patches are as follows:

1-6.	Move RCU grace-period initialization and cleanup into a kthread:
	1.	Move RCU grace-period initialization into kthread.
	2.	Prevent initialization-time quiescent-state race.
	3.	Allow RCU grace-period initialization to be preempted.
	4.	Move RCU grace-period cleanup into kthread.
	5.	Allow RCU grace-period cleanup to be preempted.
	6.	Break up rcu_gp_kthread() into subfunctions.
7.	Prevent offline CPUs from executing RCU core code.
8.	Provide an OOM handler to allow lazy callbacks to be motivated
	under memory pressure.
9.	Segregate rcu_state fields to improve cache locality
	(Courtesy of Dimitri Sivanich).
10-13.	Move RCU grace-period forcing into a kthread.
	10.	Move quiescent-state forcing into kthread.
	11.	Allow RCU quiescent-state forcing to be preempted.
	12.	Adjust debugfs tracing for kthread-based quiescent-state
		forcing.
	13.	Prevent force_quiescent_state() memory contention.
14.	Control grace-period duration from sysfs.
15.	Make rcutree module parameters visible in sysfs.
16.	Fix day-zero grace-period initialization/cleanup race.
17.	Add random PROVE_RCU_DELAY to provoke initalization races.
18.	Adjust for unconditional ->completed assignment.	
19.	Eliminate signed overflow in synchronize_rcu_expedited().
20.	Reduce synchronize_rcu_expedited() latency.
21.	Simplify quiescent-state detection.
22.	Correctly handle reconfiguring to larger leaf fanout in the
	case of CONFIG_RCU_FANOUT_EXACT=y.  (New in this posting.)
23.	Shrink RCU when there is a smaller number of CPUs than the
	kernel was built for (NR_CPUS < nr_cpu_ids) even when the
	leaf fanout did not change.  (New in this posting.)

Changes from v1 (https://lkml.org/lkml/2012/8/30/171):

o	Incorporated feedback from that posting (thank you Peter, Josh,
	and Lai!).  This involves some serious rebasing, so the patch
	numbers do not match v1.

o	Added patches #22 and #23 above.

							Thanx, Paul

 b/Documentation/RCU/trace.txt         |   43 -
 b/Documentation/kernel-parameters.txt |   11 
 b/kernel/rcutree.c                    |  970 ++++++++++++++++++----------------
 b/kernel/rcutree.h                    |   28 
 b/kernel/rcutree_plugin.h             |  131 +++-
 b/kernel/rcutree_trace.c              |   15 
 6 files changed, 680 insertions(+), 518 deletions(-)

