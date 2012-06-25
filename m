Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2FYWjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 18:39:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44598 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2FYWjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 18:39:44 -0400
Date: Mon, 25 Jun 2012 15:39:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, josh@joshtriplett.org, tglx@linutronix.de,
        sbw@mit.edu
Subject: [GIT PULL rcu/urgent] Fix for RCU-related hang
Message-ID: <20120625223940.GA17159@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062522-5518-0000-0000-00000584A8DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo,

This series has a single patch that fixes a system hang that can occur
in perhaps unusual but very real circumstances.  This hang occurs
because of a very stupid bug of mine introduced in commit b1420f1c
(Make rcu_barrier() less disruptive) that can cause CPUs to miscount
RCU callbacks.  The sequence of events leading to the hang is as follows:

1.	A CPU miscounts its callbacks.
2.	That CPU invokes all of its callbacks, so that its callback
	list is empty, but the callback count is nonzero.
3.	That CPU goes offline.  Because its callback list is empty,
	RCU's CPU-hotplug CPU_DEAD notifiers leave both the list and
	the count alone.  (In contrast, had the list been non-empty,
	RCU's CPU_DEAD notifiers would have emptied the list and
	zeroed the count.)
4.	One of the remaining CPUs executes one of the rcu_barrier()
	family of primitives.  The rcu_barrier() primitive notes
	that the offline CPU has a non-zero count of callbacks, and
	therefore hangs waiting for this count to reach zero.  The
	theory behind the indefinite wait is that the only reason that
	an offline CPU can have a non-zero number of RCU callbacks is
	that the CPU's CPU_DEAD notifiers have not yet executed.
	But they already have executed, so the offlined CPU's callback
	count will remain non-zero until it is brought back online,
	in other words, perhaps never.

However, this bug is likely to pass a combined rcutorture/CPU-hotplug
stress test because offlined CPUs tend to be brought back online
reasonably quickly.  For the rcutorture tests to fail, the system must be
in the state indicated by step #3 above at the time the "rmmod rcutorture"
executes.

The fix is simply to prevent the miscounting.

This change is available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

  								Thanx, Paul

------------------------------------------------------------------------

Paul E. McKenney (1):
      rcu: Stop rcu_do_batch() from multiplexing the "count" variable

 kernel/rcutree.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

