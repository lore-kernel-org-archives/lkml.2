Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702Ab0GPOVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 10:21:01 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48789 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965654Ab0GPOVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 10:21:00 -0400
Date: Fri, 16 Jul 2010 16:20:37 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: jeremy@goop.org, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] GSoC 2010 - Memory hotplug support for Xen guests - patch for review only
Message-ID: <20100716142036.GA21111@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

As I promised I am sending first patch which enables
memory hotplug in Xen guests. It is version for review
only. It has been tested on Xen Ver 4.0.0 in PV guest x86_64
with Linux kernel Ver. 2.6.32.16. In general it works,
however... For details look below...

This patch enables two modes of operation:
  - enabled by CONFIG_XEN_MEMORY_HOTPLUG config option:
      - set memory limit for chosen domU from dom0:
          xm mem-max <domU> <new_memory_size_limit>
      - add memory in chosen domU: echo <unused_address> > \
          /sys/devices/system/memory/probe
      - online memory in chosen domU: echo online > \
          /sys/devices/system/memory/memory<section_number>/state
  - enabled by CONFIG_XEN_BALLOON_MEMORY_HOTPLUG config option:
      - set memory limit for chosen domU from dom0:
          xm mem-max <domU> <new_memory_size_limit>
      - add memory for chosen domU from dom0:
          xm mem-set <domU> <new_memory_size>

TODO:
  - there is bug which generate oops when memory
    is added and removed a few times from domU
    (CONFIG_XEN_BALLOON_MEMORY_HOTPLUG); probably
    I missed something,
  - there is no synchronization between CONFIG_XEN_MEMORY_HOTPLUG
    and CONFIG_XEN_BALLOON_MEMORY_HOTPLUG yet; memory
    added from domU is not added to balloon_stats,
  - some additional error checking should be implemented,
  - final patch will be available for Linux kernel
    Ver. 2.6.32.y, latest stable and RC,
  - tests on all planned platforms.

I am waiting for your comments.
    
Daniel

diff -Nru linux-2.6.32.16.orig/drivers/base/memory.c linux-2.6.32.16/drivers/base/memory.c
--- linux-2.6.32.16.orig/drivers/base/memory.c	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/base/memory.c	2010-07-16 11:48:45.000000000 +0200
@@ -3,6 +3,7 @@
  *
  * Written by Matt Tolentino <matthew.e.tolentino@intel.com>
  *            Dave Hansen <haveblue@us.ibm.com>
+ *            Daniel Kiper <dkiper@net-space.pl>
  *
  * This file provides the necessary infrastructure to represent
  * a SPARSEMEM-memory-model system's physical memory in /sysfs.
@@ -26,6 +27,16 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+#include <linux/vmalloc.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/features.h>
+#include <xen/page.h>
+#endif
+
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -314,13 +325,61 @@
 memory_probe_store(struct class *class, const char *buf, size_t count)
 {
 	u64 phys_addr;
-	int nid;
-	int ret;
+	long ret;
+
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid = DOMID_SELF,
+		.nr_extents = PAGES_PER_SECTION
+	};
+	unsigned long *frame_list, i, nr_pages, pfn;
+#endif
 
 	phys_addr = simple_strtoull(buf, NULL, 0);
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+	if (xen_domain()) {
+		if (!(frame_list = vmalloc(PAGES_PER_SECTION * sizeof(unsigned long)))) {
+			printk(KERN_ERR "%s: vmalloc: Out of memory\n", __func__);
+			return -ENOMEM;
+		}
+
+		set_xen_guest_handle(reservation.extent_start, frame_list);
+		for (i = 0, pfn = phys_addr >> PAGE_SHIFT; i < PAGES_PER_SECTION; ++i, ++pfn)
+			frame_list[i] = pfn;
+
+		ret = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+
+		if (ret < PAGES_PER_SECTION) {
+			if (ret > 0) {
+				printk(KERN_ERR "%s: PHYSMAP is not fully populated: %li/%lu\n",
+						__func__, ret, PAGES_PER_SECTION);
+				reservation.nr_extents = nr_pages = ret;
+				ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+				BUG_ON(ret != nr_pages);
+				ret = -ENOMEM;
+			} else {
+				ret = (ret < 0) ? ret : -ENOMEM;
+				printk(KERN_ERR "%s: Can't populate PHYSMAP: %li\n", __func__, ret);
+			}
+			vfree(frame_list);
+			return ret;
+		}
+
+		for (i = 0, pfn = phys_addr >> PAGE_SHIFT; i < PAGES_PER_SECTION; ++i, ++pfn) {
+			BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
+					phys_to_machine_mapping_valid(pfn));
+			set_phys_to_machine(pfn, frame_list[i]);
+		}
+
+		vfree(frame_list);
+	}
+#endif
+
+	ret = add_memory(memory_add_physaddr_to_nid(phys_addr),
+				phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
 
 	if (ret)
 		count = ret;
diff -Nru linux-2.6.32.16.orig/drivers/xen/Kconfig linux-2.6.32.16/drivers/xen/Kconfig
--- linux-2.6.32.16.orig/drivers/xen/Kconfig	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/xen/Kconfig	2010-07-09 21:04:17.000000000 +0200
@@ -7,6 +7,16 @@
 	  the system to expand the domain's memory allocation, or alternatively
 	  return unneeded memory to the system.
 
+config XEN_BALLOON_MEMORY_HOTPLUG
+	bool "Xen memory balloon driver with memory hotplug support"
+	depends on EXPERIMENTAL && XEN && XEN_BALLOON && MEMORY_HOTPLUG
+	default n
+	help
+	  Xen memory balloon driver with memory hotplug support allows expanding
+	  memory available for the system above limit declared at system startup.
+	  It is very useful on critical systems which require long run without
+	  rebooting.
+
 config XEN_SCRUB_PAGES
 	bool "Scrub pages before returning them to system"
 	depends on XEN_BALLOON
@@ -60,4 +70,4 @@
          Create entries under /sys/hypervisor describing the Xen
 	 hypervisor environment.  When running native or in another
 	 virtual environment, /sys/hypervisor will still be present,
-	 but will have no xen contents.
\ No newline at end of file
+	 but will have no xen contents.
diff -Nru linux-2.6.32.16.orig/drivers/xen/balloon.c linux-2.6.32.16/drivers/xen/balloon.c
--- linux-2.6.32.16.orig/drivers/xen/balloon.c	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/xen/balloon.c	2010-07-16 15:06:53.000000000 +0200
@@ -6,6 +6,7 @@
  * Copyright (c) 2003, B Dragovic
  * Copyright (c) 2003-2004, M Williamson, K Fraser
  * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ * Copyright (c) 2010 Daniel Kiper
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
@@ -74,6 +75,10 @@
 	/* Number of pages in high- and low-memory balloons. */
 	unsigned long balloon_low;
 	unsigned long balloon_high;
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	u64 hotplug_start_addr;
+	u64 hotplug_size;
+#endif
 };
 
 static DEFINE_MUTEX(balloon_mutex);
@@ -183,6 +188,9 @@
 
 static unsigned long current_target(void)
 {
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	return balloon_stats.target_pages;
+#else
 	unsigned long target = balloon_stats.target_pages;
 
 	target = min(target,
@@ -191,6 +199,7 @@
 		     balloon_stats.balloon_high);
 
 	return target;
+#endif
 }
 
 static int increase_reservation(unsigned long nr_pages)
@@ -204,17 +213,48 @@
 		.domid        = DOMID_SELF
 	};
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	struct resource *r;
+#endif
+
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
 	spin_lock_irqsave(&balloon_lock, flags);
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (!balloon_stats.balloon_low && !balloon_stats.balloon_high) {
+		if (!balloon_stats.hotplug_start_addr)
+			for (r = iomem_resource.child; r; r = r->sibling)
+				if (!r->sibling || r->sibling->start >
+					(((r->end >> PAGE_SHIFT) + balloon_stats.target_pages -
+					  balloon_stats.current_pages) << PAGE_SHIFT)) {
+					balloon_stats.hotplug_start_addr = (((r->end >> PAGE_SHIFT) + 1) << PAGE_SHIFT);
+					break;
+				}
+
+		pfn = (balloon_stats.hotplug_start_addr + balloon_stats.hotplug_size) >> PAGE_SHIFT;
+
+		for (i = 0; i < nr_pages; ++i, ++pfn)
+			frame_list[i] = pfn;
+
+		pfn -= nr_pages + 1;
+	} else {
+		page = balloon_first_page();
+		for (i = 0; i < nr_pages; i++) {
+			BUG_ON(page == NULL);
+			frame_list[i] = page_to_pfn(page);
+			page = balloon_next_page(page);
+		}
+	}
+#else
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
 		BUG_ON(page == NULL);
 		frame_list[i] = page_to_pfn(page);
 		page = balloon_next_page(page);
 	}
+#endif
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);
 	reservation.nr_extents = nr_pages;
@@ -223,15 +263,30 @@
 		goto out;
 
 	for (i = 0; i < rc; i++) {
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+		if (balloon_stats.hotplug_start_addr)
+			++pfn;
+		else {
+			page = balloon_retrieve();
+			BUG_ON(page == NULL);
+			pfn = page_to_pfn(page);
+		}
+#else
 		page = balloon_retrieve();
 		BUG_ON(page == NULL);
-
 		pfn = page_to_pfn(page);
+#endif
+
 		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
 		       phys_to_machine_mapping_valid(pfn));
 
 		set_phys_to_machine(pfn, frame_list[i]);
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+		if (balloon_stats.hotplug_start_addr)
+			continue;
+#endif
+
 		/* Link back into the page tables if not highmem. */
 		if (pfn < max_low_pfn) {
 			int ret;
@@ -248,6 +303,11 @@
 		__free_page(page);
 	}
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (balloon_stats.hotplug_start_addr)
+		balloon_stats.hotplug_size += rc << PAGE_SHIFT;
+#endif
+
 	balloon_stats.current_pages += rc;
 
  out:
@@ -344,8 +404,24 @@
 	} while ((credit != 0) && !need_sleep);
 
 	/* Schedule more work if there is some still to be done. */
+
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	if (current_target() != balloon_stats.current_pages)
 		mod_timer(&balloon_timer, jiffies + HZ);
+	else
+		if (balloon_stats.hotplug_start_addr) {
+			/* TODO: deallocate memory if something goes wrong !!! */
+			add_memory(memory_add_physaddr_to_nid(balloon_stats.hotplug_start_addr),
+					balloon_stats.hotplug_start_addr, balloon_stats.hotplug_size);
+			online_pages(balloon_stats.hotplug_start_addr >> PAGE_SHIFT,
+					balloon_stats.hotplug_size >> PAGE_SHIFT);
+			balloon_stats.hotplug_start_addr = 0;
+			balloon_stats.hotplug_size = 0;
+		}
+#else
+	if (current_target() != balloon_stats.current_pages)
+		mod_timer(&balloon_timer, jiffies + HZ);
+#endif
 
 	mutex_unlock(&balloon_mutex);
 }
@@ -413,6 +489,11 @@
 	balloon_stats.balloon_high  = 0;
 	balloon_stats.driver_pages  = 0UL;
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	balloon_stats.hotplug_start_addr = 0;
+	balloon_stats.hotplug_size = 0;
+#endif
+
 	init_timer(&balloon_timer);
 	balloon_timer.data = 0;
 	balloon_timer.function = balloon_alarm;
diff -Nru linux-2.6.32.16.orig/mm/Kconfig linux-2.6.32.16/mm/Kconfig
--- linux-2.6.32.16.orig/mm/Kconfig	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/mm/Kconfig	2010-07-16 11:44:27.000000000 +0200
@@ -140,6 +140,15 @@
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+config XEN_MEMORY_HOTPLUG
+	bool "Allow for memory hot-add in Xen guests"
+	depends on EXPERIMENTAL && ARCH_MEMORY_PROBE && XEN
+	default n
+	help
+	  Memory hot-add allows expanding memory available for the system
+	  above limit declared at system startup. It is very useful on critical
+	  systems which require long run without rebooting.
+
 #
 # If we have space for more page flags then we can enable additional
 # optimizations and functionality.

--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.32.16-xen-memory-hotplug.r0.patch"

diff -Nru linux-2.6.32.16.orig/drivers/base/memory.c linux-2.6.32.16/drivers/base/memory.c
--- linux-2.6.32.16.orig/drivers/base/memory.c	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/base/memory.c	2010-07-16 11:48:45.000000000 +0200
@@ -3,6 +3,7 @@
  *
  * Written by Matt Tolentino <matthew.e.tolentino@intel.com>
  *            Dave Hansen <haveblue@us.ibm.com>
+ *            Daniel Kiper <dkiper@net-space.pl>
  *
  * This file provides the necessary infrastructure to represent
  * a SPARSEMEM-memory-model system's physical memory in /sysfs.
@@ -26,6 +27,16 @@
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+#include <linux/vmalloc.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/features.h>
+#include <xen/page.h>
+#endif
+
 #define MEMORY_CLASS_NAME	"memory"
 
 static struct sysdev_class memory_sysdev_class = {
@@ -314,13 +325,61 @@
 memory_probe_store(struct class *class, const char *buf, size_t count)
 {
 	u64 phys_addr;
-	int nid;
-	int ret;
+	long ret;
+
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid = DOMID_SELF,
+		.nr_extents = PAGES_PER_SECTION
+	};
+	unsigned long *frame_list, i, nr_pages, pfn;
+#endif
 
 	phys_addr = simple_strtoull(buf, NULL, 0);
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+#ifdef CONFIG_XEN_MEMORY_HOTPLUG
+	if (xen_domain()) {
+		if (!(frame_list = vmalloc(PAGES_PER_SECTION * sizeof(unsigned long)))) {
+			printk(KERN_ERR "%s: vmalloc: Out of memory\n", __func__);
+			return -ENOMEM;
+		}
+
+		set_xen_guest_handle(reservation.extent_start, frame_list);
+		for (i = 0, pfn = phys_addr >> PAGE_SHIFT; i < PAGES_PER_SECTION; ++i, ++pfn)
+			frame_list[i] = pfn;
+
+		ret = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+
+		if (ret < PAGES_PER_SECTION) {
+			if (ret > 0) {
+				printk(KERN_ERR "%s: PHYSMAP is not fully populated: %li/%lu\n",
+						__func__, ret, PAGES_PER_SECTION);
+				reservation.nr_extents = nr_pages = ret;
+				ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation, &reservation);
+				BUG_ON(ret != nr_pages);
+				ret = -ENOMEM;
+			} else {
+				ret = (ret < 0) ? ret : -ENOMEM;
+				printk(KERN_ERR "%s: Can't populate PHYSMAP: %li\n", __func__, ret);
+			}
+			vfree(frame_list);
+			return ret;
+		}
+
+		for (i = 0, pfn = phys_addr >> PAGE_SHIFT; i < PAGES_PER_SECTION; ++i, ++pfn) {
+			BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
+					phys_to_machine_mapping_valid(pfn));
+			set_phys_to_machine(pfn, frame_list[i]);
+		}
+
+		vfree(frame_list);
+	}
+#endif
+
+	ret = add_memory(memory_add_physaddr_to_nid(phys_addr),
+				phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
 
 	if (ret)
 		count = ret;
diff -Nru linux-2.6.32.16.orig/drivers/xen/Kconfig linux-2.6.32.16/drivers/xen/Kconfig
--- linux-2.6.32.16.orig/drivers/xen/Kconfig	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/xen/Kconfig	2010-07-09 21:04:17.000000000 +0200
@@ -7,6 +7,16 @@
 	  the system to expand the domain's memory allocation, or alternatively
 	  return unneeded memory to the system.
 
+config XEN_BALLOON_MEMORY_HOTPLUG
+	bool "Xen memory balloon driver with memory hotplug support"
+	depends on EXPERIMENTAL && XEN && XEN_BALLOON && MEMORY_HOTPLUG
+	default n
+	help
+	  Xen memory balloon driver with memory hotplug support allows expanding
+	  memory available for the system above limit declared at system startup.
+	  It is very useful on critical systems which require long run without
+	  rebooting.
+
 config XEN_SCRUB_PAGES
 	bool "Scrub pages before returning them to system"
 	depends on XEN_BALLOON
@@ -60,4 +70,4 @@
          Create entries under /sys/hypervisor describing the Xen
 	 hypervisor environment.  When running native or in another
 	 virtual environment, /sys/hypervisor will still be present,
-	 but will have no xen contents.
\ No newline at end of file
+	 but will have no xen contents.
diff -Nru linux-2.6.32.16.orig/drivers/xen/balloon.c linux-2.6.32.16/drivers/xen/balloon.c
--- linux-2.6.32.16.orig/drivers/xen/balloon.c	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/drivers/xen/balloon.c	2010-07-16 15:06:53.000000000 +0200
@@ -6,6 +6,7 @@
  * Copyright (c) 2003, B Dragovic
  * Copyright (c) 2003-2004, M Williamson, K Fraser
  * Copyright (c) 2005 Dan M. Smith, IBM Corporation
+ * Copyright (c) 2010 Daniel Kiper
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License version 2
@@ -74,6 +75,10 @@
 	/* Number of pages in high- and low-memory balloons. */
 	unsigned long balloon_low;
 	unsigned long balloon_high;
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	u64 hotplug_start_addr;
+	u64 hotplug_size;
+#endif
 };
 
 static DEFINE_MUTEX(balloon_mutex);
@@ -183,6 +188,9 @@
 
 static unsigned long current_target(void)
 {
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	return balloon_stats.target_pages;
+#else
 	unsigned long target = balloon_stats.target_pages;
 
 	target = min(target,
@@ -191,6 +199,7 @@
 		     balloon_stats.balloon_high);
 
 	return target;
+#endif
 }
 
 static int increase_reservation(unsigned long nr_pages)
@@ -204,17 +213,48 @@
 		.domid        = DOMID_SELF
 	};
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	struct resource *r;
+#endif
+
 	if (nr_pages > ARRAY_SIZE(frame_list))
 		nr_pages = ARRAY_SIZE(frame_list);
 
 	spin_lock_irqsave(&balloon_lock, flags);
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (!balloon_stats.balloon_low && !balloon_stats.balloon_high) {
+		if (!balloon_stats.hotplug_start_addr)
+			for (r = iomem_resource.child; r; r = r->sibling)
+				if (!r->sibling || r->sibling->start >
+					(((r->end >> PAGE_SHIFT) + balloon_stats.target_pages -
+					  balloon_stats.current_pages) << PAGE_SHIFT)) {
+					balloon_stats.hotplug_start_addr = (((r->end >> PAGE_SHIFT) + 1) << PAGE_SHIFT);
+					break;
+				}
+
+		pfn = (balloon_stats.hotplug_start_addr + balloon_stats.hotplug_size) >> PAGE_SHIFT;
+
+		for (i = 0; i < nr_pages; ++i, ++pfn)
+			frame_list[i] = pfn;
+
+		pfn -= nr_pages + 1;
+	} else {
+		page = balloon_first_page();
+		for (i = 0; i < nr_pages; i++) {
+			BUG_ON(page == NULL);
+			frame_list[i] = page_to_pfn(page);
+			page = balloon_next_page(page);
+		}
+	}
+#else
 	page = balloon_first_page();
 	for (i = 0; i < nr_pages; i++) {
 		BUG_ON(page == NULL);
 		frame_list[i] = page_to_pfn(page);
 		page = balloon_next_page(page);
 	}
+#endif
 
 	set_xen_guest_handle(reservation.extent_start, frame_list);
 	reservation.nr_extents = nr_pages;
@@ -223,15 +263,30 @@
 		goto out;
 
 	for (i = 0; i < rc; i++) {
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+		if (balloon_stats.hotplug_start_addr)
+			++pfn;
+		else {
+			page = balloon_retrieve();
+			BUG_ON(page == NULL);
+			pfn = page_to_pfn(page);
+		}
+#else
 		page = balloon_retrieve();
 		BUG_ON(page == NULL);
-
 		pfn = page_to_pfn(page);
+#endif
+
 		BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
 		       phys_to_machine_mapping_valid(pfn));
 
 		set_phys_to_machine(pfn, frame_list[i]);
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+		if (balloon_stats.hotplug_start_addr)
+			continue;
+#endif
+
 		/* Link back into the page tables if not highmem. */
 		if (pfn < max_low_pfn) {
 			int ret;
@@ -248,6 +303,11 @@
 		__free_page(page);
 	}
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	if (balloon_stats.hotplug_start_addr)
+		balloon_stats.hotplug_size += rc << PAGE_SHIFT;
+#endif
+
 	balloon_stats.current_pages += rc;
 
  out:
@@ -344,8 +404,24 @@
 	} while ((credit != 0) && !need_sleep);
 
 	/* Schedule more work if there is some still to be done. */
+
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
 	if (current_target() != balloon_stats.current_pages)
 		mod_timer(&balloon_timer, jiffies + HZ);
+	else
+		if (balloon_stats.hotplug_start_addr) {
+			/* TODO: deallocate memory if something goes wrong !!! */
+			add_memory(memory_add_physaddr_to_nid(balloon_stats.hotplug_start_addr),
+					balloon_stats.hotplug_start_addr, balloon_stats.hotplug_size);
+			online_pages(balloon_stats.hotplug_start_addr >> PAGE_SHIFT,
+					balloon_stats.hotplug_size >> PAGE_SHIFT);
+			balloon_stats.hotplug_start_addr = 0;
+			balloon_stats.hotplug_size = 0;
+		}
+#else
+	if (current_target() != balloon_stats.current_pages)
+		mod_timer(&balloon_timer, jiffies + HZ);
+#endif
 
 	mutex_unlock(&balloon_mutex);
 }
@@ -413,6 +489,11 @@
 	balloon_stats.balloon_high  = 0;
 	balloon_stats.driver_pages  = 0UL;
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	balloon_stats.hotplug_start_addr = 0;
+	balloon_stats.hotplug_size = 0;
+#endif
+
 	init_timer(&balloon_timer);
 	balloon_timer.data = 0;
 	balloon_timer.function = balloon_alarm;
diff -Nru linux-2.6.32.16.orig/mm/Kconfig linux-2.6.32.16/mm/Kconfig
--- linux-2.6.32.16.orig/mm/Kconfig	2010-07-05 20:14:00.000000000 +0200
+++ linux-2.6.32.16/mm/Kconfig	2010-07-16 11:44:27.000000000 +0200
@@ -140,6 +140,15 @@
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+config XEN_MEMORY_HOTPLUG
+	bool "Allow for memory hot-add in Xen guests"
+	depends on EXPERIMENTAL && ARCH_MEMORY_PROBE && XEN
+	default n
+	help
+	  Memory hot-add allows expanding memory available for the system
+	  above limit declared at system startup. It is very useful on critical
+	  systems which require long run without rebooting.
+
 #
 # If we have space for more page flags then we can enable additional
 # optimizations and functionality.

--FCuugMFkClbJLl1L--
