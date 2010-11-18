Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0KRONb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:13:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:52172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab0KRON3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:13:29 -0500
Date: Thu, 18 Nov 2010 14:12:55 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101115234938.291159744@google.com>
References: <20101115234938.291159744@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Implement demand based update_cfs_load()
Message-ID: <tip-3b3d190ec3683d568fd2ebaead5e1ec7f97b6e37@git.kernel.org>
Git-Commit-ID: 3b3d190ec3683d568fd2ebaead5e1ec7f97b6e37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:12:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b3d190ec3683d568fd2ebaead5e1ec7f97b6e37
Gitweb:     http://git.kernel.org/tip/3b3d190ec3683d568fd2ebaead5e1ec7f97b6e37
Author:     Paul Turner <pjt@google.com>
AuthorDate: Mon, 15 Nov 2010 15:47:08 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:27:49 +0100

sched: Implement demand based update_cfs_load()

When the system is busy, dilation of rq->next_balance makes lb->update_shares()
insufficiently frequent for threads which don't sleep (no dequeue/enqueue
updates).  Adjust for this by making demand based updates based on the
accumulation of execution time sufficient to wrap our averaging window.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101115234938.291159744@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c      |    9 ++++++++-
 kernel/sched_fair.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dadab4d..e914a71 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -353,9 +353,16 @@ struct cfs_rq {
 	 */
 	unsigned long h_load;
 
+	/*
+	 * Maintaining per-cpu shares distribution for group scheduling
+	 *
+	 * load_stamp is the last time we updated the load average
+	 * load_last is the last time we updated the load average and saw load
+	 * load_unacc_exec_time is currently unaccounted execution time
+	 */
 	u64 load_avg;
 	u64 load_period;
-	u64 load_stamp, load_last;
+	u64 load_stamp, load_last, load_unacc_exec_time;
 
 	unsigned long load_contribution;
 #endif
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 33f941d..e7e2f08 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -539,6 +539,9 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return calc_delta_fair(sched_slice(cfs_rq, se), se);
 }
 
+static void update_cfs_load(struct cfs_rq *cfs_rq);
+static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta);
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -558,6 +561,14 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 	curr->vruntime += delta_exec_weighted;
 	update_min_vruntime(cfs_rq);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	cfs_rq->load_unacc_exec_time += delta_exec;
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq);
+		update_cfs_shares(cfs_rq, 0);
+	}
+#endif
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -713,6 +724,7 @@ static void update_cfs_load(struct cfs_rq *cfs_rq)
 	}
 
 	cfs_rq->load_stamp = now;
+	cfs_rq->load_unacc_exec_time = 0;
 	cfs_rq->load_period += delta;
 	if (load) {
 		cfs_rq->load_last = now;
