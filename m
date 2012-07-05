Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab2GEQSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:18:54 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44989 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab2GEQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:18:52 -0400
Date: Thu, 5 Jul 2012 09:16:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, levinsasha928@gmail.com
Subject: [GIT RFC PULL rcu/urgent] Revert to fix RCU-related
 deadlock/softlockup
Message-ID: <20120705161644.GA10670@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070516-5518-0000-0000-000005CB66BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series has a single revert from the ill-starred attempt to inline
__rcu_read_lock() for preemptible RCU.  Without this revert, on mainline
kernels using CONFIG_RCU_BOOST there is a low-probability deadlock on the
runqueue locks, but one that actually appeared in Sasha Levin's testing.
With the revert, and with an diagnostic patch that increased probability
of the deadlock to a MTBF of roughly 10 seconds, Sasha's tests ran for
two days with no failure.

The sequence of events leading to the deadlock is as follows:

1.	A task enters an RCU read-side critical section, and is both
	preempted and subjected to RCU priority boosting.
2.	The task starts to exit its RCU read-side critical section,
	but is preempted in __rcu_read_unlock() just after the assignment
	setting t->rcu_read_lock_nesting to INT_MIN.  (The diagnostic
	patch mentioned above expands this window by ten microseconds,
	and is available in -rcu as a debug option queued for 3.7.)
3.	The task enters the scheduler, where it acquires the corresponding
	runqueue lock, then invokes rcu_switch_from() which in turn
	invokes rcu_preempt_note_context_switch(), which in turn invokes
	rcu_read_unlock_special(), which attempts to deboost the task.
4.	The attempt to deboost the task recursively enters the scheduler
	with a runqueue lock held, which can result in deadlock.

The revert moves the point at which rcu_preempt_note_context_switch() is
called to a point in the scheduler code before the runqueue lock is
acquired, avoiding the deadlock.

This pull is marked "RFC" because CONFIG_RCU_BOOST=y is not used much
outside of the real-time community.  I will be sending another pull
request later today (Pacific Time) for 3.6 RCU commits, which will
include this commit as well.  Your choice.  ;-)

This change is available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

------------------>
Paul E. McKenney (1):
      Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"

 arch/um/drivers/mconsole_kern.c |    1 -
 include/linux/rcupdate.h        |    1 -
 include/linux/rcutiny.h         |    6 ++++++
 include/linux/sched.h           |   10 ----------
 kernel/rcutree.c                |    1 +
 kernel/rcutree.h                |    1 +
 kernel/rcutree_plugin.h         |   14 +++++++++++---
 kernel/sched/core.c             |    1 -
 8 files changed, 19 insertions(+), 16 deletions(-)

