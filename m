Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2LKCgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:36:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab2LKCeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:34:37 -0500
X-IronPort-AV: E=Sophos;i="4.84,256,1355068800"; 
   d="scan'208";a="6371868"
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
Subject: [PATCH v3 5/5] page_alloc: Bootmem limit with movablecore_map
Date: Tue, 11 Dec 2012 10:33:27 +0800
Message-Id: <1355193207-21797-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1355193207-21797-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/11 10:33:39,
	Serialize complete at 2012/12/11 10:33:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch make sure bootmem will not allocate memory from areas that
may be ZONE_MOVABLE. The map info is from movablecore_map boot option.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Wen Congyang <wency@cn.fujitsu.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..6e25597 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -42,6 +42,7 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
+extern struct movablecore_map movablecore_map;
 
 #define memblock_dbg(fmt, ...) \
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..197c3be 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -101,6 +101,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
+	int curr = movablecore_map.nr_map - 1;
 
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
@@ -114,13 +115,28 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
-		if (this_end < size)
+restart:
+		if (this_end <= this_start || this_end < size)
 			continue;
 
+		for (; curr >= 0; curr--) {
+			if ((movablecore_map.map[curr].start_pfn << PAGE_SHIFT)
+			    < this_end)
+				break;
+		}
+
 		cand = round_down(this_end - size, align);
+		if (curr >= 0 &&
+		    cand < movablecore_map.map[curr].end_pfn << PAGE_SHIFT) {
+			this_end = movablecore_map.map[curr].start_pfn
+				   << PAGE_SHIFT;
+			goto restart;
+		}
+
 		if (cand >= this_start)
 			return cand;
 	}
+
 	return 0;
 }
 
-- 
1.7.1

