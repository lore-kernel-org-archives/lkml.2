Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1BCOMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:12:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:35785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1BCOMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:12:21 -0500
Date: Thu, 3 Feb 2011 14:11:54 GMT
From: tip-bot for Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, riel@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, riel@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110201094837.6b0962a9@annuminas.surriel.com>
References: <20110201094837.6b0962a9@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Limit the scope of clear_buddies
Message-ID: <tip-2c13c919d9e9a3db9896143a501f83dcbbe1ced4@git.kernel.org>
Git-Commit-ID: 2c13c919d9e9a3db9896143a501f83dcbbe1ced4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 03 Feb 2011 14:11:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c13c919d9e9a3db9896143a501f83dcbbe1ced4
Gitweb:     http://git.kernel.org/tip/2c13c919d9e9a3db9896143a501f83dcbbe1ced4
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Tue, 1 Feb 2011 09:48:37 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Feb 2011 14:20:32 +0100

sched: Limit the scope of clear_buddies

The clear_buddies function does not seem to play well with the concept
of hierarchical runqueues.  In the following tree, task groups are
represented by 'G', tasks by 'T', next by 'n' and last by 'l'.

     (nl)
    /    \
   G(nl)  G
   / \     \
 T(l) T(n)  T

This situation can arise when a task is woken up T(n), and the previously
running task T(l) is marked last.

When clear_buddies is called from either T(l) or T(n), the next and last
buddies of the group G(nl) will be cleared.  This is not the desired
result, since we would like to be able to find the other type of buddy
in many cases.

This especially a worry when implementing yield_task_fair through the
buddy system.

The fix is simple: only clear the buddy type that the task itself
is indicated to be.  As an added bonus, we stop walking up the tree
when the buddy has already been cleared or pointed elsewhere.

Signed-off-by: Rik van Riel <riel@redhat.coM>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110201094837.6b0962a9@annuminas.surriel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4de9905..a785e08 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -995,19 +995,35 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 		list_add_leaf_cfs_rq(cfs_rq);
 }
 
-static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
+static void __clear_buddies_last(struct sched_entity *se)
 {
-	if (!se || cfs_rq->last == se)
-		cfs_rq->last = NULL;
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->last == se)
+			cfs_rq->last = NULL;
+		else
+			break;
+	}
+}
 
-	if (!se || cfs_rq->next == se)
-		cfs_rq->next = NULL;
+static void __clear_buddies_next(struct sched_entity *se)
+{
+	for_each_sched_entity(se) {
+		struct cfs_rq *cfs_rq = cfs_rq_of(se);
+		if (cfs_rq->next == se)
+			cfs_rq->next = NULL;
+		else
+			break;
+	}
 }
 
 static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	for_each_sched_entity(se)
-		__clear_buddies(cfs_rq_of(se), se);
+	if (cfs_rq->last == se)
+		__clear_buddies_last(se);
+
+	if (cfs_rq->next == se)
+		__clear_buddies_next(se);
 }
 
 static void
