Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241Ab1EZSPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:15:15 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:22324 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933212Ab1EZSPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ay64YC4VM1nrdDrtBwgVvnOYQ4YfUlfgg8GzxlkIYLxIrI5
 RsDMIREIGCCToCW5XcqZfkaf3BjJHCP8Hidw_NQOqszgDzOi_aD50e16kYae
 DV7R2V8WDWJmJBuVUhxNF_j.BMsxAxCB3_YpRCaBloCRuM.D429EtTJJjHMh
 gcXKlozVp0BYd6UqyKtqt1298v3YndxRMmWgQ5SmDd_TEAHsKOiv7dtnOkTK
 wUWkUJjC3q552rr8AkYXFNE.OfNiV5_ZrEyB74hcfVigFq1JyVc5tVOluHjZ
 LYNwc7wDYXAffdrHWLe7.GdcE1u7xdYxFujPwh1Xzw6KqDgs7t0YC2mDGV3t
 XYqXXgf.tzOF3UckrWuOmKcUc
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181511.179895767@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:59 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 17/17] slub: slabinfo update for cmpxchg handling
References: <20110526181442.789868308@linux.com>
Content-Disposition: inline; filename=update_slabinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the statistics handling and the slabinfo tool to include the new
statistics in the reports it generates.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 tools/slub/slabinfo.c |   57 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 18 deletions(-)

Index: linux-2.6/tools/slub/slabinfo.c
===================================================================
--- linux-2.6.orig/tools/slub/slabinfo.c	2011-05-24 09:36:51.534876607 -0500
+++ linux-2.6/tools/slub/slabinfo.c	2011-05-24 09:41:18.114874899 -0500
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

