Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab1GHPo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:44:29 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51087 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab1GHPoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:44:24 -0400
Date: Fri, 8 Jul 2011 08:43:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: [PATCH tip/core/rcu 0/6] Check for use of RCU from dyntick-idle
 mode
Message-ID: <20110708154331.GA20161@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This set of patches adds checks for use of RCU from "extended quiescent
states" such as dyntick-idle mode.  Such use is grossly illegal because
RCU by definition ignores CPUs that are in extended quiescent states.
In the case of dyntick-idle mode, the only way for RCU to avoid ignoring
such CPUs would be to wake them up periodically, which would defeat the
whole purpose of dyntick-idle mode.

The good news is that Frederic got this effort started.  The bad news is
that there are several cases where RCU read-side critical sections appear
in dyntick-idle mode.  Frederic is working on a solution, but because there
is no point in giving warnings in cases where there is no known fix, I will
not push these patches until a fix is available.  (The most likely fix is
to move the code that informs RCU of entry to and exit from dyntick-idle
mode into the arch-specific idle loops, which would legitimize current RCU
usage -- and potentially simplify RCU's quiescent-state detection.)

The individual patches are as follows:

1.	Make rcu_read_lock_held(), rcu_read_lock_sched_held(),
	and rcu_read_lock_bh_held() invoke a new rcu_check_extended_qs()
	function to check for calls from extended quiescent states,
	courtesy of Frederic Weisbecker.
2.	Make lockdep RCU splats call out use from within extended
	quiescent states, also courtesy of Frederic Weisbecker.
3.	Make rcu_read_lock(), rcu_read_lock_sched(), and
	rcu_read_lock_bh() also check for (illegal) use from within
	an extended quiescent state, again courtesy of Frederic
	Weisbecker.
4.	Remove an unnecessary level of abstraction from the PROVE_RCU
	checking.
5.	Warn when srcu_read_lock() and srcu_read_lock_held() are called
	from within an extended quiescent state.
6.	Make srcu_read_lock_held() invoke the debug_lockdep_rcu_enabled()
	common function that determines whether or not RCU lockdep splats
	are appropriate.

These changes are also available on the subject-to-rebase branch in the
git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git eqscheck.2011.07.08a

							Thanx, Paul

------------------------------------------------------------------------

 b/include/linux/rcupdate.h |   36 +++++++++++++++
 b/include/linux/srcu.h     |   25 ++++++----
 b/kernel/lockdep.c         |   20 ++++++++
 b/kernel/rcupdate.c        |   17 ++++++-
 b/kernel/rcutiny.c         |   14 ++++++
 b/kernel/rcutree.c         |   16 ++++++
 include/linux/rcupdate.h   |  105 +++++++++++++++++++++------------------------
 include/linux/srcu.h       |    5 +-
 8 files changed, 171 insertions(+), 67 deletions(-)
