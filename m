Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0HCNjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:39:54 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55149 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756275Ab0HCNjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:39:53 -0400
Message-ID: <4C581C26.5080007@austin.ibm.com>
Date: Tue, 03 Aug 2010 08:39:50 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 4/9] v4  Add mutex for add/remove of memory blocks
References: <4C581A6D.9030908@austin.ibm.com>
In-Reply-To: <4C581A6D.9030908@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new mutex for use in adding and removing of memory blocks.  This
is needed to avoid any race conditions in which the same memory block could
be added and removed at the same time.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
---
 drivers/base/memory.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-08-02 13:35:00.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-08-02 13:45:34.000000000 -0500
@@ -27,6 +27,8 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+static struct mutex mem_sysfs_mutex;
+
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -485,6 +487,8 @@ static int add_memory_block(int nid, str
 	if (!mem)
 		return -ENOMEM;
 
+	mutex_lock(&mem_sysfs_mutex);
+
 	mem->start_phys_index = __section_nr(section);
 	mem->state = state;
 	atomic_inc(&mem->section_count);
@@ -508,6 +512,7 @@ static int add_memory_block(int nid, str
 			ret = register_mem_sect_under_node(mem, nid);
 	}
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
 }
 
@@ -516,6 +521,7 @@ int remove_memory_block(unsigned long no
 {
 	struct memory_block *mem;
 
+	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
 
 	if (atomic_dec_and_test(&mem->section_count)) {
@@ -528,6 +534,7 @@ int remove_memory_block(unsigned long no
 		unregister_memory(mem, section);
 	}
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
 }
 
@@ -562,6 +569,8 @@ int __init memory_dev_init(void)
 	if (ret)
 		goto out;
 
+	mutex_init(&mem_sysfs_mutex);
+
 	/*
 	 * Create entries for memory sections that were found
 	 * during boot and have been initialized

