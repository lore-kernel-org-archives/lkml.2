Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0KIIzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:55:14 -0500
Received: from smtp-out.google.com ([74.125.121.35]:54267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0KIIzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:55:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Aw565YwuGl4K5PLqVTucdfuT2B9FVfY+XGof+bf34HI99DVZxUzuk26WmtqWk8sk4
	76O4dL07kbUtPya5uEufw==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: avoid "free" overflow in memcg_hierarchical_free_pages()
Date: Tue,  9 Nov 2010 00:54:13 -0800
Message-Id: <1289292853-7022-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memcg limit and usage values are stored in res_counter, as 64-bit
numbers, even on 32-bit machines.  The "free" variable in
memcg_hierarchical_free_pages() stores the difference between two
64-bit numbers (limit - current_usage), and thus should be stored
in a 64-bit local rather than a machine defined unsigned long.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 35870f9..d8a06d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1343,7 +1343,8 @@ static long mem_cgroup_local_page_stat(struct mem_cgroup *mem,
 static unsigned long
 memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 {
-	unsigned long free, min_free;
+	u64 free;
+	unsigned long min_free;
 
 	min_free = global_page_state(NR_FREE_PAGES);
 
@@ -1351,7 +1352,7 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 		free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
 			res_counter_read_u64(&mem->res, RES_USAGE)) >>
 			PAGE_SHIFT;
-		min_free = min(min_free, free);
+		min_free = min((u64)min_free, free);
 		mem = parent_mem_cgroup(mem);
 	}
 
-- 
1.7.3.1

