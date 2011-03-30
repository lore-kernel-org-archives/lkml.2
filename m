Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab1C3FbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 01:31:13 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42641 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1C3FbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 01:31:11 -0400
Subject: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA (v5)
To: linux-mm@kvack.org, akpm@linux-foundation.org
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: npiggin@kernel.dk, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com
Date: Wed, 30 Mar 2011 11:01:04 +0530
Message-ID: <20110330053035.8212.64105.stgit@localhost6.localdomain6>
In-Reply-To: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves zone_reclaim and associated helpers
outside CONFIG_NUMA. This infrastructure is reused
in the patches for page cache control that follow.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
---
 include/linux/mmzone.h |    4 ++--
 include/linux/swap.h   |    4 ++--
 kernel/sysctl.c        |   16 ++++++++--------
 mm/page_alloc.c        |    6 +++---
 mm/vmscan.c            |    2 --
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 628f07b..59cbed0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -306,12 +306,12 @@ struct zone {
 	 */
 	unsigned long		lowmem_reserve[MAX_NR_ZONES];
 
-#ifdef CONFIG_NUMA
-	int node;
 	/*
 	 * zone reclaim becomes active if more unmapped pages exist.
 	 */
 	unsigned long		min_unmapped_pages;
+#ifdef CONFIG_NUMA
+	int node;
 	unsigned long		min_slab_pages;
 #endif
 	struct per_cpu_pageset __percpu *pageset;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index ed6ebe6..ce8f686 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -264,11 +264,11 @@ extern int vm_swappiness;
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
+extern int sysctl_min_unmapped_ratio;
+extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
 #ifdef CONFIG_NUMA
 extern int zone_reclaim_mode;
-extern int sysctl_min_unmapped_ratio;
 extern int sysctl_min_slab_ratio;
-extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
 #else
 #define zone_reclaim_mode 0
 static inline int zone_reclaim(struct zone *z, gfp_t mask, unsigned int order)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 927fc5a..e3a8ce4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1214,14 +1214,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec_unsigned,
 	},
 #endif
-#ifdef CONFIG_NUMA
-	{
-		.procname	= "zone_reclaim_mode",
-		.data		= &zone_reclaim_mode,
-		.maxlen		= sizeof(zone_reclaim_mode),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_unsigned,
-	},
 	{
 		.procname	= "min_unmapped_ratio",
 		.data		= &sysctl_min_unmapped_ratio,
@@ -1231,6 +1223,14 @@ static struct ctl_table vm_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+#ifdef CONFIG_NUMA
+	{
+		.procname	= "zone_reclaim_mode",
+		.data		= &zone_reclaim_mode,
+		.maxlen		= sizeof(zone_reclaim_mode),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_unsigned,
+	},
 	{
 		.procname	= "min_slab_ratio",
 		.data		= &sysctl_min_slab_ratio,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e1b52a..1d32865 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4249,10 +4249,10 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 
 		zone->spanned_pages = size;
 		zone->present_pages = realsize;
-#ifdef CONFIG_NUMA
-		zone->node = nid;
 		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
 						/ 100;
+#ifdef CONFIG_NUMA
+		zone->node = nid;
 		zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
 #endif
 		zone->name = zone_names[j];
@@ -5157,7 +5157,6 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
-#ifdef CONFIG_NUMA
 int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
@@ -5174,6 +5173,7 @@ int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
+#ifdef CONFIG_NUMA
 int sysctl_min_slab_ratio_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 060e4c1..4923160 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2874,7 +2874,6 @@ static int __init kswapd_init(void)
 
 module_init(kswapd_init)
 
-#ifdef CONFIG_NUMA
 /*
  * Zone reclaim mode
  *
@@ -3084,7 +3083,6 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	return ret;
 }
-#endif
 
 /*
  * page_evictable - test whether a page is evictable

