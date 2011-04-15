Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1DORFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:05:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36454 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1DORFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:05:07 -0400
Subject: [PATCH 1/2] break out page allocation warning code
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        Michal Nazarewicz <mina86@mina86.com>, akpm@osdl.org,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 10:04:37 -0700
Message-Id: <20110415170437.17E1AF36@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This originally started as a simple patch to give vmalloc()
some more verbose output on failure on top of the plain
page allocator messages.  Johannes suggested that it might
be nicer to lead with the vmalloc() info _before_ the page
allocator messages.

But, I do think there's a lot of value in what
__alloc_pages_slowpath() does with its filtering and so
forth.

This patch creates a new function which other allocators
can call instead of relying on the internal page allocator
warnings.  It also gives this function private rate-limiting
which separates it from other printk_ratelimit() users.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/mm.h |    2 +
 linux-2.6.git-dave/mm/page_alloc.c    |   63 ++++++++++++++++++++++------------
 2 files changed, 44 insertions(+), 21 deletions(-)

diff -puN include/linux/mm.h~break-out-alloc-failure-messages include/linux/mm.h
--- linux-2.6.git/include/linux/mm.h~break-out-alloc-failure-messages	2011-04-15 08:44:06.911445625 -0700
+++ linux-2.6.git-dave/include/linux/mm.h	2011-04-15 08:45:10.087416551 -0700
@@ -1365,6 +1365,8 @@ extern void si_meminfo(struct sysinfo * 
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 extern int after_bootmem;
 
+extern void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...);
+
 extern void setup_per_cpu_pageset(void);
 
 extern void zone_pcp_update(struct zone *zone);
diff -puN mm/page_alloc.c~break-out-alloc-failure-messages mm/page_alloc.c
--- linux-2.6.git/mm/page_alloc.c~break-out-alloc-failure-messages	2011-04-15 08:44:06.915445623 -0700
+++ linux-2.6.git-dave/mm/page_alloc.c	2011-04-15 08:48:34.255321834 -0700
@@ -54,6 +54,7 @@
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
 #include <linux/memcontrol.h>
+#include <linux/ratelimit.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1734,6 +1735,46 @@ static inline bool should_suppress_show_
 	return ret;
 }
 
+static DEFINE_RATELIMIT_STATE(nopage_rs,
+		DEFAULT_RATELIMIT_INTERVAL,
+		DEFAULT_RATELIMIT_BURST);
+
+void warn_alloc_failed(gfp_t gfp_mask, int order, const char *fmt, ...)
+{
+	va_list args;
+	unsigned int filter = SHOW_MEM_FILTER_NODES;
+	const gfp_t wait = gfp_mask & __GFP_WAIT;
+
+	if ((gfp_mask & __GFP_NOWARN) || !__ratelimit(&nopage_rs))
+		return;
+
+	/*
+	 * This documents exceptions given to allocations in certain
+	 * contexts that are allowed to allocate outside current's set
+	 * of allowed nodes.
+	 */
+	if (!(gfp_mask & __GFP_NOMEMALLOC))
+		if (test_thread_flag(TIF_MEMDIE) ||
+		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
+			filter &= ~SHOW_MEM_FILTER_NODES;
+	if (in_interrupt() || !wait)
+		filter &= ~SHOW_MEM_FILTER_NODES;
+
+	if (fmt) {
+		printk(KERN_WARNING);
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+	}
+
+	printk(KERN_WARNING "%s: page allocation failure: order:%d, mode:0x%x\n",
+			current->comm, order, gfp_mask);
+
+	dump_stack();
+	if (!should_suppress_show_mem())
+		show_mem(filter);
+}
+
 static inline int
 should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 				unsigned long pages_reclaimed)
@@ -2176,27 +2217,7 @@ rebalance:
 	}
 
 nopage:
-	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
-		unsigned int filter = SHOW_MEM_FILTER_NODES;
-
-		/*
-		 * This documents exceptions given to allocations in certain
-		 * contexts that are allowed to allocate outside current's set
-		 * of allowed nodes.
-		 */
-		if (!(gfp_mask & __GFP_NOMEMALLOC))
-			if (test_thread_flag(TIF_MEMDIE) ||
-			    (current->flags & (PF_MEMALLOC | PF_EXITING)))
-				filter &= ~SHOW_MEM_FILTER_NODES;
-		if (in_interrupt() || !wait)
-			filter &= ~SHOW_MEM_FILTER_NODES;
-
-		pr_warning("%s: page allocation failure. order:%d, mode:0x%x\n",
-			current->comm, order, gfp_mask);
-		dump_stack();
-		if (!should_suppress_show_mem())
-			show_mem(filter);
-	}
+	warn_alloc_failed(gfp_mask, order, NULL);
 	return page;
 got_pg:
 	if (kmemcheck_enabled)
_
