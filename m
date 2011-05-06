Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab1EFSHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:07:08 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:23120 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756040Ab1EFSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:07:05 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: fPkICmQVM1m2ctMmM8GWNfxDCKbI7v6g7k8C4UWGNoUdH6K
 FdEWxxJVsSPJRfo8_bp8rESHXZkchUfkF7nRA1.u.t6OUAilNIylUBFBdn7i
 1Ymbl4mzK57dX5HPs7z1fWi5QgzVJjXRWF0vv6J7maKii_kckxlHR7k18e0t
 4n._44fUUOVvmcudFj__9QfAOhbUIY76rBvxw6NNLTnL5GEHJML.ZLq3nmAs
 PHPNzXKJDWQsUG2KGrbpuGCsreHWprVC6.CfNSL0bAp7h.coXD5ySbwrRQGI
 9XhE95O4YJwDvshClilA88nlRne6WtJ_cXCNdfRE5BokpanWhmKYx5iu4T5B
 a8xSJbc_UaRJTedcUFGEkXA--
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180703.511754976@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:57 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 16/16] slub: update statistics for cmpxchg handling
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=statfixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the statistics handling and the slabinfo tool to include the new
statistics in the reports it generates.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/slub_def.h |    2 +
 mm/slub.c                |   12 ++++++++-
 tools/slub/slabinfo.c    |   57 ++++++++++++++++++++++++++++++++---------------
 3 files changed, 51 insertions(+), 20 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-06 12:54:31.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-06 12:57:25.000000000 -0500
@@ -24,6 +24,7 @@ enum stat_item {
 	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from partial list */
 	ALLOC_SLAB,		/* Cpu slab acquired from page allocator */
 	ALLOC_REFILL,		/* Refill cpu slab from slab freelist */
+	ALLOC_NODE_MISMATCH,	/* Switching cpu slab */
 	FREE_SLAB,		/* Slab freed to the page allocator */
 	CPUSLAB_FLUSH,		/* Abandoning of the cpu slab */
 	DEACTIVATE_FULL,	/* Cpu slab was full when deactivated */
@@ -31,6 +32,7 @@ enum stat_item {
 	DEACTIVATE_TO_HEAD,	/* Cpu slab was moved to the head of partials */
 	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
+	DEACTIVATE_BYPASS,	/* Implicit deactivation */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
 	CMPXCHG_DOUBLE_CPU_FAIL,/* Failure of this_cpu_cmpxchg_double */
 	CMPXCHG_DOUBLE_FAIL,	/* Number of times that cmpxchg double did not match */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-06 12:57:10.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-06 12:57:25.000000000 -0500
@@ -1774,6 +1774,7 @@ redo:
 		spin_unlock(&n->list_lock);
 
 	if (m == M_FREE) {
+		stat(s, DEACTIVATE_EMPTY);
 		discard_slab(s, page);
 		stat(s, FREE_SLAB);
 	}
@@ -1929,12 +1930,12 @@ static void *__slab_alloc(struct kmem_ca
 		goto new_slab;
 
 	if (unlikely(!node_match(c, node))) {
+		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
 		goto new_slab;
 	}
 
-	stat(s, ALLOC_REFILL);
-
+	stat(s, ALLOC_SLOWPATH);
 	{
 		struct page new;
 		unsigned long counters;
@@ -1966,9 +1967,12 @@ static void *__slab_alloc(struct kmem_ca
 
 	if (unlikely(!object)) {
 		c->page = NULL;
+		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
 	}
 
+	stat(s, ALLOC_REFILL);
+
 load_freelist:
 	VM_BUG_ON(!page->frozen);
 	c->freelist = get_freepointer(s, object);
@@ -4671,6 +4675,7 @@ STAT_ATTR(FREE_REMOVE_PARTIAL, free_remo
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
 STAT_ATTR(ALLOC_REFILL, alloc_refill);
+STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
 STAT_ATTR(FREE_SLAB, free_slab);
 STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
@@ -4678,6 +4683,7 @@ STAT_ATTR(DEACTIVATE_EMPTY, deactivate_e
 STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
 STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
+STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
 STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
@@ -4730,6 +4736,7 @@ static struct attribute *slab_attrs[] =
 	&alloc_from_partial_attr.attr,
 	&alloc_slab_attr.attr,
 	&alloc_refill_attr.attr,
+	&alloc_node_mismatch_attr.attr,
 	&free_slab_attr.attr,
 	&cpuslab_flush_attr.attr,
 	&deactivate_full_attr.attr,
@@ -4737,6 +4744,7 @@ static struct attribute *slab_attrs[] =
 	&deactivate_to_head_attr.attr,
 	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
+	&deactivate_bypass_attr.attr,
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
 	&cmpxchg_double_cpu_fail_attr.attr,
Index: linux-2.6/tools/slub/slabinfo.c
===================================================================
--- linux-2.6.orig/tools/slub/slabinfo.c	2011-05-06 12:41:41.000000000 -0500
+++ linux-2.6/tools/slub/slabinfo.c	2011-05-06 12:57:25.000000000 -0500
@@ -2,8 +2,9 @@
  * Slabinfo: Tool to get reports about slabs
  *
  * (C) 2007 sgi, Christoph Lameter
+ * (C) 2011 Linux Foundation, Christoph Lameter
  *
- * Compile by:
+ * Compile with:
  *
  * gcc -o slabinfo slabinfo.c
  */
@@ -39,6 +40,8 @@ struct slabinfo {
 	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
 	unsigned long deactivate_to_head, deactivate_to_tail;
 	unsigned long deactivate_remote_frees, order_fallback;
+	unsigned long cmpxchg_double_cpu_fail, cmpxchg_double_fail;
+	unsigned long alloc_node_mismatch, deactivate_bypass;
 	int numa[MAX_NODES];
 	int numa_partial[MAX_NODES];
 } slabinfo[MAX_SLABS];
@@ -99,7 +102,7 @@ static void fatal(const char *x, ...)
 
 static void usage(void)
 {
-	printf("slabinfo 5/7/2007. (c) 2007 sgi.\n\n"
+	printf("slabinfo 4/15/2011. (c) 2007 sgi/(c) 2011 Linux Foundation.\n\n"
 		"slabinfo [-ahnpvtsz] [-d debugopts] [slab-regexp]\n"
 		"-a|--aliases           Show aliases\n"
 		"-A|--activity          Most active slabs first\n"
@@ -293,7 +296,7 @@ int line = 0;
 static void first_line(void)
 {
 	if (show_activity)
-		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O\n");
+		printf("Name                   Objects      Alloc       Free   %%Fast Fallb O CmpX   UL\n");
 	else
 		printf("Name                   Objects Objsize    Space "
 			"Slabs/Part/Cpu  O/S O %%Fr %%Ef Flg\n");
@@ -379,14 +382,14 @@ static void show_tracking(struct slabinf
 	printf("\n%s: Kernel object allocation\n", s->name);
 	printf("-----------------------------------------------------------------------\n");
 	if (read_slab_obj(s, "alloc_calls"))
-		printf(buffer);
+		printf("%s", buffer);
 	else
 		printf("No Data\n");
 
 	printf("\n%s: Kernel object freeing\n", s->name);
 	printf("------------------------------------------------------------------------\n");
 	if (read_slab_obj(s, "free_calls"))
-		printf(buffer);
+		printf("%s", buffer);
 	else
 		printf("No Data\n");
 
@@ -400,7 +403,7 @@ static void ops(struct slabinfo *s)
 	if (read_slab_obj(s, "ops")) {
 		printf("\n%s: kmem_cache operations\n", s->name);
 		printf("--------------------------------------------\n");
-		printf(buffer);
+		printf("%s", buffer);
 	} else
 		printf("\n%s has no kmem_cache operations\n", s->name);
 }
@@ -462,19 +465,32 @@ static void slab_stats(struct slabinfo *
 	if (s->cpuslab_flush)
 		printf("Flushes %8lu\n", s->cpuslab_flush);
 
-	if (s->alloc_refill)
-		printf("Refill %8lu\n", s->alloc_refill);
-
 	total = s->deactivate_full + s->deactivate_empty +
-			s->deactivate_to_head + s->deactivate_to_tail;
+			s->deactivate_to_head + s->deactivate_to_tail + s->deactivate_bypass;
 
-	if (total)
-		printf("Deactivate Full=%lu(%lu%%) Empty=%lu(%lu%%) "
-			"ToHead=%lu(%lu%%) ToTail=%lu(%lu%%)\n",
-			s->deactivate_full, (s->deactivate_full * 100) / total,
-			s->deactivate_empty, (s->deactivate_empty * 100) / total,
-			s->deactivate_to_head, (s->deactivate_to_head * 100) / total,
+	if (total) {
+		printf("\nSlab Deactivation             Ocurrences  %%\n");
+		printf("-------------------------------------------------\n");
+		printf("Slab full                     %7lu  %3lu%%\n",
+			s->deactivate_full, (s->deactivate_full * 100) / total);
+		printf("Slab empty                    %7lu  %3lu%%\n",
+			s->deactivate_empty, (s->deactivate_empty * 100) / total);
+		printf("Moved to head of partial list %7lu  %3lu%%\n",
+			s->deactivate_to_head, (s->deactivate_to_head * 100) / total);
+		printf("Moved to tail of partial list %7lu  %3lu%%\n",
 			s->deactivate_to_tail, (s->deactivate_to_tail * 100) / total);
+		printf("Deactivation bypass           %7lu  %3lu%%\n",
+			s->deactivate_bypass, (s->deactivate_bypass * 100) / total);
+		printf("Refilled from foreign frees   %7lu  %3lu%%\n",
+			s->alloc_refill, (s->alloc_refill * 100) / total);
+		printf("Node mismatch                 %7lu  %3lu%%\n",
+			s->alloc_node_mismatch, (s->alloc_node_mismatch * 100) / total);
+	}
+
+	if (s->cmpxchg_double_fail || s->cmpxchg_double_cpu_fail)
+		printf("\nCmpxchg_double Looping\n------------------------\n");
+		printf("Locked Cmpxchg Double redos   %lu\nUnlocked Cmpxchg Double redos %lu\n",
+			s->cmpxchg_double_fail, s->cmpxchg_double_cpu_fail);
 }
 
 static void report(struct slabinfo *s)
@@ -573,12 +589,13 @@ static void slabcache(struct slabinfo *s
 		total_alloc = s->alloc_fastpath + s->alloc_slowpath;
 		total_free = s->free_fastpath + s->free_slowpath;
 
-		printf("%-21s %8ld %10ld %10ld %3ld %3ld %5ld %1d\n",
+		printf("%-21s %8ld %10ld %10ld %3ld %3ld %5ld %1d %4ld %4ld\n",
 			s->name, s->objects,
 			total_alloc, total_free,
 			total_alloc ? (s->alloc_fastpath * 100 / total_alloc) : 0,
 			total_free ? (s->free_fastpath * 100 / total_free) : 0,
-			s->order_fallback, s->order);
+			s->order_fallback, s->order, s->cmpxchg_double_fail,
+			s->cmpxchg_double_cpu_fail);
 	}
 	else
 		printf("%-21s %8ld %7d %8s %14s %4d %1d %3ld %3ld %s\n",
@@ -1190,6 +1207,10 @@ static void read_slab_dir(void)
 			slab->deactivate_to_tail = get_obj("deactivate_to_tail");
 			slab->deactivate_remote_frees = get_obj("deactivate_remote_frees");
 			slab->order_fallback = get_obj("order_fallback");
+			slab->cmpxchg_double_cpu_fail = get_obj("cmpxchg_double_cpu_fail");
+			slab->cmpxchg_double_fail = get_obj("cmpxchg_double_fail");
+			slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
+			slab->deactivate_bypass = get_obj("deactivate_bypass");
 			chdir("..");
 			if (slab->name[0] == ':')
 				alias_targets++;

