Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1EJKPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:15:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51715 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab1EJKPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:15:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 10 May 2011 19:08:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Michal Hocko <mhocko@suse.cz>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 4/7] memcg : test a memcg is reclaimable
Message-Id: <20110510190820.c62aca76.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110510190216.f4eefef7.kamezawa.hiroyu@jp.fujitsu.com>
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

Index: mmotm-May6/mm/memcontrol.c
===================================================================
--- mmotm-May6.orig/mm/memcontrol.c
+++ mmotm-May6/mm/memcontrol.c
@@ -1623,11 +1623,30 @@ int mem_cgroup_select_victim_node(struct
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
Index: mmotm-May6/include/linux/memcontrol.h
===================================================================
--- mmotm-May6.orig/include/linux/memcontrol.h
+++ mmotm-May6/include/linux/memcontrol.h
@@ -110,6 +110,7 @@ int mem_cgroup_inactive_anon_is_low(stru
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg);
 unsigned long
 mem_cgroup_zone_reclaimable_pages(struct mem_cgroup *memcg, int nid, int zid);
+bool mem_cgroup_test_reclaimable(struct mem_cgroup *memcg);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned int mem_cgroup_swappiness(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,

