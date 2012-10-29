Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab2J2QDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:03:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31364 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759569Ab2J2QDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:03:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093401"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org
Subject: [V5 PATCH 11/26] mempolicy: use N_MEMORY instead N_HIGH_MEMORY
Date: Mon, 29 Oct 2012 23:21:01 +0800
Message-Id: <1351524078-20363-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:07,
	Serialize complete at 2012/10/29 23:19:07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_HIGH_MEMORY stands for the nodes that has normal or high memory.
N_MEMORY stands for the nodes that has any memory.

The code here need to handle with the nodes which have memory, we should
use N_MEMORY instead.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/mempolicy.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d04a8a5..d4a084c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -212,9 +212,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	/* if mode is MPOL_DEFAULT, pol is NULL. This is right. */
 	if (pol == NULL)
 		return 0;
-	/* Check N_HIGH_MEMORY */
+	/* Check N_MEMORY */
 	nodes_and(nsc->mask1,
-		  cpuset_current_mems_allowed, node_states[N_HIGH_MEMORY]);
+		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
 
 	VM_BUG_ON(!nodes);
 	if (pol->mode == MPOL_PREFERRED && nodes_empty(*nodes))
@@ -1388,7 +1388,7 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pid, unsigned long, maxnode,
 		goto out_put;
 	}
 
-	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
+	if (!nodes_subset(*new, node_states[N_MEMORY])) {
 		err = -EINVAL;
 		goto out_put;
 	}
@@ -2361,7 +2361,7 @@ void __init numa_policy_init(void)
 	 * fall back to the largest node if they're all smaller.
 	 */
 	nodes_clear(interleave_nodes);
-	for_each_node_state(nid, N_HIGH_MEMORY) {
+	for_each_node_state(nid, N_MEMORY) {
 		unsigned long total_pages = node_present_pages(nid);
 
 		/* Preserve the largest node */
@@ -2442,7 +2442,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		*nodelist++ = '\0';
 		if (nodelist_parse(nodelist, nodes))
 			goto out;
-		if (!nodes_subset(nodes, node_states[N_HIGH_MEMORY]))
+		if (!nodes_subset(nodes, node_states[N_MEMORY]))
 			goto out;
 	} else
 		nodes_clear(nodes);
@@ -2476,7 +2476,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
 		 * Default to online nodes with memory if no nodelist
 		 */
 		if (!nodelist)
-			nodes = node_states[N_HIGH_MEMORY];
+			nodes = node_states[N_MEMORY];
 		break;
 	case MPOL_LOCAL:
 		/*
-- 
1.7.4.4

