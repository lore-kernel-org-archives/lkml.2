Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2KWKr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:47:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab2KWKpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:45:20 -0500
X-IronPort-AV: E=Sophos;i="4.83,307,1352044800"; 
   d="scan'208";a="6263517"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: hpa@zytor.com, akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, tangchen@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 1/5] x86: get pg_data_t's memory from other node
Date: Fri, 23 Nov 2012 18:44:01 +0800
Message-Id: <1353667445-7593-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/23 18:44:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/23 18:44:51,
	Serialize complete at 2012/11/23 18:44:51
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
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 2d125be..734bbd2 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -224,9 +224,14 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	} else {
 		nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 		if (!nd_pa) {
-			pr_err("Cannot find %zu bytes in node %d\n",
-			       nd_size, nid);
-			return;
+			pr_warn("Cannot find %zu bytes in node %d\n",
+				nd_size, nid);
+			nd_pa = memblock_alloc(nd_size, SMP_CACHE_BYTES);
+			if (!nd_pa) {
+				pr_err("Cannot find %zu bytes in other node\n",
+				       nd_size);
+				return;
+			}
 		}
 		nd = __va(nd_pa);
 	}
-- 
1.7.1

