Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1GRXZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 19:25:18 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1GRXZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 19:25:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lV2CvBOX6sFMQH6L0z3B0j3eo9mwK/H+x7GJPJo4huCXULsOHyWlFLqJL8v4mB+2h
	+MeQDEk4vCM8h8yppyRRw==
MIME-Version: 1.0
In-Reply-To: <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de> <1310986258-29985-2-git-send-email-schnhrr@cs.tu-berlin.de>
From: Paul Turner <pjt@google.com>
Date: Mon, 18 Jul 2011 16:24:43 -0700
Message-ID: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
Subject: Re: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
To: =?ISO-8859-1?Q?Jan_H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 3:50 AM, Jan H. Schönherr
<schnhrr@cs.tu-berlin.de> wrote:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
>
> Currently, it is still possible that the ordering constraint
> is violated. Consider a hierarchy of at least three task groups:
>
> tg1 --> tg2 (parent of tg1)--> tg3 (grandparent of tg1)
>
> And the following actions:
> 1. Enqueue task in tg3
> 2. Enqueue task in tg1
>
> Due to step 1 tg3 will be on the list somewhere.

Argh, yeah nice catch.

What we really want is whether the node at the *highest* level in the
tree, "the root parent", is on queue as opposed to the immediate
parent as there may be a discontinuity in this state as your example
presents.

Although this would still be subject to deletion punching holes in things..

>
> However, in step 2 tg1 will be inserted at the end of the list, because
> its parent tg2 is not yet on the list. tg2 will then be inserted at the
> beginning. So we get:
>
> tg2 --> tg3 --> tg1
>
> This patch addresses this by carrying the information of the
> previously inserted leaf during bottom-up enqueuing.
>
> This allows us to insert everything without a child at the beginning of
> the list and all not yet enqueued parents of that runqueue right after it.
> This way, every series of enqueues is guaranteed to be inserted before
> older series. (Note, that this requires that a runqueue is not removed
> from the list if it has some children that are still on the list.)
>

One thing that bothers me about this is that it adds an implicit
positional dependency in enqueue_entity.  It's no longer safe to
enqueue/dequeue an arbitrary entity; this leads to situation 1 in the
follow-up patch requiring in-order removal.  If the enqueue is always
safe then this is not required.

I wonder if we could move this logic to the enqueue_task_fair path()
as that is the gating condition to become a leaf for load tracking.
Ideally we could build up a list of the untracked entities and then
splice it, but alas we have to use an rculist to track leaf cfs_rq's
so that we can walk it without locks in update shares.

hmmm, what about something like the below (only boot tested), it
should make the insert case always safe meaning we don't need to do
anything funky around delete:

---
Subject: [PATCH] sched: handle on_list ancestor in leaf_add_cfs_rq()
From: Paul Turner <pjt@google.com>
Date: Mon, 18 Jul 2011 16:08:10 -0700

Jan H. Schönherr found that in the case of an on_list ancestor we may
incorrectly place the child to the right of a great-ancestor on the list.

Consider:

      A
     / \     Here, t1A results in A->cfs_rq being on_list, however when
    B  t1A   we start enqueuing from C this will not be visible.  This is
   /         compounded by the fact that on_list expiration may also be out
  C          of order, punching holes in the tree.
 /
t1C

Prevent this by making additions to the leaf_cfs_rq_list position independent.
This is done by maintaining additions to this list within the
enqueue_task_fair() path, which allows us to always enqueue against the
current entity's first on_list ancestor.

Reported-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
Signed-off-by: Paul Turner <pjt@google.com>
---
 kernel/sched_fair.c |   55 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eb98f77..a7e0966 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -143,26 +143,39 @@ static inline struct cfs_rq *cpu_cfs_rq(struct
cfs_rq *cfs_rq, int this_cpu)
 	return cfs_rq->tg->cfs_rq[this_cpu];
 }

-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+/*
+ * rq->leaf_cfs_rq_list has an order constraint that specifies children must
+ * appear before parents.  For the (!on_list) chain starting at cfs_rq this
+ * finds a satisfactory insertion point.  If no ancestor is yet on_list, this
+ * choice is arbitrary.
+ */
+static inline struct list_head *find_leaf_cfs_rq_insertion(struct
cfs_rq *cfs_rq)
 {
-	if (!cfs_rq->on_list) {
-		/*
-		 * Ensure we either appear before our parent (if already
-		 * enqueued) or force our parent to appear after us when it is
-		 * enqueued.  The fact that we always enqueue bottom-up
-		 * reduces this to two cases.
-		 */
-		if (cfs_rq->tg->parent &&
-		    cfs_rq->tg->parent->cfs_rq[cpu_of(rq_of(cfs_rq))]->on_list) {
-			list_add_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		} else {
-			list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list,
-				&rq_of(cfs_rq)->leaf_cfs_rq_list);
-		}
+	struct sched_entity *se;
+
+	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
+	for_each_sched_entity(se)
+		if (cfs_rq->on_list)
+			return &cfs_rq->leaf_cfs_rq_list;

-		cfs_rq->on_list = 1;
+	return &rq_of(cfs_rq)->leaf_cfs_rq_list;
+}
+
+static inline void enqueue_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+				       struct list_head **leaf_insertion)
+{
+	if (cfs_rq->on_list) {
+		/* make sure we search again when !on_list follows on_list */
+		*leaf_insertion = NULL;
+		return;
 	}
+
+	if (!*leaf_insertion)
+		*leaf_insertion = find_leaf_cfs_rq_insertion(cfs_rq);
+
+	/* use insertion point as a queue head => children appear first */
+	list_add_tail_rcu(&cfs_rq->leaf_cfs_rq_list, *leaf_insertion);
+	cfs_rq->on_list = 1;
 }

 static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
@@ -276,7 +289,8 @@ static inline struct cfs_rq *cpu_cfs_rq(struct
cfs_rq *cfs_rq, int this_cpu)
 	return &cpu_rq(this_cpu)->cfs;
 }

-static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
+static inline void enqueue_leaf_cfs_rq(struct cfs_rq *cfs_rq,
+				       struct list_head **leaf_insertion)
 {
 }

@@ -997,9 +1011,6 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct
sched_entity *se, int flags)
 	if (se != cfs_rq->curr)
 		__enqueue_entity(cfs_rq, se);
 	se->on_rq = 1;
-
-	if (cfs_rq->nr_running == 1)
-		list_add_leaf_cfs_rq(cfs_rq);
 }

 static void __clear_buddies_last(struct sched_entity *se)
@@ -1326,12 +1337,14 @@ enqueue_task_fair(struct rq *rq, struct
task_struct *p, int flags)
 {
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se = &p->se;
+	struct list_head *leaf_insertion_point = NULL;

 	for_each_sched_entity(se) {
 		if (se->on_rq)
 			break;
 		cfs_rq = cfs_rq_of(se);
 		enqueue_entity(cfs_rq, se, flags);
+		enqueue_leaf_cfs_rq(cfs_rq, &leaf_insertion_point);
 		flags = ENQUEUE_WAKEUP;
 	}

-- 
1.7.3.1
