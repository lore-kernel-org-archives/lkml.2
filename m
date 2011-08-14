Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1HNQcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:32:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:43480 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab1HNQcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:32:48 -0400
Date: Sun, 14 Aug 2011 16:32:29 GMT
From: tip-bot for Paul Turner <pjt@google.com>
Message-ID: <tip-5238cdd3873e67a98b28c1161d65d2a615c320a3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110721184757.886850167@google.com>
References: <20110721184757.886850167@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Prevent buddy interactions with throttled entities
Git-Commit-ID: 5238cdd3873e67a98b28c1161d65d2a615c320a3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 16:32:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5238cdd3873e67a98b28c1161d65d2a615c320a3
Gitweb:     http://git.kernel.org/tip/5238cdd3873e67a98b28c1161d65d2a615c320a3
Author:     Paul Turner <pjt@google.com>
AuthorDate: Thu, 21 Jul 2011 09:43:37 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Aug 2011 12:03:42 +0200

sched: Prevent buddy interactions with throttled entities

Buddies allow us to select "on-rq" entities without actually selecting them
from a cfs_rq's rb_tree.  As a result we must ensure that throttled entities
are not falsely nominated as buddies.  The fact that entities are dequeued
within throttle_entity is not sufficient for clearing buddy status as the
nomination may occur after throttling.

Signed-off-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110721184757.886850167@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5a20894..1d4acbe 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2348,6 +2348,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	if (unlikely(se == pse))
 		return;
 
+	/*
+	 * This is possible from callers such as pull_task(), in which we
+	 * unconditionally check_prempt_curr() after an enqueue (which may have
+	 * lead to a throttle).  This both saves work and prevents false
+	 * next-buddy nomination below.
+	 */
+	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
+		return;
+
 	if (sched_feat(NEXT_BUDDY) && scale && !(wake_flags & WF_FORK)) {
 		set_next_buddy(pse);
 		next_buddy_marked = 1;
@@ -2356,6 +2365,12 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	/*
 	 * We can come here with TIF_NEED_RESCHED already set from new task
 	 * wake up path.
+	 *
+	 * Note: this also catches the edge-case of curr being in a throttled
+	 * group (e.g. via set_curr_task), since update_curr() (in the
+	 * enqueue of curr) will have resulted in resched being set.  This
+	 * prevents us from potentially nominating it as a false LAST_BUDDY
+	 * below.
 	 */
 	if (test_tsk_need_resched(curr))
 		return;
@@ -2474,7 +2489,8 @@ static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preemp
 {
 	struct sched_entity *se = &p->se;
 
-	if (!se->on_rq)
+	/* throttled hierarchies are not runnable */
+	if (!se->on_rq || throttled_hierarchy(cfs_rq_of(se)))
 		return false;
 
 	/* Tell the scheduler that we'd really like pse to run next. */
