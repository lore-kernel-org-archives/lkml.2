Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1AQIfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:35:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:50262 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab1AQIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:35:11 -0500
From: "Stanley.Miao" <stanley.miao@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] Support BE8 mode kernel modules relocation
Date: Mon, 17 Jan 2011 16:42:07 +0800
Message-Id: <1295253729-23153-2-git-send-email-stanley.miao@windriver.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
References: <1295253729-23153-1-git-send-email-stanley.miao@windriver.com>
X-OriginalArrivalTime: 17 Jan 2011 08:35:00.0059 (UTC) FILETIME=[6DAF92B0:01CBB621]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code section in BE8 kernel modules is in little-endian while data
section is in big-endian. When reading code from memory in the relocation
procedure, these instructions are read according to big-endian, so they
need to be inverted before writing to memory and after reading from memory.

Signed-off-by: Stanley.Miao <stanley.miao@windriver.com>
---
 arch/arm/Makefile         |    1 +
 arch/arm/include/asm/io.h |   12 ++++++++++
 arch/arm/kernel/module.c  |   51 ++++++++++++++++++++++++--------------------
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 3eec793..03e7761 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -13,6 +13,7 @@
 LDFLAGS_vmlinux	:=-p --no-undefined -X
 ifeq ($(CONFIG_CPU_ENDIAN_BE8),y)
 LDFLAGS_vmlinux	+= --be8
+LDFLAGS_MODULE	+= --be8
 endif
 
 OBJCOPYFLAGS	:=-O binary -R .note -R .note.gnu.build-id -R .comment -S
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 815efa2..2f088c5 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -233,6 +233,18 @@ extern void _memset_io(volatile void __iomem *, int, size_t);
 
 #endif	/* __mem_pci */
 
+#ifdef CONFIG_CPU_ENDIAN_BE8
+#define read_instr32(c)			__swab32(*(u32 *)c)
+#define read_instr16(c)			__swab16(*(u16 *)c)
+#define write_instr32(v,a)		(*(u32 *)(a) = __swab32((__force __u32)(v)))
+#define write_instr16(v,a)		(*(u16 *)(a) = __swab16((__force __u16)(v)))
+#else
+#define read_instr32(c)			(*(u32 *)c)
+#define read_instr16(c)			(*(u16 *)c)
+#define write_instr32(v,a)		(*(u32 *)(a) = (v))
+#define write_instr16(v,a)		(*(u16 *)(a) = (v))
+#endif
+
 /*
  * ioremap and friends.
  *
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index d9bd786..9c58a0d 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -14,6 +14,7 @@
 #include <linux/moduleloader.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/io.h>
 #include <linux/elf.h>
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
@@ -148,7 +149,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 		case R_ARM_PC24:
 		case R_ARM_CALL:
 		case R_ARM_JUMP24:
-			offset = (*(u32 *)loc & 0x00ffffff) << 2;
+			offset = (read_instr32(loc) & 0x00ffffff) << 2;
 			if (offset & 0x02000000)
 				offset -= 0x04000000;
 
@@ -165,8 +166,8 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 
 			offset >>= 2;
 
-			*(u32 *)loc &= 0xff000000;
-			*(u32 *)loc |= offset & 0x00ffffff;
+			write_instr32((read_instr32(loc) & 0xff000000) |
+						(offset & 0x00ffffff), loc);
 			break;
 
 	       case R_ARM_V4BX:
@@ -174,9 +175,9 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			* other bits to re-code instruction as
 			* MOV PC,Rm.
 			*/
-		       *(u32 *)loc &= 0xf000000f;
-		       *(u32 *)loc |= 0x01a0f000;
-		       break;
+			write_instr32((read_instr32(loc) & 0xf000000f) |
+							0x01a0f000, loc);
+			break;
 
 		case R_ARM_PREL31:
 			offset = *(u32 *)loc + sym->st_value - loc;
@@ -185,7 +186,7 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 
 		case R_ARM_MOVW_ABS_NC:
 		case R_ARM_MOVT_ABS:
-			offset = *(u32 *)loc;
+			offset = read_instr32(loc);
 			offset = ((offset & 0xf0000) >> 4) | (offset & 0xfff);
 			offset = (offset ^ 0x8000) - 0x8000;
 
@@ -193,16 +194,16 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			if (ELF32_R_TYPE(rel->r_info) == R_ARM_MOVT_ABS)
 				offset >>= 16;
 
-			*(u32 *)loc &= 0xfff0f000;
-			*(u32 *)loc |= ((offset & 0xf000) << 4) |
-					(offset & 0x0fff);
+			write_instr32((read_instr32(loc) & 0xfff0f000) |
+					((offset & 0xf000) << 4) |
+					(offset & 0x0fff), loc);
 			break;
 
 #ifdef CONFIG_THUMB2_KERNEL
 		case R_ARM_THM_CALL:
 		case R_ARM_THM_JUMP24:
-			upper = *(u16 *)loc;
-			lower = *(u16 *)(loc + 2);
+			upper = read_instr16(loc);
+			lower = read_instr16(loc + 2);
 
 			/*
 			 * 25 bit signed address range (Thumb-2 BL and B.W
@@ -242,17 +243,19 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			sign = (offset >> 24) & 1;
 			j1 = sign ^ (~(offset >> 23) & 1);
 			j2 = sign ^ (~(offset >> 22) & 1);
-			*(u16 *)loc = (u16)((upper & 0xf800) | (sign << 10) |
-					    ((offset >> 12) & 0x03ff));
-			*(u16 *)(loc + 2) = (u16)((lower & 0xd000) |
-						  (j1 << 13) | (j2 << 11) |
-						  ((offset >> 1) & 0x07ff));
+			write_instr16((u16)((upper & 0xf800) | (sign << 10) |
+						((offset >> 12) & 0x03ff)),
+					loc);
+			write_instr16((u16)((lower & 0xd000) |
+						(j1 << 13) | (j2 << 11) |
+						((offset >> 1) & 0x07ff)),
+					loc + 2);
 			break;
 
 		case R_ARM_THM_MOVW_ABS_NC:
 		case R_ARM_THM_MOVT_ABS:
-			upper = *(u16 *)loc;
-			lower = *(u16 *)(loc + 2);
+			upper = read_instr16(loc);
+			lower = read_instr16(loc + 2);
 
 			/*
 			 * MOVT/MOVW instructions encoding in Thumb-2:
@@ -273,12 +276,14 @@ apply_relocate(Elf32_Shdr *sechdrs, const char *strtab, unsigned int symindex,
 			if (ELF32_R_TYPE(rel->r_info) == R_ARM_THM_MOVT_ABS)
 				offset >>= 16;
 
-			*(u16 *)loc = (u16)((upper & 0xfbf0) |
+			write_instr16((u16)((upper & 0xfbf0) |
 					    ((offset & 0xf000) >> 12) |
-					    ((offset & 0x0800) >> 1));
-			*(u16 *)(loc + 2) = (u16)((lower & 0x8f00) |
+					    ((offset & 0x0800) >> 1)),
+					doc);
+			write_instr16((u16)((lower & 0x8f00) |
 						  ((offset & 0x0700) << 4) |
-						  (offset & 0x00ff));
+						  (offset & 0x00ff)),
+					doc + 2);
 			break;
 #endif
 
-- 
1.5.4.3

