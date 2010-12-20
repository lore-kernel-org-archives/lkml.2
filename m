Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab0LTIhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:37:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:42278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0LTIhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:37:18 -0500
Date: Mon, 20 Dec 2010 08:36:50 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101216031038.067028969@google.com>
References: <20101216031038.067028969@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move periodic share updates to entity_tick()
Message-ID: <tip-43365bd7ff37979d2afdccbe953299ed64a4649b@git.kernel.org>
Git-Commit-ID: 43365bd7ff37979d2afdccbe953299ed64a4649b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 20 Dec 2010 08:36:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43365bd7ff37979d2afdccbe953299ed64a4649b
Gitweb:     http://git.kernel.org/tip/43365bd7ff37979d2afdccbe953299ed64a4649b
Author:     Paul Turner <pjt@google.com>
AuthorDate: Wed, 15 Dec 2010 19:10:17 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Dec 2010 16:36:22 +0100

sched: Move periodic share updates to entity_tick()

Long running entities that do not block (dequeue) require periodic updates to
maintain accurate share values.  (Note: group entities with several threads are
quite likely to be non-blocking in many circumstances).

By virtue of being long-running however, we will see entity ticks (otherwise
the required update occurs in dequeue/put and we are done).  Thus we can move
the detection (and associated work) for these updates into the periodic path.

This restores the 'atomicity' of update_curr() with respect to accounting.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101216031038.067028969@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index c886717..16ee398 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -564,10 +564,6 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 
 #if defined CONFIG_SMP && defined CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->load_unacc_exec_time += delta_exec;
-	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
-		update_cfs_load(cfs_rq, 0);
-		update_cfs_shares(cfs_rq, 0);
-	}
 #endif
 }
 
@@ -809,6 +805,14 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
+
+static void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+	if (cfs_rq->load_unacc_exec_time > sysctl_sched_shares_window) {
+		update_cfs_load(cfs_rq, 0);
+		update_cfs_shares(cfs_rq, 0);
+	}
+}
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 {
@@ -817,6 +821,10 @@ static void update_cfs_load(struct cfs_rq *cfs_rq, int global_update)
 static inline void update_cfs_shares(struct cfs_rq *cfs_rq, long weight_delta)
 {
 }
+
+static inline void update_entity_shares_tick(struct cfs_rq *cfs_rq)
+{
+}
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1133,6 +1141,11 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_curr(cfs_rq);
 
+	/*
+	 * Update share accounting for long-running entities.
+	 */
+	update_entity_shares_tick(cfs_rq);
+
 #ifdef CONFIG_SCHED_HRTICK
 	/*
 	 * queued ticks are scheduled to match the slice, so don't bother
