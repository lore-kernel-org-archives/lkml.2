Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab2IJJBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:01:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab2IJJAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:00:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814207"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 12/26] hugetlb: use N_MEMORY instead N_HIGH_MEMORY
Date: Mon, 10 Sep 2012 16:59:04 +0800
Message-Id: <1347267558-6707-13-git-send-email-laijs@cn.fujitsu.com>
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

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/base/node.c |    2 +-
 mm/hugetlb.c        |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5d7731e..4c3aa7c 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -227,7 +227,7 @@ static node_registration_func_t __hugetlb_unregister_node;
 static inline bool hugetlb_register_node(struct node *node)
 {
 	if (__hugetlb_register_node &&
-			node_state(node->dev.id, N_HIGH_MEMORY)) {
+			node_state(node->dev.id, N_MEMORY)) {
 		__hugetlb_register_node(node);
 		return true;
 	}
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc72712..a254dfb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1052,7 +1052,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
-		if (!free_pool_huge_page(h, &node_states[N_HIGH_MEMORY], 1))
+		if (!free_pool_huge_page(h, &node_states[N_MEMORY], 1))
 			break;
 	}
 }
@@ -1175,14 +1175,14 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 int __weak alloc_bootmem_huge_page(struct hstate *h)
 {
 	struct huge_bootmem_page *m;
-	int nr_nodes = nodes_weight(node_states[N_HIGH_MEMORY]);
+	int nr_nodes = nodes_weight(node_states[N_MEMORY]);
 
 	while (nr_nodes) {
 		void *addr;
 
 		addr = __alloc_bootmem_node_nopanic(
 				NODE_DATA(hstate_next_node_to_alloc(h,
-						&node_states[N_HIGH_MEMORY])),
+						&node_states[N_MEMORY])),
 				huge_page_size(h), huge_page_size(h), 0);
 
 		if (addr) {
@@ -1254,7 +1254,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 			if (!alloc_bootmem_huge_page(h))
 				break;
 		} else if (!alloc_fresh_huge_page(h,
-					 &node_states[N_HIGH_MEMORY]))
+					 &node_states[N_MEMORY]))
 			break;
 	}
 	h->max_huge_pages = i;
@@ -1522,7 +1522,7 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 		if (!(obey_mempolicy &&
 				init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_HIGH_MEMORY];
+			nodes_allowed = &node_states[N_MEMORY];
 		}
 	} else if (nodes_allowed) {
 		/*
@@ -1532,11 +1532,11 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 		count += h->nr_huge_pages - h->nr_huge_pages_node[nid];
 		init_nodemask_of_node(nodes_allowed, nid);
 	} else
-		nodes_allowed = &node_states[N_HIGH_MEMORY];
+		nodes_allowed = &node_states[N_MEMORY];
 
 	h->max_huge_pages = set_max_huge_pages(h, count, nodes_allowed);
 
-	if (nodes_allowed != &node_states[N_HIGH_MEMORY])
+	if (nodes_allowed != &node_states[N_MEMORY])
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
@@ -1839,7 +1839,7 @@ static void hugetlb_register_all_nodes(void)
 {
 	int nid;
 
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		struct node *node = &node_devices[nid];
 		if (node->dev.id == nid)
 			hugetlb_register_node(node);
@@ -1934,8 +1934,8 @@ void __init hugetlb_add_hstate(unsigned order)
 	for (i = 0; i < MAX_NUMNODES; ++i)
 		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 	INIT_LIST_HEAD(&h->hugepage_activelist);
-	h->next_nid_to_alloc = first_node(node_states[N_HIGH_MEMORY]);
-	h->next_nid_to_free = first_node(node_states[N_HIGH_MEMORY]);
+	h->next_nid_to_alloc = first_node(node_states[N_MEMORY]);
+	h->next_nid_to_free = first_node(node_states[N_MEMORY]);
 	snprintf(h->name, HSTATE_NAME_LEN, "hugepages-%lukB",
 					huge_page_size(h)/1024);
 	/*
@@ -2030,11 +2030,11 @@ static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
 		if (!(obey_mempolicy &&
 			       init_nodemask_of_mempolicy(nodes_allowed))) {
 			NODEMASK_FREE(nodes_allowed);
-			nodes_allowed = &node_states[N_HIGH_MEMORY];
+			nodes_allowed = &node_states[N_MEMORY];
 		}
 		h->max_huge_pages = set_max_huge_pages(h, tmp, nodes_allowed);
 
-		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
+		if (nodes_allowed != &node_states[N_MEMORY])
 			NODEMASK_FREE(nodes_allowed);
 	}
 out:
-- 
1.7.1

