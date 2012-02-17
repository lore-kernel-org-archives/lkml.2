Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2BQKsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:48:46 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63354 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2BQKsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:48:37 -0500
MIME-Version: 1.0
In-Reply-To: <87k43lde0r.fsf@linux.vnet.ibm.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com> <87k43lde0r.fsf@linux.vnet.ibm.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 17 Feb 2012 02:48:06 -0800
Message-ID: <CAPM31RLWpF0mO2faCfY+HOeThz0iW6_7D+S++pGHtJi6hhiAVQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 1:07 AM, Nikunj A Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
> On Wed, 01 Feb 2012 17:38:26 -0800, Paul Turner <pjt@google.com> wrote:
>> Hi all,
>>
>> The attached series is an RFC on implementing load tracking at the entity
>> instead of cfs_rq level. This results in a bottom-up load-computation in which
>> entities contribute to their parents load, as opposed to the current top-down
>> where the parent averages its children.  In particular this allows us to
>> correctly migrate load with their accompanying entities and provides the
>> necessary inputs for intelligent load-balancing and power-management.
>>
>> It was previously well tested and stable, but that was on v3.1-; there's been
>> some fairly extensive changes in the wake-up path since so apologies if anything
>> was broken in the rebase.Note also, since this is also an RFC on the approach I
>> have not yet de-linted the various CONFIG combinations for introduced compiler
>> errors.
>>
>
> I gave a quick run to this series, and it seems the fairness across
> taskgroups is broken with this.
>
> Test setup:
> Machine : IBM xSeries with Intel(R) Xeon(R) x5570 2.93GHz CPU with 8
> core, 64GB RAM, 16 cpu.
>
> Create 3 taskgroups: fair16, fair32 and fair48 having 16, 32 and 48
> cpu-hog tasks respectively. They have equal shares(default 1024), so
> they should consume roughly the same time.
>
> 120secs run 1:
> Time consumed by fair16 cgroup:  712912 Tasks: 16
> Time consumed by fair32 cgroup:  650977 Tasks: 32
> Time consumed by fair48 cgroup:  575681 Tasks: 48
>
> 120secs run 2:
> Time consumed by fair16 cgroup:  686295 Tasks: 16
> Time consumed by fair32 cgroup:  643474 Tasks: 32
> Time consumed by fair48 cgroup:  611415 Tasks: 48
>
> 600secs run 1:
> Time consumed by fair16 cgroup:  4109678 Tasks: 16
> Time consumed by fair32 cgroup:  1743983 Tasks: 32
> Time consumed by fair48 cgroup:  3759826 Tasks: 48
>
> 600secs run 2:
> Time consumed by fair16 cgroup:  3893365 Tasks: 16
> Time consumed by fair32 cgroup:  3028280 Tasks: 32
> Time consumed by fair48 cgroup:  2692001 Tasks: 48
>


This is almost certainly a result of me twiddling with the weight in
calc_cfs_shares (using average instead of instantaneous weight) in
this version -- see patch 11/14.  While this had some nice stability
properties it was not hot for fairness so I've since reverted it
(snippet attached below).

While it's hard to guarantee it was exactly this since I'm carrying a
few other minor edits in preparation for the next version, the current
results for the next version of this series look like:

8-core:
Starting task group fair16...done
Starting task group fair32...done
Starting task group fair48...done
Waiting for the task to run for 120 secs
Interpreting the results. Please wait....
Time consumed by fair16 cgroup:  316985 Tasks: 16
Time consumed by fair32 cgroup:  320274 Tasks: 32
Time consumed by fair48 cgroup:  320811 Tasks: 48

24-core:
Starting task group fair16...done
Starting task group fair32...done
Starting task group fair48...done
Waiting for the task to run for 120 secs
Interpreting the results. Please wait....
Time consumed by fair16 cgroup:  12628615 Tasks: 96
Time consumed by fair32 cgroup:  12562859 Tasks: 192
Time consumed by fair48 cgroup:  12600364 Tasks: 288

These results are stable and consistent.

As soon as I finish working through Peter's comments I'll upload a
pre-posting so you can re-test if you'd like.  Expect a formal
(non-RFC) posting with other nits such as detangling tracking from
FAIR_GROUP_SCHED so that we may use it more comprehensively following
that within the next week or so.

Thanks,

- Paul

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -823,7 +823,7 @@ static inline long calc_tg_weight(struct
task_group *tg, struct cfs_rq *cfs_rq)
        */
       tg_weight = atomic64_read(&tg->load_avg);
       tg_weight -= cfs_rq->tg_load_contrib;
-       tg_weight += cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+       tg_weight += cfs_rq->load.weight;


       return tg_weight;
 }
@@ -833,7 +833,7 @@ static long calc_cfs_shares(struct cfs_rq *cfs_rq,
struct task_group *tg)
       long tg_weight, load, shares;

       tg_weight = calc_tg_weight(tg, cfs_rq);
-       load = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
+       load = cfs_rq->load.weight;

> As you can see there is a lot of variance in the above results.
>
> wo patches
> 120secs run 1:
> Time consumed by fair16 cgroup:  667644 Tasks: 16
> Time consumed by fair32 cgroup:  653771 Tasks: 32
> Time consumed by fair48 cgroup:  624915 Tasks: 48
>
> 600secs run 1:
> Time consumed by fair16 cgroup:  3278425 Tasks: 16
> Time consumed by fair32 cgroup:  3140335 Tasks: 32
> Time consumed by fair48 cgroup:  3198817 Tasks: 48
>
> Regards
> Nikunj
>
