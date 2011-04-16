Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1DPQwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:52:41 -0400
Received: from [69.28.251.93] ([69.28.251.93]:57389 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab1DPQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:51:21 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
Date: Sat, 16 Apr 2011 09:44:29 -0700
Message-Id: <7aa38c32b7748a95e814e5bb0583f967@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reuse more of the same definitions for the non-RIXI and RIXI cases.  This
avoids having special cases for kernel_uses_smartmips_rixi cluttering up
the pgtable*.h files.

On hardware that does not support RI/XI, EntryLo bits 31:30 / 63:62 will
remain unset and RI/XI permissions will not be enforced.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/include/asm/pgtable-bits.h |   23 ++++++++---------------
 arch/mips/include/asm/pgtable.h      |   21 ++++++++-------------
 arch/mips/mm/tlbex.c                 |   17 +++++------------
 3 files changed, 21 insertions(+), 40 deletions(-)

diff --git a/arch/mips/include/asm/pgtable-bits.h b/arch/mips/include/asm/pgtable-bits.h
index e9fe7e9..7afba78 100644
--- a/arch/mips/include/asm/pgtable-bits.h
+++ b/arch/mips/include/asm/pgtable-bits.h
@@ -35,7 +35,7 @@
 #if defined(CONFIG_64BIT_PHYS_ADDR) && defined(CONFIG_CPU_MIPS32)
 
 #define _PAGE_PRESENT               (1<<6)  /* implemented in software */
-#define _PAGE_READ                  (1<<7)  /* implemented in software */
+#define _PAGE_NO_READ               (1<<7)  /* implemented in software */
 #define _PAGE_WRITE                 (1<<8)  /* implemented in software */
 #define _PAGE_ACCESSED              (1<<9)  /* implemented in software */
 #define _PAGE_MODIFIED              (1<<10) /* implemented in software */
@@ -53,7 +53,7 @@
 #elif defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
 #define _PAGE_PRESENT               (1<<0)  /* implemented in software */
-#define _PAGE_READ                  (1<<1)  /* implemented in software */
+#define _PAGE_NO_READ               (1<<1)  /* implemented in software */
 #define _PAGE_WRITE                 (1<<2)  /* implemented in software */
 #define _PAGE_ACCESSED              (1<<3)  /* implemented in software */
 #define _PAGE_MODIFIED              (1<<4)  /* implemented in software */
@@ -79,11 +79,8 @@
 /* implemented in software */
 #define _PAGE_PRESENT_SHIFT	(0)
 #define _PAGE_PRESENT		(1 << _PAGE_PRESENT_SHIFT)
-/* implemented in software, should be unused if kernel_uses_smartmips_rixi. */
-#define _PAGE_READ_SHIFT	(kernel_uses_smartmips_rixi ? _PAGE_PRESENT_SHIFT : _PAGE_PRESENT_SHIFT + 1)
-#define _PAGE_READ ({if (kernel_uses_smartmips_rixi) BUG(); 1 << _PAGE_READ_SHIFT; })
 /* implemented in software */
-#define _PAGE_WRITE_SHIFT	(_PAGE_READ_SHIFT + 1)
+#define _PAGE_WRITE_SHIFT	(_PAGE_PRESENT_SHIFT + 1)
 #define _PAGE_WRITE		(1 << _PAGE_WRITE_SHIFT)
 /* implemented in software */
 #define _PAGE_ACCESSED_SHIFT	(_PAGE_WRITE_SHIFT + 1)
@@ -104,12 +101,12 @@
 #endif
 
 /* Page cannot be executed */
-#define _PAGE_NO_EXEC_SHIFT	(kernel_uses_smartmips_rixi ? _PAGE_HUGE_SHIFT + 1 : _PAGE_HUGE_SHIFT)
-#define _PAGE_NO_EXEC		({if (!kernel_uses_smartmips_rixi) BUG(); 1 << _PAGE_NO_EXEC_SHIFT; })
+#define _PAGE_NO_EXEC_SHIFT	(_PAGE_HUGE_SHIFT + 1)
+#define _PAGE_NO_EXEC		(1 << _PAGE_NO_EXEC_SHIFT)
 
 /* Page cannot be read */
-#define _PAGE_NO_READ_SHIFT	(kernel_uses_smartmips_rixi ? _PAGE_NO_EXEC_SHIFT + 1 : _PAGE_NO_EXEC_SHIFT)
-#define _PAGE_NO_READ		({if (!kernel_uses_smartmips_rixi) BUG(); 1 << _PAGE_NO_READ_SHIFT; })
+#define _PAGE_NO_READ_SHIFT	(_PAGE_NO_EXEC_SHIFT + 1)
+#define _PAGE_NO_READ		(1 << _PAGE_NO_READ_SHIFT)
 
 #define _PAGE_GLOBAL_SHIFT	(_PAGE_NO_READ_SHIFT + 1)
 #define _PAGE_GLOBAL		(1 << _PAGE_GLOBAL_SHIFT)
@@ -136,10 +133,6 @@
 #endif
 #define _PFN_MASK		(~((1 << (_PFN_SHIFT)) - 1))
 
-#ifndef _PAGE_NO_READ
-#define _PAGE_NO_READ ({BUG(); 0; })
-#define _PAGE_NO_READ_SHIFT ({BUG(); 0; })
-#endif
 #ifndef _PAGE_NO_EXEC
 #define _PAGE_NO_EXEC ({BUG(); 0; })
 #endif
@@ -220,7 +213,7 @@ static inline uint64_t pte_to_entrylo(unsigned long pte_val)
 
 #endif
 
-#define __READABLE	(_PAGE_SILENT_READ | _PAGE_ACCESSED | (kernel_uses_smartmips_rixi ? 0 : _PAGE_READ))
+#define __READABLE	(_PAGE_SILENT_READ | _PAGE_ACCESSED)
 #define __WRITEABLE	(_PAGE_WRITE | _PAGE_SILENT_WRITE | _PAGE_MODIFIED)
 
 #define _PAGE_CHG_MASK  (_PFN_MASK | _PAGE_ACCESSED | _PAGE_MODIFIED | _CACHE_MASK)
diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index 7e40f37..0b3e7c6 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -22,15 +22,15 @@ struct mm_struct;
 struct vm_area_struct;
 
 #define PAGE_NONE	__pgprot(_PAGE_PRESENT | _CACHE_CACHABLE_NONCOHERENT)
-#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | (kernel_uses_smartmips_rixi ? 0 : _PAGE_READ) | \
+#define PAGE_SHARED	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | \
 				 _page_cachable_default)
-#define PAGE_COPY	__pgprot(_PAGE_PRESENT | (kernel_uses_smartmips_rixi ? 0 : _PAGE_READ) | \
-				 (kernel_uses_smartmips_rixi ?  _PAGE_NO_EXEC : 0) | _page_cachable_default)
-#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | (kernel_uses_smartmips_rixi ? 0 : _PAGE_READ) | \
+#define PAGE_COPY	__pgprot(_PAGE_PRESENT | _PAGE_NO_EXEC | \
+				 _page_cachable_default)
+#define PAGE_READONLY	__pgprot(_PAGE_PRESENT | \
 				 _page_cachable_default)
 #define PAGE_KERNEL	__pgprot(_PAGE_PRESENT | __READABLE | __WRITEABLE | \
 				 _PAGE_GLOBAL | _page_cachable_default)
-#define PAGE_USERIO	__pgprot(_PAGE_PRESENT | (kernel_uses_smartmips_rixi ? 0 : _PAGE_READ) | _PAGE_WRITE | \
+#define PAGE_USERIO	__pgprot(_PAGE_PRESENT | _PAGE_WRITE | \
 				 _page_cachable_default)
 #define PAGE_KERNEL_UNCACHED __pgprot(_PAGE_PRESENT | __READABLE | \
 			__WRITEABLE | _PAGE_GLOBAL | _CACHE_UNCACHED)
@@ -250,7 +250,7 @@ static inline pte_t pte_mkdirty(pte_t pte)
 static inline pte_t pte_mkyoung(pte_t pte)
 {
 	pte.pte_low |= _PAGE_ACCESSED;
-	if (pte.pte_low & _PAGE_READ) {
+	if (!(pte.pte_low & _PAGE_NO_READ)) {
 		pte.pte_low  |= _PAGE_SILENT_READ;
 		pte.pte_high |= _PAGE_SILENT_READ;
 	}
@@ -299,13 +299,8 @@ static inline pte_t pte_mkdirty(pte_t pte)
 static inline pte_t pte_mkyoung(pte_t pte)
 {
 	pte_val(pte) |= _PAGE_ACCESSED;
-	if (kernel_uses_smartmips_rixi) {
-		if (!(pte_val(pte) & _PAGE_NO_READ))
-			pte_val(pte) |= _PAGE_SILENT_READ;
-	} else {
-		if (pte_val(pte) & _PAGE_READ)
-			pte_val(pte) |= _PAGE_SILENT_READ;
-	}
+	if (!(pte_val(pte) & _PAGE_NO_READ))
+		pte_val(pte) |= _PAGE_SILENT_READ;
 	return pte;
 }
 
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index f5734c2..451735b 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1463,19 +1463,12 @@ static void __cpuinit
 build_pte_present(u32 **p, struct uasm_reloc **r,
 		  unsigned int pte, unsigned int ptr, enum label_id lid)
 {
-	if (kernel_uses_smartmips_rixi) {
-		if (use_bbit_insns()) {
-			uasm_il_bbit0(p, r, pte, ilog2(_PAGE_PRESENT), lid);
-			uasm_i_nop(p);
-		} else {
-			uasm_i_andi(p, pte, pte, _PAGE_PRESENT);
-			uasm_il_beqz(p, r, pte, lid);
-			iPTE_LW(p, pte, ptr);
-		}
+	if (use_bbit_insns()) {
+		uasm_il_bbit0(p, r, pte, ilog2(_PAGE_PRESENT), lid);
+		uasm_i_nop(p);
 	} else {
-		uasm_i_andi(p, pte, pte, _PAGE_PRESENT | _PAGE_READ);
-		uasm_i_xori(p, pte, pte, _PAGE_PRESENT | _PAGE_READ);
-		uasm_il_bnez(p, r, pte, lid);
+		uasm_i_andi(p, pte, pte, _PAGE_PRESENT);
+		uasm_il_beqz(p, r, pte, lid);
 		iPTE_LW(p, pte, ptr);
 	}
 }
-- 
1.7.4.3

