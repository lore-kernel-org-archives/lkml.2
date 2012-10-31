Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269Ab2JaJQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:16:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935235Ab2JaJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:16:06 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107691"
From: Wen Congyang <wency@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: [PART5 Patch 5/5] memblock: compare current_limit with end variable at memblock_find_in_range_node()
Date: Wed, 31 Oct 2012 17:21:43 +0800
Message-Id: <1351675303-11786-6-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
References: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:16,
	Serialize complete at 2012/10/31 17:15:16
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
 mm/memblock.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
1.8.0

