Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2LSJNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 04:13:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36033 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab2LSJMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:12:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,315,1355068800"; 
   d="scan'208";a="6432405"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: jiang.liu@huawei.com, wujianguo@huawei.com, hpa@zytor.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: [PATCH v4 3/6] ACPI: Restructure movablecore_map with memory info from SRAT.
Date: Wed, 19 Dec 2012 17:11:48 +0800
Message-Id: <1355908308-24744-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1355904903-22699-4-git-send-email-tangchen@cn.fujitsu.com>
References: <1355904903-22699-4-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/19 17:11:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/19 17:11:49,
	Serialize complete at 2012/12/19 17:11:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hot Plugable bit in SRAT flags specifys if the memory range
could be hotplugged.

If user specified movablecore_map=nn[KMG]@ss[KMG], reset
movablecore_map.map to the intersection of hotpluggable ranges from
SRAT and old movablecore_map.map.
Else if user specified movablecore_map=acpi, just use the hotpluggable
ranges from SRAT.
Otherwise, do nothing. The kernel will use all the memory in all nodes
evenly.

The idea "getting info from SRAT" was from Liu Jiang <jiang.liu@huawei.com>.
And the idea "do more limit for memblock" was from Wu Jianguo <wujianguo@huawei.com>

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 arch/x86/mm/srat.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 4ddf497..a8856d2 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -146,7 +146,12 @@ int __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
 	u64 start, end;
+	u32 hotpluggable;
 	int node, pxm;
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	int overlap;
+	unsigned long start_pfn, end_pfn;
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 	if (srat_disabled())
 		return -1;
@@ -157,8 +162,10 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
 		return -1;
 
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
+	hotpluggable = ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE;
+	if (hotpluggable && !save_add_info())
 		return -1;
+
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
@@ -178,9 +185,51 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	node_set(node, numa_nodes_parsed);
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
 	       node, pxm,
-	       (unsigned long long) start, (unsigned long long) end - 1);
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       hotpluggable ? "Hot Pluggable": "");
+
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	start_pfn = PFN_DOWN(start);
+	end_pfn = PFN_UP(end);
+
+	if (!hotpluggable) {
+		/* Clear the range overlapped in movablecore_map.map */
+		remove_movablecore_map(start_pfn, end_pfn);
+		goto out;
+	}
+
+	if (!movablecore_map.acpi) {
+		for (overlap = 0; overlap < movablecore_map.nr_map; overlap++) {
+			if (start_pfn < movablecore_map.map[overlap].end_pfn)
+				break;
+		}
+
+		/*
+		 * If there is no overlapped range, or the end of the overlapped
+		 * range is higher than end_pfn, then insert nothing.
+		 */
+		if (end_pfn <= movablecore_map.map[overlap].end_pfn)
+			goto out;
+
+		/*
+		 * Otherwise, insert the rest of this range to prevent memblock
+		 * from allocating memory in it.
+		 */
+		start_pfn = movablecore_map.map[overlap].end_pfn;
+		start = start_pfn >> PAGE_SHIFT;
+	}
+
+	/* If user chose to use SRAT info, insert the range anyway. */
+	if (insert_movablecore_map(start_pfn, end_pfn))
+		pr_err("movablecore_map: too many entries;"
+			" ignoring [mem %#010llx-%#010llx]\n",
+			(unsigned long long) start,
+			(unsigned long long) (end - 1));
+
+out:
+#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	return 0;
 }
 
-- 
1.7.1

