Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0KIBQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:16:33 -0500
Received: from smtp-out.google.com ([74.125.121.35]:42073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0KIBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:16:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=Zkhc5rehqrUer2ET9vh2jb73AZ3y4S0UIugakHTo7fcZa0rhjwA2t4gofYzKkvdMM
	oxtOyALbV2f2XElz9NKZQ==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: avoid overflow in memcg_hierarchical_free_pages()
Date: Mon,  8 Nov 2010 17:15:20 -0800
Message-Id: <1289265320-7025-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use page counts rather than byte counts to avoid overflowing
unsigned long local variables.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 mm/memcontrol.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c7115d..b287afd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1345,17 +1345,17 @@ memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 {
 	unsigned long free, min_free;
 
-	min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;
+	min_free = global_page_state(NR_FREE_PAGES);
 
 	while (mem) {
-		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
-			res_counter_read_u64(&mem->res, RES_USAGE);
+		free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
+			res_counter_read_u64(&mem->res, RES_USAGE)) >>
+			PAGE_SHIFT;
 		min_free = min(min_free, free);
 		mem = parent_mem_cgroup(mem);
 	}
 
-	/* Translate free memory in pages */
-	return min_free >> PAGE_SHIFT;
+	return min_free;
 }
 
 /*
-- 
1.7.3.1

