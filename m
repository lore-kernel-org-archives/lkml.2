Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0CWMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:25:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53476 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0CWMZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:25:53 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 08/11] Add /proc trigger for memory compaction
Date: Tue, 23 Mar 2010 12:25:43 +0000
Message-Id: <1269347146-7461-9-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proc file /proc/sys/vm/compact_memory. When an arbitrary
value is written to the file, all zones are compacted. The expected user
of such a trigger is a job scheduler that prepares the system before the
target application runs.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 Documentation/sysctl/vm.txt |   11 ++++++++
 include/linux/compaction.h  |    6 ++++
 kernel/sysctl.c             |   10 +++++++
 mm/compaction.c             |   61 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 88 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
index 6c7d18c..317d3f0 100644
--- a/Documentation/sysctl/vm.txt
+++ b/Documentation/sysctl/vm.txt
@@ -19,6 +19,7 @@ files can be found in mm/swap.c.
 Currently, these files are in /proc/sys/vm:
 
 - block_dump
+- compact_memory
 - dirty_background_bytes
 - dirty_background_ratio
 - dirty_bytes
@@ -64,6 +65,16 @@ information on block I/O debugging is in Documentation/laptops/laptop-mode.txt.
 
 ==============================================================
 
+compact_memory
+
+Available only when CONFIG_COMPACTION is set. When an arbitrary value
+is written to the file, all zones are compacted such that free memory
+is available in contiguous blocks where possible. This can be important
+for example in the allocation of huge pages although processes will also
+directly compact memory as required.
+
+==============================================================
+
 dirty_background_bytes
 
 Contains the amount of dirty memory at which the pdflush background writeback
diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 6201371..52762d2 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -5,4 +5,10 @@
 #define COMPACT_INCOMPLETE	0
 #define COMPACT_COMPLETE	1
 
+#ifdef CONFIG_COMPACTION
+extern int sysctl_compact_memory;
+extern int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos);
+#endif /* CONFIG_COMPACTION */
+
 #endif /* _LINUX_COMPACTION_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1de111d..05cfee8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -52,6 +52,7 @@
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
+#include <linux/compaction.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -1124,6 +1125,15 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
 	},
+#ifdef CONFIG_COMPACTION
+	{
+		.procname	= "compact_memory",
+		.data		= &sysctl_compact_memory,
+		.maxlen		= sizeof(int),
+		.mode		= 0200,
+		.proc_handler	= sysctl_compaction_handler,
+	},
+#endif /* CONFIG_COMPACTION */
 	{
 		.procname	= "min_free_kbytes",
 		.data		= &min_free_kbytes,
diff --git a/mm/compaction.c b/mm/compaction.c
index 0d2e8aa..faa9b53 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -11,6 +11,7 @@
 #include <linux/migrate.h>
 #include <linux/compaction.h>
 #include <linux/mm_inline.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 
 /*
@@ -346,3 +347,63 @@ static int compact_zone(struct zone *zone, struct compact_control *cc)
 	return ret;
 }
 
+/* Compact all zones within a node */
+static int compact_node(int nid)
+{
+	int zoneid;
+	pg_data_t *pgdat;
+	struct zone *zone;
+
+	if (nid < 0 || nid > nr_node_ids || !node_online(nid))
+		return -EINVAL;
+	pgdat = NODE_DATA(nid);
+
+	/* Flush pending updates to the LRU lists */
+	lru_add_drain_all();
+
+	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
+		struct compact_control cc;
+
+		zone = &pgdat->node_zones[zoneid];
+		if (!populated_zone(zone))
+			continue;
+
+		cc.nr_freepages = 0;
+		cc.nr_migratepages = 0;
+		cc.zone = zone;
+		cc.order = -1;
+		INIT_LIST_HEAD(&cc.freepages);
+		INIT_LIST_HEAD(&cc.migratepages);
+
+		compact_zone(zone, &cc);
+
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
+	}
+
+	return 0;
+}
+
+/* Compact all nodes in the system */
+static int compact_nodes(void)
+{
+	int nid;
+
+	for_each_online_node(nid)
+		compact_node(nid);
+
+	return COMPACT_COMPLETE;
+}
+
+/* The written value is actually unused, all memory is compacted */
+int sysctl_compact_memory;
+
+/* This is the entry point for compacting all nodes via /proc/sys/vm */
+int sysctl_compaction_handler(struct ctl_table *table, int write,
+			void __user *buffer, size_t *length, loff_t *ppos)
+{
+	if (write)
+		return compact_nodes();
+
+	return 0;
+}
-- 
1.6.5

