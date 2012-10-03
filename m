Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab2JCKJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 06:09:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42676 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab2JCKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 06:09:52 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <506C0EC6.9000503@jp.fujitsu.com>
Date: Wed, 3 Oct 2012 19:09:10 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [PATCH 3/6] acpi,memory-hotplug : add physical memory hotplug code
 to acpi_memhotplug.c
References: <506C0AE8.40702@jp.fujitsu.com>
In-Reply-To: <506C0AE8.40702@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

For hot removing physical memory, the patch adds remove_memory() into
acpi_memory_remove_memory(). But we cannot support physical memory
hot remove. So remove_memory() do nothinig.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> 
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |   10 ++++++++++
 include/linux/memory_hotplug.h |    5 +++++
 mm/memory_hotplug.c            |    7 +++++++
 3 files changed, 22 insertions(+)

Index: linux-3.6/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-3.6.orig/drivers/acpi/acpi_memhotplug.c	2012-10-03 19:03:10.960400793 +0900
+++ linux-3.6/drivers/acpi/acpi_memhotplug.c	2012-10-03 19:03:26.818401966 +0900
@@ -310,6 +310,9 @@ static int acpi_memory_remove_memory(str
 {
 	int result;
 	struct acpi_memory_info *info, *n;
+	int node;
+
+	node = acpi_get_node(mem_device->device->handle);
 
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (!info->enabled)
@@ -319,6 +322,13 @@ static int acpi_memory_remove_memory(str
 		if (result)
 			return result;
 
+		if (node < 0)
+			node = memory_add_physaddr_to_nid(info->start_addr);
+
+		result = remove_memory(node, info->start_addr, info->length);
+		if (result)
+			return result;
+
 		list_del(&info->list);
 		kfree(info);
 	}
Index: linux-3.6/include/linux/memory_hotplug.h
===================================================================
--- linux-3.6.orig/include/linux/memory_hotplug.h	2012-10-03 19:03:10.963400796 +0900
+++ linux-3.6/include/linux/memory_hotplug.h	2012-10-03 19:03:26.820401968 +0900
@@ -222,6 +222,7 @@ static inline void unlock_memory_hotplug
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern int remove_memory(int nid, u64 start, u64 size);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -229,6 +230,10 @@ static inline int is_mem_section_removab
 {
 	return 0;
 }
+static inline int remove_memory(int nid, u64 start, u64 size)
+{
+	return -EBUSY;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
Index: linux-3.6/mm/memory_hotplug.c
===================================================================
--- linux-3.6.orig/mm/memory_hotplug.c	2012-10-03 19:03:10.962400795 +0900
+++ linux-3.6/mm/memory_hotplug.c	2012-10-03 19:04:15.493404911 +0900
@@ -1042,6 +1042,13 @@ int offline_memory(u64 start, u64 size)
 
 	return 0;
 }
+
+int remove_memory(int nid, u64 start, u64 size)
+{
+	/* It is not implemented yet*/
+	return 0;
+}
+EXPORT_SYMBOL_GPL(remove_memory);
 #else
 int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {

