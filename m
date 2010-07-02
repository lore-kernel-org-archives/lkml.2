Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab0GBQ5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:57:10 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45007 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab0GBQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:57:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=dRNk1ksJWx3BLNKjheMiQhvSjF/CgTQIKsDPx+3QOupG09heLBtIlvy1dEpS8tPYl
	v7iGulfnhTGLakARF2aSw==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
Date: Fri,  2 Jul 2010 09:56:39 -0700
Message-Id: <1278089799-11949-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278088816.1917.279.camel@laptop>
References: <1278088816.1917.279.camel@laptop>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My fault. I completely missed that code path, assuming this_cpu in
load_balance means this_cpu :(

How about the change below instead?

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..97f4534 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2406,8 +2406,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
@@ -2456,6 +2454,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
 
+	update_group_power(sd, this_cpu);
+
 	do {
 		int local_group;
 
-- 
1.7.1

