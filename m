Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab2IJI73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:59:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62513 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab2IJI6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:58:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814161"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 20/26] page_alloc: add kernelcore_max_addr
Date: Mon, 10 Sep 2012 16:59:12 +0800
Message-Id: <1347267558-6707-21-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:20,
	Serialize complete at 2012/09/10 16:57:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ZONE_MOVABLE (kernelcore=) setting policy with boot option doesn't meet
our requirement. We need something like kernelcore_max_addr=XX boot option
to limit the kernelcore upper address.

The memory with higher address will be migratable(movable) and they
are easier to be offline(always ready to be offline when the system don't require
so much memory).

It makes things easy when we dynamic hot-add/remove memory, make better
utilities of memories, and helps for THP.

All kernelcore_max_addr=, kernelcore= and movablecore= can be safely specified
at the same time(or any 2 of them).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 mm/page_alloc.c                     |   29 ++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7aef334..02a2ce9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1215,6 +1215,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
+	kernelcore_max_addr=nn[KMG]	[KNL,X86,IA-64,PPC] This parameter
+			is the same effect as kernelcore parameter, except it
+			specifies the up physical address of memory range
+			usable by the kernel for non-movable allocations.
+			If both kernelcore and kernelcore_max_addr are
+			specified, this requested's priority is higher than
+			kernelcore's.
+			See the kernelcore parameter.
+
 	kgdbdbgp=	[KGDB,HW] kgdb over EHCI usb debug port.
 			Format: <Controller#>[,poll interval]
 			The controller # is the number of the ehci usb debug
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 621c666..c1c5834 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -203,6 +203,7 @@ static unsigned long __meminitdata dma_reserve;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __initdata required_kernelcore_max_pfn;
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
@@ -4650,6 +4651,7 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 {
 	int i, nid;
 	unsigned long usable_startpfn;
+	unsigned long kernelcore_max_pfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
 	/* save the state before borrow the nodemask */
 	nodemask_t saved_node_state = node_states[N_MEMORY];
@@ -4678,6 +4680,9 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
+	if (required_kernelcore_max_pfn && !required_kernelcore)
+		required_kernelcore = totalpages;
+
 	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
 	if (!required_kernelcore)
 		goto out;
@@ -4686,6 +4691,12 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 	find_usable_zone_for_movable();
 	usable_startpfn = arch_zone_lowest_possible_pfn[movable_zone];
 
+	if (required_kernelcore_max_pfn)
+		kernelcore_max_pfn = required_kernelcore_max_pfn;
+	else
+		kernelcore_max_pfn = ULONG_MAX >> PAGE_SHIFT;
+	kernelcore_max_pfn = max(kernelcore_max_pfn, usable_startpfn);
+
 restart:
 	/* Spread kernelcore memory as evenly as possible throughout nodes */
 	kernelcore_node = required_kernelcore / usable_nodes;
@@ -4712,8 +4723,12 @@ restart:
 			unsigned long size_pages;
 
 			start_pfn = max(start_pfn, zone_movable_pfn[nid]);
-			if (start_pfn >= end_pfn)
+			end_pfn = min(kernelcore_max_pfn, end_pfn);
+			if (start_pfn >= end_pfn) {
+				if (!zone_movable_pfn[nid])
+					zone_movable_pfn[nid] = start_pfn;
 				continue;
+			}
 
 			/* Account for what is only usable for kernelcore */
 			if (start_pfn < usable_startpfn) {
@@ -4904,6 +4919,18 @@ static int __init cmdline_parse_core(char *p, unsigned long *core)
 	return 0;
 }
 
+#ifdef CONFIG_MOVABLE_NODE
+/*
+ * kernelcore_max_addr=addr sets the up physical address of memory range
+ * for use for allocations that cannot be reclaimed or migrated.
+ */
+static int __init cmdline_parse_kernelcore_max_addr(char *p)
+{
+	return cmdline_parse_core(p, &required_kernelcore_max_pfn);
+}
+early_param("kernelcore_max_addr", cmdline_parse_kernelcore_max_addr);
+#endif
+
 /*
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
-- 
1.7.1

