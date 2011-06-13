Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1FMDSG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 23:18:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60100 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab1FMDSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 23:18:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Jun 2011 12:11:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [BUGFIX][PATCH 4/5] memcg:  fix wrong check of noswap with
 softlimit
Message-Id: <20110613121105.b8f251e2.kamezawa.hiroyu@jp.fujitsu.com>
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

>From 0a0358d300330a4ba86e39ea56ed63f1e4519dfd Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 10:31:16 +0900
Subject: [PATCH 4/5]  fix wrong check of noswap with softlimit

Hierarchical reclaim doesn't swap out if memsw and resource limits are
same (memsw_is_minimum == true) because we would hit mem+swap limit
anyway (during hard limit reclaim).
If it comes to the solft limit we shouldn't consider memsw_is_minimum at
all because it doesn't make much sense. Either the soft limit is bellow
the hard limit and then we cannot hit mem+swap limit or the direct
reclaim takes a precedence.

Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ce05835..915c3f3 100644
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


