Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933451Ab0I0TVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:21:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34667 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933439Ab0I0TVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:21:23 -0400
Message-ID: <4CA0EEA8.4050009@austin.ibm.com>
Date: Mon, 27 Sep 2010 14:21:12 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/8] v2 Move find_memory_block() routine
References: <4CA0EBEB.1030204@austin.ibm.com>
In-Reply-To: <4CA0EBEB.1030204@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the find_memory_block() routine up to avoid needing a forward
declaration in subsequent patches.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 drivers/base/memory.c |   62 +++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

Index: linux-next/drivers/base/memory.c
===================================================================
--- linux-next.orig/drivers/base/memory.c	2010-09-21 11:59:24.000000000 -0500
+++ linux-next/drivers/base/memory.c	2010-09-21 12:32:45.000000000 -0500
@@ -435,6 +435,37 @@ int __weak arch_get_memory_phys_device(u
 	return 0;
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
+	struct kobject *kobj;
+	struct sys_device *sysdev;
+	struct memory_block *mem;
+	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
+
+	/*
+	 * This only works because we know that section == sysdev->id
+	 * slightly redundant with sysdev_register()
+	 */
+	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, __section_nr(section));
+
+	kobj = kset_find_obj(&memory_sysdev_class.kset, name);
+	if (!kobj)
+		return NULL;
+
+	sysdev = container_of(kobj, struct sys_device, kobj);
+	mem = container_of(sysdev, struct memory_block, sysdev);
+
+	return mem;
+}
+
 static int add_memory_block(int nid, struct mem_section *section,
 			unsigned long state, enum mem_add_context context)
 {
@@ -468,37 +499,6 @@ static int add_memory_block(int nid, str
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
-{
-	struct kobject *kobj;
-	struct sys_device *sysdev;
-	struct memory_block *mem;
-	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
-
-	/*
-	 * This only works because we know that section == sysdev->id
-	 * slightly redundant with sysdev_register()
-	 */
-	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, __section_nr(section));
-
-	kobj = kset_find_obj(&memory_sysdev_class.kset, name);
-	if (!kobj)
-		return NULL;
-
-	sysdev = container_of(kobj, struct sys_device, kobj);
-	mem = container_of(sysdev, struct memory_block, sysdev);
-
-	return mem;
-}
-
 int remove_memory_block(unsigned long node_id, struct mem_section *section,
 		int phys_device)
 {

