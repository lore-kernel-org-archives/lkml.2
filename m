Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0GIDVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0GIDVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:21:12 -0400
Message-ID: <4C369512.30407@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:18:42 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 07/11] blkiocg async: Pass bio to elevator_ops functions
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkio controller (blkio cgroup) needs to know the information embedded
in struct page_cgroup to control async (cached) write IOs.  The
information is used to find or allocate proper cfq_queue, which should
be done by elevator_set_req_fn and elevator_may_queue_fn methods of
struct elevator_ops.

This patch adds bio as a parameter of these methods for the
preparation of blkio controller's capability for async write.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 block/blk-core.c         |    9 +++++----
 block/cfq-iosched.c      |    5 +++--
 block/elevator.c         |    9 +++++----
 include/linux/elevator.h |   10 ++++++----
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f0640d7..2637a78 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -649,7 +649,8 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 }
 
 static struct request *
-blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
+blk_alloc_request(struct request_queue *q, struct bio *bio, int flags,
+			int priv, gfp_t gfp_mask)
 {
 	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
 
@@ -661,7 +662,7 @@ blk_alloc_request(struct request_queue *q, int flags, int priv, gfp_t gfp_mask)
 	rq->cmd_flags = flags | REQ_ALLOCED;
 
 	if (priv) {
-		if (unlikely(elv_set_request(q, rq, gfp_mask))) {
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
 			mempool_free(rq, q->rq.rq_pool);
 			return NULL;
 		}
@@ -752,7 +753,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue, priv;
 
-	may_queue = elv_may_queue(q, rw_flags);
+	may_queue = elv_may_queue(q, bio, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
@@ -802,7 +803,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 		rw_flags |= REQ_IO_STAT;
 	spin_unlock_irq(q->queue_lock);
 
-	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
+	rq = blk_alloc_request(q, bio, rw_flags, priv, gfp_mask);
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7982b83..cd4c0bd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3470,7 +3470,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+static int cfq_may_queue(struct request_queue *q, struct bio *bio, int rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
@@ -3560,7 +3560,8 @@ split_cfqq(struct cfq_io_context *cic, struct cfq_queue *cfqq)
  * Allocate cfq data structures associated with this request.
  */
 static int
-cfq_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
+		gfp_t gfp_mask)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_io_context *cic;
diff --git a/block/elevator.c b/block/elevator.c
index 923a913..62daff5 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -787,12 +787,13 @@ struct request *elv_former_request(struct request_queue *q, struct request *rq)
 	return NULL;
 }
 
-int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
+int elv_set_request(struct request_queue *q, struct request *rq,
+			struct bio *bio, gfp_t gfp_mask)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->ops->elevator_set_req_fn)
-		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
+		return e->ops->elevator_set_req_fn(q, rq, bio, gfp_mask);
 
 	rq->elevator_private = NULL;
 	return 0;
@@ -806,12 +807,12 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 		e->ops->elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(struct request_queue *q, int rw)
+int elv_may_queue(struct request_queue *q, struct bio *bio, int rw)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->ops->elevator_may_queue_fn)
-		return e->ops->elevator_may_queue_fn(q, rw);
+		return e->ops->elevator_may_queue_fn(q, bio, rw);
 
 	return ELV_MQUEUE_MAY;
 }
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 2c958f4..0194e0a 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -23,9 +23,10 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef int (elevator_may_queue_fn) (struct request_queue *, struct bio *, int);
 
-typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
+typedef int (elevator_set_req_fn) (struct request_queue *, struct request *,
+					struct bio *, gfp_t);
 typedef void (elevator_put_req_fn) (struct request *);
 typedef void (elevator_activate_req_fn) (struct request_queue *, struct request *);
 typedef void (elevator_deactivate_req_fn) (struct request_queue *, struct request *);
@@ -115,10 +116,11 @@ extern struct request *elv_former_request(struct request_queue *, struct request
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
-extern int elv_may_queue(struct request_queue *, int);
+extern int elv_may_queue(struct request_queue *, struct bio *, int);
 extern void elv_abort_queue(struct request_queue *);
 extern void elv_completed_request(struct request_queue *, struct request *);
-extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
+extern int elv_set_request(struct request_queue *, struct request *,
+				struct bio *, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
 
-- 
1.6.2.5

