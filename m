Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0LERuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0LERuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ueh5VPBxKiW9VHpkdK7rOOYV9p1jbtN36EieS1Prv26gSEzDTa/tND+vBzf1hICFpn
         UDJMwvopHIMKnvDr1D1pxqKSvxaPNJAgrXIJxlqWiCqHBDtSjOtiw1wLq1uG0FJHU2sK
         DihdnniTEPu1eIunJrUDFC7FQAgnLne60DwH4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 06/45] kstrtox: convert mm/
Date: Sun,  5 Dec 2010 19:49:03 +0200
Message-Id: <1291571382-2719-6-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mm/vmscan.c:
make "scan_unevictable_pages" write-only.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/slub_def.h |    2 +-
 mm/hugetlb.c             |   12 ++++++------
 mm/kmemleak.c            |    4 ++--
 mm/ksm.c                 |   28 ++++++++++------------------
 mm/slub.c                |   19 ++++++++++---------
 mm/vmscan.c              |   25 ++++++++++---------------
 6 files changed, 39 insertions(+), 51 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index e4f5ed1..37f439d 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -95,7 +95,7 @@ struct kmem_cache {
 	/*
 	 * Defragmentation by allocating from a remote node.
 	 */
-	int remote_node_defrag_ratio;
+	unsigned int remote_node_defrag_ratio;
 #endif
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8585524..a9a5460 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1438,9 +1438,9 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
-	err = strict_strtoul(buf, 10, &count);
-	if (err)
-		return 0;
+	err = kstrtoul(buf, 10, &count);
+	if (err < 0)
+		return err;
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (nid == NUMA_NO_NODE) {
@@ -1517,9 +1517,9 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 	unsigned long input;
 	struct hstate *h = kobj_to_hstate(kobj, NULL);
 
-	err = strict_strtoul(buf, 10, &input);
-	if (err)
-		return 0;
+	err = kstrtoul(buf, 10, &input);
+	if (err < 0)
+		return err;
 
 	spin_lock(&hugetlb_lock);
 	h->nr_overcommit_huge_pages = input;
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index bd9bc21..b3fb3f5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1557,9 +1557,9 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
 	else if (strncmp(buf, "scan=off", 8) == 0)
 		stop_scan_thread();
 	else if (strncmp(buf, "scan=", 5) == 0) {
-		unsigned long secs;
+		unsigned int secs;
 
-		ret = strict_strtoul(buf + 5, 0, &secs);
+		ret = kstrtouint(buf + 5, 0, &secs);
 		if (ret < 0)
 			goto out;
 		stop_scan_thread();
diff --git a/mm/ksm.c b/mm/ksm.c
index 43bc893..c03345b 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1773,15 +1773,11 @@ static ssize_t sleep_millisecs_store(struct kobject *kobj,
 				     struct kobj_attribute *attr,
 				     const char *buf, size_t count)
 {
-	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
-		return -EINVAL;
-
-	ksm_thread_sleep_millisecs = msecs;
-
+	err = kstrtouint(buf, 10, &ksm_thread_sleep_millisecs);
+	if (err < 0)
+		return err;
 	return count;
 }
 KSM_ATTR(sleep_millisecs);
@@ -1797,14 +1793,10 @@ static ssize_t pages_to_scan_store(struct kobject *kobj,
 				   const char *buf, size_t count)
 {
 	int err;
-	unsigned long nr_pages;
-
-	err = strict_strtoul(buf, 10, &nr_pages);
-	if (err || nr_pages > UINT_MAX)
-		return -EINVAL;
-
-	ksm_thread_pages_to_scan = nr_pages;
 
+	err = kstrtouint(buf, 10, &ksm_thread_pages_to_scan);
+	if (err < 0)
+		return err;
 	return count;
 }
 KSM_ATTR(pages_to_scan);
@@ -1819,11 +1811,11 @@ static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count)
 {
 	int err;
-	unsigned long flags;
+	unsigned int flags;
 
-	err = strict_strtoul(buf, 10, &flags);
-	if (err || flags > UINT_MAX)
-		return -EINVAL;
+	err = kstrtouint(buf, 10, &flags);
+	if (err < 0)
+		return err;
 	if (flags > KSM_RUN_UNMERGE)
 		return -EINVAL;
 
diff --git a/mm/slub.c b/mm/slub.c
index 981fb73..3170e52 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3928,11 +3928,11 @@ SLAB_ATTR_RO(objs_per_slab);
 static ssize_t order_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	unsigned long order;
+	int order;
 	int err;
 
-	err = strict_strtoul(buf, 10, &order);
-	if (err)
+	err = kstrtoint(buf, 10, &order);
+	if (err < 0)
 		return err;
 
 	if (order > slub_max_order || order < slub_min_order)
@@ -3959,7 +3959,7 @@ static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
 	unsigned long min;
 	int err;
 
-	err = strict_strtoul(buf, 10, &min);
+	err = kstrtoul(buf, 10, &min);
 	if (err)
 		return err;
 
@@ -4219,21 +4219,22 @@ SLAB_ATTR(shrink);
 #ifdef CONFIG_NUMA
 static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->remote_node_defrag_ratio / 10);
+	return sprintf(buf, "%u\n", s->remote_node_defrag_ratio / 10);
 }
 
 static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
 				const char *buf, size_t length)
 {
-	unsigned long ratio;
+	unsigned int ratio;
 	int err;
 
-	err = strict_strtoul(buf, 10, &ratio);
+	err = kstrtouint(buf, 10, &ratio);
 	if (err)
 		return err;
+	if (ratio > 100)
+		return -EINVAL;
 
-	if (ratio <= 100)
-		s->remote_node_defrag_ratio = ratio * 10;
+	s->remote_node_defrag_ratio = ratio * 10;
 
 	return length;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d31d7ce..61acce3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3055,37 +3055,32 @@ int scan_unevictable_handler(struct ctl_table *table, int write,
  * per node 'scan_unevictable_pages' attribute.  On demand re-scan of
  * a specified node's per zone unevictable lists for evictable pages.
  */
-
-static ssize_t read_scan_unevictable_node(struct sys_device *dev,
-					  struct sysdev_attribute *attr,
-					  char *buf)
-{
-	return sprintf(buf, "0\n");	/* always zero; should fit... */
-}
-
 static ssize_t write_scan_unevictable_node(struct sys_device *dev,
 					   struct sysdev_attribute *attr,
 					const char *buf, size_t count)
 {
 	struct zone *node_zones = NODE_DATA(dev->id)->node_zones;
 	struct zone *zone;
-	unsigned long res;
-	unsigned long req = strict_strtoul(buf, 10, &res);
+	unsigned long val;
+	int rv;
 
-	if (!req)
-		return 1;	/* zero is no-op */
+	rv = kstrtoul(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val == 0)
+		return count;
 
 	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
 		if (!populated_zone(zone))
 			continue;
 		scan_zone_unevictable_pages(zone);
 	}
-	return 1;
+	return count;
 }
 
 
-static SYSDEV_ATTR(scan_unevictable_pages, S_IRUGO | S_IWUSR,
-			read_scan_unevictable_node,
+static SYSDEV_ATTR(scan_unevictable_pages, S_IWUSR,
+			NULL,
 			write_scan_unevictable_node);
 
 int scan_unevictable_register_node(struct node *node)
-- 
1.7.2.2

