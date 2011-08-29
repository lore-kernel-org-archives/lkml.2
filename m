Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1H2D56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:57:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:30079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab1H2D5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,295,1312182000"; 
   d="scan'208";a="43384120"
Message-Id: <20110829034932.000999180@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 29 Aug 2011 11:29:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mgorman@suse.de>, Steven Rostedt <srostedt@redhat.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/7] tracing/mm: create trace_objects.c
References: <20110829032951.677220552@intel.com>
Content-Disposition: inline; filename=trace-objects.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code refactor: create trace_objects.c and move relevant code from trace_mm.c

CC: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/trace/Makefile        |    1 +
 kernel/trace/trace.h         |    1 +
 kernel/trace/trace_mm.c      |   22 ----------------------
 kernel/trace/trace_objects.c |   26 ++++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 22 deletions(-)

--- linux-mmotm.orig/kernel/trace/Makefile	2011-08-28 10:09:25.000000000 +0800
+++ linux-mmotm/kernel/trace/Makefile	2011-08-28 10:09:28.000000000 +0800
@@ -26,6 +26,7 @@ obj-$(CONFIG_RING_BUFFER) += ring_buffer
 obj-$(CONFIG_RING_BUFFER_BENCHMARK) += ring_buffer_benchmark.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_TRACING) += trace_objects.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
--- linux-mmotm.orig/kernel/trace/trace.h	2011-08-28 10:09:25.000000000 +0800
+++ linux-mmotm/kernel/trace/trace.h	2011-08-28 10:09:28.000000000 +0800
@@ -318,6 +318,7 @@ struct dentry *trace_create_file(const c
 				 const struct file_operations *fops);
 
 struct dentry *tracing_init_dentry(void);
+struct dentry *trace_objects_dir(void);
 
 struct ring_buffer_event;
 
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-mmotm/kernel/trace/trace_objects.c	2011-08-28 10:09:28.000000000 +0800
@@ -0,0 +1,26 @@
+#include <linux/debugfs.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+struct dentry *trace_objects_dir(void)
+{
+	static struct dentry *d_objects;
+	struct dentry *d_tracer;
+
+	if (d_objects)
+		return d_objects;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return NULL;
+
+	d_objects = debugfs_create_dir("objects", d_tracer);
+	if (!d_objects)
+		pr_warning("Could not create debugfs "
+			   "'objects' directory\n");
+
+	return d_objects;
+}
+
+
--- linux-mmotm.orig/kernel/trace/trace_mm.c	2011-08-28 10:09:27.000000000 +0800
+++ linux-mmotm/kernel/trace/trace_mm.c	2011-08-28 10:09:28.000000000 +0800
@@ -95,28 +95,6 @@ static const struct file_operations trac
 	.write		= trace_mm_pfn_range_write,
 };
 
-/* move this into trace_objects.c when that file is created */
-static struct dentry *trace_objects_dir(void)
-{
-	static struct dentry *d_objects;
-	struct dentry *d_tracer;
-
-	if (d_objects)
-		return d_objects;
-
-	d_tracer = tracing_init_dentry();
-	if (!d_tracer)
-		return NULL;
-
-	d_objects = debugfs_create_dir("objects", d_tracer);
-	if (!d_objects)
-		pr_warning("Could not create debugfs "
-			   "'objects' directory\n");
-
-	return d_objects;
-}
-
-
 static struct dentry *trace_objects_mm_dir(void)
 {
 	static struct dentry *d_mm;


