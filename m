Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1JMXL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:11:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:24692 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1JMXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:08:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,343,1315206000"; 
   d="scan'208";a="77927474"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/12] Don't use inline node_page_state for sysfs output functions
Date: Thu, 13 Oct 2011 16:08:49 -0700
Message-Id: <1318547332-23155-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
References: <1318547332-23155-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

These are not time critical, and using an out of line function
saves about 2.5k text on a non force inline kernel.

I left the main hotpath user -- readahead -- inline for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/base/node.c |   72 +++++++++++++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 33 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 793f796..0b8e7a2 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -58,6 +58,12 @@ static inline ssize_t node_read_cpulist(struct sys_device *dev,
 static SYSDEV_ATTR(cpumap,  S_IRUGO, node_read_cpumask, NULL);
 static SYSDEV_ATTR(cpulist, S_IRUGO, node_read_cpulist, NULL);
 
+/* Don't inline */
+static unsigned long my_node_page_state(int node, enum zone_stat_item item)
+{
+	return node_page_state(node, item);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 static ssize_t node_read_meminfo(struct sys_device * dev,
 			struct sysdev_attribute *attr, char * buf)
@@ -82,16 +88,16 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
-				node_page_state(nid, NR_ACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_ANON) +
-				node_page_state(nid, NR_INACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_ACTIVE_ANON)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
-		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
-		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
-		       nid, K(node_page_state(nid, NR_MLOCK)));
+		       nid, K(my_node_page_state(nid, NR_ACTIVE_ANON) +
+				my_node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(my_node_page_state(nid, NR_INACTIVE_ANON) +
+				my_node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(my_node_page_state(nid, NR_ACTIVE_ANON)),
+		       nid, K(my_node_page_state(nid, NR_INACTIVE_ANON)),
+		       nid, K(my_node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(my_node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(my_node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(my_node_page_state(nid, NR_MLOCK)));
 
 #ifdef CONFIG_HIGHMEM
 	n += sprintf(buf + n,
@@ -123,30 +129,30 @@ static ssize_t node_read_meminfo(struct sys_device * dev,
 		       "Node %d AnonHugePages:  %8lu kB\n"
 #endif
 			,
-		       nid, K(node_page_state(nid, NR_FILE_DIRTY)),
-		       nid, K(node_page_state(nid, NR_WRITEBACK)),
-		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
-		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)
+		       nid, K(my_node_page_state(nid, NR_FILE_DIRTY)),
+		       nid, K(my_node_page_state(nid, NR_WRITEBACK)),
+		       nid, K(my_node_page_state(nid, NR_FILE_PAGES)),
+		       nid, K(my_node_page_state(nid, NR_FILE_MAPPED)),
+		       nid, K(my_node_page_state(nid, NR_ANON_PAGES)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			+ my_node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
 			HPAGE_PMD_NR
 #endif
 		       ),
-		       nid, K(node_page_state(nid, NR_SHMEM)),
-		       nid, node_page_state(nid, NR_KERNEL_STACK) *
+		       nid, K(my_node_page_state(nid, NR_SHMEM)),
+		       nid, my_node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
-		       nid, K(node_page_state(nid, NR_PAGETABLE)),
-		       nid, K(node_page_state(nid, NR_UNSTABLE_NFS)),
-		       nid, K(node_page_state(nid, NR_BOUNCE)),
-		       nid, K(node_page_state(nid, NR_WRITEBACK_TEMP)),
-		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE) +
-				node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_RECLAIMABLE)),
-		       nid, K(node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
+		       nid, K(my_node_page_state(nid, NR_PAGETABLE)),
+		       nid, K(my_node_page_state(nid, NR_UNSTABLE_NFS)),
+		       nid, K(my_node_page_state(nid, NR_BOUNCE)),
+		       nid, K(my_node_page_state(nid, NR_WRITEBACK_TEMP)),
+		       nid, K(my_node_page_state(nid, NR_SLAB_RECLAIMABLE) +
+				my_node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
+		       nid, K(my_node_page_state(nid, NR_SLAB_RECLAIMABLE)),
+		       nid, K(my_node_page_state(nid, NR_SLAB_UNRECLAIMABLE))
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 			, nid,
-			K(node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
+			K(my_node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
 			HPAGE_PMD_NR)
 #endif
 		       );
@@ -167,12 +173,12 @@ static ssize_t node_read_numastat(struct sys_device * dev,
 		       "interleave_hit %lu\n"
 		       "local_node %lu\n"
 		       "other_node %lu\n",
-		       node_page_state(dev->id, NUMA_HIT),
-		       node_page_state(dev->id, NUMA_MISS),
-		       node_page_state(dev->id, NUMA_FOREIGN),
-		       node_page_state(dev->id, NUMA_INTERLEAVE_HIT),
-		       node_page_state(dev->id, NUMA_LOCAL),
-		       node_page_state(dev->id, NUMA_OTHER));
+		       my_node_page_state(dev->id, NUMA_HIT),
+		       my_node_page_state(dev->id, NUMA_MISS),
+		       my_node_page_state(dev->id, NUMA_FOREIGN),
+		       my_node_page_state(dev->id, NUMA_INTERLEAVE_HIT),
+		       my_node_page_state(dev->id, NUMA_LOCAL),
+		       my_node_page_state(dev->id, NUMA_OTHER));
 }
 static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
-- 
1.7.4.4

