Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2LLX1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 18:27:17 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:24652 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2LLX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 18:27:15 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl, lenb@kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com,
        wency@cn.fujitsu.com, guohanjun@huawei.com, yinghai@kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 04/11] mm: Add memory hotplug handlers
Date: Wed, 12 Dec 2012 16:17:16 -0700
Message-Id: <1355354243-18657-5-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
References: <1355354243-18657-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added memory hotplug handlers.  mm_add_execute() onlines requested
memory ranges for hot-add and online operations, and mm_del_execute()
offlines them for hot-delete and offline operations.  They are also
used for rollback as well.

mm_del_validate() fails a request if a requested memory range is
non-movable for delete.  This check can be removed if we should
attempt to delete such range anyway (but can cause a rollback).

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index e4eeaca..107a39d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -29,6 +29,7 @@
 #include <linux/suspend.h>
 #include <linux/mm_inline.h>
 #include <linux/firmware-map.h>
+#include <linux/hotplug.h>
 
 #include <asm/tlbflush.h>
 
@@ -45,6 +46,9 @@ static void generic_online_page(struct page *page);
 
 static online_page_callback_t online_page_callback = generic_online_page;
 
+static int mm_add_execute(struct hp_request *req, int rollback);
+static int mm_del_execute(struct hp_request *req, int rollback);
+
 DEFINE_MUTEX(mem_hotplug_mutex);
 
 void lock_memory_hotplug(void)
@@ -1055,3 +1059,96 @@ int remove_memory(u64 start, u64 size)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 EXPORT_SYMBOL_GPL(remove_memory);
+
+static int mm_add_execute(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+	struct hp_memory *hp_mem;
+	int ret;
+
+	if (rollback)
+		return mm_del_execute(req, 0);
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_MEMORY)
+			continue;
+
+		hp_mem = &hp_dev->data.mem;
+
+		ret = add_memory(hp_mem->node,
+				hp_mem->start_addr, hp_mem->length);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int mm_del_validate(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+	struct hp_memory *hp_mem;
+	unsigned long start_pfn, nr_pages;
+
+	if (rollback)
+		return 0;
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_MEMORY)
+			continue;
+
+		hp_mem = &hp_dev->data.mem;
+		start_pfn = hp_mem->start_addr >> PAGE_SHIFT;
+		nr_pages = PAGE_ALIGN(hp_mem->length) >> PAGE_SHIFT;
+
+		/*
+		 * Check if this memory range is removable.  This check can
+		 * be removed if we should attempt to delete a non-movable
+		 * range.
+		 */
+		if (is_mem_section_removable(start_pfn, nr_pages)) {
+			pr_info("Memory [%#010llx-%#010llx] not removable\n",
+				hp_mem->start_addr,
+				hp_mem->start_addr + hp_mem->length-1);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int mm_del_execute(struct hp_request *req, int rollback)
+{
+	struct hp_device *hp_dev;
+	struct hp_memory *hp_mem;
+	int ret;
+
+	if (rollback)
+		return mm_add_execute(req, 0);
+
+	list_for_each_entry(hp_dev, &req->dev_list, list) {
+		if (hp_dev->class != HP_CLS_MEMORY)
+			continue;
+
+		hp_mem = &hp_dev->data.mem;
+
+		ret = remove_memory(hp_mem->start_addr, hp_mem->length);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int __init mm_hp_init(void)
+{
+	hp_register_handler(HP_ADD_EXECUTE, mm_add_execute,
+				HP_MEM_ADD_EXECUTE_ORDER);
+	hp_register_handler(HP_DEL_VALIDATE, mm_del_validate,
+				HP_MEM_DEL_VALIDATE_ORDER);
+	hp_register_handler(HP_DEL_EXECUTE, mm_del_execute,
+				HP_MEM_DEL_EXECUTE_ORDER);
+
+	return 0;
+}
+module_init(mm_hp_init);
-- 
1.7.11.7

