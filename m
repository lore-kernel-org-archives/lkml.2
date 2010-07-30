Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0G3FUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 01:20:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0G3FTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 01:19:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=m9DokFKA/z0yujvhDZhYxeHv+xJIqqERqxgi0tq4b3hEYvcuudV7NwBZmhOkgzN8A
	PlhcrD5W4A6gdRbPEQl5w==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Cc: Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>,
        Paul Turner <pjt@google.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 4/6] sched: add sched_idle_balance argument to lb functions
Date: Thu, 29 Jul 2010 22:19:04 -0700
Message-Id: <1280467146-32218-5-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280467146-32218-1-git-send-email-ncrao@google.com>
References: <1280467146-32218-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an extra sched_idle_balance argument to move_tasks,
load_balance_fair and balance_tasks. This argument is required to differentiate
between SCHED_NORMAL/SCHED_BATCH load balancing and SCHED_IDLE balancing.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0e25e51..cb270e8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1861,7 +1861,8 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
+	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq,
+	      int sched_idle_balance)
 {
 	int loops = 0, pulled = 0, pinned = 0;
 	long rem_load_move = max_load_move;
@@ -1923,7 +1924,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned, int *this_best_prio, int sched_idle_balance)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -1949,7 +1950,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
-				busiest_cfs_rq);
+				busiest_cfs_rq, sched_idle_balance);
 
 		if (!moved_load)
 			continue;
@@ -1970,11 +1971,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned, int *this_best_prio, int sched_idle_balance)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			this_best_prio, &busiest->cfs, sched_idle_balance);
 }
 #endif
 
@@ -1988,7 +1989,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      unsigned long max_load_move,
 		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
+		      int *all_pinned, int sched_idle_balance)
 {
 	unsigned long total_load_moved = 0, load_moved;
 	int this_best_prio = this_rq->curr->prio;
@@ -1996,7 +1997,8 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, all_pinned, &this_best_prio,
+				sched_idle_balance);
 
 		total_load_moved += load_moved;
 
@@ -2878,7 +2880,7 @@ redo:
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
-				      imbalance, sd, idle, &all_pinned);
+				      imbalance, sd, idle, &all_pinned, 0);
 		double_rq_unlock(this_rq, busiest);
 		local_irq_restore(flags);
 
-- 
1.7.1

