Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0GHOM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:12:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:38292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab0GHOM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:12:56 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278089799-11949-1-git-send-email-venki@google.com>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 16:12:16 +0200
Message-ID: <1278598336.1900.150.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, I got side-tracked :/

On Fri, 2010-07-02 at 09:56 -0700, Venkatesh Pallipadi wrote:
> My fault. I completely missed that code path, assuming this_cpu in
> load_balance means this_cpu :(

Right, but local_group is still valid because that's
cpumask_test_cpu(this_cpu, sched_group_cpus(group));

So in that regard your initial patch was still correct. However, since
there can be multiple CPUs in the local group, we want to only have one
do the actual balancing, which is what the !*balance logic is about, so
by keeping the call site where it is gains that.

The below proposal avoids calling update_groups_power() too often for:
 - !local_groups,
 - multiple cpus in the same group.

Does this look correct?

Related to this, Mikey was looking at avoiding the for_each_cpu_and()
loops by converting update_sg_lb_stats into something similar to
update_group_power() and have 1 cpu in the group update the statistics
and propagate upwards by summing groups instead of individual cpus.

---
 kernel/sched_fair.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9910e1b..62f34a0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2433,7 +2433,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
-	update_group_power(sd, this_cpu);
+	if (local_group)
+		update_group_power(sd, this_cpu);
 
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;

