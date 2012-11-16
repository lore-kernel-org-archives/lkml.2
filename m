Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2KPVyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:54:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:37036 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2KPVyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:54:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="250451189"
Subject: [PATCH v4 1/8] x86: Move some contents of page_64_types.h into
 pgtable_64.h and page_64.h
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:53:09 -0800
Message-ID: <20121116215244.8521.31505.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is meant to clean-up the fact that we have several functions in
page_64_types.h which really don't belong there.  I found this issue when I
had tried to replace __phys_addr with an inline function.  It resulted in the
realmode bits generating compile warnings about types.  In order to resolve
that I am relocating the address translation to page_64.h since this is in
keeping with where these functions are located in 32 bit.

In addtion I have relocated several functions defined in init_64.c to
pgtable_64.h as this seems to be where most of the functions related to
memory initialization were already located.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/include/asm/page_64.h       |   19 +++++++++++++++++++
 arch/x86/include/asm/page_64_types.h |   22 ----------------------
 arch/x86/include/asm/pgtable_64.h    |    5 +++++
 3 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 072694e..4150999 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -3,4 +3,23 @@
 
 #include <asm/page_64_types.h>
 
+#ifndef __ASSEMBLY__
+
+/* duplicated to the one in bootmem.h */
+extern unsigned long max_pfn;
+extern unsigned long phys_base;
+
+extern unsigned long __phys_addr(unsigned long);
+
+#define __phys_reloc_hide(x)	(x)
+
+#ifdef CONFIG_FLATMEM
+#define pfn_valid(pfn)          ((pfn) < max_pfn)
+#endif
+
+void clear_page(void *page);
+void copy_page(void *to, void *from);
+
+#endif	/* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_PAGE_64_H */
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 320f7bb..8b491e6 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -50,26 +50,4 @@
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
 #define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
-#ifndef __ASSEMBLY__
-void clear_page(void *page);
-void copy_page(void *to, void *from);
-
-/* duplicated to the one in bootmem.h */
-extern unsigned long max_pfn;
-extern unsigned long phys_base;
-
-extern unsigned long __phys_addr(unsigned long);
-#define __phys_reloc_hide(x)	(x)
-
-#define vmemmap ((struct page *)VMEMMAP_START)
-
-extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
-extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
-
-#endif	/* !__ASSEMBLY__ */
-
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)          ((pfn) < max_pfn)
-#endif
-
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 47356f9..b5d30ad 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -183,6 +183,11 @@ extern void cleanup_highmap(void);
 
 #define __HAVE_ARCH_PTE_SAME
 
+#define vmemmap ((struct page *)VMEMMAP_START)
+
+extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
+extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_64_H */

