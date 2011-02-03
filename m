Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500Ab1BCQZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 11:25:50 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:33888 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1BCQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 11:25:39 -0500
Date: Thu, 3 Feb 2011 17:25:14 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R3 1/7] mm: Add add_registered_memory() to memory hotplug API
Message-ID: <20110203162514.GD1364@router-fw-old.local.net-space.pl>
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
index 8122018..fe63912 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -223,6 +223,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
+extern int add_registered_memory(int nid, u64 start, u64 size);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int remove_memory(u64 start, u64 size);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 321fc74..7947bdf 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -532,20 +532,12 @@ out:
 }
 
 /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
-int __ref add_memory(int nid, u64 start, u64 size)
+static int __ref __add_memory(int nid, u64 start, u64 size)
 {
 	pg_data_t *pgdat = NULL;
 	int new_pgdat = 0;
-	struct resource *res;
 	int ret;
 
-	lock_memory_hotplug();
-
-	res = register_memory_resource(start, size);
-	ret = -EEXIST;
-	if (!res)
-		goto out;
-
 	if (!node_online(nid)) {
 		pgdat = hotadd_new_pgdat(nid, start);
 		ret = -ENOMEM;
@@ -579,14 +571,48 @@ int __ref add_memory(int nid, u64 start, u64 size)
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
+	lock_memory_hotplug();
+	ret = __add_memory(nid, start, size);
+	unlock_memory_hotplug();
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
+	lock_memory_hotplug();
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
 	unlock_memory_hotplug();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(add_memory);
-- 
1.5.6.5

