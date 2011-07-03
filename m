Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1GCN6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1GCN6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:39 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-mm@kvack.org
Subject: [PATCH 6/7] fail_page_alloc: simplify debugfs initialization
Date: Sun,  3 Jul 2011 22:59:47 +0900
Message-Id: <1309701588-16588-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now cleanup_fault_attr_dentries() recursively removes a directory,
So we can simplify the error handling in the initialization code
and no need to hold dentry structs for each debugfs file.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-mm@kvack.org
---
 mm/page_alloc.c |   47 ++++++++++++++++-------------------------------
 1 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 71159b2..44b0f09 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1370,21 +1370,12 @@ failed:
 
 #ifdef CONFIG_FAIL_PAGE_ALLOC
 
-static struct fail_page_alloc_attr {
+static struct {
 	struct fault_attr attr;
 
 	u32 ignore_gfp_highmem;
 	u32 ignore_gfp_wait;
 	u32 min_order;
-
-#ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-	struct dentry *ignore_gfp_highmem_file;
-	struct dentry *ignore_gfp_wait_file;
-	struct dentry *min_order_file;
-
-#endif /* CONFIG_FAULT_INJECTION_DEBUG_FS */
-
 } fail_page_alloc = {
 	.attr = FAULT_ATTR_INITIALIZER,
 	.ignore_gfp_wait = 1,
@@ -1424,30 +1415,24 @@ static int __init fail_page_alloc_debugfs(void)
 				       "fail_page_alloc");
 	if (err)
 		return err;
+
 	dir = fail_page_alloc.attr.dir;
 
-	fail_page_alloc.ignore_gfp_wait_file =
-		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-				      &fail_page_alloc.ignore_gfp_wait);
-
-	fail_page_alloc.ignore_gfp_highmem_file =
-		debugfs_create_bool("ignore-gfp-highmem", mode, dir,
-				      &fail_page_alloc.ignore_gfp_highmem);
-	fail_page_alloc.min_order_file =
-		debugfs_create_u32("min-order", mode, dir,
-				   &fail_page_alloc.min_order);
-
-	if (!fail_page_alloc.ignore_gfp_wait_file ||
-            !fail_page_alloc.ignore_gfp_highmem_file ||
-            !fail_page_alloc.min_order_file) {
-		err = -ENOMEM;
-		debugfs_remove(fail_page_alloc.ignore_gfp_wait_file);
-		debugfs_remove(fail_page_alloc.ignore_gfp_highmem_file);
-		debugfs_remove(fail_page_alloc.min_order_file);
-		cleanup_fault_attr_dentries(&fail_page_alloc.attr);
-	}
+	if (!debugfs_create_bool("ignore-gfp-wait", mode, dir,
+				&fail_page_alloc.ignore_gfp_wait))
+		goto fail;
+	if (!debugfs_create_bool("ignore-gfp-highmem", mode, dir,
+				&fail_page_alloc.ignore_gfp_highmem))
+		goto fail;
+	if (!debugfs_create_u32("min-order", mode, dir,
+				&fail_page_alloc.min_order))
+		goto fail;
+
+	return 0;
+fail:
+	cleanup_fault_attr_dentries(&fail_page_alloc.attr);
 
-	return err;
+	return -ENOMEM;
 }
 
 late_initcall(fail_page_alloc_debugfs);
-- 
1.7.4.4

