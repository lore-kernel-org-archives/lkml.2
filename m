Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab0JIVED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 17:04:03 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50658 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757075Ab0JIVEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 17:04:01 -0400
Date: Sat, 9 Oct 2010 17:03:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Paul Menage <menage@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Balbir Singh <balbir@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Cedric Le Goater <clg@fr.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] Prio_heap: heap_remove(), heap_maximum(), heap_replace()
	and heap_cherrypick() (v2)
Message-ID: <20101009210358.GA23109@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:00:56 up 17 days,  1:03,  1 user,  load average: 0.23, 0.10,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These added interfaces lets prio_heap users lookup the top of heap item without
performing any insertion, perform removal of the topmost heap entry, and also
replacement of topmost heap entry. This is useful if one need to use the result
of the lookup to determine if the current maximum should simply be removed or if
it should be replaced.

This is used by the Generic Ring Buffer to perform timestamp-based fusion-merge
of per-cpu buffer records into a single stream.

Changelog since v1:
- Apply cleanups recommended by Lai Jiangshan.
- Apply cleanups recommended by Paul Menage.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Acked-by: Paul Menage <menage@google.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/prio_heap.h |   47 ++++++++++++++++++++-
 lib/prio_heap.c           |   99 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 123 insertions(+), 23 deletions(-)

Index: linux.trees.git/include/linux/prio_heap.h
===================================================================
--- linux.trees.git.orig/include/linux/prio_heap.h
+++ linux.trees.git/include/linux/prio_heap.h
@@ -2,8 +2,7 @@
 #define _LINUX_PRIO_HEAP_H
 
 /*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
+ * Static-sized priority heap containing pointers. Based on CLR, chapter 7.
  */
 
 #include <linux/gfp.h>
@@ -23,6 +22,18 @@ struct ptr_heap {
 };
 
 /**
+ * heap_maximum - return the largest element in the heap
+ * @heap: the heap to be operated on
+ *
+ * Returns the largest element in the heap, without performing any modification
+ * to the heap structure. Returns NULL if the heap is empty.
+ */
+static inline void *heap_maximum(const struct ptr_heap *heap)
+{
+	return heap->size ? heap->ptrs[0] : NULL;
+}
+
+/**
  * heap_init - initialize an empty heap with a given memory size
  * @heap: the heap structure to be initialized
  * @size: amount of memory to use in bytes
@@ -53,6 +64,38 @@ void heap_free(struct ptr_heap *heap);
  */
 extern void *heap_insert(struct ptr_heap *heap, void *p);
 
+/**
+ * heap_remove - remove the largest element from the heap
+ * @heap: the heap to be operated on
+ *
+ * Returns the largest element in the heap. It removes this element from the
+ * heap. Returns NULL if the heap is empty.
+ */
+extern void *heap_remove(struct ptr_heap *heap);
 
+/**
+ * heap_cherrypick - remove a given element from the heap
+ * @heap: the heap to be operated on
+ * @p: the element
+ *
+ * Remove the given element from the heap. Return the element if present, else
+ * return NULL. This algorithm has a complexity of O(n), which is higher than
+ * O(log(n)) provided by the rest of this API.
+ */
+extern void *heap_cherrypick(struct ptr_heap *heap, void *p);
+
+/**
+ * heap_replace_max - replace the the largest element from the heap
+ * @heap: the heap to be operated on
+ * @p: the pointer to be inserted as topmost element replacement
+ *
+ * Returns the largest element in the heap. It removes this element from the
+ * heap. The heap is rebalanced only once after the insertion. Returns NULL if
+ * the heap is empty.
+ *
+ * This is the equivalent of calling heap_remove() and then heap_insert(), but
+ * it only rebalances the heap once.
+ */
+extern void *heap_replace_max(struct ptr_heap *heap, void *p);
 
 #endif /* _LINUX_PRIO_HEAP_H */
Index: linux.trees.git/lib/prio_heap.c
===================================================================
--- linux.trees.git.orig/lib/prio_heap.c
+++ linux.trees.git/lib/prio_heap.c
@@ -1,6 +1,5 @@
 /*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
+ * Static-sized priority heap containing pointers. Based on CLR, chapter 7.
  */
 
 #include <linux/slab.h>
@@ -23,10 +22,49 @@ void heap_free(struct ptr_heap *heap)
 	kfree(heap->ptrs);
 }
 
-void *heap_insert(struct ptr_heap *heap, void *p)
+static void heapify(struct ptr_heap *heap, int pos)
+{
+	void **ptrs = heap->ptrs;
+	void *p = ptrs[pos];
+
+	while (1) {
+		int left = 2 * pos + 1;
+		int right = 2 * pos + 2;
+		int largest = pos;
+		if (left < heap->size && heap->gt(ptrs[left], p))
+			largest = left;
+		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
+			largest = right;
+		if (largest == pos)
+			break;
+		/* Push p down the heap one level and bump one up */
+		ptrs[pos] = ptrs[largest];
+		ptrs[largest] = p;
+		pos = largest;
+	}
+}
+
+void *heap_replace_max(struct ptr_heap *heap, void *p)
 {
 	void *res;
 	void **ptrs = heap->ptrs;
+
+	if (!heap->size) {
+		ptrs[0] = p;
+		heap->size = 1;
+		return NULL;
+	}
+
+	/* Replace the current max and heapify */
+	res = ptrs[0];
+	ptrs[0] = p;
+	heapify(heap, 0);
+	return res;
+}
+
+void *heap_insert(struct ptr_heap *heap, void *p)
+{
+	void **ptrs = heap->ptrs;
 	int pos;
 
 	if (heap->size < heap->max) {
@@ -47,24 +85,43 @@ void *heap_insert(struct ptr_heap *heap,
 		return p;
 
 	/* Replace the current max and heapify */
-	res = ptrs[0];
-	ptrs[0] = p;
-	pos = 0;
+	return heap_replace_max(heap, p);
+}
 
-	while (1) {
-		int left = 2 * pos + 1;
-		int right = 2 * pos + 2;
-		int largest = pos;
-		if (left < heap->size && heap->gt(ptrs[left], p))
-			largest = left;
-		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
-			largest = right;
-		if (largest == pos)
-			break;
-		/* Push p down the heap one level and bump one up */
-		ptrs[pos] = ptrs[largest];
-		ptrs[largest] = p;
-		pos = largest;
+void *heap_remove(struct ptr_heap *heap)
+{
+	void **ptrs = heap->ptrs;
+
+	switch (heap->size) {
+	case 0:
+		return NULL;
+	case 1:
+		heap->size = 0;
+		return ptrs[0];
 	}
-	return res;
+
+	/* Shrink, replace the current max by previous last entry and heapify */
+	return heap_replace_max(heap, ptrs[--heap->size]);
+}
+
+void *heap_cherrypick(struct ptr_heap *heap, void *p)
+{
+	void **ptrs = heap->ptrs;
+	size_t pos, size = heap->size;
+
+	for (pos = 0; pos < size; pos++)
+		if (ptrs[pos] == p)
+			goto found;
+	return NULL;
+found:
+	if (heap->size == 1) {
+		heap->size = 0;
+		return ptrs[0];
+	}
+	/*
+	 * Replace p with previous last entry and heapify.
+	 */
+	ptrs[pos] = ptrs[--heap->size];
+	heapify(heap, pos);
+	return p;
 }
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
