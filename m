Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0LTN4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:56:16 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:51368 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab0LTNzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:55:40 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Dec 2010 08:55:39 EST
Date: Mon, 20 Dec 2010 14:46:40 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3] mm: Add add_registered_memory() to memory hotplug API
Message-ID: <20101220134640.GB6749@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add_registered_memory() adds memory ealier registered
as memory resource. It is required by memory hotplug
for Xen guests, however it could be used also by other
modules.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 include/linux/memory_hotplug.h |    1 +
 mm/memory_hotplug.c            |   50 ++++++++++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 864035f..2458b2f 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -203,6 +203,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
+extern int add_registered_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index dd186c1..b642f26 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -509,20 +509,12 @@ out:
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-int __ref add_memory(int nid, u64 start, u64 size)
+static int __ref __add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
 	int new_pgdat = 0;
-	struct resource *res;
 	int ret;
 
-	lock_system_sleep();
-
-	res = register_memory_resource(start, size);
-	ret = -EEXIST;
-	if (!res)
-		goto out;
-
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
@@ -556,14 +548,48 @@ int __ref add_memory(int nid, u64 start, u64 size)
 	goto out;
 
 error:
-	/* rollback pgdat allocation and others */
+	/* rollback pgdat allocation */
 	if (new_pgdat)
 		rollback_node_hotadd(nid, pgdat);
-	if (res)
-		release_memory_resource(res);
+
+out:
+	return ret;
+}
+
+int add_registered_memory(int nid, u64 start, u64 size)
+{
+	int ret;
+
+	lock_system_sleep();
+	ret = __add_memory(nid, start, size);
+	unlock_system_sleep();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(add_registered_memory);
+
+int add_memory(int nid, u64 start, u64 size)
+{
+	int ret = -EEXIST;
+	struct resource *res;
+
+	lock_system_sleep();
+
+	res = register_memory_resource(start, size);
+
+	if (!res)
+		goto out;
+
+	ret = __add_memory(nid, start, size);
+
+	if (!ret)
+		goto out;
+
+	release_memory_resource(res);
 
 out:
 	unlock_system_sleep();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
-- 
1.4.4.4

