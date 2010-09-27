Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab0I0TX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:23:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35412 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab0I0TXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:23:55 -0400
Message-ID: <4CA0EF45.3000601@austin.ibm.com>
Date: Mon, 27 Sep 2010 14:23:49 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 3/8] v2 Add mutex for adding/removing memory blocks
References: <4CA0EBEB.1030204@austin.ibm.com>
In-Reply-To: <4CA0EBEB.1030204@austin.ibm.com>
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
 drivers/base/memory.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-next/drivers/base/memory.c
===================================================================
--- linux-next.orig/drivers/base/memory.c	2010-09-27 09:31:35.000000000 -0500
+++ linux-next/drivers/base/memory.c	2010-09-27 09:31:57.000000000 -0500
@@ -27,6 +27,8 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+static DEFINE_MUTEX(mem_sysfs_mutex);
+
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -476,6 +478,8 @@
 	if (!mem)
 		return -ENOMEM;
 
+	mutex_lock(&mem_sysfs_mutex);
+
 	mem->phys_index = __section_nr(section);
 	mem->state = state;
 	atomic_inc(&mem->section_count);
@@ -497,6 +501,7 @@
 			ret = register_mem_sect_under_node(mem, nid);
 	}
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return ret;
 }
 
@@ -505,6 +510,7 @@
 {
 	struct memory_block *mem;
 
+	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
 
 	if (atomic_dec_and_test(&mem->section_count)) {
@@ -516,6 +522,7 @@
 		unregister_memory(mem, section);
 	}
 
+	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
 }


