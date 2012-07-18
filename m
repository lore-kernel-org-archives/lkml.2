Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2GRKEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:04:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53219 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2GRKEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:04:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50068A2C.2030605@jp.fujitsu.com>
Date: Wed, 18 Jul 2012 19:04:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-acpi@vger.kernel.org>
CC: <rientjes@google.com>, <liuj97@gmail.com>, <len.brown@intel.com>,
        <benh@kernel.crashing.org>, <paulus@samba.org>, <cl@linux.com>,
        <minchan.kim@gmail.com>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <wency@cn.fujitsu.com>
Subject: [RFC PATCH 0/13] firmware_map : unify argument of firmware_map_add_early/hotplug
References: <50068974.1070409@jp.fujitsu.com>
In-Reply-To: <50068974.1070409@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two ways to create /sys/firmware/memmap/X sysfs:

  - firmware_map_add_early
    When the system starts, it is calledd from e820_reserve_resources()
  - firmware_map_add_hotplug
    When the memory is hot plugged, it is called from add_memory()

But these functions are called without unifying value of end argument as below:

  - end argument of firmware_map_add_early()   : start + size - 1
  - end argument of firmware_map_add_hogplug() : start + size

The patch unifies them to "start + size". Even if applying the patch,
/sys/firmware/memmap/X/end file content does not change.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 arch/x86/kernel/e820.c    |    2 +-
 drivers/firmware/memmap.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-3.5-rc6/arch/x86/kernel/e820.c
===================================================================
--- linux-3.5-rc6.orig/arch/x86/kernel/e820.c	2012-07-18 17:19:38.391365260 +0900
+++ linux-3.5-rc6/arch/x86/kernel/e820.c	2012-07-18 17:19:43.616300222 +0900
@@ -944,7 +944,7 @@ void __init e820_reserve_resources(void)
 	for (i = 0; i < e820_saved.nr_map; i++) {
 		struct e820entry *entry = &e820_saved.map[i];
 		firmware_map_add_early(entry->addr,
-			entry->addr + entry->size - 1,
+			entry->addr + entry->size,
 			e820_type_to_string(entry->type));
 	}
 }
Index: linux-3.5-rc6/drivers/firmware/memmap.c
===================================================================
--- linux-3.5-rc6.orig/drivers/firmware/memmap.c	2012-07-18 17:19:38.388365299 +0900
+++ linux-3.5-rc6/drivers/firmware/memmap.c	2012-07-18 18:30:47.608390251 +0900
@@ -98,7 +98,7 @@ static LIST_HEAD(map_entries);
 /**
  * firmware_map_add_entry() - Does the real work to add a firmware memmap entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  * @entry: Pre-allocated (either kmalloc() or bootmem allocator), uninitialised
  *         entry.
@@ -113,7 +113,7 @@ static int firmware_map_add_entry(u64 st
 	BUG_ON(start > end);
 
 	entry->start = start;
-	entry->end = end;
+	entry->end = end - 1;
 	entry->type = type;
 	INIT_LIST_HEAD(&entry->list);
 	kobject_init(&entry->kobj, &memmap_ktype);
@@ -148,7 +148,7 @@ static int add_sysfs_fw_map_entry(struct
  * firmware_map_add_hotplug() - Adds a firmware mapping entry when we do
  * memory hotplug.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function is for memory hotplug, it is
@@ -175,7 +175,7 @@ int __meminit firmware_map_add_hotplug(u
 /**
  * firmware_map_add_early() - Adds a firmware mapping entry.
  * @start: Start of the memory range.
- * @end:   End of the memory range (inclusive).
+ * @end:   End of the memory range.
  * @type:  Type of the memory range.
  *
  * Adds a firmware mapping entry. This function uses the bootmem allocator

