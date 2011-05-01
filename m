Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1EAHrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 03:47:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39423 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1EAHrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 03:47:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: mmotm 2011-04-29-16-25 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20110430094616.1fd43735.rdunlap@xenotime.net>
References: <201104300002.p3U02Ma2026266@imap1.linux-foundation.org> <20110430094616.1fd43735.rdunlap@xenotime.net>
Message-Id: <20110501164918.75E0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Sun,  1 May 2011 16:47:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 29 Apr 2011 16:26:16 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2011-04-29-16-25 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > It contains the following patches against 2.6.39-rc5:
> 
> 
> mm-per-node-vmstat-show-proper-vmstats.patch
> 
> when CONFIG_PROC_FS is not enabled:
> 
> drivers/built-in.o: In function `node_read_vmstat':
> node.c:(.text+0x1e995): undefined reference to `vmstat_text'
> 
> from drivers/base/node.c


Thank you for finding that!



>From 63ad7c06f082f8423c033b9f54070e14d561db7e Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 1 May 2011 16:00:09 +0900
Subject: [PATCH] vmstat: fix build error when SYSFS=y and PROC_FS=n

Randy Dunlap pointed out node.c makes build error when
PROC_FS=n. Because node.c#node_read_vmstat() uses vmstat_text
and it depend on PROC_FS.

Thus, this patch change it to depend both SYSFS and PROC_FS.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmstat.c |  261 ++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 132 insertions(+), 129 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index a2b7344..20c18b7 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -659,6 +659,138 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
 }
 #endif
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSFS)
+#ifdef CONFIG_ZONE_DMA
+#define TEXT_FOR_DMA(xx) xx "_dma",
+#else
+#define TEXT_FOR_DMA(xx)
+#endif
+
+#ifdef CONFIG_ZONE_DMA32
+#define TEXT_FOR_DMA32(xx) xx "_dma32",
+#else
+#define TEXT_FOR_DMA32(xx)
+#endif
+
+#ifdef CONFIG_HIGHMEM
+#define TEXT_FOR_HIGHMEM(xx) xx "_high",
+#else
+#define TEXT_FOR_HIGHMEM(xx)
+#endif
+
+#define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
+					TEXT_FOR_HIGHMEM(xx) xx "_movable",
+
+const char * const vmstat_text[] = {
+	/* Zoned VM counters */
+	"nr_free_pages",
+	"nr_inactive_anon",
+	"nr_active_anon",
+	"nr_inactive_file",
+	"nr_active_file",
+	"nr_unevictable",
+	"nr_mlock",
+	"nr_anon_pages",
+	"nr_mapped",
+	"nr_file_pages",
+	"nr_dirty",
+	"nr_writeback",
+	"nr_slab_reclaimable",
+	"nr_slab_unreclaimable",
+	"nr_page_table_pages",
+	"nr_kernel_stack",
+	"nr_unstable",
+	"nr_bounce",
+	"nr_vmscan_write",
+	"nr_writeback_temp",
+	"nr_isolated_anon",
+	"nr_isolated_file",
+	"nr_shmem",
+	"nr_dirtied",
+	"nr_written",
+
+#ifdef CONFIG_NUMA
+	"numa_hit",
+	"numa_miss",
+	"numa_foreign",
+	"numa_interleave",
+	"numa_local",
+	"numa_other",
+#endif
+	"nr_anon_transparent_hugepages",
+	"nr_dirty_threshold",
+	"nr_dirty_background_threshold",
+
+#ifdef CONFIG_VM_EVENT_COUNTERS
+	"pgpgin",
+	"pgpgout",
+	"pswpin",
+	"pswpout",
+
+	TEXTS_FOR_ZONES("pgalloc")
+
+	"pgfree",
+	"pgactivate",
+	"pgdeactivate",
+
+	"pgfault",
+	"pgmajfault",
+
+	TEXTS_FOR_ZONES("pgrefill")
+	TEXTS_FOR_ZONES("pgsteal")
+	TEXTS_FOR_ZONES("pgscan_kswapd")
+	TEXTS_FOR_ZONES("pgscan_direct")
+
+#ifdef CONFIG_NUMA
+	"zone_reclaim_failed",
+#endif
+	"pginodesteal",
+	"slabs_scanned",
+	"kswapd_steal",
+	"kswapd_inodesteal",
+	"kswapd_low_wmark_hit_quickly",
+	"kswapd_high_wmark_hit_quickly",
+	"kswapd_skip_congestion_wait",
+	"pageoutrun",
+	"allocstall",
+
+	"pgrotated",
+
+#ifdef CONFIG_COMPACTION
+	"compact_blocks_moved",
+	"compact_pages_moved",
+	"compact_pagemigrate_failed",
+	"compact_stall",
+	"compact_fail",
+	"compact_success",
+#endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+	"htlb_buddy_alloc_success",
+	"htlb_buddy_alloc_fail",
+#endif
+	"unevictable_pgs_culled",
+	"unevictable_pgs_scanned",
+	"unevictable_pgs_rescued",
+	"unevictable_pgs_mlocked",
+	"unevictable_pgs_munlocked",
+	"unevictable_pgs_cleared",
+	"unevictable_pgs_stranded",
+	"unevictable_pgs_mlockfreed",
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	"thp_fault_alloc",
+	"thp_fault_fallback",
+	"thp_collapse_alloc",
+	"thp_collapse_alloc_failed",
+	"thp_split",
+#endif
+
+#endif /* CONFIG_VM_EVENTS_COUNTERS */
+};
+#endif /* CONFIG_PROC_FS || CONFIG_SYSFS */
+
+
 #ifdef CONFIG_PROC_FS
 static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
 						struct zone *zone)
@@ -831,135 +963,6 @@ static const struct file_operations pagetypeinfo_file_ops = {
 	.release	= seq_release,
 };
 
-#ifdef CONFIG_ZONE_DMA
-#define TEXT_FOR_DMA(xx) xx "_dma",
-#else
-#define TEXT_FOR_DMA(xx)
-#endif
-
-#ifdef CONFIG_ZONE_DMA32
-#define TEXT_FOR_DMA32(xx) xx "_dma32",
-#else
-#define TEXT_FOR_DMA32(xx)
-#endif
-
-#ifdef CONFIG_HIGHMEM
-#define TEXT_FOR_HIGHMEM(xx) xx "_high",
-#else
-#define TEXT_FOR_HIGHMEM(xx)
-#endif
-
-#define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
-					TEXT_FOR_HIGHMEM(xx) xx "_movable",
-
-const char * const vmstat_text[] = {
-	/* Zoned VM counters */
-	"nr_free_pages",
-	"nr_inactive_anon",
-	"nr_active_anon",
-	"nr_inactive_file",
-	"nr_active_file",
-	"nr_unevictable",
-	"nr_mlock",
-	"nr_anon_pages",
-	"nr_mapped",
-	"nr_file_pages",
-	"nr_dirty",
-	"nr_writeback",
-	"nr_slab_reclaimable",
-	"nr_slab_unreclaimable",
-	"nr_page_table_pages",
-	"nr_kernel_stack",
-	"nr_unstable",
-	"nr_bounce",
-	"nr_vmscan_write",
-	"nr_writeback_temp",
-	"nr_isolated_anon",
-	"nr_isolated_file",
-	"nr_shmem",
-	"nr_dirtied",
-	"nr_written",
-
-#ifdef CONFIG_NUMA
-	"numa_hit",
-	"numa_miss",
-	"numa_foreign",
-	"numa_interleave",
-	"numa_local",
-	"numa_other",
-#endif
-	"nr_anon_transparent_hugepages",
-	"nr_dirty_threshold",
-	"nr_dirty_background_threshold",
-
-#ifdef CONFIG_VM_EVENT_COUNTERS
-	"pgpgin",
-	"pgpgout",
-	"pswpin",
-	"pswpout",
-
-	TEXTS_FOR_ZONES("pgalloc")
-
-	"pgfree",
-	"pgactivate",
-	"pgdeactivate",
-
-	"pgfault",
-	"pgmajfault",
-
-	TEXTS_FOR_ZONES("pgrefill")
-	TEXTS_FOR_ZONES("pgsteal")
-	TEXTS_FOR_ZONES("pgscan_kswapd")
-	TEXTS_FOR_ZONES("pgscan_direct")
-
-#ifdef CONFIG_NUMA
-	"zone_reclaim_failed",
-#endif
-	"pginodesteal",
-	"slabs_scanned",
-	"kswapd_steal",
-	"kswapd_inodesteal",
-	"kswapd_low_wmark_hit_quickly",
-	"kswapd_high_wmark_hit_quickly",
-	"kswapd_skip_congestion_wait",
-	"pageoutrun",
-	"allocstall",
-
-	"pgrotated",
-
-#ifdef CONFIG_COMPACTION
-	"compact_blocks_moved",
-	"compact_pages_moved",
-	"compact_pagemigrate_failed",
-	"compact_stall",
-	"compact_fail",
-	"compact_success",
-#endif
-
-#ifdef CONFIG_HUGETLB_PAGE
-	"htlb_buddy_alloc_success",
-	"htlb_buddy_alloc_fail",
-#endif
-	"unevictable_pgs_culled",
-	"unevictable_pgs_scanned",
-	"unevictable_pgs_rescued",
-	"unevictable_pgs_mlocked",
-	"unevictable_pgs_munlocked",
-	"unevictable_pgs_cleared",
-	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	"thp_fault_alloc",
-	"thp_fault_fallback",
-	"thp_collapse_alloc",
-	"thp_collapse_alloc_failed",
-	"thp_split",
-#endif
-
-#endif /* CONFIG_VM_EVENTS_COUNTERS */
-};
-
 static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 							struct zone *zone)
 {
-- 
1.7.3.1




