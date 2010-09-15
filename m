Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0IOVIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:08:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab0IOVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:07:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        vgoyal@redhat.com
Subject: [PATCH 5/7] blk-cgroup: cgroup changes for IOPS limit support
Date: Wed, 15 Sep 2010 17:06:36 -0400
Message-Id: <1284584798-10264-6-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
References: <1284584798-10264-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o cgroup changes for IOPS throttling rules.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |  139 +++++++++++++++++++++++++++++++++++++++++++++------
 block/blk-cgroup.h |   13 +++++
 2 files changed, 135 insertions(+), 17 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 32b5920..a964a22 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -149,6 +149,27 @@ static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
 	}
 }
 
+static inline void blkio_update_group_iops(struct blkio_group *blkg,
+			unsigned int iops, int fileid)
+{
+	struct blkio_policy_type *blkiop;
+
+	list_for_each_entry(blkiop, &blkio_list, list) {
+
+		/* If this policy does not own the blkg, do not send updates */
+		if (blkiop->plid != blkg->plid)
+			continue;
+
+		if (fileid == BLKIO_THROTL_read_iops_device
+		    && blkiop->ops.blkio_update_group_read_iops_fn)
+			blkiop->ops.blkio_update_group_read_iops_fn(blkg, iops);
+
+		if (fileid == BLKIO_THROTL_write_iops_device
+		    && blkiop->ops.blkio_update_group_write_iops_fn)
+			blkiop->ops.blkio_update_group_write_iops_fn(blkg,iops);
+	}
+}
+
 /*
  * Add to the appropriate stat variable depending on the request type.
  * This should be called with the blkg->stats_lock held.
@@ -630,7 +651,7 @@ static int blkio_policy_parse_and_set(char *buf,
 {
 	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
 	int ret;
-	unsigned long major, minor, temp;
+	unsigned long major, minor, temp, iops;
 	int i = 0;
 	dev_t dev;
 	u64 bps;
@@ -692,13 +713,28 @@ static int blkio_policy_parse_and_set(char *buf,
 		newpn->val.weight = temp;
 		break;
 	case BLKIO_POLICY_THROTL:
-		ret = strict_strtoull(s[1], 10, &bps);
-		if (ret)
-			return -EINVAL;
+		switch(fileid) {
+		case BLKIO_THROTL_read_bps_device:
+		case BLKIO_THROTL_write_bps_device:
+			ret = strict_strtoull(s[1], 10, &bps);
+			if (ret)
+				return -EINVAL;
 
-		newpn->plid = plid;
-		newpn->fileid = fileid;
-		newpn->val.bps = bps;
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.bps = bps;
+			break;
+		case BLKIO_THROTL_read_iops_device:
+		case BLKIO_THROTL_write_iops_device:
+			ret = strict_strtoul(s[1], 10, &iops);
+			if (ret)
+				return -EINVAL;
+
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.iops = iops;
+			break;
+		}
 		break;
 	default:
 		BUG();
@@ -744,6 +780,29 @@ uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
 		return -1;
 }
 
+unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg, dev_t dev)
+{
+	struct blkio_policy_node *pn;
+
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_read_iops_device);
+	if (pn)
+		return pn->val.iops;
+	else
+		return -1;
+}
+
+unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg, dev_t dev)
+{
+	struct blkio_policy_node *pn;
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_write_iops_device);
+	if (pn)
+		return pn->val.iops;
+	else
+		return -1;
+}
+
 /* Checks whether user asked for deleting a policy rule */
 static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
 {
@@ -753,8 +812,17 @@ static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
 			return 1;
 		break;
 	case BLKIO_POLICY_THROTL:
-		if (pn->val.bps == 0)
-			return 1;
+		switch(pn->fileid) {
+		case BLKIO_THROTL_read_bps_device:
+		case BLKIO_THROTL_write_bps_device:
+			if (pn->val.bps == 0)
+				return 1;
+			break;
+		case BLKIO_THROTL_read_iops_device:
+		case BLKIO_THROTL_write_iops_device:
+			if (pn->val.iops == 0)
+				return 1;
+		}
 		break;
 	default:
 		BUG();
@@ -771,7 +839,15 @@ static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
 		oldpn->val.weight = newpn->val.weight;
 		break;
 	case BLKIO_POLICY_THROTL:
-		oldpn->val.bps = newpn->val.bps;
+		switch(newpn->fileid) {
+		case BLKIO_THROTL_read_bps_device:
+		case BLKIO_THROTL_write_bps_device:
+			oldpn->val.bps = newpn->val.bps;
+			break;
+		case BLKIO_THROTL_read_iops_device:
+		case BLKIO_THROTL_write_iops_device:
+			oldpn->val.iops = newpn->val.iops;
+		}
 		break;
 	default:
 		BUG();
@@ -785,7 +861,7 @@ static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
 static void blkio_update_blkg_policy(struct blkio_cgroup *blkcg,
 		struct blkio_group *blkg, struct blkio_policy_node *pn)
 {
-	unsigned int weight;
+	unsigned int weight, iops;
 	u64 bps;
 
 	switch(pn->plid) {
@@ -801,6 +877,11 @@ static void blkio_update_blkg_policy(struct blkio_cgroup *blkcg,
 			bps = pn->val.bps ? pn->val.bps : (-1);
 			blkio_update_group_bps(blkg, bps, pn->fileid);
 			break;
+		case BLKIO_THROTL_read_iops_device:
+		case BLKIO_THROTL_write_iops_device:
+			iops = pn->val.iops ? pn->val.iops : (-1);
+			blkio_update_group_iops(blkg, iops, pn->fileid);
+			break;
 		}
 		break;
 	default:
@@ -900,14 +981,18 @@ blkio_print_policy_node(struct seq_file *m, struct blkio_policy_node *pn)
 					MINOR(pn->dev), pn->val.weight);
 			break;
 		case BLKIO_POLICY_THROTL:
-			if (pn->fileid == BLKIO_THROTL_read_bps_device)
+			switch(pn->fileid) {
+			case BLKIO_THROTL_read_bps_device:
+			case BLKIO_THROTL_write_bps_device:
 				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
 					MINOR(pn->dev), pn->val.bps);
-			else if (pn->fileid == BLKIO_THROTL_write_bps_device)
-				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.bps);
-			else
-				BUG();
+				break;
+			case BLKIO_THROTL_read_iops_device:
+			case BLKIO_THROTL_write_iops_device:
+				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
+					MINOR(pn->dev), pn->val.iops);
+				break;
+			}
 			break;
 		default:
 			BUG();
@@ -954,6 +1039,8 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 		switch(name){
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
+		case BLKIO_THROTL_read_iops_device:
+		case BLKIO_THROTL_write_iops_device:
 			blkio_read_policy_node_files(cft, blkcg, m);
 			return 0;
 		default:
@@ -1171,6 +1258,24 @@ struct cftype blkio_files[] = {
 		.write_string = blkiocg_file_write,
 		.max_write_len = 256,
 	},
+
+	{
+		.name = "throttle.read_iops_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_read_iops_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+
+	{
+		.name = "throttle.write_iops_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_write_iops_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
 	{
 		.name = "time",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1b73882..2070053 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -93,6 +93,8 @@ enum blkcg_file_name_prop {
 enum blkcg_file_name_throtl {
 	BLKIO_THROTL_read_bps_device,
 	BLKIO_THROTL_write_bps_device,
+	BLKIO_THROTL_read_iops_device,
+	BLKIO_THROTL_write_iops_device,
 	BLKIO_THROTL_io_service_bytes,
 	BLKIO_THROTL_io_serviced,
 };
@@ -168,6 +170,7 @@ struct blkio_policy_node {
 		 * by file type "fileid".
 		 */
 		u64 bps;
+		unsigned int iops;
 	} val;
 };
 
@@ -177,6 +180,10 @@ extern uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg,
 				     dev_t dev);
 extern uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg,
 				     dev_t dev);
+extern unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg,
+				     dev_t dev);
+extern unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg,
+				     dev_t dev);
 
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
@@ -185,12 +192,18 @@ typedef void (blkio_update_group_read_bps_fn) (struct blkio_group *blkg,
 						u64 read_bps);
 typedef void (blkio_update_group_write_bps_fn) (struct blkio_group *blkg,
 						u64 write_bps);
+typedef void (blkio_update_group_read_iops_fn) (struct blkio_group *blkg,
+						unsigned int read_iops);
+typedef void (blkio_update_group_write_iops_fn) (struct blkio_group *blkg,
+						unsigned int write_iops);
 
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
 	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
 	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
+	blkio_update_group_read_iops_fn *blkio_update_group_read_iops_fn;
+	blkio_update_group_write_iops_fn *blkio_update_group_write_iops_fn;
 };
 
 struct blkio_policy_type {
-- 
1.7.2.3

