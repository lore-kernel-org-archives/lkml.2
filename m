Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab1GCN6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 09:58:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab1GCN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 09:58:30 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/7] fault-injection: cleanup simple attribute of stacktrace_depth
Date: Sun,  3 Jul 2011 22:59:44 +0900
Message-Id: <1309701588-16588-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
References: <1309701588-16588-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor cosmetic changes for simple attribute of stacktrace_depth:

 - use min_t()
 - reduce #ifdef by moving a function
 - do not use partly capitalized function name

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 lib/fault-inject.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index e6430e1..882fd3b 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -139,16 +139,6 @@ static int debugfs_ul_set(void *data, u64 val)
 	return 0;
 }
 
-#ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-static int debugfs_ul_set_MAX_STACK_TRACE_DEPTH(void *data, u64 val)
-{
-	*(unsigned long *)data =
-		val < MAX_STACK_TRACE_DEPTH ?
-		val : MAX_STACK_TRACE_DEPTH;
-	return 0;
-}
-#endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
-
 static int debugfs_ul_get(void *data, u64 *val)
 {
 	*val = *(unsigned long *)data;
@@ -164,16 +154,26 @@ static struct dentry *debugfs_create_ul(const char *name, mode_t mode,
 }
 
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
-DEFINE_SIMPLE_ATTRIBUTE(fops_ul_MAX_STACK_TRACE_DEPTH, debugfs_ul_get,
-			debugfs_ul_set_MAX_STACK_TRACE_DEPTH, "%llu\n");
 
-static struct dentry *debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+static int debugfs_stacktrace_depth_set(void *data, u64 val)
+{
+	*(unsigned long *)data =
+		min_t(unsigned long, val, MAX_STACK_TRACE_DEPTH);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_stacktrace_depth, debugfs_ul_get,
+			debugfs_stacktrace_depth_set, "%llu\n");
+
+static struct dentry *debugfs_create_stacktrace_depth(
 	const char *name, mode_t mode,
 	struct dentry *parent, unsigned long *value)
 {
 	return debugfs_create_file(name, mode, parent, value,
-				   &fops_ul_MAX_STACK_TRACE_DEPTH);
+				   &fops_stacktrace_depth);
 }
+
 #endif /* CONFIG_FAULT_INJECTION_STACKTRACE_FILTER */
 
 static int debugfs_atomic_t_set(void *data, u64 val)
@@ -281,7 +281,7 @@ int init_fault_attr_dentries(struct fault_attr *attr, const char *name)
 #ifdef CONFIG_FAULT_INJECTION_STACKTRACE_FILTER
 
 	attr->dentries.stacktrace_depth_file =
-		debugfs_create_ul_MAX_STACK_TRACE_DEPTH(
+		debugfs_create_stacktrace_depth(
 			"stacktrace-depth", mode, dir, &attr->stacktrace_depth);
 
 	attr->dentries.require_start_file =
-- 
1.7.4.4

