Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2EAS2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:28:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34752 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab2EAS2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:28:39 -0400
Message-Id: <20120501182610.745844312@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 01 May 2012 20:14:31 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@kernel.org, pjt@google.com, vatsa@in.ibm.com,
        suresh.b.siddha@intel.com, efault@gmx.de
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/5] sched, fair: Let minimally loaded cpu balance the group
References: <20120501181430.007891123@chello.nl>
Content-Disposition: inline; filename=sched-balance-min-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we let the leftmost (or first idle) cpu acend the
sched_domain tree and perform load-balancing. The result is that the
busiest cpu in the group might be performing this function and pull
more load to itself. The next load balance pass will then try to
equalize this again.

Change this to pick the least loaded cpu to perform higher domain
balancing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/fair.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched/fair.c
===================================================================
--- linux-2.6.orig/kernel/sched/fair.c
+++ linux-2.6/kernel/sched/fair.c
@@ -3779,7 +3779,8 @@ static inline void update_sg_lb_stats(st
 {
 	unsigned long load, max_cpu_load, min_cpu_load, max_nr_running;
 	int i;
-	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned int balance_cpu = -1;
+	unsigned long balance_load = ~0UL;
 	unsigned long avg_load_per_task = 0;
 
 	if (local_group)
@@ -3795,12 +3796,11 @@ static inline void update_sg_lb_stats(st
 
 		/* Bias balancing toward cpus of our domain */
 		if (local_group) {
-			if (idle_cpu(i) && !first_idle_cpu) {
-				first_idle_cpu = 1;
+			load = target_load(i, load_idx);
+			if (load < balance_load || idle_cpu(i)) {
+				balance_load = load;
 				balance_cpu = i;
 			}
-
-			load = target_load(i, load_idx);
 		} else {
 			load = source_load(i, load_idx);
 			if (load > max_cpu_load) {


