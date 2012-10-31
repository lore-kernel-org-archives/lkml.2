Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289Ab2JaJRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:17:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935097Ab2JaJQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:16:01 -0400
X-IronPort-AV: E=Sophos;i="4.80,687,1344182400"; 
   d="scan'208";a="6107687"
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
Subject: [PART5 Patch 2/5] x86: get pg_data_t's memory from other node
Date: Wed, 31 Oct 2012 17:21:40 +0800
Message-Id: <1351675303-11786-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
References: <1351675303-11786-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/31 17:15:15,
	Serialize complete at 2012/10/31 17:15:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

If system can create movable node which all memory of the
node is allocated as ZONE_MOVABLE, setup_node_data() cannot
allocate memory for the node's pg_data_t.
So when memblock_alloc_nid() fails, setup_node_data() retries
memblock_alloc().

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 arch/x86/mm/numa.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..a86e315 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -223,9 +223,13 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 		remapped = true;
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
-		if (!nd_pa) {
-			pr_err("Cannot find %zu bytes in node %d\n",
+		if (!nd_pa)
+			printk(KERN_WARNING "Cannot find %zu bytes in node %d\n",
 			       nd_size, nid);
+		nd_pa = memblock_alloc(nd_size, SMP_CACHE_BYTES);
+		if (!nd_pa) {
+			pr_err("Cannot find %zu bytes in other node\n",
+			       nd_size);
 			return;
 		}
 		nd = __va(nd_pa);
-- 
1.8.0

