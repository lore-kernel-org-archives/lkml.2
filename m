Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab1FNWhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1FNWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:37:00 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=i4oitjsSMAcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=JfrnYn6hAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=DGGDpp8ivC0nh92LMBIA:9 a=jeBq3FmKZ4MA:10 a=3Rfx1nUSh_UA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110614223657.824872966@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 14 Jun 2011 18:36:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Andrew Theurer <habanero@linux.vnet.ibm.com>
Subject: [PATCH 2/2] sched: Check if lowest_mask is initialized in find_lowest_rq
References: <20110614223623.876681637@goodmis.org>
Content-Disposition: inline; filename=0002-sched-Check-if-lowest_mask-is-initialized-in-find_lo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

On system boot up, the lowest_mask is initialized with early_initcall.
But RT tasks may wake up on other early_initcall callers before the
lowest_mask is initialized, causing a system crash.

The commit d72bce0e67 rcu: Cure load woes
was the first commit to wake up RT tasks in early init. Before this
commit this bug should not happen.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Reported-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
Tested-by: Andrew Theurer <habanero@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1308014683.9218.107.camel@gandalf.stny.rr.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched_rt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9b8d5dc..10d0182 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1239,6 +1239,10 @@ static int find_lowest_rq(struct task_struct *task)
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
 
+	/* Make sure the mask is initialized first */
+	if (unlikely(!lowest_mask))
+		return -1;
+
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
 
-- 
1.7.4.4


