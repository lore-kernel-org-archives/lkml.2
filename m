Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115Ab0HFTQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:16:00 -0400
Received: from kroah.org ([198.145.64.141]:58472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964946Ab0HFS74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:59:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:33 2010
Message-Id: <20100806185833.915291684@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:56:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [01/34] sched: cgroup: Implement different treatment for idle shares
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit cd8ad40de36c2fe75f3b731bd70198b385895246 upstream.

When setting the weight for a per-cpu task-group, we have to put in a
phantom weight when there is no work on that cpu, otherwise we'll not
service that cpu when new work gets placed there until we again update
the per-cpu weights.

We used to add these phantom weights to the total, so that the idle
per-cpu shares don't get inflated, this however causes the non-idle
parts to get deflated, causing unexpected weight distibutions.

Reverse this, so that the non-idle shares are correct but the idle
shares are inflated.

Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Tested-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1257934048.23203.76.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1623,7 +1623,7 @@ static void update_group_shares_cpu(stru
  */
 static int tg_shares_up(struct task_group *tg, void *data)
 {
-	unsigned long weight, rq_weight = 0, shares = 0;
+	unsigned long weight, rq_weight = 0, sum_weight = 0, shares = 0;
 	unsigned long *usd_rq_weight;
 	struct sched_domain *sd = data;
 	unsigned long flags;
@@ -1639,6 +1639,7 @@ static int tg_shares_up(struct task_grou
 		weight = tg->cfs_rq[i]->load.weight;
 		usd_rq_weight[i] = weight;
 
+		rq_weight += weight;
 		/*
 		 * If there are currently no tasks on the cpu pretend there
 		 * is one of average load so that when a new task gets to
@@ -1647,10 +1648,13 @@ static int tg_shares_up(struct task_grou
 		if (!weight)
 			weight = NICE_0_LOAD;
 
-		rq_weight += weight;
+		sum_weight += weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
 
+	if (!rq_weight)
+		rq_weight = sum_weight;
+
 	if ((!shares && rq_weight) || shares > tg->shares)
 		shares = tg->shares;
 


