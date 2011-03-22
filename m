Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1CVBLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:11:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1CVBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:10:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=SHevpLAtl3tjcL1bcoBLcA43ZwjqjNWCND0gFRvNbtx+lSEwTXcgF2B910SmzVG4z
	2OFzB7iSOpX75YaMrfpDg==
From: Chad Talbott <ctalbott@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com,
        Chad Talbott <ctalbott@google.com>
Subject: [PATCH 1/3] cfq-iosched: Fair cross-group preemption (interface and documentation)
Date: Mon, 21 Mar 2011 18:10:43 -0700
Message-Id: <1300756245-12380-2-git-send-email-ctalbott@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300756245-12380-1-git-send-email-ctalbott@google.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkio.class is a new interface that allows you to specify a cgroup as
requiring low-latency service on a specific block device.  This patch
includes only the interface and documentation.

Signed-off-by: Chad Talbott <ctalbott@google.com>
---
 Documentation/cgroups/blkio-controller.txt |   16 ++++
 block/blk-cgroup.c                         |  121 +++++++++++++++++++++-------
 block/blk-cgroup.h                         |   36 +++++++--
 block/cfq-iosched.c                        |   12 +++-
 4 files changed, 145 insertions(+), 40 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 4ed7b5c..7acf9d2 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -169,6 +169,22 @@ Proportional weight policy files
 	  dev     weight
 	  8:16    300
 
+- blkio.class
+	- Specifies the per-cgroup, per-device service class.  There
+	  are currently two service classes: real-time (1) and
+	  best-effort (2).  By default, all groups start as
+	  best-effort.
+
+	  #echo dev_maj:dev_minor class > /path/to/cgroup/blkio.class
+	  Configure class=real-time on /dev/sdb (8:16) in this cgroup
+	  # echo '8:16 1' > blkio.class
+	  # cat blkio.class
+	  8:16    1
+
+	  A real-time group can preempt a best-effort group, only as
+	  long as it's within its assigned weight; i.e. fairness is
+	  preserved.
+
 - blkio.time
 	- disk time allocated to cgroup per device in milliseconds. First
 	  two fields specify the major and minor number of the device and
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 455768a..f2c553e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -129,6 +129,21 @@ blkio_update_group_weight(struct blkio_group *blkg, unsigned int weight)
 	}
 }
 
+static inline void
+blkio_update_group_class(struct blkio_group *blkg, unsigned int class)
+{
+	struct blkio_policy_type *blkiop;
+
+	list_for_each_entry(blkiop, &blkio_list, list) {
+		/* If this policy does not own the blkg, do not send updates */
+		if (blkiop->plid != blkg->plid)
+			continue;
+		if (blkiop->ops.blkio_update_group_class_fn)
+			blkiop->ops.blkio_update_group_class_fn(blkg->key,
+								blkg, class);
+	}
+}
+
 static inline void blkio_update_group_bps(struct blkio_group *blkg, u64 bps,
 				int fileid)
 {
@@ -708,15 +723,29 @@ static int blkio_policy_parse_and_set(char *buf,
 
 	switch (plid) {
 	case BLKIO_POLICY_PROP:
-		ret = strict_strtoul(s[1], 10, &temp);
-		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-			temp > BLKIO_WEIGHT_MAX)
-			return -EINVAL;
-
-		newpn->plid = plid;
-		newpn->fileid = fileid;
-		newpn->val.weight = temp;
-		break;
+		switch (fileid) {
+		case BLKIO_PROP_weight_device:
+			ret = strict_strtoul(s[1], 10, &temp);
+			if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+			    temp > BLKIO_WEIGHT_MAX)
+				return -EINVAL;
+
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.prop.weight = temp;
+			break;
+		case BLKIO_PROP_class:
+			ret = strict_strtoul(s[1], 10, &temp);
+			if (ret ||
+			    temp < BLKIO_RT_CLASS ||
+			    temp > BLKIO_BE_CLASS)
+				return -EINVAL;
+
+			newpn->plid = plid;
+			newpn->fileid = fileid;
+			newpn->val.prop.class = temp;
+			break;
+		}
 	case BLKIO_POLICY_THROTL:
 		switch(fileid) {
 		case BLKIO_THROTL_read_bps_device:
@@ -727,7 +756,7 @@ static int blkio_policy_parse_and_set(char *buf,
 
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.bps = bps;
+			newpn->val.throtl.bps = bps;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
@@ -740,7 +769,7 @@ static int blkio_policy_parse_and_set(char *buf,
 
 			newpn->plid = plid;
 			newpn->fileid = fileid;
-			newpn->val.iops = (unsigned int)iops;
+			newpn->val.throtl.iops = (unsigned int)iops;
 			break;
 		}
 		break;
@@ -759,20 +788,34 @@ unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
 				BLKIO_PROP_weight_device);
 	if (pn)
-		return pn->val.weight;
+		return pn->val.prop.weight;
 	else
 		return blkcg->weight;
 }
 EXPORT_SYMBOL_GPL(blkcg_get_weight);
 
-uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
+enum blkcg_class blkcg_get_class(struct blkio_cgroup *blkcg,
+			     dev_t dev)
 {
 	struct blkio_policy_node *pn;
+	enum blkcg_class class = BLKIO_DEFAULT_CLASS;
+
+	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_PROP,
+				BLKIO_PROP_class);
+	if (pn)
+		class = pn->val.prop.class;
 
+	return class;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_class);
+
+uint64_t blkcg_get_read_bps(struct blkio_cgroup *blkcg, dev_t dev)
+{
+	struct blkio_policy_node *pn;
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_read_bps_device);
 	if (pn)
-		return pn->val.bps;
+		return pn->val.throtl.bps;
 	else
 		return -1;
 }
@@ -783,7 +826,7 @@ uint64_t blkcg_get_write_bps(struct blkio_cgroup *blkcg, dev_t dev)
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_write_bps_device);
 	if (pn)
-		return pn->val.bps;
+		return pn->val.throtl.bps;
 	else
 		return -1;
 }
@@ -795,7 +838,7 @@ unsigned int blkcg_get_read_iops(struct blkio_cgroup *blkcg, dev_t dev)
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_read_iops_device);
 	if (pn)
-		return pn->val.iops;
+		return pn->val.throtl.iops;
 	else
 		return -1;
 }
@@ -806,7 +849,7 @@ unsigned int blkcg_get_write_iops(struct blkio_cgroup *blkcg, dev_t dev)
 	pn = blkio_policy_search_node(blkcg, dev, BLKIO_POLICY_THROTL,
 				BLKIO_THROTL_write_iops_device);
 	if (pn)
-		return pn->val.iops;
+		return pn->val.throtl.iops;
 	else
 		return -1;
 }
@@ -816,19 +859,19 @@ static bool blkio_delete_rule_command(struct blkio_policy_node *pn)
 {
 	switch(pn->plid) {
 	case BLKIO_POLICY_PROP:
-		if (pn->val.weight == 0)
+		if (pn->val.prop.weight == 0)
 			return 1;
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(pn->fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			if (pn->val.bps == 0)
+			if (pn->val.throtl.bps == 0)
 				return 1;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			if (pn->val.iops == 0)
+			if (pn->val.throtl.iops == 0)
 				return 1;
 		}
 		break;
@@ -844,17 +887,17 @@ static void blkio_update_policy_rule(struct blkio_policy_node *oldpn,
 {
 	switch(oldpn->plid) {
 	case BLKIO_POLICY_PROP:
-		oldpn->val.weight = newpn->val.weight;
+		oldpn->val.prop.weight = newpn->val.prop.weight;
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(newpn->fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			oldpn->val.bps = newpn->val.bps;
+			oldpn->val.throtl.bps = newpn->val.throtl.bps;
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			oldpn->val.iops = newpn->val.iops;
+			oldpn->val.throtl.iops = newpn->val.throtl.iops;
 		}
 		break;
 	default:
@@ -872,22 +915,24 @@ static void blkio_update_blkg_policy(struct blkio_cgroup *blkcg,
 	unsigned int weight, iops;
 	u64 bps;
 
+
 	switch(pn->plid) {
 	case BLKIO_POLICY_PROP:
-		weight = pn->val.weight ? pn->val.weight :
+		weight = pn->val.prop.weight ? pn->val.prop.weight :
 				blkcg->weight;
 		blkio_update_group_weight(blkg, weight);
+		blkio_update_group_class(blkg, pn->val.prop.class);
 		break;
 	case BLKIO_POLICY_THROTL:
 		switch(pn->fileid) {
 		case BLKIO_THROTL_read_bps_device:
 		case BLKIO_THROTL_write_bps_device:
-			bps = pn->val.bps ? pn->val.bps : (-1);
+			bps = pn->val.throtl.bps ? pn->val.throtl.bps : (-1);
 			blkio_update_group_bps(blkg, bps, pn->fileid);
 			break;
 		case BLKIO_THROTL_read_iops_device:
 		case BLKIO_THROTL_write_iops_device:
-			iops = pn->val.iops ? pn->val.iops : (-1);
+			iops = pn->val.throtl.iops ? pn->val.throtl.iops : (-1);
 			blkio_update_group_iops(blkg, iops, pn->fileid);
 			break;
 		}
@@ -984,21 +1029,28 @@ blkio_print_policy_node(struct seq_file *m, struct blkio_policy_node *pn)
 {
 	switch(pn->plid) {
 		case BLKIO_POLICY_PROP:
-			if (pn->fileid == BLKIO_PROP_weight_device)
+			switch(pn->fileid) {
+			case BLKIO_PROP_weight_device:
+				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
+					   MINOR(pn->dev), pn->val.prop.weight);
+				break;
+			case BLKIO_PROP_class:
 				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.weight);
+					   MINOR(pn->dev), pn->val.prop.class);
+				break;
+			};
 			break;
 		case BLKIO_POLICY_THROTL:
 			switch(pn->fileid) {
 			case BLKIO_THROTL_read_bps_device:
 			case BLKIO_THROTL_write_bps_device:
 				seq_printf(m, "%u:%u\t%llu\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.bps);
+					   MINOR(pn->dev), pn->val.throtl.bps);
 				break;
 			case BLKIO_THROTL_read_iops_device:
 			case BLKIO_THROTL_write_iops_device:
 				seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-					MINOR(pn->dev), pn->val.iops);
+					   MINOR(pn->dev), pn->val.throtl.iops);
 				break;
 			}
 			break;
@@ -1037,6 +1089,7 @@ static int blkiocg_file_read(struct cgroup *cgrp, struct cftype *cft,
 	case BLKIO_POLICY_PROP:
 		switch(name) {
 		case BLKIO_PROP_weight_device:
+		case BLKIO_PROP_class:
 			blkio_read_policy_node_files(cft, blkcg, m);
 			return 0;
 		default:
@@ -1243,6 +1296,14 @@ struct cftype blkio_files[] = {
 		.max_write_len = 256,
 	},
 	{
+		.name = "class",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_class),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+	{
 		.name = "weight",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_weight),
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index ea4861b..0e9cd32 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -73,10 +73,18 @@ enum blkg_state_flags {
 	BLKG_empty,
 };
 
+enum blkcg_class {
+	BLKIO_RT_CLASS = 1,
+	BLKIO_BE_CLASS = 2,
+};
+
+#define BLKIO_DEFAULT_CLASS BLKIO_BE_CLASS
+
 /* cgroup files owned by proportional weight policy */
 enum blkcg_file_name_prop {
 	BLKIO_PROP_weight = 1,
 	BLKIO_PROP_weight_device,
+	BLKIO_PROP_class,
 	BLKIO_PROP_io_service_bytes,
 	BLKIO_PROP_io_serviced,
 	BLKIO_PROP_time,
@@ -157,6 +165,21 @@ struct blkio_group {
 	struct blkio_group_stats stats;
 };
 
+struct proportion_policy {
+	unsigned int weight;
+	unsigned int class;
+};
+
+union throttle_policy {
+	/*
+	 * Rate read/write in terms of byptes per second
+	 * Whether this rate represents read or write is determined
+	 * by file type "fileid".
+	 */
+	u64 bps;
+	unsigned int iops;
+};
+
 struct blkio_policy_node {
 	struct list_head node;
 	dev_t dev;
@@ -166,14 +189,8 @@ struct blkio_policy_node {
 	int fileid;
 
 	union {
-		unsigned int weight;
-		/*
-		 * Rate read/write in terms of byptes per second
-		 * Whether this rate represents read or write is determined
-		 * by file type "fileid".
-		 */
-		u64 bps;
-		unsigned int iops;
+		struct proportion_policy prop;
+		union throttle_policy throtl;
 	} val;
 };
 
@@ -192,6 +209,8 @@ typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 
 typedef void (blkio_update_group_weight_fn) (void *key,
 			struct blkio_group *blkg, unsigned int weight);
+typedef void (blkio_update_group_class_fn) (void *key,
+			struct blkio_group *blkg, unsigned int class);
 typedef void (blkio_update_group_read_bps_fn) (void * key,
 			struct blkio_group *blkg, u64 read_bps);
 typedef void (blkio_update_group_write_bps_fn) (void *key,
@@ -204,6 +223,7 @@ typedef void (blkio_update_group_write_iops_fn) (void *key,
 struct blkio_policy_ops {
 	blkio_unlink_group_fn *blkio_unlink_group_fn;
 	blkio_update_group_weight_fn *blkio_update_group_weight_fn;
+	blkio_update_group_class_fn *blkio_update_group_class_fn;
 	blkio_update_group_read_bps_fn *blkio_update_group_read_bps_fn;
 	blkio_update_group_write_bps_fn *blkio_update_group_write_bps_fn;
 	blkio_update_group_read_iops_fn *blkio_update_group_read_iops_fn;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index ea83a4f..55e78b7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -179,6 +179,7 @@ struct cfq_group {
 	/* group service_tree key */
 	u64 vdisktime;
 	unsigned int weight;
+	enum blkcg_class class;
 
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
@@ -988,6 +989,12 @@ void cfq_update_blkio_group_weight(void *key, struct blkio_group *blkg,
 	cfqg_of_blkg(blkg)->weight = weight;
 }
 
+void cfq_update_blkio_group_class(void *key, struct blkio_group *blkg,
+					unsigned int class)
+{
+	cfqg_of_blkg(blkg)->class = class;
+}
+
 static struct cfq_group *
 cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 {
@@ -4115,8 +4122,9 @@ static struct elevator_type iosched_cfq = {
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkio_policy_type blkio_policy_cfq = {
 	.ops = {
-		.blkio_unlink_group_fn =	cfq_unlink_blkio_group,
-		.blkio_update_group_weight_fn =	cfq_update_blkio_group_weight,
+		.blkio_unlink_group_fn =	       cfq_unlink_blkio_group,
+		.blkio_update_group_weight_fn = cfq_update_blkio_group_weight,
+		.blkio_update_group_class_fn =  cfq_update_blkio_group_class,
 	},
 	.plid = BLKIO_POLICY_PROP,
 };
-- 
1.7.3.1

