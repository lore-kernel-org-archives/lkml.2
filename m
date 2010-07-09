Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab0GIXoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:44:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59632 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab0GIXoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:44:04 -0400
Message-Id: <20100709225816.167106877@efficios.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 18:57:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Johannes Berg <johannes.berg@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>, Paul Menage <menage@google.com>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: [patch 06/20] prio_heap: heap_remove(), heap_maximum(), heap_replace() and heap_cherrypick()
References: <20100709225727.312232266@efficios.com>
Content-Disposition: inline; filename=prio-heap-remove-maximum-replace-cherrypick.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  9 Jul 2010 22:58:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These added interfaces lets prio_heap users lookup the top of heap item without
performing any insertion, perform removal of the topmost heap entry, and also
replacement of topmost heap entry. This is useful if one need to use the result
of the lookup to determine if the current maximum should simply be removed or if
it should be replaced.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/prio_heap.h |   44 ++++++++++++++++++++++
 lib/prio_heap.c           |   91 ++++++++++++++++++++++++++++++++++++----------
 2 files changed, 116 insertions(+), 19 deletions(-)

Index: linux.trees.git/include/linux/prio_heap.h
===================================================================
--- linux.trees.git.orig/include/linux/prio_heap.h	2010-07-06 14:25:29.000000000 -0400
+++ linux.trees.git/include/linux/prio_heap.h	2010-07-07 10:04:33.000000000 -0400
@@ -23,6 +23,18 @@ struct ptr_heap {
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
@@ -53,6 +65,38 @@ void heap_free(struct ptr_heap *heap);
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
--- linux.trees.git.orig/lib/prio_heap.c	2010-07-06 14:25:29.000000000 -0400
+++ linux.trees.git/lib/prio_heap.c	2010-07-07 10:18:32.000000000 -0400
@@ -23,12 +23,49 @@ void heap_free(struct ptr_heap *heap)
 	kfree(heap->ptrs);
 }
 
-void *heap_insert(struct ptr_heap *heap, void *p)
+static void heapify(struct ptr_heap *heap, void **ptrs, void *p, int pos)
+{
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
 	int pos;
 
+	if (!heap->size) {
+		ptrs[heap->size++] = p;
+		return NULL;
+	}
+
+	/* Replace the current max and heapify */
+	res = ptrs[0];
+	ptrs[0] = p;
+	pos = 0;
+	heapify(heap, ptrs, p, pos);
+	return res;
+}
+
+void *heap_insert(struct ptr_heap *heap, void *p)
+{
+	void **ptrs = heap->ptrs;
+	int pos;
+
 	if (heap->size < heap->max) {
 		/* Heap insertion */
 		pos = heap->size++;
@@ -47,24 +84,40 @@ void *heap_insert(struct ptr_heap *heap,
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
+		return ptrs[--heap->size];
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
+	if (heap->size == 1)
+		return ptrs[--heap->size];
+	/*
+	 * Replace p with previous last entry and heapify.
+	 */
+	ptrs[pos] = ptrs[--heap->size];
+	heapify(heap, ptrs, ptrs[pos], pos);
+	return p;
 }

