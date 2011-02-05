Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1BEOVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1BEOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lIt++vMUb+Jdo4i3XHB1zyuNvnJeDBLnu8ObaVs+EOtmrBNWD6hy+7AvvYYwXlfbw7
         ZGXrGpCqb2sOj/PzyYnb+fZtmyyHDBagkxfYDuXMaQiXVhXjnptAmcn+Az5nvbwydVPX
         igfkuWRsCbF42ahhwDrBwm7M8wB+ClkCvV65o=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 04/52] kstrtox: convert mm/
Date: Sat,  5 Feb 2011 16:20:07 +0200
Message-Id: <1296915654-7458-4-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/slub_def.h |    2 +-
 mm/huge_memory.c         |   35 ++++++++++++++++-------------------
 mm/hugetlb.c             |    8 ++++----
 mm/kmemleak.c            |    4 ++--
 mm/ksm.c                 |   28 ++++++++++------------------
 mm/slub.c                |   19 ++++++++++---------
 mm/vmscan.c              |   25 ++++++++++---------------
 7 files changed, 53 insertions(+), 68 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 8b6e8ae..aa128b9 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -94,7 +94,7 @@ struct kmem_cache {
 	/*
 	 * Defragmentation by allocating from a remote node.
 	 */
-	int remote_node_defrag_ratio;
+	unsigned int remote_node_defrag_ratio;
 #endif
 	struct kmem_cache_node *node[MAX_NUMNODES];
 };
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b6c1ce3..665b8ff 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -331,14 +331,11 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
 					  struct kobj_attribute *attr,
 					  const char *buf, size_t count)
 {
-	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
-		return -EINVAL;
-
-	khugepaged_scan_sleep_millisecs = msecs;
+	err = kstrtouint(buf, 10, &khugepaged_scan_sleep_millisecs);
+	if (err < 0)
+		return err;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
@@ -358,14 +355,11 @@ static ssize_t alloc_sleep_millisecs_store(struct kobject *kobj,
 					   struct kobj_attribute *attr,
 					   const char *buf, size_t count)
 {
-	unsigned long msecs;
 	int err;
 
-	err = strict_strtoul(buf, 10, &msecs);
-	if (err || msecs > UINT_MAX)
-		return -EINVAL;
-
-	khugepaged_alloc_sleep_millisecs = msecs;
+	err = kstrtouint(buf, 10, &khugepaged_alloc_sleep_millisecs);
+	if (err < 0)
+		return err;
 	wake_up_interruptible(&khugepaged_wait);
 
 	return count;
@@ -384,13 +378,14 @@ static ssize_t pages_to_scan_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
 {
+	unsigned int pages;
 	int err;
-	unsigned long pages;
 
-	err = strict_strtoul(buf, 10, &pages);
-	if (err || !pages || pages > UINT_MAX)
+	err = kstrtouint(buf, 10, &pages);
+	if (err < 0)
+		return err;
+	if (pages == 0)
 		return -EINVAL;
-
 	khugepaged_pages_to_scan = pages;
 
 	return count;
@@ -452,11 +447,13 @@ static ssize_t khugepaged_max_ptes_none_store(struct kobject *kobj,
 					      struct kobj_attribute *attr,
 					      const char *buf, size_t count)
 {
+	unsigned int max_ptes_none;
 	int err;
-	unsigned long max_ptes_none;
 
-	err = strict_strtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR-1)
+	err = kstrtouint(buf, 10, &max_ptes_none);
+	if (err < 0)
+		return err;
+	if (max_ptes_none > HPAGE_PMD_NR - 1)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bb0b7c1..92086ba 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1374,8 +1374,8 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 	struct hstate *h;
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
-	err = strict_strtoul(buf, 10, &count);
-	if (err)
+	err = kstrtoul(buf, 10, &count);
+	if (err < 0)
 		goto out;
 
 	h = kobj_to_hstate(kobj, &nid);
@@ -1465,8 +1465,8 @@ static ssize_t nr_overcommit_hugepages_store(struct kobject *kobj,
 	if (h->order >= MAX_ORDER)
 		return -EINVAL;
 
-	err = strict_strtoul(buf, 10, &input);
-	if (err)
+	err = kstrtoul(buf, 10, &input);
+	if (err < 0)
 		return err;
 
 	spin_lock(&hugetlb_lock);
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 84225f3..a2b3cbe 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1560,9 +1560,9 @@ static ssize_t kmemleak_write(struct file *file, const char __user *user_buf,
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
index c2b2a94..07d08da 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1842,15 +1842,11 @@ static ssize_t sleep_millisecs_store(struct kobject *kobj,
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
@@ -1866,14 +1862,10 @@ static ssize_t pages_to_scan_store(struct kobject *kobj,
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
@@ -1888,11 +1880,11 @@ static ssize_t run_store(struct kobject *kobj, struct kobj_attribute *attr,
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
index e15aa7f..8dc7dd9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3904,11 +3904,11 @@ SLAB_ATTR_RO(objs_per_slab);
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
@@ -3935,7 +3935,7 @@ static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
 	unsigned long min;
 	int err;
 
-	err = strict_strtoul(buf, 10, &min);
+	err = kstrtoul(buf, 10, &min);
 	if (err)
 		return err;
 
@@ -4192,21 +4192,22 @@ SLAB_ATTR(shrink);
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
index 148c6e6..7e00f77 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3284,37 +3284,32 @@ int scan_unevictable_handler(struct ctl_table *table, int write,
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
1.7.3.4

