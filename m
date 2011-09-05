Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1IELsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:30 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59839 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab1IELqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 45/54] drbd: Make all command handlers return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:36 +0200
Message-Id: <1315223145-20640-46-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |  177 +++++++++++++++++++-----------------
 1 files changed, 93 insertions(+), 84 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index e6b6e01..795d86e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1248,7 +1248,7 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 	switch (mdev->write_ordering) {
 	case WO_none:
 		if (rv == FE_RECYCLED)
-			return true;
+			return 0;
 
 		/* receiver context, in the writeout path of the other node.
 		 * avoid potential distributed deadlock */
@@ -1276,10 +1276,10 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 		D_ASSERT(atomic_read(&epoch->active) == 0);
 		D_ASSERT(epoch->flags == 0);
 
-		return true;
+		return 0;
 	default:
 		dev_err(DEV, "Strangeness in mdev->write_ordering %d\n", mdev->write_ordering);
-		return false;
+		return -EIO;
 	}
 
 	epoch->flags = 0;
@@ -1297,7 +1297,7 @@ static int receive_Barrier(struct drbd_conf *mdev, enum drbd_packet cmd,
 	}
 	spin_unlock(&mdev->epoch_lock);
 
-	return true;
+	return 0;
 }
 
 /* used from receive_RSDataReply (recv_resync_read)
@@ -1566,7 +1566,7 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 {
 	struct drbd_request *req;
 	sector_t sector;
-	int ok;
+	int err;
 	struct p_data *p = &mdev->tconn->data.rbuf.data;
 
 	sector = be64_to_cpu(p->sector);
@@ -1575,27 +1575,26 @@ static int receive_DataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 	req = find_request(mdev, &mdev->read_requests, p->block_id, sector, false, __func__);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 	if (unlikely(!req))
-		return false;
+		return -EIO;
 
 	/* hlist_del(&req->collision) is done in _req_may_be_done, to avoid
 	 * special casing it there for the various failure cases.
 	 * still no race with drbd_fail_pending_reads */
-	ok = !recv_dless_read(mdev, req, sector, data_size);
-
-	if (ok)
+	err = recv_dless_read(mdev, req, sector, data_size);
+	if (!err)
 		req_mod(req, DATA_RECEIVED);
 	/* else: nothing. handled from drbd_disconnect...
 	 * I don't think we may complete this just yet
 	 * in case we are "on-disconnect: freeze" */
 
-	return ok;
+	return err;
 }
 
 static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 			       unsigned int data_size)
 {
 	sector_t sector;
-	int ok;
+	int err;
 	struct p_data *p = &mdev->tconn->data.rbuf.data;
 
 	sector = be64_to_cpu(p->sector);
@@ -1605,19 +1604,19 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
 		 * or in drbd_peer_request_endio. */
-		ok = !recv_resync_read(mdev, sector, data_size);
+		err = recv_resync_read(mdev, sector, data_size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Can not write resync data to local disk.\n");
 
-		ok = !drbd_drain_block(mdev, data_size);
+		err = drbd_drain_block(mdev, data_size);
 
 		drbd_send_ack_dp(mdev, P_NEG_ACK, p, data_size);
 	}
 
 	atomic_add(data_size >> 9, &mdev->rs_sect_in);
 
-	return ok;
+	return err;
 }
 
 static int w_restart_write(struct drbd_work *w, int cancel)
@@ -1991,12 +1990,16 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	u32 dp_flags;
 	int err;
 
-
 	if (!get_ldev(mdev)) {
+		int err2;
+
 		err = wait_for_and_update_peer_seq(mdev, peer_seq);
 		drbd_send_ack_dp(mdev, P_NEG_ACK, p, data_size);
 		atomic_inc(&mdev->current_epoch->epoch_size);
-		return !drbd_drain_block(mdev, data_size) && err == 0;
+		err2 = drbd_drain_block(mdev, data_size);
+		if (!err)
+			err = err2;
+		return err;
 	}
 
 	/*
@@ -2009,7 +2012,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 	peer_req = read_in_block(mdev, p->block_id, sector, data_size);
 	if (!peer_req) {
 		put_ldev(mdev);
-		return false;
+		return -EIO;
 	}
 
 	peer_req->w.cb = e_end_block;
@@ -2036,7 +2039,7 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 			spin_unlock_irq(&mdev->tconn->req_lock);
 			if (err == -ENOENT) {
 				put_ldev(mdev);
-				return true;
+				return 0;
 			}
 			goto out_interrupted;
 		}
@@ -2069,8 +2072,9 @@ static int receive_Data(struct drbd_conf *mdev, enum drbd_packet cmd,
 		drbd_al_begin_io(mdev, peer_req->i.sector);
 	}
 
-	if (drbd_submit_peer_request(mdev, peer_req, rw, DRBD_FAULT_DT_WR) == 0)
-		return true;
+	err = drbd_submit_peer_request(mdev, peer_req, rw, DRBD_FAULT_DT_WR);
+	if (!err)
+		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
@@ -2085,7 +2089,7 @@ out_interrupted:
 	drbd_may_finish_epoch(mdev, peer_req->epoch, EV_PUT + EV_CLEANUP);
 	put_ldev(mdev);
 	drbd_free_ee(mdev, peer_req);
-	return false;
+	return err;
 }
 
 /* We may throttle resync, if the lower device seems to be busy,
@@ -2172,12 +2176,12 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
 		dev_err(DEV, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
 				(unsigned long long)sector, size);
-		return false;
+		return -EINVAL;
 	}
 	if (sector + (size>>9) > capacity) {
 		dev_err(DEV, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
 				(unsigned long long)sector, size);
-		return false;
+		return -EINVAL;
 	}
 
 	if (!get_ldev_if_state(mdev, D_UP_TO_DATE)) {
@@ -2205,7 +2209,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 			    "no local data.\n");
 
 		/* drain possibly payload */
-		return !drbd_drain_block(mdev, digest_size);
+		return drbd_drain_block(mdev, digest_size);
 	}
 
 	/* GFP_NOIO, because we must not cause arbitrary write-out: in a DRBD
@@ -2214,7 +2218,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	peer_req = drbd_alloc_ee(mdev, p->block_id, sector, size, GFP_NOIO);
 	if (!peer_req) {
 		put_ldev(mdev);
-		return false;
+		return -ENOMEM;
 	}
 
 	switch (cmd) {
@@ -2327,7 +2331,7 @@ submit:
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	if (drbd_submit_peer_request(mdev, peer_req, READ, fault_type) == 0)
-		return true;
+		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
@@ -2339,7 +2343,7 @@ submit:
 out_free_e:
 	put_ldev(mdev);
 	drbd_free_ee(mdev, peer_req);
-	return false;
+	return -EIO;
 }
 
 static int drbd_asb_recover_0p(struct drbd_conf *mdev) __must_hold(local)
@@ -2934,9 +2938,11 @@ static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
 
 	if (tconn->agreed_pro_version >= 87) {
 		unsigned char *my_alg = tconn->net_conf->integrity_alg;
+		int err;
 
-		if (drbd_recv(tconn, p_integrity_alg, data_size) != data_size)
-			return false;
+		err = drbd_recv_all(tconn, p_integrity_alg, data_size);
+		if (err)
+			return err;
 
 		p_integrity_alg[SHARED_SECRET_MAX-1] = 0;
 		if (strcmp(p_integrity_alg, my_alg)) {
@@ -2947,11 +2953,11 @@ static int receive_protocol(struct drbd_tconn *tconn, enum drbd_packet cmd,
 		     my_alg[0] ? my_alg : (unsigned char *)"<not-used>");
 	}
 
-	return true;
+	return 0;
 
 disconnect:
 	conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-	return false;
+	return -EIO;
 }
 
 /* helper function
@@ -2984,7 +2990,6 @@ struct crypto_hash *drbd_crypto_alloc_digest_safe(const struct drbd_conf *mdev,
 static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 			     unsigned int packet_size)
 {
-	int ok = true;
 	struct p_rs_param_95 *p = &mdev->tconn->data.rbuf.rs_param_95;
 	unsigned int header_size, data_size, exp_max_sz;
 	struct crypto_hash *verify_tfm = NULL;
@@ -2992,6 +2997,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 	const int apv = mdev->tconn->agreed_pro_version;
 	int *rs_plan_s = NULL;
 	int fifo_size = 0;
+	int err;
 
 	exp_max_sz  = apv <= 87 ? sizeof(struct p_rs_param)
 		    : apv == 88 ? sizeof(struct p_rs_param)
@@ -3002,7 +3008,7 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (packet_size > exp_max_sz) {
 		dev_err(DEV, "SyncParam packet too long: received %u, expected <= %u bytes\n",
 		    packet_size, exp_max_sz);
-		return false;
+		return -EIO;
 	}
 
 	if (apv <= 88) {
@@ -3021,8 +3027,9 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 	/* initialize verify_alg and csums_alg */
 	memset(p->verify_alg, 0, 2 * SHARED_SECRET_MAX);
 
-	if (drbd_recv(mdev->tconn, &p->head.payload, header_size) != header_size)
-		return false;
+	err = drbd_recv_all(mdev->tconn, &p->head.payload, header_size);
+	if (err)
+		return err;
 
 	mdev->ldev->dc.resync_rate = be32_to_cpu(p->rate);
 
@@ -3032,11 +3039,12 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 				dev_err(DEV, "verify-alg too long, "
 				    "peer wants %u, accepting only %u byte\n",
 						data_size, SHARED_SECRET_MAX);
-				return false;
+				return -EIO;
 			}
 
-			if (drbd_recv(mdev->tconn, p->verify_alg, data_size) != data_size)
-				return false;
+			err = drbd_recv_all(mdev->tconn, p->verify_alg, data_size);
+			if (err)
+				return err;
 
 			/* we expect NUL terminated string */
 			/* but just in case someone tries to be evil */
@@ -3121,8 +3129,8 @@ static int receive_SyncParam(struct drbd_conf *mdev, enum drbd_packet cmd,
 		}
 		spin_unlock(&mdev->peer_seq_lock);
 	}
+	return 0;
 
-	return ok;
 disconnect:
 	/* just for completeness: actually not needed,
 	 * as this is not reached if csums_tfm was ok. */
@@ -3130,7 +3138,7 @@ disconnect:
 	/* but free the verify_tfm again, if csums_tfm did not work out */
 	crypto_free_hash(verify_tfm);
 	conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-	return false;
+	return -EIO;
 }
 
 /* warn if the arguments differ by more than 12.5% */
@@ -3192,7 +3200,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 			conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 			mdev->ldev->dc.disk_size = my_usize;
 			put_ldev(mdev);
-			return false;
+			return -EIO;
 		}
 		put_ldev(mdev);
 	}
@@ -3202,7 +3210,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 		dd = drbd_determine_dev_size(mdev, ddsf);
 		put_ldev(mdev);
 		if (dd == dev_size_error)
-			return false;
+			return -EIO;
 		drbd_md_sync(mdev);
 	} else {
 		/* I am diskless, need to accept the peer's size. */
@@ -3241,7 +3249,7 @@ static int receive_sizes(struct drbd_conf *mdev, enum drbd_packet cmd,
 		}
 	}
 
-	return true;
+	return 0;
 }
 
 static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -3266,7 +3274,7 @@ static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
 		dev_err(DEV, "Can only connect to data with current UUID=%016llX\n",
 		    (unsigned long long)mdev->ed_uuid);
 		conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-		return false;
+		return -EIO;
 	}
 
 	if (get_ldev(mdev)) {
@@ -3307,7 +3315,7 @@ static int receive_uuids(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (updated_uuids)
 		drbd_print_uuids(mdev, "receiver updated UUIDs to");
 
-	return true;
+	return 0;
 }
 
 /**
@@ -3353,7 +3361,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (test_bit(DISCARD_CONCURRENT, &mdev->tconn->flags) &&
 	    mutex_is_locked(mdev->state_mutex)) {
 		drbd_send_sr_reply(mdev, SS_CONCURRENT_ST_CHG);
-		return true;
+		return 0;
 	}
 
 	mask = convert_state(mask);
@@ -3364,7 +3372,7 @@ static int receive_req_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	drbd_md_sync(mdev);
 
-	return true;
+	return 0;
 }
 
 static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd,
@@ -3380,7 +3388,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd
 	if (test_bit(DISCARD_CONCURRENT, &tconn->flags) &&
 	    mutex_is_locked(&tconn->cstate_mutex)) {
 		conn_send_sr_reply(tconn, SS_CONCURRENT_ST_CHG);
-		return true;
+		return 0;
 	}
 
 	mask = convert_state(mask);
@@ -3389,7 +3397,7 @@ static int receive_req_conn_state(struct drbd_tconn *tconn, enum drbd_packet cmd
 	rv = conn_request_state(tconn, mask, val, CS_VERBOSE | CS_LOCAL_ONLY);
 	conn_send_sr_reply(tconn, rv);
 
-	return true;
+	return 0;
 }
 
 static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -3435,7 +3443,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 			 peer_state.conn == C_CONNECTED) {
 			if (drbd_bm_total_weight(mdev) <= mdev->rs_failed)
 				drbd_resync_finished(mdev);
-			return true;
+			return 0;
 		}
 	}
 
@@ -3488,10 +3496,10 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 				real_peer_disk = D_DISKLESS;
 			} else {
 				if (test_and_clear_bit(CONN_DRY_RUN, &mdev->tconn->flags))
-					return false;
+					return -EIO;
 				D_ASSERT(os.conn == C_WF_REPORT_PARAMS);
 				conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-				return false;
+				return -EIO;
 			}
 		}
 	}
@@ -3516,7 +3524,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 		drbd_uuid_new_current(mdev);
 		clear_bit(NEW_CUR_UUID, &mdev->flags);
 		conn_request_state(mdev->tconn, NS2(conn, C_PROTOCOL_ERROR, susp, 0), CS_HARD);
-		return false;
+		return -EIO;
 	}
 	rv = _drbd_set_state(mdev, ns, cs_flags, NULL);
 	ns = mdev->state;
@@ -3524,7 +3532,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	if (rv < SS_SUCCESS) {
 		conn_request_state(mdev->tconn, NS(conn, C_DISCONNECTING), CS_HARD);
-		return false;
+		return -EIO;
 	}
 
 	if (os.conn > C_WF_REPORT_PARAMS) {
@@ -3542,7 +3550,7 @@ static int receive_state(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	drbd_md_sync(mdev); /* update connected indicator, la_size, ... */
 
-	return true;
+	return 0;
 }
 
 static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -3571,7 +3579,7 @@ static int receive_sync_uuid(struct drbd_conf *mdev, enum drbd_packet cmd,
 	} else
 		dev_err(DEV, "Ignoring SyncUUID packet!\n");
 
-	return true;
+	return 0;
 }
 
 /**
@@ -3594,12 +3602,9 @@ receive_bitmap_plain(struct drbd_conf *mdev, unsigned int data_size,
 	}
 	if (want == 0)
 		return 0;
-	err = drbd_recv(mdev->tconn, buffer, want);
-	if (err != want) {
-		if (err >= 0)
-			err = -EIO;
+	err = drbd_recv_all(mdev->tconn, buffer, want);
+	if (err)
 		return err;
-	}
 
 	drbd_bm_merge_lel(mdev, c->word_offset, num_words, buffer);
 
@@ -3748,7 +3753,6 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	struct bm_xfer_ctx c;
 	void *buffer;
 	int err;
-	int ok = false;
 	struct p_header *h = &mdev->tconn->data.rbuf.header;
 	struct packet_info pi;
 
@@ -3761,6 +3765,7 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	buffer	 = (unsigned long *) __get_free_page(GFP_NOIO);
 	if (!buffer) {
 		dev_err(DEV, "failed to allocate one page buffer in %s\n", __func__);
+		err = -ENOMEM;
 		goto out;
 	}
 
@@ -3779,20 +3784,24 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 			if (data_size > BM_PACKET_PAYLOAD_BYTES) {
 				dev_err(DEV, "ReportCBitmap packet too large\n");
+				err = -EIO;
 				goto out;
 			}
 			/* use the page buff */
 			p = buffer;
 			memcpy(p, h, sizeof(*h));
-			if (drbd_recv(mdev->tconn, p->head.payload, data_size) != data_size)
-				goto out;
+			err = drbd_recv_all(mdev->tconn, p->head.payload, data_size);
+			if (err)
+			       goto out;
 			if (data_size <= (sizeof(*p) - sizeof(p->head))) {
 				dev_err(DEV, "ReportCBitmap packet too small (l:%u)\n", data_size);
+				err = -EIO;
 				goto out;
 			}
 			err = decode_bitmap_c(mdev, p, &c, data_size);
 		} else {
 			dev_warn(DEV, "receive_bitmap: cmd neither ReportBitMap nor ReportCBitMap (is 0x%x)", cmd);
+			err = -EIO;
 			goto out;
 		}
 
@@ -3804,7 +3813,8 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 				goto out;
 			break;
 		}
-		if (drbd_recv_header(mdev->tconn, &pi))
+		err = drbd_recv_header(mdev->tconn, &pi);
+		if (err)
 			goto out;
 		cmd = pi.cmd;
 		data_size = pi.size;
@@ -3815,8 +3825,8 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 	if (mdev->state.conn == C_WF_BITMAP_T) {
 		enum drbd_state_rv rv;
 
-		ok = !drbd_send_bitmap(mdev);
-		if (!ok)
+		err = drbd_send_bitmap(mdev);
+		if (err)
 			goto out;
 		/* Omit CS_ORDERED with this state transition to avoid deadlocks. */
 		rv = _drbd_request_state(mdev, NS(conn, C_WF_SYNC_UUID), CS_VERBOSE);
@@ -3827,14 +3837,14 @@ static int receive_bitmap(struct drbd_conf *mdev, enum drbd_packet cmd,
 		dev_info(DEV, "unexpected cstate (%s) in receive_bitmap\n",
 		    drbd_conn_str(mdev->state.conn));
 	}
+	err = 0;
 
-	ok = true;
  out:
 	drbd_bm_unlock(mdev);
-	if (ok && mdev->state.conn == C_WF_BITMAP_S)
+	if (!err && mdev->state.conn == C_WF_BITMAP_S)
 		drbd_start_resync(mdev, C_SYNC_SOURCE);
 	free_page((unsigned long) buffer);
-	return ok;
+	return err;
 }
 
 static int _tconn_receive_skip(struct drbd_tconn *tconn, unsigned int data_size)
@@ -3851,7 +3861,7 @@ static int _tconn_receive_skip(struct drbd_tconn *tconn, unsigned int data_size)
 			break;
 		size -= r;
 	}
-	return size == 0;
+	return size ? -EIO : 0;
 }
 
 static int receive_skip(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -3878,7 +3888,7 @@ static int receive_UnplugRemote(struct drbd_conf *mdev, enum drbd_packet cmd,
 	 * with the data requests being unplugged */
 	drbd_tcp_quickack(mdev->tconn->data.socket);
 
-	return true;
+	return 0;
 }
 
 static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
@@ -3898,7 +3908,7 @@ static int receive_out_of_sync(struct drbd_conf *mdev, enum drbd_packet cmd,
 
 	drbd_set_out_of_sync(mdev, be64_to_cpu(p->sector), be32_to_cpu(p->blksize));
 
-	return true;
+	return 0;
 }
 
 struct data_cmd {
@@ -3951,7 +3961,7 @@ static void drbdd(struct drbd_tconn *tconn)
 	struct p_header *header = &tconn->data.rbuf.header;
 	struct packet_info pi;
 	size_t shs; /* sub header size */
-	int rv;
+	int err;
 
 	while (get_t_state(&tconn->receiver) == RUNNING) {
 		drbd_thread_current_set_cpu(&tconn->receiver);
@@ -3971,34 +3981,33 @@ static void drbdd(struct drbd_tconn *tconn)
 		}
 
 		if (shs) {
-			rv = drbd_recv(tconn, &header->payload, shs);
-			if (unlikely(rv != shs)) {
+			err = drbd_recv_all(tconn, &header->payload, shs);
+			if (err) {
 				if (!signal_pending(current))
-					conn_warn(tconn, "short read while reading sub header: rv=%d\n", rv);
+					conn_warn(tconn, "short read while reading sub header: rv=%d\n", err);
 				goto err_out;
 			}
 		}
 
 		if (drbd_cmd_handler[pi.cmd].fa_type == CONN) {
-			rv = drbd_cmd_handler[pi.cmd].conn_fn(tconn, pi.cmd, pi.size - shs);
+			err = drbd_cmd_handler[pi.cmd].conn_fn(tconn, pi.cmd, pi.size - shs);
 		} else {
 			struct drbd_conf *mdev = vnr_to_mdev(tconn, pi.vnr);
-			rv = mdev ?
+			err = mdev ?
 				drbd_cmd_handler[pi.cmd].mdev_fn(mdev, pi.cmd, pi.size - shs) :
 				tconn_receive_skip(tconn, pi.cmd, pi.size - shs);
 		}
 
-		if (unlikely(!rv)) {
+		if (unlikely(err)) {
 			conn_err(tconn, "error receiving %s, l: %d!\n",
 			    cmdname(pi.cmd), pi.size);
 			goto err_out;
 		}
 	}
+	return;
 
-	if (0) {
-	err_out:
-		conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
-	}
+    err_out:
+	conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 }
 
 void conn_flush_workqueue(struct drbd_tconn *tconn)
-- 
1.7.4.1

