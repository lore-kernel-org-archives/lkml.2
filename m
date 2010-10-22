Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0JVS1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:27:46 -0400
Received: from kroah.org ([198.145.64.141]:37844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758990Ab0JVSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Robin Holt <holt@sgi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/31] driver core: Introduce find_memory_block_hinted which utilizes kset_find_obj_hinted.
Date: Fri, 22 Oct 2010 11:25:10 -0700
Message-Id: <1287771916-15016-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

Introduce a find_memory_block_hinted() which utilizes the
recently added kset_find_obj_hinted().

Signed-off-by: Robin Holt <holt@sgi.com>
To: Dave Hansen <haveblue@us.ibm.com>
To: Matt Tolentino <matthew.e.tolentino@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c  |   28 ++++++++++++++++++----------
 include/linux/memory.h |    2 ++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 933442f..a799440 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -468,28 +468,23 @@ static int add_memory_block(int nid, struct mem_section *section,
 	return ret;
 }
 
-/*
- * For now, we have a linear search to go find the appropriate
- * memory_block corresponding to a particular phys_index. If
- * this gets to be a real problem, we can always use a radix
- * tree or something here.
- *
- * This could be made generic for all sysdev classes.
- */
-struct memory_block *find_memory_block(struct mem_section *section)
+struct memory_block *find_memory_block_hinted(struct mem_section *section,
+					      struct memory_block *hint)
 {
 	struct kobject *kobj;
 	struct sys_device *sysdev;
 	struct memory_block *mem;
 	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
 
+	kobj = hint ? &hint->sysdev.kobj : NULL;
+
 	/*
 	 * This only works because we know that section == sysdev->id
 	 * slightly redundant with sysdev_register()
 	 */
 	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, __section_nr(section));
 
-	kobj = kset_find_obj(&memory_sysdev_class.kset, name);
+	kobj = kset_find_obj_hinted(&memory_sysdev_class.kset, name, kobj);
 	if (!kobj)
 		return NULL;
 
@@ -499,6 +494,19 @@ struct memory_block *find_memory_block(struct mem_section *section)
 	return mem;
 }
 
+/*
+ * For now, we have a linear search to go find the appropriate
+ * memory_block corresponding to a particular phys_index. If
+ * this gets to be a real problem, we can always use a radix
+ * tree or something here.
+ *
+ * This could be made generic for all sysdev classes.
+ */
+struct memory_block *find_memory_block(struct mem_section *section)
+{
+	return find_memory_block_hinted(section, NULL);
+}
+
 int remove_memory_block(unsigned long node_id, struct mem_section *section,
 		int phys_device)
 {
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 85582e1..c4f3127 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -113,6 +113,8 @@ extern int memory_dev_init(void);
 extern int remove_memory_block(unsigned long, struct mem_section *, int);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
+extern struct memory_block *find_memory_block_hinted(struct mem_section *,
+							struct memory_block *);
 extern struct memory_block *find_memory_block(struct mem_section *);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 enum mem_add_context { BOOT, HOTPLUG };
-- 
1.7.2

