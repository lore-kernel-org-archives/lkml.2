Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2IJJFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:05:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15798 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab2IJI5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:57:54 -0400
X-IronPort-AV: E=Sophos;i="4.80,397,1344182400"; 
   d="scan'208";a="5814151"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [V4 PATCH 05/26] node_states: introduce N_MEMORY
Date: Mon, 10 Sep 2012 16:58:57 +0800
Message-Id: <1347267558-6707-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
References: <1347267558-6707-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/10 16:57:19,
	Serialize complete at 2012/09/10 16:57:19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have N_NORMAL_MEMORY for standing for the nodes that have normal memory with
zone_type <= ZONE_NORMAL.

And we have N_HIGH_MEMORY for standing for the nodes that have normal or high
memory.

But we don't have any word to stand for the nodes that have *any* memory.

And we have N_CPU but without N_MEMORY.

Current code reuse the N_HIGH_MEMORY for this purpose because any node which
has memory must have high memory or normal memory currently.

A)	But this reusing is bad for *readability*. Because the name
	N_HIGH_MEMORY just stands for high or normal:

A.example 1)
	mem_cgroup_nr_lru_pages():
		for_each_node_state(nid, N_HIGH_MEMORY)

	The user will be confused(why this function just counts for high or
	normal memory node? does it counts for ZONE_MOVABLE's lru pages?)
	until someone else tell them N_HIGH_MEMORY is reused to stand for
	nodes that have any memory.

A.cont) If we introduce N_MEMORY, we can reduce this confusing
	AND make the code more clearly:

A.example 2) mm/page_cgroup.c use N_HIGH_MEMORY twice:

	One is in page_cgroup_init(void):
		for_each_node_state(nid, N_HIGH_MEMORY) {

	It means if the node have memory, we will allocate page_cgroup map for
	the node. We should use N_MEMORY instead here to gaim more clearly.

	The second using is in alloc_page_cgroup():
		if (node_state(nid, N_HIGH_MEMORY))
			addr = vzalloc_node(size, nid);

	It means if the node has high or normal memory that can be allocated
	from kernel. We should keep N_HIGH_MEMORY here, and it will be better
	if the "any memory" semantic of N_HIGH_MEMORY is removed.

B)	This reusing is out-dated if we introduce MOVABLE-dedicated node.
	The MOVABLE-dedicated node should not appear in
	node_stats[N_HIGH_MEMORY] nor node_stats[N_NORMAL_MEMORY],
	because MOVABLE-dedicated node has no high or normal memory.

	In x86_64, N_HIGH_MEMORY=N_NORMAL_MEMORY, if a MOVABLE-dedicated node
	is in node_stats[N_HIGH_MEMORY], it is also means it is in
	node_stats[N_NORMAL_MEMORY], it causes SLUB wrong.

	The slub uses
		for_each_node_state(nid, N_NORMAL_MEMORY)
	and creates kmem_cache_node for MOVABLE-dedicated node and cause problem.

In one word, we need a N_MEMORY. We just intrude it as an alias to
N_HIGH_MEMORY and fix all im-proper usages of N_HIGH_MEMORY in late patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
---
 include/linux/nodemask.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 7afc363..c6ebdc9 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -380,6 +380,7 @@ enum node_states {
 #else
 	N_HIGH_MEMORY = N_NORMAL_MEMORY,
 #endif
+	N_MEMORY = N_HIGH_MEMORY,
 	N_CPU,		/* The node has one or more cpus */
 	NR_NODE_STATES
 };
-- 
1.7.1

