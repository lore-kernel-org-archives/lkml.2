Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0CYSFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:05:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab0CYSFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:05:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=baDTX/EEvunN8Qn3mzWSRCLuiWzLvUNuW+r+aT8lDVaAGNJ1qMaCbmp5MFe02V2Uy
	GHXuJDkpzAKoOcO+7XM9w==
Subject: [PATCH 4/4] Use disk-names to set blkio.weight_device policy
To: vgoyal@redhat.com, jens.axboe@oracle.com
From: Chad Talbott <ctalbott@google.com>
Cc: mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Date: Thu, 25 Mar 2010 11:04:38 -0700
Message-ID: <20100325180438.25299.60030.stgit@meat.mtv.corp.google.com>
In-Reply-To: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch also cleans up a few fields and arguments that are no
longer used once request_queue is the key for both blkio_groups as
well as blkio_policy_nodes.
---
 block/blk-cgroup.c  |  103 ++++++++++++++-------------------------------------
 block/blk-cgroup.h  |    6 +--
 block/cfq-iosched.c |    9 +---
 3 files changed, 35 insertions(+), 83 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bf77b99..086a00d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -28,7 +28,7 @@ static inline void policy_insert_node(struct blkio_cgroup *blkcg,
 				      struct blkio_policy_node *pn);
 static inline void policy_delete_node(struct blkio_policy_node *pn);
 static struct blkio_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
-						 dev_t dev);
+						 struct request_queue *queue);
 
 
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
@@ -72,7 +72,7 @@ void blkiocg_update_blkio_group_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_stats);
 
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, struct request_queue *queue, dev_t dev)
+			struct blkio_group *blkg, struct request_queue *queue)
 {
 	unsigned long flags;
 
@@ -85,7 +85,6 @@ void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 	/* Need to take css reference ? */
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
 #endif
-	blkg->dev = dev;
 }
 EXPORT_SYMBOL_GPL(blkiocg_add_blkio_group);
 
@@ -172,7 +171,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	blkcg->weight = (unsigned int)val;
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		pn = policy_search_node(blkcg, blkg->dev);
+		pn = policy_search_node(blkcg, blkg->queue);
 
 		if (pn)
 			continue;
@@ -227,87 +226,39 @@ void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
 #endif
 
-static int check_dev_num(dev_t dev)
+static int policy_parse_and_set(char *buf, struct blkio_policy_node *newpn)
 {
+	char disk_name[BDEVNAME_SIZE];
+	int weight;
+	int nfields;
 	int part = 0;
 	struct gendisk *disk;
-
-	disk = get_gendisk(dev, &part);
-	if (!disk || part)
-		return -ENODEV;
-
-	return 0;
-}
-
-static int policy_parse_and_set(char *buf, struct blkio_policy_node *newpn)
-{
-	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
-	int ret;
-	unsigned long major, minor, temp;
-	int i = 0;
 	dev_t dev;
 
-	memset(s, 0, sizeof(s));
-
-	while ((p = strsep(&buf, " ")) != NULL) {
-		if (!*p)
-			continue;
-
-		s[i++] = p;
-
-		/* Prevent from inputing too many things */
-		if (i == 3)
-			break;
-	}
-
-	if (i != 2)
+	nfields = sscanf(buf, "%s %d", disk_name, &weight);
+	if (nfields != 2)
 		return -EINVAL;
 
-	p = strsep(&s[0], ":");
-	if (p != NULL)
-		major_s = p;
-	else
-		return -EINVAL;
-
-	minor_s = s[0];
-	if (!minor_s)
-		return -EINVAL;
-
-	ret = strict_strtoul(major_s, 10, &major);
-	if (ret)
-		return -EINVAL;
-
-	ret = strict_strtoul(minor_s, 10, &minor);
-	if (ret)
-		return -EINVAL;
-
-	dev = MKDEV(major, minor);
-
-	ret = check_dev_num(dev);
-	if (ret)
-		return ret;
-
-	newpn->dev = dev;
-
-	if (s[1] == NULL)
-		return -EINVAL;
+	dev = blk_lookup_devt(disk_name, 0);
+	if (!dev)
+		return -ENODEV;
 
-	ret = strict_strtoul(s[1], 10, &temp);
-	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
-	    temp > BLKIO_WEIGHT_MAX)
-		return -EINVAL;
+	disk = get_gendisk(dev, &part);
+	if (!disk || part)
+		return -ENODEV;
 
-	newpn->weight =  temp;
+	newpn->weight = weight;
+	newpn->queue = disk->queue;
 
 	return 0;
 }
 
 unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
-				    dev_t dev)
+				    struct request_queue *queue)
 {
 	struct blkio_policy_node *pn;
 
-	pn = policy_search_node(blkcg, dev);
+	pn = policy_search_node(blkcg, queue);
 	if (pn)
 		return pn->weight;
 	else
@@ -329,12 +280,12 @@ static inline void policy_delete_node(struct blkio_policy_node *pn)
 
 /* Must be called with blkcg->lock held */
 static struct blkio_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
-						 dev_t dev)
+						 struct request_queue *queue)
 {
 	struct blkio_policy_node *pn;
 
 	list_for_each_entry(pn, &blkcg->policy_list, node) {
-		if (pn->dev == dev)
+		if (pn->queue == queue)
 			return pn;
 	}
 
@@ -372,7 +323,7 @@ static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
 
 	spin_lock_irq(&blkcg->lock);
 
-	pn = policy_search_node(blkcg, newpn->dev);
+	pn = policy_search_node(blkcg, newpn->queue);
 	if (!pn) {
 		if (newpn->weight != 0) {
 			policy_insert_node(blkcg, newpn);
@@ -398,7 +349,7 @@ update_io_group:
 	spin_lock_irq(&blkcg->lock);
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		if (newpn->dev == blkg->dev) {
+		if (newpn->queue == blkg->queue) {
 			list_for_each_entry(blkiop, &blkio_list, list)
 				blkiop->ops.blkio_update_group_weight_fn(blkg,
 						newpn->weight ?
@@ -423,6 +374,7 @@ static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
 {
 	struct blkio_cgroup *blkcg;
 	struct blkio_policy_node *pn;
+	struct gendisk *disk;
 
 	seq_printf(m, "dev\tweight\n");
 
@@ -430,12 +382,15 @@ static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
 	if (list_empty(&blkcg->policy_list))
 		goto out;
 
+	rcu_read_lock();
 	spin_lock_irq(&blkcg->lock);
 	list_for_each_entry(pn, &blkcg->policy_list, node) {
-		seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
-			   MINOR(pn->dev), pn->weight);
+		disk = rcu_dereference(pn->queue->disk);
+		if (disk != NULL)
+			seq_printf(m, "%s\t%u\n", disk->disk_name, pn->weight);
 	}
 	spin_unlock_irq(&blkcg->lock);
+	rcu_read_unlock();
 out:
 	return 0;
 }
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 92296b8..14177b5 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -53,12 +53,12 @@ struct blkio_group {
 
 struct blkio_policy_node {
 	struct list_head node;
-	dev_t dev;
+	struct request_queue *queue;
 	unsigned int weight;
 };
 
 extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
-				     dev_t dev);
+				     struct request_queue *queue);
 
 typedef void (blkio_unlink_group_fn) (struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
@@ -112,7 +112,7 @@ static inline void blkiocg_update_blkio_group_dequeue_stats(
 extern struct blkio_cgroup blkio_root_cgroup;
 extern struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup);
 extern void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-			struct blkio_group *blkg, struct request_queue *queue, dev_t dev);
+			struct blkio_group *blkg, struct request_queue *queue);
 extern int blkiocg_del_blkio_group(struct blkio_group *blkg);
 extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 						struct request_queue *queue);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d4d57a3..39d2048 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -944,7 +944,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	int i, j;
 	struct cfq_rb_root *st;
 	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
-	unsigned int major, minor;
 
 	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, queue));
 	if (cfqg || !create)
@@ -967,10 +966,8 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	atomic_set(&cfqg->ref, 1);
 
 	/* Add group onto cgroup list */
-	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, cfqd->queue,
-					MKDEV(major, minor));
-	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
+	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, cfqd->queue);
+	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.queue);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
@@ -3671,7 +3668,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 * to make sure that cfq_put_cfqg() does not try to kfree root group
 	 */
 	atomic_set(&cfqg->ref, 1);
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, q, 0);
+	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, q);
 #endif
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we

