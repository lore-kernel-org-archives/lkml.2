Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab2EQDB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 23:01:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760477Ab2EQDBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 23:01:55 -0400
From: Doug Ledford <dledford@redhat.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com,
        levinsasha928@gmail.com, npiggin@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
Subject: [Patch Version 2] ipc/mqueue: add rbtree node caching support
Date: Wed, 16 May 2012 23:01:48 -0400
Message-Id: <9fa919ff0af4808c8ae470391a4edc694c165746.1337223649.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I wrote the first patch that added the rbtree support for message
queue insertion, it sped up the case where the queue was very full
drastically from the original code.  It, however, slowed down the
case where the queue was empty (not drastically though).

This patch caches the last freed rbtree node struct so we can quickly
reuse it when we get a new message.  This is the common path for any
queue that very frequently goes from 0 to 1 then back to 0 messages
in queue.

Andrew Morton didn't like that we were doing a GFP_ATOMIC allocation
in msg_insert, so this patch attempts to speculatively allocate a
new node struct outside of the spin lock when we know we need it, but
will still fall back to a GFP_ATOMIC allocation if it has to.

Once I added the caching, the necessary various ret = ; spin_unlock
gyrations in mq_timedsend were getting pretty ugly, so this also slightly
refactors that function to streamline the flow of the code and the
function exit.

Finally, while working on getting performance back I made sure that all
of the node structs were always fully initialized when they were first
used, rendering the use of kzalloc unnecessary and a waste of CPU cycles.

The net result of all of this is:

1) We will avoid a GFP_ATOMIC allocation when possible, but fall back on
it when necessary.
2) We will speculatively allocate a node struct using GFP_KERNEL if our
cache is empty (and save the struct to our cache if it's still empty after
we have obtained the spin lock).
3) The performance of the common queue empty case has significantly
improved and is now much more in line with the older performance for
this case.

The performance changes are:

            Old mqueue      new mqueue      new mqueue + caching
queue empty
send/recv   305/288ns       349/318ns       310/322ns

I don't think we'll ever be able to get the recv performance back, but
that's because the old recv performance was a direct result and consequence
of the old methods abysmal send performance.  The recv path simply must
do more so that the send path does not incur such a penalty under higher
queue depths.

As it turns out, the new caching code also sped up the various queue full
cases relative to my last patch.  That could be because of the difference
between the syscall path in 3.3.4-rc5 and 3.3.4-rc6, or because of the
change in code flow in the mq_timedsend routine.  Regardless, I'll take
it.  It wasn't huge, and I *would* say it was within the margin for error,
but after many repeated runs what I'm seeing is that the old numbers
trend slightly higher (about 10 to 20ns depending on which test is the
one running).

Signed-off-by: Doug Ledford <dledford@redhat.com>

Version 2:

Incorporate style changes from Andrew Morton
Don't bother passing new_leaf around...when I added the code inside
the spinlock to move new_leaf to info->node_cache, it really should
have been removed then as it now became impossible for us to ever
use new_leaf, we would either have a node_cache, or neither node_cache
or new_leaf.
Clean up the logic in msg_insert with this change in mind.

Performance also improved slightly with this logic change.  New
timings show a insert time of about 306ns.  That brings us right
in line with the old insert time.  Yay!

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 ipc/mqueue.c |  104 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 81 insertions(+), 23 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 994c5e1..b35dc47 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -68,6 +68,7 @@ struct mqueue_inode_info {
 	wait_queue_head_t wait_q;
 
 	struct rb_root msg_tree;
+	struct posix_msg_tree_node *node_cache;
 	struct mq_attr attr;
 
 	struct sigevent notify;
@@ -132,15 +133,20 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
 		else
 			p = &(*p)->rb_right;
 	}
-	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
-	if (!leaf)
-		return -ENOMEM;
-	rb_init_node(&leaf->rb_node);
-	INIT_LIST_HEAD(&leaf->msg_list);
+	if (info->node_cache) {
+		leaf = info->node_cache;
+		info->node_cache = NULL;
+	} else {
+		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
+		if (!leaf)
+			return -ENOMEM;
+		rb_init_node(&leaf->rb_node);
+		INIT_LIST_HEAD(&leaf->msg_list);
+		info->qsize += sizeof(*leaf);
+	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
 	rb_insert_color(&leaf->rb_node, &info->msg_tree);
-	info->qsize += sizeof(struct posix_msg_tree_node);
 insert_msg:
 	info->attr.mq_curmsgs++;
 	info->qsize += msg->m_ts;
@@ -175,13 +181,17 @@ try_again:
 		return NULL;
 	}
 	leaf = rb_entry(parent, struct posix_msg_tree_node, rb_node);
-	if (list_empty(&leaf->msg_list)) {
+	if (unlikely(list_empty(&leaf->msg_list))) {
 		pr_warn_once("Inconsistency in POSIX message queue, "
 			     "empty leaf node but we haven't implemented "
 			     "lazy leaf delete!\n");
 		rb_erase(&leaf->rb_node, &info->msg_tree);
-		info->qsize -= sizeof(struct posix_msg_tree_node);
-		kfree(leaf);
+		if (info->node_cache) {
+			info->qsize -= sizeof(*leaf);
+			kfree(leaf);
+		} else {
+			info->node_cache = leaf;
+		}
 		goto try_again;
 	} else {
 		msg = list_first_entry(&leaf->msg_list,
@@ -189,8 +199,12 @@ try_again:
 		list_del(&msg->m_list);
 		if (list_empty(&leaf->msg_list)) {
 			rb_erase(&leaf->rb_node, &info->msg_tree);
-			info->qsize -= sizeof(struct posix_msg_tree_node);
-			kfree(leaf);
+			if (info->node_cache) {
+				info->qsize -= sizeof(*leaf);
+				kfree(leaf);
+			} else {
+				info->node_cache = leaf;
+			}
 		}
 	}
 	info->attr.mq_curmsgs--;
@@ -232,6 +246,7 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		info->qsize = 0;
 		info->user = NULL;	/* set when all is ok */
 		info->msg_tree = RB_ROOT;
+		info->node_cache = NULL;
 		memset(&info->attr, 0, sizeof(info->attr));
 		info->attr.mq_maxmsg = min(ipc_ns->mq_msg_max,
 					   ipc_ns->mq_msg_default);
@@ -364,6 +379,7 @@ static void mqueue_evict_inode(struct inode *inode)
 	spin_lock(&info->lock);
 	while ((msg = msg_get(info)) != NULL)
 		free_msg(msg);
+	kfree(info->node_cache);
 	spin_unlock(&info->lock);
 
 	/* Total amount of bytes accounted for the mqueue */
@@ -958,7 +974,8 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	struct mqueue_inode_info *info;
 	ktime_t expires, *timeout = NULL;
 	struct timespec ts;
-	int ret;
+	struct posix_msg_tree_node *new_leaf = NULL;
+	int ret = 0;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
@@ -1006,39 +1023,60 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqdes, const char __user *, u_msg_ptr,
 	msg_ptr->m_ts = msg_len;
 	msg_ptr->m_type = msg_prio;
 
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so
+	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
+	 * fall back to that if necessary.
+	 */
+	if (!info->node_cache)
+		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
+
 	spin_lock(&info->lock);
 
+	if (!info->node_cache && new_leaf) {
+		/* Save our speculative allocation into the cache */
+		rb_init_node(&new_leaf->rb_node);
+		INIT_LIST_HEAD(&new_leaf->msg_list);
+		info->node_cache = new_leaf;
+		info->qsize += sizeof(*new_leaf);
+		new_leaf = NULL;
+	} else if (new_leaf) {
+		kfree(new_leaf);
+	}
+
 	if (info->attr.mq_curmsgs == info->attr.mq_maxmsg) {
 		if (filp->f_flags & O_NONBLOCK) {
-			spin_unlock(&info->lock);
 			ret = -EAGAIN;
 		} else {
 			wait.task = current;
 			wait.msg = (void *) msg_ptr;
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, SEND, timeout, &wait);
+			/*
+			 * wq_sleep must be called with info->lock held, and
+			 * returns with the lock released
+			 */
+			goto out_free;
 		}
-		if (ret < 0)
-			free_msg(msg_ptr);
 	} else {
 		receiver = wq_get_first_waiter(info, RECV);
 		if (receiver) {
 			pipelined_send(info, msg_ptr, receiver);
 		} else {
 			/* adds message to the queue */
-			if (msg_insert(msg_ptr, info)) {
-				free_msg(msg_ptr);
-				ret = -ENOMEM;
-				spin_unlock(&info->lock);
-				goto out_fput;
-			}
+			ret = msg_insert(msg_ptr, info);
+			if (ret)
+				goto out_unlock;
 			__do_notify(info);
 		}
 		inode->i_atime = inode->i_mtime = inode->i_ctime =
 				CURRENT_TIME;
-		spin_unlock(&info->lock);
-		ret = 0;
 	}
+out_unlock:
+	spin_unlock(&info->lock);
+out_free:
+	if (ret)
+		free_msg(msg_ptr);
 out_fput:
 	fput(filp);
 out:
@@ -1057,6 +1095,7 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 	struct ext_wait_queue wait;
 	ktime_t expires, *timeout = NULL;
 	struct timespec ts;
+	struct posix_msg_tree_node *new_leaf = NULL;
 
 	if (u_abs_timeout) {
 		int res = prepare_timeout(u_abs_timeout, &expires, &ts);
@@ -1092,7 +1131,26 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, mqdes, char __user *, u_msg_ptr,
 		goto out_fput;
 	}
 
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so
+	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
+	 * fall back to that if necessary.
+	 */
+	if (!info->node_cache)
+		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
+
 	spin_lock(&info->lock);
+
+	if (!info->node_cache && new_leaf) {
+		/* Save our speculative allocation into the cache */
+		rb_init_node(&new_leaf->rb_node);
+		INIT_LIST_HEAD(&new_leaf->msg_list);
+		info->node_cache = new_leaf;
+		info->qsize += sizeof(*new_leaf);
+	} else if (new_leaf) {
+		kfree(new_leaf);
+	}
+
 	if (info->attr.mq_curmsgs == 0) {
 		if (filp->f_flags & O_NONBLOCK) {
 			spin_unlock(&info->lock);
-- 
1.7.7.6

