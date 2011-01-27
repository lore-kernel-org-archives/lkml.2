Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1A0Nqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:46:54 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50125 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab1A0Nqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:46:53 -0500
Date: Thu, 27 Jan 2011 14:46:45 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [patch 2/3] memcg: prevent endless loop on huge page charge
Message-ID: <20110127134645.GA14309@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127103438.GC2401@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127103438.GC2401@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The charging code can encounter a charge size that is bigger than a
regular page in two situations: one is a batched charge to fill the
per-cpu stocks, the other is a huge page charge.

This code is distributed over two functions, however, and only the
outer one is aware of huge pages.  In case the charging fails, the
inner function will tell the outer function to retry if the charge
size is bigger than regular pages--assuming batched charging is the
only case.  And the outer function will retry forever charging a huge
page.

This patch makes sure the inner function can distinguish between batch
charging and a single huge page charge.  It will only signal another
attempt if batch charging failed, and go into regular reclaim when it
is called on behalf of a huge page.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8fa4be3..17c4e36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1847,7 +1847,7 @@ static int __mem_cgroup_do_charge(struct mem_cgroup *mem, gfp_t gfp_mask,
 	} else
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
 
-	if (csize > PAGE_SIZE) /* change csize and retry */
+	if (csize == CHARGE_SIZE) /* retry without batching */
 		return CHARGE_RETRY;
 
 	if (!(gfp_mask & __GFP_WAIT))
-- 
1.7.3.5

