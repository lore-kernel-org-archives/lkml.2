Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1IBQ0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 12:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab1IBQ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 12:26:42 -0400
Date: Fri, 2 Sep 2011 12:26:02 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Satoru Moriya <smoriya@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, lwoodman@redhat.com,
        Seiji Aguchi <saguchi@redhat.com>, hughd@google.com,
        hannes@cmpxchg.org
Subject: [PATCH -mm] fixes & cleanups for "add extra free kbytes tunable"
Message-ID: <20110902122602.6f7c1238@annuminas.surriel.com>
In-Reply-To: <20110901150901.48d92bc2.akpm@linux-foundation.org>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<20110901150901.48d92bc2.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the fixes suggested by Andrew Morton.   Not much of a changelog
since the patch should probably be folded into
mm-add-extra-free-kbytes-tunable.patch

Thank you for pointing these out, Andrew.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 include/linux/mmzone.h |    2 +-
 include/linux/swap.h   |    2 ++
 kernel/sysctl.c        |    6 ++----
 mm/page_alloc.c        |   13 +++++++------
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be1ac8d..7013bab 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -772,7 +772,7 @@ static inline int is_dma(struct zone *zone)
 
 /* These two functions are used to setup the per zone pages min values */
 struct ctl_table;
-int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
+int free_kbytes_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 14d6249..0679ed5 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -207,6 +207,8 @@ struct swap_list_t {
 /* linux/mm/page_alloc.c */
 extern unsigned long totalram_pages;
 extern unsigned long totalreserve_pages;
+extern int min_free_kbytes;
+extern int extra_free_kbytes;
 extern unsigned int nr_free_buffer_pages(void);
 extern unsigned int nr_free_pagecache_pages(void);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 01a9acd..a3a015c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -95,8 +95,6 @@ extern int suid_dumpable;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 extern int pid_max;
-extern int min_free_kbytes;
-extern int extra_free_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
@@ -1186,7 +1184,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &min_free_kbytes,
 		.maxlen		= sizeof(min_free_kbytes),
 		.mode		= 0644,
-		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.proc_handler	= free_kbytes_sysctl_handler,
 		.extra1		= &zero,
 	},
 	{
@@ -1194,7 +1192,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &extra_free_kbytes,
 		.maxlen		= sizeof(extra_free_kbytes),
 		.mode		= 0644,
-		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.proc_handler	= free_kbytes_sysctl_handler,
 		.extra1		= &zero,
 	},
 	{
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47d185c..14fc9e9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -183,11 +183,12 @@ static char * const zone_names[MAX_NR_ZONES] = {
 int min_free_kbytes = 1024;
 
 /*
- * Extra memory for the system to try freeing. Used to temporarily
- * free memory, to make space for new workloads. Anyone can allocate
- * down to the min watermarks controlled by min_free_kbytes above.
+ * Extra memory for the system to try freeing between the min and
+ * low watermarks.  Useful for workloads that require low latency
+ * memory allocations in bursts larger than the normal gap between
+ * low and min.
  */
-int extra_free_kbytes = 0;
+int extra_free_kbytes;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
@@ -5280,11 +5281,11 @@ int __meminit init_per_zone_wmark_min(void)
 module_init(init_per_zone_wmark_min)
 
 /*
- * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
+ * free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
  *	that we can call two helper functions whenever min_free_kbytes
  *	or extra_free_kbytes changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
+int free_kbytes_sysctl_handler(ctl_table *table, int write, 
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);

