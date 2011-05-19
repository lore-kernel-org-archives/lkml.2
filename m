Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513Ab1ESTlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:41:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934493Ab1ESTig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:38:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com, vgoyal@redhat.com
Subject: [PATCH 04/13] cfq-iosched: Fix a possible race with cfq cgroup removal code
Date: Thu, 19 May 2011 15:38:22 -0400
Message-Id: <1305833911-7717-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg->key = cfqd is an rcu protected pointer and hence we used to do
call_rcu(cfqd->rcu_head) to free up cfqd after one rcu grace period.

The problem here is that even though cfqd is around, there are no
gurantees that associated request queue (td->queue) or q->queue_lock
is still around. A driver might have called blk_cleanup_queue() and
release the lock.

It might happen that after freeing up the lock we call
blkg->key->queue->queue_ock and crash. This is possible in following
path.

blkiocg_destroy()
 blkio_unlink_group_fn()
  cfq_unlink_blkio_group()

Hence, wait for an rcu peirod if there are groups which have not
been unlinked from blkcg->blkg_list. That way, if there are any groups
which are taking cfq_unlink_blkio_group() path, can safely take queue
lock.

This is how we have taken care of race in throttling logic also.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   48 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a905b55..e2e6719 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -300,7 +300,9 @@ struct cfq_data {
 
 	/* List of cfq groups being managed on this device*/
 	struct hlist_head cfqg_list;
-	struct rcu_head rcu;
+
+	/* Number of groups which are on blkcg->blkg_list */
+	unsigned int nr_blkcg_linked_grps;
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
@@ -1063,6 +1065,7 @@ static struct cfq_group * cfq_find_alloc_cfqg(struct cfq_data *cfqd,
 		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					0);
 
+	cfqd->nr_blkcg_linked_grps++;
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
@@ -3815,15 +3818,11 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
 		cfq_put_queue(cfqd->async_idle_cfqq);
 }
 
-static void cfq_cfqd_free(struct rcu_head *head)
-{
-	kfree(container_of(head, struct cfq_data, rcu));
-}
-
 static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
 	struct request_queue *q = cfqd->queue;
+	bool wait = false;
 
 	cfq_shutdown_timer_wq(cfqd);
 
@@ -3842,7 +3841,13 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
-	cfq_blkiocg_del_blkio_group(&cfqd->root_group.blkg);
+
+	/*
+	 * If there are groups which we could not unlink from blkcg list,
+	 * wait for a rcu period for them to be freed.
+	 */
+	if (cfqd->nr_blkcg_linked_grps)
+		wait = true;
 
 	spin_unlock_irq(q->queue_lock);
 
@@ -3852,8 +3857,20 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	ida_remove(&cic_index_ida, cfqd->cic_index);
 	spin_unlock(&cic_index_lock);
 
-	/* Wait for cfqg->blkg->key accessors to exit their grace periods. */
-	call_rcu(&cfqd->rcu, cfq_cfqd_free);
+	/*
+	 * Wait for cfqg->blkg->key accessors to exit their grace periods.
+	 * Do this wait only if there are other unlinked groups out
+	 * there. This can happen if cgroup deletion path claimed the
+	 * responsibility of cleaning up a group before queue cleanup code
+	 * get to the group.
+	 *
+	 * Do not call synchronize_rcu() unconditionally as there are drivers
+	 * which create/delete request queue hundreds of times during scan/boot
+	 * and synchronize_rcu() can take significant time and slow down boot.
+	 */
+	if (wait)
+		synchronize_rcu();
+	kfree(cfqd);
 }
 
 static int cfq_alloc_cic_index(void)
@@ -3909,14 +3926,21 @@ static void *cfq_init_queue(struct request_queue *q)
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
-	 * Take a reference to root group which we never drop. This is just
-	 * to make sure that cfq_put_cfqg() does not try to kfree root group
+	 * Set root group reference to 2. One reference will be dropped when
+	 * all groups on cfqd->cfqg_list are being deleted during queue exit.
+	 * Other reference will remain there as we don't want to delete this
+	 * group as it is statically allocated and gets destroyed when
+	 * throtl_data goes away.
 	 */
-	cfqg->ref = 1;
+	cfqg->ref = 2;
 	rcu_read_lock();
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);
 	rcu_read_unlock();
+	cfqd->nr_blkcg_linked_grps++;
+
+	/* Add group on cfqd->cfqg_list */
+	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
 #endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.7.4.4

