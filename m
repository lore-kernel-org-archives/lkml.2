Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab1BAAzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:55:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52619 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121Ab1BAAzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:55:50 -0500
Subject: [RFC][PATCH] trace transparent huge page splits
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 16:55:47 -0800
Message-Id: <20110201005547.85774260@kernel>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When we see transparent huge pages being broken down, we generally
have no idea of finding anything out about how it happened, or what
it affected.

A simple static tracepoint like this should at least get us some
minimal information like a stack trace, the virtual address, and
the mm that it happened to.

I'm not sure if there is a better way to do this with any of the
other tracing mechanisms, but this seems to work at least for me.
Does anybody else have a better way?  Is it worth merging this
kind of stuff, or is it best left out of tree as a debugging
patch?

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/trace/events/huge_memory.h |   32 ++++++++++++++++++
 linux-2.6.git-dave/mm/huge_memory.c                   |    5 ++
 2 files changed, 37 insertions(+)

diff -puN /dev/null include/trace/events/huge_memory.h
--- /dev/null	2011-01-21 14:16:26.635488000 -0800
+++ linux-2.6.git-dave/include/trace/events/huge_memory.h	2011-01-31 16:42:37.607926454 -0800
@@ -0,0 +1,32 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM huge_memory
+
+#if !defined(_TRACE_HUGE_MEMORY_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_HUGE_MEMORY_H
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mm_huge_memory_split,
+
+	TP_PROTO(struct mm_struct *mm, unsigned long address),
+
+	TP_ARGS(mm, address),
+
+	TP_STRUCT__entry(
+		__field(struct mm_struct *, mm)
+		__field(unsigned long,	    address)
+	),
+
+	TP_fast_assign(
+		__entry->mm	 = mm;
+		__entry->address = address;
+	),
+
+	TP_printk("mm=%p address=%p", __entry->mm, (void *)__entry->address)
+);
+
+#endif /* _TRACE_HUGE_MEMORY_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff -puN include/linux/huge_mm.h~huge_mem_trace include/linux/huge_mm.h
diff -puN mm/huge_memory.c~huge_mem_trace mm/huge_memory.c
--- linux-2.6.git/mm/huge_memory.c~huge_mem_trace	2011-01-31 16:40:38.752014520 -0800
+++ linux-2.6.git-dave/mm/huge_memory.c	2011-01-31 16:41:15.671987202 -0800
@@ -21,6 +21,9 @@
 #include <asm/pgalloc.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/huge_memory.h>
+
 /*
  * By default transparent hugepage support is enabled for all mappings
  * and khugepaged scans all mappings. Defrag is only invoked by
@@ -1254,6 +1257,8 @@ static int __split_huge_page_map(struct 
 	pgtable_t pgtable;
 	unsigned long haddr;
 
+	trace_mm_huge_memory_split(vma->vm_mm, address);
+
 	spin_lock(&mm->page_table_lock);
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
diff -puN mm/vmscan.c~huge_mem_trace mm/vmscan.c
diff -puN mm/page_io.c~huge_mem_trace mm/page_io.c
diff -puN block/blk-core.c~huge_mem_trace block/blk-core.c
_
