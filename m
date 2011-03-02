Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1CBIic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:38:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51874 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1CBIia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:38:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mdAIwYS+WHgGBvyFuLb0MdcANN3SCfXf7QMB/JVrXFwHf+q+5ygEs7bLfW0J9aMkFa
         CJ610kG/2W/WpRBq/5BIA53VdCql+Kz+9M8mXA3+KvI43gNjF46w8EFmNHxjAvfUbquW
         tRzL2S9irUIZgBRS+i3+2oh4KAm9hIjQE7lBs=
From: Liu Yuan <namei.unix@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: [RFC PATCH 3/5] block: Make Page Cache counters work with sysfs
Date: Wed,  2 Mar 2011 16:38:08 +0800
Message-Id: <1299055090-23976-3-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

Three counters are exported to the userspace from
/sys/block/sdx/{,sdxx}/page_cache_stats.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 block/genhd.c         |    6 ++++++
 fs/partitions/check.c |   23 +++++++++++++++++++++++
 include/linux/genhd.h |    4 ++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cbf1112..af9e7f8 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -988,6 +988,9 @@ static struct device_attribute dev_attr_fail_timeout =
 	__ATTR(io-timeout-fail,  S_IRUGO|S_IWUSR, part_timeout_show,
 		part_timeout_store);
 #endif
+#ifdef CONFIG_PAGE_CACHE_ACCT
+static DEVICE_ATTR(page_cache_stats, S_IRUGO, part_page_cache_stats_show, NULL);
+#endif
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
@@ -1006,6 +1009,9 @@ static struct attribute *disk_attrs[] = {
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 	&dev_attr_fail_timeout.attr,
 #endif
+#ifdef CONFIG_PAGE_CACHE_ACCT
+	&dev_attr_page_cache_stats.attr,
+#endif
 	NULL
 };
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 9c21119..e882e95 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -316,6 +316,23 @@ ssize_t part_fail_store(struct device *dev,
 }
 #endif
 
+#ifdef CONFIG_PAGE_CACHE_ACCT
+ssize_t part_page_cache_stats_show(struct device *dev,
+					  struct device_attribute * attr,
+					  char *buf)
+{
+	struct hd_struct  *p = dev_to_part(dev);
+
+	return sprintf(buf,
+			"%8lu %8lu %8lu %8lu %8lu\n ",
+			part_stat_read(p, page_cache_readpages),
+			part_stat_read(p, page_cache_missed[READ]),
+			part_stat_read(p, page_cache_hit[READ]),
+			part_stat_read(p, page_cache_missed[WRITE]),
+			part_stat_read(p, page_cache_hit[WRITE]));
+}
+#endif
+
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
@@ -329,6 +346,9 @@ static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
 #endif
+#ifdef CONFIG_PAGE_CACHE_ACCT
+static DEVICE_ATTR(page_cache_stats, S_IRUGO, part_page_cache_stats_show, NULL);
+#endif
 
 static struct attribute *part_attrs[] = {
 	&dev_attr_partition.attr,
@@ -342,6 +362,9 @@ static struct attribute *part_attrs[] = {
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
+#ifdef CONFIG_PAGE_CACHE_ACCT
+	&dev_attr_page_cache_stats.attr,
+#endif
 	NULL
 };
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f0257c..0ecd165 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -682,6 +682,10 @@ extern ssize_t part_fail_store(struct device *dev,
 			       struct device_attribute *attr,
 			       const char *buf, size_t count);
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
+#ifdef CONFIG_PAGE_CACHE_ACCT
+extern ssize_t part_page_cache_stats_show(struct device *dev,
+					  struct device_attribute *attr, char *buf);
+#endif /*  CONFIG_PAGE_CACHE_ACCT */
 
 static inline void hd_ref_init(struct hd_struct *part)
 {
-- 
1.7.0.4

