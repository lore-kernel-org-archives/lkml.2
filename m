Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0LQUyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:54:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45947 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab0LQUyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:54:38 -0500
Date: Fri, 17 Dec 2010 12:54:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: [PATCH tip/core/rcu 0/20] second preview of RCU patches for 2.6.38
Message-ID: <20101217205433.GA10199@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset contains RCU priority boosting for the tiny RCU
implementations and a number of fixes and cleanups.  The patches
are as follows, with the first 12 being updates from the earlier
posting at https://lkml.org/lkml/2010/11/6/187:

1.	Add rcutorture tests to check for correct priority boosting.
2-6.	RCU priority boosting for the tiny RCU implementations.
	RCU priority boosting for the tree RCU implementations is
	in progress, but not yet ready for prime time.
7.	Fix a few naming holdouts from old Classic RCU.
8.	Move synchronize_sched_expedited() out of sched.c
	(from Lai Jiangshan).
9.	Simplify the RCU callback orphan/adopt code for CPU hotplug
	(from Lai Jiangshan).
10.	Update RCU tracing documentation to reflect patch #9.
11.	Fix a race condition in synchronize_sched_expedited(),
	but Tejun Heo has suggested another approach that might
	be better longer term.
12.	Make synchronize_srcu_expedited() spin for a bit to avoid
	blocking -- again, there may be a better long-term fix.
	That said, this adaptive approach seems to work very well
	in practice.
13.	Improve synchronize_sched_expedited()'s ability to batch
	concurrent requests, as foreshadowed above.
14-15.	Make RCU avoid looking for quiescent states in cases when
	they are not required, thereby improving RCU's energy
	efficiency (from Frederic Weisbecker).
16.	Enlist the rnp->qsmask data to simplify #14 and #15 and
	also handle another case where RCU was unnecessarily asking
	CPUs to go through quiescent states.
17.	Limit tree RCU's leaf-level fanout to reduce lock contention.
	Lock contention is higher at the leaf level that elsewhere
	in the tree of rcu_node structures due to the fact that
	CPUs synchronize at the leaf level to detect grace-period
	events.
18.	Reduce tree RCU's leaf-level lock contention still further
	by making __call_rcu() less aggressive about starting new
	grace periods.  The aggression is a holdover from ancient
	times predating synchronize_rcu_expedited().
19.	Fix a mismatched-parentheses error in __list_for_each_rcu()
	(from Mariusz Kozlowski).
20.	Given that there are no in-tree users, remove the aforementioned
	__list_for_each_rcu().  This is maintained as a separate
	commit in case there is a use out there somewhere making its
	way into mainline.  (Though I would rather keep this API
	out -- list_for_each_entry_rcu() is much better in most cases.)

For a testing-only version of this patchset from git, please see:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

							Thanx, Paul

 Documentation/RCU/trace.txt   |   12 -
 b/Documentation/RCU/trace.txt |  132 +++++++++++-
 b/include/linux/init_task.h   |    9 
 b/include/linux/rculist.h     |    2 
 b/include/linux/rcupdate.h    |    1 
 b/include/linux/rcutiny.h     |    8 
 b/include/linux/rcutree.h     |    1 
 b/include/linux/sched.h       |   11 -
 b/init/Kconfig                |   39 +++
 b/kernel/rcutiny.c            |   71 +++++-
 b/kernel/rcutiny_plugin.h     |   15 -
 b/kernel/rcutorture.c         |  270 ++++++++++++++++++++++++-
 b/kernel/rcutree.c            |   81 +------
 b/kernel/rcutree.h            |   16 -
 b/kernel/rcutree_plugin.h     |   71 ++++++
 b/kernel/rcutree_trace.c      |    8 
 b/kernel/sched.c              |   69 ------
 b/kernel/srcu.c               |    8 
 include/linux/rculist.h       |    5 
 include/linux/rcupdate.h      |    3 
 include/linux/rcutiny.h       |    5 
 include/linux/rcutree.h       |    1 
 init/Kconfig                  |   16 +
 kernel/rcutiny.c              |   70 ++----
 kernel/rcutiny_plugin.h       |  444 ++++++++++++++++++++++++++++++++++++++++--
 kernel/rcutree.c              |   95 ++++++--
 kernel/rcutree.h              |   45 ++--
 kernel/rcutree_plugin.h       |  110 +++++++---
 kernel/rcutree_trace.c        |    4 
 29 files changed, 1272 insertions(+), 350 deletions(-)
