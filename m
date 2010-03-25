Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab0CYSFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:05:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab0CYSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:05:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=JZB3D/bJ3ry14xHC5SXSCQESs+0DUfbwbZgX2+ge8EGOhByS2cz5l36whZq2uS19V
	3MFEuyHlUkQD1rsI0P4og==
Subject: [PATCH 3/4] io-controller: Add a new interface "weight_device" for
	IO-Controller
To: vgoyal@redhat.com, jens.axboe@oracle.com
From: Chad Talbott <ctalbott@google.com>
Cc: mrubin@google.com, guijianfeng@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dpshah@google.com, Nauman Rafique <nauman@google.com>
Date: Thu, 25 Mar 2010 11:04:33 -0700
Message-ID: <20100325180433.25299.44167.stgit@meat.mtv.corp.google.com>
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

This is Gui Jianfeng's original patch.
---
 block/blk-cgroup.c  |  240 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h  |   10 ++
 block/cfq-iosched.c |    2 
 3 files changed, 251 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 809451f..bf77b99 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -24,6 +24,13 @@ static LIST_HEAD(blkio_list);
 struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
 EXPORT_SYMBOL_GPL(blkio_root_cgroup);
 
+static inline void policy_insert_node(struct blkio_cgroup *blkcg,
+				      struct blkio_policy_node *pn);
+static inline void policy_delete_node(struct blkio_policy_node *pn);
+static struct blkio_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
+						 dev_t dev);
+
+
 static struct cgroup_subsys_state *blkiocg_create(struct cgroup_subsys *,
 						  struct cgroup *);
 static int blkiocg_can_attach(struct cgroup_subsys *, struct cgroup *,
@@ -154,6 +161,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	struct blkio_group *blkg;
 	struct hlist_node *n;
 	struct blkio_policy_type *blkiop;
+	struct blkio_policy_node *pn;
 
 	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
 		return -EINVAL;
@@ -162,7 +170,13 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	spin_lock(&blkio_list_lock);
 	spin_lock_irq(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
+
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		pn = policy_search_node(blkcg, blkg->dev);
+
+		if (pn)
+			continue;
+
 		list_for_each_entry(blkiop, &blkio_list, list)
 			blkiop->ops.blkio_update_group_weight_fn(blkg,
 					blkcg->weight);
@@ -213,8 +227,227 @@ void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
 #endif
 
+static int check_dev_num(dev_t dev)
+{
+	int part = 0;
+	struct gendisk *disk;
+
+	disk = get_gendisk(dev, &part);
+	if (!disk || part)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int policy_parse_and_set(char *buf, struct blkio_policy_node *newpn)
+{
+	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
+	int ret;
+	unsigned long major, minor, temp;
+	int i = 0;
+	dev_t dev;
+
+	memset(s, 0, sizeof(s));
+
+	while ((p = strsep(&buf, " ")) != NULL) {
+		if (!*p)
+			continue;
+
+		s[i++] = p;
+
+		/* Prevent from inputing too many things */
+		if (i == 3)
+			break;
+	}
+
+	if (i != 2)
+		return -EINVAL;
+
+	p = strsep(&s[0], ":");
+	if (p != NULL)
+		major_s = p;
+	else
+		return -EINVAL;
+
+	minor_s = s[0];
+	if (!minor_s)
+		return -EINVAL;
+
+	ret = strict_strtoul(major_s, 10, &major);
+	if (ret)
+		return -EINVAL;
+
+	ret = strict_strtoul(minor_s, 10, &minor);
+	if (ret)
+		return -EINVAL;
+
+	dev = MKDEV(major, minor);
+
+	ret = check_dev_num(dev);
+	if (ret)
+		return ret;
+
+	newpn->dev = dev;
+
+	if (s[1] == NULL)
+		return -EINVAL;
+
+	ret = strict_strtoul(s[1], 10, &temp);
+	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
+	    temp > BLKIO_WEIGHT_MAX)
+		return -EINVAL;
+
+	newpn->weight =  temp;
+
+	return 0;
+}
+
+unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
+				    dev_t dev)
+{
+	struct blkio_policy_node *pn;
+
+	pn = policy_search_node(blkcg, dev);
+	if (pn)
+		return pn->weight;
+	else
+		return blkcg->weight;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_weight);
+
+static inline void policy_insert_node(struct blkio_cgroup *blkcg,
+				      struct blkio_policy_node *pn)
+{
+	list_add(&pn->node, &blkcg->policy_list);
+}
+
+/* Must be called with blkcg->lock held */
+static inline void policy_delete_node(struct blkio_policy_node *pn)
+{
+	list_del(&pn->node);
+}
+
+/* Must be called with blkcg->lock held */
+static struct blkio_policy_node *policy_search_node(const struct blkio_cgroup *blkcg,
+						 dev_t dev)
+{
+	struct blkio_policy_node *pn;
+
+	list_for_each_entry(pn, &blkcg->policy_list, node) {
+		if (pn->dev == dev)
+			return pn;
+	}
+
+	return NULL;
+}
+
+
+static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
+				const char *buffer)
+{
+	int ret = 0;
+	char *buf;
+	struct blkio_policy_node *newpn, *pn;
+	struct blkio_cgroup *blkcg;
+	struct blkio_group *blkg;
+	int keep_newpn = 0;
+	struct hlist_node *n;
+	struct blkio_policy_type *blkiop;
+
+	buf = kstrdup(buffer, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	newpn = kzalloc(sizeof(*newpn), GFP_KERNEL);
+	if (!newpn) {
+		ret = -ENOMEM;
+		goto free_buf;
+	}
+
+	ret = policy_parse_and_set(buf, newpn);
+	if (ret)
+		goto free_newpn;
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	spin_lock_irq(&blkcg->lock);
+
+	pn = policy_search_node(blkcg, newpn->dev);
+	if (!pn) {
+		if (newpn->weight != 0) {
+			policy_insert_node(blkcg, newpn);
+			keep_newpn = 1;
+		}
+		spin_unlock_irq(&blkcg->lock);
+		goto update_io_group;
+	}
+
+	if (newpn->weight == 0) {
+		/* weight == 0 means deleteing a specific weight */
+		policy_delete_node(pn);
+		spin_unlock_irq(&blkcg->lock);
+		goto update_io_group;
+	}
+	spin_unlock_irq(&blkcg->lock);
+
+	pn->weight = newpn->weight;
+
+update_io_group:
+	/* update weight for each cfqg */
+	spin_lock(&blkio_list_lock);
+	spin_lock_irq(&blkcg->lock);
+
+	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		if (newpn->dev == blkg->dev) {
+			list_for_each_entry(blkiop, &blkio_list, list)
+				blkiop->ops.blkio_update_group_weight_fn(blkg,
+						newpn->weight ?
+						newpn->weight :
+						blkcg->weight);
+		}
+	}
+
+	spin_unlock_irq(&blkcg->lock);
+	spin_unlock(&blkio_list_lock);
+
+free_newpn:
+	if (!keep_newpn)
+		kfree(newpn);
+free_buf:
+	kfree(buf);
+	return ret;
+}
+
+static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
+				       struct seq_file *m)
+{
+	struct blkio_cgroup *blkcg;
+	struct blkio_policy_node *pn;
+
+	seq_printf(m, "dev\tweight\n");
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+	if (list_empty(&blkcg->policy_list))
+		goto out;
+
+	spin_lock_irq(&blkcg->lock);
+	list_for_each_entry(pn, &blkcg->policy_list, node) {
+		seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
+			   MINOR(pn->dev), pn->weight);
+	}
+	spin_unlock_irq(&blkcg->lock);
+out:
+	return 0;
+}
+
 struct cftype blkio_files[] = {
 	{
+		.name = "weight_device",
+		.read_seq_string = blkiocg_weight_device_read,
+		.write_string = blkiocg_weight_device_write,
+		.max_write_len = 256,
+	},
+	{
 		.name = "weight",
 		.read_u64 = blkiocg_weight_read,
 		.write_u64 = blkiocg_weight_write,
@@ -247,6 +480,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 	unsigned long flags;
 	struct blkio_group *blkg;
 	struct blkio_policy_type *blkiop;
+	struct blkio_policy_node *pn, *pntmp;
 
 	rcu_read_lock();
 remove_entry:
@@ -276,7 +510,12 @@ remove_entry:
 		blkiop->ops.blkio_unlink_group_fn(blkg);
 	spin_unlock(&blkio_list_lock);
 	goto remove_entry;
+
 done:
+	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
+		policy_delete_node(pn);
+		kfree(pn);
+	}
 	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
 	if (blkcg != &blkio_root_cgroup)
@@ -307,6 +546,7 @@ done:
 	spin_lock_init(&blkcg->lock);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 
+	INIT_LIST_HEAD(&blkcg->policy_list);
 	return &blkcg->css;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 9e70c03..92296b8 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -29,6 +29,7 @@ struct blkio_cgroup {
 	unsigned int weight;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
+	struct list_head policy_list; /* list of blkio_policy_node */
 };
 
 struct blkio_group {
@@ -50,6 +51,15 @@ struct blkio_group {
 	unsigned long sectors;
 };
 
+struct blkio_policy_node {
+	struct list_head node;
+	dev_t dev;
+	unsigned int weight;
+};
+
+extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
+				     dev_t dev);
+
 typedef void (blkio_unlink_group_fn) (struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
 						unsigned int weight);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 864b39a..d4d57a3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -954,7 +954,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	if (!cfqg)
 		goto done;
 
-	cfqg->weight = blkcg->weight;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
@@ -971,6 +970,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, cfqd->queue,
 					MKDEV(major, minor));
+	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);

