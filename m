Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab0JHUfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:35:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:3400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0JHUfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eLGkbQ7ZjGyLZBgLnsuQfmfynlqPkEYl02uL9sjLSBoviqo7CW3YLIRIjvIBCrCYbG
         jZTKpg8SS0fudGPks0Mw==
MIME-Version: 1.0
In-Reply-To: <1286522543.8189.13.camel@marge.simson.net>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
 <1285682273.7469.3.camel@marge.simson.net> <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
 <1285724758.7440.11.camel@marge.simson.net> <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
 <1286161717.7410.12.camel@marge.simson.net> <AANLkTinf7fj5A4DnQOWdj8QeMhf4exPGgpMUdTGA9mTC@mail.gmail.com>
 <1286522543.8189.13.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 8 Oct 2010 13:34:42 -0700
Message-ID: <AANLkTim8m6r_8pFO6o0uOnki6mNoaR+8NZ4M0pO3H515@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 12:22 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Wed, 2010-10-06 at 01:23 -0700, Nikhil Rao wrote:
>> On Sun, Oct 3, 2010 at 8:08 PM, Mike Galbraith <efault@gmx.de> wrote:
>> > On Wed, 2010-09-29 at 12:32 -0700, Nikhil Rao wrote:
>> >> The closest I have is a quad-core dual-socket machine (MC, CPU
>> >> domains). And I'm having trouble reproducing it on that machine as
>> >> well :-( I ran 5 soaker threads (one of them niced to -15) for a few
>> >> hours and didn't see the problem. Can you please give me some trace
>> >> data & schedstats to work with?
>> >
>> > Booting with isolcpus or offlining the excess should help.
>> >
>>
>> Sorry for the late reply. Booting with isolcpus did the trick, thanks.
>>
>> ... and now to dig into why this is happening.
>
> I was poking it (again) yesterday, and it's kind of annoying.  I can't
> call this behavior black/white broken.  It's freeing up a cache for a
> very high priority task, which is kinda nice, but SMP nice is costing
> 25% of my box's processor power in this case too.  Hrmph.
>

I agree that freeing up the cache for the high priority task is a nice
side-effect of weight-based balancing. However, with sufficient number
of low weight tasks on the system, or with a small nudge to affinity
masks, the niced task will end up sharing cache with low weight tasks.
In that sense, I think this is a tad bit more black than white :-) It
would be nice to make the load balancer more cache aware, but that's
for a different RFC. :-)

Further, once a sched group reaches a certain "bad state", where the
niced task is the only task in a sched group with more than 1 cpu, it
does not recover from that state easily. This leads to the sub-optimal
utilization situation that we have been chasing down. In this
situation, even though the sched group has capacity, it does not pull
tasks because sds.this_load >> sds.max_load, and f_b_g() returns NULL.

A sched group reaches this state because either (i). a niced task is
pulled into an empty sched group, or (ii). all other tasks in the
sched group are pulled away from the group. The patches in this
patchset try to prevent the latter, i.e. prevent low weight tasks from
being pulled away from the sched group. However, there are still many
ways to end up in the bad state. From empirical evidence, it seems to
happen more probability on a machine with fewer cpus. I have verified
that with the appropriate test setup, this also happens on the
quad-socket, quad-core machines as well (i.e. set affinity of the
normal tasks to socket-0 and niced task to socket-1, and then reset
affinities).

I have attached a patch that tackles the problem in different way.
Instead of preventing the sched group from entering the bad state, it
shortcuts the checks in fbg if the group has extra capacity, where
extra capacity is defined as group_capacity > nr_running. The patch
exposes a sched feature called PREFER_UTILIZATION (disabled by
default). When this is enabled, f_b_g shortcuts the checks if the
local group has capacity. This actually works quite well. I tested
this on a quad-core dual-socket (with isolcpus) and waited for the
machine to enter the bad state. On flipping the sched feature,
utilization immediately shoots up to 100% (of non-isolated cores). I
have some data below.

This is very experimental and has not been tested beyond this case and
some basic load balance tests. If you see a better way to do this
please let me know.

w/ PREFER_UTILIZATION disabled

Cpu(s): 34.3% us,  0.2% sy,  0.0% ni, 65.1% id,  0.4% wa,  0.0% hi,  0.0% si
Mem:  16463308k total,   996368k used, 15466940k free,    12304k buffers
Swap:        0k total,        0k used,        0k free,   756244k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7651 root       5 -15  5876   84    0 R   98  0.0  37:35.97 lat
 7652 root      20   0  5876   84    0 R   49  0.0  19:49.02 lat
 7654 root      20   0  5876   84    0 R   49  0.0  20:48.93 lat
 7655 root      20   0  5876   84    0 R   49  0.0  19:25.74 lat
 7653 root      20   0  5876   84    0 R   47  0.0  20:02.16 lat

w/ PREFER_UTILIZATION enabled

Cpu(s): 52.3% us,  0.0% sy,  0.0% ni, 47.6% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:  16463308k total,  1002852k used, 15460456k free,    12304k buffers
Swap:        0k total,        0k used,        0k free,   756312k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7651 root       5 -15  5876   84    0 R  100  0.0  38:12.37 lat
 7655 root      20   0  5876   84    0 R   99  0.0  19:49.99 lat
 7652 root      20   0  5876   84    0 R   80  0.0  20:09.80 lat
 7653 root      20   0  5876   84    0 R   60  0.0  20:22.13 lat
 7654 root      20   0  5876   84    0 R   58  0.0  21:07.88 lat

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6d934e8..04e5553 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2030,12 +2030,14 @@ struct sd_lb_stats {
 	unsigned long this_load;
 	unsigned long this_load_per_task;
 	unsigned long this_nr_running;
+	unsigned long this_has_capacity;

 	/* Statistics of the busiest group */
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
+	unsigned long busiest_has_capacity;

 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2058,6 +2060,7 @@ struct sg_lb_stats {
 	unsigned long sum_weighted_load; /* Weighted load of group's tasks */
 	unsigned long group_capacity;
 	int group_imb; /* Is there an imbalance in the group ? */
+	int group_has_capacity; /* Is there extra capacity in the group? */
 };

 /**
@@ -2458,6 +2461,9 @@ static inline void update_sg_lb_stats(struct
sched_domain *sd,
 		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 	if (!sgs->group_capacity)
 		sgs->group_capacity = fix_small_capacity(sd, group);
+
+	if (sgs->group_capacity > sgs->sum_nr_running)
+		sgs->group_has_capacity = 1;
 }

 /**
@@ -2556,12 +2562,14 @@ static inline void update_sd_lb_stats(struct
sched_domain *sd, int this_cpu,
 			sds->this = sg;
 			sds->this_nr_running = sgs.sum_nr_running;
 			sds->this_load_per_task = sgs.sum_weighted_load;
+			sds->this_has_capacity = sgs.group_has_capacity;
 		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
 			sds->max_load = sgs.avg_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
+			sds->busiest_has_capacity = sgs.group_has_capacity;
 			sds->group_imb = sgs.group_imb;
 		}

@@ -2820,6 +2828,10 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (!sds.busiest || sds.busiest_nr_running == 0)
 		goto out_balanced;

+	if (sched_feat(PREFER_UTILIZATION) &&
+			sds.this_has_capacity && !sds.busiest_has_capacity)
+		goto force_balance;
+
 	if (sds.this_load >= sds.max_load)
 		goto out_balanced;

@@ -2831,6 +2843,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;

+force_balance:
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 83c66e8..9b93862 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -61,3 +61,9 @@ SCHED_FEAT(ASYM_EFF_LOAD, 1)
  * release the lock. Decreases scheduling overhead.
  */
 SCHED_FEAT(OWNER_SPIN, 1)
+
+/*
+ * Prefer utilization over fairness when balancing tasks with large weight
+ * differential.
+ */
+SCHED_FEAT(PREFER_UTILIZATION, 0)
