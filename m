Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2JJXqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:46:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:55066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab2JJXqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,567,1344236400"; 
   d="scan'208";a="204106658"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH] x86: Make it so that __pa_symbol can only process kernel
	symbols on x86_64
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Wed, 10 Oct 2012 16:46:30 -0700
Message-ID: <20121010234630.27769.88436.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I submitted an earlier patch that make __phys_addr an inline.  This obviously
results in an increase in the code size.  One step I can take to reduce that
is to make it so that the __pa_symbol call does a direct translation for
kernel addresses instead of covering all of virtual memory.

On my system this reduced the size for __pa_symbol from 5 instructions
totalling 30 bytes to 3 instructions totalling 16 bytes.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 arch/x86/include/asm/page.h          |    3 ++-
 arch/x86/include/asm/page_32.h       |    1 +
 arch/x86/include/asm/page_64_types.h |    3 +++
 arch/x86/mm/physaddr.c               |   15 +++++++++++++++
 4 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..3698a6a 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -44,7 +44,8 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
  * case properly. Once all supported versions of gcc understand it, we can
  * remove this Voodoo magic stuff. (i.e. once gcc3.x is deprecated)
  */
-#define __pa_symbol(x)	__pa(__phys_reloc_hide((unsigned long)(x)))
+#define __pa_symbol(x) \
+	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
 
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index da4e762..4d550d0 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -15,6 +15,7 @@ extern unsigned long __phys_addr(unsigned long);
 #else
 #define __phys_addr(x)		__phys_addr_nodebug(x)
 #endif
+#define __phys_addr_symbol(x)	__phys_addr(x)
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index a951e4d..217c7d5 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -60,6 +60,7 @@ extern unsigned long phys_base;
 
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
+extern unsigned long __phys_addr_symbol(unsigned long);
 #else
 static inline unsigned long __phys_addr(unsigned long x)
 {
@@ -70,6 +71,8 @@ static inline unsigned long __phys_addr(unsigned long x)
 
 	return x;
 }
+#define __phys_addr_symbol(x) \
+	((unsigned long)(x) - __START_KERNEL_map + phys_base)
 #endif
 #define __phys_reloc_hide(x)	(x)
 
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index f63bec5..666edbd 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -29,6 +29,21 @@ unsigned long __phys_addr(unsigned long x)
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
+
+unsigned long __phys_addr_symbol(unsigned long x)
+{
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* use the carry flag to determine if x was < __START_KERNEL_map */
+	VIRTUAL_BUG_ON(x < y);
+
+	x = y + phys_base;
+
+	VIRTUAL_BUG_ON(y >= KERNEL_IMAGE_SIZE);
+
+	return x;
+}
+EXPORT_SYMBOL(__phys_addr_symbol);
 #endif
 
 bool __virt_addr_valid(unsigned long x)

