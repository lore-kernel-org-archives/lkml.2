Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0F3GIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:08:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50563 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0F3GIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:08:46 -0400
Date: Wed, 30 Jun 2010 16:08:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
       Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] powerpc: fix module building for gcc 4.5 and 64 bit
Message-Id: <20100630160842.c2a69fc2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 4.5 is now generating out of line register save and restore
in the function prefix and postfix when we use -Os.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/Makefile        |    4 +-
 arch/powerpc/lib/Makefile    |    4 +-
 arch/powerpc/lib/crtsavres.S |  129 ++++++++++++++++++++++++++++++++++++++++++
 scripts/mod/modpost.c        |    5 ++
 4 files changed, 138 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 42dcd3f..77cfe7a 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -92,10 +92,10 @@ endif
 else
 	KBUILD_CFLAGS += $(call cc-option,-mtune=power4)
 endif
-else
-LDFLAGS_MODULE	+= arch/powerpc/lib/crtsavres.o
 endif
 
+LDFLAGS_MODULE	+= arch/powerpc/lib/crtsavres.o
+
 ifeq ($(CONFIG_TUNE_CELL),y)
 	KBUILD_CFLAGS += $(call cc-option,-mtune=cell)
 endif
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 3040dac..111da1c 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -12,8 +12,8 @@ CFLAGS_REMOVE_code-patching.o = -pg
 CFLAGS_REMOVE_feature-fixups.o = -pg
 
 obj-y			:= string.o alloc.o \
-			   checksum_$(CONFIG_WORD_SIZE).o
-obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o
+			   checksum_$(CONFIG_WORD_SIZE).o crtsavres.o
+obj-$(CONFIG_PPC32)	+= div64.o copy_32.o
 obj-$(CONFIG_HAS_IOMEM)	+= devres.o
 
 obj-$(CONFIG_PPC64)	+= copypage_64.o copyuser_64.o \
diff --git a/arch/powerpc/lib/crtsavres.S b/arch/powerpc/lib/crtsavres.S
index 70a9cd8..1c893f0 100644
--- a/arch/powerpc/lib/crtsavres.S
+++ b/arch/powerpc/lib/crtsavres.S
@@ -6,6 +6,7 @@
  *   Written By Michael Meissner
  *
  * Based on gcc/config/rs6000/crtsavres.asm from gcc
+ * 64 bit additions from reading the PPC elf64abi document.
  *
  * This file is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -44,6 +45,8 @@
 
 #ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 
+#ifndef CONFIG_PPC64
+
 /* Routines for saving integer registers, called by the compiler.  */
 /* Called with r11 pointing to the stack header word of the caller of the */
 /* function, just beyond the end of the integer save area.  */
@@ -226,4 +229,130 @@ _GLOBAL(_rest32gpr_31_x)
 	mtlr	0
 	mr	1,11
 	blr
+
+#else /* CONFIG_PPC64 */
+
+.globl	_savegpr0_14
+_savegpr0_14:
+	std	r14,-144(r1)
+.globl	_savegpr0_15
+_savegpr0_15:
+	std	r15,-136(r1)
+.globl	_savegpr0_16
+_savegpr0_16:
+	std	r16,-128(r1)
+.globl	_savegpr0_17
+_savegpr0_17:
+	std	r17,-120(r1)
+.globl	_savegpr0_18
+_savegpr0_18:
+	std	r18,-112(r1)
+.globl	_savegpr0_19
+_savegpr0_19:
+	std	r19,-104(r1)
+.globl	_savegpr0_20
+_savegpr0_20:
+	std	r20,-96(r1)
+.globl	_savegpr0_21
+_savegpr0_21:
+	std	r21,-88(r1)
+.globl	_savegpr0_22
+_savegpr0_22:
+	std	r22,-80(r1)
+.globl	_savegpr0_23
+_savegpr0_23:
+	std	r23,-72(r1)
+.globl	_savegpr0_24
+_savegpr0_24:
+	std	r24,-64(r1)
+.globl	_savegpr0_25
+_savegpr0_25:
+	std	r25,-56(r1)
+.globl	_savegpr0_26
+_savegpr0_26:
+	std	r26,-48(r1)
+.globl	_savegpr0_27
+_savegpr0_27:
+	std	r27,-40(r1)
+.globl	_savegpr0_28
+_savegpr0_28:
+	std	r28,-32(r1)
+.globl	_savegpr0_29
+_savegpr0_29:
+	std	r29,-24(r1)
+.globl	_savegpr0_30
+_savegpr0_30:
+	std	r30,-16(r1)
+.globl	_savegpr0_31
+_savegpr0_31:
+	std	r31,-8(r1)
+	std	r0,16(r1)
+	blr
+
+.globl	_restgpr0_14
+_restgpr0_14:
+	ld	r14,-144(r1)
+.globl	_restgpr0_15
+_restgpr0_15:
+	ld	r15,-136(r1)
+.globl	_restgpr0_16
+_restgpr0_16:
+	ld	r16,-128(r1)
+.globl	_restgpr0_17
+_restgpr0_17:
+	ld	r17,-120(r1)
+.globl	_restgpr0_18
+_restgpr0_18:
+	ld	r18,-112(r1)
+.globl	_restgpr0_19
+_restgpr0_19:
+	ld	r19,-104(r1)
+.globl	_restgpr0_20
+_restgpr0_20:
+	ld	r20,-96(r1)
+.globl	_restgpr0_21
+_restgpr0_21:
+	ld	r21,-88(r1)
+.globl	_restgpr0_22
+_restgpr0_22:
+	ld	r22,-80(r1)
+.globl	_restgpr0_23
+_restgpr0_23:
+	ld	r23,-72(r1)
+.globl	_restgpr0_24
+_restgpr0_24:
+	ld	r24,-64(r1)
+.globl	_restgpr0_25
+_restgpr0_25:
+	ld	r25,-56(r1)
+.globl	_restgpr0_26
+_restgpr0_26:
+	ld	r26,-48(r1)
+.globl	_restgpr0_27
+_restgpr0_27:
+	ld	r27,-40(r1)
+.globl	_restgpr0_28
+_restgpr0_28:
+	ld	r28,-32(r1)
+.globl	_restgpr0_29
+_restgpr0_29:
+	ld	r0,16(r1)
+	ld	r29,-24(r1)
+	mtlr	r0
+	ld	r30,-16(r1)
+	ld	r31,-8(r1)
+	blr
+
+.globl	_restgpr0_30
+_restgpr0_30:
+	ld	r30,-16(r1)
+.globl	_restgpr0_31
+_restgpr0_31:
+	ld	r0,16(r1)
+	ld	r31,-8(r1)
+	mtlr	r0
+	blr
+
+#endif /* CONFIG_PPC64 */
+
 #endif
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f877900..f6127b9 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -503,6 +503,11 @@ static int ignore_undef_symbol(struct elf_info *info, const char *symname)
 		    strncmp(symname, "_rest32gpr_", sizeof("_rest32gpr_") - 1) == 0 ||
 		    strncmp(symname, "_save32gpr_", sizeof("_save32gpr_") - 1) == 0)
 			return 1;
+	if (info->hdr->e_machine == EM_PPC64)
+		/* Special register function linked on all modules during final link of .ko */
+		if (strncmp(symname, "_restgpr0_", sizeof("_restgpr0_") - 1) == 0 ||
+		    strncmp(symname, "_savegpr0_", sizeof("_savegpr0_") - 1) == 0)
+			return 1;
 	/* Do not ignore this symbol */
 	return 0;
 }
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
