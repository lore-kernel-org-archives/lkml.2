Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1CPV15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:27:57 -0400
Received: from kroah.org ([198.145.64.141]:42593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab1CPVLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/50] memory hotplug: Update phys_index to [start|end]_section_nr
Date: Wed, 16 Mar 2011 14:10:52 -0700
Message-Id: <1300309888-5028-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Update the 'phys_index' property of a the memory_block struct to be
called start_section_nr, and add a end_section_nr property.  The
data tracked here is the same but the updated naming is more in line
with what is stored here, namely the first and last section number
that the memory block spans.

The names presented to userspace remain the same, phys_index for
start_section_nr and end_phys_index for end_section_nr, to avoid breaking
anything in userspace.

This also updates the node sysfs code to be aware of the new capability for
a memory block to contain multiple memory sections and be aware of the memory
block structure name changes (start_section_nr).  This requires an additional
parameter to unregister_mem_sect_under_nodes so that we know which memory
section of the memory block to unregister.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c  |   41 +++++++++++++++++++++++++++++++----------
 drivers/base/node.c    |   12 ++++++++----
 include/linux/memory.h |    3 ++-
 include/linux/node.h   |    6 ++++--
 4 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 0b70400..71b4a32 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -97,7 +97,7 @@ int register_memory(struct memory_block *memory)
 	int error;
 
 	memory->sysdev.cls = &memory_sysdev_class;
-	memory->sysdev.id = memory->phys_index / sections_per_block;
+	memory->sysdev.id = memory->start_section_nr / sections_per_block;
 
 	error = sysdev_register(&memory->sysdev);
 	return error;
@@ -138,12 +138,26 @@ static unsigned long get_memory_block_size(void)
  * uses.
  */
 
-static ssize_t show_mem_phys_index(struct sys_device *dev,
+static ssize_t show_mem_start_phys_index(struct sys_device *dev,
 			struct sysdev_attribute *attr, char *buf)
 {
 	struct memory_block *mem =
 		container_of(dev, struct memory_block, sysdev);
-	return sprintf(buf, "%08lx\n", mem->phys_index / sections_per_block);
+	unsigned long phys_index;
+
+	phys_index = mem->start_section_nr / sections_per_block;
+	return sprintf(buf, "%08lx\n", phys_index);
+}
+
+static ssize_t show_mem_end_phys_index(struct sys_device *dev,
+			struct sysdev_attribute *attr, char *buf)
+{
+	struct memory_block *mem =
+		container_of(dev, struct memory_block, sysdev);
+	unsigned long phys_index;
+
+	phys_index = mem->end_section_nr / sections_per_block;
+	return sprintf(buf, "%08lx\n", phys_index);
 }
 
 /*
@@ -158,7 +172,7 @@ static ssize_t show_mem_removable(struct sys_device *dev,
 		container_of(dev, struct memory_block, sysdev);
 
 	for (i = 0; i < sections_per_block; i++) {
-		pfn = section_nr_to_pfn(mem->phys_index + i);
+		pfn = section_nr_to_pfn(mem->start_section_nr + i);
 		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 	}
 
@@ -275,14 +289,15 @@ static int memory_block_change_state(struct memory_block *mem,
 		mem->state = MEM_GOING_OFFLINE;
 
 	for (i = 0; i < sections_per_block; i++) {
-		ret = memory_section_action(mem->phys_index + i, to_state);
+		ret = memory_section_action(mem->start_section_nr + i,
+					    to_state);
 		if (ret)
 			break;
 	}
 
 	if (ret) {
 		for (i = 0; i < sections_per_block; i++)
-			memory_section_action(mem->phys_index + i,
+			memory_section_action(mem->start_section_nr + i,
 					      from_state_req);
 
 		mem->state = from_state_req;
@@ -330,7 +345,8 @@ static ssize_t show_phys_device(struct sys_device *dev,
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
-static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
+static SYSDEV_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
+static SYSDEV_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
 static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
@@ -522,17 +538,21 @@ static int init_memory_block(struct memory_block **memory,
 		return -ENOMEM;
 
 	scn_nr = __section_nr(section);
-	mem->phys_index = base_memory_block_id(scn_nr) * sections_per_block;
+	mem->start_section_nr =
+			base_memory_block_id(scn_nr) * sections_per_block;
+	mem->end_section_nr = mem->start_section_nr + sections_per_block - 1;
 	mem->state = state;
 	mem->section_count++;
 	mutex_init(&mem->state_mutex);
-	start_pfn = section_nr_to_pfn(mem->phys_index);
+	start_pfn = section_nr_to_pfn(mem->start_section_nr);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
 
 	ret = register_memory(mem);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_index);
 	if (!ret)
+		ret = mem_create_simple_file(mem, end_phys_index);
+	if (!ret)
 		ret = mem_create_simple_file(mem, state);
 	if (!ret)
 		ret = mem_create_simple_file(mem, phys_device);
@@ -575,11 +595,12 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
+	unregister_mem_sect_under_nodes(mem, __section_nr(section));
 
 	mem->section_count--;
 	if (mem->section_count == 0) {
-		unregister_mem_sect_under_nodes(mem);
 		mem_remove_simple_file(mem, phys_index);
+		mem_remove_simple_file(mem, end_phys_index);
 		mem_remove_simple_file(mem, state);
 		mem_remove_simple_file(mem, phys_device);
 		mem_remove_simple_file(mem, removable);
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 36b4305..b3b72d6 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -375,8 +375,10 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 		return -EFAULT;
 	if (!node_online(nid))
 		return 0;
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
-	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
+
+	sect_start_pfn = section_nr_to_pfn(mem_blk->start_section_nr);
+	sect_end_pfn = section_nr_to_pfn(mem_blk->end_section_nr);
+	sect_end_pfn += PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int page_nid;
 
@@ -400,7 +402,8 @@ int register_mem_sect_under_node(struct memory_block *mem_blk, int nid)
 }
 
 /* unregister memory section under all nodes that it spans */
-int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+				    unsigned long phys_index)
 {
 	NODEMASK_ALLOC(nodemask_t, unlinked_nodes, GFP_KERNEL);
 	unsigned long pfn, sect_start_pfn, sect_end_pfn;
@@ -412,7 +415,8 @@ int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
 	if (!unlinked_nodes)
 		return -ENOMEM;
 	nodes_clear(*unlinked_nodes);
-	sect_start_pfn = section_nr_to_pfn(mem_blk->phys_index);
+
+	sect_start_pfn = section_nr_to_pfn(phys_index);
 	sect_end_pfn = sect_start_pfn + PAGES_PER_SECTION - 1;
 	for (pfn = sect_start_pfn; pfn <= sect_end_pfn; pfn++) {
 		int nid;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 06c1fa0..e1e3b2b 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -21,7 +21,8 @@
 #include <linux/mutex.h>
 
 struct memory_block {
-	unsigned long phys_index;
+	unsigned long start_section_nr;
+	unsigned long end_section_nr;
 	unsigned long state;
 	int section_count;
 
diff --git a/include/linux/node.h b/include/linux/node.h
index 1466945..92370e2 100644
--- a/include/linux/node.h
+++ b/include/linux/node.h
@@ -39,7 +39,8 @@ extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int register_mem_sect_under_node(struct memory_block *mem_blk,
 						int nid);
-extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk);
+extern int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+					   unsigned long phys_index);
 
 #ifdef CONFIG_HUGETLBFS
 extern void register_hugetlbfs_with_node(node_registration_func_t doregister,
@@ -67,7 +68,8 @@ static inline int register_mem_sect_under_node(struct memory_block *mem_blk,
 {
 	return 0;
 }
-static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk)
+static inline int unregister_mem_sect_under_nodes(struct memory_block *mem_blk,
+						  unsigned long phys_index)
 {
 	return 0;
 }
-- 
1.7.4.1

