Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab1DKLKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:10:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48810 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1DKLKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:10:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH] mm: per-node vmstat show proper vmstats
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20110411201015.F5BC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon, 11 Apr 2011 20:10:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2ac390370a (writeback: add /sys/devices/system/node/<node>/vmstat)
added vmstat entry. But strangely it only show nr_written and nr_dirtied.

        # cat /sys/devices/system/node/node20/vmstat
        nr_written 0
        nr_dirtied 0

Of cource, It's no adequate. With this patch, the vmstat show
all vm stastics as /proc/vmstat.

        # cat /sys/devices/system/node/node0/vmstat
	nr_free_pages 899224
	nr_inactive_anon 201
	nr_active_anon 17380
	nr_inactive_file 31572
	nr_active_file 28277
	nr_unevictable 0
	nr_mlock 0
	nr_anon_pages 17321
	nr_mapped 8640
	nr_file_pages 60107
	nr_dirty 33
	nr_writeback 0
	nr_slab_reclaimable 6850
	nr_slab_unreclaimable 7604
	nr_page_table_pages 3105
	nr_kernel_stack 175
	nr_unstable 0
	nr_bounce 0
	nr_vmscan_write 0
	nr_writeback_temp 0
	nr_isolated_anon 0
	nr_isolated_file 0
	nr_shmem 260
	nr_dirtied 1050
	nr_written 938
	numa_hit 962872
	numa_miss 0
	numa_foreign 0
	numa_interleave 8617
	numa_local 962872
	numa_other 0
	nr_anon_transparent_hugepages 0

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Rubin <mrubin@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/base/node.c |   15 ++++++++++-----
 mm/vmstat.c         |    2 +-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index b3b72d6..3fc5f28 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -175,15 +175,20 @@ static ssize_t node_read_numastat(struct sys_device * dev,
 }
 static SYSDEV_ATTR(numastat, S_IRUGO, node_read_numastat, NULL);
 
+extern const char * const vmstat_text[];
+
 static ssize_t node_read_vmstat(struct sys_device *dev,
 				struct sysdev_attribute *attr, char *buf)
 {
 	int nid = dev->id;
-	return sprintf(buf,
-		"nr_written %lu\n"
-		"nr_dirtied %lu\n",
-		node_page_state(nid, NR_WRITTEN),
-		node_page_state(nid, NR_DIRTIED));
+	int i;
+	int n = 0;
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		n += sprintf(buf+n, "%s %lu\n", vmstat_text[i],
+			     node_page_state(nid, i));
+
+	return n;
 }
 static SYSDEV_ATTR(vmstat, S_IRUGO, node_read_vmstat, NULL);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 897ea9e..0000aad 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -852,7 +852,7 @@ static const struct file_operations pagetypeinfo_file_ops = {
 #define TEXTS_FOR_ZONES(xx) TEXT_FOR_DMA(xx) TEXT_FOR_DMA32(xx) xx "_normal", \
 					TEXT_FOR_HIGHMEM(xx) xx "_movable",
 
-static const char * const vmstat_text[] = {
+const char * const vmstat_text[] = {
 	/* Zoned VM counters */
 	"nr_free_pages",
 	"nr_inactive_anon",
-- 
1.7.3.1



