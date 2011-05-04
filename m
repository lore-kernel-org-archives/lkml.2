Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1EDU0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:26:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:22994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1EDU0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,316,1301900400"; 
   d="scan'208";a="918080773"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, rientjes@google.com,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] Allocate memory cgroup structures in local nodes v2
Date: Wed,  4 May 2011 13:26:23 -0700
Message-Id: <1304540783-8247-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[Andrew: since this is a regression and a very simple fix
could you still consider it for .39? Thanks]

dde79e005a769 added a regression that the memory cgroup data structures
all end up in node 0 because the first attempt at allocating them
would not pass in a node hint. Since the initialization runs on CPU #0
it would all end up node 0. This is a problem on large memory systems,
where node 0 would lose a lot of memory.

Change the alloc_pages_exact to alloc_pages_exact_node. This will
still fall back to other nodes if not enough memory is available.

[RED-PEN: right now it would fall back first before trying
vmalloc_node. Probably not the best strategy ... But I left it like
that for now.]

v2: Fix argument order. Thanks David Rientjes.
Reported-by: Doug Nelson
Cc: rientjes@google.com
CC: Michal Hocko <mhocko@suse.cz>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/page_cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 9905501..a362215 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgroup(size_t size, int nid)
 {
 	void *addr = NULL;
 
-	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
+	addr = alloc_pages_exact_node(nid, GFP_KERNEL | __GFP_NOWARN, size);
 	if (addr)
 		return addr;
 
-- 
1.7.4.4

