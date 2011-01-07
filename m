Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1AGWqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:46:37 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:54287 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1AGWqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:46:34 -0500
From: Satoru Moriya <satoru.moriya@hds.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mel@csn.ul.ie" <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Fri, 7 Jan 2011 17:07:06 -0500
Subject: [RFC][PATCH 2/2] Make watermarks tunable separately
Thread-Topic: [RFC][PATCH 2/2] Make watermarks tunable separately
Thread-Index: AcuutsHgFEJGwsPbT6epur3gKhhD/gAAEvjA
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A298@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C3A30A295@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces three new sysctls to /proc/sys/vm:
wmark_min_kbytes, wmark_low_kbytes and wmark_high_kbytes.

Each entry is used to compute watermark[min], watermark[low]
and watermark[high] for each zone.

These parameters are also updated when min_free_kbytes are
changed because originally they are set based on min_free_kbytes.
On the other hand, min_free_kbytes is updated when wmark_free_kbytes
changes.

By using the parameters one can adjust the difference among
watermark[min], watermark[low] and watermark[high] and as a result
one can tune the kernel reclaim behaviour to fit their requirement.

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 Documentation/sysctl/vm.txt |   37 +++++++++++++++
 include/linux/mmzone.h      |    6 ++
 kernel/sysctl.c             |   28 +++++++++++-
 mm/page_alloc.c             |  109 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 179 insertions(+), 1 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index e10b279..674681d 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -55,6 +55,9 @@ Currently, these files are in /proc/sys/vm:
 - stat_interval
 - swappiness
 - vfs_cache_pressure
+- wmark_high_kbytes
+- wmark_low_kbytes
+- wmark_min_kbytes
 - zone_reclaim_mode
 
 ==============================================================
@@ -360,6 +363,8 @@ become subtly broken, and prone to deadlock under high loads.
 
 Setting this too high will OOM your machine instantly.
 
+This is also updated when wmark_min_free_kbytes changes.
+
 =============================================================
 
 min_slab_ratio:
@@ -664,6 +669,38 @@ causes the kernel to prefer to reclaim dentries and inodes.
 
 ==============================================================
 
+wmark_high_kbytes
+
+Contains the amount of free memory above which kswapd stops reclaiming pages.
+
+The Linux VM uses this number to compute a watermark[WMARK_HIGH] value for
+each zone in the system. This is also updated when min_free_kbytes is updated.
+The minimum is wmark_low_kbytes.
+
+==============================================================
+
+wmark_low_kbytes
+
+Contains the amount of free memory below which kswapd starts to reclaim pages.
+
+The Linux VM uses this number to compute a watermark[WMARK_LOW] value for
+each zone in the system. This is also updated when min_free_kbytes changes.
+The minimum is wmark_min_kbytes and maximum is wmark_high_kbytes.
+
+==============================================================
+
+wmark_min_kbytes
+
+Contains the amount of minimum free memory which Linux VM keep. If the amount
+of free memory is less than it, the VM reclaims memory first and then
+allocates (except PF_MEMALLOC allocations).
+
+The Linux VM uses this number to compute a watermark[WMARK_MIN] value for
+each lowmem zone in the system. This is also updated when min_free_kbytes is
+updated. The minimum is 0 and maximum is wmark_low_kbytes.
+
+==============================================================
+
 zone_reclaim_mode:
 
 Zone_reclaim_mode allows someone to set more or less aggressive approaches to
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 39c24eb..d2f4b40 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -771,6 +771,12 @@ int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
 extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES-1];
 int lowmem_reserve_ratio_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
+int wmark_min_kbytes_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
+int wmark_low_kbytes_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
+int wmark_high_kbytes_sysctl_handler(struct ctl_table *, int,
+					void __user *, size_t *, loff_t *);
 int percpu_pagelist_fraction_sysctl_handler(struct ctl_table *, int,
 					void __user *, size_t *, loff_t *);
 int sysctl_min_unmapped_ratio_sysctl_handler(struct ctl_table *, int,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae5cbb1..060244d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -94,6 +94,7 @@ extern char core_pattern[];
 extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
+extern int wmark_min_kbytes, wmark_low_kbytes, wmark_high_kbytes;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
@@ -1326,7 +1327,32 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
-
+	{
+		.procname	= "wmark_min_kbytes",
+		.data		= &wmark_min_kbytes,
+		.maxlen		= sizeof(wmark_min_kbytes),
+		.mode		= 0644,
+		.proc_handler	= wmark_min_kbytes_sysctl_handler,
+		.extra1		= &zero,
+		.extra2		= &wmark_low_kbytes,
+	},
+	{
+		.procname	= "wmark_low_kbytes",
+		.data		= &wmark_low_kbytes,
+		.maxlen		= sizeof(wmark_low_kbytes),
+		.mode		= 0644,
+		.proc_handler	= wmark_low_kbytes_sysctl_handler,
+		.extra1		= &wmark_min_kbytes,
+		.extra2		= &wmark_high_kbytes,
+	},
+	{
+		.procname	= "wmark_high_kbytes",
+		.data		= &wmark_high_kbytes,
+		.maxlen		= sizeof(wmark_high_kbytes),
+		.mode		= 0644,
+		.proc_handler	= wmark_high_kbytes_sysctl_handler,
+		.extra1		= &wmark_low_kbytes,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff7e158..7cd9cbf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -172,6 +172,9 @@ static char * const zone_names[MAX_NR_ZONES] = {
 };
 
 int min_free_kbytes = 1024;
+int wmark_min_kbytes = 1024;
+int wmark_low_kbytes = 1024;
+int wmark_high_kbytes = 1024;
 
 static unsigned long __meminitdata nr_kernel_pages;
 static unsigned long __meminitdata nr_all_pages;
@@ -4926,10 +4929,77 @@ void setup_per_zone_wmarks(void)
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
+	wmark_min_kbytes = min_free_kbytes;
+	wmark_low_kbytes = min_free_kbytes + (min_free_kbytes >> 2);
+	wmark_high_kbytes = min_free_kbytes + (min_free_kbytes >> 1);
+
 	/* update totalreserve_pages */
 	calculate_totalreserve_pages();
 }
 
+/**
+ * setup_per_zone_wmark - called when wmark_{min|low|high}_kbytes changes
+ *
+ * The watermark[min,low,high] values for each zone are set with respect
+ * to wmark_min_kbytes, wmark_low_kbytes and wmark_high_kbytes.
+ */
+void setup_per_zone_wmark(int wmark)
+{
+	unsigned long pages;
+	unsigned long lowmem_pages = 0;
+	struct zone *zone;
+	unsigned long flags;
+
+	switch (wmark) {
+	case WMARK_MIN:
+		pages = wmark_min_kbytes >> (PAGE_SHIFT - 10);
+		min_free_kbytes = wmark_min_kbytes;
+		break;
+	case WMARK_LOW:
+		pages = wmark_low_kbytes >> (PAGE_SHIFT - 10);
+		break;
+	case WMARK_HIGH:
+		pages = wmark_high_kbytes >> (PAGE_SHIFT - 10);
+		break;
+	default:
+		return;
+	}
+
+	/* Calculate total number of !ZONE_HIGHMEM pages */
+	for_each_zone(zone) {
+		if (!is_highmem(zone))
+			lowmem_pages += zone->present_pages;
+	}
+
+	for_each_zone(zone) {
+		u64 tmp;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		tmp = (u64)pages * zone->present_pages;
+		do_div(tmp, lowmem_pages);
+
+		if (wmark == WMARK_MIN && is_highmem(zone)) {
+			int min_pages;
+
+			min_pages = zone->present_pages / 1024;
+			if (min_pages < SWAP_CLUSTER_MAX)
+				min_pages = SWAP_CLUSTER_MAX;
+			if (min_pages > 128)
+				min_pages = 128;
+			zone->watermark[wmark] = min_pages;
+		} else {
+			zone->watermark[wmark] = tmp;
+		}
+
+		if (wmark == WMARK_MIN)
+			setup_zone_migrate_reserve(zone);
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+	
+	if (wmark == WMARK_HIGH)
+		calculate_totalreserve_pages();
+}
+
 /*
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
@@ -5029,6 +5099,45 @@ int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	return 0;
 }
 
+int wmark_min_kbytes_sysctl_handler(ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret;
+	
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	setup_per_zone_wmark(WMARK_MIN);
+	return ret;
+}
+
+int wmark_low_kbytes_sysctl_handler(ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	setup_per_zone_wmark(WMARK_LOW);
+	return ret;
+}
+
+int wmark_high_kbytes_sysctl_handler(ctl_table *table, int write,
+	void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	setup_per_zone_wmark(WMARK_HIGH);
+	return ret;
+}
+
 #ifdef CONFIG_NUMA
 int sysctl_min_unmapped_ratio_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
-- 
1.7.1

