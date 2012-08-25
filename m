Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab2HYIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 04:25:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33744 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2HYIYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 04:24:42 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: fengguang.wu@intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Vivek Trivedi <vtrivedi018@gmail.com>
Subject: [PATCH] writeback: backing-dev: replace simple_strtoul to kstrto*
Date: Sat, 25 Aug 2012 04:24:32 -0400
Message-Id: <1345883072-6364-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix checkpatch warnings:
WARNING: consider using kstrto* in preference to simple_strtoul

for below sys entry parsers:
/sys/block/<block device>/bdi/read_ahead_kb
/sys/block/<block device>/bdi/max_ratio
/sys/block/<block device>/bdi/min_ratio

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Vivek Trivedi <vtrivedi018@gmail.com>
---
 mm/backing-dev.c |   50 ++++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b41823c..d3ca2b3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -158,16 +158,16 @@ static ssize_t read_ahead_kb_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned long read_ahead_kb;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
 
-	read_ahead_kb = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
-		ret = count;
-	}
-	return ret;
+	ret = kstrtoul(buf, 10, &read_ahead_kb);
+	if (ret < 0)
+		return ret;
+
+	bdi->ra_pages = read_ahead_kb >> (PAGE_SHIFT - 10);
+
+	return count;
 }
 
 #define K(pages) ((pages) << (PAGE_SHIFT - 10))
@@ -187,16 +187,17 @@ static ssize_t min_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned int ratio;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &ratio);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_min_ratio(bdi, ratio);
+	if (!ret)
+		ret = count;
 
-	ratio = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		ret = bdi_set_min_ratio(bdi, ratio);
-		if (!ret)
-			ret = count;
-	}
 	return ret;
 }
 BDI_SHOW(min_ratio, bdi->min_ratio)
@@ -205,16 +206,17 @@ static ssize_t max_ratio_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct backing_dev_info *bdi = dev_get_drvdata(dev);
-	char *end;
 	unsigned int ratio;
-	ssize_t ret = -EINVAL;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &ratio);
+	if (ret < 0)
+		return ret;
+
+	ret = bdi_set_max_ratio(bdi, ratio);
+	if (!ret)
+		ret = count;
 
-	ratio = simple_strtoul(buf, &end, 10);
-	if (*buf && (end[0] == '\0' || (end[0] == '\n' && end[1] == '\0'))) {
-		ret = bdi_set_max_ratio(bdi, ratio);
-		if (!ret)
-			ret = count;
-	}
 	return ret;
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
-- 
1.7.9.5

