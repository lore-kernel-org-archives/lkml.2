Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1EDHOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:14:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:59556 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1EDHOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:14:10 -0400
Date: Wed, 4 May 2011 07:13:52 GMT
From: tip-bot for Vladimir Davydov <vdavydov@parallels.com>
Message-ID: <tip-931aeeda0dca81152aec48f30be01e86a268bf89@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vdavydov@parallels.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, vdavydov@parallels.com,
        mingo@elte.hu
In-Reply-To: <1304447467-29200-1-git-send-email-vdavydov@parallels.com>
References: <1304447467-29200-1-git-send-email-vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused 'this_best_prio arg' from balance_tasks()
Git-Commit-ID: 931aeeda0dca81152aec48f30be01e86a268bf89
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 04 May 2011 07:13:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  931aeeda0dca81152aec48f30be01e86a268bf89
Gitweb:     http://git.kernel.org/tip/931aeeda0dca81152aec48f30be01e86a268bf89
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Tue, 3 May 2011 22:31:07 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 May 2011 09:07:21 +0200

sched: Remove unused 'this_best_prio arg' from balance_tasks()

It's passed across multiple functions but is never really used, so
remove it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1304447467-29200-1-git-send-email-vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5280272..37f2262 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2142,7 +2142,7 @@ static unsigned long
 balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	      unsigned long max_load_move, struct sched_domain *sd,
 	      enum cpu_idle_type idle, int *all_pinned,
-	      int *this_best_prio, struct cfs_rq *busiest_cfs_rq)
+	      struct cfs_rq *busiest_cfs_rq)
 {
 	int loops = 0, pulled = 0;
 	long rem_load_move = max_load_move;
@@ -2180,9 +2180,6 @@ balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		 */
 		if (rem_load_move <= 0)
 			break;
-
-		if (p->prio < *this_best_prio)
-			*this_best_prio = p->prio;
 	}
 out:
 	/*
@@ -2242,7 +2239,7 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	long rem_load_move = max_load_move;
 	int busiest_cpu = cpu_of(busiest);
@@ -2267,7 +2264,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		rem_load = div_u64(rem_load, busiest_h_load + 1);
 
 		moved_load = balance_tasks(this_rq, this_cpu, busiest,
-				rem_load, sd, idle, all_pinned, this_best_prio,
+				rem_load, sd, idle, all_pinned,
 				busiest_cfs_rq);
 
 		if (!moved_load)
@@ -2293,11 +2290,11 @@ static unsigned long
 load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		  unsigned long max_load_move,
 		  struct sched_domain *sd, enum cpu_idle_type idle,
-		  int *all_pinned, int *this_best_prio)
+		  int *all_pinned)
 {
 	return balance_tasks(this_rq, this_cpu, busiest,
 			max_load_move, sd, idle, all_pinned,
-			this_best_prio, &busiest->cfs);
+			&busiest->cfs);
 }
 #endif
 
@@ -2314,12 +2311,11 @@ static int move_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		      int *all_pinned)
 {
 	unsigned long total_load_moved = 0, load_moved;
-	int this_best_prio = this_rq->curr->prio;
 
 	do {
 		load_moved = load_balance_fair(this_rq, this_cpu, busiest,
 				max_load_move - total_load_moved,
-				sd, idle, all_pinned, &this_best_prio);
+				sd, idle, all_pinned);
 
 		total_load_moved += load_moved;
 
