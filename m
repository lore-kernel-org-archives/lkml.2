Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020Ab2J2Pwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:52:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56602 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759893Ab2J2PsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:48:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,673,1344182400"; 
   d="scan'208";a="6093346"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        linux-mm@kvack.org
Subject: [V5 PATCH 25/26] memblock: compare current_limit with end variable at memblock_find_in_range_node()
Date: Mon, 29 Oct 2012 23:21:15 +0800
Message-Id: <1351524078-20363-24-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
References: <1351523301-20048-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:19:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/29 23:20:02,
	Serialize complete at 2012/10/29 23:20:02
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
index ee2e307..50ab53c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -100,11 +100,12 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
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

