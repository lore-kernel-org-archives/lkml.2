Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0GLPod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:44:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53763 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0GLPoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:44:32 -0400
Message-ID: <4C3B384A.4000902@austin.ibm.com>
Date: Mon, 12 Jul 2010 10:44:10 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH 3/7] Update the [register,unregister]_memory routines
References: <4C3B3446.5090302@austin.ibm.com>
In-Reply-To: <4C3B3446.5090302@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the register/unregister_memory routines to
avoid a forward declaration.  It also moves the sysfs file
creation and deletion for each directory into the register/
unregister routines to avoid duplicating it with these updates.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c |   93 +++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 45 deletions(-)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-07-09 14:23:17.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-07-09 14:23:20.000000000 -0500
@@ -87,31 +87,6 @@
 EXPORT_SYMBOL(unregister_memory_isolate_notifier);
 
 /*
- * register_memory - Setup a sysfs device for a memory block
- */
-static
-int register_memory(struct memory_block *memory, struct mem_section *section)
-{
-	int error;
-
-	memory->sysdev.cls = &memory_sysdev_class;
-	memory->sysdev.id = __section_nr(section);
-
-	error = sysdev_register(&memory->sysdev);
-	return error;
-}
-
-static void
-unregister_memory(struct memory_block *memory)
-{
-	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
-
-	/* drop the ref. we got in remove_memory_block() */
-	kobject_put(&memory->sysdev.kobj);
-	sysdev_unregister(&memory->sysdev);
-}
-
-/*
  * use this as the physical section index that this memsection
  * uses.
  */
@@ -346,6 +321,53 @@
 	sysdev_remove_file(&mem->sysdev, &attr_##attr_name)
 
 /*
+ * register_memory - Setup a sysfs device for a memory block
+ */
+static
+int register_memory(struct memory_block *memory, struct mem_section *section,
+		    int nid, enum mem_add_context context)
+{
+	int ret;
+
+	memory->sysdev.cls = &memory_sysdev_class;
+	memory->sysdev.id = __section_nr(section);
+
+	ret = sysdev_register(&memory->sysdev);
+	if (!ret)
+		ret = mem_create_simple_file(memory, phys_index);
+	if (!ret)
+		ret = mem_create_simple_file(memory, end_phys_index);
+	if (!ret)
+		ret = mem_create_simple_file(memory, state);
+	if (!ret)
+		ret = mem_create_simple_file(memory, phys_device);
+	if (!ret)
+		ret = mem_create_simple_file(memory, removable);
+	if (!ret) {
+		if (context == HOTPLUG)
+			ret = register_mem_sect_under_node(memory, nid);
+	}
+
+	return ret;
+}
+
+static void
+unregister_memory(struct memory_block *memory)
+{
+	BUG_ON(memory->sysdev.cls != &memory_sysdev_class);
+
+	mem_remove_simple_file(memory, phys_index);
+	mem_remove_simple_file(memory, end_phys_index);
+	mem_remove_simple_file(memory, state);
+	mem_remove_simple_file(memory, phys_device);
+	mem_remove_simple_file(memory, removable);
+
+	/* drop the ref. we got in remove_memory_block() */
+	kobject_put(&memory->sysdev.kobj);
+	sysdev_unregister(&memory->sysdev);
+}
+
+/*
  * Block size attribute stuff
  */
 static ssize_t
@@ -541,21 +563,7 @@
 		mem->phys_device = arch_get_memory_phys_device(start_pfn);
 		INIT_LIST_HEAD(&mem->sections);
 
-		ret = register_memory(mem, section);
-		if (!ret)
-			ret = mem_create_simple_file(mem, phys_index);
-		if (!ret)
-			ret = mem_create_simple_file(mem, end_phys_index);
-		if (!ret)
-			ret = mem_create_simple_file(mem, state);
-		if (!ret)
-			ret = mem_create_simple_file(mem, phys_device);
-		if (!ret)
-			ret = mem_create_simple_file(mem, removable);
-		if (!ret) {
-			if (context == HOTPLUG)
-				ret = register_mem_sect_under_node(mem, nid);
-		}
+		ret = register_memory(mem, section, nid, context);
 	} else {
 		kobject_put(&mem->sysdev.kobj);
 	}
@@ -591,11 +599,6 @@
 
 	if (list_empty(&mem->sections)) {
 		unregister_mem_sect_under_nodes(mem);
-		mem_remove_simple_file(mem, phys_index);
-		mem_remove_simple_file(mem, end_phys_index);
-		mem_remove_simple_file(mem, state);
-		mem_remove_simple_file(mem, phys_device);
-		mem_remove_simple_file(mem, removable);
 		unregister_memory(mem);
 		kfree(mem);
 	}
