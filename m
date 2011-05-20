Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab1ETDs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:48:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43652 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab1ETDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:48:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 May 2011 12:42:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, hannes@cmpxchg.org,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH 2/8] memcg: easy check routine for reclaimable
Message-Id: <20110520124212.facdc595.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110520123749.d54b32fa.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A function for checking that a memcg has reclaimable pages. This makes
use of mem->scan_nodes when CONFIG_NUMA=y.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

Index: mmotm-May11/mm/memcontrol.c
===================================================================
--- mmotm-May11.orig/mm/memcontrol.c
+++ mmotm-May11/mm/memcontrol.c
@@ -1587,11 +1587,30 @@ int mem_cgroup_select_victim_node(struct
 	return node;
 }
 
+bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg)
+{
+	mem_cgroup_may_update_nodemask(memcg);
+	return !nodes_empty(memcg->scan_nodes);
+}
+
 #else
 int mem_cgroup_select_victim_node(struct mem_cgroup *mem)
 {
 	return 0;
 }
+
+bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg)
+{
+	unsigned long nr;
+	int zid;
+
+	for (zid = NODE_DATA(0)->nr_zones - 1; zid >= 0; zid--)
+		if (mem_cgroup_zone_reclaimable_pages(memcg, 0, zid))
+			break;
+	if (zid < 0)
+		return false;
+	return true;
+}
 #endif
 
 /*
Index: mmotm-May11/include/linux/memcontrol.h
===================================================================
--- mmotm-May11.orig/include/linux/memcontrol.h
+++ mmotm-May11/include/linux/memcontrol.h
@@ -110,6 +110,7 @@ int mem_cgroup_inactive_anon_is_low(stru
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 unsigned long
 mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg, int nid, int zid);
+bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,

