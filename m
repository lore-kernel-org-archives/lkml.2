Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2KPV46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 16:56:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:26477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2KPV45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 16:56:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="218893221"
Subject: [PATCH v4 3/8] x86: Make it so that __pa_symbol can only process
 kernel symbols on x86_64
To: tglx@linutronix.de, mingo@redhat.com, andi@firstfloor.org, hpa@zytor.com
From: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 13:55:46 -0800
Message-ID: <20121116215356.8521.92472.stgit@ahduyck-cp1.jf.intel.com>
In-Reply-To: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
References: <20121116214644.8521.79072.stgit@ahduyck-cp1.jf.intel.com>
User-Agent: StGit/0.16
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
v4:  Dropped y>x check in debug version of __phys_addr_symbol since we already
     checked for y >= KERNEL_IMAGE_SIZE.

 arch/x86/include/asm/page.h    |    3 ++-
 arch/x86/include/asm/page_32.h |    1 +
 arch/x86/include/asm/page_64.h |    3 +++
 arch/x86/mm/physaddr.c         |   11 +++++++++++
 4 files changed, 17 insertions(+), 1 deletions(-)

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
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 5138174..0f1ddee 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -21,8 +21,11 @@ static inline unsigned long __phys_addr_nodebug(unsigned long x)
 
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
+extern unsigned long __phys_addr_symbol(unsigned long);
 #else
 #define __phys_addr(x)		__phys_addr_nodebug(x)
+#define __phys_addr_symbol(x) \
+	((unsigned long)(x) - __START_KERNEL_map + phys_base)
 #endif
 
 #define __phys_reloc_hide(x)	(x)
diff --git a/arch/x86/mm/physaddr.c b/arch/x86/mm/physaddr.c
index fd40d75..c73fedd 100644
--- a/arch/x86/mm/physaddr.c
+++ b/arch/x86/mm/physaddr.c
@@ -28,6 +28,17 @@ unsigned long __phys_addr(unsigned long x)
 	return x;
 }
 EXPORT_SYMBOL(__phys_addr);
+
+unsigned long __phys_addr_symbol(unsigned long x)
+{
+	unsigned long y = x - __START_KERNEL_map;
+
+	/* only check upper bounds since lower bounds will trigger carry */
+	VIRTUAL_BUG_ON(y >= KERNEL_IMAGE_SIZE);
+
+	return y + phys_base;
+}
+EXPORT_SYMBOL(__phys_addr_symbol);
 #endif
 
 bool __virt_addr_valid(unsigned long x)

