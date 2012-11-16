Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2KPVzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:55:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:1025 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab2KPVzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:55:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="169359041"
Subject: [PATCH v4 2/8] x86: Improve __phys_addr performance by making use
 of carry flags and inlining
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:53:51 -0800
Message-ID: <20121116215315.8521.46270.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
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

Finally I also applied the same logic changes to __virt_addr_valid since it
used the same general code flow as __phys_addr and could achieve similar gains
though these changes.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
v3:  Added changes to __virt_addr_valid to keep it in sync with __phys_addr

 arch/x86/include/asm/page_64.h   |   14 +++++++++++++
 arch/x86/kernel/x8664_ksyms_64.c |    3 +++
 arch/x86/mm/physaddr.c           |   40 ++++++++++++++++++++++++--------------
 3 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 4150999..5138174 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -9,7 +9,21 @@
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
+
+#ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
+#else
+#define __phys_addr(x)		__phys_addr_nodebug(x)
+#endif
 
 #define __phys_reloc_hide(x)	(x)
 
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
index d2e2735..fd40d75 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -8,33 +8,43 @@
 
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
-		VIRTUAL_BUG_ON(!phys_addr_valid(x));
+		x = y + (__START_KERNEL_map - PAGE_OFFSET);
+
+		/* carry flag will be set if starting x was >= PAGE_OFFSET */
+		VIRTUAL_BUG_ON((x > y) || !phys_addr_valid(x));
 	}
+
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
+#endif
 
 bool __virt_addr_valid(unsigned long x)
 {
-	if (x >= __START_KERNEL_map) {
-		x -= __START_KERNEL_map;
-		if (x >= KERNEL_IMAGE_SIZE)
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* use the carry flag to determine if x was < __START_KERNEL_map */
+	if (unlikely(x > y)) {
+		x = y + phys_base;
+
+		if (y >= KERNEL_IMAGE_SIZE)
 			return false;
-		x += phys_base;
 	} else {
-		if (x < PAGE_OFFSET)
-			return false;
-		x -= PAGE_OFFSET;
-		if (!phys_addr_valid(x))
+		x = y + (__START_KERNEL_map - PAGE_OFFSET);
+
+		/* carry flag will be set if starting x was >= PAGE_OFFSET */
+		if ((x > y) || !phys_addr_valid(x))
 			return false;
 	}
 

