Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab0FYBG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 21:06:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50819 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab0FYBGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 21:06:54 -0400
Message-ID: <4C24012B.9030506@austin.ibm.com>
Date: Thu, 24 Jun 2010 20:06:51 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] memory hotplug disable boot option
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Proposed patch to disable memory hotplug via a boot option,
mem_hotplug=[on|off].  The patch only disables memory hotplug in that it 
prevents the creation of the memory sysfs directories for memory sections.

This patch is meant to help alleviate very long boot times on systems with
large memory (1+ TB) and many memory sections (10's of thousands).

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

---
 drivers/base/memory.c  |   33 +++++++++++++++++++++++++++++++++
 drivers/base/node.c    |    3 +++
 include/linux/memory.h |    2 ++
 3 files changed, 38 insertions(+)

Index: linux-2.6/drivers/base/memory.c
===================================================================
--- linux-2.6.orig/drivers/base/memory.c	2010-06-23 15:07:03.000000000 -0500
+++ linux-2.6/drivers/base/memory.c	2010-06-24 18:46:52.000000000 -0500
@@ -29,6 +29,24 @@
 
 #define MEMORY_CLASS_NAME	"memory"
 
+static int mem_hp_enabled __read_mostly = 1;
+
+static int __setup_memory_hotplug(char *option)
+{
+	if (!strcmp(option, "off"))
+		mem_hp_enabled = 0;
+	else if (!strcmp(option, "on"))
+		mem_hp_enabled = 1;
+
+	return 1;
+}
+__setup("mem_hotplug=", __setup_memory_hotplug);
+
+int memory_hotplug_enabled(void)
+{
+	return mem_hp_enabled;
+}
+
 static struct sysdev_class memory_sysdev_class = {
 	.name = MEMORY_CLASS_NAME,
 };
@@ -320,6 +338,9 @@
 
 static int block_size_init(void)
 {
+	if (!memory_hotplug_enabled())
+		return 0;
+
 	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
 				&attr_block_size_bytes.attr);
 }
@@ -442,6 +463,9 @@
 	unsigned long start_pfn;
 	int ret = 0;
 
+	if (!memory_hotplug_enabled())
+		return 0;
+
 	if (!mem)
 		return -ENOMEM;
 
@@ -483,6 +507,9 @@
 	struct memory_block *mem;
 	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
 
+	if (!memory_hotplug_enabled())
+		return NULL;
+
 	/*
 	 * This only works because we know that section == sysdev->id
 	 * slightly redundant with sysdev_register()
@@ -504,6 +531,9 @@
 {
 	struct memory_block *mem;
 
+	if (!memory_hotplug_enabled())
+		return 0;
+
 	mem = find_memory_block(section);
 	unregister_mem_sect_under_nodes(mem);
 	mem_remove_simple_file(mem, phys_index);
@@ -541,6 +571,9 @@
 	int ret;
 	int err;
 
+	if (!memory_hotplug_enabled())
+		return 0;
+
 	memory_sysdev_class.kset.uevent_ops = &memory_uevent_ops;
 	ret = sysdev_class_register(&memory_sysdev_class);
 	if (ret)
Index: linux-2.6/drivers/base/node.c
===================================================================
--- linux-2.6.orig/drivers/base/node.c	2010-06-23 15:07:03.000000000 -0500
+++ linux-2.6/drivers/base/node.c	2010-06-24 13:05:55.000000000 -0500
@@ -411,6 +411,9 @@
 	unsigned long pfn;
 	int err = 0;
 
+	if (!memory_hotplug_enabled())
+		return 0;
+
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
 		struct mem_section *mem_sect;
Index: linux-2.6/include/linux/memory.h
===================================================================
--- linux-2.6.orig/include/linux/memory.h	2010-06-23 15:07:24.000000000 -0500
+++ linux-2.6/include/linux/memory.h	2010-06-24 13:06:25.000000000 -0500
@@ -128,6 +128,8 @@
 #define hotplug_memory_notifier(fn, pri) do { } while (0)
 #endif
 
+extern int memory_hotplug_enabled(void);
+
 /*
  * 'struct memory_accessor' is a generic interface to provide
  * in-kernel access to persistent memory such as i2c or SPI EEPROMs
