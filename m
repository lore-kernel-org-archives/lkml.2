Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab1EZUzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:55:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32862 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492Ab1EZUzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:55:41 -0400
Date: Thu, 26 May 2011 13:55:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, josh@joshtriplett.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu
Subject: [GIT PULL rcu/urgent] fixes and breakup of memory-barrier-decrease
 patch
Message-ID: <20110526205537.GA13281@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This pull requests covers some RCU bug fixes and one patch rework.

Frederic Weisbecker fixed an unpaired rcu_irq_enter() from locking
selftests, which was confusing RCU into thinking that CPUs were active
when they were actually in dyntick-idle state, which resulted in hangs
or near-hangs due to RCU grace periods completing too slowly.

The first five of my patches re-applies the infamous now-reverted
"Decrease memory-barrier usage based on semi-formal proof" commit into
five commits.  Frederic's fix gets rid of the problem that caused this
commit to be reverted.

Another commit, "Avoid build error for third-party modules", fixes a
build error reported by Randy Dunlap.

The next pair of commits, "Add atomic_or()" and "Avoid acquiring
rcu_node locks in timer functions", fix a lockdep splat reported by
Valdis Kletnieks.

Peter Zijlstra simplified RCU kthread wakeup processing (located while
chasing some scheduler issues), and my last commit avoids some softlockup
splats reported by Yinghai Lu.

Work left to be done includes fixing some performance regressions reported
by Yinghai Lu and providing a few assembly versions of atomic_or().

These changes are available in the -rcu git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent

  							Thanx, Paul

------------------>

Frederic Weisbecker (1):
      rcu: Fix unpaired rcu_irq_enter() from locking selftests

Paul E. McKenney (9):
      rcu: Add memory barriers
      rcu: Remove old memory barriers from rcu_process_callbacks()
      rcu: Don't do reschedule unless in irq
      rcu: Make rcu_enter_nohz() pay attention to nesting
      rcu: Decrease memory-barrier usage based on semi-formal proof
      rcu: Avoid build error for third-party modules
      atomic: Add atomic_or()
      rcu: Avoid acquiring rcu_node locks in timer functions
      rcu: Start RCU kthreads in TASK_INTERRUPTIBLE state

Peter Zijlstra (1):
      rcu: Remove waitqueue usage for cpu, node, and boost kthreads

 Documentation/RCU/trace.txt |   17 ++---
 include/linux/atomic.h      |   13 ++++
 include/linux/rcupdate.h    |    5 +-
 kernel/rcutree.c            |  164 ++++++++++++++++++-------------------------
 kernel/rcutree.h            |   30 ++++----
 kernel/rcutree_plugin.h     |   24 ++-----
 kernel/rcutree_trace.c      |   12 ++--
 lib/locking-selftest.c      |    2 +-
 8 files changed, 116 insertions(+), 151 deletions(-)
