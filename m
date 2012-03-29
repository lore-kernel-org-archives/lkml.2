Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2C2G2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:28:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60268 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2C2G2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:28:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F74009C.3050809@jp.fujitsu.com>
Date: Thu, 29 Mar 2012 15:26:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [BUGFIX][PATCH 1/3] memcg/tcp : fix to see memcg's use_hierarchy
 in tcp memcontrol
References: <4F73FF9D.4090809@jp.fujitsu.com>
In-Reply-To: <4F73FF9D.4090809@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, tcp memory control cgroup ignores memcg's use_hierarchy value
and act as use_hierarchy=1 always. After this patch, tcp memcontrol will
work as memcg is designed.

Note:
  I know there is a discussion to remove use_hierarchy but this
  is BUG, now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    3 +++
 mm/memcontrol.c            |    5 +++++
 net/ipv4/tcp_memcontrol.c  |    2 +-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f94efd2..e116b7c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -199,6 +199,9 @@ void mem_cgroup_split_huge_fixup(struct page *head);
 bool mem_cgroup_bad_page_check(struct page *page);
 void mem_cgroup_print_bad_page(struct page *page);
 #endif
+
+bool mem_cgroup_use_hierarchy(struct mem_cgroup *memcg);
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7d698df..467881f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -867,6 +867,11 @@ struct mem_cgroup *try_get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return memcg;
 }
 
+bool mem_cgroup_use_hierarchy(struct mem_cgroup *memcg)
+{
+	return memcg->use_hierarchy;
+}
+
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index e795272..32764a6 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -75,7 +75,7 @@ int tcp_init_cgroup(struct cgroup *cgrp, struct cgroup_subsys *ss)
 	tcp->tcp_memory_pressure = 0;
 
 	parent_cg = tcp_prot.proto_cgroup(parent);
-	if (parent_cg)
+	if (parent_cg && mem_cgroup_use_hierarchy(parent))
 		res_parent = parent_cg->memory_allocated;
 
 	res_counter_init(&tcp->tcp_memory_allocated, res_parent);
-- 
1.7.4.1


