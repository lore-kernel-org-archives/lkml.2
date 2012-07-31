Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2GaXIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:08:43 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38215 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2GaXFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:05:50 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH 02/22] ARM: use late patch framework for phys-virt patching
Date: Tue, 31 Jul 2012 19:04:38 -0400
Message-ID: <1343775898-28345-3-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the original physical offset patching implementation
with one that uses the newly added patching framework.  In the process, we now
unconditionally initialize the __pv_phys_offset and __pv_offset globals in the
head.S code.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/include/asm/memory.h |   20 ++-------
 arch/arm/kernel/head.S        |   96 +++++------------------------------------
 arch/arm/kernel/module.c      |    5 ---
 arch/arm/kernel/vmlinux.lds.S |    5 ---
 4 files changed, 15 insertions(+), 111 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index fcb5757..01c710d 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -17,6 +17,7 @@
 #include <linux/const.h>
 #include <linux/types.h>
 #include <asm/sizes.h>
+#include <asm/patch.h>
 
 #ifdef CONFIG_NEED_MACH_MEMORY_H
 #include <mach/memory.h>
@@ -151,35 +152,22 @@
 #ifndef __virt_to_phys
 #ifdef CONFIG_ARM_PATCH_PHYS_VIRT
 
-/*
- * Constants used to force the right instruction encodings and shifts
- * so that all we need to do is modify the 8-bit constant field.
- */
-#define __PV_BITS_31_24	0x81000000
-
 extern unsigned long __pv_phys_offset;
 #define PHYS_OFFSET __pv_phys_offset
 
-#define __pv_stub(from,to,instr,type)			\
-	__asm__("@ __pv_stub\n"				\
-	"1:	" instr "	%0, %1, %2\n"		\
-	"	.pushsection .pv_table,\"a\"\n"		\
-	"	.long	1b\n"				\
-	"	.popsection\n"				\
-	: "=r" (to)					\
-	: "r" (from), "I" (type))
+extern unsigned long __pv_offset;
 
 static inline unsigned long __virt_to_phys(unsigned long x)
 {
 	unsigned long t;
-	__pv_stub(x, t, "add", __PV_BITS_31_24);
+	early_patch_imm8(x, t, "add", __pv_offset);
 	return t;
 }
 
 static inline unsigned long __phys_to_virt(unsigned long x)
 {
 	unsigned long t;
-	__pv_stub(x, t, "sub", __PV_BITS_31_24);
+	early_patch_imm8(x, t, "sub", __pv_offset);
 	return t;
 }
 #else
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 835898e..d165896 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -109,9 +109,13 @@ ENTRY(stext)
 
 #ifndef CONFIG_XIP_KERNEL
 	adr	r3, 2f
-	ldmia	r3, {r4, r8}
+	ldmia	r3, {r4, r5, r6, r8}
 	sub	r4, r3, r4			@ (PHYS_OFFSET - PAGE_OFFSET)
 	add	r8, r8, r4			@ PHYS_OFFSET
+	add	r5, r5, r4
+	str	r8, [r5]			@ set __pv_phys_offset
+	add	r6, r6, r4
+	str	r4, [r6]			@ set __pv_offset
 #else
 	ldr	r8, =PHYS_OFFSET		@ always constant in this case
 #endif
@@ -124,9 +128,6 @@ ENTRY(stext)
 #ifdef CONFIG_SMP_ON_UP
 	bl	__fixup_smp
 #endif
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
-	bl	__fixup_pv_table
-#endif
 	bl	__create_page_tables
 
 	/*
@@ -148,6 +149,8 @@ ENDPROC(stext)
 	.ltorg
 #ifndef CONFIG_XIP_KERNEL
 2:	.long	.
+	.long	__pv_phys_offset
+	.long	__pv_offset
 	.long	PAGE_OFFSET
 #endif
 
@@ -522,94 +525,17 @@ ENTRY(fixup_smp)
 	ldmfd	sp!, {r4 - r6, pc}
 ENDPROC(fixup_smp)
 
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
-
-/* __fixup_pv_table - patch the stub instructions with the delta between
- * PHYS_OFFSET and PAGE_OFFSET, which is assumed to be 16MiB aligned and
- * can be expressed by an immediate shifter operand. The stub instruction
- * has a form of '(add|sub) rd, rn, #imm'.
- */
-	__HEAD
-__fixup_pv_table:
-	adr	r0, 1f
-	ldmia	r0, {r3-r5, r7}
-	sub	r3, r0, r3	@ PHYS_OFFSET - PAGE_OFFSET
-	add	r4, r4, r3	@ adjust table start address
-	add	r5, r5, r3	@ adjust table end address
-	add	r7, r7, r3	@ adjust __pv_phys_offset address
-	str	r8, [r7]	@ save computed PHYS_OFFSET to __pv_phys_offset
-	mov	r6, r3, lsr #24	@ constant for add/sub instructions
-	teq	r3, r6, lsl #24 @ must be 16MiB aligned
-THUMB(	it	ne		@ cross section branch )
-	bne	__error
-	str	r6, [r7, #4]	@ save to __pv_offset
-	b	__fixup_a_pv_table
-ENDPROC(__fixup_pv_table)
-
-	.align
-1:	.long	.
-	.long	__pv_table_begin
-	.long	__pv_table_end
-2:	.long	__pv_phys_offset
-
-	.text
-__fixup_a_pv_table:
-#ifdef CONFIG_THUMB2_KERNEL
-	lsls	r6, #24
-	beq	2f
-	clz	r7, r6
-	lsr	r6, #24
-	lsl	r6, r7
-	bic	r6, #0x0080
-	lsrs	r7, #1
-	orrcs	r6, #0x0080
-	orr	r6, r6, r7, lsl #12
-	orr	r6, #0x4000
-	b	2f
-1:	add     r7, r3
-	ldrh	ip, [r7, #2]
-	and	ip, 0x8f00
-	orr	ip, r6	@ mask in offset bits 31-24
-	strh	ip, [r7, #2]
-2:	cmp	r4, r5
-	ldrcc	r7, [r4], #4	@ use branch for delay slot
-	bcc	1b
-	bx	lr
-#else
-	b	2f
-1:	ldr	ip, [r7, r3]
-	bic	ip, ip, #0x000000ff
-	orr	ip, ip, r6	@ mask in offset bits 31-24
-	str	ip, [r7, r3]
-2:	cmp	r4, r5
-	ldrcc	r7, [r4], #4	@ use branch for delay slot
-	bcc	1b
-	mov	pc, lr
-#endif
-ENDPROC(__fixup_a_pv_table)
-
-ENTRY(fixup_pv_table)
-	stmfd	sp!, {r4 - r7, lr}
-	ldr	r2, 2f			@ get address of __pv_phys_offset
-	mov	r3, #0			@ no offset
-	mov	r4, r0			@ r0 = table start
-	add	r5, r0, r1		@ r1 = table size
-	ldr	r6, [r2, #4]		@ get __pv_offset
-	bl	__fixup_a_pv_table
-	ldmfd	sp!, {r4 - r7, pc}
-ENDPROC(fixup_pv_table)
-
-	.align
-2:	.long	__pv_phys_offset
-
 	.data
 	.globl	__pv_phys_offset
 	.type	__pv_phys_offset, %object
 __pv_phys_offset:
 	.long	0
 	.size	__pv_phys_offset, . - __pv_phys_offset
+
+	.globl	__pv_offset
+	.type	__pv_offset, %object
 __pv_offset:
 	.long	0
-#endif
+	.size	__pv_offset, . - __pv_offset
 
 #include "head-common.S"
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index df5e897..39f8fce 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -317,11 +317,6 @@ int module_finalize(const Elf32_Ehdr *hdr, const Elf_Shdr *sechdrs,
 					         maps[i].txt_sec->sh_addr,
 					         maps[i].txt_sec->sh_size);
 #endif
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT
-	s = find_mod_section(hdr, sechdrs, ".pv_table");
-	if (s)
-		fixup_pv_table((void *)s->sh_addr, s->sh_size);
-#endif
 	s = find_mod_section(hdr, sechdrs, ".patch.table");
 	if (s)
 		patch_kernel((void *)s->sh_addr, s->sh_size);
diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index bacb275..13731e3 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -162,11 +162,6 @@ SECTIONS
 		__smpalt_end = .;
 	}
 #endif
-	.init.pv_table : {
-		__pv_table_begin = .;
-		*(.pv_table)
-		__pv_table_end = .;
-	}
 	.init.patch_table : {
 		__patch_table_begin = .;
 		*(.patch.table)
-- 
1.7.9.5

