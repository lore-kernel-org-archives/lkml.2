Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0KMHfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:35:25 -0500
Received: from mga14.intel.com ([143.182.124.37]:14516 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0KMHfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:35:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="348236465"
Date: Sat, 13 Nov 2010 14:14:16 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [v2,1/8] NUMA Hotplug emulator
Message-ID: <20101113061416.GK32501@shaohui>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>
Subject: hotplug emulator: add function to hide memory region via e820 table.

NUMA hotplug emulator needs to hide memory regions at the very
beginning of kernel booting. Then emulator will use these
memory regions to fake offlined numa nodes.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |   19 ++++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 0e22296..027bbb1 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -124,6 +124,7 @@ extern int e820_find_active_region(const struct e820entry *ei,
 extern void e820_register_active_regions(int nid, unsigned long start_pfn,
 					 unsigned long end_pfn);
 extern u64 e820_hole_size(u64 start, u64 end);
+extern u64 e820_hide_mem(u64 mem_size);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7bca3c6..1993275 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -971,6 +971,7 @@ static void early_panic(char *msg)
 }
 
 static int userdef __initdata;
+static u64 max_mem_size __initdata = ULLONG_MAX;
 
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
@@ -989,12 +990,28 @@ static int __init parse_memopt(char *p)
 
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
1.6.0.rc1


-- 
Thanks & Regards,
Shaohui
