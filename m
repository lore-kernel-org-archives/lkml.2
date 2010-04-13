Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0DMIGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:06:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0DMIGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:06:36 -0400
Message-ID: <4BC425DD.9040905@cn.fujitsu.com>
Date: Tue, 13 Apr 2010 16:05:49 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
CC: Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2 V3] [RESEND] io-controller: Add a new interface "weight_device"
 for IO-Controller
References: <4BC42475.8080605@cn.fujitsu.com>
In-Reply-To: <4BC42475.8080605@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, IO Controller makes use of blkio.weight to assign weight for
all devices. Here a new user interface "blkio.weight_device" is introduced to
assign different weights for different devices. blkio.weight becomes the
default value for devices which are not configured by "blkio.weight_device"

You can use the following format to assigned specific weight for a given
device:
#echo "major:minor weight" > blkio.weight_device

major:minor represents device number.

And you can remove weight for a given device as following:
#echo "major:minor 0" > blkio.weight_device

V1->V2 changes:
- use user interface "weight_device" instead of "policy" suggested by Vivek
- rename some struct suggested by Vivek
- rebase to 2.6-block "for-linus" branch
- remove an useless list_empty check pointed out by Li Zefan
- some trivial typo fix

V2->V3 changes:
- Move policy_*_node() functions up to get rid of forward declarations
- rename related functions by adding prefix "blkio_"

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c  |  236 +++++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h  |   10 ++
 block/cfq-iosched.c |    2 +-
 3 files changed, 247 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1ecff7a..649b05d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/blkdev.h>
 #include "blk-cgroup.h"
+#include <linux/genhd.h>
 
 #define MAX_KEY_LEN 100
 
@@ -51,6 +52,32 @@ struct cgroup_subsys blkio_subsys = {
 };
 EXPORT_SYMBOL_GPL(blkio_subsys);
 
+static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
+					    struct blkio_policy_node *pn)
+{
+	list_add(&pn->node, &blkcg->policy_list);
+}
+
+/* Must be called with blkcg->lock held */
+static inline void blkio_policy_delete_node(struct blkio_policy_node *pn)
+{
+	list_del(&pn->node);
+}
+
+/* Must be called with blkcg->lock held */
+static struct blkio_policy_node *
+blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev)
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
 struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
 {
 	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
@@ -398,6 +425,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	struct blkio_group *blkg;
 	struct hlist_node *n;
 	struct blkio_policy_type *blkiop;
+	struct blkio_policy_node *pn;
 
 	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
 		return -EINVAL;
@@ -406,7 +434,13 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
 	spin_lock(&blkio_list_lock);
 	spin_lock_irq(&blkcg->lock);
 	blkcg->weight = (unsigned int)val;
+
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
+		pn = blkio_policy_search_node(blkcg, blkg->dev);
+
+		if (pn)
+			continue;
+
 		list_for_each_entry(blkiop, &blkio_list, list)
 			blkiop->ops.blkio_update_group_weight_fn(blkg,
 					blkcg->weight);
@@ -611,8 +645,203 @@ void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
 #endif
 
+static int blkio_check_dev_num(dev_t dev)
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
+static int blkio_policy_parse_and_set(char *buf,
+				      struct blkio_policy_node *newpn)
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
+	ret = blkio_check_dev_num(dev);
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
+			      dev_t dev)
+{
+	struct blkio_policy_node *pn;
+
+	pn = blkio_policy_search_node(blkcg, dev);
+	if (pn)
+		return pn->weight;
+	else
+		return blkcg->weight;
+}
+EXPORT_SYMBOL_GPL(blkcg_get_weight);
+
+
+static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
+				       const char *buffer)
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
+	ret = blkio_policy_parse_and_set(buf, newpn);
+	if (ret)
+		goto free_newpn;
+
+	blkcg = cgroup_to_blkio_cgroup(cgrp);
+
+	spin_lock_irq(&blkcg->lock);
+
+	pn = blkio_policy_search_node(blkcg, newpn->dev);
+	if (!pn) {
+		if (newpn->weight != 0) {
+			blkio_policy_insert_node(blkcg, newpn);
+			keep_newpn = 1;
+		}
+		spin_unlock_irq(&blkcg->lock);
+		goto update_io_group;
+	}
+
+	if (newpn->weight == 0) {
+		/* weight == 0 means deleteing a specific weight */
+		blkio_policy_delete_node(pn);
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
+							 newpn->weight ?
+							 newpn->weight :
+							 blkcg->weight);
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
+				      struct seq_file *m)
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
+
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
@@ -690,6 +919,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
 	struct blkio_group *blkg;
 	void *key;
 	struct blkio_policy_type *blkiop;
+	struct blkio_policy_node *pn, *pntmp;
 
 	rcu_read_lock();
 remove_entry:
@@ -720,7 +950,12 @@ remove_entry:
 		blkiop->ops.blkio_unlink_group_fn(key, blkg);
 	spin_unlock(&blkio_list_lock);
 	goto remove_entry;
+
 done:
+	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
+		blkio_policy_delete_node(pn);
+		kfree(pn);
+	}
 	free_css_id(&blkio_subsys, &blkcg->css);
 	rcu_read_unlock();
 	if (blkcg != &blkio_root_cgroup)
@@ -751,6 +986,7 @@ done:
 	spin_lock_init(&blkcg->lock);
 	INIT_HLIST_HEAD(&blkcg->blkg_list);
 
+	INIT_LIST_HEAD(&blkcg->policy_list);
 	return &blkcg->css;
 }
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index bfce085..3c27bdf 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -70,6 +70,7 @@ struct blkio_cgroup {
 	unsigned int weight;
 	spinlock_t lock;
 	struct hlist_head blkg_list;
+	struct list_head policy_list; /* list of blkio_policy_node */
 };
 
 struct blkio_group_stats {
@@ -119,6 +120,15 @@ struct blkio_group {
 	struct blkio_group_stats stats;
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
 typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
 typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
 						unsigned int weight);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b6e095c..91af2f2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -952,7 +952,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	if (!cfqg)
 		goto done;
 
-	cfqg->weight = blkcg->weight;
 	for_each_cfqg_st(cfqg, i, j, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
@@ -970,6 +969,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
 	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					MKDEV(major, minor));
+	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
 	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
-- 
1.5.4.rc3



