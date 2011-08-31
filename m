Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1HaOlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:41:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60972 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1HaOlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:41:12 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, dan.magenheimer@oracle.com, ngupta@vflare.org,
        cascardo@holoscopio.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 3/3] staging: zcache: add zv_page_count and zv_desc_count
Date: Wed, 31 Aug 2011 09:40:41 -0500
Message-Id: <1314801641-15059-4-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1314801641-15059-1-git-send-email-sjenning@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the zv_page_count and zv_desc_count attributes
to the zcache sysfs.  They are read-only attributes and return
the number of pages and the number of block descriptors in use
by the pool respectively.

These statistics can be used to calculate effective compression
and block descriptor overhead for the xcfmalloc allocator.

Using the frontswap curr_pages attribute, effective compression
is: zv_page_count / curr_pages

Using /proc/slabinfo to get the objsize for a xcf_desc_cache
object, descriptor overhead is: zv_desc_count * objsize

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zcache/zcache-main.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index b07377b..6adbbbe 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -789,6 +789,24 @@ static int zv_cumul_dist_counts_show(char *buf)
 	return p - buf;
 }
 
+static int zv_page_count_show(char *buf)
+{
+	char *p = buf;
+	unsigned long count;
+	count = xcf_get_total_size_bytes(zcache_host.xcfmpool) >> PAGE_SHIFT;
+	p += sprintf(p, "%lu\n", count);
+	return p - buf;
+}
+
+static int zv_desc_count_show(char *buf)
+{
+	char *p = buf;
+	unsigned long count;
+	count = xcf_get_desc_count(zcache_host.xcfmpool);
+	p += sprintf(p, "%lu\n", count);
+	return p - buf;
+}
+
 /*
  * setting zv_max_zsize via sysfs causes all persistent (e.g. swap)
  * pages that don't compress to less than this value (including metadata
@@ -1477,6 +1495,10 @@ ZCACHE_SYSFS_RO_CUSTOM(zv_curr_dist_counts,
 			zv_curr_dist_counts_show);
 ZCACHE_SYSFS_RO_CUSTOM(zv_cumul_dist_counts,
 			zv_cumul_dist_counts_show);
+ZCACHE_SYSFS_RO_CUSTOM(zv_page_count,
+			zv_page_count_show);
+ZCACHE_SYSFS_RO_CUSTOM(zv_desc_count,
+			zv_desc_count_show);
 
 static struct attribute *zcache_attrs[] = {
 	&zcache_curr_obj_count_attr.attr,
@@ -1513,6 +1535,8 @@ static struct attribute *zcache_attrs[] = {
 	&zcache_zv_max_zsize_attr.attr,
 	&zcache_zv_max_mean_zsize_attr.attr,
 	&zcache_zv_page_count_policy_percent_attr.attr,
+	&zcache_zv_page_count_attr.attr,
+	&zcache_zv_desc_count_attr.attr,
 	NULL,
 };
 
-- 
1.7.4.1

