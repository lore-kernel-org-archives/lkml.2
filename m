Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1DPQwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:52:31 -0400
Received: from [69.28.251.93] ([69.28.251.93]:57405 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab1DPQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:51:22 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] MIPS: Add dummy _PAGE_NO_EXEC field for R3000 and 64BIT_PHYS_ADDR cases
Date: Sat, 16 Apr 2011 09:44:30 -0700
Message-Id: <f564424e3119f4d469b772cb78546922@localhost>
In-Reply-To: <7aa38c32b7748a95e814e5bb0583f967@localhost>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a non-functional (software-only) _PAGE_NO_EXEC bit for all MIPS
pte layouts.  This allows for the elimination of the special case for
non-RIXI when initializing the page protection map.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/pgtable-bits.h |   21 ++++++-------
 arch/mips/mm/cache.c                 |   54 ++++++++++-----------------------
 2 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/arch/mips/include/asm/pgtable-bits.h b/arch/mips/include/asm/pgtable-bits.h
index 7afba78..c83eaca 100644
--- a/arch/mips/include/asm/pgtable-bits.h
+++ b/arch/mips/include/asm/pgtable-bits.h
@@ -36,10 +36,11 @@
 
 #define _PAGE_PRESENT               (1<<6)  /* implemented in software */
 #define _PAGE_NO_READ               (1<<7)  /* implemented in software */
-#define _PAGE_WRITE                 (1<<8)  /* implemented in software */
-#define _PAGE_ACCESSED              (1<<9)  /* implemented in software */
-#define _PAGE_MODIFIED              (1<<10) /* implemented in software */
-#define _PAGE_FILE                  (1<<10) /* set:pagecache unset:swap */
+#define _PAGE_NO_EXEC               (1<<8)  /* implemented in software */
+#define _PAGE_WRITE                 (1<<9)  /* implemented in software */
+#define _PAGE_ACCESSED              (1<<10) /* implemented in software */
+#define _PAGE_MODIFIED              (1<<11) /* implemented in software */
+#define _PAGE_FILE                  (1<<11) /* set:pagecache unset:swap */
 
 #define _PAGE_R4KBUG                (1<<0)  /* workaround for r4k bug  */
 #define _PAGE_GLOBAL                (1<<0)
@@ -54,10 +55,11 @@
 
 #define _PAGE_PRESENT               (1<<0)  /* implemented in software */
 #define _PAGE_NO_READ               (1<<1)  /* implemented in software */
-#define _PAGE_WRITE                 (1<<2)  /* implemented in software */
-#define _PAGE_ACCESSED              (1<<3)  /* implemented in software */
-#define _PAGE_MODIFIED              (1<<4)  /* implemented in software */
-#define _PAGE_FILE                  (1<<4)  /* set:pagecache unset:swap */
+#define _PAGE_NO_EXEC               (1<<2)  /* implemented in software */
+#define _PAGE_WRITE                 (1<<3)  /* implemented in software */
+#define _PAGE_ACCESSED              (1<<4)  /* implemented in software */
+#define _PAGE_MODIFIED              (1<<5)  /* implemented in software */
+#define _PAGE_FILE                  (1<<5)  /* set:pagecache unset:swap */
 
 #define _PAGE_GLOBAL                (1<<8)
 #define _PAGE_VALID                 (1<<9)
@@ -133,9 +135,6 @@
 #endif
 #define _PFN_MASK		(~((1 << (_PFN_SHIFT)) - 1))
 
-#ifndef _PAGE_NO_EXEC
-#define _PAGE_NO_EXEC ({BUG(); 0; })
-#endif
 #ifndef _PAGE_GLOBAL_SHIFT
 #define _PAGE_GLOBAL_SHIFT ilog2(_PAGE_GLOBAL)
 #endif
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index 12af739..7c251e6 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -137,43 +137,23 @@ EXPORT_SYMBOL(_page_cachable_default);
 
 static inline void setup_protection_map(void)
 {
-	if (kernel_uses_smartmips_rixi) {
-		protection_map[0]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-		protection_map[1]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-		protection_map[2]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-		protection_map[3]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-		protection_map[4]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-		protection_map[5]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-		protection_map[6]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-		protection_map[7]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-
-		protection_map[8]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
-		protection_map[9]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
-		protection_map[10] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE | _PAGE_NO_READ);
-		protection_map[11] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
-		protection_map[12] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
-		protection_map[13] = __pgprot(_page_cachable_default | _PAGE_PRESENT);
-		protection_map[14] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE  | _PAGE_NO_READ);
-		protection_map[15] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE);
-
-	} else {
-		protection_map[0] = PAGE_NONE;
-		protection_map[1] = PAGE_READONLY;
-		protection_map[2] = PAGE_COPY;
-		protection_map[3] = PAGE_COPY;
-		protection_map[4] = PAGE_READONLY;
-		protection_map[5] = PAGE_READONLY;
-		protection_map[6] = PAGE_COPY;
-		protection_map[7] = PAGE_COPY;
-		protection_map[8] = PAGE_NONE;
-		protection_map[9] = PAGE_READONLY;
-		protection_map[10] = PAGE_SHARED;
-		protection_map[11] = PAGE_SHARED;
-		protection_map[12] = PAGE_READONLY;
-		protection_map[13] = PAGE_READONLY;
-		protection_map[14] = PAGE_SHARED;
-		protection_map[15] = PAGE_SHARED;
-	}
+	protection_map[0]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[1]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[2]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[3]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[4]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
+	protection_map[5]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
+	protection_map[6]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
+	protection_map[7]  = __pgprot(_page_cachable_default | _PAGE_PRESENT);
+
+	protection_map[8]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_NO_READ);
+	protection_map[9]  = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC);
+	protection_map[10] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE | _PAGE_NO_READ);
+	protection_map[11] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_EXEC | _PAGE_WRITE);
+	protection_map[12] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_NO_READ);
+	protection_map[13] = __pgprot(_page_cachable_default | _PAGE_PRESENT);
+	protection_map[14] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE  | _PAGE_NO_READ);
+	protection_map[15] = __pgprot(_page_cachable_default | _PAGE_PRESENT | _PAGE_WRITE);
 }
 
 void __cpuinit cpu_cache_init(void)
-- 
1.7.4.3

