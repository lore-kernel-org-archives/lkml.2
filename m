Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab2HCHpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:45:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:18201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab2HCHpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:45:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,705,1336320000"; 
   d="scan'208";a="5544426"
From: wency@cn.fujitsu.com
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com
Cc: rientjes@google.com, liuj97@gmail.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        Wen Congyang <wency@cn.fujitsu.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH V6 02/19] memory-hotplug: implement offline_memory()
Date: Fri, 3 Aug 2012 15:49:04 +0800
Message-Id: <1343980161-14254-3-git-send-email-wency@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
References: <1343980161-14254-1-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/03 15:45:25,
	Serialize complete at 2012/08/03 15:45:25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The function offline_memory() will be called when hot removing a
memory device. The memory device may contain more than one memory
block. If the memory block has been offlined, __offline_pages()
will fail. So we should try to offline one memory block at a
time.

If the memory block is offlined in offline_memory(), we also
update it's state, and notify the userspace that its state is
changed.

The function offline_memory() also check each memory block's
state. So there is no need to check the memory block's state
before calling offline_memory().

CC: David Rientjes <rientjes@google.com>
CC: Jiang Liu <liuj97@gmail.com>
CC: Len Brown <len.brown@intel.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
CC: Christoph Lameter <cl@linux.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 drivers/base/memory.c          |   31 +++++++++++++++++++++++++++----
 include/linux/memory_hotplug.h |    2 ++
 mm/memory_hotplug.c            |   37 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 44e7de6..86c8821 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -275,13 +275,11 @@ memory_block_action(unsigned long phys_index, unsigned long action)
 	return ret;
 }
 
-static int memory_block_change_state(struct memory_block *mem,
+static int __memory_block_change_state(struct memory_block *mem,
 		unsigned long to_state, unsigned long from_state_req)
 {
 	int ret = 0;
 
-	mutex_lock(&mem->state_mutex);
-
 	if (mem->state != from_state_req) {
 		ret = -EINVAL;
 		goto out;
@@ -309,10 +307,20 @@ static int memory_block_change_state(struct memory_block *mem,
 		break;
 	}
 out:
-	mutex_unlock(&mem->state_mutex);
 	return ret;
 }
 
+static int memory_block_change_state(struct memory_block *mem,
+		unsigned long to_state, unsigned long from_state_req)
+{
+	int ret;
+
+	mutex_lock(&mem->state_mutex);
+	ret = __memory_block_change_state(mem, to_state, from_state_req);
+	mutex_unlock(&mem->state_mutex);
+
+	return ret;
+}
 static ssize_t
 store_mem_state(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
@@ -653,6 +661,21 @@ int unregister_memory_section(struct mem_section *section)
 }
 
 /*
+ * offline one memory block. If the memory block has been offlined, do nothing.
+ */
+int offline_memory_block(struct memory_block *mem)
+{
+	int ret = 0;
+
+	mutex_lock(&mem->state_mutex);
+	if (mem->state != MEM_OFFLINE)
+		ret = __memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
+	mutex_unlock(&mem->state_mutex);
+
+	return ret;
+}
+
+/*
  * Initialize the sysfs support for memory devices...
  */
 int __init memory_dev_init(void)
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index c183f39..0b040bb 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -10,6 +10,7 @@ struct page;
 struct zone;
 struct pglist_data;
 struct mem_section;
+struct memory_block;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
@@ -234,6 +235,7 @@ extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
+extern int offline_memory_block(struct memory_block *mem);
 extern int offline_memory(u64 start, u64 size);
 extern int sparse_add_one_section(struct zone *zone, unsigned long start_pfn,
 								int nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index c182c76..3113cd4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1001,7 +1001,42 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 
 int offline_memory(u64 start, u64 size)
 {
-	return -EINVAL;
+	struct memory_block *mem = NULL;
+	struct mem_section *section;
+	unsigned long start_pfn, end_pfn;
+	unsigned long pfn, section_nr;
+	int ret;
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = start_pfn + PFN_DOWN(size);
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		section_nr = pfn_to_section_nr(pfn);
+		if (!present_section_nr(section_nr))
+			continue;
+
+		section = __nr_to_section(section_nr);
+		/* same memblock? */
+		if (mem)
+			if ((section_nr >= mem->start_section_nr) &&
+			    (section_nr <= mem->end_section_nr))
+				continue;
+
+		mem = find_memory_block_hinted(section, mem);
+		if (!mem)
+			continue;
+
+		ret = offline_memory_block(mem);
+		if (ret) {
+			kobject_put(&mem->dev.kobj);
+			return ret;
+		}
+	}
+
+	if (mem)
+		kobject_put(&mem->dev.kobj);
+
+	return 0;
 }
 #else
 int offline_pages(u64 start, u64 size)
-- 
1.7.1

