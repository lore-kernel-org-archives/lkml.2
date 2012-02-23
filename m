Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2BWSsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:48:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54717 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab2BWSsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:48:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.133.147 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH 2/2] mm: show zone lruvec state in /proc/zoneinfo
To: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andi Kleen <andi@firstfloor.org>
Date: Thu, 23 Feb 2012 22:48:29 +0400
Message-ID: <20120223184829.7184.53490.stgit@zurg>
In-Reply-To: <20120223162111.GA4713@one.firstfloor.org>
References: <20120223162111.GA4713@one.firstfloor.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmstat.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 2c813e1..2e77a19 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -20,6 +20,8 @@
 #include <linux/writeback.h>
 #include <linux/compaction.h>
 
+#include "internal.h"
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
@@ -1020,6 +1022,27 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 		   "\n  start_pfn:         %lu",
 		   zone->all_unreclaimable,
 		   zone->zone_start_pfn);
+	seq_printf(m, "\n  lruvecs");
+	for_each_lruvec_id(i) {
+		struct lruvec *lruvec = zone->lruvec + i;
+		enum lru_list lru;
+
+		seq_printf(m,
+			   "\n    lruvec: %i",
+			   i);
+		for_each_lru(lru)
+			seq_printf(m,
+			   "\n              %s: %lu",
+			   vmstat_text[NR_LRU_BASE + lru],
+			   lruvec->pages_count[lru]);
+		seq_printf(m,
+			   "\n              %s: %lu"
+			   "\n              %s: %lu",
+			   vmstat_text[NR_ISOLATED_ANON],
+			   lruvec->pages_count[LRU_ISOLATED_ANON],
+			   vmstat_text[NR_ISOLATED_FILE],
+			   lruvec->pages_count[LRU_ISOLATED_FILE]);
+	}
 	seq_putc(m, '\n');
 }
 

