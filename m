Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab2EKFkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:40:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50007 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab2EKFj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:39:58 -0400
X-IronPort-AV: E=Sophos;i="4.75,569,1330876800"; 
   d="scan'208";a="4933522"
Message-ID: <4FACA79C.9070103@cn.fujitsu.com>
Date: Fri, 11 May 2012 13:46:04 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] memory: add kernelcore_max_addr boot option
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/11 13:38:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/11 13:39:00,
	Serialize complete at 2012/05/11 13:39:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current ZONE_MOVABLE (kernelcore=) setting policy with boot option doesn't meet
our requirement. We need something like kernelcore_max_addr= boot option
to limit the kernelcore upper address.

The memory with higher address will be migratable(movable) and they
are easier to be offline(always ready to be offline when the system don't require
so much memory).

All kernelcore_max_addr=, kernelcore= and movablecore= can be safely specified
at the same time(or any 2 of them).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 mm/page_alloc.c                     |   27 ++++++++++++++++++++++++++-
 2 files changed, 35 insertions(+), 1 deletions(-)
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..9f42787 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1184,6 +1184,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index a712fb9..9169ea9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -200,6 +200,7 @@ static unsigned long __meminitdata dma_reserve;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 static unsigned long __meminitdata arch_zone_lowest_possible_pfn[MAX_NR_ZONES];
 static unsigned long __meminitdata arch_zone_highest_possible_pfn[MAX_NR_ZONES];
+static unsigned long __initdata required_kernelcore_max_pfn;
 static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
@@ -4568,6 +4569,7 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 {
 	int i, nid;
 	unsigned long usable_startpfn;
+	unsigned long kernelcore_max_pfn;
 	unsigned long kernelcore_node, kernelcore_remaining;
 	/* save the state before borrow the nodemask */
 	nodemask_t saved_node_state = node_states[N_HIGH_MEMORY];
@@ -4596,6 +4598,9 @@ static void __init find_zone_movable_pfns_for_nodes(void)
 		required_kernelcore = max(required_kernelcore, corepages);
 	}
 
+	if (required_kernelcore_max_pfn && !required_kernelcore)
+		required_kernelcore = totalpages;
+
 	/* If kernelcore was not specified, there is no ZONE_MOVABLE */
 	if (!required_kernelcore)
 		goto out;
@@ -4604,6 +4609,12 @@ static void __init find_zone_movable_pfns_for_nodes(void)
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
@@ -4630,8 +4641,12 @@ restart:
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
@@ -4816,6 +4831,15 @@ static int __init cmdline_parse_core(char *p, unsigned long *core)
 }
 
 /*
+ * kernelcore_max_addr=addr sets the up physical address of memory range
+ * for use for allocations that cannot be reclaimed or migrated.
+ */
+static int __init cmdline_parse_kernelcore_max_addr(char *p)
+{
+	return cmdline_parse_core(p, &required_kernelcore_max_pfn);
+}
+
+/*
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
  */
@@ -4833,6 +4857,7 @@ static int __init cmdline_parse_movablecore(char *p)
 	return cmdline_parse_core(p, &required_movablecore);
 }
 
+early_param("kernelcore_max_addr", cmdline_parse_kernelcore_max_addr);
 early_param("kernelcore", cmdline_parse_kernelcore);
 early_param("movablecore", cmdline_parse_movablecore);
 


