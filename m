Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab0E0P3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:29:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51093 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab0E0P3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:29:43 -0400
Subject: Re: [tip:x86/pat] rbtree: Add support for augmented rbtrees
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	 <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 May 2010 17:29:43 +0200
Message-ID: <1274974183.27810.5233.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 00:21 +0000, tip-bot for Pallipadi, Venkatesh
wrote:
> Commit-ID:  17d9ddc72fb8bba0d4f67868c9c612e472a594a9
> Gitweb:     http://git.kernel.org/tip/17d9ddc72fb8bba0d4f67868c9c612e472a594a9
> Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> AuthorDate: Wed, 10 Feb 2010 15:23:44 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 18 Feb 2010 15:40:56 -0800
> 
> rbtree: Add support for augmented rbtrees
> 
> Add support for augmented rbtrees in core rbtree code.
> 
> This will be used in subsequent patches, in x86 PAT code, which needs
> interval trees to efficiently keep track of PAT ranges.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> LKML-Reference: <20100210232343.GA11465@linux-os.sc.intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -44,6 +44,11 @@ static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
>  	else
>  		root->rb_node = right;
>  	rb_set_parent(node, right);
> +
> +	if (root->augment_cb) {
> +		root->augment_cb(node);
> +		root->augment_cb(right);
> +	}
>  }
>  
>  static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
> @@ -67,12 +72,20 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
>  	else
>  		root->rb_node = left;
>  	rb_set_parent(node, left);
> +
> +	if (root->augment_cb) {
> +		root->augment_cb(node);
> +		root->augment_cb(left);
> +	}
>  }
>  

Did someone measure what these extra conditionals do to the scheduler?

Also, I don't think you actually need this callback, you can augment
externally like this ('borrowed' the idea from the BFQ code):

full patch at:
http://programming.kicks-ass.net/kernel-patches/sched_eevdf.patch

+static inline struct sched_entity *se_of(struct rb_node *node)
+{
+	return rb_entry(node, struct sched_entity, run_node);
+}
+
+static inline s64 deadline_key(struct cfs_rq *cfs_rq, u64 deadline)
+{
+	return (s64)(deadline - cfs_rq->min_vruntime);
+}
+
+#define deadline_gt(cfs_rq, field, lse, rse)			\
+({ deadline_key(cfs_rq, lse->field) >				\
+   deadline_key(cfs_rq, rse->field); })
+
+static void update_min_deadline(struct cfs_rq *cfs_rq,
+				struct sched_entity *se, struct rb_node *node)
+{
+	if (node && deadline_gt(cfs_rq, min_deadline, se, se_of(node)))
+		se->min_deadline = se_of(node)->min_deadline;
+}
+
+/*
+ * se->min_deadline = min(se->deadline, left->min_deadline, right->min_deadline)
+ */
+static void update_node(struct cfs_rq *cfs_rq, struct rb_node *node)
+{
+	struct sched_entity *se = rb_entry(node, struct sched_entity, run_node);
+
+	se->min_deadline = se->deadline;
+	update_min_deadline(cfs_rq, se, node->rb_right);
+	update_min_deadline(cfs_rq, se, node->rb_left);
+}
+
+/*
+ * update min_deadline for all nodes that could have been affected by
+ * a rebalance pass up from @node
+ */
+static void update_tree(struct cfs_rq *cfs_rq, struct rb_node *node)
+{
+	struct rb_node *parent;
+
+up:
+	update_node(cfs_rq, node);
+	parent = rb_parent(node);
+	if (!parent)
+		return;
+
+	if (node == parent->rb_left && parent->rb_right)
+		update_node(cfs_rq, parent->rb_right);
+	else if (parent->rb_left)
+		update_node(cfs_rq, parent->rb_left);
+
+	node = parent;
+	goto up;
+}
+
+/*
+ * after inserting @se into the tree, update min_deadline to account for
+ * both the new deadline and any damage done by rebalance
+ */
+static void update_tree_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
+{
+	struct rb_node *node = &se->run_node;
+
+	if (node->rb_left)
+		node = node->rb_left;
+	else if (node->rb_right)
+		node = node->rb_right;
+
+	update_tree(cfs_rq, node);
+}
+
+/*
+ * before removing the node, find the deepest node on the rebalance path
+ * that will still be there after @se gets removed
+ */
+static struct rb_node *update_tree_dequeue_begin(struct sched_entity *se)
+{
+	struct rb_node *deepest;
+	struct rb_node *node = &se->run_node;
+
+	if (!node->rb_right && !node->rb_left)
+		deepest = rb_parent(node);
+	else if (!node->rb_right)
+		deepest = node->rb_left;
+	else if (!node->rb_left)
+		deepest = node->rb_right;
+	else {
+		deepest = rb_next(node);
+		if (deepest->rb_right)
+			deepest = deepest->rb_right;
+		else if (rb_parent(deepest) != node)
+			deepest = rb_parent(deepest);
+	}
+
+	return deepest;
+}
+
+/*
+ * now that the entity got removed, update min_deadline to undo the missing
+ * deadine and any rebalance damage
+ */
+static void update_tree_dequeue_end(struct cfs_rq *cfs_rq, struct rb_node *node)
+{
+	if (node)
+		update_tree(cfs_rq, node);
 }
 
 /*
@@ -360,10 +578,14 @@ static void __enqueue_entity(struct cfs_
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
+
+	update_tree_enqueue(cfs_rq, se);
 }
 
 static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
+	struct rb_node *node = update_tree_dequeue_begin(se);
+
 	if (cfs_rq->rb_leftmost == &se->run_node) {
 		struct rb_node *next_node;
 
@@ -372,16 +594,145 @@ static void __dequeue_entity(struct cfs_
 	}
 
 	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	update_tree_dequeue_end(cfs_rq, node);
+	avg_vruntime_sub(cfs_rq, se);
 }
