Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3ADJfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:35:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28877 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3ADJfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:35:36 -0500
X-IronPort-AV: E=Sophos;i="4.84,409,1355068800"; 
   d="scan'208";a="6521726"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, tj@kernel.org
Cc: mingo@kernel.org, yinghai@kernel.org, liwanp@linux.vnet.ibm.com,
        benh@kernel.crashing.org, tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [RFC PATCH] mm: memblock: optimize memblock_find_in_range_node() to minimize the search work
Date: Fri, 4 Jan 2013 17:24:53 +0800
Message-Id: <1357291493-25773-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/04 17:25:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/04 17:35:10,
	Serialize complete at 2013/01/04 17:35:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memblock array is in ascending order and we traverse the memblock array in
reverse order so we can add some simple check to reduce the search work.

Tejun fix a underflow bug in 5d53cb27d8, but I think we could break there for
the same reason.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/memblock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..a710557 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -111,11 +111,18 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	end = max(start, end);
 
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		/*
+		 * exclude the regions out of the candidate range, since it's
+		 * likely to find a suitable range, we ignore the worst case.
+		 */
+		if (this_start >= end)
+			continue;
+
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
 		if (this_end < size)
-			continue;
+			break;
 
 		cand = round_down(this_end - size, align);
 		if (cand >= this_start)
-- 
1.7.11.7

