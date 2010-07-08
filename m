Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab0GHSRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 14:17:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50239 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab0GHSRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 14:17:18 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
	 <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 08 Jul 2010 20:16:29 +0200
Message-ID: <1278612989.1900.176.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 10:45 -0700, Suresh Siddha wrote:
> > @@ -2433,7 +2433,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
> >               return;
> >       }
> >  
> > -     update_group_power(sd, this_cpu);
> > +     if (local_group)
> > +             update_group_power(sd, this_cpu);
> 
> if IDLE == CPU_NEWLY_IDLE, then all the cpu's in the local group will do
> this. Also update_group_power() can be done on only on the local cpu,
> i.e., when this_cpu == smp_processor_id() right?

It might make sense to only update_group_power on !CPU_NEWLY_IDLE and
rely on the tick driven cpu_power updates.

No sense in updating them in finer slices I guess.

So how about something like:

---
 kernel/sched_fair.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9910e1b..2f05679 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2427,14 +2427,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 * domains. In the newly idle case, we will allow all the cpu's
 	 * to do the newly idle load balance.
 	 */
-	if (idle != CPU_NEWLY_IDLE && local_group &&
-	    balance_cpu != this_cpu) {
-		*balance = 0;
-		return;
+	if (idle != CPU_NEWLY_IDLE && local_group) {
+		if (balance_cpu != this_cpu) {
+			*balance = 0;
+			return;
+		}
+		update_group_power(sd, this_cpu);
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 

