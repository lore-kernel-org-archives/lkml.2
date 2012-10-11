Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030200Ab2JKUtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:49:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:53033 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263Ab2JKUtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:49:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="203427575"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 1/8] x86: Improve __phys_addr performance by making use of
	carry flags and inlining
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>
Date: Thu, 11 Oct 2012 13:49:57 -0700
Message-ID: <20121011204957.12787.80543.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is meant to improve overall system performance when making use of
the __phys_addr call.  To do this I have implemented several changes.

First if CONFIG_DEBUG_VIRTUAL is not defined __phys_addr is made an inline,
similar to how this is currently handled in 32 bit.  However in order to do
this it is required to export phys_base so that it is available if __phys_addr
is used in kernel modules.

The second change was to streamline the code by making use of the carry flag
on an add operation instead of performing a compare on a 64 bit value.  The
advantage to this is that it allows us to significantly reduce the overall
size of the call.  On my Xeon E5 system the entire __phys_addr inline call
consumes a little less than 32 bytes and 5 instructions.  I also applied
similar logic to the debug version of the function.  My testing shows that the
debug version of the function with this patch applied is slightly faster than
the non-debug version without the patch.

Finally, when building the kernel with the first two changes applied I saw
build warnings about __START_KERNEL_map and PAGE_OFFSET constants not fitting
in their type.  In order to resolve the build warning I changed their type
from UL to ULL.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 arch/x86/include/asm/page_64_types.h |   17 +++++++++++++++--
 arch/x86/kernel/x8664_ksyms_64.c     |    3 +++
 arch/x86/mm/physaddr.c               |   20 ++++++++++++++------
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 320f7bb..1ca93d3 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -30,14 +30,14 @@
  * hypervisor to fit.  Choosing 16 slots here is arbitrary, but it's
  * what Xen requires.
  */
-#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
+#define __PAGE_OFFSET           _AC(0xffff880000000000, ULL)
 
 #define __PHYSICAL_START	((CONFIG_PHYSICAL_START +	 	\
 				  (CONFIG_PHYSICAL_ALIGN - 1)) &	\
 				 ~(CONFIG_PHYSICAL_ALIGN - 1))
 
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
-#define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
+#define __START_KERNEL_map	_AC(0xffffffff80000000, ULL)
 
 /* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define __PHYSICAL_MASK_SHIFT	46
@@ -58,7 +58,20 @@ void copy_page(void *to, void *from);
 extern unsigned long max_pfn;
 extern unsigned long phys_base;
 
+static inline unsigned long __phys_addr_nodebug(unsigned long x)
+{
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* use the carry flag to determine if x was < __START_KERNEL_map */
+	x = y + ((x > y) ? phys_base : (__START_KERNEL_map - PAGE_OFFSET));
+
+	return x;
+}
+#ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
+#else
+#define __phys_addr(x)		__phys_addr_nodebug(x)
+#endif
 #define __phys_reloc_hide(x)	(x)
 
 #define vmemmap ((struct page *)VMEMMAP_START)
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 1330dd1..b014d94 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -59,6 +59,9 @@ EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(memmove);
 
+#ifndef CONFIG_DEBUG_VIRTUAL
+EXPORT_SYMBOL(phys_base);
+#endif
 EXPORT_SYMBOL(empty_zero_page);
 #ifndef CONFIG_PARAVIRT
 EXPORT_SYMBOL(native_load_gs_index);
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index d2e2735..f63bec5 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -8,20 +8,28 @@
 
 #ifdef CONFIG_X86_64
 
+#ifdef CONFIG_DEBUG_VIRTUAL
 unsigned long __phys_addr(unsigned long x)
 {
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		VIRTUAL_BUG_ON(x >= KERNEL_IMAGE_SIZE);
-		x += phys_base;
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* use the carry flag to determine if x was < __START_KERNEL_map */
+	if (unlikely(x > y)) {
+		x = y + phys_base;
+
+		VIRTUAL_BUG_ON(y >= KERNEL_IMAGE_SIZE);
 	} else {
-		VIRTUAL_BUG_ON(x < PAGE_OFFSET);
-		x -= PAGE_OFFSET;
+		x = y + (__START_KERNEL_map - PAGE_OFFSET);
+
+		/* carry flag will be set if starting x was >= PAGE_OFFSET */
+		VIRTUAL_BUG_ON(x > y);
 		VIRTUAL_BUG_ON(!phys_addr_valid(x));
 	}
+
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
+#endif
 
 bool __virt_addr_valid(unsigned long x)
 {

