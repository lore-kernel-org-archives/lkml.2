Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1HYPZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:25:39 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34368 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1HYPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:34 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 057/118] drbd: Rename struct drbd_epoch_entry to struct drbd_peer_request
Date: Thu, 25 Aug 2011 17:07:53 +0200
Message-Id: <1314284934-17999-58-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |   37 ++++++++++++---------------
 drivers/block/drbd/drbd_main.c     |    8 +++---
 drivers/block/drbd/drbd_nl.c       |    7 ++---
 drivers/block/drbd/drbd_receiver.c |   48 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_worker.c   |   25 +++++++++---------
 5 files changed, 61 insertions(+), 64 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index c730f20..37b3488 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -707,7 +707,7 @@ struct digest_info {
 	void *digest;
 };
 
-struct drbd_epoch_entry {
+struct drbd_peer_request {
 	struct drbd_work w;
 	struct drbd_epoch *epoch; /* for writes */
 	struct drbd_conf *mdev;
@@ -1194,8 +1194,8 @@ extern int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packet cmd,
 extern int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc);
 extern int drbd_send_b_ack(struct drbd_conf *mdev, u32 barrier_nr,
 			u32 set_size);
-extern int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
-			 struct drbd_epoch_entry *e);
+extern int drbd_send_ack(struct drbd_conf *, enum drbd_packet,
+			 struct drbd_peer_request *);
 extern int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    struct p_block_req *rp);
 extern int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -1203,8 +1203,8 @@ extern int drbd_send_ack_dp(struct drbd_conf *mdev, enum drbd_packet cmd,
 extern int drbd_send_ack_ex(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    sector_t sector, int blksize, u64 block_id);
 extern int drbd_send_oos(struct drbd_conf *mdev, struct drbd_request *req);
-extern int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
-			   struct drbd_epoch_entry *e);
+extern int drbd_send_block(struct drbd_conf *, enum drbd_packet,
+			   struct drbd_peer_request *);
 extern int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req);
 extern int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 			      sector_t sector, int size, u64 block_id);
@@ -1500,7 +1500,8 @@ static inline void ov_oos_print(struct drbd_conf *mdev)
 
 
 extern void drbd_csum_bio(struct drbd_conf *, struct crypto_hash *, struct bio *, void *);
-extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *, struct drbd_epoch_entry *, void *);
+extern void drbd_csum_ee(struct drbd_conf *, struct crypto_hash *,
+			 struct drbd_peer_request *, void *);
 /* worker callbacks */
 extern int w_req_cancel_conflict(struct drbd_conf *, struct drbd_work *, int);
 extern int w_read_retry_remote(struct drbd_conf *, struct drbd_work *, int);
@@ -1527,16 +1528,14 @@ extern void start_resync_timer_fn(unsigned long data);
 
 /* drbd_receiver.c */
 extern int drbd_rs_should_slow_down(struct drbd_conf *mdev, sector_t sector);
-extern int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e,
-		const unsigned rw, const int fault_type);
+extern int drbd_submit_ee(struct drbd_conf *, struct drbd_peer_request *,
+			  const unsigned, const int);
 extern int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list);
-extern struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
-					    u64 id,
-					    sector_t sector,
-					    unsigned int data_size,
-					    gfp_t gfp_mask) __must_hold(local);
-extern void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e,
-		int is_net);
+extern struct drbd_peer_request *drbd_alloc_ee(struct drbd_conf *,
+					       u64, sector_t, unsigned int,
+					       gfp_t) __must_hold(local);
+extern void drbd_free_some_ee(struct drbd_conf *, struct drbd_peer_request *,
+			      int);
 #define drbd_free_ee(m,e)	drbd_free_some_ee(m, e, 0)
 #define drbd_free_net_ee(m,e)	drbd_free_some_ee(m, e, 1)
 extern void drbd_wait_ee_list_empty(struct drbd_conf *mdev,
@@ -1627,10 +1626,8 @@ void drbd_nl_cleanup(void);
 int __init drbd_nl_init(void);
 void drbd_bcast_state(struct drbd_conf *mdev, union drbd_state);
 void drbd_bcast_sync_progress(struct drbd_conf *mdev);
-void drbd_bcast_ee(struct drbd_conf *mdev,
-		const char *reason, const int dgs,
-		const char* seen_hash, const char* calc_hash,
-		const struct drbd_epoch_entry* e);
+void drbd_bcast_ee(struct drbd_conf *, const char *, const int, const char *,
+		   const char *, const struct drbd_peer_request *);
 
 
 /**
@@ -1713,7 +1710,7 @@ static inline int drbd_bio_has_active_page(struct bio *bio)
 	return 0;
 }
 
-static inline int drbd_ee_has_active_page(struct drbd_epoch_entry *e)
+static inline int drbd_ee_has_active_page(struct drbd_peer_request *e)
 {
 	struct page *page = e->pages;
 	page_chain_for_each(page) {
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a2417e4..9e8cc1c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2434,7 +2434,7 @@ int drbd_send_ack_rp(struct drbd_conf *mdev, enum drbd_packet cmd,
  * @e:		Epoch entry.
  */
 int drbd_send_ack(struct drbd_conf *mdev, enum drbd_packet cmd,
-		  struct drbd_epoch_entry *e)
+		  struct drbd_peer_request *e)
 {
 	return _drbd_send_ack(mdev, cmd,
 			      cpu_to_be64(e->i.sector),
@@ -2641,7 +2641,7 @@ static int _drbd_send_zc_bio(struct drbd_conf *mdev, struct bio *bio)
 	return 1;
 }
 
-static int _drbd_send_zc_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e)
+static int _drbd_send_zc_ee(struct drbd_conf *mdev, struct drbd_peer_request *e)
 {
 	struct page *page = e->pages;
 	unsigned len = e->i.size;
@@ -2747,7 +2747,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
  *  C_SYNC_SOURCE -> C_SYNC_TARGET         (P_RS_DATA_REPLY)
  */
 int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
-		    struct drbd_epoch_entry *e)
+		    struct drbd_peer_request *e)
 {
 	int ok;
 	struct p_data p;
@@ -3147,7 +3147,7 @@ static int drbd_create_mempools(void)
 		goto Enomem;
 
 	drbd_ee_cache = kmem_cache_create(
-		"drbd_ee", sizeof(struct drbd_epoch_entry), 0, 0, NULL);
+		"drbd_ee", sizeof(struct drbd_peer_request), 0, 0, NULL);
 	if (drbd_ee_cache == NULL)
 		goto Enomem;
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8b8894e..ee00ffa 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2443,10 +2443,9 @@ void drbd_bcast_ev_helper(struct drbd_conf *mdev, char *helper_name)
 	cn_netlink_send(cn_reply, CN_IDX_DRBD, GFP_NOIO);
 }
 
-void drbd_bcast_ee(struct drbd_conf *mdev,
-		const char *reason, const int dgs,
-		const char* seen_hash, const char* calc_hash,
-		const struct drbd_epoch_entry* e)
+void drbd_bcast_ee(struct drbd_conf *mdev, const char *reason, const int dgs,
+		   const char *seen_hash, const char *calc_hash,
+			   const struct drbd_peer_request *e)
 {
 	struct cn_msg *cn_reply;
 	struct drbd_nl_cfg_reply *reply;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 654c1c9..7829656 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -189,7 +189,7 @@ static struct page *drbd_pp_first_pages_or_try_alloc(struct drbd_conf *mdev, int
 
 static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed)
 {
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 	struct list_head *le, *tle;
 
 	/* The EEs are always appended to the end of the list. Since
@@ -198,7 +198,7 @@ static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed
 	   stop to examine the list... */
 
 	list_for_each_safe(le, tle, &mdev->net_ee) {
-		e = list_entry(le, struct drbd_epoch_entry, w.list);
+		e = list_entry(le, struct drbd_peer_request, w.list);
 		if (drbd_ee_has_active_page(e))
 			break;
 		list_move(le, to_be_freed);
@@ -208,7 +208,7 @@ static void reclaim_net_ee(struct drbd_conf *mdev, struct list_head *to_be_freed
 static void drbd_kick_lo_and_reclaim_net(struct drbd_conf *mdev)
 {
 	LIST_HEAD(reclaimed);
-	struct drbd_epoch_entry *e, *t;
+	struct drbd_peer_request *e, *t;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
@@ -309,13 +309,11 @@ You must not have the req_lock:
  drbd_wait_ee_list_empty()
 */
 
-struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
-				     u64 id,
-				     sector_t sector,
-				     unsigned int data_size,
-				     gfp_t gfp_mask) __must_hold(local)
+struct drbd_peer_request *
+drbd_alloc_ee(struct drbd_conf *mdev, u64 id, sector_t sector,
+	      unsigned int data_size, gfp_t gfp_mask) __must_hold(local)
 {
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 	struct page *page;
 	unsigned nr_pages = (data_size + PAGE_SIZE -1) >> PAGE_SHIFT;
 
@@ -357,7 +355,8 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	return NULL;
 }
 
-void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e, int is_net)
+void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_peer_request *e,
+		       int is_net)
 {
 	if (e->flags & EE_HAS_DIGEST)
 		kfree(e->digest);
@@ -370,7 +369,7 @@ void drbd_free_some_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e, int i
 int drbd_release_ee(struct drbd_conf *mdev, struct list_head *list)
 {
 	LIST_HEAD(work_list);
-	struct drbd_epoch_entry *e, *t;
+	struct drbd_peer_request *e, *t;
 	int count = 0;
 	int is_net = list == &mdev->net_ee;
 
@@ -399,7 +398,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 {
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
-	struct drbd_epoch_entry *e, *t;
+	struct drbd_peer_request *e, *t;
 	int ok = (mdev->state.conn >= C_WF_REPORT_PARAMS);
 
 	spin_lock_irq(&mdev->tconn->req_lock);
@@ -1104,8 +1103,8 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo)
  *  on certain Xen deployments.
  */
 /* TODO allocate from our own bio_set. */
-int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_epoch_entry *e,
-		const unsigned rw, const int fault_type)
+int drbd_submit_ee(struct drbd_conf *mdev, struct drbd_peer_request *e,
+		   const unsigned rw, const int fault_type)
 {
 	struct bio *bios = NULL;
 	struct bio *bio;
@@ -1180,7 +1179,7 @@ fail:
 }
 
 static void drbd_remove_epoch_entry_interval(struct drbd_conf *mdev,
-					     struct drbd_epoch_entry *e)
+					     struct drbd_peer_request *e)
 {
 	struct drbd_interval *i = &e->i;
 
@@ -1266,11 +1265,12 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 /* used from receive_RSDataReply (recv_resync_read)
  * and from receive_Data */
-static struct drbd_epoch_entry *
-read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector, int data_size) __must_hold(local)
+static struct drbd_peer_request *
+read_in_block(struct drbd_conf *mdev, u64 id, sector_t sector,
+	      int data_size) __must_hold(local)
 {
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 	struct page *page;
 	int dgs, ds, rr;
 	void *dig_in = mdev->tconn->int_dig_in;
@@ -1449,7 +1449,7 @@ static int recv_dless_read(struct drbd_conf *mdev, struct drbd_request *req,
  * drbd_process_done_ee() by asender only */
 static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 {
-	struct drbd_epoch_entry *e = (struct drbd_epoch_entry *)w;
+	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
 	sector_t sector = e->i.sector;
 	int ok;
 
@@ -1471,7 +1471,7 @@ static int e_end_resync_block(struct drbd_conf *mdev, struct drbd_work *w, int u
 
 static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_size) __releases(local)
 {
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 
 	e = read_in_block(mdev, ID_SYNCER, sector, data_size);
 	if (!e)
@@ -1586,7 +1586,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
  */
 static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = (struct drbd_epoch_entry *)w;
+	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
 	sector_t sector = e->i.sector;
 	int ok = 1, pcmd;
 
@@ -1623,7 +1623,7 @@ static int e_end_block(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 
 static int e_send_discard_ack(struct drbd_conf *mdev, struct drbd_work *w, int unused)
 {
-	struct drbd_epoch_entry *e = (struct drbd_epoch_entry *)w;
+	struct drbd_peer_request *e = (struct drbd_peer_request *)w;
 	int ok = 1;
 
 	D_ASSERT(mdev->tconn->net_conf->wire_protocol == DRBD_PROT_C);
@@ -1735,7 +1735,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			unsigned int data_size)
 {
 	sector_t sector;
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 	struct p_data *p = &mdev->tconn->data.rbuf.data;
 	int rw = WRITE;
 	u32 dp_flags;
@@ -2019,7 +2019,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	sector_t sector;
 	const sector_t capacity = drbd_get_capacity(mdev->this_bdev);
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 0359600..06628d1 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -80,7 +80,7 @@ void drbd_md_io_complete(struct bio *bio, int error)
 /* reads on behalf of the partner,
  * "submitted" by the receiver
  */
-void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
+void drbd_endio_read_sec_final(struct drbd_peer_request *e) __releases(local)
 {
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = e->mdev;
@@ -100,7 +100,7 @@ void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
 
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver, final stage.  */
-static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(local)
+static void drbd_endio_write_sec_final(struct drbd_peer_request *e) __releases(local)
 {
 	unsigned long flags = 0;
 	struct drbd_conf *mdev = e->mdev;
@@ -154,7 +154,7 @@ static void drbd_endio_write_sec_final(struct drbd_epoch_entry *e) __releases(lo
  */
 void drbd_endio_sec(struct bio *bio, int error)
 {
-	struct drbd_epoch_entry *e = bio->bi_private;
+	struct drbd_peer_request *e = bio->bi_private;
 	struct drbd_conf *mdev = e->mdev;
 	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
@@ -247,7 +247,8 @@ int w_read_retry_remote(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	return w_send_read_req(mdev, w, 0);
 }
 
-void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm, struct drbd_epoch_entry *e, void *digest)
+void drbd_csum_ee(struct drbd_conf *mdev, struct crypto_hash *tfm,
+		  struct drbd_peer_request *e, void *digest)
 {
 	struct hash_desc desc;
 	struct scatterlist sg;
@@ -297,7 +298,7 @@ void drbd_csum_bio(struct drbd_conf *mdev, struct crypto_hash *tfm, struct bio *
 /* TODO merge common code with w_e_end_ov_req */
 int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	int digest_size;
 	void *digest;
 	int ok = 1;
@@ -344,7 +345,7 @@ out:
 
 static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 {
-	struct drbd_epoch_entry *e;
+	struct drbd_peer_request *e;
 
 	if (!get_ldev(mdev))
 		return -EIO;
@@ -900,7 +901,7 @@ out:
 }
 
 /* helper */
-static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_epoch_entry *e)
+static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_peer_request *e)
 {
 	if (drbd_ee_has_active_page(e)) {
 		/* This might happen if sendpage() has not finished */
@@ -923,7 +924,7 @@ static void move_to_net_ee_or_free(struct drbd_conf *mdev, struct drbd_epoch_ent
  */
 int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -959,7 +960,7 @@ int w_e_end_data_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
  */
 int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	int ok;
 
 	if (unlikely(cancel)) {
@@ -1007,7 +1008,7 @@ int w_e_end_rsdata_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 
 int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	struct digest_info *di;
 	int digest_size;
 	void *digest = NULL;
@@ -1070,7 +1071,7 @@ int w_e_end_csum_rs_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 /* TODO merge common code with w_e_send_csum */
 int w_e_end_ov_req(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	sector_t sector = e->i.sector;
 	unsigned int size = e->i.size;
 	int digest_size;
@@ -1127,7 +1128,7 @@ void drbd_ov_oos_found(struct drbd_conf *mdev, sector_t sector, int size)
 
 int w_e_end_ov_reply(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
-	struct drbd_epoch_entry *e = container_of(w, struct drbd_epoch_entry, w);
+	struct drbd_peer_request *e = container_of(w, struct drbd_peer_request, w);
 	struct digest_info *di;
 	void *digest;
 	sector_t sector = e->i.sector;
-- 
1.7.4.1

