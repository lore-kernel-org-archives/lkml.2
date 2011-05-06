Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1EFB3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:29:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab1EFB3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vaEDFjMjxG0P/yj1IsgDWbgCETH976m3/9lvkGJvd9PWVuox7FB94Tel0UI7XawdBo
         y51aFyyG/GbgP7bsnxdw==
MIME-Version: 1.0
In-Reply-To: <20110504111355.GC5914@elte.hu>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 5 May 2011 18:29:19 -0700
Message-ID: <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 4:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikhil Rao <ncrao@google.com> wrote:
>
>> Also, out of curiosity, what's an acceptable tolerance level for a
>> performance hit on 32-bit?
>
> It's a cost/benefit analysis and for 32-bit systems the benefits seem to be
> rather small, right?
>

Yes, that's right. The benefits for 32-bit systems do seem to be limited.

When I initially posted this patchset, I expected much larger benefits
for 32-bit systems. I ran some experiments yesterday and found
negligible gains for 32-bit systems. I think two aspects of this
patchset are relevant for 32-bit:

1. Better distribution of weight for low-weight task groups. For
example, when an autogroup gets niced to +19, the task group is
assigned a weight of 15. Since 32-bit systems are only restricted to 8
cpus at most, I think we can manage to handle this case without the
need for more resolution. The results for this experiment were not
statistically significant.

2. You could also run out of resolution with deep hierarchies on
32-bit systems, but you need pretty complex cgroup hierarchies. Let's
assume you have a hierarchy with n levels and a branching factor of b
at each level. Let's also assume each leaf node has at least one
running task and users don't change any of the weights. You will need
approx log_b(1024/NR_CPUS) levels to run out of resolution in this
setup... so, b=2 needs 7 levels, b=3 needs 5 levels, b=4 needs 4
levels, ... and so on. These are a pretty elaborate hierarchy and I'm
not sure if there are use cases for these (yet!).

> Can we make the increase in resolution dependent on max CPU count or such and
> use cheaper divides on 32-bit in that case, while still keeping the code clean?
>

Sure. Is this what you had in mind?

commit 860030069190e3d6e1983cc77c936f7ccdaf7cff
Author: Nikhil Rao <ncrao@google.com>
Date:   Mon Apr 11 15:16:08 2011 -0700

    sched: increase SCHED_LOAD_SCALE resolution

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8d1ff2b..f92353c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -794,7 +794,21 @@ enum cpu_idle_type {
 /*
  * Increase resolution of nice-level calculations:
  */
-#define SCHED_LOAD_SHIFT	10
+#if CONFIG_NR_CPUS > 32
+#define SCHED_LOAD_RESOLUTION	10
+
+#define scale_up_load_resolution(w)	w << SCHED_LOAD_RESOLUTION
+#define scale_down_load_resolution(w)	w >> SCHED_LOAD_RESOLUTION;
+
+#else
+#define SCHED_LOAD_RESOLUTION	0
+
+#define scale_up_load_resolution(w)	w
+#define scale_down_load_resolution(w)	w
+
+#endif
+
+#define SCHED_LOAD_SHIFT	(10 + (SCHED_LOAD_RESOLUTION))
 #define SCHED_LOAD_SCALE	(1L << SCHED_LOAD_SHIFT)

 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index f4b4679..3dae6c5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(task_group_lock);
  *  limitation from this.)
  */
 #define MIN_SHARES	2
-#define MAX_SHARES	(1UL << 18)
+#define MAX_SHARES	(1UL << (18 + SCHED_LOAD_RESOLUTION))

 static int root_task_group_load = ROOT_TASK_GROUP_LOAD;
 #endif
@@ -1307,14 +1307,18 @@ calc_delta_mine(unsigned long delta_exec, u64
weight, struct load_weight *lw)
 	u64 tmp;

 	if (!lw->inv_weight) {
-		if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
+		unsigned long w = scale_down_load_resolution(lw->weight);
+		if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
 			lw->inv_weight = 1;
 		else
-			lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
-				/ (lw->weight+1);
+			lw->inv_weight = 1 + (WMULT_CONST - w/2) / (w + 1);
 	}

-	tmp = (u64)delta_exec * weight;
+	if (likely(weight > (1UL << SCHED_LOAD_RESOLUTION)))
+		tmp = (u64)delta_exec * scale_down_load_resolution(weight);
+	else
+		tmp = (u64)delta_exec;
+
 	/*
 	 * Check whether we'd overflow the 64-bit multiplication:
 	 */
@@ -1758,12 +1762,13 @@ static void set_load_weight(struct task_struct *p)
 	 * SCHED_IDLE tasks get minimal weight:
 	 */
 	if (p->policy == SCHED_IDLE) {
-		p->se.load.weight = WEIGHT_IDLEPRIO;
+		p->se.load.weight = scale_up_load_resolution(WEIGHT_IDLEPRIO);
 		p->se.load.inv_weight = WMULT_IDLEPRIO;
 		return;
 	}

-	p->se.load.weight = prio_to_weight[p->static_prio - MAX_RT_PRIO];
+	p->se.load.weight = scale_up_load_resolution(
+			prio_to_weight[p->static_prio - MAX_RT_PRIO]);
 	p->se.load.inv_weight = prio_to_wmult[p->static_prio - MAX_RT_PRIO];
 }

@@ -9129,14 +9134,15 @@ cpu_cgroup_exit(struct cgroup_subsys *ss,
struct cgroup *cgrp,
 static int cpu_shares_write_u64(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
-	return sched_group_set_shares(cgroup_tg(cgrp), shareval);
+	return sched_group_set_shares(cgroup_tg(cgrp),
+				      scale_up_load_resolution(shareval));
 }

 static u64 cpu_shares_read_u64(struct cgroup *cgrp, struct cftype *cft)
 {
 	struct task_group *tg = cgroup_tg(cgrp);

-	return (u64) tg->shares;
+	return (u64) scale_down_load_resolution(tg->shares);
 }
 #endif /* CONFIG_FAIR_GROUP_SCHED */


I think we still need the scaling in calc_delta_mine() -- it helps
with accuracy, and (tmp * inv_weight) would be less likely to overflow
the 64-bit multiplication, so we only do one SRR instead of two SRRs.
I think the SCHED_POWER_SCALE is also a good change since it makes
cpu_power calculations independent of LOAD_SCALE. We can drop all the
other patches that convert unsigned long to u64 and only carry the
overflow detection changes (eg. shares update).

> We'd expect only relatively large and new (and 64-bit) systems to run into
> resolution problems, right?
>

Yes, from the experiments I've run so far, it looks like larger
systems seem to be more affected by resolution problems.

-Thanks,
Nikhil
