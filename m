Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FHBWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:22:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57294 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab1FHBWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:22:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 8 Jun 2011 10:15:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>, dave@linux.vnet.ibm.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [BUGFIX][PATCH] fix node hotplug zonelist build
Message-Id: <20110608101506.60642149.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At memory hotplug, we reflesh zonelists when we online a page in a new zone.
It means that Node's zonelist is not initialized until pages are onlined. So,
for example, "nid" passed by MEM_GOING_ONLINE notifier will point to
NODE_DATA(nid) which has no zone fallback list. Moreover, if we hot-add
cpu-only nodes, alloc_pages() will do no fallback.

This patch makes zonelist when a new pgdata is available.

Note: in production, at fujitsu, memory should be onlined before cpu
      and our server didn't have any memory-less nodes and had no problems.

      But recent changes in MEM_GOING_ONLINE+page_cgroup
      will access not initialized zonelist of node.
      Anyway, there are memory-less node and we need some care.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memory_hotplug.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-3.0-rc1/mm/memory_hotplug.c
===================================================================
--- linux-3.0-rc1.orig/mm/memory_hotplug.c
+++ linux-3.0-rc1/mm/memory_hotplug.c
@@ -494,6 +494,12 @@ static pg_data_t __ref *hotadd_new_pgdat
 	/* init node's zones as empty zones, we don't have any present pages.*/
 	free_area_init_node(nid, zones_size, start_pfn, zholes_size);
 
+	/*
+	 * The node we allocated has no zone fallback lists. For avoiding
+	 * to access not-initialized zonelist, build here.
+	 */
+	build_all_zonelists(NULL);
+
 	return pgdat;
 }
 

