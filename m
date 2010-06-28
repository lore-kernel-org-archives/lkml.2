Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0F1NRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 09:17:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:34095 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0F1NRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 09:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uDmU37nDXznGHBJfZ2JRy+YxBaUFRc13/sDW6JeXdH1hShRJ2Z1or6+j+YG11zWhUq
         QY7J3fJ+isQt77nTxg2UurJvkE4V5vOVukbXnTcUW5H6RDLLtxrUJFGJ2nBGvLAPXnGE
         iyK1e5xEf8hbzE2Ys0BGXEOdDgKz0WBX2izzo=
MIME-Version: 1.0
Date: Mon, 28 Jun 2010 21:17:03 +0800
Message-ID: <AANLkTilJDrpoFGyTSrKg3Hg59u9TvBLbxk4HAVKBvjxQ@mail.gmail.com>
Subject: [PATCH] avoid return NULL on root rb_node in rb_next/rb_prev in 
	lib/rbtree.c
From: shenghui <crosslonelyover@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-mm@kvack.org, mingo@elte.hu,
       peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

       I'm reading cfs code, and get the following potential bug.

In kernel/sched_fair.c, we can get the following call thread:

1778static struct task_struct *pick_next_task_fair(struct rq *rq)
1779{
...
1787        do {
1788                se = pick_next_entity(cfs_rq);
1789                set_next_entity(cfs_rq, se);
1790                cfs_rq = group_cfs_rq(se);
1791        } while (cfs_rq);
...
1797}

 925static struct sched_entity *pick_next_entity(struct cfs_rq *cfs_rq)
 926{
 927        struct sched_entity *se = __pick_next_entity(cfs_rq);
...
 941        return se;
 942}

 377static struct sched_entity *__pick_next_entity(struct cfs_rq *cfs_rq)
 378{
 379        struct rb_node *left = cfs_rq->rb_leftmost;
 380
 381        if (!left)
 382                return NULL;
 ...
 385}

To manipulate cfs_rq->rb_leftmost, __dequeue_entity does the following:

 365static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 366{
 367        if (cfs_rq->rb_leftmost == &se->run_node) {
 368                struct rb_node *next_node;
 369
 370                next_node = rb_next(&se->run_node);
 371                cfs_rq->rb_leftmost = next_node;
 372        }
 373
 374        rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
 375}

Here, if se->run_node is the root rb_node, next_node will be set NULL
by rb_next.
Then __pick_next_entity may get NULL on some call, and set_next_entity
may deference
NULL value.

 892static void
 893set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 894{
 895        /* 'current' is not kept within the tree. */
 896        if (se->on_rq) {
...
 919        se->prev_sum_exec_runtime = se->sum_exec_runtime;
 920}

Following is my patch. Please check it.


>From cb076095b9c93860afb037c50bb70c4a957c9118 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
Date: Mon, 28 Jun 2010 19:13:33 +0800
Subject: [PATCH] avoid return NULL on root rb_node in rb_next/rb_prev
in lib/rbtree.c


Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
---
 lib/rbtree.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 15e10b1..474e9fd 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -356,9 +356,6 @@ struct rb_node *rb_next(const struct rb_node *node)
 {
 	struct rb_node *parent;

-	if (rb_parent(node) == node)
-		return NULL;
-
 	/* If we have a right-hand child, go down and then left as far
 	   as we can. */
 	if (node->rb_right) {
@@ -385,9 +382,6 @@ struct rb_node *rb_prev(const struct rb_node *node)
 {
 	struct rb_node *parent;

-	if (rb_parent(node) == node)
-		return NULL;
-
 	/* If we have a left-hand child, go down and then right as far
 	   as we can. */
 	if (node->rb_left) {
-- 
1.6.3.3



-- 


Thanks and Best Regards,
shenghui
