Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab2F0FqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:46:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38677 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2F0FqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:46:09 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FEA9E0A.1040202@jp.fujitsu.com>
Date: Wed, 27 Jun 2012 14:45:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <len.brown@intel.com>, <benh@kernel.crashing.org>, <paulus@samba.org>,
        <cl@linux.com>, <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH 3/12] memory-hotplug : add physical memory hotplug code
 to acpi_memory_device_remove
References: <4FEA9C88.1070800@jp.fujitsu.com>
In-Reply-To: <4FEA9C88.1070800@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_memory_device_remove() has been prepared to remove physical memory.
But, the function only frees acpi_memory_device currentlry.

The patch adds following functions into acpi_memory_device_remove():
  - offline memory
  - remove physical memory (only return -EBUSY)
  - free acpi_memory_device

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
 drivers/acpi/acpi_memhotplug.c |   23 ++++++++++++++++++++++-
 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |    8 ++++++++
 3 files changed, 31 insertions(+), 1 deletion(-)

Index: linux-3.5-rc4/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-3.5-rc4.orig/drivers/acpi/acpi_memhotplug.c	2012-06-26 13:28:16.722211802 +0900
+++ linux-3.5-rc4/drivers/acpi/acpi_memhotplug.c	2012-06-26 13:38:01.085906251 +0900
@@ -452,12 +452,33 @@ static int acpi_memory_device_add(struct
 static int acpi_memory_device_remove(struct acpi_device *device, int type)
 {
 	struct acpi_memory_device *mem_device = NULL;
-
+	struct acpi_memory_info *info, *tmp;
+	int result;
+	int node;

 	if (!device || !acpi_driver_data(device))
 		return -EINVAL;

 	mem_device = acpi_driver_data(device);
+
+	node = acpi_get_node(mem_device->device->handle);
+
+	list_for_each_entry_safe(info, tmp, &mem_device->res_list, list) {
+		if (!info->enabled)
+			continue;
+
+		result = offline_memory(info->start_addr, info->length);
+		if (result)
+			return result;
+
+		result = remove_memory(node, info->start_addr, info->length);
+		if (result)
+			return result;
+
+		list_del(&info->list);
+		kfree(info);
+	}
+
 	kfree(mem_device);

 	return 0;
Index: linux-3.5-rc4/include/linux/memory_hotplug.h
===================================================================
--- linux-3.5-rc4.orig/include/linux/memory_hotplug.h	2012-06-26 13:28:16.773211163 +0900
+++ linux-3.5-rc4/include/linux/memory_hotplug.h	2012-06-26 13:37:30.545288962 +0900
@@ -233,6 +233,7 @@ static inline int is_mem_section_removab
 extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
+extern int remove_memory(int nid, u64 start, u64 size);
 extern int offline_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
Index: linux-3.5-rc4/mm/memory_hotplug.c
===================================================================
--- linux-3.5-rc4.orig/mm/memory_hotplug.c	2012-06-26 13:34:22.425639879 +0900
+++ linux-3.5-rc4/mm/memory_hotplug.c	2012-06-26 13:48:30.096046767 +0900
@@ -659,6 +659,14 @@ out:
 }
 EXPORT_SYMBOL_GPL(add_memory);

+int remove_memory(int nid, u64 start, u64 size)
+{
+	return -EBUSY;
+
+}
+EXPORT_SYMBOL_GPL(remove_memory);
+
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 /*
  * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy


