Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1DTUwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:52:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7891 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab1DTUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:52:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=Z08d1uiG4a6lIxqxXlp2vfnmmpLHMsrFztqLLmCqpJJZ1r+2MVquAGpvO9bnSPcSo
	EC9kV6bW+EWHrHHIhQKpg==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 16/18] sched: update move_task() and helper functions to use u64 for weights
Date: Wed, 20 Apr 2011 13:51:35 -0700
Message-Id: <1303332697-16426-17-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates move_task() and helper functions to use u64 to handle load
weight related calculations.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched_fair.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ab2d1c9..386d832 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2099,14 +2099,14 @@ move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 
-static unsigned long
+static u64
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-	      unsigned long max_load_move, struct sched_domain *sd,
+	      u64 max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
 	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
-	long rem_load_move = max_load_move;
+	s64 rem_load_move = max_load_move;
 	struct task_struct *p, *n;
 
 	if (max_load_move == 0)
@@ -2199,13 +2199,12 @@ static void update_shares(int cpu)
 	rcu_read_unlock();
 }
 
-static unsigned long
+static u64
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  u64 max_load_move, struct sched_domain *sd,
+		  enum cpu_idle_type idle, int *all_pinned, int *this_best_prio)
 {
-	long rem_load_move = max_load_move;
+	s64 rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
 	struct task_group *tg;
 
@@ -2214,8 +2213,8 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 
 	list_for_each_entry_rcu(tg, &task_groups, list) {
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
-		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
-		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
+		u64 busiest_h_load = busiest_cfs_rq->h_load;
+		u64 busiest_weight = busiest_cfs_rq->load.weight;
 		u64 rem_load, moved_load;
 
 		/*
@@ -2224,8 +2223,8 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		if (!busiest_cfs_rq->task_weight)
 			continue;
 
-		rem_load = (u64)rem_load_move * busiest_weight;
-		rem_load = div_u64(rem_load, busiest_h_load + 1);
+		rem_load = div64_u64(busiest_weight * rem_load_move,
+				     busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
 				rem_load, sd, idle, all_pinned, this_best_prio,
@@ -2234,8 +2233,8 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		if (!moved_load)
 			continue;
 
-		moved_load *= busiest_h_load;
-		moved_load = div_u64(moved_load, busiest_weight + 1);
+		moved_load = div64_u64(moved_load * busiest_h_load,
+				       busiest_weight + 1);
 
 		rem_load_move -= moved_load;
 		if (rem_load_move < 0)
@@ -2250,11 +2249,10 @@ static inline void update_shares(int cpu)
 {
 }
 
-static unsigned long
+static u64
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		  unsigned long max_load_move,
-		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  u64 max_load_move, struct sched_domain *sd,
+		  enum cpu_idle_type idle, int *all_pinned, int *this_best_prio)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
@@ -2270,11 +2268,10 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
  * Called with both runqueues locked.
  */
 static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
-		      unsigned long max_load_move,
-		      struct sched_domain *sd, enum cpu_idle_type idle,
-		      int *all_pinned)
+		      u64 max_load_move, struct sched_domain *sd,
+		      enum cpu_idle_type idle, int *all_pinned)
 {
-	unsigned long total_load_moved = 0, load_moved;
+	u64 total_load_moved = 0, load_moved;
 	int this_best_prio = this_rq->curr->prio;
 
 	do {
-- 
1.7.3.1

