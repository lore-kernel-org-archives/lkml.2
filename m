Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab0HCNmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:42:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49432 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab0HCNmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:42:39 -0400
Message-ID: <4C581CCB.7070806@austin.ibm.com>
Date: Tue, 03 Aug 2010 08:42:35 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 7/9] v4  Update the node sysfs code
References: <4C581A6D.9030908@austin.ibm.com>
In-Reply-To: <4C581A6D.9030908@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the node sysfs code to be aware of the new capability for a memory
block to contain multiple memory sections.  This requires an additional
parameter to unregister_mem_sect_under_nodes so that we know which memory
section of the memory block to unregister.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c |    2 +-
 drivers/base/node.c   |   12 ++++++++----
 include/linux/node.h  |    6 ++++--
 3 files changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/node.c
===================================================================
--- linux-2.6.orig/drivers/base/node.c	2010-08-02 13:57:20.000000000 -0500
+++ linux-2.6/drivers/base/node.c	2010-08-02 14:01:58.000000000 -0500
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
Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-08-02 14:01:04.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-08-02 14:01:58.000000000 -0500
@@ -555,9 +555,9 @@ int remove_memory_block(unsigned long no
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
+	unregister_mem_sect_under_nodes(mem, __section_nr(section));
 
 	if (atomic_dec_and_test(&mem->section_count)) {
-		unregister_mem_sect_under_nodes(mem);
 		mem_remove_simple_file(mem, phys_index);
 		mem_remove_simple_file(mem, end_phys_index);
 		mem_remove_simple_file(mem, state);
Index: linux-2.6/include/linux/node.h
===================================================================
--- linux-2.6.orig/include/linux/node.h	2010-08-02 13:57:20.000000000 -0500
+++ linux-2.6/include/linux/node.h	2010-08-02 14:01:58.000000000 -0500
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


