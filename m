Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2GRKMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:12:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37658 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab2GRKMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:12:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50068B8E.1090408@jp.fujitsu.com>
Date: Wed, 18 Jul 2012 19:10:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH v4 5/13] memory-hotplug : does not release memory region
 in PAGES_PER_SECTION chunks
References: <50068974.1070409@jp.fujitsu.com>
In-Reply-To: <50068974.1070409@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since applying a patch(de7f0cba96786c), release_mem_region() has been changed
as called in PAGES_PER_SECTION chunks because register_memory_resource() is
called in PAGES_PER_SECTION chunks by add_memory(). But it seems firmware
dependency. If CRS are written in the PAGES_PER_SECTION chunks in ACPI DSDT
Table, register_memory_resource() is called in PAGES_PER_SECTION chunks.
But if CRS are written in the DIMM unit in ACPI DSDT Table,
register_memory_resource() is called in DIMM unit. So release_mem_region()
should not be called in PAGES_PER_SECTION chunks. The patch fixes it.

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
 arch/powerpc/platforms/pseries/hotplug-memory.c |   13 +++++++++----
 mm/memory_hotplug.c                             |    4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: linux-3.5-rc6/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc6.orig/mm/memory_hotplug.c	2012-07-18 17:51:03.933189930 +0900
+++ linux-3.5-rc6/mm/memory_hotplug.c	2012-07-18 17:51:17.550020005 +0900
@@ -358,11 +358,11 @@ int __remove_pages(struct zone *zone, un
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
+	release_mem_region(phys_start_pfn << PAGE_SHIFT,  nr_pages * PAGE_SIZE);
+
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
-		release_mem_region(pfn << PAGE_SHIFT,
-				   PAGES_PER_SECTION << PAGE_SHIFT);
 		ret = __remove_section(zone, __pfn_to_section(pfn));
 		if (ret)
 			break;
Index: linux-3.5-rc6/arch/powerpc/platforms/pseries/hotplug-memory.c
===================================================================
--- linux-3.5-rc6.orig/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-07-18 17:50:49.893365814 +0900
+++ linux-3.5-rc6/arch/powerpc/platforms/pseries/hotplug-memory.c	2012-07-18 17:51:17.553019968 +0900
@@ -77,7 +77,8 @@ static int pseries_remove_memblock(unsig
 {
 	unsigned long start, start_pfn;
 	struct zone *zone;
-	int ret;
+	int i, ret;
+	int sections_to_remove;
 
 	start_pfn = base >> PAGE_SHIFT;
 
@@ -97,9 +98,13 @@ static int pseries_remove_memblock(unsig
 	 * to sysfs "state" file and we can't remove sysfs entries
 	 * while writing to it. So we have to defer it to here.
 	 */
-	ret = __remove_pages(zone, start_pfn, memblock_size >> PAGE_SHIFT);
-	if (ret)
-		return ret;
+	sections_to_remove = (memblock_size >> PAGE_SHIFT) / PAGES_PER_SECTION;
+	for (i = 0; i < sections_to_remove; i++) {
+		unsigned long pfn = start_pfn + i * PAGES_PER_SECTION;
+		ret = __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Update memory regions for memory remove

