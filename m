Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab0GOSkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:40:01 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57581 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934133Ab0GOSj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:39:59 -0400
Message-ID: <4C3F55FC.4050205@austin.ibm.com>
Date: Thu, 15 Jul 2010 13:39:56 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 3/5] v2 Change the mutex name in the memory_block struct
References: <4C3F53D1.3090001@austin.ibm.com>
In-Reply-To: <4C3F53D1.3090001@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the name of the memory_block mutex since it is now used for
more than just gating changes to the status of the memory sections
covered by the memory sysfs directory.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c  |   20 ++++++++++----------
 include/linux/memory.h |    9 +--------
 2 files changed, 11 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-07-15 09:56:05.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-07-15 09:56:10.000000000 -0500
@@ -144,14 +144,14 @@
 	int ret = 1;
 
 	mem = container_of(dev, struct memory_block, sysdev);
-	mutex_lock(&mem->state_mutex);
+	mutex_lock(&mem->mutex);
 
 	list_for_each_entry(mbs, &mem->sections, next) {
 		start_pfn = section_nr_to_pfn(mbs->phys_index);
 		ret &= is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
 	}
 
-	mutex_unlock(&mem->state_mutex);
+	mutex_unlock(&mem->mutex);
 	return sprintf(buf, "%d\n", ret);
 }
 
@@ -263,7 +263,7 @@
 	struct memory_block_section *mbs;
 	int ret = 0;
 
-	mutex_lock(&mem->state_mutex);
+	mutex_lock(&mem->mutex);
 
 	list_for_each_entry(mbs, &mem->sections, next) {
 		if (mbs->state != from_state_req)
@@ -288,7 +288,7 @@
 	if (!ret)
 		mem->state = to_state;
 
-	mutex_unlock(&mem->state_mutex);
+	mutex_unlock(&mem->mutex);
 	return ret;
 }
 
@@ -531,12 +531,12 @@
 			return -ENOMEM;
 
 		mem->state = state;
-		mutex_init(&mem->state_mutex);
+		mutex_init(&mem->mutex);
 		start_pfn = section_nr_to_pfn(__section_nr(section));
 		mem->phys_device = arch_get_memory_phys_device(start_pfn);
 		INIT_LIST_HEAD(&mem->sections);
 
-		mutex_lock(&mem->state_mutex);
+		mutex_lock(&mem->mutex);
 
 		ret = register_memory(mem, section);
 		if (!ret)
@@ -555,13 +555,13 @@
 		}
 	} else {
 		kobject_put(&mem->sysdev.kobj);
-		mutex_lock(&mem->state_mutex);
+		mutex_lock(&mem->mutex);
 	}
 
 	if (!ret)
 		ret = add_mem_block_section(mem, __section_nr(section), state);
 
-	mutex_unlock(&mem->state_mutex);
+	mutex_unlock(&mem->mutex);
 	return ret;
 }
 
@@ -573,7 +573,7 @@
 	int section_nr = __section_nr(section);
 
 	mem = find_memory_block(section);
-	mutex_lock(&mem->state_mutex);
+	mutex_lock(&mem->mutex);
 
 	/* remove the specified section */
 	list_for_each_entry_safe(mbs, tmp, &mem->sections, next) {
@@ -583,7 +583,7 @@
 		}
 	}
 
-	mutex_unlock(&mem->state_mutex);
+	mutex_unlock(&mem->mutex);
 
 	if (list_empty(&mem->sections)) {
 		unregister_mem_sect_under_nodes(mem);
Index: linux-2.6/include/linux/memory.h
===================================================================
--- linux-2.6.orig/include/linux/memory.h	2010-07-15 09:56:05.000000000 -0500
+++ linux-2.6/include/linux/memory.h	2010-07-15 09:56:10.000000000 -0500
@@ -31,14 +31,7 @@
 	unsigned long state;
 	unsigned long start_phys_index;
 	unsigned long end_phys_index;
-
-	/*
-	 * This serializes all state change requests.  It isn't
-	 * held during creation because the control files are
-	 * created long after the critical areas during
-	 * initialization.
-	 */
-	struct mutex state_mutex;
+	struct mutex mutex;
 	int phys_device;		/* to which fru does this belong? */
 	void *hw;			/* optional pointer to fw/hw data */
 	int (*phys_callback)(struct memory_block *);
