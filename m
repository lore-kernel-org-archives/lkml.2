Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0JVS0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:26:48 -0400
Received: from kroah.org ([198.145.64.141]:37857 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758981Ab0JVSZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:48 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Nathan Fontenot <nfont@austin.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/31] Driver core: Add mutex for adding/removing memory blocks
Date: Fri, 22 Oct 2010 11:25:14 -0700
Message-Id: <1287771916-15016-29-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Fontenot <nfont@austin.ibm.com>

Add a new mutex for use in adding and removing of memory blocks.  This
is needed to avoid any race conditions in which the same memory block could
be added and removed at the same time.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Reviewed-by: Robin Holt <holt@sgi.com>
Reviewed-By: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/memory.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 63c2560..5185bcf 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -27,6 +27,8 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+static DEFINE_MUTEX(mem_sysfs_mutex);
+
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -484,6 +486,8 @@ static int add_memory_block(int nid, struct mem_section *section,
 	if (!mem)
 		return -ENOMEM;
 
+	mutex_lock(&mem_sysfs_mutex);
+
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
 	mutex_init(&mem->state_mutex);
@@ -504,6 +508,7 @@ static int add_memory_block(int nid, struct mem_section *section,
 			ret = register_mem_sect_under_node(mem, nid);
 	}
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
 }
 
@@ -512,6 +517,7 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 {
 	struct memory_block *mem;
 
+	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
 	unregister_mem_sect_under_nodes(mem);
 	mem_remove_simple_file(mem, phys_index);
@@ -520,6 +526,7 @@ int remove_memory_block(unsigned long node_id, struct mem_section *section,
 	mem_remove_simple_file(mem, removable);
 	unregister_memory(mem, section);
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
 }
 
-- 
1.7.2

