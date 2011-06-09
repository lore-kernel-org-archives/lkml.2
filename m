Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1FIBBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 21:01:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44276 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab1FIBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 21:01:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Jun 2011 09:54:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>
Subject: [BUGFIX][PATCH] memcg: fix wrong decision of noswap with softlimit.
Message-Id: <20110609095445.5f98b752.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder this should go stable...
==
>From e2565de1c764057b75b4d9a1674d163b6c873cdd Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 9 Jun 2011 09:54:32 +0900
Subject: [PATCH 2/2] Fix softlimit wrong check of noswap

Now, hierarchical reclaim doesn't make swap if memory's limit is
equal to mem+swap limit. Because if reclaim does swap-out,
it still hits mem+swap limit and there will be no progress.
WHEN HITTING HARD LIMIT.

When it comes to softlimit, it works for kswapd. noswap is nonsense.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3baddcb..06825be 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1663,7 +1663,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
-	if (root_mem->memsw_is_minimum)
+	if (!check_soft && root_mem->memsw_is_minimum)
 		noswap = true;
 
 	while (1) {
-- 
1.7.4.1


