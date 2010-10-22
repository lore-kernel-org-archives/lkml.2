Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0JVS0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:26:33 -0400
Received: from kroah.org ([198.145.64.141]:37860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028Ab0JVSZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/31] Driver core: Add section count to memory_block struct
Date: Fri, 22 Oct 2010 11:25:15 -0700
Message-Id: <1287771916-15016-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Add a section count property to the memory_block struct to track the number
of memory sections that have been added/removed from a memory block. This
allows us to know when the last memory section of a memory block has been
removed so we can remove the memory block.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c  |   17 +++++++++++------
 include/linux/memory.h |    2 ++
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5185bcf..cafeaaf 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -490,6 +490,7 @@ static int add_memory_block(int nid, struct mem_section *section,
 
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
+	mem->section_count++;
 	mutex_init(&mem->state_mutex);
 	start_pfn = section_nr_to_pfn(mem->phys_index);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
@@ -519,12 +520,16 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
-	unregister_mem_sect_under_nodes(mem);
-	mem_remove_simple_file(mem, phys_index);
-	mem_remove_simple_file(mem, state);
-	mem_remove_simple_file(mem, phys_device);
-	mem_remove_simple_file(mem, removable);
-	unregister_memory(mem, section);
+
+	mem->section_count--;
+	if (mem->section_count == 0) {
+		unregister_mem_sect_under_nodes(mem);
+		mem_remove_simple_file(mem, phys_index);
+		mem_remove_simple_file(mem, state);
+		mem_remove_simple_file(mem, phys_device);
+		mem_remove_simple_file(mem, removable);
+		unregister_memory(mem, section);
+	}
 
 	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index c4f3127..06c1fa0 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -23,6 +23,8 @@
 struct memory_block {
 	unsigned long phys_index;
 	unsigned long state;
+	int section_count;
+
 	/*
 	 * This serializes all state change requests.  It isn't
 	 * held during creation because the control files are
-- 
1.7.2

