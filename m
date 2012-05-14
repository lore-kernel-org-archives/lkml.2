Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2ENL6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:58:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54818 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2ENL6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:58:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4FB0F38A.5020909@jp.fujitsu.com>
Date: Mon, 14 May 2012 20:59:06 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 4/4] memblock: compare current_limit with end variable at
 memblock_find_in_range_node()
References: <4FACA79C.9070103@cn.fujitsu.com> <4FB0F174.1000400@jp.fujitsu.com>
In-Reply-To: <4FB0F174.1000400@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_find_in_range_node() does not compare memblock.current_limit
with end variable. Thus even if memblock.current_limit is smaller than
end variable, the function allocates memory address that is bigger than
memblock.current_limit.

The patch adds the check to "memblock_find_in_range_node()"

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
  mm/memblock.c |    5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-3.4-rc6/mm/memblock.c
===================================================================
--- linux-3.4-rc6.orig/mm/memblock.c	2012-05-15 03:51:25.104153055 +0900
+++ linux-3.4-rc6/mm/memblock.c	2012-05-15 04:16:49.468094485 +0900
@@ -97,11 +97,12 @@ phys_addr_t __init_memblock memblock_fin
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

