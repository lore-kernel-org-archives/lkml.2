Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1BCOMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 09:12:44 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:56921 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932113Ab1BCOMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 09:12:42 -0500
Date: Thu, 3 Feb 2011 15:12:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch rfc] memcg: remove NULL check from lookup_page_cgroup() result
Message-ID: <20110203141230.GG2286@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page_cgroup array is set up before even fork is initialized.  I
seriously doubt that this code executes before the array is alloc'd.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a145c9e..6abaa10 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2343,10 +2343,7 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 	}
 
 	pc = lookup_page_cgroup(page);
-	/* can happen at boot */
-	if (unlikely(!pc))
-		return 0;
-	prefetchw(pc);
+	BUG_ON(!pc); /* XXX: remove this and move pc lookup into commit */
 
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, oom, page_size);
 	if (ret || !mem)
-- 
1.7.4
