Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0CVTwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab0CVTwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:52:19 -0400
Date: Mon, 22 Mar 2010 15:51:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: catalin.marinas@arm.com, jbarnes@virtuousgeek.org, prarit@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] kmemleak vs. memory hotplug
Message-ID: <20100322195149.GA2278@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed in the Kconfig that kmemleak can not be set without
MEMORY_HOTPLUG being unset. I'd like to be able to enable both. Below,
is an rfc patch, completely untested, as a starting point. Hopefully,
ppl more knowledgeable in this area can comment.

thanks,

-Jason



diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 99d9a67..ad89f2d 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -54,6 +54,18 @@ static inline void kmemleak_erase(void **ptr)
 	*ptr = NULL;
 }
 
+extern struct mutex kmemleak_hotplug;
+
+static inline void lock_system_kmemleak(void)
+{
+        mutex_lock(&kmemleak_hotplug);
+}
+
+static inline void unlock_system_kmemleak(void)
+{
+        mutex_unlock(&kmemleak_hotplug);
+}
+
 #else
 
 static inline void kmemleak_init(void)
@@ -93,6 +105,14 @@ static inline void kmemleak_no_scan(const void *ptr)
 {
 }
 
+static inline void lock_system_kmemleak(void)
+{
+}
+
+static inline void unlock_system_kmemleak(void) 
+{
+}
+
 #endif	/* CONFIG_DEBUG_KMEMLEAK */
 
 #endif	/* __KMEMLEAK_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4a50fc1..2e89153 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -365,14 +365,13 @@ config SLUB_STATS
 
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && !MEMORY_HOTPLUG && \
+	depends on DEBUG_KERNEL && EXPERIMENTAL && \
 		(X86 || ARM || PPC || S390 || SUPERH)
 
 	select DEBUG_FS if SYSFS
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
 	select CRC32
-	depends on 0
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5b069e4..509a728 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -102,6 +102,9 @@
 #include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 
+/* exlcludes memory hotplug */
+DEFINE_MUTEX(kmemleak_hotplug);
+
 /*
  * Kmemleak configuration and common defines.
  */
@@ -1178,6 +1181,7 @@ static void kmemleak_scan(void)
 	 * Struct page scanning for each node. The code below is not yet safe
 	 * with MEMORY_HOTPLUG.
 	 */
+	mutex_lock(&kmemleak_hotplug);
 	for_each_online_node(i) {
 		pg_data_t *pgdat = NODE_DATA(i);
 		unsigned long start_pfn = pgdat->node_start_pfn;
@@ -1196,6 +1200,7 @@ static void kmemleak_scan(void)
 			scan_block(page, page + 1, NULL, 1);
 		}
 	}
+	mutex_unlock(&kmemleak_hotplug);
 
 	/*
 	 * Scanning the task stacks (may introduce false negatives).
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 78e34e6..01fc57d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -34,6 +34,23 @@
 
 #include "internal.h"
 
+/* exclude subsystems that hotplug might conflict with */
+static void lock_hotplug_exlucde(void)
+{
+	/* exclude hotplug */
+	lock_system_sleep();
+	/* exlucde kmemleak */
+	lock_system_kmemleak();
+}
+
+static void unlock_hotplug_exlucde(void)
+{
+	/* exclude hotplug */
+	unlock_system_sleep();
+	/* exlucde kmemleak */
+	unlock_system_kmemleak();
+}
+
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
@@ -490,7 +507,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
 	struct resource *res;
 	int ret;
 
-	lock_system_sleep();
+	lock_hotplug_exclude();
 
 	res = register_memory_resource(start, size);
 	ret = -EEXIST;
@@ -537,7 +554,7 @@ error:
 		release_memory_resource(res);
 
 out:
-	unlock_system_sleep();
+	unlock_hotplug_exclude();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -777,7 +794,7 @@ static int offline_pages(unsigned long start_pfn,
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
-	lock_system_sleep();
+	lock_hotplug_exclude();
 
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
@@ -868,7 +885,7 @@ repeat:
 	writeback_set_ratelimit();
 
 	memory_notify(MEM_OFFLINE, &arg);
-	unlock_system_sleep();
+	unlock_hotplug_exclude();
 	return 0;
 
 failed_removal:
@@ -879,7 +896,7 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 
 out:
-	unlock_system_sleep();
+	unlock_hotplug_exclude();
 	return ret;
 }
 

