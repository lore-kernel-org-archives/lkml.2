Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1HYPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33385 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab1HYPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:10 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 031/118] drbd: moved data and meta from mdev to tconn
Date: Thu, 25 Aug 2011 17:07:27 +0200
Message-Id: <1314284934-17999-32-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch mostly:

sed -i -e 's/mdev->data/mdev->tconn->data/g' \
       -e 's/mdev->meta/mdev->tconn->meta/g' \
       *.[ch]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    4 +-
 drivers/block/drbd/drbd_int.h      |   17 +++---
 drivers/block/drbd/drbd_main.c     |  122 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_receiver.c |   82 ++++++++++++------------
 drivers/block/drbd/drbd_req.c      |   12 ++--
 drivers/block/drbd/drbd_worker.c   |   66 ++++++++++----------
 6 files changed, 152 insertions(+), 151 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 9284b10..7943177 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -228,7 +228,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, sector_t sector)
 		al_work.enr = enr;
 		al_work.old_enr = al_ext->lc_number;
 		al_work.w.cb = w_al_write_transaction;
-		drbd_queue_work_front(&mdev->data.work, &al_work.w);
+		drbd_queue_work_front(&mdev->tconn->data.work, &al_work.w);
 		wait_for_completion(&al_work.event);
 
 		mdev->al_writ_cnt++;
@@ -717,7 +717,7 @@ static void drbd_try_clear_on_disk_bm(struct drbd_conf *mdev, sector_t sector,
 			if (udw) {
 				udw->enr = ext->lce.lc_number;
 				udw->w.cb = w_update_odbm;
-				drbd_queue_work_front(&mdev->data.work, &udw->w);
+				drbd_queue_work_front(&mdev->tconn->data.work, &udw->w);
 			} else {
 				dev_warn(DEV, "Could not kmalloc an udw\n");
 			}
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a464642..015ec05 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -969,6 +969,9 @@ struct drbd_tconn {			/* is a resource from the config file */
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
 	atomic_t net_cnt;		/* Users of net_conf */
 	wait_queue_head_t net_cnt_wait;
+
+	struct drbd_socket data;	/* data/barrier/cstate/parameter packets */
+	struct drbd_socket meta;	/* ping/ack (metadata) packets */
 };
 
 struct drbd_conf {
@@ -987,8 +990,6 @@ struct drbd_conf {
 	struct block_device *this_bdev;
 	struct gendisk	    *vdisk;
 
-	struct drbd_socket data; /* data/barrier/cstate/parameter packets */
-	struct drbd_socket meta; /* ping/ack (metadata) packets */
 	int agreed_pro_version;  /* actually used protocol version */
 	unsigned long last_received; /* in jiffies, either socket */
 	unsigned int ko_count;
@@ -1167,11 +1168,11 @@ static inline unsigned int mdev_to_minor(struct drbd_conf *mdev)
  */
 static inline int drbd_get_data_sock(struct drbd_conf *mdev)
 {
-	mutex_lock(&mdev->data.mutex);
+	mutex_lock(&mdev->tconn->data.mutex);
 	/* drbd_disconnect() could have called drbd_free_sock()
 	 * while we were waiting in down()... */
-	if (unlikely(mdev->data.socket == NULL)) {
-		mutex_unlock(&mdev->data.mutex);
+	if (unlikely(mdev->tconn->data.socket == NULL)) {
+		mutex_unlock(&mdev->tconn->data.mutex);
 		return 0;
 	}
 	return 1;
@@ -1179,7 +1180,7 @@ static inline int drbd_get_data_sock(struct drbd_conf *mdev)
 
 static inline void drbd_put_data_sock(struct drbd_conf *mdev)
 {
-	mutex_unlock(&mdev->data.mutex);
+	mutex_unlock(&mdev->tconn->data.mutex);
 }
 
 /*
@@ -2399,7 +2400,7 @@ static inline void dec_ap_bio(struct drbd_conf *mdev)
 		wake_up(&mdev->misc_wait);
 	if (ap_bio == 0 && test_bit(BITMAP_IO, &mdev->flags)) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &mdev->flags))
-			drbd_queue_work(&mdev->data.work, &mdev->bm_io_work.w);
+			drbd_queue_work(&mdev->tconn->data.work, &mdev->bm_io_work.w);
 	}
 }
 
@@ -2439,7 +2440,7 @@ static inline void update_peer_seq(struct drbd_conf *mdev, unsigned int new_seq)
 
 static inline void drbd_update_congested(struct drbd_conf *mdev)
 {
-	struct sock *sk = mdev->data.socket->sk;
+	struct sock *sk = mdev->tconn->data.socket->sk;
 	if (sk->sk_wmem_queued > sk->sk_sndbuf * 4 / 5)
 		set_bit(NET_CONGESTED, &mdev->flags);
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9a77a9b..84e40fb 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -371,7 +371,7 @@ static void _tl_restart(struct drbd_conf *mdev, enum drbd_req_event what)
 					set_bit(CREATE_BARRIER, &mdev->flags);
 				}
 
-				drbd_queue_work(&mdev->data.work, &b->w);
+				drbd_queue_work(&mdev->tconn->data.work, &b->w);
 			}
 			pn = &b->next;
 		} else {
@@ -1251,7 +1251,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 		ascw->flags = flags;
 		ascw->w.cb = w_after_state_ch;
 		ascw->done = done;
-		drbd_queue_work(&mdev->data.work, &ascw->w);
+		drbd_queue_work(&mdev->tconn->data.work, &ascw->w);
 	} else {
 		dev_warn(DEV, "Could not kmalloc an ascw\n");
 	}
@@ -1855,11 +1855,11 @@ int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 	struct socket *sock;
 
 	if (use_data_socket) {
-		mutex_lock(&mdev->data.mutex);
-		sock = mdev->data.socket;
+		mutex_lock(&mdev->tconn->data.mutex);
+		sock = mdev->tconn->data.socket;
 	} else {
-		mutex_lock(&mdev->meta.mutex);
-		sock = mdev->meta.socket;
+		mutex_lock(&mdev->tconn->meta.mutex);
+		sock = mdev->tconn->meta.socket;
 	}
 
 	/* drbd_disconnect() could have called drbd_free_sock()
@@ -1868,9 +1868,9 @@ int drbd_send_cmd(struct drbd_conf *mdev, int use_data_socket,
 		ok = _drbd_send_cmd(mdev, sock, cmd, h, size, 0);
 
 	if (use_data_socket)
-		mutex_unlock(&mdev->data.mutex);
+		mutex_unlock(&mdev->tconn->data.mutex);
 	else
-		mutex_unlock(&mdev->meta.mutex);
+		mutex_unlock(&mdev->tconn->meta.mutex);
 	return ok;
 }
 
@@ -1888,9 +1888,9 @@ int drbd_send_cmd2(struct drbd_conf *mdev, enum drbd_packets cmd, char *data,
 		return 0;
 
 	ok = (sizeof(h) ==
-		drbd_send(mdev, mdev->data.socket, &h, sizeof(h), 0));
+		drbd_send(mdev, mdev->tconn->data.socket, &h, sizeof(h), 0));
 	ok = ok && (size ==
-		drbd_send(mdev, mdev->data.socket, data, size, 0));
+		drbd_send(mdev, mdev->tconn->data.socket, data, size, 0));
 
 	drbd_put_data_sock(mdev);
 
@@ -1913,13 +1913,13 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 	/* used from admin command context and receiver/worker context.
 	 * to avoid kmalloc, grab the socket right here,
 	 * then use the pre-allocated sbuf there */
-	mutex_lock(&mdev->data.mutex);
-	sock = mdev->data.socket;
+	mutex_lock(&mdev->tconn->data.mutex);
+	sock = mdev->tconn->data.socket;
 
 	if (likely(sock != NULL)) {
 		enum drbd_packets cmd = apv >= 89 ? P_SYNC_PARAM89 : P_SYNC_PARAM;
 
-		p = &mdev->data.sbuf.rs_param_95;
+		p = &mdev->tconn->data.sbuf.rs_param_95;
 
 		/* initialize verify_alg and csums_alg */
 		memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
@@ -1939,7 +1939,7 @@ int drbd_send_sync_param(struct drbd_conf *mdev, struct syncer_conf *sc)
 	} else
 		rv = 0; /* not ok */
 
-	mutex_unlock(&mdev->data.mutex);
+	mutex_unlock(&mdev->tconn->data.mutex);
 
 	return rv;
 }
@@ -2106,17 +2106,17 @@ int drbd_send_state(struct drbd_conf *mdev)
 	 * of a cluster wide state change on another thread */
 	drbd_state_lock(mdev);
 
-	mutex_lock(&mdev->data.mutex);
+	mutex_lock(&mdev->tconn->data.mutex);
 
 	p.state = cpu_to_be32(mdev->state.i); /* Within the send mutex */
-	sock = mdev->data.socket;
+	sock = mdev->tconn->data.socket;
 
 	if (likely(sock != NULL)) {
 		ok = _drbd_send_cmd(mdev, sock, P_STATE,
 				    (struct p_header80 *)&p, sizeof(p), 0);
 	}
 
-	mutex_unlock(&mdev->data.mutex);
+	mutex_unlock(&mdev->tconn->data.mutex);
 
 	drbd_state_unlock(mdev);
 	return ok;
@@ -2260,7 +2260,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 
 	if (len) {
 		DCBP_set_code(p, RLE_VLI_Bits);
-		ok = _drbd_send_cmd(mdev, mdev->data.socket, P_COMPRESSED_BITMAP, h,
+		ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_COMPRESSED_BITMAP, h,
 			sizeof(*p) + len, 0);
 
 		c->packets[0]++;
@@ -2275,7 +2275,7 @@ send_bitmap_rle_or_plain(struct drbd_conf *mdev,
 		len = num_words * sizeof(long);
 		if (len)
 			drbd_bm_get_lel(mdev, c->word_offset, num_words, (unsigned long*)h->payload);
-		ok = _drbd_send_cmd(mdev, mdev->data.socket, P_BITMAP,
+		ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BITMAP,
 				   h, sizeof(struct p_header80) + len, 0);
 		c->word_offset += num_words;
 		c->bit_offset = c->word_offset * BITS_PER_LONG;
@@ -2391,7 +2391,7 @@ static int _drbd_send_ack(struct drbd_conf *mdev, enum drbd_packets cmd,
 	p.blksize  = blksize;
 	p.seq_num  = cpu_to_be32(atomic_add_return(1, &mdev->packet_seq));
 
-	if (!mdev->meta.socket || mdev->state.conn < C_CONNECTED)
+	if (!mdev->tconn->meta.socket || mdev->state.conn < C_CONNECTED)
 		return false;
 	ok = drbd_send_cmd(mdev, USE_META_SOCKET, cmd,
 				(struct p_header80 *)&p, sizeof(p));
@@ -2473,12 +2473,12 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev,
 	p.head.command = cpu_to_be16(cmd);
 	p.head.length  = cpu_to_be16(sizeof(p) - sizeof(struct p_header80) + digest_size);
 
-	mutex_lock(&mdev->data.mutex);
+	mutex_lock(&mdev->tconn->data.mutex);
 
-	ok = (sizeof(p) == drbd_send(mdev, mdev->data.socket, &p, sizeof(p), 0));
-	ok = ok && (digest_size == drbd_send(mdev, mdev->data.socket, digest, digest_size, 0));
+	ok = (sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), 0));
+	ok = ok && (digest_size == drbd_send(mdev, mdev->tconn->data.socket, digest, digest_size, 0));
 
-	mutex_unlock(&mdev->data.mutex);
+	mutex_unlock(&mdev->tconn->data.mutex);
 
 	return ok;
 }
@@ -2506,7 +2506,7 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 	int drop_it;
 	/* long elapsed = (long)(jiffies - mdev->last_received); */
 
-	drop_it =   mdev->meta.socket == sock
+	drop_it =   mdev->tconn->meta.socket == sock
 		|| !mdev->asender.task
 		|| get_t_state(&mdev->asender) != RUNNING
 		|| mdev->state.conn < C_CONNECTED;
@@ -2548,7 +2548,7 @@ static int we_should_drop_the_connection(struct drbd_conf *mdev, struct socket *
 static int _drbd_no_send_page(struct drbd_conf *mdev, struct page *page,
 		   int offset, size_t size, unsigned msg_flags)
 {
-	int sent = drbd_send(mdev, mdev->data.socket, kmap(page) + offset, size, msg_flags);
+	int sent = drbd_send(mdev, mdev->tconn->data.socket, kmap(page) + offset, size, msg_flags);
 	kunmap(page);
 	if (sent == size)
 		mdev->send_cnt += size>>9;
@@ -2575,12 +2575,12 @@ static int _drbd_send_page(struct drbd_conf *mdev, struct page *page,
 	drbd_update_congested(mdev);
 	set_fs(KERNEL_DS);
 	do {
-		sent = mdev->data.socket->ops->sendpage(mdev->data.socket, page,
+		sent = mdev->tconn->data.socket->ops->sendpage(mdev->tconn->data.socket, page,
 							offset, len,
 							msg_flags);
 		if (sent == -EAGAIN) {
 			if (we_should_drop_the_connection(mdev,
-							  mdev->data.socket))
+							  mdev->tconn->data.socket))
 				break;
 			else
 				continue;
@@ -2699,11 +2699,11 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	p.dp_flags = cpu_to_be32(dp_flags);
 	set_bit(UNPLUG_REMOTE, &mdev->flags);
 	ok = (sizeof(p) ==
-		drbd_send(mdev, mdev->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
+		drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
 	if (ok && dgs) {
 		dgb = mdev->int_dig_out;
 		drbd_csum_bio(mdev, mdev->integrity_w_tfm, req->master_bio, dgb);
-		ok = dgs == drbd_send(mdev, mdev->data.socket, dgb, dgs, 0);
+		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok) {
 		/* For protocol A, we have to memcpy the payload into
@@ -2781,11 +2781,11 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packets cmd,
 	if (!drbd_get_data_sock(mdev))
 		return 0;
 
-	ok = sizeof(p) == drbd_send(mdev, mdev->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
+	ok = sizeof(p) == drbd_send(mdev, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
 	if (ok && dgs) {
 		dgb = mdev->int_dig_out;
 		drbd_csum_ee(mdev, mdev->integrity_w_tfm, e, dgb);
-		ok = dgs == drbd_send(mdev, mdev->data.socket, dgb, dgs, 0);
+		ok = dgs == drbd_send(mdev, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
 	if (ok)
 		ok = _drbd_send_zc_ee(mdev, e);
@@ -2842,7 +2842,7 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 	msg.msg_controllen = 0;
 	msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
 
-	if (sock == mdev->data.socket) {
+	if (sock == mdev->tconn->data.socket) {
 		mdev->ko_count = mdev->tconn->net_conf->ko_count;
 		drbd_update_congested(mdev);
 	}
@@ -2875,13 +2875,13 @@ int drbd_send(struct drbd_conf *mdev, struct socket *sock,
 		iov.iov_len  -= rv;
 	} while (sent < size);
 
-	if (sock == mdev->data.socket)
+	if (sock == mdev->tconn->data.socket)
 		clear_bit(NET_CONGESTED, &mdev->flags);
 
 	if (rv <= 0) {
 		if (rv != -EAGAIN) {
 			dev_err(DEV, "%s_sendmsg returned %d\n",
-			    sock == mdev->meta.socket ? "msock" : "sock",
+			    sock == mdev->tconn->meta.socket ? "msock" : "sock",
 			    rv);
 			drbd_force_state(mdev, NS(conn, C_BROKEN_PIPE));
 		} else
@@ -2980,14 +2980,14 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	atomic_set(&mdev->ap_in_flight, 0);
 
 	mutex_init(&mdev->md_io_mutex);
-	mutex_init(&mdev->data.mutex);
-	mutex_init(&mdev->meta.mutex);
-	sema_init(&mdev->data.work.s, 0);
-	sema_init(&mdev->meta.work.s, 0);
+	mutex_init(&mdev->tconn->data.mutex);
+	mutex_init(&mdev->tconn->meta.mutex);
+	sema_init(&mdev->tconn->data.work.s, 0);
+	sema_init(&mdev->tconn->meta.work.s, 0);
 	mutex_init(&mdev->state_mutex);
 
-	spin_lock_init(&mdev->data.work.q_lock);
-	spin_lock_init(&mdev->meta.work.q_lock);
+	spin_lock_init(&mdev->tconn->data.work.q_lock);
+	spin_lock_init(&mdev->tconn->meta.work.q_lock);
 
 	spin_lock_init(&mdev->al_lock);
 	spin_lock_init(&mdev->req_lock);
@@ -3000,8 +3000,8 @@ void drbd_init_set_defaults(struct drbd_conf *mdev)
 	INIT_LIST_HEAD(&mdev->read_ee);
 	INIT_LIST_HEAD(&mdev->net_ee);
 	INIT_LIST_HEAD(&mdev->resync_reads);
-	INIT_LIST_HEAD(&mdev->data.work.q);
-	INIT_LIST_HEAD(&mdev->meta.work.q);
+	INIT_LIST_HEAD(&mdev->tconn->data.work.q);
+	INIT_LIST_HEAD(&mdev->tconn->meta.work.q);
 	INIT_LIST_HEAD(&mdev->resync_work.list);
 	INIT_LIST_HEAD(&mdev->unplug_work.list);
 	INIT_LIST_HEAD(&mdev->go_diskless.list);
@@ -3093,8 +3093,8 @@ void drbd_mdev_cleanup(struct drbd_conf *mdev)
 	D_ASSERT(list_empty(&mdev->read_ee));
 	D_ASSERT(list_empty(&mdev->net_ee));
 	D_ASSERT(list_empty(&mdev->resync_reads));
-	D_ASSERT(list_empty(&mdev->data.work.q));
-	D_ASSERT(list_empty(&mdev->meta.work.q));
+	D_ASSERT(list_empty(&mdev->tconn->data.work.q));
+	D_ASSERT(list_empty(&mdev->tconn->meta.work.q));
 	D_ASSERT(list_empty(&mdev->resync_work.list));
 	D_ASSERT(list_empty(&mdev->unplug_work.list));
 	D_ASSERT(list_empty(&mdev->go_diskless.list));
@@ -3254,7 +3254,7 @@ static void drbd_delete_device(unsigned int minor)
 
 	/* paranoia asserts */
 	D_ASSERT(mdev->open_cnt == 0);
-	D_ASSERT(list_empty(&mdev->data.work.q));
+	D_ASSERT(list_empty(&mdev->tconn->data.work.q));
 	/* end paranoia asserts */
 
 	del_gendisk(mdev->vdisk);
@@ -3606,19 +3606,19 @@ void drbd_free_bc(struct drbd_backing_dev *ldev)
 
 void drbd_free_sock(struct drbd_conf *mdev)
 {
-	if (mdev->data.socket) {
-		mutex_lock(&mdev->data.mutex);
-		kernel_sock_shutdown(mdev->data.socket, SHUT_RDWR);
-		sock_release(mdev->data.socket);
-		mdev->data.socket = NULL;
-		mutex_unlock(&mdev->data.mutex);
+	if (mdev->tconn->data.socket) {
+		mutex_lock(&mdev->tconn->data.mutex);
+		kernel_sock_shutdown(mdev->tconn->data.socket, SHUT_RDWR);
+		sock_release(mdev->tconn->data.socket);
+		mdev->tconn->data.socket = NULL;
+		mutex_unlock(&mdev->tconn->data.mutex);
 	}
-	if (mdev->meta.socket) {
-		mutex_lock(&mdev->meta.mutex);
-		kernel_sock_shutdown(mdev->meta.socket, SHUT_RDWR);
-		sock_release(mdev->meta.socket);
-		mdev->meta.socket = NULL;
-		mutex_unlock(&mdev->meta.mutex);
+	if (mdev->tconn->meta.socket) {
+		mutex_lock(&mdev->tconn->meta.mutex);
+		kernel_sock_shutdown(mdev->tconn->meta.socket, SHUT_RDWR);
+		sock_release(mdev->tconn->meta.socket);
+		mdev->tconn->meta.socket = NULL;
+		mutex_unlock(&mdev->tconn->meta.mutex);
 	}
 }
 
@@ -4012,7 +4012,7 @@ void drbd_go_diskless(struct drbd_conf *mdev)
 {
 	D_ASSERT(mdev->state.disk == D_FAILED);
 	if (!test_and_set_bit(GO_DISKLESS, &mdev->flags))
-		drbd_queue_work(&mdev->data.work, &mdev->go_diskless);
+		drbd_queue_work(&mdev->tconn->data.work, &mdev->go_diskless);
 }
 
 /**
@@ -4050,7 +4050,7 @@ void drbd_queue_bitmap_io(struct drbd_conf *mdev,
 	set_bit(BITMAP_IO, &mdev->flags);
 	if (atomic_read(&mdev->ap_bio_cnt) == 0) {
 		if (!test_and_set_bit(BITMAP_IO_QUEUED, &mdev->flags))
-			drbd_queue_work(&mdev->data.work, &mdev->bm_io_work.w);
+			drbd_queue_work(&mdev->tconn->data.work, &mdev->bm_io_work.w);
 	}
 	spin_unlock_irq(&mdev->req_lock);
 }
@@ -4108,7 +4108,7 @@ static void md_sync_timer_fn(unsigned long data)
 {
 	struct drbd_conf *mdev = (struct drbd_conf *) data;
 
-	drbd_queue_work_front(&mdev->data.work, &mdev->md_sync_work);
+	drbd_queue_work_front(&mdev->tconn->data.work, &mdev->md_sync_work);
 }
 
 static int w_md_sync(struct drbd_conf *mdev, struct drbd_work *w, int unused)
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 8a01f27..2636bcc 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -516,7 +516,7 @@ static int drbd_recv(struct drbd_conf *mdev, void *buf, size_t size)
 	set_fs(KERNEL_DS);
 
 	for (;;) {
-		rv = sock_recvmsg(mdev->data.socket, &msg, size, msg.msg_flags);
+		rv = sock_recvmsg(mdev->tconn->data.socket, &msg, size, msg.msg_flags);
 		if (rv == size)
 			break;
 
@@ -700,14 +700,14 @@ out:
 static int drbd_send_fp(struct drbd_conf *mdev,
 	struct socket *sock, enum drbd_packets cmd)
 {
-	struct p_header80 *h = &mdev->data.sbuf.header.h80;
+	struct p_header80 *h = &mdev->tconn->data.sbuf.header.h80;
 
 	return _drbd_send_cmd(mdev, sock, cmd, h, sizeof(*h), 0);
 }
 
 static enum drbd_packets drbd_recv_fp(struct drbd_conf *mdev, struct socket *sock)
 {
-	struct p_header80 *h = &mdev->data.rbuf.header.h80;
+	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
 	int rr;
 
 	rr = drbd_recv_short(mdev, sock, h, sizeof(*h), 0);
@@ -755,7 +755,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 	struct socket *s, *sock, *msock;
 	int try, h, ok;
 
-	D_ASSERT(!mdev->data.socket);
+	D_ASSERT(!mdev->tconn->data.socket);
 
 	if (drbd_request_state(mdev, NS(conn, C_WF_CONNECTION)) < SS_SUCCESS)
 		return -2;
@@ -870,8 +870,8 @@ retry:
 	drbd_tcp_nodelay(sock);
 	drbd_tcp_nodelay(msock);
 
-	mdev->data.socket = sock;
-	mdev->meta.socket = msock;
+	mdev->tconn->data.socket = sock;
+	mdev->tconn->meta.socket = msock;
 	mdev->last_received = jiffies;
 
 	D_ASSERT(mdev->asender.task == NULL);
@@ -925,7 +925,7 @@ out_release_sockets:
 
 static int drbd_recv_header(struct drbd_conf *mdev, enum drbd_packets *cmd, unsigned int *packet_size)
 {
-	union p_header *h = &mdev->data.rbuf.header;
+	union p_header *h = &mdev->tconn->data.rbuf.header;
 	int r;
 
 	r = drbd_recv(mdev, h, sizeof(*h));
@@ -1163,7 +1163,7 @@ fail:
 static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
 	int rv;
-	struct p_barrier *p = &mdev->data.rbuf.barrier;
+	struct p_barrier *p = &mdev->tconn->data.rbuf.barrier;
 	struct drbd_epoch *epoch;
 
 	inc_unacked(mdev);
@@ -1494,7 +1494,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 	struct drbd_request *req;
 	sector_t sector;
 	int ok;
-	struct p_data *p = &mdev->data.rbuf.data;
+	struct p_data *p = &mdev->tconn->data.rbuf.data;
 
 	sector = be64_to_cpu(p->sector);
 
@@ -1522,7 +1522,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packets cmd, un
 {
 	sector_t sector;
 	int ok;
-	struct p_data *p = &mdev->data.rbuf.data;
+	struct p_data *p = &mdev->tconn->data.rbuf.data;
 
 	sector = be64_to_cpu(p->sector);
 	D_ASSERT(p->block_id == ID_SYNCER);
@@ -1675,7 +1675,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 {
 	sector_t sector;
 	struct drbd_epoch_entry *e;
-	struct p_data *p = &mdev->data.rbuf.data;
+	struct p_data *p = &mdev->tconn->data.rbuf.data;
 	int rw = WRITE;
 	u32 dp_flags;
 
@@ -1964,7 +1964,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packets cmd, un
 	struct digest_info *di = NULL;
 	int size, verb;
 	unsigned int fault_type;
-	struct p_block_req *p =	&mdev->data.rbuf.block_req;
+	struct p_block_req *p =	&mdev->tconn->data.rbuf.block_req;
 
 	sector = be64_to_cpu(p->sector);
 	size   = be32_to_cpu(p->blksize);
@@ -2683,7 +2683,7 @@ static int cmp_after_sb(enum drbd_after_sb_p peer, enum drbd_after_sb_p self)
 
 static int receive_protocol(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_protocol *p = &mdev->data.rbuf.protocol;
+	struct p_protocol *p = &mdev->tconn->data.rbuf.protocol;
 	int p_proto, p_after_sb_0p, p_after_sb_1p, p_after_sb_2p;
 	int p_want_lose, p_two_primaries, cf;
 	char p_integrity_alg[SHARED_SECRET_MAX] = "";
@@ -2783,7 +2783,7 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int packet_size)
 {
 	int ok = true;
-	struct p_rs_param_95 *p = &mdev->data.rbuf.rs_param_95;
+	struct p_rs_param_95 *p = &mdev->tconn->data.rbuf.rs_param_95;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
 	struct crypto_hash *csums_tfm = NULL;
@@ -2946,7 +2946,7 @@ static void warn_if_differ_considerably(struct drbd_conf *mdev,
 
 static int receive_sizes(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_sizes *p = &mdev->data.rbuf.sizes;
+	struct p_sizes *p = &mdev->tconn->data.rbuf.sizes;
 	enum determine_dev_size dd = unchanged;
 	sector_t p_size, p_usize, my_usize;
 	int ldsc = 0; /* local disk size changed */
@@ -3049,7 +3049,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 static int receive_uuids(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_uuids *p = &mdev->data.rbuf.uuids;
+	struct p_uuids *p = &mdev->tconn->data.rbuf.uuids;
 	u64 *p_uuid;
 	int i, updated_uuids = 0;
 
@@ -3143,7 +3143,7 @@ static union drbd_state convert_state(union drbd_state ps)
 
 static int receive_req_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_req_state *p = &mdev->data.rbuf.req_state;
+	struct p_req_state *p = &mdev->tconn->data.rbuf.req_state;
 	union drbd_state mask, val;
 	enum drbd_state_rv rv;
 
@@ -3169,7 +3169,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsi
 
 static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_state *p = &mdev->data.rbuf.state;
+	struct p_state *p = &mdev->tconn->data.rbuf.state;
 	union drbd_state os, ns, peer_state;
 	enum drbd_disk_state real_peer_disk;
 	enum chg_state_flags cs_flags;
@@ -3321,7 +3321,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned
 
 static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_rs_uuid *p = &mdev->data.rbuf.rs_uuid;
+	struct p_rs_uuid *p = &mdev->tconn->data.rbuf.rs_uuid;
 
 	wait_event(mdev->misc_wait,
 		   mdev->state.conn == C_WF_SYNC_UUID ||
@@ -3520,7 +3520,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packets cmd, unsigne
 	void *buffer;
 	int err;
 	int ok = false;
-	struct p_header80 *h = &mdev->data.rbuf.header.h80;
+	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
 
 	drbd_bm_lock(mdev, "receive bitmap", BM_LOCKED_SET_ALLOWED);
 	/* you are supposed to send additional out-of-sync information
@@ -3629,14 +3629,14 @@ static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packets cmd, u
 {
 	/* Make sure we've acked all the TCP data associated
 	 * with the data requests being unplugged */
-	drbd_tcp_quickack(mdev->data.socket);
+	drbd_tcp_quickack(mdev->tconn->data.socket);
 
 	return true;
 }
 
 static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packets cmd, unsigned int data_size)
 {
-	struct p_block_desc *p = &mdev->data.rbuf.block_desc;
+	struct p_block_desc *p = &mdev->tconn->data.rbuf.block_desc;
 
 	switch (mdev->state.conn) {
 	case C_WF_SYNC_UUID:
@@ -3690,15 +3690,15 @@ static struct data_cmd drbd_cmd_handler[] = {
 };
 
 /* All handler functions that expect a sub-header get that sub-heder in
-   mdev->data.rbuf.header.head.payload.
+   mdev->tconn->data.rbuf.header.head.payload.
 
-   Usually in mdev->data.rbuf.header.head the callback can find the usual
+   Usually in mdev->tconn->data.rbuf.header.head the callback can find the usual
    p_header, but they may not rely on that. Since there is also p_header95 !
  */
 
 static void drbdd(struct drbd_conf *mdev)
 {
-	union p_header *header = &mdev->data.rbuf.header;
+	union p_header *header = &mdev->tconn->data.rbuf.header;
 	unsigned int packet_size;
 	enum drbd_packets cmd;
 	size_t shs; /* sub header size */
@@ -3753,7 +3753,7 @@ void drbd_flush_workqueue(struct drbd_conf *mdev)
 
 	barr.w.cb = w_prev_work_done;
 	init_completion(&barr.done);
-	drbd_queue_work(&mdev->data.work, &barr.w);
+	drbd_queue_work(&mdev->tconn->data.work, &barr.w);
 	wait_for_completion(&barr.done);
 }
 
@@ -3892,25 +3892,25 @@ static void drbd_disconnect(struct drbd_conf *mdev)
 static int drbd_send_handshake(struct drbd_conf *mdev)
 {
 	/* ASSERT current == mdev->receiver ... */
-	struct p_handshake *p = &mdev->data.sbuf.handshake;
+	struct p_handshake *p = &mdev->tconn->data.sbuf.handshake;
 	int ok;
 
-	if (mutex_lock_interruptible(&mdev->data.mutex)) {
+	if (mutex_lock_interruptible(&mdev->tconn->data.mutex)) {
 		dev_err(DEV, "interrupted during initial handshake\n");
 		return 0; /* interrupted. not ok. */
 	}
 
-	if (mdev->data.socket == NULL) {
-		mutex_unlock(&mdev->data.mutex);
+	if (mdev->tconn->data.socket == NULL) {
+		mutex_unlock(&mdev->tconn->data.mutex);
 		return 0;
 	}
 
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	ok = _drbd_send_cmd( mdev, mdev->data.socket, P_HAND_SHAKE,
+	ok = _drbd_send_cmd( mdev, mdev->tconn->data.socket, P_HAND_SHAKE,
 			     (struct p_header80 *)p, sizeof(*p), 0 );
-	mutex_unlock(&mdev->data.mutex);
+	mutex_unlock(&mdev->tconn->data.mutex);
 	return ok;
 }
 
@@ -3924,7 +3924,7 @@ static int drbd_send_handshake(struct drbd_conf *mdev)
 static int drbd_do_handshake(struct drbd_conf *mdev)
 {
 	/* ASSERT current == mdev->receiver ... */
-	struct p_handshake *p = &mdev->data.rbuf.handshake;
+	struct p_handshake *p = &mdev->tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	unsigned int length;
 	enum drbd_packets cmd;
@@ -4207,7 +4207,7 @@ static int got_Ping(struct drbd_conf *mdev, struct p_header80 *h)
 static int got_PingAck(struct drbd_conf *mdev, struct p_header80 *h)
 {
 	/* restore idle timeout */
-	mdev->meta.socket->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
+	mdev->tconn->meta.socket->sk->sk_rcvtimeo = mdev->tconn->net_conf->ping_int*HZ;
 	if (!test_and_set_bit(GOT_PING_ACK, &mdev->flags))
 		wake_up(&mdev->misc_wait);
 
@@ -4427,7 +4427,7 @@ static int got_OVResult(struct drbd_conf *mdev, struct p_header80 *h)
 		w = kmalloc(sizeof(*w), GFP_NOIO);
 		if (w) {
 			w->cb = w_ov_finished;
-			drbd_queue_work_front(&mdev->data.work, w);
+			drbd_queue_work_front(&mdev->tconn->data.work, w);
 		} else {
 			dev_err(DEV, "kmalloc(w) failed.");
 			ov_oos_print(mdev);
@@ -4479,7 +4479,7 @@ static struct asender_cmd *get_asender_cmd(int cmd)
 int drbd_asender(struct drbd_thread *thi)
 {
 	struct drbd_conf *mdev = thi->mdev;
-	struct p_header80 *h = &mdev->meta.rbuf.header.h80;
+	struct p_header80 *h = &mdev->tconn->meta.rbuf.header.h80;
 	struct asender_cmd *cmd = NULL;
 
 	int rv, len;
@@ -4501,7 +4501,7 @@ int drbd_asender(struct drbd_thread *thi)
 				dev_err(DEV, "drbd_send_ping has failed\n");
 				goto reconnect;
 			}
-			mdev->meta.socket->sk->sk_rcvtimeo =
+			mdev->tconn->meta.socket->sk->sk_rcvtimeo =
 				mdev->tconn->net_conf->ping_timeo*HZ/10;
 			ping_timeout_active = 1;
 		}
@@ -4510,7 +4510,7 @@ int drbd_asender(struct drbd_thread *thi)
 		 * it may hurt latency if we cork without much to send */
 		if (!mdev->tconn->net_conf->no_cork &&
 			3 < atomic_read(&mdev->unacked_cnt))
-			drbd_tcp_cork(mdev->meta.socket);
+			drbd_tcp_cork(mdev->tconn->meta.socket);
 		while (1) {
 			clear_bit(SIGNAL_ASENDER, &mdev->flags);
 			flush_signals(current);
@@ -4529,13 +4529,13 @@ int drbd_asender(struct drbd_thread *thi)
 		}
 		/* but unconditionally uncork unless disabled */
 		if (!mdev->tconn->net_conf->no_cork)
-			drbd_tcp_uncork(mdev->meta.socket);
+			drbd_tcp_uncork(mdev->tconn->meta.socket);
 
 		/* short circuit, recv_msg would return EINTR anyways. */
 		if (signal_pending(current))
 			continue;
 
-		rv = drbd_recv_short(mdev, mdev->meta.socket,
+		rv = drbd_recv_short(mdev, mdev->tconn->meta.socket,
 				     buf, expect-received, 0);
 		clear_bit(SIGNAL_ASENDER, &mdev->flags);
 
@@ -4561,7 +4561,7 @@ int drbd_asender(struct drbd_thread *thi)
 			/* If the data socket received something meanwhile,
 			 * that is good enough: peer is still alive. */
 			if (time_after(mdev->last_received,
-				jiffies - mdev->meta.socket->sk->sk_rcvtimeo))
+				jiffies - mdev->tconn->meta.socket->sk->sk_rcvtimeo))
 				continue;
 			if (ping_timeout_active) {
 				dev_err(DEV, "PingAck did not arrive in time.\n");
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 8f1e7db..ac43e44 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -127,7 +127,7 @@ static void queue_barrier(struct drbd_conf *mdev)
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in tl_clear.  */
 	inc_ap_pending(mdev);
-	drbd_queue_work(&mdev->data.work, &b->w);
+	drbd_queue_work(&mdev->tconn->data.work, &b->w);
 	set_bit(CREATE_BARRIER, &mdev->flags);
 }
 
@@ -483,7 +483,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		req->w.cb = (req->rq_state & RQ_LOCAL_MASK)
 			? w_read_retry_remote
 			: w_send_read_req;
-		drbd_queue_work(&mdev->data.work, &req->w);
+		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 		break;
 
 	case QUEUE_FOR_NET_WRITE:
@@ -525,7 +525,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		req->rq_state |= RQ_NET_QUEUED;
 		req->w.cb =  w_send_dblock;
-		drbd_queue_work(&mdev->data.work, &req->w);
+		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 
 		/* close the epoch, in case it outgrew the limit */
 		if (mdev->newest_tle->n_writes >= mdev->tconn->net_conf->max_epoch_size)
@@ -536,7 +536,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 	case QUEUE_FOR_SEND_OOS:
 		req->rq_state |= RQ_NET_QUEUED;
 		req->w.cb =  w_send_oos;
-		drbd_queue_work(&mdev->data.work, &req->w);
+		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 		break;
 
 	case OOS_HANDED_TO_NETWORK:
@@ -667,7 +667,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 
 		get_ldev(mdev);
 		req->w.cb = w_restart_disk_io;
-		drbd_queue_work(&mdev->data.work, &req->w);
+		drbd_queue_work(&mdev->tconn->data.work, &req->w);
 		break;
 
 	case RESEND:
@@ -677,7 +677,7 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		   We ensure that the peer was not rebooted */
 		if (!(req->rq_state & RQ_NET_OK)) {
 			if (req->w.cb) {
-				drbd_queue_work(&mdev->data.work, &req->w);
+				drbd_queue_work(&mdev->tconn->data.work, &req->w);
 				rv = req->rq_state & RQ_WRITE ? MR_WRITE : MR_READ;
 			}
 			break;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d8c6181..9b1e2ba 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -94,7 +94,7 @@ void drbd_endio_read_sec_final(struct drbd_epoch_entry *e) __releases(local)
 		__drbd_chk_io_error(mdev, false);
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
 
-	drbd_queue_work(&mdev->data.work, &e->w);
+	drbd_queue_work(&mdev->tconn->data.work, &e->w);
 	put_ldev(mdev);
 }
 
@@ -400,7 +400,7 @@ void resync_timer_fn(unsigned long data)
 	struct drbd_conf *mdev = (struct drbd_conf *) data;
 
 	if (list_empty(&mdev->resync_work.list))
-		drbd_queue_work(&mdev->data.work, &mdev->resync_work);
+		drbd_queue_work(&mdev->tconn->data.work, &mdev->resync_work);
 }
 
 static void fifo_set(struct fifo_buffer *fb, int value)
@@ -538,15 +538,15 @@ static int w_make_resync_request(struct drbd_conf *mdev,
 
 	for (i = 0; i < number; i++) {
 		/* Stop generating RS requests, when half of the send buffer is filled */
-		mutex_lock(&mdev->data.mutex);
-		if (mdev->data.socket) {
-			queued = mdev->data.socket->sk->sk_wmem_queued;
-			sndbuf = mdev->data.socket->sk->sk_sndbuf;
+		mutex_lock(&mdev->tconn->data.mutex);
+		if (mdev->tconn->data.socket) {
+			queued = mdev->tconn->data.socket->sk->sk_wmem_queued;
+			sndbuf = mdev->tconn->data.socket->sk->sk_sndbuf;
 		} else {
 			queued = 1;
 			sndbuf = 0;
 		}
-		mutex_unlock(&mdev->data.mutex);
+		mutex_unlock(&mdev->tconn->data.mutex);
 		if (queued > sndbuf / 2)
 			goto requeue;
 
@@ -710,7 +710,7 @@ void start_resync_timer_fn(unsigned long data)
 {
 	struct drbd_conf *mdev = (struct drbd_conf *) data;
 
-	drbd_queue_work(&mdev->data.work, &mdev->start_resync_work);
+	drbd_queue_work(&mdev->tconn->data.work, &mdev->start_resync_work);
 }
 
 int w_start_resync(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
@@ -775,7 +775,7 @@ int drbd_resync_finished(struct drbd_conf *mdev)
 		w = kmalloc(sizeof(struct drbd_work), GFP_ATOMIC);
 		if (w) {
 			w->cb = w_resync_finished;
-			drbd_queue_work(&mdev->data.work, w);
+			drbd_queue_work(&mdev->tconn->data.work, w);
 			return 1;
 		}
 		dev_err(DEV, "Warn failed to drbd_rs_del_all() and to kmalloc(w).\n");
@@ -1202,7 +1202,7 @@ int w_prev_work_done(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 {
 	struct drbd_tl_epoch *b = container_of(w, struct drbd_tl_epoch, w);
-	struct p_barrier *p = &mdev->data.sbuf.barrier;
+	struct p_barrier *p = &mdev->tconn->data.sbuf.barrier;
 	int ok = 1;
 
 	/* really avoid racing with tl_clear.  w.cb may have been referenced
@@ -1223,7 +1223,7 @@ int w_send_barrier(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	/* inc_ap_pending was done where this was queued.
 	 * dec_ap_pending will be done in got_BarrierAck
 	 * or (on connection loss) in w_clear_epoch.  */
-	ok = _drbd_send_cmd(mdev, mdev->data.socket, P_BARRIER,
+	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_BARRIER,
 				(struct p_header80 *)p, sizeof(*p), 0);
 	drbd_put_data_sock(mdev);
 
@@ -1621,18 +1621,18 @@ int drbd_worker(struct drbd_thread *thi)
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(mdev);
 
-		if (down_trylock(&mdev->data.work.s)) {
-			mutex_lock(&mdev->data.mutex);
-			if (mdev->data.socket && !mdev->tconn->net_conf->no_cork)
-				drbd_tcp_uncork(mdev->data.socket);
-			mutex_unlock(&mdev->data.mutex);
+		if (down_trylock(&mdev->tconn->data.work.s)) {
+			mutex_lock(&mdev->tconn->data.mutex);
+			if (mdev->tconn->data.socket && !mdev->tconn->net_conf->no_cork)
+				drbd_tcp_uncork(mdev->tconn->data.socket);
+			mutex_unlock(&mdev->tconn->data.mutex);
 
-			intr = down_interruptible(&mdev->data.work.s);
+			intr = down_interruptible(&mdev->tconn->data.work.s);
 
-			mutex_lock(&mdev->data.mutex);
-			if (mdev->data.socket  && !mdev->tconn->net_conf->no_cork)
-				drbd_tcp_cork(mdev->data.socket);
-			mutex_unlock(&mdev->data.mutex);
+			mutex_lock(&mdev->tconn->data.mutex);
+			if (mdev->tconn->data.socket  && !mdev->tconn->net_conf->no_cork)
+				drbd_tcp_cork(mdev->tconn->data.socket);
+			mutex_unlock(&mdev->tconn->data.mutex);
 		}
 
 		if (intr) {
@@ -1650,8 +1650,8 @@ int drbd_worker(struct drbd_thread *thi)
 		   this...   */
 
 		w = NULL;
-		spin_lock_irq(&mdev->data.work.q_lock);
-		if (!expect(!list_empty(&mdev->data.work.q))) {
+		spin_lock_irq(&mdev->tconn->data.work.q_lock);
+		if (!expect(!list_empty(&mdev->tconn->data.work.q))) {
 			/* something terribly wrong in our logic.
 			 * we were able to down() the semaphore,
 			 * but the list is empty... doh.
@@ -1663,12 +1663,12 @@ int drbd_worker(struct drbd_thread *thi)
 			 *
 			 * I'll try to get away just starting over this loop.
 			 */
-			spin_unlock_irq(&mdev->data.work.q_lock);
+			spin_unlock_irq(&mdev->tconn->data.work.q_lock);
 			continue;
 		}
-		w = list_entry(mdev->data.work.q.next, struct drbd_work, list);
+		w = list_entry(mdev->tconn->data.work.q.next, struct drbd_work, list);
 		list_del_init(&w->list);
-		spin_unlock_irq(&mdev->data.work.q_lock);
+		spin_unlock_irq(&mdev->tconn->data.work.q_lock);
 
 		if (!w->cb(mdev, w, mdev->state.conn < C_CONNECTED)) {
 			/* dev_warn(DEV, "worker: a callback failed! \n"); */
@@ -1680,11 +1680,11 @@ int drbd_worker(struct drbd_thread *thi)
 	D_ASSERT(test_bit(DEVICE_DYING, &mdev->flags));
 	D_ASSERT(test_bit(CONFIG_PENDING, &mdev->flags));
 
-	spin_lock_irq(&mdev->data.work.q_lock);
+	spin_lock_irq(&mdev->tconn->data.work.q_lock);
 	i = 0;
-	while (!list_empty(&mdev->data.work.q)) {
-		list_splice_init(&mdev->data.work.q, &work_list);
-		spin_unlock_irq(&mdev->data.work.q_lock);
+	while (!list_empty(&mdev->tconn->data.work.q)) {
+		list_splice_init(&mdev->tconn->data.work.q, &work_list);
+		spin_unlock_irq(&mdev->tconn->data.work.q_lock);
 
 		while (!list_empty(&work_list)) {
 			w = list_entry(work_list.next, struct drbd_work, list);
@@ -1693,15 +1693,15 @@ int drbd_worker(struct drbd_thread *thi)
 			i++; /* dead debugging code */
 		}
 
-		spin_lock_irq(&mdev->data.work.q_lock);
+		spin_lock_irq(&mdev->tconn->data.work.q_lock);
 	}
-	sema_init(&mdev->data.work.s, 0);
+	sema_init(&mdev->tconn->data.work.s, 0);
 	/* DANGEROUS race: if someone did queue his work within the spinlock,
 	 * but up() ed outside the spinlock, we could get an up() on the
 	 * semaphore without corresponding list entry.
 	 * So don't do that.
 	 */
-	spin_unlock_irq(&mdev->data.work.q_lock);
+	spin_unlock_irq(&mdev->tconn->data.work.q_lock);
 
 	D_ASSERT(mdev->state.disk == D_DISKLESS && mdev->state.conn == C_STANDALONE);
 	/* _drbd_set_state only uses stop_nowait.
-- 
1.7.4.1

