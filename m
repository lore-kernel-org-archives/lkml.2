Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0GLPp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:45:29 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38253 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0GLPp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:45:28 -0400
Message-ID: <4C3B3895.3040209@austin.ibm.com>
Date: Mon, 12 Jul 2010 10:45:25 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH 4/7] Allow sysfs memory directories to be split
References: <4C3B3446.5090302@austin.ibm.com>
In-Reply-To: <4C3B3446.5090302@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the new 'split' file in each memory sysfs
directory and the associated routines needed to handle splitting
a directory.

Signed-off-by; Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-07-09 14:23:20.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-07-09 14:38:09.000000000 -0500
@@ -32,6 +32,9 @@
 
 static int sections_per_block;
 
+static int register_memory(struct memory_block *, struct mem_section *,
+			   int, enum mem_add_context);
+
 static inline int base_memory_block_id(int section_nr)
 {
 	return (section_nr / sections_per_block) * sections_per_block;
@@ -309,11 +312,100 @@
 	return sprintf(buf, "%d\n", mem->phys_device);
 }
 
+static void update_memory_block_phys_indexes(struct memory_block *mem)
+{
+	struct list_head *pos;
+	struct memory_block_section *mbs;
+	unsigned long min_index = 0xffffffff;
+	unsigned long max_index = 0;
+
+	list_for_each(pos, &mem->sections) {
+		mbs = list_entry(pos, struct memory_block_section, next);
+
+		if (mbs->phys_index < min_index)
+			min_index = mbs->phys_index;
+
+		if (mbs->phys_index > max_index)
+			max_index = mbs->phys_index;
+	}
+
+	mem->start_phys_index = min_index;
+	mem->end_phys_index = max_index;
+}
+
+static ssize_t
+store_mem_split_block(struct sys_device *dev, struct sysdev_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct memory_block *mem, *new_mem_blk;
+	struct memory_block_section *mbs;
+	struct list_head *pos, *tmp;
+	struct mem_section *section;
+	int min_scn_nr = 0;
+	int max_scn_nr = 0;
+	int total_scns = 0;
+	int new_blk_min, new_blk_total;
+	int ret = -EINVAL;
+
+	mem = container_of(dev, struct memory_block, sysdev);
+
+	if (list_is_singular(&mem->sections))
+		return -EINVAL;
+
+	mutex_lock(&mem->state_mutex);
+
+	list_for_each(pos, &mem->sections) {
+		mbs = list_entry(pos, struct memory_block_section, next);
+
+		total_scns++;
+
+		if (min_scn_nr > mbs->phys_index)
+			min_scn_nr = mbs->phys_index;
+
+		if (max_scn_nr < mbs->phys_index)
+			max_scn_nr = mbs->phys_index;
+	}
+
+	new_mem_blk = kzalloc(sizeof(*new_mem_blk), GFP_KERNEL);
+	if (!new_mem_blk)
+		return -ENOMEM;
+
+	mutex_init(&new_mem_blk->state_mutex);
+	INIT_LIST_HEAD(&new_mem_blk->sections);
+	new_mem_blk->state = mem->state;
+
+	mutex_lock(&new_mem_blk->state_mutex);
+
+	new_blk_total = total_scns / 2;
+	new_blk_min = max_scn_nr - new_blk_total + 1;
+
+	section = __nr_to_section(new_blk_min);
+	ret = register_memory(new_mem_blk, section, 0, HOTPLUG);
+
+	list_for_each_safe(pos, tmp, &mem->sections) {
+		unsigned long scn_nr;
+
+		mbs = list_entry(pos, struct memory_block_section, next);
+		scn_nr = mbs->phys_index;
+
+		if ((scn_nr >= new_blk_min) && (scn_nr <= max_scn_nr))
+			list_move(&mbs->next, &new_mem_blk->sections);
+	}
+
+	update_memory_block_phys_indexes(mem);
+	update_memory_block_phys_indexes(new_mem_blk);
+
+	mutex_unlock(&new_mem_blk->state_mutex);
+	mutex_unlock(&mem->state_mutex);
+	return count;
+}
+
 static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
 static SYSDEV_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
 static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
 static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
 static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
+static SYSDEV_ATTR(split, 0200, NULL, store_mem_split_block);
 
 #define mem_create_simple_file(mem, attr_name)	\
 	sysdev_create_file(&mem->sysdev, &attr_##attr_name)
@@ -343,6 +435,8 @@
 		ret = mem_create_simple_file(memory, phys_device);
 	if (!ret)
 		ret = mem_create_simple_file(memory, removable);
+	if (!ret)
+		ret = mem_create_simple_file(memory, split);
 	if (!ret) {
 		if (context == HOTPLUG)
 			ret = register_mem_sect_under_node(memory, nid);
@@ -361,6 +455,7 @@
 	mem_remove_simple_file(memory, state);
 	mem_remove_simple_file(memory, phys_device);
 	mem_remove_simple_file(memory, removable);
+	mem_remove_simple_file(memory, split);
 
 	/* drop the ref. we got in remove_memory_block() */
 	kobject_put(&memory->sysdev.kobj);
@@ -568,8 +663,10 @@
 		kobject_put(&mem->sysdev.kobj);
 	}
 
-	if (!ret)
+	if (!ret) {
 		ret = add_mem_block_section(mem, __section_nr(section), state);
+		update_memory_block_phys_indexes(mem);
+	}
 
 	return ret;
 }
