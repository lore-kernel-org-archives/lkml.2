Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1HYPMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:12:41 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33318 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1HYPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 110/118] drbd: Killed volume0; last step of multi-volume-enablement
Date: Thu, 25 Aug 2011 17:08:46 +0200
Message-Id: <1314284934-17999-111-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    4 +-
 drivers/block/drbd/drbd_main.c     |    8 +-
 drivers/block/drbd/drbd_nl.c       |    2 +-
 drivers/block/drbd/drbd_receiver.c |   39 +++---
 drivers/block/drbd/drbd_state.c    |  292 +++++++++++++++++++++++++++++-------
 drivers/block/drbd/drbd_state.h    |   10 ++
 drivers/block/drbd/drbd_worker.c   |    7 +-
 7 files changed, 276 insertions(+), 86 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 9c63b10..0ea0b15 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -917,8 +917,8 @@ enum {
 struct drbd_tconn {			/* is a resource from the config file */
 	char *name;			/* Resource name */
 	struct list_head all_tconn;	/* List of all drbd_tconn, prot by global_state_lock */
-	struct drbd_conf *volume0;	/* TODO: Remove me again */
 	struct idr volumes;             /* <tconn, vnr> to mdev mapping */
+	enum drbd_conns cstate;        /* Only C_STANDALONE to C_WF_REPORT_PARAMS */
 
 	unsigned long flags;
 	struct net_conf *net_conf;	/* protected by get_net_conf() and put_net_conf() */
@@ -2023,7 +2023,7 @@ static inline int get_net_conf(struct drbd_tconn *tconn)
 	int have_net_conf;
 
 	atomic_inc(&tconn->net_cnt);
-	have_net_conf = tconn->volume0->state.conn >= C_UNCONNECTED;
+	have_net_conf = tconn->cstate >= C_UNCONNECTED;
 	if (!have_net_conf)
 		put_net_conf(tconn);
 	return have_net_conf;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9d6eb74..2c1df75 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1356,7 +1356,7 @@ static int we_should_drop_the_connection(struct drbd_tconn *tconn, struct socket
 	drop_it =   tconn->meta.socket == sock
 		|| !tconn->asender.task
 		|| get_t_state(&tconn->asender) != RUNNING
-		|| tconn->volume0->state.conn < C_CONNECTED;
+		|| tconn->cstate < C_WF_REPORT_PARAMS;
 
 	if (drop_it)
 		return true;
@@ -1717,9 +1717,9 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 			conn_err(tconn, "%s_sendmsg returned %d\n",
 				 sock == tconn->meta.socket ? "msock" : "sock",
 				 rv);
-			drbd_force_state(tconn->volume0, NS(conn, C_BROKEN_PIPE));
+			conn_request_state(tconn, NS(conn, C_BROKEN_PIPE), CS_HARD);
 		} else
-			drbd_force_state(tconn->volume0, NS(conn, C_TIMEOUT));
+			conn_request_state(tconn, NS(conn, C_TIMEOUT), CS_HARD);
 	}
 
 	return sent;
@@ -2200,6 +2200,7 @@ struct drbd_tconn *drbd_new_tconn(char *name)
 	if (!tconn->name)
 		goto fail;
 
+	tconn->cstate = C_STANDALONE;
 	spin_lock_init(&tconn->req_lock);
 	atomic_set(&tconn->net_cnt, 0);
 	init_waitqueue_head(&tconn->net_cnt_wait);
@@ -2270,7 +2271,6 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	if (!zalloc_cpumask_var(&mdev->tconn->cpu_mask, GFP_KERNEL))
 		goto out_no_cpumask;
 
-	mdev->tconn->volume0 = mdev;
 	mdev->minor = minor;
 
 	drbd_init_set_defaults(mdev);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0debe58..eeb284a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1547,7 +1547,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	mdev->tconn->int_dig_out=int_dig_out;
 	mdev->tconn->int_dig_in=int_dig_in;
 	mdev->tconn->int_dig_vv=int_dig_vv;
-	retcode = _drbd_set_state(_NS(mdev, conn, C_UNCONNECTED), CS_VERBOSE, NULL);
+	retcode = _conn_request_state(mdev->tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
 	kobject_uevent(&disk_to_dev(mdev->vdisk)->kobj, KOBJ_CHANGE);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 113d37f..f755134 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -551,7 +551,7 @@ static int drbd_recv(struct drbd_tconn *tconn, void *buf, size_t size)
 	set_fs(oldfs);
 
 	if (rv != size)
-		drbd_force_state(tconn->volume0, NS(conn, C_BROKEN_PIPE));
+		conn_request_state(tconn, NS(conn, C_BROKEN_PIPE), CS_HARD);
 
 	return rv;
 }
@@ -647,7 +647,7 @@ out:
 			conn_err(tconn, "%s failed, err = %d\n", what, err);
 		}
 		if (disconnect_on_error)
-			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
+			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	}
 	put_net_conf(tconn);
 	return sock;
@@ -694,7 +694,7 @@ out:
 	if (err < 0) {
 		if (err != -EAGAIN && err != -EINTR && err != -ERESTARTSYS) {
 			conn_err(tconn, "%s failed, err = %d\n", what, err);
-			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
+			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	}
 	put_net_conf(tconn);
@@ -776,7 +776,7 @@ static int drbd_connect(struct drbd_tconn *tconn)
 	struct socket *s, *sock, *msock;
 	int try, h, ok;
 
-	if (drbd_request_state(tconn->volume0, NS(conn, C_WF_CONNECTION)) < SS_SUCCESS)
+	if (conn_request_state(tconn, NS(conn, C_WF_CONNECTION), CS_VERBOSE) < SS_SUCCESS)
 		return -2;
 
 	clear_bit(DISCARD_CONCURRENT, &tconn->flags);
@@ -850,7 +850,7 @@ retry:
 			}
 		}
 
-		if (tconn->volume0->state.conn <= C_DISCONNECTING)
+		if (tconn->cstate <= C_DISCONNECTING)
 			goto out_release_sockets;
 		if (signal_pending(current)) {
 			flush_signals(current);
@@ -912,7 +912,7 @@ retry:
 		}
 	}
 
-	if (drbd_request_state(tconn->volume0, NS(conn, C_WF_REPORT_PARAMS)) < SS_SUCCESS)
+	if (conn_request_state(tconn, NS(conn, C_WF_REPORT_PARAMS), CS_VERBOSE) < SS_SUCCESS)
 		return 0;
 
 	sock->sk->sk_sndtimeo = tconn->net_conf->timeout*HZ/10;
@@ -3820,7 +3820,7 @@ static void drbdd(struct drbd_tconn *tconn)
 
 	if (0) {
 	err_out:
-		drbd_force_state(tconn->volume0, NS(conn, C_PROTOCOL_ERROR));
+		conn_request_state(tconn, NS(conn, C_PROTOCOL_ERROR), CS_HARD);
 	}
 }
 
@@ -3837,10 +3837,10 @@ void drbd_flush_workqueue(struct drbd_conf *mdev)
 
 static void drbd_disconnect(struct drbd_tconn *tconn)
 {
-	union drbd_state os, ns;
+	enum drbd_conns oc;
 	int rv = SS_UNKNOWN_ERROR;
 
-	if (tconn->volume0->state.conn == C_STANDALONE)
+	if (tconn->cstate == C_STANDALONE)
 		return;
 
 	/* asender does not clean up anything. it must not interfere, either */
@@ -3852,16 +3852,13 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 	conn_info(tconn, "Connection closed\n");
 
 	spin_lock_irq(&tconn->req_lock);
-	os = tconn->volume0->state;
-	if (os.conn >= C_UNCONNECTED) {
-		/* Do not restart in case we are C_DISCONNECTING */
-		ns.i = os.i;
-		ns.conn = C_UNCONNECTED;
-		rv = _drbd_set_state(tconn->volume0, ns, CS_VERBOSE, NULL);
-	}
+	oc = tconn->cstate;
+	if (oc >= C_UNCONNECTED)
+		rv = _conn_request_state(tconn, NS(conn, C_UNCONNECTED), CS_VERBOSE);
+
 	spin_unlock_irq(&tconn->req_lock);
 
-	if (os.conn == C_DISCONNECTING) {
+	if (oc == C_DISCONNECTING) {
 		wait_event(tconn->net_cnt_wait, atomic_read(&tconn->net_cnt) == 0);
 
 		crypto_free_hash(tconn->cram_hmac_tfm);
@@ -3869,7 +3866,7 @@ static void drbd_disconnect(struct drbd_tconn *tconn)
 
 		kfree(tconn->net_conf);
 		tconn->net_conf = NULL;
-		drbd_request_state(tconn->volume0, NS(conn, C_STANDALONE));
+		conn_request_state(tconn, NS(conn, C_STANDALONE), CS_VERBOSE);
 	}
 }
 
@@ -4243,7 +4240,7 @@ int drbdd_init(struct drbd_thread *thi)
 		}
 		if (h == -1) {
 			conn_warn(tconn, "Discarding network configuration.\n");
-			drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
+			conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 		}
 	} while (h == 0);
 
@@ -4712,11 +4709,11 @@ int drbd_asender(struct drbd_thread *thi)
 
 	if (0) {
 reconnect:
-		drbd_force_state(tconn->volume0, NS(conn, C_NETWORK_FAILURE));
+		conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
 	}
 	if (0) {
 disconnect:
-		drbd_force_state(tconn->volume0, NS(conn, C_DISCONNECTING));
+		conn_request_state(tconn, NS(conn, C_DISCONNECTING), CS_HARD);
 	}
 	clear_bit(SIGNAL_ASENDER, &tconn->flags);
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 0100aab..405ed12 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -43,8 +43,7 @@ int drbd_send_state_req(struct drbd_conf *, union drbd_state, union drbd_state);
 static int w_after_state_ch(struct drbd_work *w, int unused);
 static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			   union drbd_state ns, enum chg_state_flags flags);
-static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
-				union drbd_state ns, enum chg_state_flags flags);
+static void after_all_state_ch(struct drbd_tconn *tconn, union drbd_state ns);
 static enum drbd_state_rv is_valid_state(struct drbd_conf *, union drbd_state);
 static enum drbd_state_rv is_valid_soft_transition(union drbd_state, union drbd_state);
 static enum drbd_state_rv is_valid_transition(union drbd_state os, union drbd_state ns);
@@ -275,6 +274,51 @@ void print_st_err(struct drbd_conf *mdev, union drbd_state os,
 	print_st(mdev, "wanted", ns);
 }
 
+static void print_state_change(struct drbd_conf *mdev, union drbd_state os, union drbd_state ns,
+			       enum chg_state_flags flags)
+{
+	char *pbp, pb[300];
+	pbp = pb;
+	*pbp = 0;
+	if (ns.role != os.role)
+		pbp += sprintf(pbp, "role( %s -> %s ) ",
+			       drbd_role_str(os.role),
+			       drbd_role_str(ns.role));
+	if (ns.peer != os.peer)
+		pbp += sprintf(pbp, "peer( %s -> %s ) ",
+			       drbd_role_str(os.peer),
+			       drbd_role_str(ns.peer));
+	if (ns.conn != os.conn && !(flags & CS_NO_CSTATE_CHG))
+		pbp += sprintf(pbp, "conn( %s -> %s ) ",
+			       drbd_conn_str(os.conn),
+			       drbd_conn_str(ns.conn));
+	if (ns.disk != os.disk)
+		pbp += sprintf(pbp, "disk( %s -> %s ) ",
+			       drbd_disk_str(os.disk),
+			       drbd_disk_str(ns.disk));
+	if (ns.pdsk != os.pdsk)
+		pbp += sprintf(pbp, "pdsk( %s -> %s ) ",
+			       drbd_disk_str(os.pdsk),
+			       drbd_disk_str(ns.pdsk));
+	if (is_susp(ns) != is_susp(os))
+		pbp += sprintf(pbp, "susp( %d -> %d ) ",
+			       is_susp(os),
+			       is_susp(ns));
+	if (ns.aftr_isp != os.aftr_isp)
+		pbp += sprintf(pbp, "aftr_isp( %d -> %d ) ",
+			       os.aftr_isp,
+			       ns.aftr_isp);
+	if (ns.peer_isp != os.peer_isp)
+		pbp += sprintf(pbp, "peer_isp( %d -> %d ) ",
+			       os.peer_isp,
+			       ns.peer_isp);
+	if (ns.user_isp != os.user_isp)
+		pbp += sprintf(pbp, "user_isp( %d -> %d ) ",
+			       os.user_isp,
+			       ns.user_isp);
+	if (pbp != pb)
+		dev_info(DEV, "%s\n", pb);
+}
 
 /**
  * is_valid_state() - Returns an SS_ error code if ns is not valid
@@ -704,48 +748,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 	if (warn_sync_abort)
 		dev_warn(DEV, "%s aborted.\n", warn_sync_abort);
 
-	{
-	char *pbp, pb[300];
-	pbp = pb;
-	*pbp = 0;
-	if (ns.role != os.role)
-		pbp += sprintf(pbp, "role( %s -> %s ) ",
-			       drbd_role_str(os.role),
-			       drbd_role_str(ns.role));
-	if (ns.peer != os.peer)
-		pbp += sprintf(pbp, "peer( %s -> %s ) ",
-			       drbd_role_str(os.peer),
-			       drbd_role_str(ns.peer));
-	if (ns.conn != os.conn)
-		pbp += sprintf(pbp, "conn( %s -> %s ) ",
-			       drbd_conn_str(os.conn),
-			       drbd_conn_str(ns.conn));
-	if (ns.disk != os.disk)
-		pbp += sprintf(pbp, "disk( %s -> %s ) ",
-			       drbd_disk_str(os.disk),
-			       drbd_disk_str(ns.disk));
-	if (ns.pdsk != os.pdsk)
-		pbp += sprintf(pbp, "pdsk( %s -> %s ) ",
-			       drbd_disk_str(os.pdsk),
-			       drbd_disk_str(ns.pdsk));
-	if (is_susp(ns) != is_susp(os))
-		pbp += sprintf(pbp, "susp( %d -> %d ) ",
-			       is_susp(os),
-			       is_susp(ns));
-	if (ns.aftr_isp != os.aftr_isp)
-		pbp += sprintf(pbp, "aftr_isp( %d -> %d ) ",
-			       os.aftr_isp,
-			       ns.aftr_isp);
-	if (ns.peer_isp != os.peer_isp)
-		pbp += sprintf(pbp, "peer_isp( %d -> %d ) ",
-			       os.peer_isp,
-			       ns.peer_isp);
-	if (ns.user_isp != os.user_isp)
-		pbp += sprintf(pbp, "user_isp( %d -> %d ) ",
-			       os.user_isp,
-			       ns.user_isp);
-	dev_info(DEV, "%s\n", pb);
-	}
+	print_state_change(mdev, os, ns, flags);
 
 	/* solve the race between becoming unconfigured,
 	 * worker doing the cleanup, and
@@ -887,7 +890,7 @@ __drbd_set_state(struct drbd_conf *mdev, union drbd_state ns,
 		ascw->done = done;
 		drbd_queue_work(&mdev->tconn->data.work, &ascw->w);
 	} else {
-		dev_warn(DEV, "Could not kmalloc an ascw\n");
+		dev_err(DEV, "Could not kmalloc an ascw\n");
 	}
 
 	return rv;
@@ -1239,21 +1242,202 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 			resume_next_sg(mdev);
 	}
 
-	after_conn_state_ch(mdev->tconn, os, ns, flags);
+	after_all_state_ch(mdev->tconn, ns);
+
 	drbd_md_sync(mdev);
 }
 
-static void after_conn_state_ch(struct drbd_tconn *tconn, union drbd_state os,
-				union drbd_state ns, enum chg_state_flags flags)
+struct after_conn_state_chg_work {
+	struct drbd_work w;
+	enum drbd_conns oc;
+	union drbd_state nms; /* new, max state, over all mdevs */
+	enum chg_state_flags flags;
+};
+
+static void after_all_state_ch(struct drbd_tconn *tconn, union drbd_state ns)
+{
+	if (ns.disk == D_DISKLESS && ns.conn == C_STANDALONE && ns.role == R_SECONDARY) {
+		/* if (test_bit(DEVICE_DYING, &mdev->flags)) TODO: DEVICE_DYING functionality */
+		drbd_thread_stop_nowait(&tconn->worker);
+	}
+}
+
+static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 {
+	struct after_conn_state_chg_work *acscw =
+		container_of(w, struct after_conn_state_chg_work, w);
+	struct drbd_tconn *tconn = w->tconn;
+	enum drbd_conns oc = acscw->oc;
+	union drbd_state nms = acscw->nms;
+
+	kfree(acscw);
+
 	/* Upon network configuration, we need to start the receiver */
-	if (os.conn == C_STANDALONE && ns.conn == C_UNCONNECTED)
+	if (oc == C_STANDALONE && nms.conn == C_UNCONNECTED)
 		drbd_thread_start(&tconn->receiver);
 
-	if (ns.disk == D_DISKLESS &&
-	    ns.conn == C_STANDALONE &&
-	    ns.role == R_SECONDARY) {
-		/* if (test_bit(DEVICE_DYING, &mdev->flags)) TODO: DEVICE_DYING functionality */
-		drbd_thread_stop_nowait(&tconn->worker);
+	//conn_err(tconn, STATE_FMT, STATE_ARGS("nms", nms));
+	after_all_state_ch(tconn, nms);
+
+	return 1;
+}
+
+static void print_conn_state_change(struct drbd_tconn *tconn, enum drbd_conns oc, enum drbd_conns nc)
+{
+	char *pbp, pb[300];
+	pbp = pb;
+	*pbp = 0;
+	if (nc != oc)
+		pbp += sprintf(pbp, "conn( %s -> %s ) ",
+			       drbd_conn_str(oc),
+			       drbd_conn_str(nc));
+
+	conn_info(tconn, "%s\n", pb);
+}
+
+struct _is_valid_itr_params {
+	enum chg_state_flags flags;
+	union drbd_state mask, val;
+	union drbd_state ms; /* maximal state, over all mdevs */
+	enum drbd_conns oc;
+	enum {
+		OC_UNINITIALIZED,
+		OC_CONSISTENT,
+		OC_INCONSISTENT,
+	} oc_state;
+};
+
+static int _is_valid_itr_fn(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	struct _is_valid_itr_params *params = (struct _is_valid_itr_params *)data;
+	enum chg_state_flags flags = params->flags;
+	union drbd_state ns, os;
+	enum drbd_state_rv rv;
+
+	os = mdev->state;
+	ns = apply_mask_val(os, params->mask, params->val);
+	ns = sanitize_state(mdev, ns, NULL);
+	rv = is_valid_state(mdev, ns);
+
+	if (rv < SS_SUCCESS) {
+		/* If the old state was illegal as well, then let this happen...*/
+
+		if (is_valid_state(mdev, os) == rv)
+			rv = is_valid_soft_transition(os, ns);
+	} else
+		rv = is_valid_soft_transition(os, ns);
+
+	switch (params->oc_state) {
+	case OC_UNINITIALIZED:
+		params->oc = os.conn;
+		params->oc_state = OC_CONSISTENT;
+		break;
+	case OC_CONSISTENT:
+		if (params->oc != os.conn)
+			params->oc_state = OC_INCONSISTENT;
+		break;
+	case OC_INCONSISTENT:
+		break;
+	}
+
+	if (rv < SS_SUCCESS) {
+		if (flags & CS_VERBOSE)
+			print_st_err(mdev, os, ns, rv);
+		return rv;
+	} else
+		return 0;
+}
+
+static int _set_state_itr_fn(int vnr, void *p, void *data)
+{
+	struct drbd_conf *mdev = (struct drbd_conf *)p;
+	struct _is_valid_itr_params *params = (struct _is_valid_itr_params *)data;
+	enum chg_state_flags flags = params->flags;
+	union drbd_state os, ns, ms = params->ms;
+	enum drbd_state_rv rv;
+
+	os = mdev->state;
+	ns = apply_mask_val(os, params->mask, params->val);
+	ns = sanitize_state(mdev, ns, NULL);
+
+	rv = __drbd_set_state(mdev, ns, flags, NULL);
+
+	ms.role = max_t(enum drbd_role, mdev->state.role, ms.role);
+	ms.peer = max_t(enum drbd_role, mdev->state.peer, ms.peer);
+	ms.disk = max_t(enum drbd_role, mdev->state.disk, ms.disk);
+	ms.pdsk = max_t(enum drbd_role, mdev->state.pdsk, ms.pdsk);
+	params->ms = ms;
+
+	return 0;
+}
+
+enum drbd_state_rv
+_conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+		    enum chg_state_flags flags)
+{
+	enum drbd_state_rv rv = SS_SUCCESS;
+	struct _is_valid_itr_params params;
+	struct after_conn_state_chg_work *acscw;
+	enum drbd_conns oc = tconn->cstate;
+
+	read_lock(&global_state_lock);
+
+	rv = is_valid_conn_transition(oc, val.conn);
+	if (rv < SS_SUCCESS)
+		goto abort;
+
+	params.flags = flags;
+	params.mask = mask;
+	params.val = val;
+	params.oc_state = OC_UNINITIALIZED;
+
+	if (!(flags & CS_HARD))
+		rv = idr_for_each(&tconn->volumes, _is_valid_itr_fn, &params);
+
+	if (rv == 0)  /* idr_for_each semantics */
+		rv = SS_SUCCESS;
+
+	if (rv < SS_SUCCESS)
+		goto abort;
+
+	if (params.oc_state == OC_CONSISTENT) {
+		oc = params.oc;
+		print_conn_state_change(tconn, oc, val.conn);
+		params.flags |= CS_NO_CSTATE_CHG;
 	}
+	tconn->cstate = val.conn;
+	params.ms.i = 0;
+	params.ms.conn = val.conn;
+	idr_for_each(&tconn->volumes, _set_state_itr_fn, &params);
+
+	acscw = kmalloc(sizeof(*acscw), GFP_ATOMIC);
+	if (acscw) {
+		acscw->oc = oc;
+		acscw->nms = params.ms;
+		acscw->flags = flags;
+		acscw->w.cb = w_after_conn_state_ch;
+		acscw->w.tconn = tconn;
+		drbd_queue_work(&tconn->data.work, &acscw->w);
+	} else {
+		conn_err(tconn, "Could not kmalloc an acscw\n");
+	}
+
+abort:
+	read_unlock(&global_state_lock);
+
+	return rv;
+}
+
+enum drbd_state_rv
+conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+		   enum chg_state_flags flags)
+{
+	static enum drbd_state_rv rv;
+
+	spin_lock_irq(&tconn->req_lock);
+	rv = _conn_request_state(tconn, mask, val, flags);
+	spin_unlock_irq(&tconn->req_lock);
+
+	return rv;
 }
diff --git a/drivers/block/drbd/drbd_state.h b/drivers/block/drbd/drbd_state.h
index 3ec26e2..d312d84 100644
--- a/drivers/block/drbd/drbd_state.h
+++ b/drivers/block/drbd/drbd_state.h
@@ -2,6 +2,7 @@
 #define DRBD_STATE_H
 
 struct drbd_conf;
+struct drbd_tconn;
 
 /**
  * DOC: DRBD State macros
@@ -61,6 +62,7 @@ enum chg_state_flags {
 	CS_WAIT_COMPLETE = 4,
 	CS_SERIALIZE    = 8,
 	CS_ORDERED      = CS_WAIT_COMPLETE + CS_SERIALIZE,
+	CS_NO_CSTATE_CHG = 16, /* Do not display changes in cstate. Internal to drbd_state.c */
 };
 
 extern enum drbd_state_rv drbd_change_state(struct drbd_conf *mdev,
@@ -79,6 +81,14 @@ extern enum drbd_state_rv __drbd_set_state(struct drbd_conf *, union drbd_state,
 extern void print_st_err(struct drbd_conf *, union drbd_state,
 			union drbd_state, int);
 
+enum drbd_state_rv
+_conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+		    enum chg_state_flags flags);
+
+enum drbd_state_rv
+conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
+		   enum chg_state_flags flags);
+
 extern void drbd_resume_al(struct drbd_conf *mdev);
 
 /**
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 8539df2..eee017d 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1720,11 +1720,10 @@ int drbd_worker(struct drbd_thread *thi)
 		list_del_init(&w->list);
 		spin_unlock_irq(&tconn->data.work.q_lock);
 
-		if (!w->cb(w, tconn->volume0->state.conn < C_CONNECTED)) {
+		if (!w->cb(w, tconn->cstate < C_WF_REPORT_PARAMS)) {
 			/* dev_warn(DEV, "worker: a callback failed! \n"); */
-			if (tconn->volume0->state.conn >= C_CONNECTED)
-				drbd_force_state(tconn->volume0,
-						 NS(conn, C_NETWORK_FAILURE));
+			if (tconn->cstate >= C_WF_REPORT_PARAMS)
+				conn_request_state(tconn, NS(conn, C_NETWORK_FAILURE), CS_HARD);
 		}
 	}
 
-- 
1.7.4.1

