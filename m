Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0I2TBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:01:20 -0400
Received: from relay3.sgi.com ([192.48.152.1]:47092 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754395Ab0I2TBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:01:17 -0400
Message-Id: <20100929190115.632695677@gulag1.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Wed, 29 Sep 2010 14:00:55 -0500
From: Robin Holt <holt@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>, Dave Hansen <haveblue@us.ibm.com>,
        Matt Tolentino <matthew.e.tolentino@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Badari Pulavarty <pbadari@us.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [Patch 2/3] Introduce find_memory_block_hinted which utilizes kset_find_obj_hinted.
References: <20100929190053.992911934@gulag1.americas.sgi.com>
Content-Disposition: inline; filename=add-find_memory_block_hinted
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a find_memory_block_hinted() which utilizes the
recently added kset_find_obj_hinted().

Signed-off-by: Robin Holt <holt@sgi.com>
To: Dave Hansen <haveblue@us.ibm.com>
To: Matt Tolentino <matthew.e.tolentino@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 drivers/base/memory.c  |   28 ++++++++++++++++++----------
 include/linux/memory.h |    2 ++
 2 files changed, 20 insertions(+), 10 deletions(-)

Index: pv1010359/drivers/base/memory.c
===================================================================
--- pv1010359.orig/drivers/base/memory.c	2010-09-29 11:25:41.000000000 -0500
+++ pv1010359/drivers/base/memory.c	2010-09-29 11:33:49.903994093 -0500
@@ -468,28 +468,23 @@ static int add_memory_block(int nid, str
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
 
@@ -499,6 +494,19 @@ struct memory_block *find_memory_block(s
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
Index: pv1010359/include/linux/memory.h
===================================================================
--- pv1010359.orig/include/linux/memory.h	2010-09-29 11:25:41.000000000 -0500
+++ pv1010359/include/linux/memory.h	2010-09-29 11:25:43.289450971 -0500
@@ -113,6 +113,8 @@ extern int memory_dev_init(void);
 extern int remove_memory_block(unsigned long, struct mem_section *, int);
 extern int memory_notify(unsigned long val, void *v);
 extern int memory_isolate_notify(unsigned long val, void *v);
+extern struct memory_block *find_memory_block_hinted(struct mem_section *,
+							struct memory_block *);
 extern struct memory_block *find_memory_block(struct mem_section *);
 #define CONFIG_MEM_BLOCK_SIZE	(PAGES_PER_SECTION<<PAGE_SHIFT)
 enum mem_add_context { BOOT, HOTPLUG };

