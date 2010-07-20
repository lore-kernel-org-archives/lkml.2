Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab0GTDyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 23:54:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45796 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab0GTDyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 23:54:01 -0400
Message-ID: <4C451DD6.3080005@austin.ibm.com>
Date: Mon, 19 Jul 2010 22:53:58 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, greg@kroah.com
Subject: [PATCH 3/8] v3 Add section count to memory_block
References: <4C451BF5.50304@austin.ibm.com>
In-Reply-To: <4C451BF5.50304@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section count property to the memory_block struct to track the number
of memory sections that have been added/removed from a emory block.

Signed-off-by: Nathan Fontenot <nfont@asutin.ibm.com>
---
 drivers/base/memory.c  |   19 ++++++++++++-------
 include/linux/memory.h |    2 ++
 2 files changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-07-19 20:43:49.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-07-19 20:44:01.000000000 -0500
@@ -487,6 +487,7 @@ static int add_memory_block(int nid, str
 
 	mem->start_phys_index = __section_nr(section);
 	mem->state = state;
+	atomic_inc(&mem->section_count);
 	mutex_init(&mem->state_mutex);
 	start_pfn = section_nr_to_pfn(mem->start_phys_index);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
@@ -516,13 +517,17 @@ int remove_memory_block(unsigned long no
 	struct memory_block *mem;
 
 	mem = find_memory_block(section);
-	unregister_mem_sect_under_nodes(mem);
-	mem_remove_simple_file(mem, start_phys_index);
-	mem_remove_simple_file(mem, end_phys_index);
-	mem_remove_simple_file(mem, state);
-	mem_remove_simple_file(mem, phys_device);
-	mem_remove_simple_file(mem, removable);
-	unregister_memory(mem, section);
+	atomic_dec(&mem->section_count);
+
+	if (atomic_read(&mem->section_count) == 0) {
+		unregister_mem_sect_under_nodes(mem);
+		mem_remove_simple_file(mem, start_phys_index);
+		mem_remove_simple_file(mem, end_phys_index);
+		mem_remove_simple_file(mem, state);
+		mem_remove_simple_file(mem, phys_device);
+		mem_remove_simple_file(mem, removable);
+		unregister_memory(mem, section);
+	}
 
 	return 0;
 }
Index: linux-2.6/include/linux/memory.h
===================================================================
--- linux-2.6.orig/include/linux/memory.h	2010-07-19 20:43:49.000000000 -0500
+++ linux-2.6/include/linux/memory.h	2010-07-19 20:44:01.000000000 -0500
@@ -19,11 +19,13 @@
 #include <linux/node.h>
 #include <linux/compiler.h>
 #include <linux/mutex.h>
+#include <asm/atomic.h>
 
 struct memory_block {
 	unsigned long start_phys_index;
 	unsigned long end_phys_index;
 	unsigned long state;
+	atomic_t section_count;
 	/*
 	 * This serializes all state change requests.  It isn't
 	 * held during creation because the control files are
