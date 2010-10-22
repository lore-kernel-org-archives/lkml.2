Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab0JVSZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:52 -0400
Received: from kroah.org ([198.145.64.141]:37854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759011Ab0JVSZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/31] Driver core: Move find_memory_block routine
Date: Fri, 22 Oct 2010 11:25:13 -0700
Message-Id: <1287771916-15016-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Move the find_memory_block() routine up to avoid needing a forward
declaration in subsequent patches.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Reviewed-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |   66 ++++++++++++++++++++++++------------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a799440..63c2560 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -435,39 +435,6 @@ int __weak arch_get_memory_phys_device(unsigned long start_pfn)
 	return 0;
 }
 
-static int add_memory_block(int nid, struct mem_section *section,
-			unsigned long state, enum mem_add_context context)
-{
-	struct memory_block *mem = kzalloc(sizeof(*mem), GFP_KERNEL);
-	unsigned long start_pfn;
-	int ret = 0;
-
-	if (!mem)
-		return -ENOMEM;
-
-	mem->phys_index = __section_nr(section);
-	mem->state = state;
-	mutex_init(&mem->state_mutex);
-	start_pfn = section_nr_to_pfn(mem->phys_index);
-	mem->phys_device = arch_get_memory_phys_device(start_pfn);
-
-	ret = register_memory(mem, section);
-	if (!ret)
-		ret = mem_create_simple_file(mem, phys_index);
-	if (!ret)
-		ret = mem_create_simple_file(mem, state);
-	if (!ret)
-		ret = mem_create_simple_file(mem, phys_device);
-	if (!ret)
-		ret = mem_create_simple_file(mem, removable);
-	if (!ret) {
-		if (context == HOTPLUG)
-			ret = register_mem_sect_under_node(mem, nid);
-	}
-
-	return ret;
-}
-
 struct memory_block *find_memory_block_hinted(struct mem_section *section,
 					      struct memory_block *hint)
 {
@@ -507,6 +474,39 @@ struct memory_block *find_memory_block(struct mem_section *section)
 	return find_memory_block_hinted(section, NULL);
 }
 
+static int add_memory_block(int nid, struct mem_section *section,
+			unsigned long state, enum mem_add_context context)
+{
+	struct memory_block *mem = kzalloc(sizeof(*mem), GFP_KERNEL);
+	unsigned long start_pfn;
+	int ret = 0;
+
+	if (!mem)
+		return -ENOMEM;
+
+	mem->phys_index = __section_nr(section);
+	mem->state = state;
+	mutex_init(&mem->state_mutex);
+	start_pfn = section_nr_to_pfn(mem->phys_index);
+	mem->phys_device = arch_get_memory_phys_device(start_pfn);
+
+	ret = register_memory(mem, section);
+	if (!ret)
+		ret = mem_create_simple_file(mem, phys_index);
+	if (!ret)
+		ret = mem_create_simple_file(mem, state);
+	if (!ret)
+		ret = mem_create_simple_file(mem, phys_device);
+	if (!ret)
+		ret = mem_create_simple_file(mem, removable);
+	if (!ret) {
+		if (context == HOTPLUG)
+			ret = register_mem_sect_under_node(mem, nid);
+	}
+
+	return ret;
+}
+
 int remove_memory_block(unsigned long node_id, struct mem_section *section,
 		int phys_device)
 {
-- 
1.7.2

