Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab0JASap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:30:45 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35761 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0JASao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:30:44 -0400
Message-ID: <4CA628D0.6030508@austin.ibm.com>
Date: Fri, 01 Oct 2010 13:30:40 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org
CC: Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: [PATCH 3/9] v3 Add section count to memory_block struct
References: <4CA62700.7010809@austin.ibm.com>
In-Reply-To: <4CA62700.7010809@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a section count property to the memory_block struct to track the number
of memory sections that have been added/removed from a memory block. This
allows us to know when the last memory section of a memory block has been
removed so we can remove the memory block.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 drivers/base/memory.c  |   17 +++++++++++------
 include/linux/memory.h |    2 ++
 2 files changed, 13 insertions(+), 6 deletions(-)

Index: linux-next/drivers/base/memory.c
===================================================================
--- linux-next.orig/drivers/base/memory.c	2010-09-30 14:12:41.000000000 -0500
+++ linux-next/drivers/base/memory.c	2010-09-30 14:13:50.000000000 -0500
@@ -482,6 +482,7 @@
 
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
+	mem->section_count++;
 	mutex_init(&mem->state_mutex);
 	start_pfn = section_nr_to_pfn(mem->phys_index);
 	mem->phys_device = arch_get_memory_phys_device(start_pfn);
@@ -511,12 +512,16 @@
 
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
Index: linux-next/include/linux/memory.h
===================================================================
--- linux-next.orig/include/linux/memory.h	2010-09-29 14:56:29.000000000 -0500
+++ linux-next/include/linux/memory.h	2010-09-30 14:13:50.000000000 -0500
@@ -23,6 +23,8 @@
 struct memory_block {
 	unsigned long phys_index;
 	unsigned long state;
+	int section_count;
+
 	/*
 	 * This serializes all state change requests.  It isn't
 	 * held during creation because the control files are
