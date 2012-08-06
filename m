Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2HFJYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:24:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab2HFJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:24:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,719,1336320000"; 
   d="scan'208";a="5560156"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        linux-mm@kvack.org
Subject: [RFC V3 PATCH 24/25] memblock: compare current_limit with end variable at memblock_find_in_range_node()
Date: Mon, 6 Aug 2012 17:23:18 +0800
Message-Id: <1344244999-5081-25-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
References: <1343887288-8866-1-git-send-email-laijs@cn.fujitsu.com>
 <1344244999-5081-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/06 17:24:42,
	Serialize complete at 2012/08/06 17:24:42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

memblock_find_in_range_node() does not compare memblock.current_limit
with end variable. Thus even if memblock.current_limit is smaller than
end variable, the function allocates memory address that is bigger than
memblock.current_limit.

The patch adds the check to "memblock_find_in_range_node()"

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/memblock.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 663b805..ce7fcb6 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -99,11 +99,12 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 					phys_addr_t align, int nid)
 {
 	phys_addr_t this_start, this_end, cand;
+	phys_addr_t current_limit = memblock.current_limit;
 	u64 i;
 
 	/* pump up @end */
-	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
-		end = memblock.current_limit;
+	if ((end == MEMBLOCK_ALLOC_ACCESSIBLE) || (end > current_limit))
+		end = current_limit;
 
 	/* avoid allocating the first page */
 	start = max_t(phys_addr_t, start, PAGE_SIZE);
-- 
1.7.4.4

