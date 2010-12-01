Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0LAF2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 00:28:24 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58710 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0LAF2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 00:28:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 1/2] mem-hotplug: Introduce {un}lock_memory_hotplug()
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101026163218.B7BF.A69D9226@jp.fujitsu.com>
References: <alpine.LSU.2.00.1010252248210.2939@sister.anvils> <20101026163218.B7BF.A69D9226@jp.fujitsu.com>
Message-Id: <20101201142722.ABCB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  1 Dec 2010 14:28:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, hwpoison are using lock_system_sleep() for prevent a race
with memory hotplug. However lock_system_sleep() is no-op if
CONFIG_HIBERNATION=n. Therefore we need new lock.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memory_hotplug.h |    6 ++++++
 mm/memory-failure.c            |    8 ++++----
 mm/memory_hotplug.c            |   31 ++++++++++++++++++++++++-------
 3 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 4307231..31c237a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -161,6 +161,9 @@ extern void register_page_bootmem_info_node(struct pglist_data *pgdat);
 extern void put_page_bootmem(struct page *page);
 #endif
 
+void lock_memory_hotplug(void);
+void unlock_memory_hotplug(void);
+
 #else /* ! CONFIG_MEMORY_HOTPLUG */
 /*
  * Stub functions for when hotplug is off
@@ -192,6 +195,9 @@ static inline void register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
 }
 
+static inline void lock_memory_hotplug(void) {}
+static inline void unlock_memory_hotplug(void) {}
+
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 1243241..46ab2c0 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/memory_hotplug.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1230,11 +1231,10 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 		return 1;
 
 	/*
-	 * The lock_system_sleep prevents a race with memory hotplug,
-	 * because the isolation assumes there's only a single user.
+	 * The lock_memory_hotplug prevents a race with memory hotplug.
 	 * This is a big hammer, a better would be nicer.
 	 */
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	/*
 	 * Isolate the page, so that it doesn't get reallocated if it
@@ -1264,7 +1264,7 @@ static int get_any_page(struct page *p, unsigned long pfn, int flags)
 		ret = 1;
 	}
 	unset_migratetype_isolate(p);
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 833e286..7549a01 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -34,6 +34,23 @@
 
 #include "internal.h"
 
+DEFINE_MUTEX(mem_hotplug_mutex);
+
+void lock_memory_hotplug(void)
+{
+	mutex_lock(&mem_hotplug_mutex);
+
+	/* for exclusive hibernation if CONFIG_HIBERNATION=y */
+	lock_system_sleep();
+}
+
+void unlock_memory_hotplug(void)
+{
+	unlock_system_sleep();
+	mutex_unlock(&mem_hotplug_mutex);
+}
+
+
 /* add this memory to iomem resource */
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
@@ -491,7 +508,7 @@ int mem_online_node(int nid)
 	pg_data_t	*pgdat;
 	int	ret;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
 	if (pgdat) {
 		ret = -ENOMEM;
@@ -502,7 +519,7 @@ int mem_online_node(int nid)
 	BUG_ON(ret);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
@@ -514,7 +531,7 @@ int __ref add_memory(int nid, u64 start, u64 size)
 	struct resource *res;
 	int ret;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	res = register_memory_resource(start, size);
 	ret = -EEXIST;
@@ -561,7 +578,7 @@ error:
 		release_memory_resource(res);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
@@ -789,7 +806,7 @@ static int offline_pages(unsigned long start_pfn,
 	if (!test_pages_in_a_zone(start_pfn, end_pfn))
 		return -EINVAL;
 
-	lock_system_sleep();
+	lock_memory_hotplug();
 
 	zone = page_zone(pfn_to_page(start_pfn));
 	node = zone_to_nid(zone);
@@ -877,7 +894,7 @@ repeat:
 	vm_total_pages = nr_free_pagecache_pages();
 
 	memory_notify(MEM_OFFLINE, &arg);
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return 0;
 
 failed_removal:
@@ -888,7 +905,7 @@ failed_removal:
 	undo_isolate_page_range(start_pfn, end_pfn);
 
 out:
-	unlock_system_sleep();
+	unlock_memory_hotplug();
 	return ret;
 }
 
-- 
1.6.5.2



