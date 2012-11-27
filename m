Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab2K0J7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:59:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20521 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758729Ab2K0J61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:58:27 -0500
X-IronPort-AV: E=Sophos;i="4.83,327,1352044800"; 
   d="scan'208";a="6284844"
From: Wen Congyang <wency@cn.fujitsu.com>
To: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Jiang Liu <liuj97@gmail.com>,
        Len Brown <len.brown@intel.com>, benh@kernel.crashing.org,
        paulus@samba.org, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>
Subject: [Patch v4 11/12] memory-hotplug: remove sysfs file of node
Date: Tue, 27 Nov 2012 18:00:21 +0800
Message-Id: <1354010422-19648-12-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com>
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:53:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:57:50,
	Serialize complete at 2012/11/27 17:57:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new function try_offline_node() to
remove sysfs file of node when all memory sections of this
node are removed. If some memory sections of this node are
not removed, this function does nothing.

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/acpi/acpi_memhotplug.c |  8 +++++-
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            | 58 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 24c807f..0780f99 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -310,7 +310,9 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
 {
 	int result;
 	struct acpi_memory_info *info, *n;
+	int node;
 
+	node = acpi_get_node(mem_device->device->handle);
 
 	/*
 	 * Ask the VM to offline this memory range.
@@ -318,7 +320,11 @@ static int acpi_memory_disable_device(struct acpi_memory_device *mem_device)
 	 */
 	list_for_each_entry_safe(info, n, &mem_device->res_list, list) {
 		if (info->enabled) {
-			result = remove_memory(info->start_addr, info->length);
+			if (node < 0)
+				node = memory_add_physaddr_to_nid(
+					info->start_addr);
+			result = remove_memory(node, info->start_addr,
+				info->length);
 			if (result)
 				return result;
 		}
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index d4c4402..7b4cfe6 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -231,7 +231,7 @@ extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern int offline_memory_block(struct memory_block *mem);
 extern bool is_memblock_offlined(struct memory_block *mem);
-extern int remove_memory(u64 start, u64 size);
+extern int remove_memory(int node, u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
 extern void sparse_remove_one_section(struct zone *zone, struct mem_section *ms);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index aa97d56..449663e 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -29,6 +29,7 @@
 #include <linux/suspend.h>
 #include <linux/mm_inline.h>
 #include <linux/firmware-map.h>
+#include <linux/stop_machine.h>
 
 #include <asm/tlbflush.h>
 
@@ -1288,7 +1289,58 @@ static int is_memblock_offlined_cb(struct memory_block *mem, void *arg)
 	return ret;
 }
 
-int __ref remove_memory(u64 start, u64 size)
+static int check_cpu_on_node(void *data)
+{
+	struct pglist_data *pgdat = data;
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		if (cpu_to_node(cpu) == pgdat->node_id)
+			/*
+			 * the cpu on this node isn't removed, and we can't
+			 * offline this node.
+			 */
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+/* offline the node if all memory sections of this node are removed */
+static void try_offline_node(int nid)
+{
+	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
+	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+
+		if (!present_section_nr(section_nr))
+			continue;
+
+		if (pfn_to_nid(pfn) != nid)
+			continue;
+
+		/*
+		 * some memory sections of this node are not removed, and we
+		 * can't offline node now.
+		 */
+		return;
+	}
+
+	if (stop_machine(check_cpu_on_node, NODE_DATA(nid), NULL))
+		return;
+
+	/*
+	 * all memory/cpu of this node are removed, we can offline this
+	 * node now.
+	 */
+	node_set_offline(nid);
+	unregister_one_node(nid);
+}
+
+int __ref remove_memory(int nid, u64 start, u64 size)
 {
 	unsigned long start_pfn, end_pfn;
 	int ret = 0;
@@ -1335,6 +1387,8 @@ repeat:
 
 	arch_remove_memory(start, size);
 
+	try_offline_node(nid);
+
 	unlock_memory_hotplug();
 
 	return 0;
@@ -1344,7 +1398,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 {
 	return -EINVAL;
 }
-int remove_memory(u64 start, u64 size)
+int remove_memory(int nid, u64 start, u64 size)
 {
 	return -EINVAL;
 }
-- 
1.8.0

