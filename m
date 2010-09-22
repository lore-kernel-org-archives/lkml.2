Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0IVOe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:34:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41431 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0IVOeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:34:25 -0400
Message-ID: <4C9A13ED.2050703@austin.ibm.com>
Date: Wed, 22 Sep 2010 09:34:21 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 6/8] Update node sysfs code
References: <4C9A0F8F.2030409@austin.ibm.com>
In-Reply-To: <4C9A0F8F.2030409@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the node sysfs code to be aware of the new capability for a memory
block to span multiple memory sections.  This requires an additional
parameter to unregister_mem_sect_under_nodes so that we know which memory
section of the memory block to unregister.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 drivers/base/memory.c |    4 +++-
 drivers/base/node.c   |   12 ++++++++----
 include/linux/node.h  |    6 ++++--
 3 files changed, 15 insertions(+), 7 deletions(-)

Index: linux-next/drivers/base/node.c
===================================================================
--- linux-next.orig/drivers/base/node.c	2010-09-21 11:59:24.000000000 -0500
+++ linux-next/drivers/base/node.c	2010-09-21 12:38:02.000000000 -0500
@@ -346,8 +346,10 @@ int register_mem_sect_under_node(struct
 		return -EFAULT;
 	if (!node_online(nid))
 		return 0;
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
-	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+
+	sect_start_pfn = section_nr_to_pfn(mem_blk->start_phys_index);
+	sect_end_pfn = section_nr_to_pfn(mem_blk->end_phys_index);
+	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid;
 
@@ -371,7 +373,8 @@ int register_mem_sect_under_node(struct
 }
 
 /* unregister memory section under all nodes that it spans */
-int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+				    unsigned long phys_index)
 {
 	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -383,7 +386,8 @@ int unregister_mem_sect_under_nodes(stru
 	if (!unlinked_nodes)
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
+
+	sect_start_pfn = section_nr_to_pfn(phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid;
Index: linux-next/drivers/base/memory.c
===================================================================
--- linux-next.orig/drivers/base/memory.c	2010-09-21 12:37:30.000000000 -0500
+++ linux-next/drivers/base/memory.c	2010-09-21 12:38:02.000000000 -0500
@@ -555,9 +555,9 @@ int remove_memory_block(unsigned long no
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
+	unregister_mem_sect_under_nodes(mem, __section_nr(section));
 
 	if (atomic_dec_and_test(&mem->section_count)) {
-		unregister_mem_sect_under_nodes(mem);
 		mem_remove_simple_file(mem, phys_index);
 		mem_remove_simple_file(mem, end_phys_index);
 		mem_remove_simple_file(mem, state);
@@ -631,6 +631,7 @@ int __init memory_dev_init(void)
 	 * Create entries for memory sections that were found
 	 * during boot and have been initialized
 	 */
+	printk(KERN_ERR "Memory Start\n");
 	for (i = 0; i < NR_MEM_SECTIONS; i++) {
 		if (!present_section_nr(i))
 			continue;
@@ -639,6 +640,7 @@ int __init memory_dev_init(void)
 		if (!ret)
 			ret = err;
 	}
+	printk(KERN_ERR "Memory End\n");
 
 	err = memory_probe_init();
 	if (!ret)
Index: linux-next/include/linux/node.h
===================================================================
--- linux-next.orig/include/linux/node.h	2010-09-21 11:59:28.000000000 -0500
+++ linux-next/include/linux/node.h	2010-09-21 12:38:02.000000000 -0500
@@ -44,7 +44,8 @@ extern int register_cpu_under_node(unsig
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						int nid);
-extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
+extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+					   unsigned long phys_index);
 
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
@@ -72,7 +73,8 @@ static inline int register_mem_sect_unde
 {
 	return 0;
 }
-static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+						  unsigned long phys_index)
 {
 	return 0;
 }

