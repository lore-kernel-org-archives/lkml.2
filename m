Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab0KQEpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:45:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:37715 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab0KQEpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:45:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,209,1288594800"; 
   d="scan'208";a="349743912"
X-Mailbox-Line: From shaohui.zheng@intel.com Wed Nov 17 10:10:00 2010
Message-Id: <20101117021000.479272928@intel.com>
References: <20101117020759.016741414@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 17 Nov 2010 10:08:00 +0800
From: shaohui.zheng@intel.com
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>
Subject: [1/8,v3] NUMA Hotplug Emulator: add function to hide memory region via e820 table.
Content-Disposition: inline; filename=001-hotplug-emulator-x86-add-function-to-hide-memory-region-via-e820.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@intel.com>

NUMA hotplug emulator needs to hide memory regions at the very
beginning of kernel booting. Then emulator will use these
memory regions to fake offlined numa nodes.

CC: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |   19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

Index: linux-hpe4/arch/x86/include/asm/e820.h
===================================================================
--- linux-hpe4.orig/arch/x86/include/asm/e820.h	2010-11-15 17:13:02.483461667 +0800
+++ linux-hpe4/arch/x86/include/asm/e820.h	2010-11-15 17:13:07.083461581 +0800
@@ -129,6 +129,7 @@
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern u64 e820_hole_size(u64 start, u64 end);
+extern u64 e820_hide_mem(u64 mem_size);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
Index: linux-hpe4/arch/x86/kernel/e820.c
===================================================================
--- linux-hpe4.orig/arch/x86/kernel/e820.c	2010-11-15 17:13:02.483461667 +0800
+++ linux-hpe4/arch/x86/kernel/e820.c	2010-11-15 17:13:07.083461581 +0800
@@ -971,6 +971,7 @@
 }
 
 static int userdef __initdata;
+static u64 max_mem_size __initdata = ULLONG_MAX;
 
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
@@ -989,12 +990,28 @@
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
+	e820_remove_range(mem_size, max_mem_size - mem_size, E820_RAM, 1);
+	max_mem_size = mem_size;
 
 	return 0;
 }
 early_param("mem", parse_memopt);
 
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+u64 __init e820_hide_mem(u64 mem_size)
+{
+	u64 start, end_pfn;
+
+	userdef = 1;
+	end_pfn = e820_end_of_ram_pfn();
+	start = (end_pfn << PAGE_SHIFT) - mem_size;
+	e820_remove_range(start, max_mem_size - start, E820_RAM, 1);
+	max_mem_size = start;
+
+	return start;
+}
+#endif
+
 static int __init parse_memmap_opt(char *p)
 {
 	char *oldp;

-- 
Thanks & Regards,
Shaohui


