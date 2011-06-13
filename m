Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1FMDNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:13:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43848 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab1FMDNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:13:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 12:06:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH 2/5] memcg: fix init_page_cgroup nid with sparsemem
Message-Id: <20110613120608.d5243bc9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added some clean ups.
==
>From 45b8881201f73015c4e0352eb7e434f6e9c53fdd Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 10:09:17 +0900
Subject: [PATCH 2/5] [BUGFIX] memcg: fix init_page_cgroup nid with sparsemem


commit 21a3c96 makes page_cgroup allocation as NUMA aware. But that caused
a problem https://bugzilla.kernel.org/show_bug.cgi?id=36192.

The problem was getting a NID from invalid struct pages, which was not
initialized because it was out-of-node, out of [node_start_pfn, node_end_pfn)

Now, with sparsemem, page_cgroup_init scans pfn from 0 to max_pfn.
But this may scan a pfn which is not on any node and can access
memmap which is not initialized.

This makes page_cgroup_init() for SPARSEMEM node aware and remove
a code to get nid from page->flags. (Then, we'll use valid NID
always.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog :
  - use better macros as node_start/end_pfn(), PAGE_SECTION_MASK..etc
  - pull out error handling code, which is rarely called.
  - fixed MEM_GOING_ONLINE case.
  - Add more comments and updated patch descriptions.
---
 mm/page_cgroup.c |   67 +++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 51 insertions(+), 16 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 74ccff6..0742633 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -162,13 +162,13 @@ static void free_page_cgroup(void *addr)
 }
 #endif
 
-static int __meminit init_section_page_cgroup(unsigned long pfn)
+static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
 {
 	struct page_cgroup *base, *pc;
 	struct mem_section *section;
 	unsigned long table_size;
 	unsigned long nr;
-	int nid, index;
+	int index;
 
 	nr = pfn_to_section_nr(pfn);
 	section = __nr_to_section(nr);
@@ -176,7 +176,6 @@ static int __meminit init_section_page_cgroup(unsigned long pfn)
 	if (section->page_cgroup)
 		return 0;
 
-	nid = page_to_nid(pfn_to_page(pfn));
 	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 	base = alloc_page_cgroup(table_size, nid);
 
@@ -196,7 +195,11 @@ static int __meminit init_section_page_cgroup(unsigned long pfn)
 		pc = base + index;
 		init_page_cgroup(pc, nr);
 	}
-
+	/*
+	 * Passed "pfn" may not be aligned to SECTION. For calculation,
+	 * nedd to apply a mask.
+	 */
+	pfn &= PAGE_SECTION_MASK;
 	section->page_cgroup = base - pfn;
 	total_usage += table_size;
 	return 0;
@@ -225,10 +228,20 @@ int __meminit online_page_cgroup(unsigned long start_pfn,
 	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
+	if (nid == -1) {
+		/*
+		 * In this case, "nid" already exists and contains valid memory.
+		 * "start_pfn" passed for us is a pfn which is args for online_
+		 * _pages(), and start_pfn should exists.
+		 */
+		nid = pfn_to_nid(start_pfn);
+		VM_BUG_ON(!node_state(nid, N_ONLINE));
+	}
+
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
 		if (!pfn_present(pfn))
 			continue;
-		fail = init_section_page_cgroup(pfn);
+		fail = init_section_page_cgroup(pfn, nid);
 	}
 	if (!fail)
 		return 0;
@@ -284,25 +297,47 @@ static int __meminit page_cgroup_callback(struct notifier_block *self,
 void __init page_cgroup_init(void)
 {
 	unsigned long pfn;
-	int fail = 0;
+	int nid;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
-			continue;
-		fail = init_section_page_cgroup(pfn);
-	}
-	if (fail) {
-		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
-		panic("Out of memory");
-	} else {
-		hotplug_memory_notifier(page_cgroup_callback, 0);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long start_pfn, end_pfn;
+
+		start_pfn = node_start_pfn(nid);
+		end_pfn = node_end_pfn(nid);
+		/*
+		 * start_pfn and end_pfn may not be aligned to SECTION and
+		 * page->flags of out of node pages are not initialized. So,
+		 * we scan [start_pfn, the biggest section's pfn < end_pfn), here.
+		 */
+		for (pfn = start_pfn;
+		     pfn < end_pfn;
+                     pfn = ALIGN(pfn + 1, PAGES_PER_SECTION)) {
+
+			if (!pfn_valid(pfn))
+				continue;
+			/*
+			 * Nodes's pfn can be overlapped.
+			 * We know some arch can have nodes layout as
+			 * -------------pfn-------------->
+			 * N0 | N1 | N2 | N0 | N1 | N2|....
+			 */
+			if (pfn_to_nid(pfn) != nid)
+				continue;
+			if (init_section_page_cgroup(pfn, nid))
+				goto oom;
+		}
 	}
+	hotplug_memory_notifier(page_cgroup_callback, 0);
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
 	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
 	" want memory cgroups\n");
+	return;
+oom:
+	printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
+	panic("Out of memory");
 }
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
-- 
1.7.4.1


