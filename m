Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2BBBna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:43:30 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58965 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab2BBBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:43:22 -0500
Subject: [RFC PATCH 00/14] sched: entity load-tracking re-work
To: linux-kernel@vger.kernel.org
From: Paul Turner <pjt@google.com>
Cc: Venki Pallipadi <venki@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 01 Feb 2012 17:38:26 -0800
Message-ID: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The attached series is an RFC on implementing load tracking at the entity
instead of cfs_rq level. This results in a bottom-up load-computation in which
entities contribute to their parents load, as opposed to the current top-down
where the parent averages its children.  In particular this allows us to
correctly migrate load with their accompanying entities and provides the
necessary inputs for intelligent load-balancing and power-management.

It was previously well tested and stable, but that was on v3.1-; there's been
some fairly extensive changes in the wake-up path since so apologies if anything
was broken in the rebase.Note also, since this is also an RFC on the approach I
have not yet de-linted the various CONFIG combinations for introduced compiler
errors.

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

Exmaple: consider 1x80% task  and 2x40% tasks on a 2-core machine.  It's
currently a bit of a gamble as to whether you get an {AB, B} or {A,
BB} split since they have equal weight (assume 1024).  With per-task
tracking we can actually consider them at their contributed weight and
see a stable ~{800,{400, 400}} load-split.  Likewise within balance_tasks we can
consider the load migrated to be that actually contributed.

Thanks,

- Paul


---

Ben Segall (1):
      sched: maintain per-rq runnable averages

Paul Turner (13):
      sched: track the runnable average on a per-task entitiy basis
      sched: aggregate load contributed by task entities on parenting cfs_rq
      sched: maintain the load contribution of blocked entities
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


 include/linux/sched.h |   11 +
 kernel/sched/core.c   |    3 
 kernel/sched/debug.c  |   37 ++-
 kernel/sched/fair.c   |  714 ++++++++++++++++++++++++++++++++++++++-----------
 kernel/sched/sched.h  |   29 +-
 5 files changed, 611 insertions(+), 183 deletions(-)


