Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab0HLAbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:31:10 -0400
Received: from kroah.org ([198.145.64.141]:43644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759167Ab0HKX7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:13 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:03 2010
Message-Id: <20100811235503.837140666@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Li Haicheng <haicheng.li@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [090/111] memory hotplug: fix a bug on /dev/mem for 64-bit kernels
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shaohui Zheng <shaohui.zheng@intel.com>

commit ea0854170c95245a258b386c7a9314399c949fe0 upstream.

Newly added memory can not be accessed via /dev/mem, because we do not
update the variables high_memory, max_pfn and max_low_pfn.

Add a function update_end_of_memory_vars() to update these variables for
64-bit kernels.

[akpm@linux-foundation.org: simplify comment]
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Li Haicheng <haicheng.li@intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/init_64.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -49,6 +49,7 @@
 #include <asm/numa.h>
 #include <asm/cacheflush.h>
 #include <asm/init.h>
+#include <linux/bootmem.h>
 
 static unsigned long dma_reserve __initdata;
 
@@ -615,6 +616,21 @@ void __init paging_init(void)
  */
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
+ * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
+ * updating.
+ */
+static void  update_end_of_memory_vars(u64 start, u64 size)
+{
+	unsigned long end_pfn = PFN_UP(start + size);
+
+	if (end_pfn > max_pfn) {
+		max_pfn = end_pfn;
+		max_low_pfn = end_pfn;
+		high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
+	}
+}
+
+/*
  * Memory is added always to NORMAL zone. This means you will never get
  * additional DMA/DMA32 memory.
  */
@@ -633,6 +649,9 @@ int arch_add_memory(int nid, u64 start,
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
 
+	/* update max_pfn, max_low_pfn and high_memory */
+	update_end_of_memory_vars(start, size);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(arch_add_memory);


