Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2H3SSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:18:44 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46378 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2H3SSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:18:43 -0400
Date: Thu, 30 Aug 2012 11:18:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: [PATCH tip/core/rcu 0/23] Improvements to RT response on big systems
 and expedited functions
Message-ID: <20120830181811.GA29154@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083018-6148-0000-0000-000009162A42
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
	2.	Allow RCU grace-period initialization to be preempted.
	3.	Move RCU grace-period cleanup into kthread.
	4.	Allow RCU grace-period cleanup to be preempted.
	5.	Prevent offline CPUs from executing RCU core code.
	6.	Break up rcu_gp_kthread() into subfunctions.
7.	Provide an OOM handler to allow lazy callbacks to be motivated
	under memory pressure.
8.	Segregate rcu_state fields to improve cache locality
	(Courtesy of Dimitri Sivanich).
9-12.	Move RCU grace-period forcing into a kthread.
	9.	Move quiescent-state forcing into kthread.
	10.	Allow RCU quiescent-state forcing to be preempted.
	11.	Adjust debugfs tracing for kthread-based quiescent-state
		forcing.
	12.	Prevent force_quiescent_state() memory contention.
13.	Control grace-period duration from sysfs.
14.	Remove now-unused rcu_state fields.
15.	Make rcutree module parameters visible in sysfs.
16.	Prevent initialization-time quiescent-state race.
17.	Fix day-zero grace-period initialization/cleanup race.
18.	Add random PROVE_RCU_DELAY to provoke initalization races.
19.	Adjust for unconditional ->completed assignment.	
20.	Remove callback acceleration from grace-period initialization
	due it no longer being safe.
21.	Eliminate signed overflow in synchronize_rcu_expedited().
22.	Reduce synchronize_rcu_expedited() latency.
23.	Simplify quiescent-state detection.

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/RCU/trace.txt         |   43 -
 b/Documentation/kernel-parameters.txt |   11 
 b/kernel/rcutree.c                    |  191 +++++---
 b/kernel/rcutree.h                    |    3 
 b/kernel/rcutree_plugin.h             |   80 +++
 b/kernel/rcutree_trace.c              |    3 
 kernel/rcutree.c                      |  805 +++++++++++++++++-----------------
 kernel/rcutree.h                      |   25 -
 kernel/rcutree_plugin.h               |   48 +-
 kernel/rcutree_trace.c                |   12 
 10 files changed, 690 insertions(+), 531 deletions(-)

