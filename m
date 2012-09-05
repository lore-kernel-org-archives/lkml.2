Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab2IEJpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:45:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2IEJo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:44:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,373,1344182400"; 
   d="scan'208";a="5789230"
From: wency@cn.fujitsu.com
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: [RFC v9 PATCH 14/21] memory-hotplug: move register_page_bootmem_info_node and put_page_bootmem for sparse-vmemmap
Date: Wed, 5 Sep 2012 17:25:48 +0800
Message-Id: <1346837155-534-15-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/05 17:20:04,
	Serialize complete at 2012/09/05 17:20:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

For implementing register_page_bootmem_info_node of sparse-vmemmap,
register_page_bootmem_info_node and put_page_bootmem are moved to
memory_hotplug.c

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 include/linux/memory_hotplug.h |    9 ---------
 mm/memory_hotplug.c            |    8 ++++++--
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index cdbbd79..1133e63 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -162,17 +162,8 @@ static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
 #endif /* CONFIG_NUMA */
 #endif /* CONFIG_HAVE_ARCH_NODEDATA_EXTENSION */
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
-{
-}
-static inline void put_page_bootmem(struct page *page)
-{
-}
-#else
 extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
 extern void put_page_bootmem(struct page *page);
-#endif
 
 /*
  * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 26a5012..df6857b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -91,7 +91,6 @@ static void release_memory_resource(struct resource *res)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
 static void get_page_bootmem(unsigned long info,  struct page *page,
 			     unsigned long type)
 {
@@ -127,6 +126,7 @@ void __ref put_page_bootmem(struct page *page)
 
 }
 
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long *usemap, mapsize, section_nr, i;
@@ -163,6 +163,11 @@ static void register_page_bootmem_info_section(unsigned long start_pfn)
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 
 }
+#else
+static inline void register_page_bootmem_info_section(unsigned long start_pfn)
+{
+}
+#endif
 
 void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
@@ -198,7 +203,6 @@ void register_page_bootmem_info_node(struct pglist_data *pgdat)
 		register_page_bootmem_info_section(pfn);
 
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
 			   unsigned long end_pfn)
-- 
1.7.1

