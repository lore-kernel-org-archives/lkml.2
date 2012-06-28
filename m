Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454Ab2F1C5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:57:20 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:52809 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758147Ab2F1C40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:56:26 -0400
Subject: [PATCH 00/16] Series short description
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2012 19:24:14 -0700
Message-ID: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Please find attached the latest version for CFS load-tracking.

It implements load-tracking on a per-sched_entity (currently SCHED_NORMAL, but
could be extended to RT as well) basis. This results in a bottom-up
load-computation in which entities contribute to their parents' load, as
opposed to the current top-down where the parent averages its children.  In
particular this allows us to correctly migrate load with their accompanying
entities and provides the necessary inputs for intelligent load-balancing and
power-management.

Modulo review I think this is now close to a mergable state.

Notable updates:
----------------
- Few stability issues fixed; in particular on systems with tasks having idle
  periods spanning several days.  Minor code cleanups.
- 32 bit performance improved (now reported faster[*] on 32-bit ARM than
  without, presumably due to better load-balance or reduced overhead.  Thanks
  to Vincent Guittot and others for looking at this)
- All configs delinted
- Config dependencies seperated so that load-tracking can be used without
  FAIR_GROUP_SCHED so that we may generally use it for power governors and
  per-entity load-balance (in progress).

Thanks to Peter, Vincent, Morten, Nikunj, and others for testing and comments.

Rewinding some context since I've been buried with internal work and it's been
a while since my last posting:

Background:
----------
We currently track the load average at the parenting cfs_rq level. We divide
execution into a series of consecutive "windows, w_i".  Within each we track:
  \Sum load_i * t_i where \Sum t_i = w and each load_i a disjoint load level.

The load average is then \Sum w_j / 2^n.

This this works reasonably well but there's a few problems
1) Since decay occurs at boundary window boundary there are 'skews':
At a window boundary the 'foreground' time has a bias against the
time immediately preceding it (as a result of the folding division)
e.g.  __xx_|_yyyy___ vs __xx_yyyy_|___  (where '|' is a window boundary).

The accounting here is 2x + 4y/2 or 2x + 4y, depending on which side of the
window your load lands on.

2) Everything within a window 'w' is accounted equally, we only fold at
the boundaries.  This actually means you can't set 'w' large enough to
really have meaningful coverage of the sched period without throwing
decay out the window.  But then with w/2 << sched_period (currently
w/2=5ms) the average ends up having fairly drastic swings even with
stable loads.

(Note:  Before we even looked at migrating to per-entity tracking we evaluating
foreground window into the considered average until it was "complete", this
represented a measurable improvement in stability under predictable load.)

3) Since the load sum average is per-cfs_rq and not per-entity when a task
entity migrates we lose its contribution to load-sum and effectively double
count it while it former sum decays.

New approach:
-------------
Instead of tracking load on a per-cfs_rq basis we do it on a per-sched_entity
basis.  The load sum for a cfs_rq is then just the sum of its childrens' load
averages.  The obvious immediately nice property is that when we migrate thread
A from cpu1-->cpu2, we carry its load with it; leaving the global load sum
unmodified.

The 'windows' above are replaced with more fine-grained tracking, that is (for
an entity j):

runnable_j = u_i * y^i , load_avg_j = runnable_j * weight_j [*]

Where: u_i is the usage in the last i`th ~ms and y is chosen such that
y^~sched_period = 1/2 (we currently choose k=32).This means that load tracked 1
sched_period ago contributes about ~50% as current execution.

Now, the real challenge in tracking at an entity basis is handling blocked
entities.  Obviously runnable entities will be updated naturally as we iterate
through them but there could be O(many) blocked entities so we can't afford to
iterate through them and update their tracking.

That our decay for a unit period is exponential introduces a particularly nice
property here:
We can separate the contributed load on a cfs_rq into blocked and runnable.
Runnable load is just the sum of all load_avg_j above, maintained by the
entities themselves as they run and self update (when they update their
load_avg they update the cumulative sum also).

Blocked load then looks like:
  load_avg_j = weight_k * \Sum u[k]_n * y^n

To account an entirely idle period we then only need to multiply by y.

This ends up being orders of magnitude more accurate than the current
tracking schema, even with the old shares_window massively dilated to
better capture a stable load-state.  It's also obviously stable under
migration.

As referenced above this also allows us to potentially improve decisions within
the load-balancer, for both distribution and power-management.

Example: consider 1x80% task  and 2x40% tasks on a 2-core machine.  It's
currently a bit of a gamble as to whether you get an {AB, B} or {A, BB} split
since they have equal weight (assume 1024).  With per-task tracking we can
actually consider them at their contributed weight and see a stable ~{800,{400,
400}} load-split.  Likewise within balance_tasks we can consider the load
migrated to be that actually contributed.  We have some patches looking at this
and will post them as they mature.

Thanks,

- Paul

---

Ben Segall (1):
      sched: maintain per-rq runnable averages

Paul Turner (15):
      sched: track the runnable average on a per-task entitiy basis
      sched: aggregate load contributed by task entities on parenting cfs_rq
      sched: maintain the load contribution of blocked entities
      sched: add an rq migration call-back to sched_class
      sched: account for blocked load waking back up
      sched: aggregate total task_group load
      sched: compute load contribution by a group entity
      sched: normalize tg load contributions against runnable time
      sched: maintain runnable averages across throttled periods
      sched: replace update_shares weight distribution with per-entity computation
      sched: refactor update_shares_cpu() -> update_blocked_avgs()
      sched: update_cfs_shares at period edge
      sched: make __update_entity_runnable_avg() fast
      sched: implement usage tracking
      sched: introduce temporary FAIR_GROUP_SCHED dependency for load-tracking


 include/linux/sched.h |   18 +
 kernel/sched/core.c   |    5 
 kernel/sched/debug.c  |   39 ++
 kernel/sched/fair.c   |  793 +++++++++++++++++++++++++++++++++++++++----------
 kernel/sched/sched.h  |   60 ++--
 5 files changed, 720 insertions(+), 195 deletions(-)

-- 
Signature

