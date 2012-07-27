Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2G0K2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:28:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab2G0K2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:28:32 -0400
X-IronPort-AV: E=Sophos;i="4.77,666,1336320000"; 
   d="scan'208";a="5496425"
Message-ID: <50126E7D.1070807@cn.fujitsu.com>
Date: Fri, 27 Jul 2012 18:33:33 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
CC: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>
Subject: [RFC PATCH v5 14/19] memory-hotplug: move register_page_bootmem_info_node
 and put_page_bootmem for sparse-vmemmap
References: <50126B83.3050201@cn.fujitsu.com>
In-Reply-To: <50126B83.3050201@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:29:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/27 18:29:01,
	Serialize complete at 2012/07/27 18:29:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
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
index 0d500be..fe50a9b 100644
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
index eae946b..180d555 100644
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

