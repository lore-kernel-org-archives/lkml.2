Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab1H2D5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 23:57:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:45068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab1H2D5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 23:57:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,295,1312182000"; 
   d="scan'208";a="43384118"
Message-Id: <20110829034932.272364561@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 29 Aug 2011 11:29:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
to: Ingo Molnar <mingo@elte.hu>
cc: Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 5/7] tracing/mm: accept echo-able input format for pfn range 
References: <20110829032951.677220552@intel.com>
Content-Disposition: inline; filename=trace-mm-pfn-range-input.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seek+write style input for specifying pfn range is not scriptable.
Change it to more user friendly echo-able format.

Before patch:

	fd = open("/debug/tracing/object/mm/page/dump-pfn");
	seek(fd, start);
	write(fd, "size");

After patch:

	echo start +size > /debug/tracing/object/mm/page/dump-pfn
or
	echo start end   > /debug/tracing/object/mm/page/dump-pfn

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 kernel/trace/trace_mm.c |   39 +++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- mmotm.orig/kernel/trace/trace_mm.c	2010-12-26 20:05:26.000000000 +0800
+++ mmotm/kernel/trace/trace_mm.c	2010-12-26 20:20:13.000000000 +0800
@@ -9,6 +9,7 @@
 #include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
+#include <linux/ctype.h>
 
 #include "trace_output.h"
 
@@ -24,8 +25,8 @@ void trace_mm_page_frames(unsigned long 
 	if (start > max_pfn - 1)
 		return;
 
-	if (end > max_pfn - 1)
-		end = max_pfn - 1;
+	if (end > max_pfn)
+		end = max_pfn;
 
 	while (pfn < end) {
 		page = NULL;
@@ -50,13 +51,20 @@ trace_mm_pfn_range_read(struct file *fil
 }
 
 
+/*
+ * recognized formats:
+ * 		"M N"	start=M, end=N
+ * 		"M"	start=M, end=M+1
+ * 		"M +N"	start=M, end=M+N-1
+ */
 static ssize_t
 trace_mm_pfn_range_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			 loff_t *ppos)
 {
-	unsigned long val, start, end;
+	unsigned long start;
+	unsigned long end = 0;
 	char buf[64];
-	int ret;
+	char *ptr;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -72,19 +80,20 @@ trace_mm_pfn_range_write(struct file *fi
 
 	buf[cnt] = 0;
 
-	ret = strict_strtol(buf, 10, &val);
-	if (ret < 0)
-		return ret;
-
-	start = *ppos;
-	if (val < 0)
-		end = max_pfn - 1;
-	else
-		end = start + val;
+	start = simple_strtoul(buf, &ptr, 0);
 
-	trace_mm_page_frames(start, end, trace_mm_page_frame);
+	for (; *ptr; ptr++) {
+		if (isdigit(*ptr)) {
+			if (*(ptr - 1) == '+')
+				end = start;
+			end += simple_strtoul(ptr, NULL, 0);
+			break;
+		}
+	}
+	if (!*ptr)
+		end = start + 1;
 
-	*ppos += cnt;
+	trace_mm_page_frames(start, end, trace_mm_page_frame);
 
 	return cnt;
 }


