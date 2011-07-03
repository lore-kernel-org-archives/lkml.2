Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1GCN6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61248 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1GCN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:32 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/7] fault-injection: use debugfs_remove_recursive
Date: Sun,  3 Jul 2011 22:59:45 +0900
Message-Id: <1309701588-16588-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use debugfs_remove_recursive() to simplify initialization and
deinitialization of fault injection debugfs files.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/fault-inject.h |   18 +------
 lib/fault-inject.c           |  115 ++++++++++--------------------------------
 mm/failslab.c                |    2 +-
 mm/page_alloc.c              |    2 +-
 4 files changed, 30 insertions(+), 107 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 7b72328..a842db6 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -27,23 +27,7 @@ struct fault_attr {
 	unsigned long count;
 
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
-
-	struct {
-		struct dentry *dir;
-
-		struct dentry *probability_file;
-		struct dentry *interval_file;
-		struct dentry *times_file;
-		struct dentry *space_file;
-		struct dentry *verbose_file;
-		struct dentry *task_filter_file;
-		struct dentry *stacktrace_depth_file;
-		struct dentry *require_start_file;
-		struct dentry *require_end_file;
-		struct dentry *reject_start_file;
-		struct dentry *reject_end_file;
-	} dentries;
-
+	struct dentry *dir;
 #endif
 };
 
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 882fd3b..2577b12 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -199,48 +199,7 @@ static struct dentry *debugfs_create_atomic_t(const char *name, mode_t mode,
 
 void cleanup_fault_attr_dentries(struct fault_attr *attr)
 {
-	debugfs_remove(attr->dentries.probability_file);
-	attr->dentries.probability_file = NULL;
-
-	debugfs_remove(attr->dentries.interval_file);
-	attr->dentries.interval_file = NULL;
-
-	debugfs_remove(attr->dentries.times_file);
-	attr->dentries.times_file = NULL;
-
-	debugfs_remove(attr->dentries.space_file);
-	attr->dentries.space_file = NULL;
-
-	debugfs_remove(attr->dentries.verbose_file);
-	attr->dentries.verbose_file = NULL;
-
-	debugfs_remove(attr->dentries.task_filter_file);
-	attr->dentries.task_filter_file = NULL;
-
-#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-
-	debugfs_remove(attr->dentries.stacktrace_depth_file);
-	attr->dentries.stacktrace_depth_file = NULL;
-
-	debugfs_remove(attr->dentries.require_start_file);
-	attr->dentries.require_start_file = NULL;
-
-	debugfs_remove(attr->dentries.require_end_file);
-	attr->dentries.require_end_file = NULL;
-
-	debugfs_remove(attr->dentries.reject_start_file);
-	attr->dentries.reject_start_file = NULL;
-
-	debugfs_remove(attr->dentries.reject_end_file);
-	attr->dentries.reject_end_file = NULL;
-
-#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
-
-	if (attr->dentries.dir)
-		WARN_ON(!simple_empty(attr->dentries.dir));
-
-	debugfs_remove(attr->dentries.dir);
-	attr->dentries.dir = NULL;
+	debugfs_remove_recursive(attr->dir);
 }
 
 int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
@@ -248,66 +207,46 @@ int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
 	mode_t mode = S_IFREG | S_IRUSR | S_IWUSR;
 	struct dentry *dir;
 
-	memset(&attr->dentries, 0, sizeof(attr->dentries));
-
 	dir = debugfs_create_dir(name, NULL);
 	if (!dir)
-		goto fail;
-	attr->dentries.dir = dir;
-
-	attr->dentries.probability_file =
-		debugfs_create_ul("probability", mode, dir, &attr->probability);
+		return -ENOMEM;
 
-	attr->dentries.interval_file =
-		debugfs_create_ul("interval", mode, dir, &attr->interval);
+	attr->dir = dir;
 
-	attr->dentries.times_file =
-		debugfs_create_atomic_t("times", mode, dir, &attr->times);
-
-	attr->dentries.space_file =
-		debugfs_create_atomic_t("space", mode, dir, &attr->space);
-
-	attr->dentries.verbose_file =
-		debugfs_create_ul("verbose", mode, dir, &attr->verbose);
-
-	attr->dentries.task_filter_file = debugfs_create_bool("task-filter",
-						mode, dir, &attr->task_filter);
-
-	if (!attr->dentries.probability_file || !attr->dentries.interval_file ||
-	    !attr->dentries.times_file || !attr->dentries.space_file ||
-	    !attr->dentries.verbose_file || !attr->dentries.task_filter_file)
+	if (!debugfs_create_ul("probability", mode, dir, &attr->probability))
+		goto fail;
+	if (!debugfs_create_ul("interval", mode, dir, &attr->interval))
+		goto fail;
+	if (!debugfs_create_atomic_t("times", mode, dir, &attr->times))
+		goto fail;
+	if (!debugfs_create_atomic_t("space", mode, dir, &attr->space))
+		goto fail;
+	if (!debugfs_create_ul("verbose", mode, dir, &attr->verbose))
+		goto fail;
+	if (!debugfs_create_bool("task-filter", mode, dir, &attr->task_filter))
 		goto fail;
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
-	attr->dentries.stacktrace_depth_file =
-		debugfs_create_stacktrace_depth(
-			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
-
-	attr->dentries.require_start_file =
-		debugfs_create_ul("require-start", mode, dir, &attr->require_start);
-
-	attr->dentries.require_end_file =
-		debugfs_create_ul("require-end", mode, dir, &attr->require_end);
-
-	attr->dentries.reject_start_file =
-		debugfs_create_ul("reject-start", mode, dir, &attr->reject_start);
-
-	attr->dentries.reject_end_file =
-		debugfs_create_ul("reject-end", mode, dir, &attr->reject_end);
-
-	if (!attr->dentries.stacktrace_depth_file ||
-	    !attr->dentries.require_start_file ||
-	    !attr->dentries.require_end_file ||
-	    !attr->dentries.reject_start_file ||
-	    !attr->dentries.reject_end_file)
+	if (!debugfs_create_stacktrace_depth("stacktrace-depth", mode, dir,
+				&attr->stacktrace_depth))
+		goto fail;
+	if (!debugfs_create_ul("require-start", mode, dir,
+				&attr->require_start))
+		goto fail;
+	if (!debugfs_create_ul("require-end", mode, dir, &attr->require_end))
+		goto fail;
+	if (!debugfs_create_ul("reject-start", mode, dir, &attr->reject_start))
+		goto fail;
+	if (!debugfs_create_ul("reject-end", mode, dir, &attr->reject_end))
 		goto fail;
 
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 	return 0;
 fail:
-	cleanup_fault_attr_dentries(attr);
+	debugfs_remove_recursive(attr->dir);
+
 	return -ENOMEM;
 }
 
diff --git a/mm/failslab.c b/mm/failslab.c
index c5f88f2..7df9f7f 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -45,7 +45,7 @@ static int __init failslab_debugfs_init(void)
 	err = init_fault_attr_dentries(&failslab.attr, "failslab");
 	if (err)
 		return err;
-	dir = failslab.attr.dentries.dir;
+	dir = failslab.attr.dir;
 
 	failslab.ignore_gfp_wait_file =
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e8985a..71159b2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1424,7 +1424,7 @@ static int __init fail_page_alloc_debugfs(void)
 				       "fail_page_alloc");
 	if (err)
 		return err;
-	dir = fail_page_alloc.attr.dentries.dir;
+	dir = fail_page_alloc.attr.dir;
 
 	fail_page_alloc.ignore_gfp_wait_file =
 		debugfs_create_bool("ignore-gfp-wait", mode, dir,
-- 
1.7.4.4

