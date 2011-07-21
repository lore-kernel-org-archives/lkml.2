Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GUSbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:31:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:56822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab1GUSbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:31:42 -0400
Date: Thu, 21 Jul 2011 18:31:28 GMT
From: tip-bot for Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Message-ID: <tip-ns12mnd2h5w8rb9agd8hnsfk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stephan.baerwolf@tu-ilmenau.de,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stephan.baerwolf@tu-ilmenau.de, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Replace use of entity_key()
Git-Commit-ID: 2bd2d6f2dc952fc44fc52887de36e51896da96b9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 18:31:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bd2d6f2dc952fc44fc52887de36e51896da96b9
Gitweb:     http://git.kernel.org/tip/2bd2d6f2dc952fc44fc52887de36e51896da96b9
Author:     Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
AuthorDate: Wed, 20 Jul 2011 14:46:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 18:01:55 +0200

sched: Replace use of entity_key()

"entity_key()" is only used in "__enqueue_entity()" and
its only function is to subtract a tasks vruntime by
its groups minvruntime.
Before this patch a rbtree enqueue-decision is done by
comparing two tasks in the style:

	"if (entity_key(cfs_rq, se) < entity_key(cfs_rq, entry))"

which would be

	"if (se->vruntime-cfs_rq->min_vruntime < entry->vruntime-cfs_rq->min_vruntime)"

or (if reducing cfs_rq->min_vruntime out)

	"if (se->vruntime < entry->vruntime)"

which is

	"if (entity_before(se, entry))"

So we do not need "entity_key()".
If "entity_before()" is inline we will also save one subtraction (only one,
because "entity_key(cfs_rq, se)"  was cached in "key")

Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ns12mnd2h5w8rb9agd8hnsfk@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0588c0b..a2ecbaa 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -321,11 +321,6 @@ static inline int entity_before(struct sched_entity *a,
 	return (s64)(a->vruntime - b->vruntime) < 0;
 }
 
-static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
-{
-	return se->vruntime - cfs_rq->min_vruntime;
-}
-
 static void update_min_vruntime(struct cfs_rq *cfs_rq)
 {
 	u64 vruntime = cfs_rq->min_vruntime;
@@ -359,7 +354,6 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
 	struct rb_node *parent = NULL;
 	struct sched_entity *entry;
-	s64 key = entity_key(cfs_rq, se);
 	int leftmost = 1;
 
 	/*
@@ -372,7 +366,7 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 		 * We dont care about collisions. Nodes with
 		 * the same key stay together.
 		 */
-		if (key < entity_key(cfs_rq, entry)) {
+		if (entity_before(se, entry)) {
 			link = &parent->rb_left;
 		} else {
 			link = &parent->rb_right;
