Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab1HaPNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:13:08 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59956 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab1HaPLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/16] drbd: Removed the mdev parameter from the ..to_tags() and ...from_tags() functions
Date: Wed, 31 Aug 2011 17:11:02 +0200
Message-Id: <1314803468-1201-11-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 8cdfb46..33159e4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -50,9 +50,9 @@ static char *drbd_m_holder = "Hands off! this is DRBD's meta data device.";
 
 /* Generate the tag_list to struct functions */
 #define NL_PACKET(name, number, fields) \
-static int name ## _from_tags(struct drbd_conf *mdev, \
+static int name ## _from_tags( \
 	unsigned short *tags, struct name *arg) __attribute__ ((unused)); \
-static int name ## _from_tags(struct drbd_conf *mdev, \
+static int name ## _from_tags( \
 	unsigned short *tags, struct name *arg) \
 { \
 	int tag; \
@@ -64,7 +64,7 @@ static int name ## _from_tags(struct drbd_conf *mdev, \
 		fields \
 		default: \
 			if (tag & T_MANDATORY) { \
-				dev_err(DEV, "Unknown tag: %d\n", tag_number(tag)); \
+				printk(KERN_ERR "drbd: Unknown tag: %d\n", tag_number(tag)); \
 				return 0; \
 			} \
 		} \
@@ -87,7 +87,7 @@ static int name ## _from_tags(struct drbd_conf *mdev, \
 #define NL_STRING(pn, pr, member, len) \
 	case pn: /* D_ASSERT( tag_type(tag) == TT_STRING ); */ \
 		if (dlen > len) { \
-			dev_err(DEV, "arg too long: %s (%u wanted, max len: %u bytes)\n", \
+			printk(KERN_ERR "drbd: arg too long: %s (%u wanted, max len: %u bytes)\n", \
 				#member, dlen, (unsigned int)len); \
 			return 0; \
 		} \
@@ -99,10 +99,10 @@ static int name ## _from_tags(struct drbd_conf *mdev, \
 /* Generate the struct to tag_list functions */
 #define NL_PACKET(name, number, fields) \
 static unsigned short* \
-name ## _to_tags(struct drbd_conf *mdev, \
+name ## _to_tags( \
 	struct name *arg, unsigned short *tags) __attribute__ ((unused)); \
 static unsigned short* \
-name ## _to_tags(struct drbd_conf *mdev, \
+name ## _to_tags( \
 	struct name *arg, unsigned short *tags) \
 { \
 	fields \
@@ -483,7 +483,7 @@ static int drbd_nl_primary(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	struct primary primary_args;
 
 	memset(&primary_args, 0, sizeof(struct primary));
-	if (!primary_from_tags(mdev, nlp->tag_list, &primary_args)) {
+	if (!primary_from_tags(nlp->tag_list, &primary_args)) {
 		reply->ret_code = ERR_MANDATORY_TAG;
 		return 0;
 	}
@@ -956,7 +956,7 @@ static int drbd_nl_disk_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	nbc->dc.fencing       = DRBD_FENCING_DEF;
 	nbc->dc.max_bio_bvecs = DRBD_MAX_BIO_BVECS_DEF;
 
-	if (!disk_conf_from_tags(mdev, nlp->tag_list, &nbc->dc)) {
+	if (!disk_conf_from_tags(nlp->tag_list, &nbc->dc)) {
 		retcode = ERR_MANDATORY_TAG;
 		goto fail;
 	}
@@ -1376,7 +1376,7 @@ static int drbd_nl_net_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	new_conf->on_congestion    = DRBD_ON_CONGESTION_DEF;
 	new_conf->cong_extents     = DRBD_CONG_EXTENTS_DEF;
 
-	if (!net_conf_from_tags(mdev, nlp->tag_list, new_conf)) {
+	if (!net_conf_from_tags(nlp->tag_list, new_conf)) {
 		retcode = ERR_MANDATORY_TAG;
 		goto fail;
 	}
@@ -1553,7 +1553,7 @@ static int drbd_nl_disconnect(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	struct disconnect dc;
 
 	memset(&dc, 0, sizeof(struct disconnect));
-	if (!disconnect_from_tags(mdev, nlp->tag_list, &dc)) {
+	if (!disconnect_from_tags(nlp->tag_list, &dc)) {
 		retcode = ERR_MANDATORY_TAG;
 		goto fail;
 	}
@@ -1630,7 +1630,7 @@ static int drbd_nl_resize(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	enum dds_flags ddsf;
 
 	memset(&rs, 0, sizeof(struct resize));
-	if (!resize_from_tags(mdev, nlp->tag_list, &rs)) {
+	if (!resize_from_tags(nlp->tag_list, &rs)) {
 		retcode = ERR_MANDATORY_TAG;
 		goto fail;
 	}
@@ -1715,7 +1715,7 @@ static int drbd_nl_syncer_conf(struct drbd_conf *mdev, struct drbd_nl_cfg_req *n
 	} else
 		memcpy(&sc, &mdev->sync_conf, sizeof(struct syncer_conf));
 
-	if (!syncer_conf_from_tags(mdev, nlp->tag_list, &sc)) {
+	if (!syncer_conf_from_tags(nlp->tag_list, &sc)) {
 		retcode = ERR_MANDATORY_TAG;
 		goto fail;
 	}
@@ -2020,15 +2020,15 @@ static int drbd_nl_get_config(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	tl = reply->tag_list;
 
 	if (get_ldev(mdev)) {
-		tl = disk_conf_to_tags(mdev, &mdev->ldev->dc, tl);
+		tl = disk_conf_to_tags(&mdev->ldev->dc, tl);
 		put_ldev(mdev);
 	}
 
 	if (get_net_conf(mdev->tconn)) {
-		tl = net_conf_to_tags(mdev, mdev->tconn->net_conf, tl);
+		tl = net_conf_to_tags(mdev->tconn->net_conf, tl);
 		put_net_conf(mdev->tconn);
 	}
-	tl = syncer_conf_to_tags(mdev, &mdev->sync_conf, tl);
+	tl = syncer_conf_to_tags(&mdev->sync_conf, tl);
 
 	put_unaligned(TT_END, tl++); /* Close the tag list */
 
@@ -2043,7 +2043,7 @@ static int drbd_nl_get_state(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp
 	unsigned long rs_left;
 	unsigned int res;
 
-	tl = get_state_to_tags(mdev, (struct get_state *)&s, tl);
+	tl = get_state_to_tags((struct get_state *)&s, tl);
 
 	/* no local ref, no bitmap, no syncer progress. */
 	if (s.conn >= C_SYNC_SOURCE && s.conn <= C_PAUSED_SYNC_T) {
@@ -2105,7 +2105,7 @@ static int drbd_nl_start_ov(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nlp,
 	struct start_ov args =
 		{ .start_sector = mdev->ov_start_sector };
 
-	if (!start_ov_from_tags(mdev, nlp->tag_list, &args)) {
+	if (!start_ov_from_tags(nlp->tag_list, &args)) {
 		reply->ret_code = ERR_MANDATORY_TAG;
 		return 0;
 	}
@@ -2131,7 +2131,7 @@ static int drbd_nl_new_c_uuid(struct drbd_conf *mdev, struct drbd_nl_cfg_req *nl
 	struct new_c_uuid args;
 
 	memset(&args, 0, sizeof(struct new_c_uuid));
-	if (!new_c_uuid_from_tags(mdev, nlp->tag_list, &args)) {
+	if (!new_c_uuid_from_tags(nlp->tag_list, &args)) {
 		reply->ret_code = ERR_MANDATORY_TAG;
 		return 0;
 	}
@@ -2365,7 +2365,7 @@ void drbd_bcast_state(struct drbd_conf *mdev, union drbd_state state)
 
 	/* dev_warn(DEV, "drbd_bcast_state() got called\n"); */
 
-	tl = get_state_to_tags(mdev, (struct get_state *)&state, tl);
+	tl = get_state_to_tags((struct get_state *)&state, tl);
 
 	put_unaligned(TT_END, tl++); /* Close the tag list */
 
-- 
1.7.4.1

