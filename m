Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1HaPLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:11:54 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60084 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab1HaPLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 13/16] drbd: Preparing the connector interface to operator on connections
Date: Wed, 31 Aug 2011 17:11:05 +0200
Message-Id: <1314803468-1201-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up to now it only operated on minor numbers. Now it can work also
on named connections.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    1 +
 drivers/block/drbd/drbd_main.c |   15 ++++++
 drivers/block/drbd/drbd_nl.c   |   96 ++++++++++++++++++++++++++--------------
 include/linux/drbd.h           |   19 ++++++--
 4 files changed, 94 insertions(+), 37 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index fe3c2d2..8ef5b82 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1479,6 +1479,7 @@ extern void drbd_free_mdev(struct drbd_conf *mdev);
 
 struct drbd_tconn *drbd_new_tconn(char *name);
 extern void drbd_free_tconn(struct drbd_tconn *tconn);
+struct drbd_tconn *conn_by_name(const char *name);
 
 extern int proc_details;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 860ed18..689f23f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2196,6 +2196,21 @@ static void drbd_init_workqueue(struct drbd_work_queue* wq)
 	INIT_LIST_HEAD(&wq->q);
 }
 
+struct drbd_tconn *conn_by_name(const char *name)
+{
+	struct drbd_tconn *tconn;
+
+	write_lock_irq(&global_state_lock);
+	list_for_each_entry(tconn, &drbd_tconns, all_tconn) {
+		if (!strcmp(tconn->name, name))
+			goto found;
+	}
+	tconn = NULL;
+found:
+	write_unlock_irq(&global_state_lock);
+	return tconn;
+}
+
 struct drbd_tconn *drbd_new_tconn(char *name)
 {
 	struct drbd_tconn *tconn;
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index b141f89..27a43d1 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2184,42 +2184,57 @@ out:
 	return 0;
 }
 
+enum cn_handler_type {
+	CHT_MINOR,
+	CHT_CONN,
+	CHT_CTOR,
+	/* CHT_RES, later */
+};
+
 struct cn_handler_struct {
-	int (*function)(struct drbd_conf *,
-			 struct drbd_nl_cfg_req *,
-			 struct drbd_nl_cfg_reply *);
+	enum cn_handler_type type;
+	union {
+		int (*minor_based)(struct drbd_conf *,
+				   struct drbd_nl_cfg_req *,
+				   struct drbd_nl_cfg_reply *);
+		int (*conn_based)(struct drbd_tconn *,
+				  struct drbd_nl_cfg_req *,
+				  struct drbd_nl_cfg_reply *);
+		int (*constructor)(struct drbd_nl_cfg_req *,
+				   struct drbd_nl_cfg_reply *);
+	};
 	int reply_body_size;
 };
 
 static struct cn_handler_struct cnd_table[] = {
-	[ P_primary ]		= { &drbd_nl_primary,		0 },
-	[ P_secondary ]		= { &drbd_nl_secondary,		0 },
-	[ P_disk_conf ]		= { &drbd_nl_disk_conf,		0 },
-	[ P_detach ]		= { &drbd_nl_detach,		0 },
-	[ P_net_conf ]		= { &drbd_nl_net_conf,		0 },
-	[ P_disconnect ]	= { &drbd_nl_disconnect,	0 },
-	[ P_resize ]		= { &drbd_nl_resize,		0 },
-	[ P_syncer_conf ]	= { &drbd_nl_syncer_conf,	0 },
-	[ P_invalidate ]	= { &drbd_nl_invalidate,	0 },
-	[ P_invalidate_peer ]	= { &drbd_nl_invalidate_peer,	0 },
-	[ P_pause_sync ]	= { &drbd_nl_pause_sync,	0 },
-	[ P_resume_sync ]	= { &drbd_nl_resume_sync,	0 },
-	[ P_suspend_io ]	= { &drbd_nl_suspend_io,	0 },
-	[ P_resume_io ]		= { &drbd_nl_resume_io,		0 },
-	[ P_outdate ]		= { &drbd_nl_outdate,		0 },
-	[ P_get_config ]	= { &drbd_nl_get_config,
+	[ P_primary ]		= { CHT_MINOR, { &drbd_nl_primary },	0 },
+	[ P_secondary ]		= { CHT_MINOR, { &drbd_nl_secondary },	0 },
+	[ P_disk_conf ]		= { CHT_MINOR, { &drbd_nl_disk_conf },	0 },
+	[ P_detach ]		= { CHT_MINOR, { &drbd_nl_detach },	0 },
+	[ P_net_conf ]		= { CHT_MINOR, { &drbd_nl_net_conf },	0 },
+	[ P_disconnect ]	= { CHT_MINOR, { &drbd_nl_disconnect },	0 },
+	[ P_resize ]		= { CHT_MINOR, { &drbd_nl_resize },	0 },
+	[ P_syncer_conf ]	= { CHT_MINOR, { &drbd_nl_syncer_conf },0 },
+	[ P_invalidate ]	= { CHT_MINOR, { &drbd_nl_invalidate },	0 },
+	[ P_invalidate_peer ]	= { CHT_MINOR, { &drbd_nl_invalidate_peer },0 },
+	[ P_pause_sync ]	= { CHT_MINOR, { &drbd_nl_pause_sync },	0 },
+	[ P_resume_sync ]	= { CHT_MINOR, { &drbd_nl_resume_sync },0 },
+	[ P_suspend_io ]	= { CHT_MINOR, { &drbd_nl_suspend_io },	0 },
+	[ P_resume_io ]		= { CHT_MINOR, { &drbd_nl_resume_io },	0 },
+	[ P_outdate ]		= { CHT_MINOR, { &drbd_nl_outdate },	0 },
+	[ P_get_config ]	= { CHT_MINOR, { &drbd_nl_get_config },
 				    sizeof(struct syncer_conf_tag_len_struct) +
 				    sizeof(struct disk_conf_tag_len_struct) +
 				    sizeof(struct net_conf_tag_len_struct) },
-	[ P_get_state ]		= { &drbd_nl_get_state,
+	[ P_get_state ]		= { CHT_MINOR, { &drbd_nl_get_state },
 				    sizeof(struct get_state_tag_len_struct) +
 				    sizeof(struct sync_progress_tag_len_struct)	},
-	[ P_get_uuids ]		= { &drbd_nl_get_uuids,
+	[ P_get_uuids ]		= { CHT_MINOR, { &drbd_nl_get_uuids },
 				    sizeof(struct get_uuids_tag_len_struct) },
-	[ P_get_timeout_flag ]	= { &drbd_nl_get_timeout_flag,
+	[ P_get_timeout_flag ]	= { CHT_MINOR, { &drbd_nl_get_timeout_flag },
 				    sizeof(struct get_timeout_flag_tag_len_struct)},
-	[ P_start_ov ]		= { &drbd_nl_start_ov,		0 },
-	[ P_new_c_uuid ]	= { &drbd_nl_new_c_uuid,	0 },
+	[ P_start_ov ]		= { CHT_MINOR, { &drbd_nl_start_ov },	0 },
+	[ P_new_c_uuid ]	= { CHT_MINOR, { &drbd_nl_new_c_uuid },	0 },
 };
 
 static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms *nsp)
@@ -2229,6 +2244,7 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 	struct cn_msg *cn_reply;
 	struct drbd_nl_cfg_reply *reply;
 	struct drbd_conf *mdev;
+	struct drbd_tconn *tconn;
 	int retcode, rr;
 	int reply_size = sizeof(struct cn_msg)
 		+ sizeof(struct drbd_nl_cfg_reply)
@@ -2244,13 +2260,6 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 		goto fail;
 	}
 
-	mdev = ensure_mdev(nlp->drbd_minor,
-			(nlp->flags & DRBD_NL_CREATE_DEVICE));
-	if (!mdev) {
-		retcode = ERR_MINOR_INVALID;
-		goto fail;
-	}
-
 	if (nlp->packet_type >= P_nl_after_last_packet ||
 	    nlp->packet_type == P_return_code_only) {
 		retcode = ERR_PACKET_NR;
@@ -2260,7 +2269,7 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 	cm = cnd_table + nlp->packet_type;
 
 	/* This may happen if packet number is 0: */
-	if (cm->function == NULL) {
+	if (cm->minor_based == NULL) {
 		retcode = ERR_PACKET_NR;
 		goto fail;
 	}
@@ -2281,7 +2290,28 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
 	reply->ret_code = NO_ERROR; /* Might by modified by cm->function. */
 	/* reply->tag_list; might be modified by cm->function. */
 
-	rr = cm->function(mdev, nlp, reply);
+	retcode = ERR_MINOR_INVALID;
+	rr = 0;
+	switch (cm->type) {
+	case CHT_MINOR:
+		mdev = minor_to_mdev(nlp->drbd_minor);
+		if (!mdev)
+			goto fail;
+		rr = cm->minor_based(mdev, nlp, reply);
+		break;
+	case CHT_CONN:
+		tconn = conn_by_name(nlp->obj_name);
+		if (!tconn) {
+			retcode = ERR_CONN_NOT_KNOWN;
+			goto fail;
+		}
+		rr = cm->conn_based(tconn, nlp, reply);
+		break;
+	case CHT_CTOR:
+		rr = cm->constructor(nlp, reply);
+		break;
+	/* case CHT_RES: */
+	}
 
 	cn_reply->id = req->id;
 	cn_reply->seq = req->seq;
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 70a688b..7683b4a 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -155,6 +155,7 @@ enum drbd_ret_code {
 	ERR_CONG_NOT_PROTO_A	= 155,
 	ERR_PIC_AFTER_DEP	= 156,
 	ERR_PIC_PEER_DEP	= 157,
+	ERR_CONN_NOT_KNOWN      = 158,
 
 	/* insert new ones above this line */
 	AFTER_LAST_ERR_CODE
@@ -347,8 +348,11 @@ enum drbd_timeout_flag {
 
 /* Start of the new netlink/connector stuff */
 
-#define DRBD_NL_CREATE_DEVICE 0x01
-#define DRBD_NL_SET_DEFAULTS  0x02
+enum drbd_ncr_flags {
+	DRBD_NL_CREATE_DEVICE = 0x01,
+	DRBD_NL_SET_DEFAULTS =  0x02,
+};
+#define DRBD_NL_OBJ_NAME_LEN 32
 
 
 /* For searching a vacant cn_idx value */
@@ -356,8 +360,15 @@ enum drbd_timeout_flag {
 
 struct drbd_nl_cfg_req {
 	int packet_type;
-	unsigned int drbd_minor;
-	int flags;
+	union {
+		struct {
+			unsigned int drbd_minor;
+			enum drbd_ncr_flags flags;
+		};
+		struct {
+			char obj_name[DRBD_NL_OBJ_NAME_LEN];
+		};
+	};
 	unsigned short tag_list[];
 };
 
-- 
1.7.4.1

