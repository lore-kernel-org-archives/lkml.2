Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1CVXKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 19:10:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54992 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab1CVXJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 19:09:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=FHspnlqGvEKMJM1QBG76gK1tnc4YvgmwaxP0a5fY22n4zvK1hXSI6YtJh3QpDtyK6
	Zsv7rbusH6ri1O7cm+XYw==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp, taka@valinux.co.jp,
        kamezawa.hiroyu@jp.fujitsu.com, righi.andrea@gmail.com,
        guijianfeng@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
        ctalbott@google.com, linux-kernel@vger.kernel.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH v2 1/8] cfq-iosched: add symmetric reference wrappers
Date: Tue, 22 Mar 2011 16:08:48 -0700
Message-Id: <1300835335-2777-2-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300835335-2777-1-git-send-email-teravest@google.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cfq_group and cfq_queue objects did not have symmetric
wrapper functions and many of the reference taking was
open coded. For clarity add the following wrappers:

cfq_group:
- cfq_get_group_ref()
- cfq_put_group_ref()

cfq_queue:
- cfq_get_queue_ref()
- cfq_put_queue_ref()

The use of '_ref' was done not to collide with existing
function names.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   95 +++++++++++++++++++++++++++++---------------------
 1 files changed, 55 insertions(+), 40 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 12e380b..74510f5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -303,6 +303,11 @@ struct cfq_data {
 	struct rcu_head rcu;
 };
 
+static void cfq_get_group_ref(struct cfq_group *cfqg);
+static void cfq_put_group_ref(struct cfq_group *cfqg);
+static void cfq_get_queue_ref(struct cfq_queue *cfqq);
+static void cfq_put_queue_ref(struct cfq_queue *cfqq);
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
@@ -1048,7 +1053,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	 * elevator which will be dropped by either elevator exit
 	 * or cgroup deletion path depending on who is exiting first.
 	 */
-	cfqg->ref = 1;
+	cfq_get_group_ref(cfqg);
 
 	/*
 	 * Add group onto cgroup list. It might happen that bdi->dev is
@@ -1091,24 +1096,12 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 	return cfqg;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
+static void cfq_get_group_ref(struct cfq_group *cfqg)
 {
 	cfqg->ref++;
-	return cfqg;
 }
 
-static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
-{
-	/* Currently, all async queues are mapped to root group */
-	if (!cfq_cfqq_sync(cfqq))
-		cfqg = &cfqq->cfqd->root_group;
-
-	cfqq->cfqg = cfqg;
-	/* cfqq reference on cfqg */
-	cfqq->cfqg->ref++;
-}
-
-static void cfq_put_cfqg(struct cfq_group *cfqg)
+static void cfq_put_group_ref(struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st;
 	int i, j;
@@ -1122,6 +1115,17 @@ static void cfq_put_cfqg(struct cfq_group *cfqg)
 	kfree(cfqg);
 }
 
+static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
+{
+	/* Currently, all async queues are mapped to root group */
+	if (!cfq_cfqq_sync(cfqq))
+		cfqg = &cfqq->cfqd->root_group;
+
+	cfqq->cfqg = cfqg;
+	/* cfqq reference on cfqg */
+	cfq_get_group_ref(cfqq->cfqg);
+}
+
 static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	/* Something wrong if we are trying to remove same group twice */
@@ -1133,7 +1137,7 @@ static void cfq_destroy_cfqg(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * Put the reference taken at the time of creation so that when all
 	 * queues are gone, group can be destroyed.
 	 */
-	cfq_put_cfqg(cfqg);
+	cfq_put_group_ref(cfqg);
 }
 
 static void cfq_release_cfq_groups(struct cfq_data *cfqd)
@@ -1177,14 +1181,18 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 }
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+
+static void cfq_get_group_ref(struct cfq_group *cfqg)
 {
-	return &cfqd->root_group;
 }
 
-static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
+static void cfq_put_group_ref(struct cfq_group *cfqg)
 {
-	return cfqg;
+}
+
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+{
+	return &cfqd->root_group;
 }
 
 static inline void
@@ -1193,7 +1201,6 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 }
 
 static void cfq_release_cfq_groups(struct cfq_data *cfqd) {}
-static inline void cfq_put_cfqg(struct cfq_group *cfqg) {}
 
 #endif /* GROUP_IOSCHED */
 
@@ -2553,6 +2560,11 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	return 1;
 }
 
+static void cfq_get_queue_ref(struct cfq_queue *cfqq)
+{
+	cfqq->ref++;
+}
+
 /*
  * task holds one reference to the queue, dropped when task exits. each rq
  * in-flight on this queue also holds a reference, dropped when rq is freed.
@@ -2560,7 +2572,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
  * Each cfq queue took a reference on the parent group. Drop it now.
  * queue lock must be held here.
  */
-static void cfq_put_queue(struct cfq_queue *cfqq)
+static void cfq_put_queue_ref(struct cfq_queue *cfqq)
 {
 	struct cfq_data *cfqd = cfqq->cfqd;
 	struct cfq_group *cfqg;
@@ -2583,7 +2595,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	kmem_cache_free(cfq_pool, cfqq);
-	cfq_put_cfqg(cfqg);
+	cfq_put_group_ref(cfqg);
 }
 
 /*
@@ -2688,7 +2700,7 @@ static void cfq_put_cooperator(struct cfq_queue *cfqq)
 			break;
 		}
 		next = __cfqq->new_cfqq;
-		cfq_put_queue(__cfqq);
+		cfq_put_queue_ref(__cfqq);
 		__cfqq = next;
 	}
 }
@@ -2702,7 +2714,7 @@ static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	cfq_put_cooperator(cfqq);
 
-	cfq_put_queue(cfqq);
+	cfq_put_queue_ref(cfqq);
 }
 
 static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
@@ -2844,7 +2856,7 @@ static void changed_ioprio(struct io_context *ioc, struct cfq_io_context *cic)
 						GFP_ATOMIC);
 		if (new_cfqq) {
 			cic->cfqq[BLK_RW_ASYNC] = new_cfqq;
-			cfq_put_queue(cfqq);
+			cfq_put_queue_ref(cfqq);
 		}
 	}
 
@@ -2903,7 +2915,7 @@ static void changed_cgroup(struct io_context *ioc, struct cfq_io_context *cic)
 		 */
 		cfq_log_cfqq(cfqd, sync_cfqq, "changed cgroup");
 		cic_set_cfqq(cic, NULL, 1);
-		cfq_put_queue(sync_cfqq);
+		cfq_put_queue_ref(sync_cfqq);
 	}
 
 	spin_unlock_irqrestore(q->queue_lock, flags);
@@ -3004,11 +3016,11 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct io_context *ioc,
 	 * pin the queue now that it's allocated, scheduler exit will prune it
 	 */
 	if (!is_sync && !(*async_cfqq)) {
-		cfqq->ref++;
+		cfq_get_queue_ref(cfqq);
 		*async_cfqq = cfqq;
 	}
 
-	cfqq->ref++;
+	cfq_get_queue_ref(cfqq);
 	return cfqq;
 }
 
@@ -3633,10 +3645,10 @@ static void cfq_put_request(struct request *rq)
 		rq->elevator_private[1] = NULL;
 
 		/* Put down rq reference on cfqg */
-		cfq_put_cfqg(RQ_CFQG(rq));
+		cfq_put_group_ref(RQ_CFQG(rq));
 		rq->elevator_private[2] = NULL;
 
-		cfq_put_queue(cfqq);
+		cfq_put_queue_ref(cfqq);
 	}
 }
 
@@ -3647,7 +3659,7 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
 	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
 	cic_set_cfqq(cic, cfqq->new_cfqq, 1);
 	cfq_mark_cfqq_coop(cfqq->new_cfqq);
-	cfq_put_queue(cfqq);
+	cfq_put_queue_ref(cfqq);
 	return cic_to_cfqq(cic, 1);
 }
 
@@ -3669,7 +3681,7 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
 
 	cfq_put_cooperator(cfqq);
 
-	cfq_put_queue(cfqq);
+	cfq_put_queue_ref(cfqq);
 	return NULL;
 }
 /*
@@ -3722,10 +3734,12 @@ new_queue:
 
 	cfqq->allocated[rw]++;
 
-	cfqq->ref++;
+	cfq_get_queue_ref(cfqq);
 	rq->elevator_private[0] = cic;
 	rq->elevator_private[1] = cfqq;
-	rq->elevator_private[2] = cfq_ref_get_cfqg(cfqq->cfqg);
+
+	cfq_get_group_ref(cfqq->cfqg);
+	rq->elevator_private[2] = cfqq->cfqg;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 	return 0;
 
@@ -3818,13 +3832,13 @@ static void cfq_put_async_queues(struct cfq_data *cfqd)
 
 	for (i = 0; i < IOPRIO_BE_NR; i++) {
 		if (cfqd->async_cfqq[0][i])
-			cfq_put_queue(cfqd->async_cfqq[0][i]);
+			cfq_put_queue_ref(cfqd->async_cfqq[0][i]);
 		if (cfqd->async_cfqq[1][i])
-			cfq_put_queue(cfqd->async_cfqq[1][i]);
+			cfq_put_queue_ref(cfqd->async_cfqq[1][i]);
 	}
 
 	if (cfqd->async_idle_cfqq)
-		cfq_put_queue(cfqd->async_idle_cfqq);
+		cfq_put_queue_ref(cfqd->async_idle_cfqq);
 }
 
 static void cfq_cfqd_free(struct rcu_head *head)
@@ -3922,9 +3936,10 @@ static void *cfq_init_queue(struct request_queue *q)
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	/*
 	 * Take a reference to root group which we never drop. This is just
-	 * to make sure that cfq_put_cfqg() does not try to kfree root group
+	 * to make sure that cfq_put_group_ref() does not try to kfree
+	 * root group
 	 */
-	cfqg->ref = 1;
+	cfq_get_group_ref(cfqg);
 	rcu_read_lock();
 	cfq_blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg,
 					(void *)cfqd, 0);
-- 
1.7.3.1

