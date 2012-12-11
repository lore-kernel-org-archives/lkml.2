Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2LKCe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:34:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:34496 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab2LKCe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:34:27 -0500
X-IronPort-AV: E=Sophos;i="4.84,256,1355068800"; 
   d="scan'208";a="6371864"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v3 1/5] x86: get pg_data_t's memory from other node
Date: Tue, 11 Dec 2012 10:33:23 +0800
Message-Id: <1355193207-21797-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:37,
	Serialize complete at 2012/12/11 10:33:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

If system can create movable node which all memory of the
node is allocated as ZONE_MOVABLE, setup_node_data() cannot
allocate memory for the node's pg_data_t.
So, use memblock_alloc_try_nid() instead of memblock_alloc_nid()
to retry when the first allocation fails.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/mm/numa.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..db939b6 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -222,10 +222,9 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 		nd_pa = __pa(nd);
 		remapped = true;
 	} else {
-		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
+		nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
 		if (!nd_pa) {
-			pr_err("Cannot find %zu bytes in node %d\n",
-			       nd_size, nid);
+			pr_err("Cannot find %zu bytes in any node\n", nd_size);
 			return;
 		}
 		nd = __va(nd_pa);
-- 
1.7.1

