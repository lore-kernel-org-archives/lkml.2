Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab1KCDTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:19:20 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:9772 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1KCDTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:19:13 -0400
Message-Id: <201111030319.pA33JBsJ005867@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 2 Nov 2011 23:02:17 -0400
Subject: [PATCH] arch/tile: factor out <arch/opcode.h> header
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 03 Nov 2011 03:19:11.0358 (UTC) FILETIME=[5B2CC1E0:01CC99D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel code was using some <asm> headers that included a mix
of hardware-specific information (typically found in Tilera <arch>
headers) and structures, enums, and function declarations supporting
the disassembly function of the tile-desc.c sources.

This change refactors that code so that a hardware-specific, but
OS- and application-agnostic header, is created: <arch/opcode.h>.
This header is then exported to userspace along with the other
<arch> headers and can be used to build userspace code; in particular,
it is used by glibc as part of implementing the backtrace() function.

The new header, together with a header that specifically describes
the disassembly code (<asm/tile-desc.h> with _32 and _64 variants),
replaces the old <asm/opcode-tile*.h> and <asm/opcode_constants*.h>
headers.

As part of this change, we are also renaming the 32-bit constants
from TILE_xxx to TILEPRO_xxx to better reflect the fact that they
are specific to the TILEPro architecture, and not to TILE-Gx
and any successor "tile" architecture chips.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/opcode.h             |   21 +
 arch/tile/include/arch/opcode_tilegx.h      | 1405 +++++++++++++++++
 arch/tile/include/arch/opcode_tilepro.h     | 1471 ++++++++++++++++++
 arch/tile/include/asm/opcode-tile.h         |   30 -
 arch/tile/include/asm/opcode-tile_32.h      | 1513 ------------------
 arch/tile/include/asm/opcode-tile_64.h      | 1248 ---------------
 arch/tile/include/asm/opcode_constants.h    |   26 -
 arch/tile/include/asm/opcode_constants_32.h |  480 ------
 arch/tile/include/asm/opcode_constants_64.h |  609 --------
 arch/tile/include/asm/tile-desc.h           |   19 +
 arch/tile/include/asm/tile-desc_32.h        |  553 +++++++
 arch/tile/include/asm/tile-desc_64.h        |  483 ++++++
 arch/tile/kernel/backtrace.c                |   19 +-
 arch/tile/kernel/module.c                   |    2 +-
 arch/tile/kernel/single_step.c              |    9 +-
 arch/tile/kernel/tile-desc_32.c             | 2242 ++++++++++++++-------------
 arch/tile/kernel/tile-desc_64.c             |   28 +-
 arch/tile/kernel/traps.c                    |    5 +-
 18 files changed, 5170 insertions(+), 4993 deletions(-)
 create mode 100644 arch/tile/include/arch/opcode.h
 create mode 100644 arch/tile/include/arch/opcode_tilegx.h
 create mode 100644 arch/tile/include/arch/opcode_tilepro.h
 delete mode 100644 arch/tile/include/asm/opcode-tile.h
 delete mode 100644 arch/tile/include/asm/opcode-tile_32.h
 delete mode 100644 arch/tile/include/asm/opcode-tile_64.h
 delete mode 100644 arch/tile/include/asm/opcode_constants.h
 delete mode 100644 arch/tile/include/asm/opcode_constants_32.h
 delete mode 100644 arch/tile/include/asm/opcode_constants_64.h
 create mode 100644 arch/tile/include/asm/tile-desc.h
 create mode 100644 arch/tile/include/asm/tile-desc_32.h
 create mode 100644 arch/tile/include/asm/tile-desc_64.h

diff --git a/arch/tile/include/arch/opcode.h b/arch/tile/include/arch/opcode.h
new file mode 100644
index 0000000..92d1522
--- /dev/null
+++ b/arch/tile/include/arch/opcode.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#if defined(__tilepro__)
+#include <arch/opcode_tilepro.h>
+#elif defined(__tilegx__)
+#include <arch/opcode_tilegx.h>
+#else
+#error Unexpected Tilera chip type
+#endif
diff --git a/arch/tile/include/arch/opcode_tilegx.h b/arch/tile/include/arch/opcode_tilegx.h
new file mode 100644
index 0000000..c14d02c
--- /dev/null
+++ b/arch/tile/include/arch/opcode_tilegx.h
@@ -0,0 +1,1405 @@
+/* TILE-Gx opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
+#ifndef __ARCH_OPCODE_H__
+#define __ARCH_OPCODE_H__
+
+#ifndef __ASSEMBLER__
+
+typedef unsigned long long tilegx_bundle_bits;
+
+/* These are the bits that determine if a bundle is in the X encoding. */
+#define TILEGX_BUNDLE_MODE_MASK ((tilegx_bundle_bits)3 << 62)
+
+enum
+{
+  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
+  TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
+
+  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
+  TILEGX_NUM_PIPELINE_ENCODINGS = 5,
+
+  /* Log base 2 of TILEGX_BUNDLE_SIZE_IN_BYTES. */
+  TILEGX_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
+
+  /* Instructions take this many bytes. */
+  TILEGX_BUNDLE_SIZE_IN_BYTES = 1 << TILEGX_LOG2_BUNDLE_SIZE_IN_BYTES,
+
+  /* Log base 2 of TILEGX_BUNDLE_ALIGNMENT_IN_BYTES. */
+  TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
+
+  /* Bundles should be aligned modulo this number of bytes. */
+  TILEGX_BUNDLE_ALIGNMENT_IN_BYTES =
+    (1 << TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
+
+  /* Number of registers (some are magic, such as network I/O). */
+  TILEGX_NUM_REGISTERS = 64,
+};
+
+/* Make a few "tile_" variables to simplify common code between
+   architectures.  */
+
+typedef tilegx_bundle_bits tile_bundle_bits;
+#define TILE_BUNDLE_SIZE_IN_BYTES TILEGX_BUNDLE_SIZE_IN_BYTES
+#define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEGX_BUNDLE_ALIGNMENT_IN_BYTES
+#define TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES \
+  TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES
+
+/* 64-bit pattern for a { bpt ; nop } bundle. */
+#define TILEGX_BPT_BUNDLE 0x286a44ae51485000ULL
+
+static __inline unsigned int
+get_BFEnd_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_BFOpcodeExtension_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 24)) & 0xf);
+}
+
+static __inline unsigned int
+get_BFStart_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3f);
+}
+
+static __inline unsigned int
+get_BrOff_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 37)) & 0x0001ffc0);
+}
+
+static __inline unsigned int
+get_BrType_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 54)) & 0x1f);
+}
+
+static __inline unsigned int
+get_Dest_Imm8_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 43)) & 0x000000c0);
+}
+
+static __inline unsigned int
+get_Dest_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Imm16_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm16_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm8OpcodeExtension_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8OpcodeExtension_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 51)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_JumpOff_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x7ffffff);
+}
+
+static __inline unsigned int
+get_JumpOpcodeExtension_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 58)) & 0x1);
+}
+
+static __inline unsigned int
+get_MF_Imm14_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3fff);
+}
+
+static __inline unsigned int
+get_MT_Imm14_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 37)) & 0x00003fc0);
+}
+
+static __inline unsigned int
+get_Mode(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 62)) & 0x3);
+}
+
+static __inline unsigned int
+get_Opcode_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 28)) & 0x7);
+}
+
+static __inline unsigned int
+get_Opcode_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0x7);
+}
+
+static __inline unsigned int
+get_Opcode_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 58)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y2(tilegx_bundle_bits n)
+{
+  return (((n >> 26)) & 0x00000001) |
+         (((unsigned int)(n >> 56)) & 0x00000002);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3);
+}
+
+static __inline unsigned int
+get_ShAmt_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_ShAmt_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_ShiftOpcodeExtension_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_ShiftOpcodeExtension_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_ShiftOpcodeExtension_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3);
+}
+
+static __inline unsigned int
+get_ShiftOpcodeExtension_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3);
+}
+
+static __inline unsigned int
+get_SrcA_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y2(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcBDest_Y2(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 51)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_UnaryOpcodeExtension_X0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_UnaryOpcodeExtension_X1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_UnaryOpcodeExtension_Y0(tilegx_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_UnaryOpcodeExtension_Y1(tilegx_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+
+static __inline int
+sign_extend(int n, int num_bits)
+{
+  int shift = (int)(sizeof(int) * 8 - num_bits);
+  return (n << shift) >> shift;
+}
+
+
+
+static __inline tilegx_bundle_bits
+create_BFEnd_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_BFOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 24);
+}
+
+static __inline tilegx_bundle_bits
+create_BFStart_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 18);
+}
+
+static __inline tilegx_bundle_bits
+create_BrOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tilegx_bundle_bits)(n & 0x0001ffc0)) << 37);
+}
+
+static __inline tilegx_bundle_bits
+create_BrType_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x1f)) << 54);
+}
+
+static __inline tilegx_bundle_bits
+create_Dest_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tilegx_bundle_bits)(n & 0x000000c0)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_Dest_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tilegx_bundle_bits
+create_Dest_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tilegx_bundle_bits
+create_Dest_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tilegx_bundle_bits
+create_Dest_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm16_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xffff) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm16_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0xffff)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8OpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 20);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8OpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0xff)) << 51);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_Imm8_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_JumpOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x7ffffff)) << 31);
+}
+
+static __inline tilegx_bundle_bits
+create_JumpOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x1)) << 58);
+}
+
+static __inline tilegx_bundle_bits
+create_MF_Imm14_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3fff)) << 37);
+}
+
+static __inline tilegx_bundle_bits
+create_MT_Imm14_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tilegx_bundle_bits)(n & 0x00003fc0)) << 37);
+}
+
+static __inline tilegx_bundle_bits
+create_Mode(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3)) << 62);
+}
+
+static __inline tilegx_bundle_bits
+create_Opcode_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 28);
+}
+
+static __inline tilegx_bundle_bits
+create_Opcode_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x7)) << 59);
+}
+
+static __inline tilegx_bundle_bits
+create_Opcode_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 27);
+}
+
+static __inline tilegx_bundle_bits
+create_Opcode_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0xf)) << 58);
+}
+
+static __inline tilegx_bundle_bits
+create_Opcode_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x00000001) << 26) |
+         (((tilegx_bundle_bits)(n & 0x00000002)) << 56);
+}
+
+static __inline tilegx_bundle_bits
+create_RRROpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 18);
+}
+
+static __inline tilegx_bundle_bits
+create_RRROpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3ff)) << 49);
+}
+
+static __inline tilegx_bundle_bits
+create_RRROpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 18);
+}
+
+static __inline tilegx_bundle_bits
+create_RRROpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3)) << 49);
+}
+
+static __inline tilegx_bundle_bits
+create_ShAmt_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_ShAmt_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_ShAmt_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_ShAmt_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_ShiftOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 18);
+}
+
+static __inline tilegx_bundle_bits
+create_ShiftOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3ff)) << 49);
+}
+
+static __inline tilegx_bundle_bits
+create_ShiftOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 18);
+}
+
+static __inline tilegx_bundle_bits
+create_ShiftOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3)) << 49);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcA_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcA_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcA_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcA_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcA_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 20);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcBDest_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 51);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcB_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcB_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcB_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_SrcB_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_UnaryOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_UnaryOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilegx_bundle_bits
+create_UnaryOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilegx_bundle_bits
+create_UnaryOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
+}
+
+
+enum
+{
+  ADDI_IMM8_OPCODE_X0 = 1,
+  ADDI_IMM8_OPCODE_X1 = 1,
+  ADDI_OPCODE_Y0 = 0,
+  ADDI_OPCODE_Y1 = 1,
+  ADDLI_OPCODE_X0 = 1,
+  ADDLI_OPCODE_X1 = 0,
+  ADDXI_IMM8_OPCODE_X0 = 2,
+  ADDXI_IMM8_OPCODE_X1 = 2,
+  ADDXI_OPCODE_Y0 = 1,
+  ADDXI_OPCODE_Y1 = 2,
+  ADDXLI_OPCODE_X0 = 2,
+  ADDXLI_OPCODE_X1 = 1,
+  ADDXSC_RRR_0_OPCODE_X0 = 1,
+  ADDXSC_RRR_0_OPCODE_X1 = 1,
+  ADDX_RRR_0_OPCODE_X0 = 2,
+  ADDX_RRR_0_OPCODE_X1 = 2,
+  ADDX_RRR_0_OPCODE_Y0 = 0,
+  ADDX_SPECIAL_0_OPCODE_Y1 = 0,
+  ADD_RRR_0_OPCODE_X0 = 3,
+  ADD_RRR_0_OPCODE_X1 = 3,
+  ADD_RRR_0_OPCODE_Y0 = 1,
+  ADD_SPECIAL_0_OPCODE_Y1 = 1,
+  ANDI_IMM8_OPCODE_X0 = 3,
+  ANDI_IMM8_OPCODE_X1 = 3,
+  ANDI_OPCODE_Y0 = 2,
+  ANDI_OPCODE_Y1 = 3,
+  AND_RRR_0_OPCODE_X0 = 4,
+  AND_RRR_0_OPCODE_X1 = 4,
+  AND_RRR_5_OPCODE_Y0 = 0,
+  AND_RRR_5_OPCODE_Y1 = 0,
+  BEQZT_BRANCH_OPCODE_X1 = 16,
+  BEQZ_BRANCH_OPCODE_X1 = 17,
+  BFEXTS_BF_OPCODE_X0 = 4,
+  BFEXTU_BF_OPCODE_X0 = 5,
+  BFINS_BF_OPCODE_X0 = 6,
+  BF_OPCODE_X0 = 3,
+  BGEZT_BRANCH_OPCODE_X1 = 18,
+  BGEZ_BRANCH_OPCODE_X1 = 19,
+  BGTZT_BRANCH_OPCODE_X1 = 20,
+  BGTZ_BRANCH_OPCODE_X1 = 21,
+  BLBCT_BRANCH_OPCODE_X1 = 22,
+  BLBC_BRANCH_OPCODE_X1 = 23,
+  BLBST_BRANCH_OPCODE_X1 = 24,
+  BLBS_BRANCH_OPCODE_X1 = 25,
+  BLEZT_BRANCH_OPCODE_X1 = 26,
+  BLEZ_BRANCH_OPCODE_X1 = 27,
+  BLTZT_BRANCH_OPCODE_X1 = 28,
+  BLTZ_BRANCH_OPCODE_X1 = 29,
+  BNEZT_BRANCH_OPCODE_X1 = 30,
+  BNEZ_BRANCH_OPCODE_X1 = 31,
+  BRANCH_OPCODE_X1 = 2,
+  CMOVEQZ_RRR_0_OPCODE_X0 = 5,
+  CMOVEQZ_RRR_4_OPCODE_Y0 = 0,
+  CMOVNEZ_RRR_0_OPCODE_X0 = 6,
+  CMOVNEZ_RRR_4_OPCODE_Y0 = 1,
+  CMPEQI_IMM8_OPCODE_X0 = 4,
+  CMPEQI_IMM8_OPCODE_X1 = 4,
+  CMPEQI_OPCODE_Y0 = 3,
+  CMPEQI_OPCODE_Y1 = 4,
+  CMPEQ_RRR_0_OPCODE_X0 = 7,
+  CMPEQ_RRR_0_OPCODE_X1 = 5,
+  CMPEQ_RRR_3_OPCODE_Y0 = 0,
+  CMPEQ_RRR_3_OPCODE_Y1 = 2,
+  CMPEXCH4_RRR_0_OPCODE_X1 = 6,
+  CMPEXCH_RRR_0_OPCODE_X1 = 7,
+  CMPLES_RRR_0_OPCODE_X0 = 8,
+  CMPLES_RRR_0_OPCODE_X1 = 8,
+  CMPLES_RRR_2_OPCODE_Y0 = 0,
+  CMPLES_RRR_2_OPCODE_Y1 = 0,
+  CMPLEU_RRR_0_OPCODE_X0 = 9,
+  CMPLEU_RRR_0_OPCODE_X1 = 9,
+  CMPLEU_RRR_2_OPCODE_Y0 = 1,
+  CMPLEU_RRR_2_OPCODE_Y1 = 1,
+  CMPLTSI_IMM8_OPCODE_X0 = 5,
+  CMPLTSI_IMM8_OPCODE_X1 = 5,
+  CMPLTSI_OPCODE_Y0 = 4,
+  CMPLTSI_OPCODE_Y1 = 5,
+  CMPLTS_RRR_0_OPCODE_X0 = 10,
+  CMPLTS_RRR_0_OPCODE_X1 = 10,
+  CMPLTS_RRR_2_OPCODE_Y0 = 2,
+  CMPLTS_RRR_2_OPCODE_Y1 = 2,
+  CMPLTUI_IMM8_OPCODE_X0 = 6,
+  CMPLTUI_IMM8_OPCODE_X1 = 6,
+  CMPLTU_RRR_0_OPCODE_X0 = 11,
+  CMPLTU_RRR_0_OPCODE_X1 = 11,
+  CMPLTU_RRR_2_OPCODE_Y0 = 3,
+  CMPLTU_RRR_2_OPCODE_Y1 = 3,
+  CMPNE_RRR_0_OPCODE_X0 = 12,
+  CMPNE_RRR_0_OPCODE_X1 = 12,
+  CMPNE_RRR_3_OPCODE_Y0 = 1,
+  CMPNE_RRR_3_OPCODE_Y1 = 3,
+  CMULAF_RRR_0_OPCODE_X0 = 13,
+  CMULA_RRR_0_OPCODE_X0 = 14,
+  CMULFR_RRR_0_OPCODE_X0 = 15,
+  CMULF_RRR_0_OPCODE_X0 = 16,
+  CMULHR_RRR_0_OPCODE_X0 = 17,
+  CMULH_RRR_0_OPCODE_X0 = 18,
+  CMUL_RRR_0_OPCODE_X0 = 19,
+  CNTLZ_UNARY_OPCODE_X0 = 1,
+  CNTLZ_UNARY_OPCODE_Y0 = 1,
+  CNTTZ_UNARY_OPCODE_X0 = 2,
+  CNTTZ_UNARY_OPCODE_Y0 = 2,
+  CRC32_32_RRR_0_OPCODE_X0 = 20,
+  CRC32_8_RRR_0_OPCODE_X0 = 21,
+  DBLALIGN2_RRR_0_OPCODE_X0 = 22,
+  DBLALIGN2_RRR_0_OPCODE_X1 = 13,
+  DBLALIGN4_RRR_0_OPCODE_X0 = 23,
+  DBLALIGN4_RRR_0_OPCODE_X1 = 14,
+  DBLALIGN6_RRR_0_OPCODE_X0 = 24,
+  DBLALIGN6_RRR_0_OPCODE_X1 = 15,
+  DBLALIGN_RRR_0_OPCODE_X0 = 25,
+  DRAIN_UNARY_OPCODE_X1 = 1,
+  DTLBPR_UNARY_OPCODE_X1 = 2,
+  EXCH4_RRR_0_OPCODE_X1 = 16,
+  EXCH_RRR_0_OPCODE_X1 = 17,
+  FDOUBLE_ADDSUB_RRR_0_OPCODE_X0 = 26,
+  FDOUBLE_ADD_FLAGS_RRR_0_OPCODE_X0 = 27,
+  FDOUBLE_MUL_FLAGS_RRR_0_OPCODE_X0 = 28,
+  FDOUBLE_PACK1_RRR_0_OPCODE_X0 = 29,
+  FDOUBLE_PACK2_RRR_0_OPCODE_X0 = 30,
+  FDOUBLE_SUB_FLAGS_RRR_0_OPCODE_X0 = 31,
+  FDOUBLE_UNPACK_MAX_RRR_0_OPCODE_X0 = 32,
+  FDOUBLE_UNPACK_MIN_RRR_0_OPCODE_X0 = 33,
+  FETCHADD4_RRR_0_OPCODE_X1 = 18,
+  FETCHADDGEZ4_RRR_0_OPCODE_X1 = 19,
+  FETCHADDGEZ_RRR_0_OPCODE_X1 = 20,
+  FETCHADD_RRR_0_OPCODE_X1 = 21,
+  FETCHAND4_RRR_0_OPCODE_X1 = 22,
+  FETCHAND_RRR_0_OPCODE_X1 = 23,
+  FETCHOR4_RRR_0_OPCODE_X1 = 24,
+  FETCHOR_RRR_0_OPCODE_X1 = 25,
+  FINV_UNARY_OPCODE_X1 = 3,
+  FLUSHWB_UNARY_OPCODE_X1 = 4,
+  FLUSH_UNARY_OPCODE_X1 = 5,
+  FNOP_UNARY_OPCODE_X0 = 3,
+  FNOP_UNARY_OPCODE_X1 = 6,
+  FNOP_UNARY_OPCODE_Y0 = 3,
+  FNOP_UNARY_OPCODE_Y1 = 8,
+  FSINGLE_ADD1_RRR_0_OPCODE_X0 = 34,
+  FSINGLE_ADDSUB2_RRR_0_OPCODE_X0 = 35,
+  FSINGLE_MUL1_RRR_0_OPCODE_X0 = 36,
+  FSINGLE_MUL2_RRR_0_OPCODE_X0 = 37,
+  FSINGLE_PACK1_UNARY_OPCODE_X0 = 4,
+  FSINGLE_PACK1_UNARY_OPCODE_Y0 = 4,
+  FSINGLE_PACK2_RRR_0_OPCODE_X0 = 38,
+  FSINGLE_SUB1_RRR_0_OPCODE_X0 = 39,
+  ICOH_UNARY_OPCODE_X1 = 7,
+  ILL_UNARY_OPCODE_X1 = 8,
+  ILL_UNARY_OPCODE_Y1 = 9,
+  IMM8_OPCODE_X0 = 4,
+  IMM8_OPCODE_X1 = 3,
+  INV_UNARY_OPCODE_X1 = 9,
+  IRET_UNARY_OPCODE_X1 = 10,
+  JALRP_UNARY_OPCODE_X1 = 11,
+  JALRP_UNARY_OPCODE_Y1 = 10,
+  JALR_UNARY_OPCODE_X1 = 12,
+  JALR_UNARY_OPCODE_Y1 = 11,
+  JAL_JUMP_OPCODE_X1 = 0,
+  JRP_UNARY_OPCODE_X1 = 13,
+  JRP_UNARY_OPCODE_Y1 = 12,
+  JR_UNARY_OPCODE_X1 = 14,
+  JR_UNARY_OPCODE_Y1 = 13,
+  JUMP_OPCODE_X1 = 4,
+  J_JUMP_OPCODE_X1 = 1,
+  LD1S_ADD_IMM8_OPCODE_X1 = 7,
+  LD1S_OPCODE_Y2 = 0,
+  LD1S_UNARY_OPCODE_X1 = 15,
+  LD1U_ADD_IMM8_OPCODE_X1 = 8,
+  LD1U_OPCODE_Y2 = 1,
+  LD1U_UNARY_OPCODE_X1 = 16,
+  LD2S_ADD_IMM8_OPCODE_X1 = 9,
+  LD2S_OPCODE_Y2 = 2,
+  LD2S_UNARY_OPCODE_X1 = 17,
+  LD2U_ADD_IMM8_OPCODE_X1 = 10,
+  LD2U_OPCODE_Y2 = 3,
+  LD2U_UNARY_OPCODE_X1 = 18,
+  LD4S_ADD_IMM8_OPCODE_X1 = 11,
+  LD4S_OPCODE_Y2 = 1,
+  LD4S_UNARY_OPCODE_X1 = 19,
+  LD4U_ADD_IMM8_OPCODE_X1 = 12,
+  LD4U_OPCODE_Y2 = 2,
+  LD4U_UNARY_OPCODE_X1 = 20,
+  LDNA_UNARY_OPCODE_X1 = 21,
+  LDNT1S_ADD_IMM8_OPCODE_X1 = 13,
+  LDNT1S_UNARY_OPCODE_X1 = 22,
+  LDNT1U_ADD_IMM8_OPCODE_X1 = 14,
+  LDNT1U_UNARY_OPCODE_X1 = 23,
+  LDNT2S_ADD_IMM8_OPCODE_X1 = 15,
+  LDNT2S_UNARY_OPCODE_X1 = 24,
+  LDNT2U_ADD_IMM8_OPCODE_X1 = 16,
+  LDNT2U_UNARY_OPCODE_X1 = 25,
+  LDNT4S_ADD_IMM8_OPCODE_X1 = 17,
+  LDNT4S_UNARY_OPCODE_X1 = 26,
+  LDNT4U_ADD_IMM8_OPCODE_X1 = 18,
+  LDNT4U_UNARY_OPCODE_X1 = 27,
+  LDNT_ADD_IMM8_OPCODE_X1 = 19,
+  LDNT_UNARY_OPCODE_X1 = 28,
+  LD_ADD_IMM8_OPCODE_X1 = 20,
+  LD_OPCODE_Y2 = 3,
+  LD_UNARY_OPCODE_X1 = 29,
+  LNK_UNARY_OPCODE_X1 = 30,
+  LNK_UNARY_OPCODE_Y1 = 14,
+  LWNA_ADD_IMM8_OPCODE_X1 = 21,
+  MFSPR_IMM8_OPCODE_X1 = 22,
+  MF_UNARY_OPCODE_X1 = 31,
+  MM_BF_OPCODE_X0 = 7,
+  MNZ_RRR_0_OPCODE_X0 = 40,
+  MNZ_RRR_0_OPCODE_X1 = 26,
+  MNZ_RRR_4_OPCODE_Y0 = 2,
+  MNZ_RRR_4_OPCODE_Y1 = 2,
+  MODE_OPCODE_YA2 = 1,
+  MODE_OPCODE_YB2 = 2,
+  MODE_OPCODE_YC2 = 3,
+  MTSPR_IMM8_OPCODE_X1 = 23,
+  MULAX_RRR_0_OPCODE_X0 = 41,
+  MULAX_RRR_3_OPCODE_Y0 = 2,
+  MULA_HS_HS_RRR_0_OPCODE_X0 = 42,
+  MULA_HS_HS_RRR_9_OPCODE_Y0 = 0,
+  MULA_HS_HU_RRR_0_OPCODE_X0 = 43,
+  MULA_HS_LS_RRR_0_OPCODE_X0 = 44,
+  MULA_HS_LU_RRR_0_OPCODE_X0 = 45,
+  MULA_HU_HU_RRR_0_OPCODE_X0 = 46,
+  MULA_HU_HU_RRR_9_OPCODE_Y0 = 1,
+  MULA_HU_LS_RRR_0_OPCODE_X0 = 47,
+  MULA_HU_LU_RRR_0_OPCODE_X0 = 48,
+  MULA_LS_LS_RRR_0_OPCODE_X0 = 49,
+  MULA_LS_LS_RRR_9_OPCODE_Y0 = 2,
+  MULA_LS_LU_RRR_0_OPCODE_X0 = 50,
+  MULA_LU_LU_RRR_0_OPCODE_X0 = 51,
+  MULA_LU_LU_RRR_9_OPCODE_Y0 = 3,
+  MULX_RRR_0_OPCODE_X0 = 52,
+  MULX_RRR_3_OPCODE_Y0 = 3,
+  MUL_HS_HS_RRR_0_OPCODE_X0 = 53,
+  MUL_HS_HS_RRR_8_OPCODE_Y0 = 0,
+  MUL_HS_HU_RRR_0_OPCODE_X0 = 54,
+  MUL_HS_LS_RRR_0_OPCODE_X0 = 55,
+  MUL_HS_LU_RRR_0_OPCODE_X0 = 56,
+  MUL_HU_HU_RRR_0_OPCODE_X0 = 57,
+  MUL_HU_HU_RRR_8_OPCODE_Y0 = 1,
+  MUL_HU_LS_RRR_0_OPCODE_X0 = 58,
+  MUL_HU_LU_RRR_0_OPCODE_X0 = 59,
+  MUL_LS_LS_RRR_0_OPCODE_X0 = 60,
+  MUL_LS_LS_RRR_8_OPCODE_Y0 = 2,
+  MUL_LS_LU_RRR_0_OPCODE_X0 = 61,
+  MUL_LU_LU_RRR_0_OPCODE_X0 = 62,
+  MUL_LU_LU_RRR_8_OPCODE_Y0 = 3,
+  MZ_RRR_0_OPCODE_X0 = 63,
+  MZ_RRR_0_OPCODE_X1 = 27,
+  MZ_RRR_4_OPCODE_Y0 = 3,
+  MZ_RRR_4_OPCODE_Y1 = 3,
+  NAP_UNARY_OPCODE_X1 = 32,
+  NOP_UNARY_OPCODE_X0 = 5,
+  NOP_UNARY_OPCODE_X1 = 33,
+  NOP_UNARY_OPCODE_Y0 = 5,
+  NOP_UNARY_OPCODE_Y1 = 15,
+  NOR_RRR_0_OPCODE_X0 = 64,
+  NOR_RRR_0_OPCODE_X1 = 28,
+  NOR_RRR_5_OPCODE_Y0 = 1,
+  NOR_RRR_5_OPCODE_Y1 = 1,
+  ORI_IMM8_OPCODE_X0 = 7,
+  ORI_IMM8_OPCODE_X1 = 24,
+  OR_RRR_0_OPCODE_X0 = 65,
+  OR_RRR_0_OPCODE_X1 = 29,
+  OR_RRR_5_OPCODE_Y0 = 2,
+  OR_RRR_5_OPCODE_Y1 = 2,
+  PCNT_UNARY_OPCODE_X0 = 6,
+  PCNT_UNARY_OPCODE_Y0 = 6,
+  REVBITS_UNARY_OPCODE_X0 = 7,
+  REVBITS_UNARY_OPCODE_Y0 = 7,
+  REVBYTES_UNARY_OPCODE_X0 = 8,
+  REVBYTES_UNARY_OPCODE_Y0 = 8,
+  ROTLI_SHIFT_OPCODE_X0 = 1,
+  ROTLI_SHIFT_OPCODE_X1 = 1,
+  ROTLI_SHIFT_OPCODE_Y0 = 0,
+  ROTLI_SHIFT_OPCODE_Y1 = 0,
+  ROTL_RRR_0_OPCODE_X0 = 66,
+  ROTL_RRR_0_OPCODE_X1 = 30,
+  ROTL_RRR_6_OPCODE_Y0 = 0,
+  ROTL_RRR_6_OPCODE_Y1 = 0,
+  RRR_0_OPCODE_X0 = 5,
+  RRR_0_OPCODE_X1 = 5,
+  RRR_0_OPCODE_Y0 = 5,
+  RRR_0_OPCODE_Y1 = 6,
+  RRR_1_OPCODE_Y0 = 6,
+  RRR_1_OPCODE_Y1 = 7,
+  RRR_2_OPCODE_Y0 = 7,
+  RRR_2_OPCODE_Y1 = 8,
+  RRR_3_OPCODE_Y0 = 8,
+  RRR_3_OPCODE_Y1 = 9,
+  RRR_4_OPCODE_Y0 = 9,
+  RRR_4_OPCODE_Y1 = 10,
+  RRR_5_OPCODE_Y0 = 10,
+  RRR_5_OPCODE_Y1 = 11,
+  RRR_6_OPCODE_Y0 = 11,
+  RRR_6_OPCODE_Y1 = 12,
+  RRR_7_OPCODE_Y0 = 12,
+  RRR_7_OPCODE_Y1 = 13,
+  RRR_8_OPCODE_Y0 = 13,
+  RRR_9_OPCODE_Y0 = 14,
+  SHIFT_OPCODE_X0 = 6,
+  SHIFT_OPCODE_X1 = 6,
+  SHIFT_OPCODE_Y0 = 15,
+  SHIFT_OPCODE_Y1 = 14,
+  SHL16INSLI_OPCODE_X0 = 7,
+  SHL16INSLI_OPCODE_X1 = 7,
+  SHL1ADDX_RRR_0_OPCODE_X0 = 67,
+  SHL1ADDX_RRR_0_OPCODE_X1 = 31,
+  SHL1ADDX_RRR_7_OPCODE_Y0 = 1,
+  SHL1ADDX_RRR_7_OPCODE_Y1 = 1,
+  SHL1ADD_RRR_0_OPCODE_X0 = 68,
+  SHL1ADD_RRR_0_OPCODE_X1 = 32,
+  SHL1ADD_RRR_1_OPCODE_Y0 = 0,
+  SHL1ADD_RRR_1_OPCODE_Y1 = 0,
+  SHL2ADDX_RRR_0_OPCODE_X0 = 69,
+  SHL2ADDX_RRR_0_OPCODE_X1 = 33,
+  SHL2ADDX_RRR_7_OPCODE_Y0 = 2,
+  SHL2ADDX_RRR_7_OPCODE_Y1 = 2,
+  SHL2ADD_RRR_0_OPCODE_X0 = 70,
+  SHL2ADD_RRR_0_OPCODE_X1 = 34,
+  SHL2ADD_RRR_1_OPCODE_Y0 = 1,
+  SHL2ADD_RRR_1_OPCODE_Y1 = 1,
+  SHL3ADDX_RRR_0_OPCODE_X0 = 71,
+  SHL3ADDX_RRR_0_OPCODE_X1 = 35,
+  SHL3ADDX_RRR_7_OPCODE_Y0 = 3,
+  SHL3ADDX_RRR_7_OPCODE_Y1 = 3,
+  SHL3ADD_RRR_0_OPCODE_X0 = 72,
+  SHL3ADD_RRR_0_OPCODE_X1 = 36,
+  SHL3ADD_RRR_1_OPCODE_Y0 = 2,
+  SHL3ADD_RRR_1_OPCODE_Y1 = 2,
+  SHLI_SHIFT_OPCODE_X0 = 2,
+  SHLI_SHIFT_OPCODE_X1 = 2,
+  SHLI_SHIFT_OPCODE_Y0 = 1,
+  SHLI_SHIFT_OPCODE_Y1 = 1,
+  SHLXI_SHIFT_OPCODE_X0 = 3,
+  SHLXI_SHIFT_OPCODE_X1 = 3,
+  SHLX_RRR_0_OPCODE_X0 = 73,
+  SHLX_RRR_0_OPCODE_X1 = 37,
+  SHL_RRR_0_OPCODE_X0 = 74,
+  SHL_RRR_0_OPCODE_X1 = 38,
+  SHL_RRR_6_OPCODE_Y0 = 1,
+  SHL_RRR_6_OPCODE_Y1 = 1,
+  SHRSI_SHIFT_OPCODE_X0 = 4,
+  SHRSI_SHIFT_OPCODE_X1 = 4,
+  SHRSI_SHIFT_OPCODE_Y0 = 2,
+  SHRSI_SHIFT_OPCODE_Y1 = 2,
+  SHRS_RRR_0_OPCODE_X0 = 75,
+  SHRS_RRR_0_OPCODE_X1 = 39,
+  SHRS_RRR_6_OPCODE_Y0 = 2,
+  SHRS_RRR_6_OPCODE_Y1 = 2,
+  SHRUI_SHIFT_OPCODE_X0 = 5,
+  SHRUI_SHIFT_OPCODE_X1 = 5,
+  SHRUI_SHIFT_OPCODE_Y0 = 3,
+  SHRUI_SHIFT_OPCODE_Y1 = 3,
+  SHRUXI_SHIFT_OPCODE_X0 = 6,
+  SHRUXI_SHIFT_OPCODE_X1 = 6,
+  SHRUX_RRR_0_OPCODE_X0 = 76,
+  SHRUX_RRR_0_OPCODE_X1 = 40,
+  SHRU_RRR_0_OPCODE_X0 = 77,
+  SHRU_RRR_0_OPCODE_X1 = 41,
+  SHRU_RRR_6_OPCODE_Y0 = 3,
+  SHRU_RRR_6_OPCODE_Y1 = 3,
+  SHUFFLEBYTES_RRR_0_OPCODE_X0 = 78,
+  ST1_ADD_IMM8_OPCODE_X1 = 25,
+  ST1_OPCODE_Y2 = 0,
+  ST1_RRR_0_OPCODE_X1 = 42,
+  ST2_ADD_IMM8_OPCODE_X1 = 26,
+  ST2_OPCODE_Y2 = 1,
+  ST2_RRR_0_OPCODE_X1 = 43,
+  ST4_ADD_IMM8_OPCODE_X1 = 27,
+  ST4_OPCODE_Y2 = 2,
+  ST4_RRR_0_OPCODE_X1 = 44,
+  STNT1_ADD_IMM8_OPCODE_X1 = 28,
+  STNT1_RRR_0_OPCODE_X1 = 45,
+  STNT2_ADD_IMM8_OPCODE_X1 = 29,
+  STNT2_RRR_0_OPCODE_X1 = 46,
+  STNT4_ADD_IMM8_OPCODE_X1 = 30,
+  STNT4_RRR_0_OPCODE_X1 = 47,
+  STNT_ADD_IMM8_OPCODE_X1 = 31,
+  STNT_RRR_0_OPCODE_X1 = 48,
+  ST_ADD_IMM8_OPCODE_X1 = 32,
+  ST_OPCODE_Y2 = 3,
+  ST_RRR_0_OPCODE_X1 = 49,
+  SUBXSC_RRR_0_OPCODE_X0 = 79,
+  SUBXSC_RRR_0_OPCODE_X1 = 50,
+  SUBX_RRR_0_OPCODE_X0 = 80,
+  SUBX_RRR_0_OPCODE_X1 = 51,
+  SUBX_RRR_0_OPCODE_Y0 = 2,
+  SUBX_RRR_0_OPCODE_Y1 = 2,
+  SUB_RRR_0_OPCODE_X0 = 81,
+  SUB_RRR_0_OPCODE_X1 = 52,
+  SUB_RRR_0_OPCODE_Y0 = 3,
+  SUB_RRR_0_OPCODE_Y1 = 3,
+  SWINT0_UNARY_OPCODE_X1 = 34,
+  SWINT1_UNARY_OPCODE_X1 = 35,
+  SWINT2_UNARY_OPCODE_X1 = 36,
+  SWINT3_UNARY_OPCODE_X1 = 37,
+  TBLIDXB0_UNARY_OPCODE_X0 = 9,
+  TBLIDXB0_UNARY_OPCODE_Y0 = 9,
+  TBLIDXB1_UNARY_OPCODE_X0 = 10,
+  TBLIDXB1_UNARY_OPCODE_Y0 = 10,
+  TBLIDXB2_UNARY_OPCODE_X0 = 11,
+  TBLIDXB2_UNARY_OPCODE_Y0 = 11,
+  TBLIDXB3_UNARY_OPCODE_X0 = 12,
+  TBLIDXB3_UNARY_OPCODE_Y0 = 12,
+  UNARY_RRR_0_OPCODE_X0 = 82,
+  UNARY_RRR_0_OPCODE_X1 = 53,
+  UNARY_RRR_1_OPCODE_Y0 = 3,
+  UNARY_RRR_1_OPCODE_Y1 = 3,
+  V1ADDI_IMM8_OPCODE_X0 = 8,
+  V1ADDI_IMM8_OPCODE_X1 = 33,
+  V1ADDUC_RRR_0_OPCODE_X0 = 83,
+  V1ADDUC_RRR_0_OPCODE_X1 = 54,
+  V1ADD_RRR_0_OPCODE_X0 = 84,
+  V1ADD_RRR_0_OPCODE_X1 = 55,
+  V1ADIFFU_RRR_0_OPCODE_X0 = 85,
+  V1AVGU_RRR_0_OPCODE_X0 = 86,
+  V1CMPEQI_IMM8_OPCODE_X0 = 9,
+  V1CMPEQI_IMM8_OPCODE_X1 = 34,
+  V1CMPEQ_RRR_0_OPCODE_X0 = 87,
+  V1CMPEQ_RRR_0_OPCODE_X1 = 56,
+  V1CMPLES_RRR_0_OPCODE_X0 = 88,
+  V1CMPLES_RRR_0_OPCODE_X1 = 57,
+  V1CMPLEU_RRR_0_OPCODE_X0 = 89,
+  V1CMPLEU_RRR_0_OPCODE_X1 = 58,
+  V1CMPLTSI_IMM8_OPCODE_X0 = 10,
+  V1CMPLTSI_IMM8_OPCODE_X1 = 35,
+  V1CMPLTS_RRR_0_OPCODE_X0 = 90,
+  V1CMPLTS_RRR_0_OPCODE_X1 = 59,
+  V1CMPLTUI_IMM8_OPCODE_X0 = 11,
+  V1CMPLTUI_IMM8_OPCODE_X1 = 36,
+  V1CMPLTU_RRR_0_OPCODE_X0 = 91,
+  V1CMPLTU_RRR_0_OPCODE_X1 = 60,
+  V1CMPNE_RRR_0_OPCODE_X0 = 92,
+  V1CMPNE_RRR_0_OPCODE_X1 = 61,
+  V1DDOTPUA_RRR_0_OPCODE_X0 = 161,
+  V1DDOTPUSA_RRR_0_OPCODE_X0 = 93,
+  V1DDOTPUS_RRR_0_OPCODE_X0 = 94,
+  V1DDOTPU_RRR_0_OPCODE_X0 = 162,
+  V1DOTPA_RRR_0_OPCODE_X0 = 95,
+  V1DOTPUA_RRR_0_OPCODE_X0 = 163,
+  V1DOTPUSA_RRR_0_OPCODE_X0 = 96,
+  V1DOTPUS_RRR_0_OPCODE_X0 = 97,
+  V1DOTPU_RRR_0_OPCODE_X0 = 164,
+  V1DOTP_RRR_0_OPCODE_X0 = 98,
+  V1INT_H_RRR_0_OPCODE_X0 = 99,
+  V1INT_H_RRR_0_OPCODE_X1 = 62,
+  V1INT_L_RRR_0_OPCODE_X0 = 100,
+  V1INT_L_RRR_0_OPCODE_X1 = 63,
+  V1MAXUI_IMM8_OPCODE_X0 = 12,
+  V1MAXUI_IMM8_OPCODE_X1 = 37,
+  V1MAXU_RRR_0_OPCODE_X0 = 101,
+  V1MAXU_RRR_0_OPCODE_X1 = 64,
+  V1MINUI_IMM8_OPCODE_X0 = 13,
+  V1MINUI_IMM8_OPCODE_X1 = 38,
+  V1MINU_RRR_0_OPCODE_X0 = 102,
+  V1MINU_RRR_0_OPCODE_X1 = 65,
+  V1MNZ_RRR_0_OPCODE_X0 = 103,
+  V1MNZ_RRR_0_OPCODE_X1 = 66,
+  V1MULTU_RRR_0_OPCODE_X0 = 104,
+  V1MULUS_RRR_0_OPCODE_X0 = 105,
+  V1MULU_RRR_0_OPCODE_X0 = 106,
+  V1MZ_RRR_0_OPCODE_X0 = 107,
+  V1MZ_RRR_0_OPCODE_X1 = 67,
+  V1SADAU_RRR_0_OPCODE_X0 = 108,
+  V1SADU_RRR_0_OPCODE_X0 = 109,
+  V1SHLI_SHIFT_OPCODE_X0 = 7,
+  V1SHLI_SHIFT_OPCODE_X1 = 7,
+  V1SHL_RRR_0_OPCODE_X0 = 110,
+  V1SHL_RRR_0_OPCODE_X1 = 68,
+  V1SHRSI_SHIFT_OPCODE_X0 = 8,
+  V1SHRSI_SHIFT_OPCODE_X1 = 8,
+  V1SHRS_RRR_0_OPCODE_X0 = 111,
+  V1SHRS_RRR_0_OPCODE_X1 = 69,
+  V1SHRUI_SHIFT_OPCODE_X0 = 9,
+  V1SHRUI_SHIFT_OPCODE_X1 = 9,
+  V1SHRU_RRR_0_OPCODE_X0 = 112,
+  V1SHRU_RRR_0_OPCODE_X1 = 70,
+  V1SUBUC_RRR_0_OPCODE_X0 = 113,
+  V1SUBUC_RRR_0_OPCODE_X1 = 71,
+  V1SUB_RRR_0_OPCODE_X0 = 114,
+  V1SUB_RRR_0_OPCODE_X1 = 72,
+  V2ADDI_IMM8_OPCODE_X0 = 14,
+  V2ADDI_IMM8_OPCODE_X1 = 39,
+  V2ADDSC_RRR_0_OPCODE_X0 = 115,
+  V2ADDSC_RRR_0_OPCODE_X1 = 73,
+  V2ADD_RRR_0_OPCODE_X0 = 116,
+  V2ADD_RRR_0_OPCODE_X1 = 74,
+  V2ADIFFS_RRR_0_OPCODE_X0 = 117,
+  V2AVGS_RRR_0_OPCODE_X0 = 118,
+  V2CMPEQI_IMM8_OPCODE_X0 = 15,
+  V2CMPEQI_IMM8_OPCODE_X1 = 40,
+  V2CMPEQ_RRR_0_OPCODE_X0 = 119,
+  V2CMPEQ_RRR_0_OPCODE_X1 = 75,
+  V2CMPLES_RRR_0_OPCODE_X0 = 120,
+  V2CMPLES_RRR_0_OPCODE_X1 = 76,
+  V2CMPLEU_RRR_0_OPCODE_X0 = 121,
+  V2CMPLEU_RRR_0_OPCODE_X1 = 77,
+  V2CMPLTSI_IMM8_OPCODE_X0 = 16,
+  V2CMPLTSI_IMM8_OPCODE_X1 = 41,
+  V2CMPLTS_RRR_0_OPCODE_X0 = 122,
+  V2CMPLTS_RRR_0_OPCODE_X1 = 78,
+  V2CMPLTUI_IMM8_OPCODE_X0 = 17,
+  V2CMPLTUI_IMM8_OPCODE_X1 = 42,
+  V2CMPLTU_RRR_0_OPCODE_X0 = 123,
+  V2CMPLTU_RRR_0_OPCODE_X1 = 79,
+  V2CMPNE_RRR_0_OPCODE_X0 = 124,
+  V2CMPNE_RRR_0_OPCODE_X1 = 80,
+  V2DOTPA_RRR_0_OPCODE_X0 = 125,
+  V2DOTP_RRR_0_OPCODE_X0 = 126,
+  V2INT_H_RRR_0_OPCODE_X0 = 127,
+  V2INT_H_RRR_0_OPCODE_X1 = 81,
+  V2INT_L_RRR_0_OPCODE_X0 = 128,
+  V2INT_L_RRR_0_OPCODE_X1 = 82,
+  V2MAXSI_IMM8_OPCODE_X0 = 18,
+  V2MAXSI_IMM8_OPCODE_X1 = 43,
+  V2MAXS_RRR_0_OPCODE_X0 = 129,
+  V2MAXS_RRR_0_OPCODE_X1 = 83,
+  V2MINSI_IMM8_OPCODE_X0 = 19,
+  V2MINSI_IMM8_OPCODE_X1 = 44,
+  V2MINS_RRR_0_OPCODE_X0 = 130,
+  V2MINS_RRR_0_OPCODE_X1 = 84,
+  V2MNZ_RRR_0_OPCODE_X0 = 131,
+  V2MNZ_RRR_0_OPCODE_X1 = 85,
+  V2MULFSC_RRR_0_OPCODE_X0 = 132,
+  V2MULS_RRR_0_OPCODE_X0 = 133,
+  V2MULTS_RRR_0_OPCODE_X0 = 134,
+  V2MZ_RRR_0_OPCODE_X0 = 135,
+  V2MZ_RRR_0_OPCODE_X1 = 86,
+  V2PACKH_RRR_0_OPCODE_X0 = 136,
+  V2PACKH_RRR_0_OPCODE_X1 = 87,
+  V2PACKL_RRR_0_OPCODE_X0 = 137,
+  V2PACKL_RRR_0_OPCODE_X1 = 88,
+  V2PACKUC_RRR_0_OPCODE_X0 = 138,
+  V2PACKUC_RRR_0_OPCODE_X1 = 89,
+  V2SADAS_RRR_0_OPCODE_X0 = 139,
+  V2SADAU_RRR_0_OPCODE_X0 = 140,
+  V2SADS_RRR_0_OPCODE_X0 = 141,
+  V2SADU_RRR_0_OPCODE_X0 = 142,
+  V2SHLI_SHIFT_OPCODE_X0 = 10,
+  V2SHLI_SHIFT_OPCODE_X1 = 10,
+  V2SHLSC_RRR_0_OPCODE_X0 = 143,
+  V2SHLSC_RRR_0_OPCODE_X1 = 90,
+  V2SHL_RRR_0_OPCODE_X0 = 144,
+  V2SHL_RRR_0_OPCODE_X1 = 91,
+  V2SHRSI_SHIFT_OPCODE_X0 = 11,
+  V2SHRSI_SHIFT_OPCODE_X1 = 11,
+  V2SHRS_RRR_0_OPCODE_X0 = 145,
+  V2SHRS_RRR_0_OPCODE_X1 = 92,
+  V2SHRUI_SHIFT_OPCODE_X0 = 12,
+  V2SHRUI_SHIFT_OPCODE_X1 = 12,
+  V2SHRU_RRR_0_OPCODE_X0 = 146,
+  V2SHRU_RRR_0_OPCODE_X1 = 93,
+  V2SUBSC_RRR_0_OPCODE_X0 = 147,
+  V2SUBSC_RRR_0_OPCODE_X1 = 94,
+  V2SUB_RRR_0_OPCODE_X0 = 148,
+  V2SUB_RRR_0_OPCODE_X1 = 95,
+  V4ADDSC_RRR_0_OPCODE_X0 = 149,
+  V4ADDSC_RRR_0_OPCODE_X1 = 96,
+  V4ADD_RRR_0_OPCODE_X0 = 150,
+  V4ADD_RRR_0_OPCODE_X1 = 97,
+  V4INT_H_RRR_0_OPCODE_X0 = 151,
+  V4INT_H_RRR_0_OPCODE_X1 = 98,
+  V4INT_L_RRR_0_OPCODE_X0 = 152,
+  V4INT_L_RRR_0_OPCODE_X1 = 99,
+  V4PACKSC_RRR_0_OPCODE_X0 = 153,
+  V4PACKSC_RRR_0_OPCODE_X1 = 100,
+  V4SHLSC_RRR_0_OPCODE_X0 = 154,
+  V4SHLSC_RRR_0_OPCODE_X1 = 101,
+  V4SHL_RRR_0_OPCODE_X0 = 155,
+  V4SHL_RRR_0_OPCODE_X1 = 102,
+  V4SHRS_RRR_0_OPCODE_X0 = 156,
+  V4SHRS_RRR_0_OPCODE_X1 = 103,
+  V4SHRU_RRR_0_OPCODE_X0 = 157,
+  V4SHRU_RRR_0_OPCODE_X1 = 104,
+  V4SUBSC_RRR_0_OPCODE_X0 = 158,
+  V4SUBSC_RRR_0_OPCODE_X1 = 105,
+  V4SUB_RRR_0_OPCODE_X0 = 159,
+  V4SUB_RRR_0_OPCODE_X1 = 106,
+  WH64_UNARY_OPCODE_X1 = 38,
+  XORI_IMM8_OPCODE_X0 = 20,
+  XORI_IMM8_OPCODE_X1 = 45,
+  XOR_RRR_0_OPCODE_X0 = 160,
+  XOR_RRR_0_OPCODE_X1 = 107,
+  XOR_RRR_5_OPCODE_Y0 = 3,
+  XOR_RRR_5_OPCODE_Y1 = 3
+};
+
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* __ARCH_OPCODE_H__ */
diff --git a/arch/tile/include/arch/opcode_tilepro.h b/arch/tile/include/arch/opcode_tilepro.h
new file mode 100644
index 0000000..71b763b
--- /dev/null
+++ b/arch/tile/include/arch/opcode_tilepro.h
@@ -0,0 +1,1471 @@
+/* TILEPro opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
+#ifndef __ARCH_OPCODE_H__
+#define __ARCH_OPCODE_H__
+
+#ifndef __ASSEMBLER__
+
+typedef unsigned long long tilepro_bundle_bits;
+
+/* This is the bit that determines if a bundle is in the Y encoding. */
+#define TILEPRO_BUNDLE_Y_ENCODING_MASK ((tilepro_bundle_bits)1 << 63)
+
+enum
+{
+  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
+  TILEPRO_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
+
+  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
+  TILEPRO_NUM_PIPELINE_ENCODINGS = 5,
+
+  /* Log base 2 of TILEPRO_BUNDLE_SIZE_IN_BYTES. */
+  TILEPRO_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
+
+  /* Instructions take this many bytes. */
+  TILEPRO_BUNDLE_SIZE_IN_BYTES = 1 << TILEPRO_LOG2_BUNDLE_SIZE_IN_BYTES,
+
+  /* Log base 2 of TILEPRO_BUNDLE_ALIGNMENT_IN_BYTES. */
+  TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
+
+  /* Bundles should be aligned modulo this number of bytes. */
+  TILEPRO_BUNDLE_ALIGNMENT_IN_BYTES =
+    (1 << TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
+
+  /* Log base 2 of TILEPRO_SN_INSTRUCTION_SIZE_IN_BYTES. */
+  TILEPRO_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES = 1,
+
+  /* Static network instructions take this many bytes. */
+  TILEPRO_SN_INSTRUCTION_SIZE_IN_BYTES =
+    (1 << TILEPRO_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES),
+
+  /* Number of registers (some are magic, such as network I/O). */
+  TILEPRO_NUM_REGISTERS = 64,
+
+  /* Number of static network registers. */
+  TILEPRO_NUM_SN_REGISTERS = 4
+};
+
+/* Make a few "tile_" variables to simplify common code between
+   architectures.  */
+
+typedef tilepro_bundle_bits tile_bundle_bits;
+#define TILE_BUNDLE_SIZE_IN_BYTES TILEPRO_BUNDLE_SIZE_IN_BYTES
+#define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEPRO_BUNDLE_ALIGNMENT_IN_BYTES
+#define TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES \
+  TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES
+
+/* 64-bit pattern for a { bpt ; nop } bundle. */
+#define TILEPRO_BPT_BUNDLE 0x400b3cae70166000ULL
+
+static __inline unsigned int
+get_BrOff_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_BrOff_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000);
+}
+
+static __inline unsigned int
+get_BrType_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0xf);
+}
+
+static __inline unsigned int
+get_Dest_Imm8_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 43)) & 0x000000c0);
+}
+
+static __inline unsigned int
+get_Dest_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 2)) & 0x3);
+}
+
+static __inline unsigned int
+get_Dest_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Dest_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Imm16_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm16_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xffff);
+}
+
+static __inline unsigned int
+get_Imm8_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0xff);
+}
+
+static __inline unsigned int
+get_Imm8_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0xff);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmOpcodeExtension_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 51)) & 0x7f);
+}
+
+static __inline unsigned int
+get_ImmRROpcodeExtension_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 8)) & 0x3);
+}
+
+static __inline unsigned int
+get_JOffLong_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x18000000);
+}
+
+static __inline unsigned int
+get_JOff_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x00007fff) |
+         (((unsigned int)(n >> 20)) & 0x00018000) |
+         (((unsigned int)(n >> 14)) & 0x001e0000) |
+         (((unsigned int)(n >> 16)) & 0x07e00000) |
+         (((unsigned int)(n >> 31)) & 0x08000000);
+}
+
+static __inline unsigned int
+get_MF_Imm15_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x00003fff) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_MMEnd_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMEnd_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 23)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MMStart_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 54)) & 0x1f);
+}
+
+static __inline unsigned int
+get_MT_Imm15_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 31)) & 0x0000003f) |
+         (((unsigned int)(n >> 37)) & 0x00003fc0) |
+         (((unsigned int)(n >> 44)) & 0x00004000);
+}
+
+static __inline unsigned int
+get_Mode(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 63)) & 0x1);
+}
+
+static __inline unsigned int
+get_NoRegOpcodeExtension_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 10)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Opcode_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 28)) & 0x7);
+}
+
+static __inline unsigned int
+get_Opcode_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 59)) & 0xf);
+}
+
+static __inline unsigned int
+get_Opcode_Y2(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 56)) & 0x7);
+}
+
+static __inline unsigned int
+get_RROpcodeExtension_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 4)) & 0xf);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x1ff);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 18)) & 0x3);
+}
+
+static __inline unsigned int
+get_RRROpcodeExtension_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 49)) & 0x3);
+}
+
+static __inline unsigned int
+get_RouteOpcodeExtension_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_S_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 27)) & 0x1);
+}
+
+static __inline unsigned int
+get_S_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 58)) & 0x1);
+}
+
+static __inline unsigned int
+get_ShAmt_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_ShAmt_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_SrcA_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 6)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 37)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcA_Y2(tilepro_bundle_bits n)
+{
+  return (((n >> 26)) & 0x00000001) |
+         (((unsigned int)(n >> 50)) & 0x0000003e);
+}
+
+static __inline unsigned int
+get_SrcBDest_Y2(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 20)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x3f);
+}
+
+static __inline unsigned int
+get_SrcB_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x3f);
+}
+
+static __inline unsigned int
+get_Src_SN(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 0)) & 0x3);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 12)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnOpcodeExtension_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 43)) & 0x1f);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_X1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x3ff);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y0(tilepro_bundle_bits num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((n >> 17)) & 0x7);
+}
+
+static __inline unsigned int
+get_UnShOpcodeExtension_Y1(tilepro_bundle_bits n)
+{
+  return (((unsigned int)(n >> 48)) & 0x7);
+}
+
+
+static __inline int
+sign_extend(int n, int num_bits)
+{
+  int shift = (int)(sizeof(int) * 8 - num_bits);
+  return (n << shift) >> shift;
+}
+
+
+
+static __inline tilepro_bundle_bits
+create_BrOff_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_BrOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tilepro_bundle_bits)(n & 0x00018000)) << 20);
+}
+
+static __inline tilepro_bundle_bits
+create_BrType_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xf)) << 31);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tilepro_bundle_bits)(n & 0x000000c0)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 2);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_Dest_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 31);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm16_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xffff) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm16_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xffff)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm8_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm8_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm8_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm8_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xff) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_Imm8_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xff)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_ImmOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7f) << 20);
+}
+
+static __inline tilepro_bundle_bits
+create_ImmOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x7f)) << 51);
+}
+
+static __inline tilepro_bundle_bits
+create_ImmRROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 8);
+}
+
+static __inline tilepro_bundle_bits
+create_JOffLong_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tilepro_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tilepro_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tilepro_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tilepro_bundle_bits)(n & 0x18000000)) << 31);
+}
+
+static __inline tilepro_bundle_bits
+create_JOff_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x00007fff)) << 43) |
+         (((tilepro_bundle_bits)(n & 0x00018000)) << 20) |
+         (((tilepro_bundle_bits)(n & 0x001e0000)) << 14) |
+         (((tilepro_bundle_bits)(n & 0x07e00000)) << 16) |
+         (((tilepro_bundle_bits)(n & 0x08000000)) << 31);
+}
+
+static __inline tilepro_bundle_bits
+create_MF_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x00003fff)) << 37) |
+         (((tilepro_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tilepro_bundle_bits
+create_MMEnd_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 18);
+}
+
+static __inline tilepro_bundle_bits
+create_MMEnd_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 49);
+}
+
+static __inline tilepro_bundle_bits
+create_MMStart_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 23);
+}
+
+static __inline tilepro_bundle_bits
+create_MMStart_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 54);
+}
+
+static __inline tilepro_bundle_bits
+create_MT_Imm15_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x0000003f)) << 31) |
+         (((tilepro_bundle_bits)(n & 0x00003fc0)) << 37) |
+         (((tilepro_bundle_bits)(n & 0x00004000)) << 44);
+}
+
+static __inline tilepro_bundle_bits
+create_Mode(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1)) << 63);
+}
+
+static __inline tilepro_bundle_bits
+create_NoRegOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 10);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 28);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 27);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0xf)) << 59);
+}
+
+static __inline tilepro_bundle_bits
+create_Opcode_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x7)) << 56);
+}
+
+static __inline tilepro_bundle_bits
+create_RROpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0xf) << 4);
+}
+
+static __inline tilepro_bundle_bits
+create_RRROpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1ff) << 18);
+}
+
+static __inline tilepro_bundle_bits
+create_RRROpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1ff)) << 49);
+}
+
+static __inline tilepro_bundle_bits
+create_RRROpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 18);
+}
+
+static __inline tilepro_bundle_bits
+create_RRROpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3)) << 49);
+}
+
+static __inline tilepro_bundle_bits
+create_RouteOpcodeExtension_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_S_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1) << 27);
+}
+
+static __inline tilepro_bundle_bits
+create_S_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1)) << 58);
+}
+
+static __inline tilepro_bundle_bits
+create_ShAmt_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_ShAmt_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_ShAmt_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_ShAmt_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcA_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcA_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcA_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 6);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcA_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 37);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcA_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x00000001) << 26) |
+         (((tilepro_bundle_bits)(n & 0x0000003e)) << 50);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcBDest_Y2(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 20);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcB_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcB_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcB_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_SrcB_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_Src_SN(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3) << 0);
+}
+
+static __inline tilepro_bundle_bits
+create_UnOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_UnOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_UnOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x1f) << 12);
+}
+
+static __inline tilepro_bundle_bits
+create_UnOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x1f)) << 43);
+}
+
+static __inline tilepro_bundle_bits
+create_UnShOpcodeExtension_X0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x3ff) << 17);
+}
+
+static __inline tilepro_bundle_bits
+create_UnShOpcodeExtension_X1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x3ff)) << 48);
+}
+
+static __inline tilepro_bundle_bits
+create_UnShOpcodeExtension_Y0(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return ((n & 0x7) << 17);
+}
+
+static __inline tilepro_bundle_bits
+create_UnShOpcodeExtension_Y1(int num)
+{
+  const unsigned int n = (unsigned int)num;
+  return (((tilepro_bundle_bits)(n & 0x7)) << 48);
+}
+
+
+enum
+{
+  ADDBS_U_SPECIAL_0_OPCODE_X0 = 98,
+  ADDBS_U_SPECIAL_0_OPCODE_X1 = 68,
+  ADDB_SPECIAL_0_OPCODE_X0 = 1,
+  ADDB_SPECIAL_0_OPCODE_X1 = 1,
+  ADDHS_SPECIAL_0_OPCODE_X0 = 99,
+  ADDHS_SPECIAL_0_OPCODE_X1 = 69,
+  ADDH_SPECIAL_0_OPCODE_X0 = 2,
+  ADDH_SPECIAL_0_OPCODE_X1 = 2,
+  ADDIB_IMM_0_OPCODE_X0 = 1,
+  ADDIB_IMM_0_OPCODE_X1 = 1,
+  ADDIH_IMM_0_OPCODE_X0 = 2,
+  ADDIH_IMM_0_OPCODE_X1 = 2,
+  ADDI_IMM_0_OPCODE_X0 = 3,
+  ADDI_IMM_0_OPCODE_X1 = 3,
+  ADDI_IMM_1_OPCODE_SN = 1,
+  ADDI_OPCODE_Y0 = 9,
+  ADDI_OPCODE_Y1 = 7,
+  ADDLIS_OPCODE_X0 = 1,
+  ADDLIS_OPCODE_X1 = 2,
+  ADDLI_OPCODE_X0 = 2,
+  ADDLI_OPCODE_X1 = 3,
+  ADDS_SPECIAL_0_OPCODE_X0 = 96,
+  ADDS_SPECIAL_0_OPCODE_X1 = 66,
+  ADD_SPECIAL_0_OPCODE_X0 = 3,
+  ADD_SPECIAL_0_OPCODE_X1 = 3,
+  ADD_SPECIAL_0_OPCODE_Y0 = 0,
+  ADD_SPECIAL_0_OPCODE_Y1 = 0,
+  ADIFFB_U_SPECIAL_0_OPCODE_X0 = 4,
+  ADIFFH_SPECIAL_0_OPCODE_X0 = 5,
+  ANDI_IMM_0_OPCODE_X0 = 1,
+  ANDI_IMM_0_OPCODE_X1 = 4,
+  ANDI_OPCODE_Y0 = 10,
+  ANDI_OPCODE_Y1 = 8,
+  AND_SPECIAL_0_OPCODE_X0 = 6,
+  AND_SPECIAL_0_OPCODE_X1 = 4,
+  AND_SPECIAL_2_OPCODE_Y0 = 0,
+  AND_SPECIAL_2_OPCODE_Y1 = 0,
+  AULI_OPCODE_X0 = 3,
+  AULI_OPCODE_X1 = 4,
+  AVGB_U_SPECIAL_0_OPCODE_X0 = 7,
+  AVGH_SPECIAL_0_OPCODE_X0 = 8,
+  BBNST_BRANCH_OPCODE_X1 = 15,
+  BBNS_BRANCH_OPCODE_X1 = 14,
+  BBNS_OPCODE_SN = 63,
+  BBST_BRANCH_OPCODE_X1 = 13,
+  BBS_BRANCH_OPCODE_X1 = 12,
+  BBS_OPCODE_SN = 62,
+  BGEZT_BRANCH_OPCODE_X1 = 7,
+  BGEZ_BRANCH_OPCODE_X1 = 6,
+  BGEZ_OPCODE_SN = 61,
+  BGZT_BRANCH_OPCODE_X1 = 5,
+  BGZ_BRANCH_OPCODE_X1 = 4,
+  BGZ_OPCODE_SN = 58,
+  BITX_UN_0_SHUN_0_OPCODE_X0 = 1,
+  BITX_UN_0_SHUN_0_OPCODE_Y0 = 1,
+  BLEZT_BRANCH_OPCODE_X1 = 11,
+  BLEZ_BRANCH_OPCODE_X1 = 10,
+  BLEZ_OPCODE_SN = 59,
+  BLZT_BRANCH_OPCODE_X1 = 9,
+  BLZ_BRANCH_OPCODE_X1 = 8,
+  BLZ_OPCODE_SN = 60,
+  BNZT_BRANCH_OPCODE_X1 = 3,
+  BNZ_BRANCH_OPCODE_X1 = 2,
+  BNZ_OPCODE_SN = 57,
+  BPT_NOREG_RR_IMM_0_OPCODE_SN = 1,
+  BRANCH_OPCODE_X1 = 5,
+  BYTEX_UN_0_SHUN_0_OPCODE_X0 = 2,
+  BYTEX_UN_0_SHUN_0_OPCODE_Y0 = 2,
+  BZT_BRANCH_OPCODE_X1 = 1,
+  BZ_BRANCH_OPCODE_X1 = 0,
+  BZ_OPCODE_SN = 56,
+  CLZ_UN_0_SHUN_0_OPCODE_X0 = 3,
+  CLZ_UN_0_SHUN_0_OPCODE_Y0 = 3,
+  CRC32_32_SPECIAL_0_OPCODE_X0 = 9,
+  CRC32_8_SPECIAL_0_OPCODE_X0 = 10,
+  CTZ_UN_0_SHUN_0_OPCODE_X0 = 4,
+  CTZ_UN_0_SHUN_0_OPCODE_Y0 = 4,
+  DRAIN_UN_0_SHUN_0_OPCODE_X1 = 1,
+  DTLBPR_UN_0_SHUN_0_OPCODE_X1 = 2,
+  DWORD_ALIGN_SPECIAL_0_OPCODE_X0 = 95,
+  FINV_UN_0_SHUN_0_OPCODE_X1 = 3,
+  FLUSH_UN_0_SHUN_0_OPCODE_X1 = 4,
+  FNOP_NOREG_RR_IMM_0_OPCODE_SN = 3,
+  FNOP_UN_0_SHUN_0_OPCODE_X0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_X1 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y0 = 5,
+  FNOP_UN_0_SHUN_0_OPCODE_Y1 = 1,
+  HALT_NOREG_RR_IMM_0_OPCODE_SN = 0,
+  ICOH_UN_0_SHUN_0_OPCODE_X1 = 6,
+  ILL_UN_0_SHUN_0_OPCODE_X1 = 7,
+  ILL_UN_0_SHUN_0_OPCODE_Y1 = 2,
+  IMM_0_OPCODE_SN = 0,
+  IMM_0_OPCODE_X0 = 4,
+  IMM_0_OPCODE_X1 = 6,
+  IMM_1_OPCODE_SN = 1,
+  IMM_OPCODE_0_X0 = 5,
+  INTHB_SPECIAL_0_OPCODE_X0 = 11,
+  INTHB_SPECIAL_0_OPCODE_X1 = 5,
+  INTHH_SPECIAL_0_OPCODE_X0 = 12,
+  INTHH_SPECIAL_0_OPCODE_X1 = 6,
+  INTLB_SPECIAL_0_OPCODE_X0 = 13,
+  INTLB_SPECIAL_0_OPCODE_X1 = 7,
+  INTLH_SPECIAL_0_OPCODE_X0 = 14,
+  INTLH_SPECIAL_0_OPCODE_X1 = 8,
+  INV_UN_0_SHUN_0_OPCODE_X1 = 8,
+  IRET_UN_0_SHUN_0_OPCODE_X1 = 9,
+  JALB_OPCODE_X1 = 13,
+  JALF_OPCODE_X1 = 12,
+  JALRP_SPECIAL_0_OPCODE_X1 = 9,
+  JALRR_IMM_1_OPCODE_SN = 3,
+  JALR_RR_IMM_0_OPCODE_SN = 5,
+  JALR_SPECIAL_0_OPCODE_X1 = 10,
+  JB_OPCODE_X1 = 11,
+  JF_OPCODE_X1 = 10,
+  JRP_SPECIAL_0_OPCODE_X1 = 11,
+  JRR_IMM_1_OPCODE_SN = 2,
+  JR_RR_IMM_0_OPCODE_SN = 4,
+  JR_SPECIAL_0_OPCODE_X1 = 12,
+  LBADD_IMM_0_OPCODE_X1 = 22,
+  LBADD_U_IMM_0_OPCODE_X1 = 23,
+  LB_OPCODE_Y2 = 0,
+  LB_UN_0_SHUN_0_OPCODE_X1 = 10,
+  LB_U_OPCODE_Y2 = 1,
+  LB_U_UN_0_SHUN_0_OPCODE_X1 = 11,
+  LHADD_IMM_0_OPCODE_X1 = 24,
+  LHADD_U_IMM_0_OPCODE_X1 = 25,
+  LH_OPCODE_Y2 = 2,
+  LH_UN_0_SHUN_0_OPCODE_X1 = 12,
+  LH_U_OPCODE_Y2 = 3,
+  LH_U_UN_0_SHUN_0_OPCODE_X1 = 13,
+  LNK_SPECIAL_0_OPCODE_X1 = 13,
+  LWADD_IMM_0_OPCODE_X1 = 26,
+  LWADD_NA_IMM_0_OPCODE_X1 = 27,
+  LW_NA_UN_0_SHUN_0_OPCODE_X1 = 24,
+  LW_OPCODE_Y2 = 4,
+  LW_UN_0_SHUN_0_OPCODE_X1 = 14,
+  MAXB_U_SPECIAL_0_OPCODE_X0 = 15,
+  MAXB_U_SPECIAL_0_OPCODE_X1 = 14,
+  MAXH_SPECIAL_0_OPCODE_X0 = 16,
+  MAXH_SPECIAL_0_OPCODE_X1 = 15,
+  MAXIB_U_IMM_0_OPCODE_X0 = 4,
+  MAXIB_U_IMM_0_OPCODE_X1 = 5,
+  MAXIH_IMM_0_OPCODE_X0 = 5,
+  MAXIH_IMM_0_OPCODE_X1 = 6,
+  MFSPR_IMM_0_OPCODE_X1 = 7,
+  MF_UN_0_SHUN_0_OPCODE_X1 = 15,
+  MINB_U_SPECIAL_0_OPCODE_X0 = 17,
+  MINB_U_SPECIAL_0_OPCODE_X1 = 16,
+  MINH_SPECIAL_0_OPCODE_X0 = 18,
+  MINH_SPECIAL_0_OPCODE_X1 = 17,
+  MINIB_U_IMM_0_OPCODE_X0 = 6,
+  MINIB_U_IMM_0_OPCODE_X1 = 8,
+  MINIH_IMM_0_OPCODE_X0 = 7,
+  MINIH_IMM_0_OPCODE_X1 = 9,
+  MM_OPCODE_X0 = 6,
+  MM_OPCODE_X1 = 7,
+  MNZB_SPECIAL_0_OPCODE_X0 = 19,
+  MNZB_SPECIAL_0_OPCODE_X1 = 18,
+  MNZH_SPECIAL_0_OPCODE_X0 = 20,
+  MNZH_SPECIAL_0_OPCODE_X1 = 19,
+  MNZ_SPECIAL_0_OPCODE_X0 = 21,
+  MNZ_SPECIAL_0_OPCODE_X1 = 20,
+  MNZ_SPECIAL_1_OPCODE_Y0 = 0,
+  MNZ_SPECIAL_1_OPCODE_Y1 = 1,
+  MOVEI_IMM_1_OPCODE_SN = 0,
+  MOVE_RR_IMM_0_OPCODE_SN = 8,
+  MTSPR_IMM_0_OPCODE_X1 = 10,
+  MULHHA_SS_SPECIAL_0_OPCODE_X0 = 22,
+  MULHHA_SS_SPECIAL_7_OPCODE_Y0 = 0,
+  MULHHA_SU_SPECIAL_0_OPCODE_X0 = 23,
+  MULHHA_UU_SPECIAL_0_OPCODE_X0 = 24,
+  MULHHA_UU_SPECIAL_7_OPCODE_Y0 = 1,
+  MULHHSA_UU_SPECIAL_0_OPCODE_X0 = 25,
+  MULHH_SS_SPECIAL_0_OPCODE_X0 = 26,
+  MULHH_SS_SPECIAL_6_OPCODE_Y0 = 0,
+  MULHH_SU_SPECIAL_0_OPCODE_X0 = 27,
+  MULHH_UU_SPECIAL_0_OPCODE_X0 = 28,
+  MULHH_UU_SPECIAL_6_OPCODE_Y0 = 1,
+  MULHLA_SS_SPECIAL_0_OPCODE_X0 = 29,
+  MULHLA_SU_SPECIAL_0_OPCODE_X0 = 30,
+  MULHLA_US_SPECIAL_0_OPCODE_X0 = 31,
+  MULHLA_UU_SPECIAL_0_OPCODE_X0 = 32,
+  MULHLSA_UU_SPECIAL_0_OPCODE_X0 = 33,
+  MULHLSA_UU_SPECIAL_5_OPCODE_Y0 = 0,
+  MULHL_SS_SPECIAL_0_OPCODE_X0 = 34,
+  MULHL_SU_SPECIAL_0_OPCODE_X0 = 35,
+  MULHL_US_SPECIAL_0_OPCODE_X0 = 36,
+  MULHL_UU_SPECIAL_0_OPCODE_X0 = 37,
+  MULLLA_SS_SPECIAL_0_OPCODE_X0 = 38,
+  MULLLA_SS_SPECIAL_7_OPCODE_Y0 = 2,
+  MULLLA_SU_SPECIAL_0_OPCODE_X0 = 39,
+  MULLLA_UU_SPECIAL_0_OPCODE_X0 = 40,
+  MULLLA_UU_SPECIAL_7_OPCODE_Y0 = 3,
+  MULLLSA_UU_SPECIAL_0_OPCODE_X0 = 41,
+  MULLL_SS_SPECIAL_0_OPCODE_X0 = 42,
+  MULLL_SS_SPECIAL_6_OPCODE_Y0 = 2,
+  MULLL_SU_SPECIAL_0_OPCODE_X0 = 43,
+  MULLL_UU_SPECIAL_0_OPCODE_X0 = 44,
+  MULLL_UU_SPECIAL_6_OPCODE_Y0 = 3,
+  MVNZ_SPECIAL_0_OPCODE_X0 = 45,
+  MVNZ_SPECIAL_1_OPCODE_Y0 = 1,
+  MVZ_SPECIAL_0_OPCODE_X0 = 46,
+  MVZ_SPECIAL_1_OPCODE_Y0 = 2,
+  MZB_SPECIAL_0_OPCODE_X0 = 47,
+  MZB_SPECIAL_0_OPCODE_X1 = 21,
+  MZH_SPECIAL_0_OPCODE_X0 = 48,
+  MZH_SPECIAL_0_OPCODE_X1 = 22,
+  MZ_SPECIAL_0_OPCODE_X0 = 49,
+  MZ_SPECIAL_0_OPCODE_X1 = 23,
+  MZ_SPECIAL_1_OPCODE_Y0 = 3,
+  MZ_SPECIAL_1_OPCODE_Y1 = 2,
+  NAP_UN_0_SHUN_0_OPCODE_X1 = 16,
+  NOP_NOREG_RR_IMM_0_OPCODE_SN = 2,
+  NOP_UN_0_SHUN_0_OPCODE_X0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_X1 = 17,
+  NOP_UN_0_SHUN_0_OPCODE_Y0 = 6,
+  NOP_UN_0_SHUN_0_OPCODE_Y1 = 3,
+  NOREG_RR_IMM_0_OPCODE_SN = 0,
+  NOR_SPECIAL_0_OPCODE_X0 = 50,
+  NOR_SPECIAL_0_OPCODE_X1 = 24,
+  NOR_SPECIAL_2_OPCODE_Y0 = 1,
+  NOR_SPECIAL_2_OPCODE_Y1 = 1,
+  ORI_IMM_0_OPCODE_X0 = 8,
+  ORI_IMM_0_OPCODE_X1 = 11,
+  ORI_OPCODE_Y0 = 11,
+  ORI_OPCODE_Y1 = 9,
+  OR_SPECIAL_0_OPCODE_X0 = 51,
+  OR_SPECIAL_0_OPCODE_X1 = 25,
+  OR_SPECIAL_2_OPCODE_Y0 = 2,
+  OR_SPECIAL_2_OPCODE_Y1 = 2,
+  PACKBS_U_SPECIAL_0_OPCODE_X0 = 103,
+  PACKBS_U_SPECIAL_0_OPCODE_X1 = 73,
+  PACKHB_SPECIAL_0_OPCODE_X0 = 52,
+  PACKHB_SPECIAL_0_OPCODE_X1 = 26,
+  PACKHS_SPECIAL_0_OPCODE_X0 = 102,
+  PACKHS_SPECIAL_0_OPCODE_X1 = 72,
+  PACKLB_SPECIAL_0_OPCODE_X0 = 53,
+  PACKLB_SPECIAL_0_OPCODE_X1 = 27,
+  PCNT_UN_0_SHUN_0_OPCODE_X0 = 7,
+  PCNT_UN_0_SHUN_0_OPCODE_Y0 = 7,
+  RLI_SHUN_0_OPCODE_X0 = 1,
+  RLI_SHUN_0_OPCODE_X1 = 1,
+  RLI_SHUN_0_OPCODE_Y0 = 1,
+  RLI_SHUN_0_OPCODE_Y1 = 1,
+  RL_SPECIAL_0_OPCODE_X0 = 54,
+  RL_SPECIAL_0_OPCODE_X1 = 28,
+  RL_SPECIAL_3_OPCODE_Y0 = 0,
+  RL_SPECIAL_3_OPCODE_Y1 = 0,
+  RR_IMM_0_OPCODE_SN = 0,
+  S1A_SPECIAL_0_OPCODE_X0 = 55,
+  S1A_SPECIAL_0_OPCODE_X1 = 29,
+  S1A_SPECIAL_0_OPCODE_Y0 = 1,
+  S1A_SPECIAL_0_OPCODE_Y1 = 1,
+  S2A_SPECIAL_0_OPCODE_X0 = 56,
+  S2A_SPECIAL_0_OPCODE_X1 = 30,
+  S2A_SPECIAL_0_OPCODE_Y0 = 2,
+  S2A_SPECIAL_0_OPCODE_Y1 = 2,
+  S3A_SPECIAL_0_OPCODE_X0 = 57,
+  S3A_SPECIAL_0_OPCODE_X1 = 31,
+  S3A_SPECIAL_5_OPCODE_Y0 = 1,
+  S3A_SPECIAL_5_OPCODE_Y1 = 1,
+  SADAB_U_SPECIAL_0_OPCODE_X0 = 58,
+  SADAH_SPECIAL_0_OPCODE_X0 = 59,
+  SADAH_U_SPECIAL_0_OPCODE_X0 = 60,
+  SADB_U_SPECIAL_0_OPCODE_X0 = 61,
+  SADH_SPECIAL_0_OPCODE_X0 = 62,
+  SADH_U_SPECIAL_0_OPCODE_X0 = 63,
+  SBADD_IMM_0_OPCODE_X1 = 28,
+  SB_OPCODE_Y2 = 5,
+  SB_SPECIAL_0_OPCODE_X1 = 32,
+  SEQB_SPECIAL_0_OPCODE_X0 = 64,
+  SEQB_SPECIAL_0_OPCODE_X1 = 33,
+  SEQH_SPECIAL_0_OPCODE_X0 = 65,
+  SEQH_SPECIAL_0_OPCODE_X1 = 34,
+  SEQIB_IMM_0_OPCODE_X0 = 9,
+  SEQIB_IMM_0_OPCODE_X1 = 12,
+  SEQIH_IMM_0_OPCODE_X0 = 10,
+  SEQIH_IMM_0_OPCODE_X1 = 13,
+  SEQI_IMM_0_OPCODE_X0 = 11,
+  SEQI_IMM_0_OPCODE_X1 = 14,
+  SEQI_OPCODE_Y0 = 12,
+  SEQI_OPCODE_Y1 = 10,
+  SEQ_SPECIAL_0_OPCODE_X0 = 66,
+  SEQ_SPECIAL_0_OPCODE_X1 = 35,
+  SEQ_SPECIAL_5_OPCODE_Y0 = 2,
+  SEQ_SPECIAL_5_OPCODE_Y1 = 2,
+  SHADD_IMM_0_OPCODE_X1 = 29,
+  SHL8II_IMM_0_OPCODE_SN = 3,
+  SHLB_SPECIAL_0_OPCODE_X0 = 67,
+  SHLB_SPECIAL_0_OPCODE_X1 = 36,
+  SHLH_SPECIAL_0_OPCODE_X0 = 68,
+  SHLH_SPECIAL_0_OPCODE_X1 = 37,
+  SHLIB_SHUN_0_OPCODE_X0 = 2,
+  SHLIB_SHUN_0_OPCODE_X1 = 2,
+  SHLIH_SHUN_0_OPCODE_X0 = 3,
+  SHLIH_SHUN_0_OPCODE_X1 = 3,
+  SHLI_SHUN_0_OPCODE_X0 = 4,
+  SHLI_SHUN_0_OPCODE_X1 = 4,
+  SHLI_SHUN_0_OPCODE_Y0 = 2,
+  SHLI_SHUN_0_OPCODE_Y1 = 2,
+  SHL_SPECIAL_0_OPCODE_X0 = 69,
+  SHL_SPECIAL_0_OPCODE_X1 = 38,
+  SHL_SPECIAL_3_OPCODE_Y0 = 1,
+  SHL_SPECIAL_3_OPCODE_Y1 = 1,
+  SHR1_RR_IMM_0_OPCODE_SN = 9,
+  SHRB_SPECIAL_0_OPCODE_X0 = 70,
+  SHRB_SPECIAL_0_OPCODE_X1 = 39,
+  SHRH_SPECIAL_0_OPCODE_X0 = 71,
+  SHRH_SPECIAL_0_OPCODE_X1 = 40,
+  SHRIB_SHUN_0_OPCODE_X0 = 5,
+  SHRIB_SHUN_0_OPCODE_X1 = 5,
+  SHRIH_SHUN_0_OPCODE_X0 = 6,
+  SHRIH_SHUN_0_OPCODE_X1 = 6,
+  SHRI_SHUN_0_OPCODE_X0 = 7,
+  SHRI_SHUN_0_OPCODE_X1 = 7,
+  SHRI_SHUN_0_OPCODE_Y0 = 3,
+  SHRI_SHUN_0_OPCODE_Y1 = 3,
+  SHR_SPECIAL_0_OPCODE_X0 = 72,
+  SHR_SPECIAL_0_OPCODE_X1 = 41,
+  SHR_SPECIAL_3_OPCODE_Y0 = 2,
+  SHR_SPECIAL_3_OPCODE_Y1 = 2,
+  SHUN_0_OPCODE_X0 = 7,
+  SHUN_0_OPCODE_X1 = 8,
+  SHUN_0_OPCODE_Y0 = 13,
+  SHUN_0_OPCODE_Y1 = 11,
+  SH_OPCODE_Y2 = 6,
+  SH_SPECIAL_0_OPCODE_X1 = 42,
+  SLTB_SPECIAL_0_OPCODE_X0 = 73,
+  SLTB_SPECIAL_0_OPCODE_X1 = 43,
+  SLTB_U_SPECIAL_0_OPCODE_X0 = 74,
+  SLTB_U_SPECIAL_0_OPCODE_X1 = 44,
+  SLTEB_SPECIAL_0_OPCODE_X0 = 75,
+  SLTEB_SPECIAL_0_OPCODE_X1 = 45,
+  SLTEB_U_SPECIAL_0_OPCODE_X0 = 76,
+  SLTEB_U_SPECIAL_0_OPCODE_X1 = 46,
+  SLTEH_SPECIAL_0_OPCODE_X0 = 77,
+  SLTEH_SPECIAL_0_OPCODE_X1 = 47,
+  SLTEH_U_SPECIAL_0_OPCODE_X0 = 78,
+  SLTEH_U_SPECIAL_0_OPCODE_X1 = 48,
+  SLTE_SPECIAL_0_OPCODE_X0 = 79,
+  SLTE_SPECIAL_0_OPCODE_X1 = 49,
+  SLTE_SPECIAL_4_OPCODE_Y0 = 0,
+  SLTE_SPECIAL_4_OPCODE_Y1 = 0,
+  SLTE_U_SPECIAL_0_OPCODE_X0 = 80,
+  SLTE_U_SPECIAL_0_OPCODE_X1 = 50,
+  SLTE_U_SPECIAL_4_OPCODE_Y0 = 1,
+  SLTE_U_SPECIAL_4_OPCODE_Y1 = 1,
+  SLTH_SPECIAL_0_OPCODE_X0 = 81,
+  SLTH_SPECIAL_0_OPCODE_X1 = 51,
+  SLTH_U_SPECIAL_0_OPCODE_X0 = 82,
+  SLTH_U_SPECIAL_0_OPCODE_X1 = 52,
+  SLTIB_IMM_0_OPCODE_X0 = 12,
+  SLTIB_IMM_0_OPCODE_X1 = 15,
+  SLTIB_U_IMM_0_OPCODE_X0 = 13,
+  SLTIB_U_IMM_0_OPCODE_X1 = 16,
+  SLTIH_IMM_0_OPCODE_X0 = 14,
+  SLTIH_IMM_0_OPCODE_X1 = 17,
+  SLTIH_U_IMM_0_OPCODE_X0 = 15,
+  SLTIH_U_IMM_0_OPCODE_X1 = 18,
+  SLTI_IMM_0_OPCODE_X0 = 16,
+  SLTI_IMM_0_OPCODE_X1 = 19,
+  SLTI_OPCODE_Y0 = 14,
+  SLTI_OPCODE_Y1 = 12,
+  SLTI_U_IMM_0_OPCODE_X0 = 17,
+  SLTI_U_IMM_0_OPCODE_X1 = 20,
+  SLTI_U_OPCODE_Y0 = 15,
+  SLTI_U_OPCODE_Y1 = 13,
+  SLT_SPECIAL_0_OPCODE_X0 = 83,
+  SLT_SPECIAL_0_OPCODE_X1 = 53,
+  SLT_SPECIAL_4_OPCODE_Y0 = 2,
+  SLT_SPECIAL_4_OPCODE_Y1 = 2,
+  SLT_U_SPECIAL_0_OPCODE_X0 = 84,
+  SLT_U_SPECIAL_0_OPCODE_X1 = 54,
+  SLT_U_SPECIAL_4_OPCODE_Y0 = 3,
+  SLT_U_SPECIAL_4_OPCODE_Y1 = 3,
+  SNEB_SPECIAL_0_OPCODE_X0 = 85,
+  SNEB_SPECIAL_0_OPCODE_X1 = 55,
+  SNEH_SPECIAL_0_OPCODE_X0 = 86,
+  SNEH_SPECIAL_0_OPCODE_X1 = 56,
+  SNE_SPECIAL_0_OPCODE_X0 = 87,
+  SNE_SPECIAL_0_OPCODE_X1 = 57,
+  SNE_SPECIAL_5_OPCODE_Y0 = 3,
+  SNE_SPECIAL_5_OPCODE_Y1 = 3,
+  SPECIAL_0_OPCODE_X0 = 0,
+  SPECIAL_0_OPCODE_X1 = 1,
+  SPECIAL_0_OPCODE_Y0 = 1,
+  SPECIAL_0_OPCODE_Y1 = 1,
+  SPECIAL_1_OPCODE_Y0 = 2,
+  SPECIAL_1_OPCODE_Y1 = 2,
+  SPECIAL_2_OPCODE_Y0 = 3,
+  SPECIAL_2_OPCODE_Y1 = 3,
+  SPECIAL_3_OPCODE_Y0 = 4,
+  SPECIAL_3_OPCODE_Y1 = 4,
+  SPECIAL_4_OPCODE_Y0 = 5,
+  SPECIAL_4_OPCODE_Y1 = 5,
+  SPECIAL_5_OPCODE_Y0 = 6,
+  SPECIAL_5_OPCODE_Y1 = 6,
+  SPECIAL_6_OPCODE_Y0 = 7,
+  SPECIAL_7_OPCODE_Y0 = 8,
+  SRAB_SPECIAL_0_OPCODE_X0 = 88,
+  SRAB_SPECIAL_0_OPCODE_X1 = 58,
+  SRAH_SPECIAL_0_OPCODE_X0 = 89,
+  SRAH_SPECIAL_0_OPCODE_X1 = 59,
+  SRAIB_SHUN_0_OPCODE_X0 = 8,
+  SRAIB_SHUN_0_OPCODE_X1 = 8,
+  SRAIH_SHUN_0_OPCODE_X0 = 9,
+  SRAIH_SHUN_0_OPCODE_X1 = 9,
+  SRAI_SHUN_0_OPCODE_X0 = 10,
+  SRAI_SHUN_0_OPCODE_X1 = 10,
+  SRAI_SHUN_0_OPCODE_Y0 = 4,
+  SRAI_SHUN_0_OPCODE_Y1 = 4,
+  SRA_SPECIAL_0_OPCODE_X0 = 90,
+  SRA_SPECIAL_0_OPCODE_X1 = 60,
+  SRA_SPECIAL_3_OPCODE_Y0 = 3,
+  SRA_SPECIAL_3_OPCODE_Y1 = 3,
+  SUBBS_U_SPECIAL_0_OPCODE_X0 = 100,
+  SUBBS_U_SPECIAL_0_OPCODE_X1 = 70,
+  SUBB_SPECIAL_0_OPCODE_X0 = 91,
+  SUBB_SPECIAL_0_OPCODE_X1 = 61,
+  SUBHS_SPECIAL_0_OPCODE_X0 = 101,
+  SUBHS_SPECIAL_0_OPCODE_X1 = 71,
+  SUBH_SPECIAL_0_OPCODE_X0 = 92,
+  SUBH_SPECIAL_0_OPCODE_X1 = 62,
+  SUBS_SPECIAL_0_OPCODE_X0 = 97,
+  SUBS_SPECIAL_0_OPCODE_X1 = 67,
+  SUB_SPECIAL_0_OPCODE_X0 = 93,
+  SUB_SPECIAL_0_OPCODE_X1 = 63,
+  SUB_SPECIAL_0_OPCODE_Y0 = 3,
+  SUB_SPECIAL_0_OPCODE_Y1 = 3,
+  SWADD_IMM_0_OPCODE_X1 = 30,
+  SWINT0_UN_0_SHUN_0_OPCODE_X1 = 18,
+  SWINT1_UN_0_SHUN_0_OPCODE_X1 = 19,
+  SWINT2_UN_0_SHUN_0_OPCODE_X1 = 20,
+  SWINT3_UN_0_SHUN_0_OPCODE_X1 = 21,
+  SW_OPCODE_Y2 = 7,
+  SW_SPECIAL_0_OPCODE_X1 = 64,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_X0 = 8,
+  TBLIDXB0_UN_0_SHUN_0_OPCODE_Y0 = 8,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_X0 = 9,
+  TBLIDXB1_UN_0_SHUN_0_OPCODE_Y0 = 9,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_X0 = 10,
+  TBLIDXB2_UN_0_SHUN_0_OPCODE_Y0 = 10,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_X0 = 11,
+  TBLIDXB3_UN_0_SHUN_0_OPCODE_Y0 = 11,
+  TNS_UN_0_SHUN_0_OPCODE_X1 = 22,
+  UN_0_SHUN_0_OPCODE_X0 = 11,
+  UN_0_SHUN_0_OPCODE_X1 = 11,
+  UN_0_SHUN_0_OPCODE_Y0 = 5,
+  UN_0_SHUN_0_OPCODE_Y1 = 5,
+  WH64_UN_0_SHUN_0_OPCODE_X1 = 23,
+  XORI_IMM_0_OPCODE_X0 = 2,
+  XORI_IMM_0_OPCODE_X1 = 21,
+  XOR_SPECIAL_0_OPCODE_X0 = 94,
+  XOR_SPECIAL_0_OPCODE_X1 = 65,
+  XOR_SPECIAL_2_OPCODE_Y0 = 3,
+  XOR_SPECIAL_2_OPCODE_Y1 = 3
+};
+
+
+#endif /* __ASSEMBLER__ */
+
+#endif /* __ARCH_OPCODE_H__ */
diff --git a/arch/tile/include/asm/opcode-tile.h b/arch/tile/include/asm/opcode-tile.h
deleted file mode 100644
index ba38959..0000000
--- a/arch/tile/include/asm/opcode-tile.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_OPCODE_TILE_H
-#define _ASM_TILE_OPCODE_TILE_H
-
-#include <arch/chip.h>
-
-#if CHIP_WORD_SIZE() == 64
-#include <asm/opcode-tile_64.h>
-#else
-#include <asm/opcode-tile_32.h>
-#endif
-
-/* These definitions are not correct for TILE64, so just avoid them. */
-#undef TILE_ELF_MACHINE_CODE
-#undef TILE_ELF_NAME
-
-#endif /* _ASM_TILE_OPCODE_TILE_H */
diff --git a/arch/tile/include/asm/opcode-tile_32.h b/arch/tile/include/asm/opcode-tile_32.h
deleted file mode 100644
index 03df7b1..0000000
--- a/arch/tile/include/asm/opcode-tile_32.h
+++ /dev/null
@@ -1,1513 +0,0 @@
-/* tile.h -- Header file for TILE opcode table
-   Copyright (C) 2005 Free Software Foundation, Inc.
-   Contributed by Tilera Corp. */
-
-#ifndef opcode_tile_h
-#define opcode_tile_h
-
-typedef unsigned long long tile_bundle_bits;
-
-
-enum
-{
-  TILE_MAX_OPERANDS = 5 /* mm */
-};
-
-typedef enum
-{
-  TILE_OPC_BPT,
-  TILE_OPC_INFO,
-  TILE_OPC_INFOL,
-  TILE_OPC_J,
-  TILE_OPC_JAL,
-  TILE_OPC_MOVE,
-  TILE_OPC_MOVE_SN,
-  TILE_OPC_MOVEI,
-  TILE_OPC_MOVEI_SN,
-  TILE_OPC_MOVELI,
-  TILE_OPC_MOVELI_SN,
-  TILE_OPC_MOVELIS,
-  TILE_OPC_PREFETCH,
-  TILE_OPC_RAISE,
-  TILE_OPC_ADD,
-  TILE_OPC_ADD_SN,
-  TILE_OPC_ADDB,
-  TILE_OPC_ADDB_SN,
-  TILE_OPC_ADDBS_U,
-  TILE_OPC_ADDBS_U_SN,
-  TILE_OPC_ADDH,
-  TILE_OPC_ADDH_SN,
-  TILE_OPC_ADDHS,
-  TILE_OPC_ADDHS_SN,
-  TILE_OPC_ADDI,
-  TILE_OPC_ADDI_SN,
-  TILE_OPC_ADDIB,
-  TILE_OPC_ADDIB_SN,
-  TILE_OPC_ADDIH,
-  TILE_OPC_ADDIH_SN,
-  TILE_OPC_ADDLI,
-  TILE_OPC_ADDLI_SN,
-  TILE_OPC_ADDLIS,
-  TILE_OPC_ADDS,
-  TILE_OPC_ADDS_SN,
-  TILE_OPC_ADIFFB_U,
-  TILE_OPC_ADIFFB_U_SN,
-  TILE_OPC_ADIFFH,
-  TILE_OPC_ADIFFH_SN,
-  TILE_OPC_AND,
-  TILE_OPC_AND_SN,
-  TILE_OPC_ANDI,
-  TILE_OPC_ANDI_SN,
-  TILE_OPC_AULI,
-  TILE_OPC_AVGB_U,
-  TILE_OPC_AVGB_U_SN,
-  TILE_OPC_AVGH,
-  TILE_OPC_AVGH_SN,
-  TILE_OPC_BBNS,
-  TILE_OPC_BBNS_SN,
-  TILE_OPC_BBNST,
-  TILE_OPC_BBNST_SN,
-  TILE_OPC_BBS,
-  TILE_OPC_BBS_SN,
-  TILE_OPC_BBST,
-  TILE_OPC_BBST_SN,
-  TILE_OPC_BGEZ,
-  TILE_OPC_BGEZ_SN,
-  TILE_OPC_BGEZT,
-  TILE_OPC_BGEZT_SN,
-  TILE_OPC_BGZ,
-  TILE_OPC_BGZ_SN,
-  TILE_OPC_BGZT,
-  TILE_OPC_BGZT_SN,
-  TILE_OPC_BITX,
-  TILE_OPC_BITX_SN,
-  TILE_OPC_BLEZ,
-  TILE_OPC_BLEZ_SN,
-  TILE_OPC_BLEZT,
-  TILE_OPC_BLEZT_SN,
-  TILE_OPC_BLZ,
-  TILE_OPC_BLZ_SN,
-  TILE_OPC_BLZT,
-  TILE_OPC_BLZT_SN,
-  TILE_OPC_BNZ,
-  TILE_OPC_BNZ_SN,
-  TILE_OPC_BNZT,
-  TILE_OPC_BNZT_SN,
-  TILE_OPC_BYTEX,
-  TILE_OPC_BYTEX_SN,
-  TILE_OPC_BZ,
-  TILE_OPC_BZ_SN,
-  TILE_OPC_BZT,
-  TILE_OPC_BZT_SN,
-  TILE_OPC_CLZ,
-  TILE_OPC_CLZ_SN,
-  TILE_OPC_CRC32_32,
-  TILE_OPC_CRC32_32_SN,
-  TILE_OPC_CRC32_8,
-  TILE_OPC_CRC32_8_SN,
-  TILE_OPC_CTZ,
-  TILE_OPC_CTZ_SN,
-  TILE_OPC_DRAIN,
-  TILE_OPC_DTLBPR,
-  TILE_OPC_DWORD_ALIGN,
-  TILE_OPC_DWORD_ALIGN_SN,
-  TILE_OPC_FINV,
-  TILE_OPC_FLUSH,
-  TILE_OPC_FNOP,
-  TILE_OPC_ICOH,
-  TILE_OPC_ILL,
-  TILE_OPC_INTHB,
-  TILE_OPC_INTHB_SN,
-  TILE_OPC_INTHH,
-  TILE_OPC_INTHH_SN,
-  TILE_OPC_INTLB,
-  TILE_OPC_INTLB_SN,
-  TILE_OPC_INTLH,
-  TILE_OPC_INTLH_SN,
-  TILE_OPC_INV,
-  TILE_OPC_IRET,
-  TILE_OPC_JALB,
-  TILE_OPC_JALF,
-  TILE_OPC_JALR,
-  TILE_OPC_JALRP,
-  TILE_OPC_JB,
-  TILE_OPC_JF,
-  TILE_OPC_JR,
-  TILE_OPC_JRP,
-  TILE_OPC_LB,
-  TILE_OPC_LB_SN,
-  TILE_OPC_LB_U,
-  TILE_OPC_LB_U_SN,
-  TILE_OPC_LBADD,
-  TILE_OPC_LBADD_SN,
-  TILE_OPC_LBADD_U,
-  TILE_OPC_LBADD_U_SN,
-  TILE_OPC_LH,
-  TILE_OPC_LH_SN,
-  TILE_OPC_LH_U,
-  TILE_OPC_LH_U_SN,
-  TILE_OPC_LHADD,
-  TILE_OPC_LHADD_SN,
-  TILE_OPC_LHADD_U,
-  TILE_OPC_LHADD_U_SN,
-  TILE_OPC_LNK,
-  TILE_OPC_LNK_SN,
-  TILE_OPC_LW,
-  TILE_OPC_LW_SN,
-  TILE_OPC_LW_NA,
-  TILE_OPC_LW_NA_SN,
-  TILE_OPC_LWADD,
-  TILE_OPC_LWADD_SN,
-  TILE_OPC_LWADD_NA,
-  TILE_OPC_LWADD_NA_SN,
-  TILE_OPC_MAXB_U,
-  TILE_OPC_MAXB_U_SN,
-  TILE_OPC_MAXH,
-  TILE_OPC_MAXH_SN,
-  TILE_OPC_MAXIB_U,
-  TILE_OPC_MAXIB_U_SN,
-  TILE_OPC_MAXIH,
-  TILE_OPC_MAXIH_SN,
-  TILE_OPC_MF,
-  TILE_OPC_MFSPR,
-  TILE_OPC_MINB_U,
-  TILE_OPC_MINB_U_SN,
-  TILE_OPC_MINH,
-  TILE_OPC_MINH_SN,
-  TILE_OPC_MINIB_U,
-  TILE_OPC_MINIB_U_SN,
-  TILE_OPC_MINIH,
-  TILE_OPC_MINIH_SN,
-  TILE_OPC_MM,
-  TILE_OPC_MNZ,
-  TILE_OPC_MNZ_SN,
-  TILE_OPC_MNZB,
-  TILE_OPC_MNZB_SN,
-  TILE_OPC_MNZH,
-  TILE_OPC_MNZH_SN,
-  TILE_OPC_MTSPR,
-  TILE_OPC_MULHH_SS,
-  TILE_OPC_MULHH_SS_SN,
-  TILE_OPC_MULHH_SU,
-  TILE_OPC_MULHH_SU_SN,
-  TILE_OPC_MULHH_UU,
-  TILE_OPC_MULHH_UU_SN,
-  TILE_OPC_MULHHA_SS,
-  TILE_OPC_MULHHA_SS_SN,
-  TILE_OPC_MULHHA_SU,
-  TILE_OPC_MULHHA_SU_SN,
-  TILE_OPC_MULHHA_UU,
-  TILE_OPC_MULHHA_UU_SN,
-  TILE_OPC_MULHHSA_UU,
-  TILE_OPC_MULHHSA_UU_SN,
-  TILE_OPC_MULHL_SS,
-  TILE_OPC_MULHL_SS_SN,
-  TILE_OPC_MULHL_SU,
-  TILE_OPC_MULHL_SU_SN,
-  TILE_OPC_MULHL_US,
-  TILE_OPC_MULHL_US_SN,
-  TILE_OPC_MULHL_UU,
-  TILE_OPC_MULHL_UU_SN,
-  TILE_OPC_MULHLA_SS,
-  TILE_OPC_MULHLA_SS_SN,
-  TILE_OPC_MULHLA_SU,
-  TILE_OPC_MULHLA_SU_SN,
-  TILE_OPC_MULHLA_US,
-  TILE_OPC_MULHLA_US_SN,
-  TILE_OPC_MULHLA_UU,
-  TILE_OPC_MULHLA_UU_SN,
-  TILE_OPC_MULHLSA_UU,
-  TILE_OPC_MULHLSA_UU_SN,
-  TILE_OPC_MULLL_SS,
-  TILE_OPC_MULLL_SS_SN,
-  TILE_OPC_MULLL_SU,
-  TILE_OPC_MULLL_SU_SN,
-  TILE_OPC_MULLL_UU,
-  TILE_OPC_MULLL_UU_SN,
-  TILE_OPC_MULLLA_SS,
-  TILE_OPC_MULLLA_SS_SN,
-  TILE_OPC_MULLLA_SU,
-  TILE_OPC_MULLLA_SU_SN,
-  TILE_OPC_MULLLA_UU,
-  TILE_OPC_MULLLA_UU_SN,
-  TILE_OPC_MULLLSA_UU,
-  TILE_OPC_MULLLSA_UU_SN,
-  TILE_OPC_MVNZ,
-  TILE_OPC_MVNZ_SN,
-  TILE_OPC_MVZ,
-  TILE_OPC_MVZ_SN,
-  TILE_OPC_MZ,
-  TILE_OPC_MZ_SN,
-  TILE_OPC_MZB,
-  TILE_OPC_MZB_SN,
-  TILE_OPC_MZH,
-  TILE_OPC_MZH_SN,
-  TILE_OPC_NAP,
-  TILE_OPC_NOP,
-  TILE_OPC_NOR,
-  TILE_OPC_NOR_SN,
-  TILE_OPC_OR,
-  TILE_OPC_OR_SN,
-  TILE_OPC_ORI,
-  TILE_OPC_ORI_SN,
-  TILE_OPC_PACKBS_U,
-  TILE_OPC_PACKBS_U_SN,
-  TILE_OPC_PACKHB,
-  TILE_OPC_PACKHB_SN,
-  TILE_OPC_PACKHS,
-  TILE_OPC_PACKHS_SN,
-  TILE_OPC_PACKLB,
-  TILE_OPC_PACKLB_SN,
-  TILE_OPC_PCNT,
-  TILE_OPC_PCNT_SN,
-  TILE_OPC_RL,
-  TILE_OPC_RL_SN,
-  TILE_OPC_RLI,
-  TILE_OPC_RLI_SN,
-  TILE_OPC_S1A,
-  TILE_OPC_S1A_SN,
-  TILE_OPC_S2A,
-  TILE_OPC_S2A_SN,
-  TILE_OPC_S3A,
-  TILE_OPC_S3A_SN,
-  TILE_OPC_SADAB_U,
-  TILE_OPC_SADAB_U_SN,
-  TILE_OPC_SADAH,
-  TILE_OPC_SADAH_SN,
-  TILE_OPC_SADAH_U,
-  TILE_OPC_SADAH_U_SN,
-  TILE_OPC_SADB_U,
-  TILE_OPC_SADB_U_SN,
-  TILE_OPC_SADH,
-  TILE_OPC_SADH_SN,
-  TILE_OPC_SADH_U,
-  TILE_OPC_SADH_U_SN,
-  TILE_OPC_SB,
-  TILE_OPC_SBADD,
-  TILE_OPC_SEQ,
-  TILE_OPC_SEQ_SN,
-  TILE_OPC_SEQB,
-  TILE_OPC_SEQB_SN,
-  TILE_OPC_SEQH,
-  TILE_OPC_SEQH_SN,
-  TILE_OPC_SEQI,
-  TILE_OPC_SEQI_SN,
-  TILE_OPC_SEQIB,
-  TILE_OPC_SEQIB_SN,
-  TILE_OPC_SEQIH,
-  TILE_OPC_SEQIH_SN,
-  TILE_OPC_SH,
-  TILE_OPC_SHADD,
-  TILE_OPC_SHL,
-  TILE_OPC_SHL_SN,
-  TILE_OPC_SHLB,
-  TILE_OPC_SHLB_SN,
-  TILE_OPC_SHLH,
-  TILE_OPC_SHLH_SN,
-  TILE_OPC_SHLI,
-  TILE_OPC_SHLI_SN,
-  TILE_OPC_SHLIB,
-  TILE_OPC_SHLIB_SN,
-  TILE_OPC_SHLIH,
-  TILE_OPC_SHLIH_SN,
-  TILE_OPC_SHR,
-  TILE_OPC_SHR_SN,
-  TILE_OPC_SHRB,
-  TILE_OPC_SHRB_SN,
-  TILE_OPC_SHRH,
-  TILE_OPC_SHRH_SN,
-  TILE_OPC_SHRI,
-  TILE_OPC_SHRI_SN,
-  TILE_OPC_SHRIB,
-  TILE_OPC_SHRIB_SN,
-  TILE_OPC_SHRIH,
-  TILE_OPC_SHRIH_SN,
-  TILE_OPC_SLT,
-  TILE_OPC_SLT_SN,
-  TILE_OPC_SLT_U,
-  TILE_OPC_SLT_U_SN,
-  TILE_OPC_SLTB,
-  TILE_OPC_SLTB_SN,
-  TILE_OPC_SLTB_U,
-  TILE_OPC_SLTB_U_SN,
-  TILE_OPC_SLTE,
-  TILE_OPC_SLTE_SN,
-  TILE_OPC_SLTE_U,
-  TILE_OPC_SLTE_U_SN,
-  TILE_OPC_SLTEB,
-  TILE_OPC_SLTEB_SN,
-  TILE_OPC_SLTEB_U,
-  TILE_OPC_SLTEB_U_SN,
-  TILE_OPC_SLTEH,
-  TILE_OPC_SLTEH_SN,
-  TILE_OPC_SLTEH_U,
-  TILE_OPC_SLTEH_U_SN,
-  TILE_OPC_SLTH,
-  TILE_OPC_SLTH_SN,
-  TILE_OPC_SLTH_U,
-  TILE_OPC_SLTH_U_SN,
-  TILE_OPC_SLTI,
-  TILE_OPC_SLTI_SN,
-  TILE_OPC_SLTI_U,
-  TILE_OPC_SLTI_U_SN,
-  TILE_OPC_SLTIB,
-  TILE_OPC_SLTIB_SN,
-  TILE_OPC_SLTIB_U,
-  TILE_OPC_SLTIB_U_SN,
-  TILE_OPC_SLTIH,
-  TILE_OPC_SLTIH_SN,
-  TILE_OPC_SLTIH_U,
-  TILE_OPC_SLTIH_U_SN,
-  TILE_OPC_SNE,
-  TILE_OPC_SNE_SN,
-  TILE_OPC_SNEB,
-  TILE_OPC_SNEB_SN,
-  TILE_OPC_SNEH,
-  TILE_OPC_SNEH_SN,
-  TILE_OPC_SRA,
-  TILE_OPC_SRA_SN,
-  TILE_OPC_SRAB,
-  TILE_OPC_SRAB_SN,
-  TILE_OPC_SRAH,
-  TILE_OPC_SRAH_SN,
-  TILE_OPC_SRAI,
-  TILE_OPC_SRAI_SN,
-  TILE_OPC_SRAIB,
-  TILE_OPC_SRAIB_SN,
-  TILE_OPC_SRAIH,
-  TILE_OPC_SRAIH_SN,
-  TILE_OPC_SUB,
-  TILE_OPC_SUB_SN,
-  TILE_OPC_SUBB,
-  TILE_OPC_SUBB_SN,
-  TILE_OPC_SUBBS_U,
-  TILE_OPC_SUBBS_U_SN,
-  TILE_OPC_SUBH,
-  TILE_OPC_SUBH_SN,
-  TILE_OPC_SUBHS,
-  TILE_OPC_SUBHS_SN,
-  TILE_OPC_SUBS,
-  TILE_OPC_SUBS_SN,
-  TILE_OPC_SW,
-  TILE_OPC_SWADD,
-  TILE_OPC_SWINT0,
-  TILE_OPC_SWINT1,
-  TILE_OPC_SWINT2,
-  TILE_OPC_SWINT3,
-  TILE_OPC_TBLIDXB0,
-  TILE_OPC_TBLIDXB0_SN,
-  TILE_OPC_TBLIDXB1,
-  TILE_OPC_TBLIDXB1_SN,
-  TILE_OPC_TBLIDXB2,
-  TILE_OPC_TBLIDXB2_SN,
-  TILE_OPC_TBLIDXB3,
-  TILE_OPC_TBLIDXB3_SN,
-  TILE_OPC_TNS,
-  TILE_OPC_TNS_SN,
-  TILE_OPC_WH64,
-  TILE_OPC_XOR,
-  TILE_OPC_XOR_SN,
-  TILE_OPC_XORI,
-  TILE_OPC_XORI_SN,
-  TILE_OPC_NONE
-} tile_mnemonic;
-
-/* 64-bit pattern for a { bpt ; nop } bundle. */
-#define TILE_BPT_BUNDLE 0x400b3cae70166000ULL
-
-
-#define TILE_ELF_MACHINE_CODE EM_TILEPRO
-
-#define TILE_ELF_NAME "elf32-tilepro"
-
-
-static __inline unsigned int
-get_BrOff_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_BrOff_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x00007fff) |
-         (((unsigned int)(n >> 20)) & 0x00018000);
-}
-
-static __inline unsigned int
-get_BrType_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0xf);
-}
-
-static __inline unsigned int
-get_Dest_Imm8_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x0000003f) |
-         (((unsigned int)(n >> 43)) & 0x000000c0);
-}
-
-static __inline unsigned int
-get_Dest_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 2)) & 0x3);
-}
-
-static __inline unsigned int
-get_Dest_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Imm16_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xffff);
-}
-
-static __inline unsigned int
-get_Imm16_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xffff);
-}
-
-static __inline unsigned int
-get_Imm8_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xff);
-}
-
-static __inline unsigned int
-get_ImmOpcodeExtension_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 20)) & 0x7f);
-}
-
-static __inline unsigned int
-get_ImmOpcodeExtension_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 51)) & 0x7f);
-}
-
-static __inline unsigned int
-get_ImmRROpcodeExtension_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 8)) & 0x3);
-}
-
-static __inline unsigned int
-get_JOffLong_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x00007fff) |
-         (((unsigned int)(n >> 20)) & 0x00018000) |
-         (((unsigned int)(n >> 14)) & 0x001e0000) |
-         (((unsigned int)(n >> 16)) & 0x07e00000) |
-         (((unsigned int)(n >> 31)) & 0x18000000);
-}
-
-static __inline unsigned int
-get_JOff_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x00007fff) |
-         (((unsigned int)(n >> 20)) & 0x00018000) |
-         (((unsigned int)(n >> 14)) & 0x001e0000) |
-         (((unsigned int)(n >> 16)) & 0x07e00000) |
-         (((unsigned int)(n >> 31)) & 0x08000000);
-}
-
-static __inline unsigned int
-get_MF_Imm15_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x00003fff) |
-         (((unsigned int)(n >> 44)) & 0x00004000);
-}
-
-static __inline unsigned int
-get_MMEnd_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x1f);
-}
-
-static __inline unsigned int
-get_MMEnd_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x1f);
-}
-
-static __inline unsigned int
-get_MMStart_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 23)) & 0x1f);
-}
-
-static __inline unsigned int
-get_MMStart_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 54)) & 0x1f);
-}
-
-static __inline unsigned int
-get_MT_Imm15_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x0000003f) |
-         (((unsigned int)(n >> 37)) & 0x00003fc0) |
-         (((unsigned int)(n >> 44)) & 0x00004000);
-}
-
-static __inline unsigned int
-get_Mode(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 63)) & 0x1);
-}
-
-static __inline unsigned int
-get_NoRegOpcodeExtension_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 10)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Opcode_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 28)) & 0x7);
-}
-
-static __inline unsigned int
-get_Opcode_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 59)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 27)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 59)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_Y2(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 56)) & 0x7);
-}
-
-static __inline unsigned int
-get_RROpcodeExtension_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 4)) & 0xf);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x1ff);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x1ff);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x3);
-}
-
-static __inline unsigned int
-get_RouteOpcodeExtension_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_S_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 27)) & 0x1);
-}
-
-static __inline unsigned int
-get_S_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 58)) & 0x1);
-}
-
-static __inline unsigned int
-get_ShAmt_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x1f);
-}
-
-static __inline unsigned int
-get_ShAmt_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x1f);
-}
-
-static __inline unsigned int
-get_ShAmt_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x1f);
-}
-
-static __inline unsigned int
-get_ShAmt_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x1f);
-}
-
-static __inline unsigned int
-get_SrcA_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 6)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 6)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y2(tile_bundle_bits n)
-{
-  return (((n >> 26)) & 0x00000001) |
-         (((unsigned int)(n >> 50)) & 0x0000003e);
-}
-
-static __inline unsigned int
-get_SrcBDest_Y2(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 20)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Src_SN(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3);
-}
-
-static __inline unsigned int
-get_UnOpcodeExtension_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x1f);
-}
-
-static __inline unsigned int
-get_UnOpcodeExtension_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x1f);
-}
-
-static __inline unsigned int
-get_UnOpcodeExtension_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x1f);
-}
-
-static __inline unsigned int
-get_UnOpcodeExtension_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x1f);
-}
-
-static __inline unsigned int
-get_UnShOpcodeExtension_X0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 17)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_UnShOpcodeExtension_X1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 48)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_UnShOpcodeExtension_Y0(tile_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 17)) & 0x7);
-}
-
-static __inline unsigned int
-get_UnShOpcodeExtension_Y1(tile_bundle_bits n)
-{
-  return (((unsigned int)(n >> 48)) & 0x7);
-}
-
-
-static __inline int
-sign_extend(int n, int num_bits)
-{
-  int shift = (int)(sizeof(int) * 8 - num_bits);
-  return (n << shift) >> shift;
-}
-
-
-
-static __inline tile_bundle_bits
-create_BrOff_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3ff) << 0);
-}
-
-static __inline tile_bundle_bits
-create_BrOff_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
-         (((tile_bundle_bits)(n & 0x00018000)) << 20);
-}
-
-static __inline tile_bundle_bits
-create_BrType_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xf)) << 31);
-}
-
-static __inline tile_bundle_bits
-create_Dest_Imm8_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
-         (((tile_bundle_bits)(n & 0x000000c0)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_Dest_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 2);
-}
-
-static __inline tile_bundle_bits
-create_Dest_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 0);
-}
-
-static __inline tile_bundle_bits
-create_Dest_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 31);
-}
-
-static __inline tile_bundle_bits
-create_Dest_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 0);
-}
-
-static __inline tile_bundle_bits
-create_Dest_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 31);
-}
-
-static __inline tile_bundle_bits
-create_Imm16_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xffff) << 12);
-}
-
-static __inline tile_bundle_bits
-create_Imm16_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xffff)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_Imm8_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 0);
-}
-
-static __inline tile_bundle_bits
-create_Imm8_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 12);
-}
-
-static __inline tile_bundle_bits
-create_Imm8_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xff)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_Imm8_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 12);
-}
-
-static __inline tile_bundle_bits
-create_Imm8_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xff)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_ImmOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x7f) << 20);
-}
-
-static __inline tile_bundle_bits
-create_ImmOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x7f)) << 51);
-}
-
-static __inline tile_bundle_bits
-create_ImmRROpcodeExtension_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 8);
-}
-
-static __inline tile_bundle_bits
-create_JOffLong_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
-         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
-         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
-         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
-         (((tile_bundle_bits)(n & 0x18000000)) << 31);
-}
-
-static __inline tile_bundle_bits
-create_JOff_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x00007fff)) << 43) |
-         (((tile_bundle_bits)(n & 0x00018000)) << 20) |
-         (((tile_bundle_bits)(n & 0x001e0000)) << 14) |
-         (((tile_bundle_bits)(n & 0x07e00000)) << 16) |
-         (((tile_bundle_bits)(n & 0x08000000)) << 31);
-}
-
-static __inline tile_bundle_bits
-create_MF_Imm15_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x00003fff)) << 37) |
-         (((tile_bundle_bits)(n & 0x00004000)) << 44);
-}
-
-static __inline tile_bundle_bits
-create_MMEnd_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 18);
-}
-
-static __inline tile_bundle_bits
-create_MMEnd_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 49);
-}
-
-static __inline tile_bundle_bits
-create_MMStart_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 23);
-}
-
-static __inline tile_bundle_bits
-create_MMStart_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 54);
-}
-
-static __inline tile_bundle_bits
-create_MT_Imm15_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x0000003f)) << 31) |
-         (((tile_bundle_bits)(n & 0x00003fc0)) << 37) |
-         (((tile_bundle_bits)(n & 0x00004000)) << 44);
-}
-
-static __inline tile_bundle_bits
-create_Mode(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1)) << 63);
-}
-
-static __inline tile_bundle_bits
-create_NoRegOpcodeExtension_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xf) << 0);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 10);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x7) << 28);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xf)) << 59);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xf) << 27);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0xf)) << 59);
-}
-
-static __inline tile_bundle_bits
-create_Opcode_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x7)) << 56);
-}
-
-static __inline tile_bundle_bits
-create_RROpcodeExtension_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xf) << 4);
-}
-
-static __inline tile_bundle_bits
-create_RRROpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1ff) << 18);
-}
-
-static __inline tile_bundle_bits
-create_RRROpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1ff)) << 49);
-}
-
-static __inline tile_bundle_bits
-create_RRROpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 18);
-}
-
-static __inline tile_bundle_bits
-create_RRROpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3)) << 49);
-}
-
-static __inline tile_bundle_bits
-create_RouteOpcodeExtension_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3ff) << 0);
-}
-
-static __inline tile_bundle_bits
-create_S_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1) << 27);
-}
-
-static __inline tile_bundle_bits
-create_S_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1)) << 58);
-}
-
-static __inline tile_bundle_bits
-create_ShAmt_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_ShAmt_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_ShAmt_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_ShAmt_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_SrcA_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 6);
-}
-
-static __inline tile_bundle_bits
-create_SrcA_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 37);
-}
-
-static __inline tile_bundle_bits
-create_SrcA_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 6);
-}
-
-static __inline tile_bundle_bits
-create_SrcA_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 37);
-}
-
-static __inline tile_bundle_bits
-create_SrcA_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x00000001) << 26) |
-         (((tile_bundle_bits)(n & 0x0000003e)) << 50);
-}
-
-static __inline tile_bundle_bits
-create_SrcBDest_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 20);
-}
-
-static __inline tile_bundle_bits
-create_SrcB_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_SrcB_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_SrcB_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_SrcB_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_Src_SN(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 0);
-}
-
-static __inline tile_bundle_bits
-create_UnOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_UnOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_UnOpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x1f) << 12);
-}
-
-static __inline tile_bundle_bits
-create_UnOpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x1f)) << 43);
-}
-
-static __inline tile_bundle_bits
-create_UnShOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3ff) << 17);
-}
-
-static __inline tile_bundle_bits
-create_UnShOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x3ff)) << 48);
-}
-
-static __inline tile_bundle_bits
-create_UnShOpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x7) << 17);
-}
-
-static __inline tile_bundle_bits
-create_UnShOpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tile_bundle_bits)(n & 0x7)) << 48);
-}
-
-
-
-typedef enum
-{
-  TILE_PIPELINE_X0,
-  TILE_PIPELINE_X1,
-  TILE_PIPELINE_Y0,
-  TILE_PIPELINE_Y1,
-  TILE_PIPELINE_Y2,
-} tile_pipeline;
-
-#define tile_is_x_pipeline(p) ((int)(p) <= (int)TILE_PIPELINE_X1)
-
-typedef enum
-{
-  TILE_OP_TYPE_REGISTER,
-  TILE_OP_TYPE_IMMEDIATE,
-  TILE_OP_TYPE_ADDRESS,
-  TILE_OP_TYPE_SPR
-} tile_operand_type;
-
-/* This is the bit that determines if a bundle is in the Y encoding. */
-#define TILE_BUNDLE_Y_ENCODING_MASK ((tile_bundle_bits)1 << 63)
-
-enum
-{
-  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
-  TILE_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
-
-  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
-  TILE_NUM_PIPELINE_ENCODINGS = 5,
-
-  /* Log base 2 of TILE_BUNDLE_SIZE_IN_BYTES. */
-  TILE_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
-
-  /* Instructions take this many bytes. */
-  TILE_BUNDLE_SIZE_IN_BYTES = 1 << TILE_LOG2_BUNDLE_SIZE_IN_BYTES,
-
-  /* Log base 2 of TILE_BUNDLE_ALIGNMENT_IN_BYTES. */
-  TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
-
-  /* Bundles should be aligned modulo this number of bytes. */
-  TILE_BUNDLE_ALIGNMENT_IN_BYTES =
-    (1 << TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
-
-  /* Log base 2 of TILE_SN_INSTRUCTION_SIZE_IN_BYTES. */
-  TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES = 1,
-
-  /* Static network instructions take this many bytes. */
-  TILE_SN_INSTRUCTION_SIZE_IN_BYTES =
-    (1 << TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES),
-
-  /* Number of registers (some are magic, such as network I/O). */
-  TILE_NUM_REGISTERS = 64,
-
-  /* Number of static network registers. */
-  TILE_NUM_SN_REGISTERS = 4
-};
-
-
-struct tile_operand
-{
-  /* Is this operand a register, immediate or address? */
-  tile_operand_type type;
-
-  /* The default relocation type for this operand.  */
-  signed int default_reloc : 16;
-
-  /* How many bits is this value? (used for range checking) */
-  unsigned int num_bits : 5;
-
-  /* Is the value signed? (used for range checking) */
-  unsigned int is_signed : 1;
-
-  /* Is this operand a source register? */
-  unsigned int is_src_reg : 1;
-
-  /* Is this operand written? (i.e. is it a destination register) */
-  unsigned int is_dest_reg : 1;
-
-  /* Is this operand PC-relative? */
-  unsigned int is_pc_relative : 1;
-
-  /* By how many bits do we right shift the value before inserting? */
-  unsigned int rightshift : 2;
-
-  /* Return the bits for this operand to be ORed into an existing bundle. */
-  tile_bundle_bits (*insert) (int op);
-
-  /* Extract this operand and return it. */
-  unsigned int (*extract) (tile_bundle_bits bundle);
-};
-
-
-extern const struct tile_operand tile_operands[];
-
-/* One finite-state machine per pipe for rapid instruction decoding. */
-extern const unsigned short * const
-tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS];
-
-
-struct tile_opcode
-{
-  /* The opcode mnemonic, e.g. "add" */
-  const char *name;
-
-  /* The enum value for this mnemonic. */
-  tile_mnemonic mnemonic;
-
-  /* A bit mask of which of the five pipes this instruction
-     is compatible with:
-     X0  0x01
-     X1  0x02
-     Y0  0x04
-     Y1  0x08
-     Y2  0x10 */
-  unsigned char pipes;
-
-  /* How many operands are there? */
-  unsigned char num_operands;
-
-  /* Which register does this write implicitly, or TREG_ZERO if none? */
-  unsigned char implicitly_written_register;
-
-  /* Can this be bundled with other instructions (almost always true). */
-  unsigned char can_bundle;
-
-  /* The description of the operands. Each of these is an
-   * index into the tile_operands[] table. */
-  unsigned char operands[TILE_NUM_PIPELINE_ENCODINGS][TILE_MAX_OPERANDS];
-
-};
-
-extern const struct tile_opcode tile_opcodes[];
-
-
-/* Used for non-textual disassembly into structs. */
-struct tile_decoded_instruction
-{
-  const struct tile_opcode *opcode;
-  const struct tile_operand *operands[TILE_MAX_OPERANDS];
-  int operand_values[TILE_MAX_OPERANDS];
-};
-
-
-/* Disassemble a bundle into a struct for machine processing. */
-extern int parse_insn_tile(tile_bundle_bits bits,
-                           unsigned int pc,
-                           struct tile_decoded_instruction
-                           decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
-
-
-/* Given a set of bundle bits and a specific pipe, returns which
- * instruction the bundle contains in that pipe.
- */
-extern const struct tile_opcode *
-find_opcode(tile_bundle_bits bits, tile_pipeline pipe);
-
-
-
-#endif /* opcode_tile_h */
diff --git a/arch/tile/include/asm/opcode-tile_64.h b/arch/tile/include/asm/opcode-tile_64.h
deleted file mode 100644
index c063346..0000000
--- a/arch/tile/include/asm/opcode-tile_64.h
+++ /dev/null
@@ -1,1248 +0,0 @@
-/* tile.h -- Header file for TILE opcode table
-   Copyright (C) 2005 Free Software Foundation, Inc.
-   Contributed by Tilera Corp. */
-
-#ifndef opcode_tile_h
-#define opcode_tile_h
-
-typedef unsigned long long tilegx_bundle_bits;
-
-
-enum
-{
-  TILEGX_MAX_OPERANDS = 4 /* bfexts */
-};
-
-typedef enum
-{
-  TILEGX_OPC_BPT,
-  TILEGX_OPC_INFO,
-  TILEGX_OPC_INFOL,
-  TILEGX_OPC_MOVE,
-  TILEGX_OPC_MOVEI,
-  TILEGX_OPC_MOVELI,
-  TILEGX_OPC_PREFETCH,
-  TILEGX_OPC_PREFETCH_ADD_L1,
-  TILEGX_OPC_PREFETCH_ADD_L1_FAULT,
-  TILEGX_OPC_PREFETCH_ADD_L2,
-  TILEGX_OPC_PREFETCH_ADD_L2_FAULT,
-  TILEGX_OPC_PREFETCH_ADD_L3,
-  TILEGX_OPC_PREFETCH_ADD_L3_FAULT,
-  TILEGX_OPC_PREFETCH_L1,
-  TILEGX_OPC_PREFETCH_L1_FAULT,
-  TILEGX_OPC_PREFETCH_L2,
-  TILEGX_OPC_PREFETCH_L2_FAULT,
-  TILEGX_OPC_PREFETCH_L3,
-  TILEGX_OPC_PREFETCH_L3_FAULT,
-  TILEGX_OPC_RAISE,
-  TILEGX_OPC_ADD,
-  TILEGX_OPC_ADDI,
-  TILEGX_OPC_ADDLI,
-  TILEGX_OPC_ADDX,
-  TILEGX_OPC_ADDXI,
-  TILEGX_OPC_ADDXLI,
-  TILEGX_OPC_ADDXSC,
-  TILEGX_OPC_AND,
-  TILEGX_OPC_ANDI,
-  TILEGX_OPC_BEQZ,
-  TILEGX_OPC_BEQZT,
-  TILEGX_OPC_BFEXTS,
-  TILEGX_OPC_BFEXTU,
-  TILEGX_OPC_BFINS,
-  TILEGX_OPC_BGEZ,
-  TILEGX_OPC_BGEZT,
-  TILEGX_OPC_BGTZ,
-  TILEGX_OPC_BGTZT,
-  TILEGX_OPC_BLBC,
-  TILEGX_OPC_BLBCT,
-  TILEGX_OPC_BLBS,
-  TILEGX_OPC_BLBST,
-  TILEGX_OPC_BLEZ,
-  TILEGX_OPC_BLEZT,
-  TILEGX_OPC_BLTZ,
-  TILEGX_OPC_BLTZT,
-  TILEGX_OPC_BNEZ,
-  TILEGX_OPC_BNEZT,
-  TILEGX_OPC_CLZ,
-  TILEGX_OPC_CMOVEQZ,
-  TILEGX_OPC_CMOVNEZ,
-  TILEGX_OPC_CMPEQ,
-  TILEGX_OPC_CMPEQI,
-  TILEGX_OPC_CMPEXCH,
-  TILEGX_OPC_CMPEXCH4,
-  TILEGX_OPC_CMPLES,
-  TILEGX_OPC_CMPLEU,
-  TILEGX_OPC_CMPLTS,
-  TILEGX_OPC_CMPLTSI,
-  TILEGX_OPC_CMPLTU,
-  TILEGX_OPC_CMPLTUI,
-  TILEGX_OPC_CMPNE,
-  TILEGX_OPC_CMUL,
-  TILEGX_OPC_CMULA,
-  TILEGX_OPC_CMULAF,
-  TILEGX_OPC_CMULF,
-  TILEGX_OPC_CMULFR,
-  TILEGX_OPC_CMULH,
-  TILEGX_OPC_CMULHR,
-  TILEGX_OPC_CRC32_32,
-  TILEGX_OPC_CRC32_8,
-  TILEGX_OPC_CTZ,
-  TILEGX_OPC_DBLALIGN,
-  TILEGX_OPC_DBLALIGN2,
-  TILEGX_OPC_DBLALIGN4,
-  TILEGX_OPC_DBLALIGN6,
-  TILEGX_OPC_DRAIN,
-  TILEGX_OPC_DTLBPR,
-  TILEGX_OPC_EXCH,
-  TILEGX_OPC_EXCH4,
-  TILEGX_OPC_FDOUBLE_ADD_FLAGS,
-  TILEGX_OPC_FDOUBLE_ADDSUB,
-  TILEGX_OPC_FDOUBLE_MUL_FLAGS,
-  TILEGX_OPC_FDOUBLE_PACK1,
-  TILEGX_OPC_FDOUBLE_PACK2,
-  TILEGX_OPC_FDOUBLE_SUB_FLAGS,
-  TILEGX_OPC_FDOUBLE_UNPACK_MAX,
-  TILEGX_OPC_FDOUBLE_UNPACK_MIN,
-  TILEGX_OPC_FETCHADD,
-  TILEGX_OPC_FETCHADD4,
-  TILEGX_OPC_FETCHADDGEZ,
-  TILEGX_OPC_FETCHADDGEZ4,
-  TILEGX_OPC_FETCHAND,
-  TILEGX_OPC_FETCHAND4,
-  TILEGX_OPC_FETCHOR,
-  TILEGX_OPC_FETCHOR4,
-  TILEGX_OPC_FINV,
-  TILEGX_OPC_FLUSH,
-  TILEGX_OPC_FLUSHWB,
-  TILEGX_OPC_FNOP,
-  TILEGX_OPC_FSINGLE_ADD1,
-  TILEGX_OPC_FSINGLE_ADDSUB2,
-  TILEGX_OPC_FSINGLE_MUL1,
-  TILEGX_OPC_FSINGLE_MUL2,
-  TILEGX_OPC_FSINGLE_PACK1,
-  TILEGX_OPC_FSINGLE_PACK2,
-  TILEGX_OPC_FSINGLE_SUB1,
-  TILEGX_OPC_ICOH,
-  TILEGX_OPC_ILL,
-  TILEGX_OPC_INV,
-  TILEGX_OPC_IRET,
-  TILEGX_OPC_J,
-  TILEGX_OPC_JAL,
-  TILEGX_OPC_JALR,
-  TILEGX_OPC_JALRP,
-  TILEGX_OPC_JR,
-  TILEGX_OPC_JRP,
-  TILEGX_OPC_LD,
-  TILEGX_OPC_LD1S,
-  TILEGX_OPC_LD1S_ADD,
-  TILEGX_OPC_LD1U,
-  TILEGX_OPC_LD1U_ADD,
-  TILEGX_OPC_LD2S,
-  TILEGX_OPC_LD2S_ADD,
-  TILEGX_OPC_LD2U,
-  TILEGX_OPC_LD2U_ADD,
-  TILEGX_OPC_LD4S,
-  TILEGX_OPC_LD4S_ADD,
-  TILEGX_OPC_LD4U,
-  TILEGX_OPC_LD4U_ADD,
-  TILEGX_OPC_LD_ADD,
-  TILEGX_OPC_LDNA,
-  TILEGX_OPC_LDNA_ADD,
-  TILEGX_OPC_LDNT,
-  TILEGX_OPC_LDNT1S,
-  TILEGX_OPC_LDNT1S_ADD,
-  TILEGX_OPC_LDNT1U,
-  TILEGX_OPC_LDNT1U_ADD,
-  TILEGX_OPC_LDNT2S,
-  TILEGX_OPC_LDNT2S_ADD,
-  TILEGX_OPC_LDNT2U,
-  TILEGX_OPC_LDNT2U_ADD,
-  TILEGX_OPC_LDNT4S,
-  TILEGX_OPC_LDNT4S_ADD,
-  TILEGX_OPC_LDNT4U,
-  TILEGX_OPC_LDNT4U_ADD,
-  TILEGX_OPC_LDNT_ADD,
-  TILEGX_OPC_LNK,
-  TILEGX_OPC_MF,
-  TILEGX_OPC_MFSPR,
-  TILEGX_OPC_MM,
-  TILEGX_OPC_MNZ,
-  TILEGX_OPC_MTSPR,
-  TILEGX_OPC_MUL_HS_HS,
-  TILEGX_OPC_MUL_HS_HU,
-  TILEGX_OPC_MUL_HS_LS,
-  TILEGX_OPC_MUL_HS_LU,
-  TILEGX_OPC_MUL_HU_HU,
-  TILEGX_OPC_MUL_HU_LS,
-  TILEGX_OPC_MUL_HU_LU,
-  TILEGX_OPC_MUL_LS_LS,
-  TILEGX_OPC_MUL_LS_LU,
-  TILEGX_OPC_MUL_LU_LU,
-  TILEGX_OPC_MULA_HS_HS,
-  TILEGX_OPC_MULA_HS_HU,
-  TILEGX_OPC_MULA_HS_LS,
-  TILEGX_OPC_MULA_HS_LU,
-  TILEGX_OPC_MULA_HU_HU,
-  TILEGX_OPC_MULA_HU_LS,
-  TILEGX_OPC_MULA_HU_LU,
-  TILEGX_OPC_MULA_LS_LS,
-  TILEGX_OPC_MULA_LS_LU,
-  TILEGX_OPC_MULA_LU_LU,
-  TILEGX_OPC_MULAX,
-  TILEGX_OPC_MULX,
-  TILEGX_OPC_MZ,
-  TILEGX_OPC_NAP,
-  TILEGX_OPC_NOP,
-  TILEGX_OPC_NOR,
-  TILEGX_OPC_OR,
-  TILEGX_OPC_ORI,
-  TILEGX_OPC_PCNT,
-  TILEGX_OPC_REVBITS,
-  TILEGX_OPC_REVBYTES,
-  TILEGX_OPC_ROTL,
-  TILEGX_OPC_ROTLI,
-  TILEGX_OPC_SHL,
-  TILEGX_OPC_SHL16INSLI,
-  TILEGX_OPC_SHL1ADD,
-  TILEGX_OPC_SHL1ADDX,
-  TILEGX_OPC_SHL2ADD,
-  TILEGX_OPC_SHL2ADDX,
-  TILEGX_OPC_SHL3ADD,
-  TILEGX_OPC_SHL3ADDX,
-  TILEGX_OPC_SHLI,
-  TILEGX_OPC_SHLX,
-  TILEGX_OPC_SHLXI,
-  TILEGX_OPC_SHRS,
-  TILEGX_OPC_SHRSI,
-  TILEGX_OPC_SHRU,
-  TILEGX_OPC_SHRUI,
-  TILEGX_OPC_SHRUX,
-  TILEGX_OPC_SHRUXI,
-  TILEGX_OPC_SHUFFLEBYTES,
-  TILEGX_OPC_ST,
-  TILEGX_OPC_ST1,
-  TILEGX_OPC_ST1_ADD,
-  TILEGX_OPC_ST2,
-  TILEGX_OPC_ST2_ADD,
-  TILEGX_OPC_ST4,
-  TILEGX_OPC_ST4_ADD,
-  TILEGX_OPC_ST_ADD,
-  TILEGX_OPC_STNT,
-  TILEGX_OPC_STNT1,
-  TILEGX_OPC_STNT1_ADD,
-  TILEGX_OPC_STNT2,
-  TILEGX_OPC_STNT2_ADD,
-  TILEGX_OPC_STNT4,
-  TILEGX_OPC_STNT4_ADD,
-  TILEGX_OPC_STNT_ADD,
-  TILEGX_OPC_SUB,
-  TILEGX_OPC_SUBX,
-  TILEGX_OPC_SUBXSC,
-  TILEGX_OPC_SWINT0,
-  TILEGX_OPC_SWINT1,
-  TILEGX_OPC_SWINT2,
-  TILEGX_OPC_SWINT3,
-  TILEGX_OPC_TBLIDXB0,
-  TILEGX_OPC_TBLIDXB1,
-  TILEGX_OPC_TBLIDXB2,
-  TILEGX_OPC_TBLIDXB3,
-  TILEGX_OPC_V1ADD,
-  TILEGX_OPC_V1ADDI,
-  TILEGX_OPC_V1ADDUC,
-  TILEGX_OPC_V1ADIFFU,
-  TILEGX_OPC_V1AVGU,
-  TILEGX_OPC_V1CMPEQ,
-  TILEGX_OPC_V1CMPEQI,
-  TILEGX_OPC_V1CMPLES,
-  TILEGX_OPC_V1CMPLEU,
-  TILEGX_OPC_V1CMPLTS,
-  TILEGX_OPC_V1CMPLTSI,
-  TILEGX_OPC_V1CMPLTU,
-  TILEGX_OPC_V1CMPLTUI,
-  TILEGX_OPC_V1CMPNE,
-  TILEGX_OPC_V1DDOTPU,
-  TILEGX_OPC_V1DDOTPUA,
-  TILEGX_OPC_V1DDOTPUS,
-  TILEGX_OPC_V1DDOTPUSA,
-  TILEGX_OPC_V1DOTP,
-  TILEGX_OPC_V1DOTPA,
-  TILEGX_OPC_V1DOTPU,
-  TILEGX_OPC_V1DOTPUA,
-  TILEGX_OPC_V1DOTPUS,
-  TILEGX_OPC_V1DOTPUSA,
-  TILEGX_OPC_V1INT_H,
-  TILEGX_OPC_V1INT_L,
-  TILEGX_OPC_V1MAXU,
-  TILEGX_OPC_V1MAXUI,
-  TILEGX_OPC_V1MINU,
-  TILEGX_OPC_V1MINUI,
-  TILEGX_OPC_V1MNZ,
-  TILEGX_OPC_V1MULTU,
-  TILEGX_OPC_V1MULU,
-  TILEGX_OPC_V1MULUS,
-  TILEGX_OPC_V1MZ,
-  TILEGX_OPC_V1SADAU,
-  TILEGX_OPC_V1SADU,
-  TILEGX_OPC_V1SHL,
-  TILEGX_OPC_V1SHLI,
-  TILEGX_OPC_V1SHRS,
-  TILEGX_OPC_V1SHRSI,
-  TILEGX_OPC_V1SHRU,
-  TILEGX_OPC_V1SHRUI,
-  TILEGX_OPC_V1SUB,
-  TILEGX_OPC_V1SUBUC,
-  TILEGX_OPC_V2ADD,
-  TILEGX_OPC_V2ADDI,
-  TILEGX_OPC_V2ADDSC,
-  TILEGX_OPC_V2ADIFFS,
-  TILEGX_OPC_V2AVGS,
-  TILEGX_OPC_V2CMPEQ,
-  TILEGX_OPC_V2CMPEQI,
-  TILEGX_OPC_V2CMPLES,
-  TILEGX_OPC_V2CMPLEU,
-  TILEGX_OPC_V2CMPLTS,
-  TILEGX_OPC_V2CMPLTSI,
-  TILEGX_OPC_V2CMPLTU,
-  TILEGX_OPC_V2CMPLTUI,
-  TILEGX_OPC_V2CMPNE,
-  TILEGX_OPC_V2DOTP,
-  TILEGX_OPC_V2DOTPA,
-  TILEGX_OPC_V2INT_H,
-  TILEGX_OPC_V2INT_L,
-  TILEGX_OPC_V2MAXS,
-  TILEGX_OPC_V2MAXSI,
-  TILEGX_OPC_V2MINS,
-  TILEGX_OPC_V2MINSI,
-  TILEGX_OPC_V2MNZ,
-  TILEGX_OPC_V2MULFSC,
-  TILEGX_OPC_V2MULS,
-  TILEGX_OPC_V2MULTS,
-  TILEGX_OPC_V2MZ,
-  TILEGX_OPC_V2PACKH,
-  TILEGX_OPC_V2PACKL,
-  TILEGX_OPC_V2PACKUC,
-  TILEGX_OPC_V2SADAS,
-  TILEGX_OPC_V2SADAU,
-  TILEGX_OPC_V2SADS,
-  TILEGX_OPC_V2SADU,
-  TILEGX_OPC_V2SHL,
-  TILEGX_OPC_V2SHLI,
-  TILEGX_OPC_V2SHLSC,
-  TILEGX_OPC_V2SHRS,
-  TILEGX_OPC_V2SHRSI,
-  TILEGX_OPC_V2SHRU,
-  TILEGX_OPC_V2SHRUI,
-  TILEGX_OPC_V2SUB,
-  TILEGX_OPC_V2SUBSC,
-  TILEGX_OPC_V4ADD,
-  TILEGX_OPC_V4ADDSC,
-  TILEGX_OPC_V4INT_H,
-  TILEGX_OPC_V4INT_L,
-  TILEGX_OPC_V4PACKSC,
-  TILEGX_OPC_V4SHL,
-  TILEGX_OPC_V4SHLSC,
-  TILEGX_OPC_V4SHRS,
-  TILEGX_OPC_V4SHRU,
-  TILEGX_OPC_V4SUB,
-  TILEGX_OPC_V4SUBSC,
-  TILEGX_OPC_WH64,
-  TILEGX_OPC_XOR,
-  TILEGX_OPC_XORI,
-  TILEGX_OPC_NONE
-} tilegx_mnemonic;
-
-/* 64-bit pattern for a { bpt ; nop } bundle. */
-#define TILEGX_BPT_BUNDLE 0x286a44ae51485000ULL
-
-
-#define TILE_ELF_MACHINE_CODE EM_TILE64
-
-#define TILE_ELF_NAME "elf32-tile64"
-
-
-static __inline unsigned int
-get_BFEnd_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_BFOpcodeExtension_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 24)) & 0xf);
-}
-
-static __inline unsigned int
-get_BFStart_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3f);
-}
-
-static __inline unsigned int
-get_BrOff_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x0000003f) |
-         (((unsigned int)(n >> 37)) & 0x0001ffc0);
-}
-
-static __inline unsigned int
-get_BrType_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 54)) & 0x1f);
-}
-
-static __inline unsigned int
-get_Dest_Imm8_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x0000003f) |
-         (((unsigned int)(n >> 43)) & 0x000000c0);
-}
-
-static __inline unsigned int
-get_Dest_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 0)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Dest_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x3f);
-}
-
-static __inline unsigned int
-get_Imm16_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xffff);
-}
-
-static __inline unsigned int
-get_Imm16_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xffff);
-}
-
-static __inline unsigned int
-get_Imm8OpcodeExtension_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 20)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8OpcodeExtension_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 51)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0xff);
-}
-
-static __inline unsigned int
-get_Imm8_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0xff);
-}
-
-static __inline unsigned int
-get_JumpOff_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x7ffffff);
-}
-
-static __inline unsigned int
-get_JumpOpcodeExtension_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 58)) & 0x1);
-}
-
-static __inline unsigned int
-get_MF_Imm14_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x3fff);
-}
-
-static __inline unsigned int
-get_MT_Imm14_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 31)) & 0x0000003f) |
-         (((unsigned int)(n >> 37)) & 0x00003fc0);
-}
-
-static __inline unsigned int
-get_Mode(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 62)) & 0x3);
-}
-
-static __inline unsigned int
-get_Opcode_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 28)) & 0x7);
-}
-
-static __inline unsigned int
-get_Opcode_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 59)) & 0x7);
-}
-
-static __inline unsigned int
-get_Opcode_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 27)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 58)) & 0xf);
-}
-
-static __inline unsigned int
-get_Opcode_Y2(tilegx_bundle_bits n)
-{
-  return (((n >> 26)) & 0x00000001) |
-         (((unsigned int)(n >> 56)) & 0x00000002);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3);
-}
-
-static __inline unsigned int
-get_RRROpcodeExtension_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x3);
-}
-
-static __inline unsigned int
-get_ShAmt_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_ShAmt_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_ShAmt_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_ShAmt_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_ShiftOpcodeExtension_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_ShiftOpcodeExtension_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x3ff);
-}
-
-static __inline unsigned int
-get_ShiftOpcodeExtension_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 18)) & 0x3);
-}
-
-static __inline unsigned int
-get_ShiftOpcodeExtension_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 49)) & 0x3);
-}
-
-static __inline unsigned int
-get_SrcA_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 6)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 6)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 37)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcA_Y2(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 20)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcBDest_Y2(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 51)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_SrcB_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_UnaryOpcodeExtension_X0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_UnaryOpcodeExtension_X1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-static __inline unsigned int
-get_UnaryOpcodeExtension_Y0(tilegx_bundle_bits num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((n >> 12)) & 0x3f);
-}
-
-static __inline unsigned int
-get_UnaryOpcodeExtension_Y1(tilegx_bundle_bits n)
-{
-  return (((unsigned int)(n >> 43)) & 0x3f);
-}
-
-
-static __inline int
-sign_extend(int n, int num_bits)
-{
-  int shift = (int)(sizeof(int) * 8 - num_bits);
-  return (n << shift) >> shift;
-}
-
-
-
-static __inline tilegx_bundle_bits
-create_BFEnd_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_BFOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xf) << 24);
-}
-
-static __inline tilegx_bundle_bits
-create_BFStart_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 18);
-}
-
-static __inline tilegx_bundle_bits
-create_BrOff_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
-         (((tilegx_bundle_bits)(n & 0x0001ffc0)) << 37);
-}
-
-static __inline tilegx_bundle_bits
-create_BrType_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x1f)) << 54);
-}
-
-static __inline tilegx_bundle_bits
-create_Dest_Imm8_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
-         (((tilegx_bundle_bits)(n & 0x000000c0)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_Dest_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 0);
-}
-
-static __inline tilegx_bundle_bits
-create_Dest_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 31);
-}
-
-static __inline tilegx_bundle_bits
-create_Dest_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 0);
-}
-
-static __inline tilegx_bundle_bits
-create_Dest_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 31);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm16_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xffff) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm16_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0xffff)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8OpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 20);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8OpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0xff)) << 51);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0xff)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xff) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_Imm8_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0xff)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_JumpOff_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x7ffffff)) << 31);
-}
-
-static __inline tilegx_bundle_bits
-create_JumpOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x1)) << 58);
-}
-
-static __inline tilegx_bundle_bits
-create_MF_Imm14_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3fff)) << 37);
-}
-
-static __inline tilegx_bundle_bits
-create_MT_Imm14_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x0000003f)) << 31) |
-         (((tilegx_bundle_bits)(n & 0x00003fc0)) << 37);
-}
-
-static __inline tilegx_bundle_bits
-create_Mode(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3)) << 62);
-}
-
-static __inline tilegx_bundle_bits
-create_Opcode_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x7) << 28);
-}
-
-static __inline tilegx_bundle_bits
-create_Opcode_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x7)) << 59);
-}
-
-static __inline tilegx_bundle_bits
-create_Opcode_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0xf) << 27);
-}
-
-static __inline tilegx_bundle_bits
-create_Opcode_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0xf)) << 58);
-}
-
-static __inline tilegx_bundle_bits
-create_Opcode_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x00000001) << 26) |
-         (((tilegx_bundle_bits)(n & 0x00000002)) << 56);
-}
-
-static __inline tilegx_bundle_bits
-create_RRROpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3ff) << 18);
-}
-
-static __inline tilegx_bundle_bits
-create_RRROpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3ff)) << 49);
-}
-
-static __inline tilegx_bundle_bits
-create_RRROpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 18);
-}
-
-static __inline tilegx_bundle_bits
-create_RRROpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3)) << 49);
-}
-
-static __inline tilegx_bundle_bits
-create_ShAmt_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_ShAmt_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_ShAmt_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_ShAmt_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_ShiftOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3ff) << 18);
-}
-
-static __inline tilegx_bundle_bits
-create_ShiftOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3ff)) << 49);
-}
-
-static __inline tilegx_bundle_bits
-create_ShiftOpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3) << 18);
-}
-
-static __inline tilegx_bundle_bits
-create_ShiftOpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3)) << 49);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcA_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 6);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcA_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 37);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcA_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 6);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcA_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 37);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcA_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 20);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcBDest_Y2(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 51);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcB_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcB_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcB_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_SrcB_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_UnaryOpcodeExtension_X0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_UnaryOpcodeExtension_X1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-static __inline tilegx_bundle_bits
-create_UnaryOpcodeExtension_Y0(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return ((n & 0x3f) << 12);
-}
-
-static __inline tilegx_bundle_bits
-create_UnaryOpcodeExtension_Y1(int num)
-{
-  const unsigned int n = (unsigned int)num;
-  return (((tilegx_bundle_bits)(n & 0x3f)) << 43);
-}
-
-
-typedef enum
-{
-  TILEGX_PIPELINE_X0,
-  TILEGX_PIPELINE_X1,
-  TILEGX_PIPELINE_Y0,
-  TILEGX_PIPELINE_Y1,
-  TILEGX_PIPELINE_Y2,
-} tilegx_pipeline;
-
-#define tilegx_is_x_pipeline(p) ((int)(p) <= (int)TILEGX_PIPELINE_X1)
-
-typedef enum
-{
-  TILEGX_OP_TYPE_REGISTER,
-  TILEGX_OP_TYPE_IMMEDIATE,
-  TILEGX_OP_TYPE_ADDRESS,
-  TILEGX_OP_TYPE_SPR
-} tilegx_operand_type;
-
-/* These are the bits that determine if a bundle is in the X encoding. */
-#define TILEGX_BUNDLE_MODE_MASK ((tilegx_bundle_bits)3 << 62)
-
-enum
-{
-  /* Maximum number of instructions in a bundle (2 for X, 3 for Y). */
-  TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE = 3,
-
-  /* How many different pipeline encodings are there? X0, X1, Y0, Y1, Y2. */
-  TILEGX_NUM_PIPELINE_ENCODINGS = 5,
-
-  /* Log base 2 of TILEGX_BUNDLE_SIZE_IN_BYTES. */
-  TILEGX_LOG2_BUNDLE_SIZE_IN_BYTES = 3,
-
-  /* Instructions take this many bytes. */
-  TILEGX_BUNDLE_SIZE_IN_BYTES = 1 << TILEGX_LOG2_BUNDLE_SIZE_IN_BYTES,
-
-  /* Log base 2 of TILEGX_BUNDLE_ALIGNMENT_IN_BYTES. */
-  TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES = 3,
-
-  /* Bundles should be aligned modulo this number of bytes. */
-  TILEGX_BUNDLE_ALIGNMENT_IN_BYTES =
-    (1 << TILEGX_LOG2_BUNDLE_ALIGNMENT_IN_BYTES),
-
-  /* Number of registers (some are magic, such as network I/O). */
-  TILEGX_NUM_REGISTERS = 64,
-};
-
-
-struct tilegx_operand
-{
-  /* Is this operand a register, immediate or address? */
-  tilegx_operand_type type;
-
-  /* The default relocation type for this operand.  */
-  signed int default_reloc : 16;
-
-  /* How many bits is this value? (used for range checking) */
-  unsigned int num_bits : 5;
-
-  /* Is the value signed? (used for range checking) */
-  unsigned int is_signed : 1;
-
-  /* Is this operand a source register? */
-  unsigned int is_src_reg : 1;
-
-  /* Is this operand written? (i.e. is it a destination register) */
-  unsigned int is_dest_reg : 1;
-
-  /* Is this operand PC-relative? */
-  unsigned int is_pc_relative : 1;
-
-  /* By how many bits do we right shift the value before inserting? */
-  unsigned int rightshift : 2;
-
-  /* Return the bits for this operand to be ORed into an existing bundle. */
-  tilegx_bundle_bits (*insert) (int op);
-
-  /* Extract this operand and return it. */
-  unsigned int (*extract) (tilegx_bundle_bits bundle);
-};
-
-
-extern const struct tilegx_operand tilegx_operands[];
-
-/* One finite-state machine per pipe for rapid instruction decoding. */
-extern const unsigned short * const
-tilegx_bundle_decoder_fsms[TILEGX_NUM_PIPELINE_ENCODINGS];
-
-
-struct tilegx_opcode
-{
-  /* The opcode mnemonic, e.g. "add" */
-  const char *name;
-
-  /* The enum value for this mnemonic. */
-  tilegx_mnemonic mnemonic;
-
-  /* A bit mask of which of the five pipes this instruction
-     is compatible with:
-     X0  0x01
-     X1  0x02
-     Y0  0x04
-     Y1  0x08
-     Y2  0x10 */
-  unsigned char pipes;
-
-  /* How many operands are there? */
-  unsigned char num_operands;
-
-  /* Which register does this write implicitly, or TREG_ZERO if none? */
-  unsigned char implicitly_written_register;
-
-  /* Can this be bundled with other instructions (almost always true). */
-  unsigned char can_bundle;
-
-  /* The description of the operands. Each of these is an
-   * index into the tilegx_operands[] table. */
-  unsigned char operands[TILEGX_NUM_PIPELINE_ENCODINGS][TILEGX_MAX_OPERANDS];
-
-};
-
-extern const struct tilegx_opcode tilegx_opcodes[];
-
-/* Used for non-textual disassembly into structs. */
-struct tilegx_decoded_instruction
-{
-  const struct tilegx_opcode *opcode;
-  const struct tilegx_operand *operands[TILEGX_MAX_OPERANDS];
-  long long operand_values[TILEGX_MAX_OPERANDS];
-};
-
-
-/* Disassemble a bundle into a struct for machine processing. */
-extern int parse_insn_tilegx(tilegx_bundle_bits bits,
-                             unsigned long long pc,
-                             struct tilegx_decoded_instruction
-                             decoded[TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE]);
-
-
-
-#endif /* opcode_tilegx_h */
diff --git a/arch/tile/include/asm/opcode_constants.h b/arch/tile/include/asm/opcode_constants.h
deleted file mode 100644
index 37a9f29..0000000
--- a/arch/tile/include/asm/opcode_constants.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_OPCODE_CONSTANTS_H
-#define _ASM_TILE_OPCODE_CONSTANTS_H
-
-#include <arch/chip.h>
-
-#if CHIP_WORD_SIZE() == 64
-#include <asm/opcode_constants_64.h>
-#else
-#include <asm/opcode_constants_32.h>
-#endif
-
-#endif /* _ASM_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/opcode_constants_32.h b/arch/tile/include/asm/opcode_constants_32.h
deleted file mode 100644
index 227d033..0000000
--- a/arch/tile/include/asm/opcode_constants_32.h
+++ /dev/null
@@ -1,480 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-/* This file is machine-generated; DO NOT EDIT! */
-
-
-#ifndef _TILE_OPCODE_CONSTANTS_H
-#define _TILE_OPCODE_CONSTANTS_H
-enum
-{
-  ADDBS_U_SPECIAL_0_OPCODE_X0 = 98,
-  ADDBS_U_SPECIAL_0_OPCODE_X1 = 68,
-  ADDB_SPECIAL_0_OPCODE_X0 = 1,
-  ADDB_SPECIAL_0_OPCODE_X1 = 1,
-  ADDHS_SPECIAL_0_OPCODE_X0 = 99,
-  ADDHS_SPECIAL_0_OPCODE_X1 = 69,
-  ADDH_SPECIAL_0_OPCODE_X0 = 2,
-  ADDH_SPECIAL_0_OPCODE_X1 = 2,
-  ADDIB_IMM_0_OPCODE_X0 = 1,
-  ADDIB_IMM_0_OPCODE_X1 = 1,
-  ADDIH_IMM_0_OPCODE_X0 = 2,
-  ADDIH_IMM_0_OPCODE_X1 = 2,
-  ADDI_IMM_0_OPCODE_X0 = 3,
-  ADDI_IMM_0_OPCODE_X1 = 3,
-  ADDI_IMM_1_OPCODE_SN = 1,
-  ADDI_OPCODE_Y0 = 9,
-  ADDI_OPCODE_Y1 = 7,
-  ADDLIS_OPCODE_X0 = 1,
-  ADDLIS_OPCODE_X1 = 2,
-  ADDLI_OPCODE_X0 = 2,
-  ADDLI_OPCODE_X1 = 3,
-  ADDS_SPECIAL_0_OPCODE_X0 = 96,
-  ADDS_SPECIAL_0_OPCODE_X1 = 66,
-  ADD_SPECIAL_0_OPCODE_X0 = 3,
-  ADD_SPECIAL_0_OPCODE_X1 = 3,
-  ADD_SPECIAL_0_OPCODE_Y0 = 0,
-  ADD_SPECIAL_0_OPCODE_Y1 = 0,
-  ADIFFB_U_SPECIAL_0_OPCODE_X0 = 4,
-  ADIFFH_SPECIAL_0_OPCODE_X0 = 5,
-  ANDI_IMM_0_OPCODE_X0 = 1,
-  ANDI_IMM_0_OPCODE_X1 = 4,
-  ANDI_OPCODE_Y0 = 10,
-  ANDI_OPCODE_Y1 = 8,
-  AND_SPECIAL_0_OPCODE_X0 = 6,
-  AND_SPECIAL_0_OPCODE_X1 = 4,
-  AND_SPECIAL_2_OPCODE_Y0 = 0,
-  AND_SPECIAL_2_OPCODE_Y1 = 0,
-  AULI_OPCODE_X0 = 3,
-  AULI_OPCODE_X1 = 4,
-  AVGB_U_SPECIAL_0_OPCODE_X0 = 7,
-  AVGH_SPECIAL_0_OPCODE_X0 = 8,
-  BBNST_BRANCH_OPCODE_X1 = 15,
-  BBNS_BRANCH_OPCODE_X1 = 14,
-  BBNS_OPCODE_SN = 63,
-  BBST_BRANCH_OPCODE_X1 = 13,
-  BBS_BRANCH_OPCODE_X1 = 12,
-  BBS_OPCODE_SN = 62,
-  BGEZT_BRANCH_OPCODE_X1 = 7,
-  BGEZ_BRANCH_OPCODE_X1 = 6,
-  BGEZ_OPCODE_SN = 61,
-  BGZT_BRANCH_OPCODE_X1 = 5,
-  BGZ_BRANCH_OPCODE_X1 = 4,
-  BGZ_OPCODE_SN = 58,
-  BITX_UN_0_SHUN_0_OPCODE_X0 = 1,
-  BITX_UN_0_SHUN_0_OPCODE_Y0 = 1,
-  BLEZT_BRANCH_OPCODE_X1 = 11,
-  BLEZ_BRANCH_OPCODE_X1 = 10,
-  BLEZ_OPCODE_SN = 59,
-  BLZT_BRANCH_OPCODE_X1 = 9,
-  BLZ_BRANCH_OPCODE_X1 = 8,
-  BLZ_OPCODE_SN = 60,
-  BNZT_BRANCH_OPCODE_X1 = 3,
-  BNZ_BRANCH_OPCODE_X1 = 2,
-  BNZ_OPCODE_SN = 57,
-  BPT_NOREG_RR_IMM_0_OPCODE_SN = 1,
-  BRANCH_OPCODE_X1 = 5,
-  BYTEX_UN_0_SHUN_0_OPCODE_X0 = 2,
-  BYTEX_UN_0_SHUN_0_OPCODE_Y0 = 2,
-  BZT_BRANCH_OPCODE_X1 = 1,
-  BZ_BRANCH_OPCODE_X1 = 0,
-  BZ_OPCODE_SN = 56,
-  CLZ_UN_0_SHUN_0_OPCODE_X0 = 3,
-  CLZ_UN_0_SHUN_0_OPCODE_Y0 = 3,
-  CRC32_32_SPECIAL_0_OPCODE_X0 = 9,
-  CRC32_8_SPECIAL_0_OPCODE_X0 = 10,
-  CTZ_UN_0_SHUN_0_OPCODE_X0 = 4,
-  CTZ_UN_0_SHUN_0_OPCODE_Y0 = 4,
-  DRAIN_UN_0_SHUN_0_OPCODE_X1 = 1,
-  DTLBPR_UN_0_SHUN_0_OPCODE_X1 = 2,
-  DWORD_ALIGN_SPECIAL_0_OPCODE_X0 = 95,
-  FINV_UN_0_SHUN_0_OPCODE_X1 = 3,
-  FLUSH_UN_0_SHUN_0_OPCODE_X1 = 4,
-  FNOP_NOREG_RR_IMM_0_OPCODE_SN = 3,
-  FNOP_UN_0_SHUN_0_OPCODE_X0 = 5,
-  FNOP_UN_0_SHUN_0_OPCODE_X1 = 5,
-  FNOP_UN_0_SHUN_0_OPCODE_Y0 = 5,
-  FNOP_UN_0_SHUN_0_OPCODE_Y1 = 1,
-  HALT_NOREG_RR_IMM_0_OPCODE_SN = 0,
-  ICOH_UN_0_SHUN_0_OPCODE_X1 = 6,
-  ILL_UN_0_SHUN_0_OPCODE_X1 = 7,
-  ILL_UN_0_SHUN_0_OPCODE_Y1 = 2,
-  IMM_0_OPCODE_SN = 0,
-  IMM_0_OPCODE_X0 = 4,
-  IMM_0_OPCODE_X1 = 6,
-  IMM_1_OPCODE_SN = 1,
-  IMM_OPCODE_0_X0 = 5,
-  INTHB_SPECIAL_0_OPCODE_X0 = 11,
-  INTHB_SPECIAL_0_OPCODE_X1 = 5,
-  INTHH_SPECIAL_0_OPCODE_X0 = 12,
-  INTHH_SPECIAL_0_OPCODE_X1 = 6,
-  INTLB_SPECIAL_0_OPCODE_X0 = 13,
-  INTLB_SPECIAL_0_OPCODE_X1 = 7,
-  INTLH_SPECIAL_0_OPCODE_X0 = 14,
-  INTLH_SPECIAL_0_OPCODE_X1 = 8,
-  INV_UN_0_SHUN_0_OPCODE_X1 = 8,
-  IRET_UN_0_SHUN_0_OPCODE_X1 = 9,
-  JALB_OPCODE_X1 = 13,
-  JALF_OPCODE_X1 = 12,
-  JALRP_SPECIAL_0_OPCODE_X1 = 9,
-  JALRR_IMM_1_OPCODE_SN = 3,
-  JALR_RR_IMM_0_OPCODE_SN = 5,
-  JALR_SPECIAL_0_OPCODE_X1 = 10,
-  JB_OPCODE_X1 = 11,
-  JF_OPCODE_X1 = 10,
-  JRP_SPECIAL_0_OPCODE_X1 = 11,
-  JRR_IMM_1_OPCODE_SN = 2,
-  JR_RR_IMM_0_OPCODE_SN = 4,
-  JR_SPECIAL_0_OPCODE_X1 = 12,
-  LBADD_IMM_0_OPCODE_X1 = 22,
-  LBADD_U_IMM_0_OPCODE_X1 = 23,
-  LB_OPCODE_Y2 = 0,
-  LB_UN_0_SHUN_0_OPCODE_X1 = 10,
-  LB_U_OPCODE_Y2 = 1,
-  LB_U_UN_0_SHUN_0_OPCODE_X1 = 11,
-  LHADD_IMM_0_OPCODE_X1 = 24,
-  LHADD_U_IMM_0_OPCODE_X1 = 25,
-  LH_OPCODE_Y2 = 2,
-  LH_UN_0_SHUN_0_OPCODE_X1 = 12,
-  LH_U_OPCODE_Y2 = 3,
-  LH_U_UN_0_SHUN_0_OPCODE_X1 = 13,
-  LNK_SPECIAL_0_OPCODE_X1 = 13,
-  LWADD_IMM_0_OPCODE_X1 = 26,
-  LWADD_NA_IMM_0_OPCODE_X1 = 27,
-  LW_NA_UN_0_SHUN_0_OPCODE_X1 = 24,
-  LW_OPCODE_Y2 = 4,
-  LW_UN_0_SHUN_0_OPCODE_X1 = 14,
-  MAXB_U_SPECIAL_0_OPCODE_X0 = 15,
-  MAXB_U_SPECIAL_0_OPCODE_X1 = 14,
-  MAXH_SPECIAL_0_OPCODE_X0 = 16,
-  MAXH_SPECIAL_0_OPCODE_X1 = 15,
-  MAXIB_U_IMM_0_OPCODE_X0 = 4,
-  MAXIB_U_IMM_0_OPCODE_X1 = 5,
-  MAXIH_IMM_0_OPCODE_X0 = 5,
-  MAXIH_IMM_0_OPCODE_X1 = 6,
-  MFSPR_IMM_0_OPCODE_X1 = 7,
-  MF_UN_0_SHUN_0_OPCODE_X1 = 15,
-  MINB_U_SPECIAL_0_OPCODE_X0 = 17,
-  MINB_U_SPECIAL_0_OPCODE_X1 = 16,
-  MINH_SPECIAL_0_OPCODE_X0 = 18,
-  MINH_SPECIAL_0_OPCODE_X1 = 17,
-  MINIB_U_IMM_0_OPCODE_X0 = 6,
-  MINIB_U_IMM_0_OPCODE_X1 = 8,
-  MINIH_IMM_0_OPCODE_X0 = 7,
-  MINIH_IMM_0_OPCODE_X1 = 9,
-  MM_OPCODE_X0 = 6,
-  MM_OPCODE_X1 = 7,
-  MNZB_SPECIAL_0_OPCODE_X0 = 19,
-  MNZB_SPECIAL_0_OPCODE_X1 = 18,
-  MNZH_SPECIAL_0_OPCODE_X0 = 20,
-  MNZH_SPECIAL_0_OPCODE_X1 = 19,
-  MNZ_SPECIAL_0_OPCODE_X0 = 21,
-  MNZ_SPECIAL_0_OPCODE_X1 = 20,
-  MNZ_SPECIAL_1_OPCODE_Y0 = 0,
-  MNZ_SPECIAL_1_OPCODE_Y1 = 1,
-  MOVEI_IMM_1_OPCODE_SN = 0,
-  MOVE_RR_IMM_0_OPCODE_SN = 8,
-  MTSPR_IMM_0_OPCODE_X1 = 10,
-  MULHHA_SS_SPECIAL_0_OPCODE_X0 = 22,
-  MULHHA_SS_SPECIAL_7_OPCODE_Y0 = 0,
-  MULHHA_SU_SPECIAL_0_OPCODE_X0 = 23,
-  MULHHA_UU_SPECIAL_0_OPCODE_X0 = 24,
-  MULHHA_UU_SPECIAL_7_OPCODE_Y0 = 1,
-  MULHHSA_UU_SPECIAL_0_OPCODE_X0 = 25,
-  MULHH_SS_SPECIAL_0_OPCODE_X0 = 26,
-  MULHH_SS_SPECIAL_6_OPCODE_Y0 = 0,
-  MULHH_SU_SPECIAL_0_OPCODE_X0 = 27,
-  MULHH_UU_SPECIAL_0_OPCODE_X0 = 28,
-  MULHH_UU_SPECIAL_6_OPCODE_Y0 = 1,
-  MULHLA_SS_SPECIAL_0_OPCODE_X0 = 29,
-  MULHLA_SU_SPECIAL_0_OPCODE_X0 = 30,
-  MULHLA_US_SPECIAL_0_OPCODE_X0 = 31,
-  MULHLA_UU_SPECIAL_0_OPCODE_X0 = 32,
-  MULHLSA_UU_SPECIAL_0_OPCODE_X0 = 33,
-  MULHLSA_UU_SPECIAL_5_OPCODE_Y0 = 0,
-  MULHL_SS_SPECIAL_0_OPCODE_X0 = 34,
-  MULHL_SU_SPECIAL_0_OPCODE_X0 = 35,
-  MULHL_US_SPECIAL_0_OPCODE_X0 = 36,
-  MULHL_UU_SPECIAL_0_OPCODE_X0 = 37,
-  MULLLA_SS_SPECIAL_0_OPCODE_X0 = 38,
-  MULLLA_SS_SPECIAL_7_OPCODE_Y0 = 2,
-  MULLLA_SU_SPECIAL_0_OPCODE_X0 = 39,
-  MULLLA_UU_SPECIAL_0_OPCODE_X0 = 40,
-  MULLLA_UU_SPECIAL_7_OPCODE_Y0 = 3,
-  MULLLSA_UU_SPECIAL_0_OPCODE_X0 = 41,
-  MULLL_SS_SPECIAL_0_OPCODE_X0 = 42,
-  MULLL_SS_SPECIAL_6_OPCODE_Y0 = 2,
-  MULLL_SU_SPECIAL_0_OPCODE_X0 = 43,
-  MULLL_UU_SPECIAL_0_OPCODE_X0 = 44,
-  MULLL_UU_SPECIAL_6_OPCODE_Y0 = 3,
-  MVNZ_SPECIAL_0_OPCODE_X0 = 45,
-  MVNZ_SPECIAL_1_OPCODE_Y0 = 1,
-  MVZ_SPECIAL_0_OPCODE_X0 = 46,
-  MVZ_SPECIAL_1_OPCODE_Y0 = 2,
-  MZB_SPECIAL_0_OPCODE_X0 = 47,
-  MZB_SPECIAL_0_OPCODE_X1 = 21,
-  MZH_SPECIAL_0_OPCODE_X0 = 48,
-  MZH_SPECIAL_0_OPCODE_X1 = 22,
-  MZ_SPECIAL_0_OPCODE_X0 = 49,
-  MZ_SPECIAL_0_OPCODE_X1 = 23,
-  MZ_SPECIAL_1_OPCODE_Y0 = 3,
-  MZ_SPECIAL_1_OPCODE_Y1 = 2,
-  NAP_UN_0_SHUN_0_OPCODE_X1 = 16,
-  NOP_NOREG_RR_IMM_0_OPCODE_SN = 2,
-  NOP_UN_0_SHUN_0_OPCODE_X0 = 6,
-  NOP_UN_0_SHUN_0_OPCODE_X1 = 17,
-  NOP_UN_0_SHUN_0_OPCODE_Y0 = 6,
-  NOP_UN_0_SHUN_0_OPCODE_Y1 = 3,
-  NOREG_RR_IMM_0_OPCODE_SN = 0,
-  NOR_SPECIAL_0_OPCODE_X0 = 50,
-  NOR_SPECIAL_0_OPCODE_X1 = 24,
-  NOR_SPECIAL_2_OPCODE_Y0 = 1,
-  NOR_SPECIAL_2_OPCODE_Y1 = 1,
-  ORI_IMM_0_OPCODE_X0 = 8,
-  ORI_IMM_0_OPCODE_X1 = 11,
-  ORI_OPCODE_Y0 = 11,
-  ORI_OPCODE_Y1 = 9,
-  OR_SPECIAL_0_OPCODE_X0 = 51,
-  OR_SPECIAL_0_OPCODE_X1 = 25,
-  OR_SPECIAL_2_OPCODE_Y0 = 2,
-  OR_SPECIAL_2_OPCODE_Y1 = 2,
-  PACKBS_U_SPECIAL_0_OPCODE_X0 = 103,
-  PACKBS_U_SPECIAL_0_OPCODE_X1 = 73,
-  PACKHB_SPECIAL_0_OPCODE_X0 = 52,
-  PACKHB_SPECIAL_0_OPCODE_X1 = 26,
-  PACKHS_SPECIAL_0_OPCODE_X0 = 102,
-  PACKHS_SPECIAL_0_OPCODE_X1 = 72,
-  PACKLB_SPECIAL_0_OPCODE_X0 = 53,
-  PACKLB_SPECIAL_0_OPCODE_X1 = 27,
-  PCNT_UN_0_SHUN_0_OPCODE_X0 = 7,
-  PCNT_UN_0_SHUN_0_OPCODE_Y0 = 7,
-  RLI_SHUN_0_OPCODE_X0 = 1,
-  RLI_SHUN_0_OPCODE_X1 = 1,
-  RLI_SHUN_0_OPCODE_Y0 = 1,
-  RLI_SHUN_0_OPCODE_Y1 = 1,
-  RL_SPECIAL_0_OPCODE_X0 = 54,
-  RL_SPECIAL_0_OPCODE_X1 = 28,
-  RL_SPECIAL_3_OPCODE_Y0 = 0,
-  RL_SPECIAL_3_OPCODE_Y1 = 0,
-  RR_IMM_0_OPCODE_SN = 0,
-  S1A_SPECIAL_0_OPCODE_X0 = 55,
-  S1A_SPECIAL_0_OPCODE_X1 = 29,
-  S1A_SPECIAL_0_OPCODE_Y0 = 1,
-  S1A_SPECIAL_0_OPCODE_Y1 = 1,
-  S2A_SPECIAL_0_OPCODE_X0 = 56,
-  S2A_SPECIAL_0_OPCODE_X1 = 30,
-  S2A_SPECIAL_0_OPCODE_Y0 = 2,
-  S2A_SPECIAL_0_OPCODE_Y1 = 2,
-  S3A_SPECIAL_0_OPCODE_X0 = 57,
-  S3A_SPECIAL_0_OPCODE_X1 = 31,
-  S3A_SPECIAL_5_OPCODE_Y0 = 1,
-  S3A_SPECIAL_5_OPCODE_Y1 = 1,
-  SADAB_U_SPECIAL_0_OPCODE_X0 = 58,
-  SADAH_SPECIAL_0_OPCODE_X0 = 59,
-  SADAH_U_SPECIAL_0_OPCODE_X0 = 60,
-  SADB_U_SPECIAL_0_OPCODE_X0 = 61,
-  SADH_SPECIAL_0_OPCODE_X0 = 62,
-  SADH_U_SPECIAL_0_OPCODE_X0 = 63,
-  SBADD_IMM_0_OPCODE_X1 = 28,
-  SB_OPCODE_Y2 = 5,
-  SB_SPECIAL_0_OPCODE_X1 = 32,
-  SEQB_SPECIAL_0_OPCODE_X0 = 64,
-  SEQB_SPECIAL_0_OPCODE_X1 = 33,
-  SEQH_SPECIAL_0_OPCODE_X0 = 65,
-  SEQH_SPECIAL_0_OPCODE_X1 = 34,
-  SEQIB_IMM_0_OPCODE_X0 = 9,
-  SEQIB_IMM_0_OPCODE_X1 = 12,
-  SEQIH_IMM_0_OPCODE_X0 = 10,
-  SEQIH_IMM_0_OPCODE_X1 = 13,
-  SEQI_IMM_0_OPCODE_X0 = 11,
-  SEQI_IMM_0_OPCODE_X1 = 14,
-  SEQI_OPCODE_Y0 = 12,
-  SEQI_OPCODE_Y1 = 10,
-  SEQ_SPECIAL_0_OPCODE_X0 = 66,
-  SEQ_SPECIAL_0_OPCODE_X1 = 35,
-  SEQ_SPECIAL_5_OPCODE_Y0 = 2,
-  SEQ_SPECIAL_5_OPCODE_Y1 = 2,
-  SHADD_IMM_0_OPCODE_X1 = 29,
-  SHL8II_IMM_0_OPCODE_SN = 3,
-  SHLB_SPECIAL_0_OPCODE_X0 = 67,
-  SHLB_SPECIAL_0_OPCODE_X1 = 36,
-  SHLH_SPECIAL_0_OPCODE_X0 = 68,
-  SHLH_SPECIAL_0_OPCODE_X1 = 37,
-  SHLIB_SHUN_0_OPCODE_X0 = 2,
-  SHLIB_SHUN_0_OPCODE_X1 = 2,
-  SHLIH_SHUN_0_OPCODE_X0 = 3,
-  SHLIH_SHUN_0_OPCODE_X1 = 3,
-  SHLI_SHUN_0_OPCODE_X0 = 4,
-  SHLI_SHUN_0_OPCODE_X1 = 4,
-  SHLI_SHUN_0_OPCODE_Y0 = 2,
-  SHLI_SHUN_0_OPCODE_Y1 = 2,
-  SHL_SPECIAL_0_OPCODE_X0 = 69,
-  SHL_SPECIAL_0_OPCODE_X1 = 38,
-  SHL_SPECIAL_3_OPCODE_Y0 = 1,
-  SHL_SPECIAL_3_OPCODE_Y1 = 1,
-  SHR1_RR_IMM_0_OPCODE_SN = 9,
-  SHRB_SPECIAL_0_OPCODE_X0 = 70,
-  SHRB_SPECIAL_0_OPCODE_X1 = 39,
-  SHRH_SPECIAL_0_OPCODE_X0 = 71,
-  SHRH_SPECIAL_0_OPCODE_X1 = 40,
-  SHRIB_SHUN_0_OPCODE_X0 = 5,
-  SHRIB_SHUN_0_OPCODE_X1 = 5,
-  SHRIH_SHUN_0_OPCODE_X0 = 6,
-  SHRIH_SHUN_0_OPCODE_X1 = 6,
-  SHRI_SHUN_0_OPCODE_X0 = 7,
-  SHRI_SHUN_0_OPCODE_X1 = 7,
-  SHRI_SHUN_0_OPCODE_Y0 = 3,
-  SHRI_SHUN_0_OPCODE_Y1 = 3,
-  SHR_SPECIAL_0_OPCODE_X0 = 72,
-  SHR_SPECIAL_0_OPCODE_X1 = 41,
-  SHR_SPECIAL_3_OPCODE_Y0 = 2,
-  SHR_SPECIAL_3_OPCODE_Y1 = 2,
-  SHUN_0_OPCODE_X0 = 7,
-  SHUN_0_OPCODE_X1 = 8,
-  SHUN_0_OPCODE_Y0 = 13,
-  SHUN_0_OPCODE_Y1 = 11,
-  SH_OPCODE_Y2 = 6,
-  SH_SPECIAL_0_OPCODE_X1 = 42,
-  SLTB_SPECIAL_0_OPCODE_X0 = 73,
-  SLTB_SPECIAL_0_OPCODE_X1 = 43,
-  SLTB_U_SPECIAL_0_OPCODE_X0 = 74,
-  SLTB_U_SPECIAL_0_OPCODE_X1 = 44,
-  SLTEB_SPECIAL_0_OPCODE_X0 = 75,
-  SLTEB_SPECIAL_0_OPCODE_X1 = 45,
-  SLTEB_U_SPECIAL_0_OPCODE_X0 = 76,
-  SLTEB_U_SPECIAL_0_OPCODE_X1 = 46,
-  SLTEH_SPECIAL_0_OPCODE_X0 = 77,
-  SLTEH_SPECIAL_0_OPCODE_X1 = 47,
-  SLTEH_U_SPECIAL_0_OPCODE_X0 = 78,
-  SLTEH_U_SPECIAL_0_OPCODE_X1 = 48,
-  SLTE_SPECIAL_0_OPCODE_X0 = 79,
-  SLTE_SPECIAL_0_OPCODE_X1 = 49,
-  SLTE_SPECIAL_4_OPCODE_Y0 = 0,
-  SLTE_SPECIAL_4_OPCODE_Y1 = 0,
-  SLTE_U_SPECIAL_0_OPCODE_X0 = 80,
-  SLTE_U_SPECIAL_0_OPCODE_X1 = 50,
-  SLTE_U_SPECIAL_4_OPCODE_Y0 = 1,
-  SLTE_U_SPECIAL_4_OPCODE_Y1 = 1,
-  SLTH_SPECIAL_0_OPCODE_X0 = 81,
-  SLTH_SPECIAL_0_OPCODE_X1 = 51,
-  SLTH_U_SPECIAL_0_OPCODE_X0 = 82,
-  SLTH_U_SPECIAL_0_OPCODE_X1 = 52,
-  SLTIB_IMM_0_OPCODE_X0 = 12,
-  SLTIB_IMM_0_OPCODE_X1 = 15,
-  SLTIB_U_IMM_0_OPCODE_X0 = 13,
-  SLTIB_U_IMM_0_OPCODE_X1 = 16,
-  SLTIH_IMM_0_OPCODE_X0 = 14,
-  SLTIH_IMM_0_OPCODE_X1 = 17,
-  SLTIH_U_IMM_0_OPCODE_X0 = 15,
-  SLTIH_U_IMM_0_OPCODE_X1 = 18,
-  SLTI_IMM_0_OPCODE_X0 = 16,
-  SLTI_IMM_0_OPCODE_X1 = 19,
-  SLTI_OPCODE_Y0 = 14,
-  SLTI_OPCODE_Y1 = 12,
-  SLTI_U_IMM_0_OPCODE_X0 = 17,
-  SLTI_U_IMM_0_OPCODE_X1 = 20,
-  SLTI_U_OPCODE_Y0 = 15,
-  SLTI_U_OPCODE_Y1 = 13,
-  SLT_SPECIAL_0_OPCODE_X0 = 83,
-  SLT_SPECIAL_0_OPCODE_X1 = 53,
-  SLT_SPECIAL_4_OPCODE_Y0 = 2,
-  SLT_SPECIAL_4_OPCODE_Y1 = 2,
-  SLT_U_SPECIAL_0_OPCODE_X0 = 84,
-  SLT_U_SPECIAL_0_OPCODE_X1 = 54,
-  SLT_U_SPECIAL_4_OPCODE_Y0 = 3,
-  SLT_U_SPECIAL_4_OPCODE_Y1 = 3,
-  SNEB_SPECIAL_0_OPCODE_X0 = 85,
-  SNEB_SPECIAL_0_OPCODE_X1 = 55,
-  SNEH_SPECIAL_0_OPCODE_X0 = 86,
-  SNEH_SPECIAL_0_OPCODE_X1 = 56,
-  SNE_SPECIAL_0_OPCODE_X0 = 87,
-  SNE_SPECIAL_0_OPCODE_X1 = 57,
-  SNE_SPECIAL_5_OPCODE_Y0 = 3,
-  SNE_SPECIAL_5_OPCODE_Y1 = 3,
-  SPECIAL_0_OPCODE_X0 = 0,
-  SPECIAL_0_OPCODE_X1 = 1,
-  SPECIAL_0_OPCODE_Y0 = 1,
-  SPECIAL_0_OPCODE_Y1 = 1,
-  SPECIAL_1_OPCODE_Y0 = 2,
-  SPECIAL_1_OPCODE_Y1 = 2,
-  SPECIAL_2_OPCODE_Y0 = 3,
-  SPECIAL_2_OPCODE_Y1 = 3,
-  SPECIAL_3_OPCODE_Y0 = 4,
-  SPECIAL_3_OPCODE_Y1 = 4,
-  SPECIAL_4_OPCODE_Y0 = 5,
-  SPECIAL_4_OPCODE_Y1 = 5,
-  SPECIAL_5_OPCODE_Y0 = 6,
-  SPECIAL_5_OPCODE_Y1 = 6,
-  SPECIAL_6_OPCODE_Y0 = 7,
-  SPECIAL_7_OPCODE_Y0 = 8,
-  SRAB_SPECIAL_0_OPCODE_X0 = 88,
-  SRAB_SPECIAL_0_OPCODE_X1 = 58,
-  SRAH_SPECIAL_0_OPCODE_X0 = 89,
-  SRAH_SPECIAL_0_OPCODE_X1 = 59,
-  SRAIB_SHUN_0_OPCODE_X0 = 8,
-  SRAIB_SHUN_0_OPCODE_X1 = 8,
-  SRAIH_SHUN_0_OPCODE_X0 = 9,
-  SRAIH_SHUN_0_OPCODE_X1 = 9,
-  SRAI_SHUN_0_OPCODE_X0 = 10,
-  SRAI_SHUN_0_OPCODE_X1 = 10,
-  SRAI_SHUN_0_OPCODE_Y0 = 4,
-  SRAI_SHUN_0_OPCODE_Y1 = 4,
-  SRA_SPECIAL_0_OPCODE_X0 = 90,
-  SRA_SPECIAL_0_OPCODE_X1 = 60,
-  SRA_SPECIAL_3_OPCODE_Y0 = 3,
-  SRA_SPECIAL_3_OPCODE_Y1 = 3,
-  SUBBS_U_SPECIAL_0_OPCODE_X0 = 100,
-  SUBBS_U_SPECIAL_0_OPCODE_X1 = 70,
-  SUBB_SPECIAL_0_OPCODE_X0 = 91,
-  SUBB_SPECIAL_0_OPCODE_X1 = 61,
-  SUBHS_SPECIAL_0_OPCODE_X0 = 101,
-  SUBHS_SPECIAL_0_OPCODE_X1 = 71,
-  SUBH_SPECIAL_0_OPCODE_X0 = 92,
-  SUBH_SPECIAL_0_OPCODE_X1 = 62,
-  SUBS_SPECIAL_0_OPCODE_X0 = 97,
-  SUBS_SPECIAL_0_OPCODE_X1 = 67,
-  SUB_SPECIAL_0_OPCODE_X0 = 93,
-  SUB_SPECIAL_0_OPCODE_X1 = 63,
-  SUB_SPECIAL_0_OPCODE_Y0 = 3,
-  SUB_SPECIAL_0_OPCODE_Y1 = 3,
-  SWADD_IMM_0_OPCODE_X1 = 30,
-  SWINT0_UN_0_SHUN_0_OPCODE_X1 = 18,
-  SWINT1_UN_0_SHUN_0_OPCODE_X1 = 19,
-  SWINT2_UN_0_SHUN_0_OPCODE_X1 = 20,
-  SWINT3_UN_0_SHUN_0_OPCODE_X1 = 21,
-  SW_OPCODE_Y2 = 7,
-  SW_SPECIAL_0_OPCODE_X1 = 64,
-  TBLIDXB0_UN_0_SHUN_0_OPCODE_X0 = 8,
-  TBLIDXB0_UN_0_SHUN_0_OPCODE_Y0 = 8,
-  TBLIDXB1_UN_0_SHUN_0_OPCODE_X0 = 9,
-  TBLIDXB1_UN_0_SHUN_0_OPCODE_Y0 = 9,
-  TBLIDXB2_UN_0_SHUN_0_OPCODE_X0 = 10,
-  TBLIDXB2_UN_0_SHUN_0_OPCODE_Y0 = 10,
-  TBLIDXB3_UN_0_SHUN_0_OPCODE_X0 = 11,
-  TBLIDXB3_UN_0_SHUN_0_OPCODE_Y0 = 11,
-  TNS_UN_0_SHUN_0_OPCODE_X1 = 22,
-  UN_0_SHUN_0_OPCODE_X0 = 11,
-  UN_0_SHUN_0_OPCODE_X1 = 11,
-  UN_0_SHUN_0_OPCODE_Y0 = 5,
-  UN_0_SHUN_0_OPCODE_Y1 = 5,
-  WH64_UN_0_SHUN_0_OPCODE_X1 = 23,
-  XORI_IMM_0_OPCODE_X0 = 2,
-  XORI_IMM_0_OPCODE_X1 = 21,
-  XOR_SPECIAL_0_OPCODE_X0 = 94,
-  XOR_SPECIAL_0_OPCODE_X1 = 65,
-  XOR_SPECIAL_2_OPCODE_Y0 = 3,
-  XOR_SPECIAL_2_OPCODE_Y1 = 3
-};
-
-#endif /* !_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/opcode_constants_64.h b/arch/tile/include/asm/opcode_constants_64.h
deleted file mode 100644
index 7101928..0000000
--- a/arch/tile/include/asm/opcode_constants_64.h
+++ /dev/null
@@ -1,609 +0,0 @@
-/*
- * Copyright 2011 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-/* This file is machine-generated; DO NOT EDIT! */
-
-
-#ifndef _TILE_OPCODE_CONSTANTS_H
-#define _TILE_OPCODE_CONSTANTS_H
-enum
-{
-  ADDI_IMM8_OPCODE_X0 = 1,
-  ADDI_IMM8_OPCODE_X1 = 1,
-  ADDI_OPCODE_Y0 = 0,
-  ADDI_OPCODE_Y1 = 1,
-  ADDLI_OPCODE_X0 = 1,
-  ADDLI_OPCODE_X1 = 0,
-  ADDXI_IMM8_OPCODE_X0 = 2,
-  ADDXI_IMM8_OPCODE_X1 = 2,
-  ADDXI_OPCODE_Y0 = 1,
-  ADDXI_OPCODE_Y1 = 2,
-  ADDXLI_OPCODE_X0 = 2,
-  ADDXLI_OPCODE_X1 = 1,
-  ADDXSC_RRR_0_OPCODE_X0 = 1,
-  ADDXSC_RRR_0_OPCODE_X1 = 1,
-  ADDX_RRR_0_OPCODE_X0 = 2,
-  ADDX_RRR_0_OPCODE_X1 = 2,
-  ADDX_RRR_0_OPCODE_Y0 = 0,
-  ADDX_SPECIAL_0_OPCODE_Y1 = 0,
-  ADD_RRR_0_OPCODE_X0 = 3,
-  ADD_RRR_0_OPCODE_X1 = 3,
-  ADD_RRR_0_OPCODE_Y0 = 1,
-  ADD_SPECIAL_0_OPCODE_Y1 = 1,
-  ANDI_IMM8_OPCODE_X0 = 3,
-  ANDI_IMM8_OPCODE_X1 = 3,
-  ANDI_OPCODE_Y0 = 2,
-  ANDI_OPCODE_Y1 = 3,
-  AND_RRR_0_OPCODE_X0 = 4,
-  AND_RRR_0_OPCODE_X1 = 4,
-  AND_RRR_5_OPCODE_Y0 = 0,
-  AND_RRR_5_OPCODE_Y1 = 0,
-  BEQZT_BRANCH_OPCODE_X1 = 16,
-  BEQZ_BRANCH_OPCODE_X1 = 17,
-  BFEXTS_BF_OPCODE_X0 = 4,
-  BFEXTU_BF_OPCODE_X0 = 5,
-  BFINS_BF_OPCODE_X0 = 6,
-  BF_OPCODE_X0 = 3,
-  BGEZT_BRANCH_OPCODE_X1 = 18,
-  BGEZ_BRANCH_OPCODE_X1 = 19,
-  BGTZT_BRANCH_OPCODE_X1 = 20,
-  BGTZ_BRANCH_OPCODE_X1 = 21,
-  BLBCT_BRANCH_OPCODE_X1 = 22,
-  BLBC_BRANCH_OPCODE_X1 = 23,
-  BLBST_BRANCH_OPCODE_X1 = 24,
-  BLBS_BRANCH_OPCODE_X1 = 25,
-  BLEZT_BRANCH_OPCODE_X1 = 26,
-  BLEZ_BRANCH_OPCODE_X1 = 27,
-  BLTZT_BRANCH_OPCODE_X1 = 28,
-  BLTZ_BRANCH_OPCODE_X1 = 29,
-  BNEZT_BRANCH_OPCODE_X1 = 30,
-  BNEZ_BRANCH_OPCODE_X1 = 31,
-  BRANCH_OPCODE_X1 = 2,
-  CMOVEQZ_RRR_0_OPCODE_X0 = 5,
-  CMOVEQZ_RRR_4_OPCODE_Y0 = 0,
-  CMOVNEZ_RRR_0_OPCODE_X0 = 6,
-  CMOVNEZ_RRR_4_OPCODE_Y0 = 1,
-  CMPEQI_IMM8_OPCODE_X0 = 4,
-  CMPEQI_IMM8_OPCODE_X1 = 4,
-  CMPEQI_OPCODE_Y0 = 3,
-  CMPEQI_OPCODE_Y1 = 4,
-  CMPEQ_RRR_0_OPCODE_X0 = 7,
-  CMPEQ_RRR_0_OPCODE_X1 = 5,
-  CMPEQ_RRR_3_OPCODE_Y0 = 0,
-  CMPEQ_RRR_3_OPCODE_Y1 = 2,
-  CMPEXCH4_RRR_0_OPCODE_X1 = 6,
-  CMPEXCH_RRR_0_OPCODE_X1 = 7,
-  CMPLES_RRR_0_OPCODE_X0 = 8,
-  CMPLES_RRR_0_OPCODE_X1 = 8,
-  CMPLES_RRR_2_OPCODE_Y0 = 0,
-  CMPLES_RRR_2_OPCODE_Y1 = 0,
-  CMPLEU_RRR_0_OPCODE_X0 = 9,
-  CMPLEU_RRR_0_OPCODE_X1 = 9,
-  CMPLEU_RRR_2_OPCODE_Y0 = 1,
-  CMPLEU_RRR_2_OPCODE_Y1 = 1,
-  CMPLTSI_IMM8_OPCODE_X0 = 5,
-  CMPLTSI_IMM8_OPCODE_X1 = 5,
-  CMPLTSI_OPCODE_Y0 = 4,
-  CMPLTSI_OPCODE_Y1 = 5,
-  CMPLTS_RRR_0_OPCODE_X0 = 10,
-  CMPLTS_RRR_0_OPCODE_X1 = 10,
-  CMPLTS_RRR_2_OPCODE_Y0 = 2,
-  CMPLTS_RRR_2_OPCODE_Y1 = 2,
-  CMPLTUI_IMM8_OPCODE_X0 = 6,
-  CMPLTUI_IMM8_OPCODE_X1 = 6,
-  CMPLTU_RRR_0_OPCODE_X0 = 11,
-  CMPLTU_RRR_0_OPCODE_X1 = 11,
-  CMPLTU_RRR_2_OPCODE_Y0 = 3,
-  CMPLTU_RRR_2_OPCODE_Y1 = 3,
-  CMPNE_RRR_0_OPCODE_X0 = 12,
-  CMPNE_RRR_0_OPCODE_X1 = 12,
-  CMPNE_RRR_3_OPCODE_Y0 = 1,
-  CMPNE_RRR_3_OPCODE_Y1 = 3,
-  CMULAF_RRR_0_OPCODE_X0 = 13,
-  CMULA_RRR_0_OPCODE_X0 = 14,
-  CMULFR_RRR_0_OPCODE_X0 = 15,
-  CMULF_RRR_0_OPCODE_X0 = 16,
-  CMULHR_RRR_0_OPCODE_X0 = 17,
-  CMULH_RRR_0_OPCODE_X0 = 18,
-  CMUL_RRR_0_OPCODE_X0 = 19,
-  CNTLZ_UNARY_OPCODE_X0 = 1,
-  CNTLZ_UNARY_OPCODE_Y0 = 1,
-  CNTTZ_UNARY_OPCODE_X0 = 2,
-  CNTTZ_UNARY_OPCODE_Y0 = 2,
-  CRC32_32_RRR_0_OPCODE_X0 = 20,
-  CRC32_8_RRR_0_OPCODE_X0 = 21,
-  DBLALIGN2_RRR_0_OPCODE_X0 = 22,
-  DBLALIGN2_RRR_0_OPCODE_X1 = 13,
-  DBLALIGN4_RRR_0_OPCODE_X0 = 23,
-  DBLALIGN4_RRR_0_OPCODE_X1 = 14,
-  DBLALIGN6_RRR_0_OPCODE_X0 = 24,
-  DBLALIGN6_RRR_0_OPCODE_X1 = 15,
-  DBLALIGN_RRR_0_OPCODE_X0 = 25,
-  DRAIN_UNARY_OPCODE_X1 = 1,
-  DTLBPR_UNARY_OPCODE_X1 = 2,
-  EXCH4_RRR_0_OPCODE_X1 = 16,
-  EXCH_RRR_0_OPCODE_X1 = 17,
-  FDOUBLE_ADDSUB_RRR_0_OPCODE_X0 = 26,
-  FDOUBLE_ADD_FLAGS_RRR_0_OPCODE_X0 = 27,
-  FDOUBLE_MUL_FLAGS_RRR_0_OPCODE_X0 = 28,
-  FDOUBLE_PACK1_RRR_0_OPCODE_X0 = 29,
-  FDOUBLE_PACK2_RRR_0_OPCODE_X0 = 30,
-  FDOUBLE_SUB_FLAGS_RRR_0_OPCODE_X0 = 31,
-  FDOUBLE_UNPACK_MAX_RRR_0_OPCODE_X0 = 32,
-  FDOUBLE_UNPACK_MIN_RRR_0_OPCODE_X0 = 33,
-  FETCHADD4_RRR_0_OPCODE_X1 = 18,
-  FETCHADDGEZ4_RRR_0_OPCODE_X1 = 19,
-  FETCHADDGEZ_RRR_0_OPCODE_X1 = 20,
-  FETCHADD_RRR_0_OPCODE_X1 = 21,
-  FETCHAND4_RRR_0_OPCODE_X1 = 22,
-  FETCHAND_RRR_0_OPCODE_X1 = 23,
-  FETCHOR4_RRR_0_OPCODE_X1 = 24,
-  FETCHOR_RRR_0_OPCODE_X1 = 25,
-  FINV_UNARY_OPCODE_X1 = 3,
-  FLUSHWB_UNARY_OPCODE_X1 = 4,
-  FLUSH_UNARY_OPCODE_X1 = 5,
-  FNOP_UNARY_OPCODE_X0 = 3,
-  FNOP_UNARY_OPCODE_X1 = 6,
-  FNOP_UNARY_OPCODE_Y0 = 3,
-  FNOP_UNARY_OPCODE_Y1 = 8,
-  FSINGLE_ADD1_RRR_0_OPCODE_X0 = 34,
-  FSINGLE_ADDSUB2_RRR_0_OPCODE_X0 = 35,
-  FSINGLE_MUL1_RRR_0_OPCODE_X0 = 36,
-  FSINGLE_MUL2_RRR_0_OPCODE_X0 = 37,
-  FSINGLE_PACK1_UNARY_OPCODE_X0 = 4,
-  FSINGLE_PACK1_UNARY_OPCODE_Y0 = 4,
-  FSINGLE_PACK2_RRR_0_OPCODE_X0 = 38,
-  FSINGLE_SUB1_RRR_0_OPCODE_X0 = 39,
-  ICOH_UNARY_OPCODE_X1 = 7,
-  ILL_UNARY_OPCODE_X1 = 8,
-  ILL_UNARY_OPCODE_Y1 = 9,
-  IMM8_OPCODE_X0 = 4,
-  IMM8_OPCODE_X1 = 3,
-  INV_UNARY_OPCODE_X1 = 9,
-  IRET_UNARY_OPCODE_X1 = 10,
-  JALRP_UNARY_OPCODE_X1 = 11,
-  JALRP_UNARY_OPCODE_Y1 = 10,
-  JALR_UNARY_OPCODE_X1 = 12,
-  JALR_UNARY_OPCODE_Y1 = 11,
-  JAL_JUMP_OPCODE_X1 = 0,
-  JRP_UNARY_OPCODE_X1 = 13,
-  JRP_UNARY_OPCODE_Y1 = 12,
-  JR_UNARY_OPCODE_X1 = 14,
-  JR_UNARY_OPCODE_Y1 = 13,
-  JUMP_OPCODE_X1 = 4,
-  J_JUMP_OPCODE_X1 = 1,
-  LD1S_ADD_IMM8_OPCODE_X1 = 7,
-  LD1S_OPCODE_Y2 = 0,
-  LD1S_UNARY_OPCODE_X1 = 15,
-  LD1U_ADD_IMM8_OPCODE_X1 = 8,
-  LD1U_OPCODE_Y2 = 1,
-  LD1U_UNARY_OPCODE_X1 = 16,
-  LD2S_ADD_IMM8_OPCODE_X1 = 9,
-  LD2S_OPCODE_Y2 = 2,
-  LD2S_UNARY_OPCODE_X1 = 17,
-  LD2U_ADD_IMM8_OPCODE_X1 = 10,
-  LD2U_OPCODE_Y2 = 3,
-  LD2U_UNARY_OPCODE_X1 = 18,
-  LD4S_ADD_IMM8_OPCODE_X1 = 11,
-  LD4S_OPCODE_Y2 = 1,
-  LD4S_UNARY_OPCODE_X1 = 19,
-  LD4U_ADD_IMM8_OPCODE_X1 = 12,
-  LD4U_OPCODE_Y2 = 2,
-  LD4U_UNARY_OPCODE_X1 = 20,
-  LDNA_UNARY_OPCODE_X1 = 21,
-  LDNT1S_ADD_IMM8_OPCODE_X1 = 13,
-  LDNT1S_UNARY_OPCODE_X1 = 22,
-  LDNT1U_ADD_IMM8_OPCODE_X1 = 14,
-  LDNT1U_UNARY_OPCODE_X1 = 23,
-  LDNT2S_ADD_IMM8_OPCODE_X1 = 15,
-  LDNT2S_UNARY_OPCODE_X1 = 24,
-  LDNT2U_ADD_IMM8_OPCODE_X1 = 16,
-  LDNT2U_UNARY_OPCODE_X1 = 25,
-  LDNT4S_ADD_IMM8_OPCODE_X1 = 17,
-  LDNT4S_UNARY_OPCODE_X1 = 26,
-  LDNT4U_ADD_IMM8_OPCODE_X1 = 18,
-  LDNT4U_UNARY_OPCODE_X1 = 27,
-  LDNT_ADD_IMM8_OPCODE_X1 = 19,
-  LDNT_UNARY_OPCODE_X1 = 28,
-  LD_ADD_IMM8_OPCODE_X1 = 20,
-  LD_OPCODE_Y2 = 3,
-  LD_UNARY_OPCODE_X1 = 29,
-  LNK_UNARY_OPCODE_X1 = 30,
-  LNK_UNARY_OPCODE_Y1 = 14,
-  LWNA_ADD_IMM8_OPCODE_X1 = 21,
-  MFSPR_IMM8_OPCODE_X1 = 22,
-  MF_UNARY_OPCODE_X1 = 31,
-  MM_BF_OPCODE_X0 = 7,
-  MNZ_RRR_0_OPCODE_X0 = 40,
-  MNZ_RRR_0_OPCODE_X1 = 26,
-  MNZ_RRR_4_OPCODE_Y0 = 2,
-  MNZ_RRR_4_OPCODE_Y1 = 2,
-  MODE_OPCODE_YA2 = 1,
-  MODE_OPCODE_YB2 = 2,
-  MODE_OPCODE_YC2 = 3,
-  MTSPR_IMM8_OPCODE_X1 = 23,
-  MULAX_RRR_0_OPCODE_X0 = 41,
-  MULAX_RRR_3_OPCODE_Y0 = 2,
-  MULA_HS_HS_RRR_0_OPCODE_X0 = 42,
-  MULA_HS_HS_RRR_9_OPCODE_Y0 = 0,
-  MULA_HS_HU_RRR_0_OPCODE_X0 = 43,
-  MULA_HS_LS_RRR_0_OPCODE_X0 = 44,
-  MULA_HS_LU_RRR_0_OPCODE_X0 = 45,
-  MULA_HU_HU_RRR_0_OPCODE_X0 = 46,
-  MULA_HU_HU_RRR_9_OPCODE_Y0 = 1,
-  MULA_HU_LS_RRR_0_OPCODE_X0 = 47,
-  MULA_HU_LU_RRR_0_OPCODE_X0 = 48,
-  MULA_LS_LS_RRR_0_OPCODE_X0 = 49,
-  MULA_LS_LS_RRR_9_OPCODE_Y0 = 2,
-  MULA_LS_LU_RRR_0_OPCODE_X0 = 50,
-  MULA_LU_LU_RRR_0_OPCODE_X0 = 51,
-  MULA_LU_LU_RRR_9_OPCODE_Y0 = 3,
-  MULX_RRR_0_OPCODE_X0 = 52,
-  MULX_RRR_3_OPCODE_Y0 = 3,
-  MUL_HS_HS_RRR_0_OPCODE_X0 = 53,
-  MUL_HS_HS_RRR_8_OPCODE_Y0 = 0,
-  MUL_HS_HU_RRR_0_OPCODE_X0 = 54,
-  MUL_HS_LS_RRR_0_OPCODE_X0 = 55,
-  MUL_HS_LU_RRR_0_OPCODE_X0 = 56,
-  MUL_HU_HU_RRR_0_OPCODE_X0 = 57,
-  MUL_HU_HU_RRR_8_OPCODE_Y0 = 1,
-  MUL_HU_LS_RRR_0_OPCODE_X0 = 58,
-  MUL_HU_LU_RRR_0_OPCODE_X0 = 59,
-  MUL_LS_LS_RRR_0_OPCODE_X0 = 60,
-  MUL_LS_LS_RRR_8_OPCODE_Y0 = 2,
-  MUL_LS_LU_RRR_0_OPCODE_X0 = 61,
-  MUL_LU_LU_RRR_0_OPCODE_X0 = 62,
-  MUL_LU_LU_RRR_8_OPCODE_Y0 = 3,
-  MZ_RRR_0_OPCODE_X0 = 63,
-  MZ_RRR_0_OPCODE_X1 = 27,
-  MZ_RRR_4_OPCODE_Y0 = 3,
-  MZ_RRR_4_OPCODE_Y1 = 3,
-  NAP_UNARY_OPCODE_X1 = 32,
-  NOP_UNARY_OPCODE_X0 = 5,
-  NOP_UNARY_OPCODE_X1 = 33,
-  NOP_UNARY_OPCODE_Y0 = 5,
-  NOP_UNARY_OPCODE_Y1 = 15,
-  NOR_RRR_0_OPCODE_X0 = 64,
-  NOR_RRR_0_OPCODE_X1 = 28,
-  NOR_RRR_5_OPCODE_Y0 = 1,
-  NOR_RRR_5_OPCODE_Y1 = 1,
-  ORI_IMM8_OPCODE_X0 = 7,
-  ORI_IMM8_OPCODE_X1 = 24,
-  OR_RRR_0_OPCODE_X0 = 65,
-  OR_RRR_0_OPCODE_X1 = 29,
-  OR_RRR_5_OPCODE_Y0 = 2,
-  OR_RRR_5_OPCODE_Y1 = 2,
-  PCNT_UNARY_OPCODE_X0 = 6,
-  PCNT_UNARY_OPCODE_Y0 = 6,
-  REVBITS_UNARY_OPCODE_X0 = 7,
-  REVBITS_UNARY_OPCODE_Y0 = 7,
-  REVBYTES_UNARY_OPCODE_X0 = 8,
-  REVBYTES_UNARY_OPCODE_Y0 = 8,
-  ROTLI_SHIFT_OPCODE_X0 = 1,
-  ROTLI_SHIFT_OPCODE_X1 = 1,
-  ROTLI_SHIFT_OPCODE_Y0 = 0,
-  ROTLI_SHIFT_OPCODE_Y1 = 0,
-  ROTL_RRR_0_OPCODE_X0 = 66,
-  ROTL_RRR_0_OPCODE_X1 = 30,
-  ROTL_RRR_6_OPCODE_Y0 = 0,
-  ROTL_RRR_6_OPCODE_Y1 = 0,
-  RRR_0_OPCODE_X0 = 5,
-  RRR_0_OPCODE_X1 = 5,
-  RRR_0_OPCODE_Y0 = 5,
-  RRR_0_OPCODE_Y1 = 6,
-  RRR_1_OPCODE_Y0 = 6,
-  RRR_1_OPCODE_Y1 = 7,
-  RRR_2_OPCODE_Y0 = 7,
-  RRR_2_OPCODE_Y1 = 8,
-  RRR_3_OPCODE_Y0 = 8,
-  RRR_3_OPCODE_Y1 = 9,
-  RRR_4_OPCODE_Y0 = 9,
-  RRR_4_OPCODE_Y1 = 10,
-  RRR_5_OPCODE_Y0 = 10,
-  RRR_5_OPCODE_Y1 = 11,
-  RRR_6_OPCODE_Y0 = 11,
-  RRR_6_OPCODE_Y1 = 12,
-  RRR_7_OPCODE_Y0 = 12,
-  RRR_7_OPCODE_Y1 = 13,
-  RRR_8_OPCODE_Y0 = 13,
-  RRR_9_OPCODE_Y0 = 14,
-  SHIFT_OPCODE_X0 = 6,
-  SHIFT_OPCODE_X1 = 6,
-  SHIFT_OPCODE_Y0 = 15,
-  SHIFT_OPCODE_Y1 = 14,
-  SHL16INSLI_OPCODE_X0 = 7,
-  SHL16INSLI_OPCODE_X1 = 7,
-  SHL1ADDX_RRR_0_OPCODE_X0 = 67,
-  SHL1ADDX_RRR_0_OPCODE_X1 = 31,
-  SHL1ADDX_RRR_7_OPCODE_Y0 = 1,
-  SHL1ADDX_RRR_7_OPCODE_Y1 = 1,
-  SHL1ADD_RRR_0_OPCODE_X0 = 68,
-  SHL1ADD_RRR_0_OPCODE_X1 = 32,
-  SHL1ADD_RRR_1_OPCODE_Y0 = 0,
-  SHL1ADD_RRR_1_OPCODE_Y1 = 0,
-  SHL2ADDX_RRR_0_OPCODE_X0 = 69,
-  SHL2ADDX_RRR_0_OPCODE_X1 = 33,
-  SHL2ADDX_RRR_7_OPCODE_Y0 = 2,
-  SHL2ADDX_RRR_7_OPCODE_Y1 = 2,
-  SHL2ADD_RRR_0_OPCODE_X0 = 70,
-  SHL2ADD_RRR_0_OPCODE_X1 = 34,
-  SHL2ADD_RRR_1_OPCODE_Y0 = 1,
-  SHL2ADD_RRR_1_OPCODE_Y1 = 1,
-  SHL3ADDX_RRR_0_OPCODE_X0 = 71,
-  SHL3ADDX_RRR_0_OPCODE_X1 = 35,
-  SHL3ADDX_RRR_7_OPCODE_Y0 = 3,
-  SHL3ADDX_RRR_7_OPCODE_Y1 = 3,
-  SHL3ADD_RRR_0_OPCODE_X0 = 72,
-  SHL3ADD_RRR_0_OPCODE_X1 = 36,
-  SHL3ADD_RRR_1_OPCODE_Y0 = 2,
-  SHL3ADD_RRR_1_OPCODE_Y1 = 2,
-  SHLI_SHIFT_OPCODE_X0 = 2,
-  SHLI_SHIFT_OPCODE_X1 = 2,
-  SHLI_SHIFT_OPCODE_Y0 = 1,
-  SHLI_SHIFT_OPCODE_Y1 = 1,
-  SHLXI_SHIFT_OPCODE_X0 = 3,
-  SHLXI_SHIFT_OPCODE_X1 = 3,
-  SHLX_RRR_0_OPCODE_X0 = 73,
-  SHLX_RRR_0_OPCODE_X1 = 37,
-  SHL_RRR_0_OPCODE_X0 = 74,
-  SHL_RRR_0_OPCODE_X1 = 38,
-  SHL_RRR_6_OPCODE_Y0 = 1,
-  SHL_RRR_6_OPCODE_Y1 = 1,
-  SHRSI_SHIFT_OPCODE_X0 = 4,
-  SHRSI_SHIFT_OPCODE_X1 = 4,
-  SHRSI_SHIFT_OPCODE_Y0 = 2,
-  SHRSI_SHIFT_OPCODE_Y1 = 2,
-  SHRS_RRR_0_OPCODE_X0 = 75,
-  SHRS_RRR_0_OPCODE_X1 = 39,
-  SHRS_RRR_6_OPCODE_Y0 = 2,
-  SHRS_RRR_6_OPCODE_Y1 = 2,
-  SHRUI_SHIFT_OPCODE_X0 = 5,
-  SHRUI_SHIFT_OPCODE_X1 = 5,
-  SHRUI_SHIFT_OPCODE_Y0 = 3,
-  SHRUI_SHIFT_OPCODE_Y1 = 3,
-  SHRUXI_SHIFT_OPCODE_X0 = 6,
-  SHRUXI_SHIFT_OPCODE_X1 = 6,
-  SHRUX_RRR_0_OPCODE_X0 = 76,
-  SHRUX_RRR_0_OPCODE_X1 = 40,
-  SHRU_RRR_0_OPCODE_X0 = 77,
-  SHRU_RRR_0_OPCODE_X1 = 41,
-  SHRU_RRR_6_OPCODE_Y0 = 3,
-  SHRU_RRR_6_OPCODE_Y1 = 3,
-  SHUFFLEBYTES_RRR_0_OPCODE_X0 = 78,
-  ST1_ADD_IMM8_OPCODE_X1 = 25,
-  ST1_OPCODE_Y2 = 0,
-  ST1_RRR_0_OPCODE_X1 = 42,
-  ST2_ADD_IMM8_OPCODE_X1 = 26,
-  ST2_OPCODE_Y2 = 1,
-  ST2_RRR_0_OPCODE_X1 = 43,
-  ST4_ADD_IMM8_OPCODE_X1 = 27,
-  ST4_OPCODE_Y2 = 2,
-  ST4_RRR_0_OPCODE_X1 = 44,
-  STNT1_ADD_IMM8_OPCODE_X1 = 28,
-  STNT1_RRR_0_OPCODE_X1 = 45,
-  STNT2_ADD_IMM8_OPCODE_X1 = 29,
-  STNT2_RRR_0_OPCODE_X1 = 46,
-  STNT4_ADD_IMM8_OPCODE_X1 = 30,
-  STNT4_RRR_0_OPCODE_X1 = 47,
-  STNT_ADD_IMM8_OPCODE_X1 = 31,
-  STNT_RRR_0_OPCODE_X1 = 48,
-  ST_ADD_IMM8_OPCODE_X1 = 32,
-  ST_OPCODE_Y2 = 3,
-  ST_RRR_0_OPCODE_X1 = 49,
-  SUBXSC_RRR_0_OPCODE_X0 = 79,
-  SUBXSC_RRR_0_OPCODE_X1 = 50,
-  SUBX_RRR_0_OPCODE_X0 = 80,
-  SUBX_RRR_0_OPCODE_X1 = 51,
-  SUBX_RRR_0_OPCODE_Y0 = 2,
-  SUBX_RRR_0_OPCODE_Y1 = 2,
-  SUB_RRR_0_OPCODE_X0 = 81,
-  SUB_RRR_0_OPCODE_X1 = 52,
-  SUB_RRR_0_OPCODE_Y0 = 3,
-  SUB_RRR_0_OPCODE_Y1 = 3,
-  SWINT0_UNARY_OPCODE_X1 = 34,
-  SWINT1_UNARY_OPCODE_X1 = 35,
-  SWINT2_UNARY_OPCODE_X1 = 36,
-  SWINT3_UNARY_OPCODE_X1 = 37,
-  TBLIDXB0_UNARY_OPCODE_X0 = 9,
-  TBLIDXB0_UNARY_OPCODE_Y0 = 9,
-  TBLIDXB1_UNARY_OPCODE_X0 = 10,
-  TBLIDXB1_UNARY_OPCODE_Y0 = 10,
-  TBLIDXB2_UNARY_OPCODE_X0 = 11,
-  TBLIDXB2_UNARY_OPCODE_Y0 = 11,
-  TBLIDXB3_UNARY_OPCODE_X0 = 12,
-  TBLIDXB3_UNARY_OPCODE_Y0 = 12,
-  UNARY_RRR_0_OPCODE_X0 = 82,
-  UNARY_RRR_0_OPCODE_X1 = 53,
-  UNARY_RRR_1_OPCODE_Y0 = 3,
-  UNARY_RRR_1_OPCODE_Y1 = 3,
-  V1ADDI_IMM8_OPCODE_X0 = 8,
-  V1ADDI_IMM8_OPCODE_X1 = 33,
-  V1ADDUC_RRR_0_OPCODE_X0 = 83,
-  V1ADDUC_RRR_0_OPCODE_X1 = 54,
-  V1ADD_RRR_0_OPCODE_X0 = 84,
-  V1ADD_RRR_0_OPCODE_X1 = 55,
-  V1ADIFFU_RRR_0_OPCODE_X0 = 85,
-  V1AVGU_RRR_0_OPCODE_X0 = 86,
-  V1CMPEQI_IMM8_OPCODE_X0 = 9,
-  V1CMPEQI_IMM8_OPCODE_X1 = 34,
-  V1CMPEQ_RRR_0_OPCODE_X0 = 87,
-  V1CMPEQ_RRR_0_OPCODE_X1 = 56,
-  V1CMPLES_RRR_0_OPCODE_X0 = 88,
-  V1CMPLES_RRR_0_OPCODE_X1 = 57,
-  V1CMPLEU_RRR_0_OPCODE_X0 = 89,
-  V1CMPLEU_RRR_0_OPCODE_X1 = 58,
-  V1CMPLTSI_IMM8_OPCODE_X0 = 10,
-  V1CMPLTSI_IMM8_OPCODE_X1 = 35,
-  V1CMPLTS_RRR_0_OPCODE_X0 = 90,
-  V1CMPLTS_RRR_0_OPCODE_X1 = 59,
-  V1CMPLTUI_IMM8_OPCODE_X0 = 11,
-  V1CMPLTUI_IMM8_OPCODE_X1 = 36,
-  V1CMPLTU_RRR_0_OPCODE_X0 = 91,
-  V1CMPLTU_RRR_0_OPCODE_X1 = 60,
-  V1CMPNE_RRR_0_OPCODE_X0 = 92,
-  V1CMPNE_RRR_0_OPCODE_X1 = 61,
-  V1DDOTPUA_RRR_0_OPCODE_X0 = 161,
-  V1DDOTPUSA_RRR_0_OPCODE_X0 = 93,
-  V1DDOTPUS_RRR_0_OPCODE_X0 = 94,
-  V1DDOTPU_RRR_0_OPCODE_X0 = 162,
-  V1DOTPA_RRR_0_OPCODE_X0 = 95,
-  V1DOTPUA_RRR_0_OPCODE_X0 = 163,
-  V1DOTPUSA_RRR_0_OPCODE_X0 = 96,
-  V1DOTPUS_RRR_0_OPCODE_X0 = 97,
-  V1DOTPU_RRR_0_OPCODE_X0 = 164,
-  V1DOTP_RRR_0_OPCODE_X0 = 98,
-  V1INT_H_RRR_0_OPCODE_X0 = 99,
-  V1INT_H_RRR_0_OPCODE_X1 = 62,
-  V1INT_L_RRR_0_OPCODE_X0 = 100,
-  V1INT_L_RRR_0_OPCODE_X1 = 63,
-  V1MAXUI_IMM8_OPCODE_X0 = 12,
-  V1MAXUI_IMM8_OPCODE_X1 = 37,
-  V1MAXU_RRR_0_OPCODE_X0 = 101,
-  V1MAXU_RRR_0_OPCODE_X1 = 64,
-  V1MINUI_IMM8_OPCODE_X0 = 13,
-  V1MINUI_IMM8_OPCODE_X1 = 38,
-  V1MINU_RRR_0_OPCODE_X0 = 102,
-  V1MINU_RRR_0_OPCODE_X1 = 65,
-  V1MNZ_RRR_0_OPCODE_X0 = 103,
-  V1MNZ_RRR_0_OPCODE_X1 = 66,
-  V1MULTU_RRR_0_OPCODE_X0 = 104,
-  V1MULUS_RRR_0_OPCODE_X0 = 105,
-  V1MULU_RRR_0_OPCODE_X0 = 106,
-  V1MZ_RRR_0_OPCODE_X0 = 107,
-  V1MZ_RRR_0_OPCODE_X1 = 67,
-  V1SADAU_RRR_0_OPCODE_X0 = 108,
-  V1SADU_RRR_0_OPCODE_X0 = 109,
-  V1SHLI_SHIFT_OPCODE_X0 = 7,
-  V1SHLI_SHIFT_OPCODE_X1 = 7,
-  V1SHL_RRR_0_OPCODE_X0 = 110,
-  V1SHL_RRR_0_OPCODE_X1 = 68,
-  V1SHRSI_SHIFT_OPCODE_X0 = 8,
-  V1SHRSI_SHIFT_OPCODE_X1 = 8,
-  V1SHRS_RRR_0_OPCODE_X0 = 111,
-  V1SHRS_RRR_0_OPCODE_X1 = 69,
-  V1SHRUI_SHIFT_OPCODE_X0 = 9,
-  V1SHRUI_SHIFT_OPCODE_X1 = 9,
-  V1SHRU_RRR_0_OPCODE_X0 = 112,
-  V1SHRU_RRR_0_OPCODE_X1 = 70,
-  V1SUBUC_RRR_0_OPCODE_X0 = 113,
-  V1SUBUC_RRR_0_OPCODE_X1 = 71,
-  V1SUB_RRR_0_OPCODE_X0 = 114,
-  V1SUB_RRR_0_OPCODE_X1 = 72,
-  V2ADDI_IMM8_OPCODE_X0 = 14,
-  V2ADDI_IMM8_OPCODE_X1 = 39,
-  V2ADDSC_RRR_0_OPCODE_X0 = 115,
-  V2ADDSC_RRR_0_OPCODE_X1 = 73,
-  V2ADD_RRR_0_OPCODE_X0 = 116,
-  V2ADD_RRR_0_OPCODE_X1 = 74,
-  V2ADIFFS_RRR_0_OPCODE_X0 = 117,
-  V2AVGS_RRR_0_OPCODE_X0 = 118,
-  V2CMPEQI_IMM8_OPCODE_X0 = 15,
-  V2CMPEQI_IMM8_OPCODE_X1 = 40,
-  V2CMPEQ_RRR_0_OPCODE_X0 = 119,
-  V2CMPEQ_RRR_0_OPCODE_X1 = 75,
-  V2CMPLES_RRR_0_OPCODE_X0 = 120,
-  V2CMPLES_RRR_0_OPCODE_X1 = 76,
-  V2CMPLEU_RRR_0_OPCODE_X0 = 121,
-  V2CMPLEU_RRR_0_OPCODE_X1 = 77,
-  V2CMPLTSI_IMM8_OPCODE_X0 = 16,
-  V2CMPLTSI_IMM8_OPCODE_X1 = 41,
-  V2CMPLTS_RRR_0_OPCODE_X0 = 122,
-  V2CMPLTS_RRR_0_OPCODE_X1 = 78,
-  V2CMPLTUI_IMM8_OPCODE_X0 = 17,
-  V2CMPLTUI_IMM8_OPCODE_X1 = 42,
-  V2CMPLTU_RRR_0_OPCODE_X0 = 123,
-  V2CMPLTU_RRR_0_OPCODE_X1 = 79,
-  V2CMPNE_RRR_0_OPCODE_X0 = 124,
-  V2CMPNE_RRR_0_OPCODE_X1 = 80,
-  V2DOTPA_RRR_0_OPCODE_X0 = 125,
-  V2DOTP_RRR_0_OPCODE_X0 = 126,
-  V2INT_H_RRR_0_OPCODE_X0 = 127,
-  V2INT_H_RRR_0_OPCODE_X1 = 81,
-  V2INT_L_RRR_0_OPCODE_X0 = 128,
-  V2INT_L_RRR_0_OPCODE_X1 = 82,
-  V2MAXSI_IMM8_OPCODE_X0 = 18,
-  V2MAXSI_IMM8_OPCODE_X1 = 43,
-  V2MAXS_RRR_0_OPCODE_X0 = 129,
-  V2MAXS_RRR_0_OPCODE_X1 = 83,
-  V2MINSI_IMM8_OPCODE_X0 = 19,
-  V2MINSI_IMM8_OPCODE_X1 = 44,
-  V2MINS_RRR_0_OPCODE_X0 = 130,
-  V2MINS_RRR_0_OPCODE_X1 = 84,
-  V2MNZ_RRR_0_OPCODE_X0 = 131,
-  V2MNZ_RRR_0_OPCODE_X1 = 85,
-  V2MULFSC_RRR_0_OPCODE_X0 = 132,
-  V2MULS_RRR_0_OPCODE_X0 = 133,
-  V2MULTS_RRR_0_OPCODE_X0 = 134,
-  V2MZ_RRR_0_OPCODE_X0 = 135,
-  V2MZ_RRR_0_OPCODE_X1 = 86,
-  V2PACKH_RRR_0_OPCODE_X0 = 136,
-  V2PACKH_RRR_0_OPCODE_X1 = 87,
-  V2PACKL_RRR_0_OPCODE_X0 = 137,
-  V2PACKL_RRR_0_OPCODE_X1 = 88,
-  V2PACKUC_RRR_0_OPCODE_X0 = 138,
-  V2PACKUC_RRR_0_OPCODE_X1 = 89,
-  V2SADAS_RRR_0_OPCODE_X0 = 139,
-  V2SADAU_RRR_0_OPCODE_X0 = 140,
-  V2SADS_RRR_0_OPCODE_X0 = 141,
-  V2SADU_RRR_0_OPCODE_X0 = 142,
-  V2SHLI_SHIFT_OPCODE_X0 = 10,
-  V2SHLI_SHIFT_OPCODE_X1 = 10,
-  V2SHLSC_RRR_0_OPCODE_X0 = 143,
-  V2SHLSC_RRR_0_OPCODE_X1 = 90,
-  V2SHL_RRR_0_OPCODE_X0 = 144,
-  V2SHL_RRR_0_OPCODE_X1 = 91,
-  V2SHRSI_SHIFT_OPCODE_X0 = 11,
-  V2SHRSI_SHIFT_OPCODE_X1 = 11,
-  V2SHRS_RRR_0_OPCODE_X0 = 145,
-  V2SHRS_RRR_0_OPCODE_X1 = 92,
-  V2SHRUI_SHIFT_OPCODE_X0 = 12,
-  V2SHRUI_SHIFT_OPCODE_X1 = 12,
-  V2SHRU_RRR_0_OPCODE_X0 = 146,
-  V2SHRU_RRR_0_OPCODE_X1 = 93,
-  V2SUBSC_RRR_0_OPCODE_X0 = 147,
-  V2SUBSC_RRR_0_OPCODE_X1 = 94,
-  V2SUB_RRR_0_OPCODE_X0 = 148,
-  V2SUB_RRR_0_OPCODE_X1 = 95,
-  V4ADDSC_RRR_0_OPCODE_X0 = 149,
-  V4ADDSC_RRR_0_OPCODE_X1 = 96,
-  V4ADD_RRR_0_OPCODE_X0 = 150,
-  V4ADD_RRR_0_OPCODE_X1 = 97,
-  V4INT_H_RRR_0_OPCODE_X0 = 151,
-  V4INT_H_RRR_0_OPCODE_X1 = 98,
-  V4INT_L_RRR_0_OPCODE_X0 = 152,
-  V4INT_L_RRR_0_OPCODE_X1 = 99,
-  V4PACKSC_RRR_0_OPCODE_X0 = 153,
-  V4PACKSC_RRR_0_OPCODE_X1 = 100,
-  V4SHLSC_RRR_0_OPCODE_X0 = 154,
-  V4SHLSC_RRR_0_OPCODE_X1 = 101,
-  V4SHL_RRR_0_OPCODE_X0 = 155,
-  V4SHL_RRR_0_OPCODE_X1 = 102,
-  V4SHRS_RRR_0_OPCODE_X0 = 156,
-  V4SHRS_RRR_0_OPCODE_X1 = 103,
-  V4SHRU_RRR_0_OPCODE_X0 = 157,
-  V4SHRU_RRR_0_OPCODE_X1 = 104,
-  V4SUBSC_RRR_0_OPCODE_X0 = 158,
-  V4SUBSC_RRR_0_OPCODE_X1 = 105,
-  V4SUB_RRR_0_OPCODE_X0 = 159,
-  V4SUB_RRR_0_OPCODE_X1 = 106,
-  WH64_UNARY_OPCODE_X1 = 38,
-  XORI_IMM8_OPCODE_X0 = 20,
-  XORI_IMM8_OPCODE_X1 = 45,
-  XOR_RRR_0_OPCODE_X0 = 160,
-  XOR_RRR_0_OPCODE_X1 = 107,
-  XOR_RRR_5_OPCODE_Y0 = 3,
-  XOR_RRR_5_OPCODE_Y1 = 3
-};
-
-#endif /* !_TILE_OPCODE_CONSTANTS_H */
diff --git a/arch/tile/include/asm/tile-desc.h b/arch/tile/include/asm/tile-desc.h
new file mode 100644
index 0000000..43849bf
--- /dev/null
+++ b/arch/tile/include/asm/tile-desc.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef __tilegx__
+#include <asm/tile-desc_32.h>
+#else
+#include <asm/tile-desc_64.h>
+#endif
diff --git a/arch/tile/include/asm/tile-desc_32.h b/arch/tile/include/asm/tile-desc_32.h
new file mode 100644
index 0000000..f09c5c4
--- /dev/null
+++ b/arch/tile/include/asm/tile-desc_32.h
@@ -0,0 +1,553 @@
+/* TILEPro opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
+#ifndef opcode_tilepro_h
+#define opcode_tilepro_h
+
+#include <arch/opcode.h>
+
+
+enum
+{
+  TILEPRO_MAX_OPERANDS = 5 /* mm */
+};
+
+typedef enum
+{
+  TILEPRO_OPC_BPT,
+  TILEPRO_OPC_INFO,
+  TILEPRO_OPC_INFOL,
+  TILEPRO_OPC_J,
+  TILEPRO_OPC_JAL,
+  TILEPRO_OPC_MOVE,
+  TILEPRO_OPC_MOVE_SN,
+  TILEPRO_OPC_MOVEI,
+  TILEPRO_OPC_MOVEI_SN,
+  TILEPRO_OPC_MOVELI,
+  TILEPRO_OPC_MOVELI_SN,
+  TILEPRO_OPC_MOVELIS,
+  TILEPRO_OPC_PREFETCH,
+  TILEPRO_OPC_RAISE,
+  TILEPRO_OPC_ADD,
+  TILEPRO_OPC_ADD_SN,
+  TILEPRO_OPC_ADDB,
+  TILEPRO_OPC_ADDB_SN,
+  TILEPRO_OPC_ADDBS_U,
+  TILEPRO_OPC_ADDBS_U_SN,
+  TILEPRO_OPC_ADDH,
+  TILEPRO_OPC_ADDH_SN,
+  TILEPRO_OPC_ADDHS,
+  TILEPRO_OPC_ADDHS_SN,
+  TILEPRO_OPC_ADDI,
+  TILEPRO_OPC_ADDI_SN,
+  TILEPRO_OPC_ADDIB,
+  TILEPRO_OPC_ADDIB_SN,
+  TILEPRO_OPC_ADDIH,
+  TILEPRO_OPC_ADDIH_SN,
+  TILEPRO_OPC_ADDLI,
+  TILEPRO_OPC_ADDLI_SN,
+  TILEPRO_OPC_ADDLIS,
+  TILEPRO_OPC_ADDS,
+  TILEPRO_OPC_ADDS_SN,
+  TILEPRO_OPC_ADIFFB_U,
+  TILEPRO_OPC_ADIFFB_U_SN,
+  TILEPRO_OPC_ADIFFH,
+  TILEPRO_OPC_ADIFFH_SN,
+  TILEPRO_OPC_AND,
+  TILEPRO_OPC_AND_SN,
+  TILEPRO_OPC_ANDI,
+  TILEPRO_OPC_ANDI_SN,
+  TILEPRO_OPC_AULI,
+  TILEPRO_OPC_AVGB_U,
+  TILEPRO_OPC_AVGB_U_SN,
+  TILEPRO_OPC_AVGH,
+  TILEPRO_OPC_AVGH_SN,
+  TILEPRO_OPC_BBNS,
+  TILEPRO_OPC_BBNS_SN,
+  TILEPRO_OPC_BBNST,
+  TILEPRO_OPC_BBNST_SN,
+  TILEPRO_OPC_BBS,
+  TILEPRO_OPC_BBS_SN,
+  TILEPRO_OPC_BBST,
+  TILEPRO_OPC_BBST_SN,
+  TILEPRO_OPC_BGEZ,
+  TILEPRO_OPC_BGEZ_SN,
+  TILEPRO_OPC_BGEZT,
+  TILEPRO_OPC_BGEZT_SN,
+  TILEPRO_OPC_BGZ,
+  TILEPRO_OPC_BGZ_SN,
+  TILEPRO_OPC_BGZT,
+  TILEPRO_OPC_BGZT_SN,
+  TILEPRO_OPC_BITX,
+  TILEPRO_OPC_BITX_SN,
+  TILEPRO_OPC_BLEZ,
+  TILEPRO_OPC_BLEZ_SN,
+  TILEPRO_OPC_BLEZT,
+  TILEPRO_OPC_BLEZT_SN,
+  TILEPRO_OPC_BLZ,
+  TILEPRO_OPC_BLZ_SN,
+  TILEPRO_OPC_BLZT,
+  TILEPRO_OPC_BLZT_SN,
+  TILEPRO_OPC_BNZ,
+  TILEPRO_OPC_BNZ_SN,
+  TILEPRO_OPC_BNZT,
+  TILEPRO_OPC_BNZT_SN,
+  TILEPRO_OPC_BYTEX,
+  TILEPRO_OPC_BYTEX_SN,
+  TILEPRO_OPC_BZ,
+  TILEPRO_OPC_BZ_SN,
+  TILEPRO_OPC_BZT,
+  TILEPRO_OPC_BZT_SN,
+  TILEPRO_OPC_CLZ,
+  TILEPRO_OPC_CLZ_SN,
+  TILEPRO_OPC_CRC32_32,
+  TILEPRO_OPC_CRC32_32_SN,
+  TILEPRO_OPC_CRC32_8,
+  TILEPRO_OPC_CRC32_8_SN,
+  TILEPRO_OPC_CTZ,
+  TILEPRO_OPC_CTZ_SN,
+  TILEPRO_OPC_DRAIN,
+  TILEPRO_OPC_DTLBPR,
+  TILEPRO_OPC_DWORD_ALIGN,
+  TILEPRO_OPC_DWORD_ALIGN_SN,
+  TILEPRO_OPC_FINV,
+  TILEPRO_OPC_FLUSH,
+  TILEPRO_OPC_FNOP,
+  TILEPRO_OPC_ICOH,
+  TILEPRO_OPC_ILL,
+  TILEPRO_OPC_INTHB,
+  TILEPRO_OPC_INTHB_SN,
+  TILEPRO_OPC_INTHH,
+  TILEPRO_OPC_INTHH_SN,
+  TILEPRO_OPC_INTLB,
+  TILEPRO_OPC_INTLB_SN,
+  TILEPRO_OPC_INTLH,
+  TILEPRO_OPC_INTLH_SN,
+  TILEPRO_OPC_INV,
+  TILEPRO_OPC_IRET,
+  TILEPRO_OPC_JALB,
+  TILEPRO_OPC_JALF,
+  TILEPRO_OPC_JALR,
+  TILEPRO_OPC_JALRP,
+  TILEPRO_OPC_JB,
+  TILEPRO_OPC_JF,
+  TILEPRO_OPC_JR,
+  TILEPRO_OPC_JRP,
+  TILEPRO_OPC_LB,
+  TILEPRO_OPC_LB_SN,
+  TILEPRO_OPC_LB_U,
+  TILEPRO_OPC_LB_U_SN,
+  TILEPRO_OPC_LBADD,
+  TILEPRO_OPC_LBADD_SN,
+  TILEPRO_OPC_LBADD_U,
+  TILEPRO_OPC_LBADD_U_SN,
+  TILEPRO_OPC_LH,
+  TILEPRO_OPC_LH_SN,
+  TILEPRO_OPC_LH_U,
+  TILEPRO_OPC_LH_U_SN,
+  TILEPRO_OPC_LHADD,
+  TILEPRO_OPC_LHADD_SN,
+  TILEPRO_OPC_LHADD_U,
+  TILEPRO_OPC_LHADD_U_SN,
+  TILEPRO_OPC_LNK,
+  TILEPRO_OPC_LNK_SN,
+  TILEPRO_OPC_LW,
+  TILEPRO_OPC_LW_SN,
+  TILEPRO_OPC_LW_NA,
+  TILEPRO_OPC_LW_NA_SN,
+  TILEPRO_OPC_LWADD,
+  TILEPRO_OPC_LWADD_SN,
+  TILEPRO_OPC_LWADD_NA,
+  TILEPRO_OPC_LWADD_NA_SN,
+  TILEPRO_OPC_MAXB_U,
+  TILEPRO_OPC_MAXB_U_SN,
+  TILEPRO_OPC_MAXH,
+  TILEPRO_OPC_MAXH_SN,
+  TILEPRO_OPC_MAXIB_U,
+  TILEPRO_OPC_MAXIB_U_SN,
+  TILEPRO_OPC_MAXIH,
+  TILEPRO_OPC_MAXIH_SN,
+  TILEPRO_OPC_MF,
+  TILEPRO_OPC_MFSPR,
+  TILEPRO_OPC_MINB_U,
+  TILEPRO_OPC_MINB_U_SN,
+  TILEPRO_OPC_MINH,
+  TILEPRO_OPC_MINH_SN,
+  TILEPRO_OPC_MINIB_U,
+  TILEPRO_OPC_MINIB_U_SN,
+  TILEPRO_OPC_MINIH,
+  TILEPRO_OPC_MINIH_SN,
+  TILEPRO_OPC_MM,
+  TILEPRO_OPC_MNZ,
+  TILEPRO_OPC_MNZ_SN,
+  TILEPRO_OPC_MNZB,
+  TILEPRO_OPC_MNZB_SN,
+  TILEPRO_OPC_MNZH,
+  TILEPRO_OPC_MNZH_SN,
+  TILEPRO_OPC_MTSPR,
+  TILEPRO_OPC_MULHH_SS,
+  TILEPRO_OPC_MULHH_SS_SN,
+  TILEPRO_OPC_MULHH_SU,
+  TILEPRO_OPC_MULHH_SU_SN,
+  TILEPRO_OPC_MULHH_UU,
+  TILEPRO_OPC_MULHH_UU_SN,
+  TILEPRO_OPC_MULHHA_SS,
+  TILEPRO_OPC_MULHHA_SS_SN,
+  TILEPRO_OPC_MULHHA_SU,
+  TILEPRO_OPC_MULHHA_SU_SN,
+  TILEPRO_OPC_MULHHA_UU,
+  TILEPRO_OPC_MULHHA_UU_SN,
+  TILEPRO_OPC_MULHHSA_UU,
+  TILEPRO_OPC_MULHHSA_UU_SN,
+  TILEPRO_OPC_MULHL_SS,
+  TILEPRO_OPC_MULHL_SS_SN,
+  TILEPRO_OPC_MULHL_SU,
+  TILEPRO_OPC_MULHL_SU_SN,
+  TILEPRO_OPC_MULHL_US,
+  TILEPRO_OPC_MULHL_US_SN,
+  TILEPRO_OPC_MULHL_UU,
+  TILEPRO_OPC_MULHL_UU_SN,
+  TILEPRO_OPC_MULHLA_SS,
+  TILEPRO_OPC_MULHLA_SS_SN,
+  TILEPRO_OPC_MULHLA_SU,
+  TILEPRO_OPC_MULHLA_SU_SN,
+  TILEPRO_OPC_MULHLA_US,
+  TILEPRO_OPC_MULHLA_US_SN,
+  TILEPRO_OPC_MULHLA_UU,
+  TILEPRO_OPC_MULHLA_UU_SN,
+  TILEPRO_OPC_MULHLSA_UU,
+  TILEPRO_OPC_MULHLSA_UU_SN,
+  TILEPRO_OPC_MULLL_SS,
+  TILEPRO_OPC_MULLL_SS_SN,
+  TILEPRO_OPC_MULLL_SU,
+  TILEPRO_OPC_MULLL_SU_SN,
+  TILEPRO_OPC_MULLL_UU,
+  TILEPRO_OPC_MULLL_UU_SN,
+  TILEPRO_OPC_MULLLA_SS,
+  TILEPRO_OPC_MULLLA_SS_SN,
+  TILEPRO_OPC_MULLLA_SU,
+  TILEPRO_OPC_MULLLA_SU_SN,
+  TILEPRO_OPC_MULLLA_UU,
+  TILEPRO_OPC_MULLLA_UU_SN,
+  TILEPRO_OPC_MULLLSA_UU,
+  TILEPRO_OPC_MULLLSA_UU_SN,
+  TILEPRO_OPC_MVNZ,
+  TILEPRO_OPC_MVNZ_SN,
+  TILEPRO_OPC_MVZ,
+  TILEPRO_OPC_MVZ_SN,
+  TILEPRO_OPC_MZ,
+  TILEPRO_OPC_MZ_SN,
+  TILEPRO_OPC_MZB,
+  TILEPRO_OPC_MZB_SN,
+  TILEPRO_OPC_MZH,
+  TILEPRO_OPC_MZH_SN,
+  TILEPRO_OPC_NAP,
+  TILEPRO_OPC_NOP,
+  TILEPRO_OPC_NOR,
+  TILEPRO_OPC_NOR_SN,
+  TILEPRO_OPC_OR,
+  TILEPRO_OPC_OR_SN,
+  TILEPRO_OPC_ORI,
+  TILEPRO_OPC_ORI_SN,
+  TILEPRO_OPC_PACKBS_U,
+  TILEPRO_OPC_PACKBS_U_SN,
+  TILEPRO_OPC_PACKHB,
+  TILEPRO_OPC_PACKHB_SN,
+  TILEPRO_OPC_PACKHS,
+  TILEPRO_OPC_PACKHS_SN,
+  TILEPRO_OPC_PACKLB,
+  TILEPRO_OPC_PACKLB_SN,
+  TILEPRO_OPC_PCNT,
+  TILEPRO_OPC_PCNT_SN,
+  TILEPRO_OPC_RL,
+  TILEPRO_OPC_RL_SN,
+  TILEPRO_OPC_RLI,
+  TILEPRO_OPC_RLI_SN,
+  TILEPRO_OPC_S1A,
+  TILEPRO_OPC_S1A_SN,
+  TILEPRO_OPC_S2A,
+  TILEPRO_OPC_S2A_SN,
+  TILEPRO_OPC_S3A,
+  TILEPRO_OPC_S3A_SN,
+  TILEPRO_OPC_SADAB_U,
+  TILEPRO_OPC_SADAB_U_SN,
+  TILEPRO_OPC_SADAH,
+  TILEPRO_OPC_SADAH_SN,
+  TILEPRO_OPC_SADAH_U,
+  TILEPRO_OPC_SADAH_U_SN,
+  TILEPRO_OPC_SADB_U,
+  TILEPRO_OPC_SADB_U_SN,
+  TILEPRO_OPC_SADH,
+  TILEPRO_OPC_SADH_SN,
+  TILEPRO_OPC_SADH_U,
+  TILEPRO_OPC_SADH_U_SN,
+  TILEPRO_OPC_SB,
+  TILEPRO_OPC_SBADD,
+  TILEPRO_OPC_SEQ,
+  TILEPRO_OPC_SEQ_SN,
+  TILEPRO_OPC_SEQB,
+  TILEPRO_OPC_SEQB_SN,
+  TILEPRO_OPC_SEQH,
+  TILEPRO_OPC_SEQH_SN,
+  TILEPRO_OPC_SEQI,
+  TILEPRO_OPC_SEQI_SN,
+  TILEPRO_OPC_SEQIB,
+  TILEPRO_OPC_SEQIB_SN,
+  TILEPRO_OPC_SEQIH,
+  TILEPRO_OPC_SEQIH_SN,
+  TILEPRO_OPC_SH,
+  TILEPRO_OPC_SHADD,
+  TILEPRO_OPC_SHL,
+  TILEPRO_OPC_SHL_SN,
+  TILEPRO_OPC_SHLB,
+  TILEPRO_OPC_SHLB_SN,
+  TILEPRO_OPC_SHLH,
+  TILEPRO_OPC_SHLH_SN,
+  TILEPRO_OPC_SHLI,
+  TILEPRO_OPC_SHLI_SN,
+  TILEPRO_OPC_SHLIB,
+  TILEPRO_OPC_SHLIB_SN,
+  TILEPRO_OPC_SHLIH,
+  TILEPRO_OPC_SHLIH_SN,
+  TILEPRO_OPC_SHR,
+  TILEPRO_OPC_SHR_SN,
+  TILEPRO_OPC_SHRB,
+  TILEPRO_OPC_SHRB_SN,
+  TILEPRO_OPC_SHRH,
+  TILEPRO_OPC_SHRH_SN,
+  TILEPRO_OPC_SHRI,
+  TILEPRO_OPC_SHRI_SN,
+  TILEPRO_OPC_SHRIB,
+  TILEPRO_OPC_SHRIB_SN,
+  TILEPRO_OPC_SHRIH,
+  TILEPRO_OPC_SHRIH_SN,
+  TILEPRO_OPC_SLT,
+  TILEPRO_OPC_SLT_SN,
+  TILEPRO_OPC_SLT_U,
+  TILEPRO_OPC_SLT_U_SN,
+  TILEPRO_OPC_SLTB,
+  TILEPRO_OPC_SLTB_SN,
+  TILEPRO_OPC_SLTB_U,
+  TILEPRO_OPC_SLTB_U_SN,
+  TILEPRO_OPC_SLTE,
+  TILEPRO_OPC_SLTE_SN,
+  TILEPRO_OPC_SLTE_U,
+  TILEPRO_OPC_SLTE_U_SN,
+  TILEPRO_OPC_SLTEB,
+  TILEPRO_OPC_SLTEB_SN,
+  TILEPRO_OPC_SLTEB_U,
+  TILEPRO_OPC_SLTEB_U_SN,
+  TILEPRO_OPC_SLTEH,
+  TILEPRO_OPC_SLTEH_SN,
+  TILEPRO_OPC_SLTEH_U,
+  TILEPRO_OPC_SLTEH_U_SN,
+  TILEPRO_OPC_SLTH,
+  TILEPRO_OPC_SLTH_SN,
+  TILEPRO_OPC_SLTH_U,
+  TILEPRO_OPC_SLTH_U_SN,
+  TILEPRO_OPC_SLTI,
+  TILEPRO_OPC_SLTI_SN,
+  TILEPRO_OPC_SLTI_U,
+  TILEPRO_OPC_SLTI_U_SN,
+  TILEPRO_OPC_SLTIB,
+  TILEPRO_OPC_SLTIB_SN,
+  TILEPRO_OPC_SLTIB_U,
+  TILEPRO_OPC_SLTIB_U_SN,
+  TILEPRO_OPC_SLTIH,
+  TILEPRO_OPC_SLTIH_SN,
+  TILEPRO_OPC_SLTIH_U,
+  TILEPRO_OPC_SLTIH_U_SN,
+  TILEPRO_OPC_SNE,
+  TILEPRO_OPC_SNE_SN,
+  TILEPRO_OPC_SNEB,
+  TILEPRO_OPC_SNEB_SN,
+  TILEPRO_OPC_SNEH,
+  TILEPRO_OPC_SNEH_SN,
+  TILEPRO_OPC_SRA,
+  TILEPRO_OPC_SRA_SN,
+  TILEPRO_OPC_SRAB,
+  TILEPRO_OPC_SRAB_SN,
+  TILEPRO_OPC_SRAH,
+  TILEPRO_OPC_SRAH_SN,
+  TILEPRO_OPC_SRAI,
+  TILEPRO_OPC_SRAI_SN,
+  TILEPRO_OPC_SRAIB,
+  TILEPRO_OPC_SRAIB_SN,
+  TILEPRO_OPC_SRAIH,
+  TILEPRO_OPC_SRAIH_SN,
+  TILEPRO_OPC_SUB,
+  TILEPRO_OPC_SUB_SN,
+  TILEPRO_OPC_SUBB,
+  TILEPRO_OPC_SUBB_SN,
+  TILEPRO_OPC_SUBBS_U,
+  TILEPRO_OPC_SUBBS_U_SN,
+  TILEPRO_OPC_SUBH,
+  TILEPRO_OPC_SUBH_SN,
+  TILEPRO_OPC_SUBHS,
+  TILEPRO_OPC_SUBHS_SN,
+  TILEPRO_OPC_SUBS,
+  TILEPRO_OPC_SUBS_SN,
+  TILEPRO_OPC_SW,
+  TILEPRO_OPC_SWADD,
+  TILEPRO_OPC_SWINT0,
+  TILEPRO_OPC_SWINT1,
+  TILEPRO_OPC_SWINT2,
+  TILEPRO_OPC_SWINT3,
+  TILEPRO_OPC_TBLIDXB0,
+  TILEPRO_OPC_TBLIDXB0_SN,
+  TILEPRO_OPC_TBLIDXB1,
+  TILEPRO_OPC_TBLIDXB1_SN,
+  TILEPRO_OPC_TBLIDXB2,
+  TILEPRO_OPC_TBLIDXB2_SN,
+  TILEPRO_OPC_TBLIDXB3,
+  TILEPRO_OPC_TBLIDXB3_SN,
+  TILEPRO_OPC_TNS,
+  TILEPRO_OPC_TNS_SN,
+  TILEPRO_OPC_WH64,
+  TILEPRO_OPC_XOR,
+  TILEPRO_OPC_XOR_SN,
+  TILEPRO_OPC_XORI,
+  TILEPRO_OPC_XORI_SN,
+  TILEPRO_OPC_NONE
+} tilepro_mnemonic;
+
+
+
+
+typedef enum
+{
+  TILEPRO_PIPELINE_X0,
+  TILEPRO_PIPELINE_X1,
+  TILEPRO_PIPELINE_Y0,
+  TILEPRO_PIPELINE_Y1,
+  TILEPRO_PIPELINE_Y2,
+} tilepro_pipeline;
+
+#define tilepro_is_x_pipeline(p) ((int)(p) <= (int)TILEPRO_PIPELINE_X1)
+
+typedef enum
+{
+  TILEPRO_OP_TYPE_REGISTER,
+  TILEPRO_OP_TYPE_IMMEDIATE,
+  TILEPRO_OP_TYPE_ADDRESS,
+  TILEPRO_OP_TYPE_SPR
+} tilepro_operand_type;
+
+struct tilepro_operand
+{
+  /* Is this operand a register, immediate or address? */
+  tilepro_operand_type type;
+
+  /* The default relocation type for this operand.  */
+  signed int default_reloc : 16;
+
+  /* How many bits is this value? (used for range checking) */
+  unsigned int num_bits : 5;
+
+  /* Is the value signed? (used for range checking) */
+  unsigned int is_signed : 1;
+
+  /* Is this operand a source register? */
+  unsigned int is_src_reg : 1;
+
+  /* Is this operand written? (i.e. is it a destination register) */
+  unsigned int is_dest_reg : 1;
+
+  /* Is this operand PC-relative? */
+  unsigned int is_pc_relative : 1;
+
+  /* By how many bits do we right shift the value before inserting? */
+  unsigned int rightshift : 2;
+
+  /* Return the bits for this operand to be ORed into an existing bundle. */
+  tilepro_bundle_bits (*insert) (int op);
+
+  /* Extract this operand and return it. */
+  unsigned int (*extract) (tilepro_bundle_bits bundle);
+};
+
+
+extern const struct tilepro_operand tilepro_operands[];
+
+/* One finite-state machine per pipe for rapid instruction decoding. */
+extern const unsigned short * const
+tilepro_bundle_decoder_fsms[TILEPRO_NUM_PIPELINE_ENCODINGS];
+
+
+struct tilepro_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tilepro_mnemonic mnemonic;
+
+  /* A bit mask of which of the five pipes this instruction
+     is compatible with:
+     X0  0x01
+     X1  0x02
+     Y0  0x04
+     Y1  0x08
+     Y2  0x10 */
+  unsigned char pipes;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* Which register does this write implicitly, or TREG_ZERO if none? */
+  unsigned char implicitly_written_register;
+
+  /* Can this be bundled with other instructions (almost always true). */
+  unsigned char can_bundle;
+
+  /* The description of the operands. Each of these is an
+   * index into the tilepro_operands[] table. */
+  unsigned char operands[TILEPRO_NUM_PIPELINE_ENCODINGS][TILEPRO_MAX_OPERANDS];
+
+};
+
+extern const struct tilepro_opcode tilepro_opcodes[];
+
+
+/* Used for non-textual disassembly into structs. */
+struct tilepro_decoded_instruction
+{
+  const struct tilepro_opcode *opcode;
+  const struct tilepro_operand *operands[TILEPRO_MAX_OPERANDS];
+  int operand_values[TILEPRO_MAX_OPERANDS];
+};
+
+
+/* Disassemble a bundle into a struct for machine processing. */
+extern int parse_insn_tilepro(tilepro_bundle_bits bits,
+                              unsigned int pc,
+                              struct tilepro_decoded_instruction
+                              decoded[TILEPRO_MAX_INSTRUCTIONS_PER_BUNDLE]);
+
+
+/* Given a set of bundle bits and a specific pipe, returns which
+ * instruction the bundle contains in that pipe.
+ */
+extern const struct tilepro_opcode *
+find_opcode(tilepro_bundle_bits bits, tilepro_pipeline pipe);
+
+
+
+#endif /* opcode_tilepro_h */
diff --git a/arch/tile/include/asm/tile-desc_64.h b/arch/tile/include/asm/tile-desc_64.h
new file mode 100644
index 0000000..1819efc
--- /dev/null
+++ b/arch/tile/include/asm/tile-desc_64.h
@@ -0,0 +1,483 @@
+/* TILE-Gx opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
+#ifndef opcode_tile_h
+#define opcode_tile_h
+
+#include <arch/opcode.h>
+
+
+enum
+{
+  TILEGX_MAX_OPERANDS = 4 /* bfexts */
+};
+
+typedef enum
+{
+  TILEGX_OPC_BPT,
+  TILEGX_OPC_INFO,
+  TILEGX_OPC_INFOL,
+  TILEGX_OPC_MOVE,
+  TILEGX_OPC_MOVEI,
+  TILEGX_OPC_MOVELI,
+  TILEGX_OPC_PREFETCH,
+  TILEGX_OPC_PREFETCH_ADD_L1,
+  TILEGX_OPC_PREFETCH_ADD_L1_FAULT,
+  TILEGX_OPC_PREFETCH_ADD_L2,
+  TILEGX_OPC_PREFETCH_ADD_L2_FAULT,
+  TILEGX_OPC_PREFETCH_ADD_L3,
+  TILEGX_OPC_PREFETCH_ADD_L3_FAULT,
+  TILEGX_OPC_PREFETCH_L1,
+  TILEGX_OPC_PREFETCH_L1_FAULT,
+  TILEGX_OPC_PREFETCH_L2,
+  TILEGX_OPC_PREFETCH_L2_FAULT,
+  TILEGX_OPC_PREFETCH_L3,
+  TILEGX_OPC_PREFETCH_L3_FAULT,
+  TILEGX_OPC_RAISE,
+  TILEGX_OPC_ADD,
+  TILEGX_OPC_ADDI,
+  TILEGX_OPC_ADDLI,
+  TILEGX_OPC_ADDX,
+  TILEGX_OPC_ADDXI,
+  TILEGX_OPC_ADDXLI,
+  TILEGX_OPC_ADDXSC,
+  TILEGX_OPC_AND,
+  TILEGX_OPC_ANDI,
+  TILEGX_OPC_BEQZ,
+  TILEGX_OPC_BEQZT,
+  TILEGX_OPC_BFEXTS,
+  TILEGX_OPC_BFEXTU,
+  TILEGX_OPC_BFINS,
+  TILEGX_OPC_BGEZ,
+  TILEGX_OPC_BGEZT,
+  TILEGX_OPC_BGTZ,
+  TILEGX_OPC_BGTZT,
+  TILEGX_OPC_BLBC,
+  TILEGX_OPC_BLBCT,
+  TILEGX_OPC_BLBS,
+  TILEGX_OPC_BLBST,
+  TILEGX_OPC_BLEZ,
+  TILEGX_OPC_BLEZT,
+  TILEGX_OPC_BLTZ,
+  TILEGX_OPC_BLTZT,
+  TILEGX_OPC_BNEZ,
+  TILEGX_OPC_BNEZT,
+  TILEGX_OPC_CLZ,
+  TILEGX_OPC_CMOVEQZ,
+  TILEGX_OPC_CMOVNEZ,
+  TILEGX_OPC_CMPEQ,
+  TILEGX_OPC_CMPEQI,
+  TILEGX_OPC_CMPEXCH,
+  TILEGX_OPC_CMPEXCH4,
+  TILEGX_OPC_CMPLES,
+  TILEGX_OPC_CMPLEU,
+  TILEGX_OPC_CMPLTS,
+  TILEGX_OPC_CMPLTSI,
+  TILEGX_OPC_CMPLTU,
+  TILEGX_OPC_CMPLTUI,
+  TILEGX_OPC_CMPNE,
+  TILEGX_OPC_CMUL,
+  TILEGX_OPC_CMULA,
+  TILEGX_OPC_CMULAF,
+  TILEGX_OPC_CMULF,
+  TILEGX_OPC_CMULFR,
+  TILEGX_OPC_CMULH,
+  TILEGX_OPC_CMULHR,
+  TILEGX_OPC_CRC32_32,
+  TILEGX_OPC_CRC32_8,
+  TILEGX_OPC_CTZ,
+  TILEGX_OPC_DBLALIGN,
+  TILEGX_OPC_DBLALIGN2,
+  TILEGX_OPC_DBLALIGN4,
+  TILEGX_OPC_DBLALIGN6,
+  TILEGX_OPC_DRAIN,
+  TILEGX_OPC_DTLBPR,
+  TILEGX_OPC_EXCH,
+  TILEGX_OPC_EXCH4,
+  TILEGX_OPC_FDOUBLE_ADD_FLAGS,
+  TILEGX_OPC_FDOUBLE_ADDSUB,
+  TILEGX_OPC_FDOUBLE_MUL_FLAGS,
+  TILEGX_OPC_FDOUBLE_PACK1,
+  TILEGX_OPC_FDOUBLE_PACK2,
+  TILEGX_OPC_FDOUBLE_SUB_FLAGS,
+  TILEGX_OPC_FDOUBLE_UNPACK_MAX,
+  TILEGX_OPC_FDOUBLE_UNPACK_MIN,
+  TILEGX_OPC_FETCHADD,
+  TILEGX_OPC_FETCHADD4,
+  TILEGX_OPC_FETCHADDGEZ,
+  TILEGX_OPC_FETCHADDGEZ4,
+  TILEGX_OPC_FETCHAND,
+  TILEGX_OPC_FETCHAND4,
+  TILEGX_OPC_FETCHOR,
+  TILEGX_OPC_FETCHOR4,
+  TILEGX_OPC_FINV,
+  TILEGX_OPC_FLUSH,
+  TILEGX_OPC_FLUSHWB,
+  TILEGX_OPC_FNOP,
+  TILEGX_OPC_FSINGLE_ADD1,
+  TILEGX_OPC_FSINGLE_ADDSUB2,
+  TILEGX_OPC_FSINGLE_MUL1,
+  TILEGX_OPC_FSINGLE_MUL2,
+  TILEGX_OPC_FSINGLE_PACK1,
+  TILEGX_OPC_FSINGLE_PACK2,
+  TILEGX_OPC_FSINGLE_SUB1,
+  TILEGX_OPC_ICOH,
+  TILEGX_OPC_ILL,
+  TILEGX_OPC_INV,
+  TILEGX_OPC_IRET,
+  TILEGX_OPC_J,
+  TILEGX_OPC_JAL,
+  TILEGX_OPC_JALR,
+  TILEGX_OPC_JALRP,
+  TILEGX_OPC_JR,
+  TILEGX_OPC_JRP,
+  TILEGX_OPC_LD,
+  TILEGX_OPC_LD1S,
+  TILEGX_OPC_LD1S_ADD,
+  TILEGX_OPC_LD1U,
+  TILEGX_OPC_LD1U_ADD,
+  TILEGX_OPC_LD2S,
+  TILEGX_OPC_LD2S_ADD,
+  TILEGX_OPC_LD2U,
+  TILEGX_OPC_LD2U_ADD,
+  TILEGX_OPC_LD4S,
+  TILEGX_OPC_LD4S_ADD,
+  TILEGX_OPC_LD4U,
+  TILEGX_OPC_LD4U_ADD,
+  TILEGX_OPC_LD_ADD,
+  TILEGX_OPC_LDNA,
+  TILEGX_OPC_LDNA_ADD,
+  TILEGX_OPC_LDNT,
+  TILEGX_OPC_LDNT1S,
+  TILEGX_OPC_LDNT1S_ADD,
+  TILEGX_OPC_LDNT1U,
+  TILEGX_OPC_LDNT1U_ADD,
+  TILEGX_OPC_LDNT2S,
+  TILEGX_OPC_LDNT2S_ADD,
+  TILEGX_OPC_LDNT2U,
+  TILEGX_OPC_LDNT2U_ADD,
+  TILEGX_OPC_LDNT4S,
+  TILEGX_OPC_LDNT4S_ADD,
+  TILEGX_OPC_LDNT4U,
+  TILEGX_OPC_LDNT4U_ADD,
+  TILEGX_OPC_LDNT_ADD,
+  TILEGX_OPC_LNK,
+  TILEGX_OPC_MF,
+  TILEGX_OPC_MFSPR,
+  TILEGX_OPC_MM,
+  TILEGX_OPC_MNZ,
+  TILEGX_OPC_MTSPR,
+  TILEGX_OPC_MUL_HS_HS,
+  TILEGX_OPC_MUL_HS_HU,
+  TILEGX_OPC_MUL_HS_LS,
+  TILEGX_OPC_MUL_HS_LU,
+  TILEGX_OPC_MUL_HU_HU,
+  TILEGX_OPC_MUL_HU_LS,
+  TILEGX_OPC_MUL_HU_LU,
+  TILEGX_OPC_MUL_LS_LS,
+  TILEGX_OPC_MUL_LS_LU,
+  TILEGX_OPC_MUL_LU_LU,
+  TILEGX_OPC_MULA_HS_HS,
+  TILEGX_OPC_MULA_HS_HU,
+  TILEGX_OPC_MULA_HS_LS,
+  TILEGX_OPC_MULA_HS_LU,
+  TILEGX_OPC_MULA_HU_HU,
+  TILEGX_OPC_MULA_HU_LS,
+  TILEGX_OPC_MULA_HU_LU,
+  TILEGX_OPC_MULA_LS_LS,
+  TILEGX_OPC_MULA_LS_LU,
+  TILEGX_OPC_MULA_LU_LU,
+  TILEGX_OPC_MULAX,
+  TILEGX_OPC_MULX,
+  TILEGX_OPC_MZ,
+  TILEGX_OPC_NAP,
+  TILEGX_OPC_NOP,
+  TILEGX_OPC_NOR,
+  TILEGX_OPC_OR,
+  TILEGX_OPC_ORI,
+  TILEGX_OPC_PCNT,
+  TILEGX_OPC_REVBITS,
+  TILEGX_OPC_REVBYTES,
+  TILEGX_OPC_ROTL,
+  TILEGX_OPC_ROTLI,
+  TILEGX_OPC_SHL,
+  TILEGX_OPC_SHL16INSLI,
+  TILEGX_OPC_SHL1ADD,
+  TILEGX_OPC_SHL1ADDX,
+  TILEGX_OPC_SHL2ADD,
+  TILEGX_OPC_SHL2ADDX,
+  TILEGX_OPC_SHL3ADD,
+  TILEGX_OPC_SHL3ADDX,
+  TILEGX_OPC_SHLI,
+  TILEGX_OPC_SHLX,
+  TILEGX_OPC_SHLXI,
+  TILEGX_OPC_SHRS,
+  TILEGX_OPC_SHRSI,
+  TILEGX_OPC_SHRU,
+  TILEGX_OPC_SHRUI,
+  TILEGX_OPC_SHRUX,
+  TILEGX_OPC_SHRUXI,
+  TILEGX_OPC_SHUFFLEBYTES,
+  TILEGX_OPC_ST,
+  TILEGX_OPC_ST1,
+  TILEGX_OPC_ST1_ADD,
+  TILEGX_OPC_ST2,
+  TILEGX_OPC_ST2_ADD,
+  TILEGX_OPC_ST4,
+  TILEGX_OPC_ST4_ADD,
+  TILEGX_OPC_ST_ADD,
+  TILEGX_OPC_STNT,
+  TILEGX_OPC_STNT1,
+  TILEGX_OPC_STNT1_ADD,
+  TILEGX_OPC_STNT2,
+  TILEGX_OPC_STNT2_ADD,
+  TILEGX_OPC_STNT4,
+  TILEGX_OPC_STNT4_ADD,
+  TILEGX_OPC_STNT_ADD,
+  TILEGX_OPC_SUB,
+  TILEGX_OPC_SUBX,
+  TILEGX_OPC_SUBXSC,
+  TILEGX_OPC_SWINT0,
+  TILEGX_OPC_SWINT1,
+  TILEGX_OPC_SWINT2,
+  TILEGX_OPC_SWINT3,
+  TILEGX_OPC_TBLIDXB0,
+  TILEGX_OPC_TBLIDXB1,
+  TILEGX_OPC_TBLIDXB2,
+  TILEGX_OPC_TBLIDXB3,
+  TILEGX_OPC_V1ADD,
+  TILEGX_OPC_V1ADDI,
+  TILEGX_OPC_V1ADDUC,
+  TILEGX_OPC_V1ADIFFU,
+  TILEGX_OPC_V1AVGU,
+  TILEGX_OPC_V1CMPEQ,
+  TILEGX_OPC_V1CMPEQI,
+  TILEGX_OPC_V1CMPLES,
+  TILEGX_OPC_V1CMPLEU,
+  TILEGX_OPC_V1CMPLTS,
+  TILEGX_OPC_V1CMPLTSI,
+  TILEGX_OPC_V1CMPLTU,
+  TILEGX_OPC_V1CMPLTUI,
+  TILEGX_OPC_V1CMPNE,
+  TILEGX_OPC_V1DDOTPU,
+  TILEGX_OPC_V1DDOTPUA,
+  TILEGX_OPC_V1DDOTPUS,
+  TILEGX_OPC_V1DDOTPUSA,
+  TILEGX_OPC_V1DOTP,
+  TILEGX_OPC_V1DOTPA,
+  TILEGX_OPC_V1DOTPU,
+  TILEGX_OPC_V1DOTPUA,
+  TILEGX_OPC_V1DOTPUS,
+  TILEGX_OPC_V1DOTPUSA,
+  TILEGX_OPC_V1INT_H,
+  TILEGX_OPC_V1INT_L,
+  TILEGX_OPC_V1MAXU,
+  TILEGX_OPC_V1MAXUI,
+  TILEGX_OPC_V1MINU,
+  TILEGX_OPC_V1MINUI,
+  TILEGX_OPC_V1MNZ,
+  TILEGX_OPC_V1MULTU,
+  TILEGX_OPC_V1MULU,
+  TILEGX_OPC_V1MULUS,
+  TILEGX_OPC_V1MZ,
+  TILEGX_OPC_V1SADAU,
+  TILEGX_OPC_V1SADU,
+  TILEGX_OPC_V1SHL,
+  TILEGX_OPC_V1SHLI,
+  TILEGX_OPC_V1SHRS,
+  TILEGX_OPC_V1SHRSI,
+  TILEGX_OPC_V1SHRU,
+  TILEGX_OPC_V1SHRUI,
+  TILEGX_OPC_V1SUB,
+  TILEGX_OPC_V1SUBUC,
+  TILEGX_OPC_V2ADD,
+  TILEGX_OPC_V2ADDI,
+  TILEGX_OPC_V2ADDSC,
+  TILEGX_OPC_V2ADIFFS,
+  TILEGX_OPC_V2AVGS,
+  TILEGX_OPC_V2CMPEQ,
+  TILEGX_OPC_V2CMPEQI,
+  TILEGX_OPC_V2CMPLES,
+  TILEGX_OPC_V2CMPLEU,
+  TILEGX_OPC_V2CMPLTS,
+  TILEGX_OPC_V2CMPLTSI,
+  TILEGX_OPC_V2CMPLTU,
+  TILEGX_OPC_V2CMPLTUI,
+  TILEGX_OPC_V2CMPNE,
+  TILEGX_OPC_V2DOTP,
+  TILEGX_OPC_V2DOTPA,
+  TILEGX_OPC_V2INT_H,
+  TILEGX_OPC_V2INT_L,
+  TILEGX_OPC_V2MAXS,
+  TILEGX_OPC_V2MAXSI,
+  TILEGX_OPC_V2MINS,
+  TILEGX_OPC_V2MINSI,
+  TILEGX_OPC_V2MNZ,
+  TILEGX_OPC_V2MULFSC,
+  TILEGX_OPC_V2MULS,
+  TILEGX_OPC_V2MULTS,
+  TILEGX_OPC_V2MZ,
+  TILEGX_OPC_V2PACKH,
+  TILEGX_OPC_V2PACKL,
+  TILEGX_OPC_V2PACKUC,
+  TILEGX_OPC_V2SADAS,
+  TILEGX_OPC_V2SADAU,
+  TILEGX_OPC_V2SADS,
+  TILEGX_OPC_V2SADU,
+  TILEGX_OPC_V2SHL,
+  TILEGX_OPC_V2SHLI,
+  TILEGX_OPC_V2SHLSC,
+  TILEGX_OPC_V2SHRS,
+  TILEGX_OPC_V2SHRSI,
+  TILEGX_OPC_V2SHRU,
+  TILEGX_OPC_V2SHRUI,
+  TILEGX_OPC_V2SUB,
+  TILEGX_OPC_V2SUBSC,
+  TILEGX_OPC_V4ADD,
+  TILEGX_OPC_V4ADDSC,
+  TILEGX_OPC_V4INT_H,
+  TILEGX_OPC_V4INT_L,
+  TILEGX_OPC_V4PACKSC,
+  TILEGX_OPC_V4SHL,
+  TILEGX_OPC_V4SHLSC,
+  TILEGX_OPC_V4SHRS,
+  TILEGX_OPC_V4SHRU,
+  TILEGX_OPC_V4SUB,
+  TILEGX_OPC_V4SUBSC,
+  TILEGX_OPC_WH64,
+  TILEGX_OPC_XOR,
+  TILEGX_OPC_XORI,
+  TILEGX_OPC_NONE
+} tilegx_mnemonic;
+
+
+
+typedef enum
+{
+  TILEGX_PIPELINE_X0,
+  TILEGX_PIPELINE_X1,
+  TILEGX_PIPELINE_Y0,
+  TILEGX_PIPELINE_Y1,
+  TILEGX_PIPELINE_Y2,
+} tilegx_pipeline;
+
+#define tilegx_is_x_pipeline(p) ((int)(p) <= (int)TILEGX_PIPELINE_X1)
+
+typedef enum
+{
+  TILEGX_OP_TYPE_REGISTER,
+  TILEGX_OP_TYPE_IMMEDIATE,
+  TILEGX_OP_TYPE_ADDRESS,
+  TILEGX_OP_TYPE_SPR
+} tilegx_operand_type;
+
+struct tilegx_operand
+{
+  /* Is this operand a register, immediate or address? */
+  tilegx_operand_type type;
+
+  /* The default relocation type for this operand.  */
+  signed int default_reloc : 16;
+
+  /* How many bits is this value? (used for range checking) */
+  unsigned int num_bits : 5;
+
+  /* Is the value signed? (used for range checking) */
+  unsigned int is_signed : 1;
+
+  /* Is this operand a source register? */
+  unsigned int is_src_reg : 1;
+
+  /* Is this operand written? (i.e. is it a destination register) */
+  unsigned int is_dest_reg : 1;
+
+  /* Is this operand PC-relative? */
+  unsigned int is_pc_relative : 1;
+
+  /* By how many bits do we right shift the value before inserting? */
+  unsigned int rightshift : 2;
+
+  /* Return the bits for this operand to be ORed into an existing bundle. */
+  tilegx_bundle_bits (*insert) (int op);
+
+  /* Extract this operand and return it. */
+  unsigned int (*extract) (tilegx_bundle_bits bundle);
+};
+
+
+extern const struct tilegx_operand tilegx_operands[];
+
+/* One finite-state machine per pipe for rapid instruction decoding. */
+extern const unsigned short * const
+tilegx_bundle_decoder_fsms[TILEGX_NUM_PIPELINE_ENCODINGS];
+
+
+struct tilegx_opcode
+{
+  /* The opcode mnemonic, e.g. "add" */
+  const char *name;
+
+  /* The enum value for this mnemonic. */
+  tilegx_mnemonic mnemonic;
+
+  /* A bit mask of which of the five pipes this instruction
+     is compatible with:
+     X0  0x01
+     X1  0x02
+     Y0  0x04
+     Y1  0x08
+     Y2  0x10 */
+  unsigned char pipes;
+
+  /* How many operands are there? */
+  unsigned char num_operands;
+
+  /* Which register does this write implicitly, or TREG_ZERO if none? */
+  unsigned char implicitly_written_register;
+
+  /* Can this be bundled with other instructions (almost always true). */
+  unsigned char can_bundle;
+
+  /* The description of the operands. Each of these is an
+   * index into the tilegx_operands[] table. */
+  unsigned char operands[TILEGX_NUM_PIPELINE_ENCODINGS][TILEGX_MAX_OPERANDS];
+
+};
+
+extern const struct tilegx_opcode tilegx_opcodes[];
+
+/* Used for non-textual disassembly into structs. */
+struct tilegx_decoded_instruction
+{
+  const struct tilegx_opcode *opcode;
+  const struct tilegx_operand *operands[TILEGX_MAX_OPERANDS];
+  long long operand_values[TILEGX_MAX_OPERANDS];
+};
+
+
+/* Disassemble a bundle into a struct for machine processing. */
+extern int parse_insn_tilegx(tilegx_bundle_bits bits,
+                             unsigned long long pc,
+                             struct tilegx_decoded_instruction
+                             decoded[TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE]);
+
+
+
+#endif /* opcode_tilegx_h */
diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
index 1dc71ea..9092ce8 100644
--- a/arch/tile/kernel/backtrace.c
+++ b/arch/tile/kernel/backtrace.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License
@@ -15,13 +15,11 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <asm/backtrace.h>
-#include <asm/opcode-tile.h>
+#include <asm/tile-desc.h>
 #include <arch/abi.h>
 
 #ifdef __tilegx__
-#define tile_bundle_bits tilegx_bundle_bits
 #define TILE_MAX_INSTRUCTIONS_PER_BUNDLE TILEGX_MAX_INSTRUCTIONS_PER_BUNDLE
-#define TILE_BUNDLE_ALIGNMENT_IN_BYTES TILEGX_BUNDLE_ALIGNMENT_IN_BYTES
 #define tile_decoded_instruction tilegx_decoded_instruction
 #define tile_mnemonic tilegx_mnemonic
 #define parse_insn_tile parse_insn_tilegx
@@ -35,7 +33,18 @@
 #define OPCODE_STORE TILEGX_OPC_ST
 typedef long long bt_int_reg_t;
 #else
-#define OPCODE_STORE TILE_OPC_SW
+#define TILE_MAX_INSTRUCTIONS_PER_BUNDLE TILEPRO_MAX_INSTRUCTIONS_PER_BUNDLE
+#define tile_decoded_instruction tilepro_decoded_instruction
+#define tile_mnemonic tilepro_mnemonic
+#define parse_insn_tile parse_insn_tilepro
+#define TILE_OPC_IRET TILEPRO_OPC_IRET
+#define TILE_OPC_ADDI TILEPRO_OPC_ADDI
+#define TILE_OPC_ADDLI TILEPRO_OPC_ADDLI
+#define TILE_OPC_INFO TILEPRO_OPC_INFO
+#define TILE_OPC_INFOL TILEPRO_OPC_INFOL
+#define TILE_OPC_JRP TILEPRO_OPC_JRP
+#define TILE_OPC_MOVE TILEPRO_OPC_MOVE
+#define OPCODE_STORE TILEPRO_OPC_SW
 typedef int bt_int_reg_t;
 #endif
 
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index 28fa6ec..b90ab99 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -20,9 +20,9 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
-#include <asm/opcode-tile.h>
 #include <asm/pgtable.h>
 #include <asm/homecache.h>
+#include <arch/opcode.h>
 
 #ifdef __tilegx__
 # define Elf_Rela Elf64_Rela
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 4032ca8..b7a8795 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -25,9 +25,8 @@
 #include <linux/types.h>
 #include <linux/err.h>
 #include <asm/cacheflush.h>
-#include <asm/opcode-tile.h>
-#include <asm/opcode_constants.h>
 #include <arch/abi.h>
+#include <arch/opcode.h>
 
 #define signExtend17(val) sign_extend((val), 17)
 #define TILE_X1_MASK (0xffffffffULL << 31)
@@ -118,7 +117,7 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 	int val_reg, addr_reg, err, val;
 
 	/* Get address and value registers */
-	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK) {
+	if (bundle & TILEPRO_BUNDLE_Y_ENCODING_MASK) {
 		addr_reg = get_SrcA_Y2(bundle);
 		val_reg = get_SrcBDest_Y2(bundle);
 	} else if (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) {
@@ -229,7 +228,7 @@ P("\n");
 	}
 	++unaligned_fixup_count;
 
-	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK) {
+	if (bundle & TILEPRO_BUNDLE_Y_ENCODING_MASK) {
 		/* Convert the Y2 instruction to a prefetch. */
 		bundle &= ~(create_SrcBDest_Y2(-1) |
 			    create_Opcode_Y2(-1));
@@ -389,7 +388,7 @@ void single_step_once(struct pt_regs *regs)
 	state->branch_next_pc = 0;
 	state->update = 0;
 
-	if (!(bundle & TILE_BUNDLE_Y_ENCODING_MASK)) {
+	if (!(bundle & TILEPRO_BUNDLE_Y_ENCODING_MASK)) {
 		/* two wide, check for control flow */
 		int opcode = get_Opcode_X1(bundle);
 
diff --git a/arch/tile/kernel/tile-desc_32.c b/arch/tile/kernel/tile-desc_32.c
index 7e31a12..dd7bd1d 100644
--- a/arch/tile/kernel/tile-desc_32.c
+++ b/arch/tile/kernel/tile-desc_32.c
@@ -1,3 +1,23 @@
+/* TILEPro opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
 /* This define is BFD_RELOC_##x for real bfd, or -1 for everyone else. */
 #define BFD_RELOC(x) -1
 
@@ -6,1217 +26,1217 @@
 #define TREG_SN 56
 #define TREG_ZERO 63
 
-/* FIXME: Rename this. */
-#include <asm/opcode-tile.h>
-
 #include <linux/stddef.h>
+#include <asm/tile-desc.h>
 
-const struct tile_opcode tile_opcodes[395] =
+const struct tilepro_opcode tilepro_opcodes[395] =
 {
- { "bpt", TILE_OPC_BPT, 0x2, 0, TREG_ZERO, 0,
+ { "bpt", TILEPRO_OPC_BPT, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "info", TILE_OPC_INFO, 0xf, 1, TREG_ZERO, 1,
+  { "info", TILEPRO_OPC_INFO, 0xf, 1, TREG_ZERO, 1,
     { { 0 }, { 1 }, { 2 }, { 3 }, { 0, } },
   },
-  { "infol", TILE_OPC_INFOL, 0x3, 1, TREG_ZERO, 1,
+  { "infol", TILEPRO_OPC_INFOL, 0x3, 1, TREG_ZERO, 1,
     { { 4 }, { 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "j", TILE_OPC_J, 0x2, 1, TREG_ZERO, 1,
+  { "j", TILEPRO_OPC_J, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 6 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jal", TILE_OPC_JAL, 0x2, 1, TREG_LR, 1,
+  { "jal", TILEPRO_OPC_JAL, 0x2, 1, TREG_LR, 1,
     { { 0, }, { 6 }, { 0, }, { 0, }, { 0, } },
   },
-  { "move", TILE_OPC_MOVE, 0xf, 2, TREG_ZERO, 1,
+  { "move", TILEPRO_OPC_MOVE, 0xf, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 9, 10 }, { 11, 12 }, { 13, 14 }, { 0, } },
   },
-  { "move.sn", TILE_OPC_MOVE_SN, 0x3, 2, TREG_SN, 1,
+  { "move.sn", TILEPRO_OPC_MOVE_SN, 0x3, 2, TREG_SN, 1,
     { { 7, 8 }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "movei", TILE_OPC_MOVEI, 0xf, 2, TREG_ZERO, 1,
+  { "movei", TILEPRO_OPC_MOVEI, 0xf, 2, TREG_ZERO, 1,
     { { 7, 0 }, { 9, 1 }, { 11, 2 }, { 13, 3 }, { 0, } },
   },
-  { "movei.sn", TILE_OPC_MOVEI_SN, 0x3, 2, TREG_SN, 1,
+  { "movei.sn", TILEPRO_OPC_MOVEI_SN, 0x3, 2, TREG_SN, 1,
     { { 7, 0 }, { 9, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "moveli", TILE_OPC_MOVELI, 0x3, 2, TREG_ZERO, 1,
+  { "moveli", TILEPRO_OPC_MOVELI, 0x3, 2, TREG_ZERO, 1,
     { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "moveli.sn", TILE_OPC_MOVELI_SN, 0x3, 2, TREG_SN, 1,
+  { "moveli.sn", TILEPRO_OPC_MOVELI_SN, 0x3, 2, TREG_SN, 1,
     { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "movelis", TILE_OPC_MOVELIS, 0x3, 2, TREG_SN, 1,
+  { "movelis", TILEPRO_OPC_MOVELIS, 0x3, 2, TREG_SN, 1,
     { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "prefetch", TILE_OPC_PREFETCH, 0x12, 1, TREG_ZERO, 1,
+  { "prefetch", TILEPRO_OPC_PREFETCH, 0x12, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 15 } },
   },
-  { "raise", TILE_OPC_RAISE, 0x2, 0, TREG_ZERO, 1,
+  { "raise", TILEPRO_OPC_RAISE, 0x2, 0, TREG_ZERO, 1,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "add", TILE_OPC_ADD, 0xf, 3, TREG_ZERO, 1,
+  { "add", TILEPRO_OPC_ADD, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "add.sn", TILE_OPC_ADD_SN, 0x3, 3, TREG_SN, 1,
+  { "add.sn", TILEPRO_OPC_ADD_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addb", TILE_OPC_ADDB, 0x3, 3, TREG_ZERO, 1,
+  { "addb", TILEPRO_OPC_ADDB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addb.sn", TILE_OPC_ADDB_SN, 0x3, 3, TREG_SN, 1,
+  { "addb.sn", TILEPRO_OPC_ADDB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addbs_u", TILE_OPC_ADDBS_U, 0x3, 3, TREG_ZERO, 1,
+  { "addbs_u", TILEPRO_OPC_ADDBS_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addbs_u.sn", TILE_OPC_ADDBS_U_SN, 0x3, 3, TREG_SN, 1,
+  { "addbs_u.sn", TILEPRO_OPC_ADDBS_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addh", TILE_OPC_ADDH, 0x3, 3, TREG_ZERO, 1,
+  { "addh", TILEPRO_OPC_ADDH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addh.sn", TILE_OPC_ADDH_SN, 0x3, 3, TREG_SN, 1,
+  { "addh.sn", TILEPRO_OPC_ADDH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addhs", TILE_OPC_ADDHS, 0x3, 3, TREG_ZERO, 1,
+  { "addhs", TILEPRO_OPC_ADDHS, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addhs.sn", TILE_OPC_ADDHS_SN, 0x3, 3, TREG_SN, 1,
+  { "addhs.sn", TILEPRO_OPC_ADDHS_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addi", TILE_OPC_ADDI, 0xf, 3, TREG_ZERO, 1,
+  { "addi", TILEPRO_OPC_ADDI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "addi.sn", TILE_OPC_ADDI_SN, 0x3, 3, TREG_SN, 1,
+  { "addi.sn", TILEPRO_OPC_ADDI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addib", TILE_OPC_ADDIB, 0x3, 3, TREG_ZERO, 1,
+  { "addib", TILEPRO_OPC_ADDIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addib.sn", TILE_OPC_ADDIB_SN, 0x3, 3, TREG_SN, 1,
+  { "addib.sn", TILEPRO_OPC_ADDIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addih", TILE_OPC_ADDIH, 0x3, 3, TREG_ZERO, 1,
+  { "addih", TILEPRO_OPC_ADDIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addih.sn", TILE_OPC_ADDIH_SN, 0x3, 3, TREG_SN, 1,
+  { "addih.sn", TILEPRO_OPC_ADDIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addli", TILE_OPC_ADDLI, 0x3, 3, TREG_ZERO, 1,
+  { "addli", TILEPRO_OPC_ADDLI, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addli.sn", TILE_OPC_ADDLI_SN, 0x3, 3, TREG_SN, 1,
+  { "addli.sn", TILEPRO_OPC_ADDLI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addlis", TILE_OPC_ADDLIS, 0x3, 3, TREG_SN, 1,
+  { "addlis", TILEPRO_OPC_ADDLIS, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adds", TILE_OPC_ADDS, 0x3, 3, TREG_ZERO, 1,
+  { "adds", TILEPRO_OPC_ADDS, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adds.sn", TILE_OPC_ADDS_SN, 0x3, 3, TREG_SN, 1,
+  { "adds.sn", TILEPRO_OPC_ADDS_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffb_u", TILE_OPC_ADIFFB_U, 0x1, 3, TREG_ZERO, 1,
+  { "adiffb_u", TILEPRO_OPC_ADIFFB_U, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffb_u.sn", TILE_OPC_ADIFFB_U_SN, 0x1, 3, TREG_SN, 1,
+  { "adiffb_u.sn", TILEPRO_OPC_ADIFFB_U_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffh", TILE_OPC_ADIFFH, 0x1, 3, TREG_ZERO, 1,
+  { "adiffh", TILEPRO_OPC_ADIFFH, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffh.sn", TILE_OPC_ADIFFH_SN, 0x1, 3, TREG_SN, 1,
+  { "adiffh.sn", TILEPRO_OPC_ADIFFH_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "and", TILE_OPC_AND, 0xf, 3, TREG_ZERO, 1,
+  { "and", TILEPRO_OPC_AND, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "and.sn", TILE_OPC_AND_SN, 0x3, 3, TREG_SN, 1,
+  { "and.sn", TILEPRO_OPC_AND_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "andi", TILE_OPC_ANDI, 0xf, 3, TREG_ZERO, 1,
+  { "andi", TILEPRO_OPC_ANDI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "andi.sn", TILE_OPC_ANDI_SN, 0x3, 3, TREG_SN, 1,
+  { "andi.sn", TILEPRO_OPC_ANDI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "auli", TILE_OPC_AULI, 0x3, 3, TREG_ZERO, 1,
+  { "auli", TILEPRO_OPC_AULI, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgb_u", TILE_OPC_AVGB_U, 0x1, 3, TREG_ZERO, 1,
+  { "avgb_u", TILEPRO_OPC_AVGB_U, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgb_u.sn", TILE_OPC_AVGB_U_SN, 0x1, 3, TREG_SN, 1,
+  { "avgb_u.sn", TILEPRO_OPC_AVGB_U_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgh", TILE_OPC_AVGH, 0x1, 3, TREG_ZERO, 1,
+  { "avgh", TILEPRO_OPC_AVGH, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgh.sn", TILE_OPC_AVGH_SN, 0x1, 3, TREG_SN, 1,
+  { "avgh.sn", TILEPRO_OPC_AVGH_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbns", TILE_OPC_BBNS, 0x2, 2, TREG_ZERO, 1,
+  { "bbns", TILEPRO_OPC_BBNS, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbns.sn", TILE_OPC_BBNS_SN, 0x2, 2, TREG_SN, 1,
+  { "bbns.sn", TILEPRO_OPC_BBNS_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbnst", TILE_OPC_BBNST, 0x2, 2, TREG_ZERO, 1,
+  { "bbnst", TILEPRO_OPC_BBNST, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbnst.sn", TILE_OPC_BBNST_SN, 0x2, 2, TREG_SN, 1,
+  { "bbnst.sn", TILEPRO_OPC_BBNST_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbs", TILE_OPC_BBS, 0x2, 2, TREG_ZERO, 1,
+  { "bbs", TILEPRO_OPC_BBS, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbs.sn", TILE_OPC_BBS_SN, 0x2, 2, TREG_SN, 1,
+  { "bbs.sn", TILEPRO_OPC_BBS_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbst", TILE_OPC_BBST, 0x2, 2, TREG_ZERO, 1,
+  { "bbst", TILEPRO_OPC_BBST, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbst.sn", TILE_OPC_BBST_SN, 0x2, 2, TREG_SN, 1,
+  { "bbst.sn", TILEPRO_OPC_BBST_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgez", TILE_OPC_BGEZ, 0x2, 2, TREG_ZERO, 1,
+  { "bgez", TILEPRO_OPC_BGEZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgez.sn", TILE_OPC_BGEZ_SN, 0x2, 2, TREG_SN, 1,
+  { "bgez.sn", TILEPRO_OPC_BGEZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgezt", TILE_OPC_BGEZT, 0x2, 2, TREG_ZERO, 1,
+  { "bgezt", TILEPRO_OPC_BGEZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgezt.sn", TILE_OPC_BGEZT_SN, 0x2, 2, TREG_SN, 1,
+  { "bgezt.sn", TILEPRO_OPC_BGEZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgz", TILE_OPC_BGZ, 0x2, 2, TREG_ZERO, 1,
+  { "bgz", TILEPRO_OPC_BGZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgz.sn", TILE_OPC_BGZ_SN, 0x2, 2, TREG_SN, 1,
+  { "bgz.sn", TILEPRO_OPC_BGZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgzt", TILE_OPC_BGZT, 0x2, 2, TREG_ZERO, 1,
+  { "bgzt", TILEPRO_OPC_BGZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgzt.sn", TILE_OPC_BGZT_SN, 0x2, 2, TREG_SN, 1,
+  { "bgzt.sn", TILEPRO_OPC_BGZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bitx", TILE_OPC_BITX, 0x5, 2, TREG_ZERO, 1,
+  { "bitx", TILEPRO_OPC_BITX, 0x5, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "bitx.sn", TILE_OPC_BITX_SN, 0x1, 2, TREG_SN, 1,
+  { "bitx.sn", TILEPRO_OPC_BITX_SN, 0x1, 2, TREG_SN, 1,
     { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "blez", TILE_OPC_BLEZ, 0x2, 2, TREG_ZERO, 1,
+  { "blez", TILEPRO_OPC_BLEZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blez.sn", TILE_OPC_BLEZ_SN, 0x2, 2, TREG_SN, 1,
+  { "blez.sn", TILEPRO_OPC_BLEZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blezt", TILE_OPC_BLEZT, 0x2, 2, TREG_ZERO, 1,
+  { "blezt", TILEPRO_OPC_BLEZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blezt.sn", TILE_OPC_BLEZT_SN, 0x2, 2, TREG_SN, 1,
+  { "blezt.sn", TILEPRO_OPC_BLEZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blz", TILE_OPC_BLZ, 0x2, 2, TREG_ZERO, 1,
+  { "blz", TILEPRO_OPC_BLZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blz.sn", TILE_OPC_BLZ_SN, 0x2, 2, TREG_SN, 1,
+  { "blz.sn", TILEPRO_OPC_BLZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blzt", TILE_OPC_BLZT, 0x2, 2, TREG_ZERO, 1,
+  { "blzt", TILEPRO_OPC_BLZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blzt.sn", TILE_OPC_BLZT_SN, 0x2, 2, TREG_SN, 1,
+  { "blzt.sn", TILEPRO_OPC_BLZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnz", TILE_OPC_BNZ, 0x2, 2, TREG_ZERO, 1,
+  { "bnz", TILEPRO_OPC_BNZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnz.sn", TILE_OPC_BNZ_SN, 0x2, 2, TREG_SN, 1,
+  { "bnz.sn", TILEPRO_OPC_BNZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnzt", TILE_OPC_BNZT, 0x2, 2, TREG_ZERO, 1,
+  { "bnzt", TILEPRO_OPC_BNZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnzt.sn", TILE_OPC_BNZT_SN, 0x2, 2, TREG_SN, 1,
+  { "bnzt.sn", TILEPRO_OPC_BNZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bytex", TILE_OPC_BYTEX, 0x5, 2, TREG_ZERO, 1,
+  { "bytex", TILEPRO_OPC_BYTEX, 0x5, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "bytex.sn", TILE_OPC_BYTEX_SN, 0x1, 2, TREG_SN, 1,
+  { "bytex.sn", TILEPRO_OPC_BYTEX_SN, 0x1, 2, TREG_SN, 1,
     { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "bz", TILE_OPC_BZ, 0x2, 2, TREG_ZERO, 1,
+  { "bz", TILEPRO_OPC_BZ, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bz.sn", TILE_OPC_BZ_SN, 0x2, 2, TREG_SN, 1,
+  { "bz.sn", TILEPRO_OPC_BZ_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bzt", TILE_OPC_BZT, 0x2, 2, TREG_ZERO, 1,
+  { "bzt", TILEPRO_OPC_BZT, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bzt.sn", TILE_OPC_BZT_SN, 0x2, 2, TREG_SN, 1,
+  { "bzt.sn", TILEPRO_OPC_BZT_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "clz", TILE_OPC_CLZ, 0x5, 2, TREG_ZERO, 1,
+  { "clz", TILEPRO_OPC_CLZ, 0x5, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "clz.sn", TILE_OPC_CLZ_SN, 0x1, 2, TREG_SN, 1,
+  { "clz.sn", TILEPRO_OPC_CLZ_SN, 0x1, 2, TREG_SN, 1,
     { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_32", TILE_OPC_CRC32_32, 0x1, 3, TREG_ZERO, 1,
+  { "crc32_32", TILEPRO_OPC_CRC32_32, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_32.sn", TILE_OPC_CRC32_32_SN, 0x1, 3, TREG_SN, 1,
+  { "crc32_32.sn", TILEPRO_OPC_CRC32_32_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_8", TILE_OPC_CRC32_8, 0x1, 3, TREG_ZERO, 1,
+  { "crc32_8", TILEPRO_OPC_CRC32_8, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_8.sn", TILE_OPC_CRC32_8_SN, 0x1, 3, TREG_SN, 1,
+  { "crc32_8.sn", TILEPRO_OPC_CRC32_8_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "ctz", TILE_OPC_CTZ, 0x5, 2, TREG_ZERO, 1,
+  { "ctz", TILEPRO_OPC_CTZ, 0x5, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "ctz.sn", TILE_OPC_CTZ_SN, 0x1, 2, TREG_SN, 1,
+  { "ctz.sn", TILEPRO_OPC_CTZ_SN, 0x1, 2, TREG_SN, 1,
     { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "drain", TILE_OPC_DRAIN, 0x2, 0, TREG_ZERO, 0,
+  { "drain", TILEPRO_OPC_DRAIN, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "dtlbpr", TILE_OPC_DTLBPR, 0x2, 1, TREG_ZERO, 1,
+  { "dtlbpr", TILEPRO_OPC_DTLBPR, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "dword_align", TILE_OPC_DWORD_ALIGN, 0x1, 3, TREG_ZERO, 1,
+  { "dword_align", TILEPRO_OPC_DWORD_ALIGN, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "dword_align.sn", TILE_OPC_DWORD_ALIGN_SN, 0x1, 3, TREG_SN, 1,
+  { "dword_align.sn", TILEPRO_OPC_DWORD_ALIGN_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "finv", TILE_OPC_FINV, 0x2, 1, TREG_ZERO, 1,
+  { "finv", TILEPRO_OPC_FINV, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "flush", TILE_OPC_FLUSH, 0x2, 1, TREG_ZERO, 1,
+  { "flush", TILEPRO_OPC_FLUSH, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "fnop", TILE_OPC_FNOP, 0xf, 0, TREG_ZERO, 1,
+  { "fnop", TILEPRO_OPC_FNOP, 0xf, 0, TREG_ZERO, 1,
     { {  }, {  }, {  }, {  }, { 0, } },
   },
-  { "icoh", TILE_OPC_ICOH, 0x2, 1, TREG_ZERO, 1,
+  { "icoh", TILEPRO_OPC_ICOH, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "ill", TILE_OPC_ILL, 0xa, 0, TREG_ZERO, 1,
+  { "ill", TILEPRO_OPC_ILL, 0xa, 0, TREG_ZERO, 1,
     { { 0, }, {  }, { 0, }, {  }, { 0, } },
   },
-  { "inthb", TILE_OPC_INTHB, 0x3, 3, TREG_ZERO, 1,
+  { "inthb", TILEPRO_OPC_INTHB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthb.sn", TILE_OPC_INTHB_SN, 0x3, 3, TREG_SN, 1,
+  { "inthb.sn", TILEPRO_OPC_INTHB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthh", TILE_OPC_INTHH, 0x3, 3, TREG_ZERO, 1,
+  { "inthh", TILEPRO_OPC_INTHH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthh.sn", TILE_OPC_INTHH_SN, 0x3, 3, TREG_SN, 1,
+  { "inthh.sn", TILEPRO_OPC_INTHH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlb", TILE_OPC_INTLB, 0x3, 3, TREG_ZERO, 1,
+  { "intlb", TILEPRO_OPC_INTLB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlb.sn", TILE_OPC_INTLB_SN, 0x3, 3, TREG_SN, 1,
+  { "intlb.sn", TILEPRO_OPC_INTLB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlh", TILE_OPC_INTLH, 0x3, 3, TREG_ZERO, 1,
+  { "intlh", TILEPRO_OPC_INTLH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlh.sn", TILE_OPC_INTLH_SN, 0x3, 3, TREG_SN, 1,
+  { "intlh.sn", TILEPRO_OPC_INTLH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inv", TILE_OPC_INV, 0x2, 1, TREG_ZERO, 1,
+  { "inv", TILEPRO_OPC_INV, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "iret", TILE_OPC_IRET, 0x2, 0, TREG_ZERO, 1,
+  { "iret", TILEPRO_OPC_IRET, 0x2, 0, TREG_ZERO, 1,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalb", TILE_OPC_JALB, 0x2, 1, TREG_LR, 1,
+  { "jalb", TILEPRO_OPC_JALB, 0x2, 1, TREG_LR, 1,
     { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalf", TILE_OPC_JALF, 0x2, 1, TREG_LR, 1,
+  { "jalf", TILEPRO_OPC_JALF, 0x2, 1, TREG_LR, 1,
     { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalr", TILE_OPC_JALR, 0x2, 1, TREG_LR, 1,
+  { "jalr", TILEPRO_OPC_JALR, 0x2, 1, TREG_LR, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalrp", TILE_OPC_JALRP, 0x2, 1, TREG_LR, 1,
+  { "jalrp", TILEPRO_OPC_JALRP, 0x2, 1, TREG_LR, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jb", TILE_OPC_JB, 0x2, 1, TREG_ZERO, 1,
+  { "jb", TILEPRO_OPC_JB, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jf", TILE_OPC_JF, 0x2, 1, TREG_ZERO, 1,
+  { "jf", TILEPRO_OPC_JF, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jr", TILE_OPC_JR, 0x2, 1, TREG_ZERO, 1,
+  { "jr", TILEPRO_OPC_JR, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jrp", TILE_OPC_JRP, 0x2, 1, TREG_ZERO, 1,
+  { "jrp", TILEPRO_OPC_JRP, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lb", TILE_OPC_LB, 0x12, 2, TREG_ZERO, 1,
+  { "lb", TILEPRO_OPC_LB, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lb.sn", TILE_OPC_LB_SN, 0x2, 2, TREG_SN, 1,
+  { "lb.sn", TILEPRO_OPC_LB_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lb_u", TILE_OPC_LB_U, 0x12, 2, TREG_ZERO, 1,
+  { "lb_u", TILEPRO_OPC_LB_U, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lb_u.sn", TILE_OPC_LB_U_SN, 0x2, 2, TREG_SN, 1,
+  { "lb_u.sn", TILEPRO_OPC_LB_U_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd", TILE_OPC_LBADD, 0x2, 3, TREG_ZERO, 1,
+  { "lbadd", TILEPRO_OPC_LBADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd.sn", TILE_OPC_LBADD_SN, 0x2, 3, TREG_SN, 1,
+  { "lbadd.sn", TILEPRO_OPC_LBADD_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd_u", TILE_OPC_LBADD_U, 0x2, 3, TREG_ZERO, 1,
+  { "lbadd_u", TILEPRO_OPC_LBADD_U, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd_u.sn", TILE_OPC_LBADD_U_SN, 0x2, 3, TREG_SN, 1,
+  { "lbadd_u.sn", TILEPRO_OPC_LBADD_U_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lh", TILE_OPC_LH, 0x12, 2, TREG_ZERO, 1,
+  { "lh", TILEPRO_OPC_LH, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lh.sn", TILE_OPC_LH_SN, 0x2, 2, TREG_SN, 1,
+  { "lh.sn", TILEPRO_OPC_LH_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lh_u", TILE_OPC_LH_U, 0x12, 2, TREG_ZERO, 1,
+  { "lh_u", TILEPRO_OPC_LH_U, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lh_u.sn", TILE_OPC_LH_U_SN, 0x2, 2, TREG_SN, 1,
+  { "lh_u.sn", TILEPRO_OPC_LH_U_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd", TILE_OPC_LHADD, 0x2, 3, TREG_ZERO, 1,
+  { "lhadd", TILEPRO_OPC_LHADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd.sn", TILE_OPC_LHADD_SN, 0x2, 3, TREG_SN, 1,
+  { "lhadd.sn", TILEPRO_OPC_LHADD_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd_u", TILE_OPC_LHADD_U, 0x2, 3, TREG_ZERO, 1,
+  { "lhadd_u", TILEPRO_OPC_LHADD_U, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd_u.sn", TILE_OPC_LHADD_U_SN, 0x2, 3, TREG_SN, 1,
+  { "lhadd_u.sn", TILEPRO_OPC_LHADD_U_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lnk", TILE_OPC_LNK, 0x2, 1, TREG_ZERO, 1,
+  { "lnk", TILEPRO_OPC_LNK, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 9 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lnk.sn", TILE_OPC_LNK_SN, 0x2, 1, TREG_SN, 1,
+  { "lnk.sn", TILEPRO_OPC_LNK_SN, 0x2, 1, TREG_SN, 1,
     { { 0, }, { 9 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw", TILE_OPC_LW, 0x12, 2, TREG_ZERO, 1,
+  { "lw", TILEPRO_OPC_LW, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lw.sn", TILE_OPC_LW_SN, 0x2, 2, TREG_SN, 1,
+  { "lw.sn", TILEPRO_OPC_LW_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw_na", TILE_OPC_LW_NA, 0x2, 2, TREG_ZERO, 1,
+  { "lw_na", TILEPRO_OPC_LW_NA, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw_na.sn", TILE_OPC_LW_NA_SN, 0x2, 2, TREG_SN, 1,
+  { "lw_na.sn", TILEPRO_OPC_LW_NA_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd", TILE_OPC_LWADD, 0x2, 3, TREG_ZERO, 1,
+  { "lwadd", TILEPRO_OPC_LWADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd.sn", TILE_OPC_LWADD_SN, 0x2, 3, TREG_SN, 1,
+  { "lwadd.sn", TILEPRO_OPC_LWADD_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd_na", TILE_OPC_LWADD_NA, 0x2, 3, TREG_ZERO, 1,
+  { "lwadd_na", TILEPRO_OPC_LWADD_NA, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd_na.sn", TILE_OPC_LWADD_NA_SN, 0x2, 3, TREG_SN, 1,
+  { "lwadd_na.sn", TILEPRO_OPC_LWADD_NA_SN, 0x2, 3, TREG_SN, 1,
     { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxb_u", TILE_OPC_MAXB_U, 0x3, 3, TREG_ZERO, 1,
+  { "maxb_u", TILEPRO_OPC_MAXB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxb_u.sn", TILE_OPC_MAXB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "maxb_u.sn", TILEPRO_OPC_MAXB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxh", TILE_OPC_MAXH, 0x3, 3, TREG_ZERO, 1,
+  { "maxh", TILEPRO_OPC_MAXH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxh.sn", TILE_OPC_MAXH_SN, 0x3, 3, TREG_SN, 1,
+  { "maxh.sn", TILEPRO_OPC_MAXH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxib_u", TILE_OPC_MAXIB_U, 0x3, 3, TREG_ZERO, 1,
+  { "maxib_u", TILEPRO_OPC_MAXIB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxib_u.sn", TILE_OPC_MAXIB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "maxib_u.sn", TILEPRO_OPC_MAXIB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxih", TILE_OPC_MAXIH, 0x3, 3, TREG_ZERO, 1,
+  { "maxih", TILEPRO_OPC_MAXIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxih.sn", TILE_OPC_MAXIH_SN, 0x3, 3, TREG_SN, 1,
+  { "maxih.sn", TILEPRO_OPC_MAXIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mf", TILE_OPC_MF, 0x2, 0, TREG_ZERO, 1,
+  { "mf", TILEPRO_OPC_MF, 0x2, 0, TREG_ZERO, 1,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "mfspr", TILE_OPC_MFSPR, 0x2, 2, TREG_ZERO, 1,
+  { "mfspr", TILEPRO_OPC_MFSPR, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 25 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minb_u", TILE_OPC_MINB_U, 0x3, 3, TREG_ZERO, 1,
+  { "minb_u", TILEPRO_OPC_MINB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minb_u.sn", TILE_OPC_MINB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "minb_u.sn", TILEPRO_OPC_MINB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minh", TILE_OPC_MINH, 0x3, 3, TREG_ZERO, 1,
+  { "minh", TILEPRO_OPC_MINH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minh.sn", TILE_OPC_MINH_SN, 0x3, 3, TREG_SN, 1,
+  { "minh.sn", TILEPRO_OPC_MINH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minib_u", TILE_OPC_MINIB_U, 0x3, 3, TREG_ZERO, 1,
+  { "minib_u", TILEPRO_OPC_MINIB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minib_u.sn", TILE_OPC_MINIB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "minib_u.sn", TILEPRO_OPC_MINIB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minih", TILE_OPC_MINIH, 0x3, 3, TREG_ZERO, 1,
+  { "minih", TILEPRO_OPC_MINIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minih.sn", TILE_OPC_MINIH_SN, 0x3, 3, TREG_SN, 1,
+  { "minih.sn", TILEPRO_OPC_MINIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mm", TILE_OPC_MM, 0x3, 5, TREG_ZERO, 1,
+  { "mm", TILEPRO_OPC_MM, 0x3, 5, TREG_ZERO, 1,
     { { 7, 8, 16, 26, 27 }, { 9, 10, 17, 28, 29 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnz", TILE_OPC_MNZ, 0xf, 3, TREG_ZERO, 1,
+  { "mnz", TILEPRO_OPC_MNZ, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "mnz.sn", TILE_OPC_MNZ_SN, 0x3, 3, TREG_SN, 1,
+  { "mnz.sn", TILEPRO_OPC_MNZ_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzb", TILE_OPC_MNZB, 0x3, 3, TREG_ZERO, 1,
+  { "mnzb", TILEPRO_OPC_MNZB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzb.sn", TILE_OPC_MNZB_SN, 0x3, 3, TREG_SN, 1,
+  { "mnzb.sn", TILEPRO_OPC_MNZB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzh", TILE_OPC_MNZH, 0x3, 3, TREG_ZERO, 1,
+  { "mnzh", TILEPRO_OPC_MNZH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzh.sn", TILE_OPC_MNZH_SN, 0x3, 3, TREG_SN, 1,
+  { "mnzh.sn", TILEPRO_OPC_MNZH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mtspr", TILE_OPC_MTSPR, 0x2, 2, TREG_ZERO, 1,
+  { "mtspr", TILEPRO_OPC_MTSPR, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 30, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_ss", TILE_OPC_MULHH_SS, 0x5, 3, TREG_ZERO, 1,
+  { "mulhh_ss", TILEPRO_OPC_MULHH_SS, 0x5, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhh_ss.sn", TILE_OPC_MULHH_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhh_ss.sn", TILEPRO_OPC_MULHH_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_su", TILE_OPC_MULHH_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhh_su", TILEPRO_OPC_MULHH_SU, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_su.sn", TILE_OPC_MULHH_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhh_su.sn", TILEPRO_OPC_MULHH_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_uu", TILE_OPC_MULHH_UU, 0x5, 3, TREG_ZERO, 1,
+  { "mulhh_uu", TILEPRO_OPC_MULHH_UU, 0x5, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhh_uu.sn", TILE_OPC_MULHH_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhh_uu.sn", TILEPRO_OPC_MULHH_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_ss", TILE_OPC_MULHHA_SS, 0x5, 3, TREG_ZERO, 1,
+  { "mulhha_ss", TILEPRO_OPC_MULHHA_SS, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhha_ss.sn", TILE_OPC_MULHHA_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhha_ss.sn", TILEPRO_OPC_MULHHA_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_su", TILE_OPC_MULHHA_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhha_su", TILEPRO_OPC_MULHHA_SU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_su.sn", TILE_OPC_MULHHA_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhha_su.sn", TILEPRO_OPC_MULHHA_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_uu", TILE_OPC_MULHHA_UU, 0x5, 3, TREG_ZERO, 1,
+  { "mulhha_uu", TILEPRO_OPC_MULHHA_UU, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhha_uu.sn", TILE_OPC_MULHHA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhha_uu.sn", TILEPRO_OPC_MULHHA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhhsa_uu", TILE_OPC_MULHHSA_UU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhhsa_uu", TILEPRO_OPC_MULHHSA_UU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhhsa_uu.sn", TILE_OPC_MULHHSA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhhsa_uu.sn", TILEPRO_OPC_MULHHSA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_ss", TILE_OPC_MULHL_SS, 0x1, 3, TREG_ZERO, 1,
+  { "mulhl_ss", TILEPRO_OPC_MULHL_SS, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_ss.sn", TILE_OPC_MULHL_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhl_ss.sn", TILEPRO_OPC_MULHL_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_su", TILE_OPC_MULHL_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhl_su", TILEPRO_OPC_MULHL_SU, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_su.sn", TILE_OPC_MULHL_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhl_su.sn", TILEPRO_OPC_MULHL_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_us", TILE_OPC_MULHL_US, 0x1, 3, TREG_ZERO, 1,
+  { "mulhl_us", TILEPRO_OPC_MULHL_US, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_us.sn", TILE_OPC_MULHL_US_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhl_us.sn", TILEPRO_OPC_MULHL_US_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_uu", TILE_OPC_MULHL_UU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhl_uu", TILEPRO_OPC_MULHL_UU, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_uu.sn", TILE_OPC_MULHL_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhl_uu.sn", TILEPRO_OPC_MULHL_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_ss", TILE_OPC_MULHLA_SS, 0x1, 3, TREG_ZERO, 1,
+  { "mulhla_ss", TILEPRO_OPC_MULHLA_SS, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_ss.sn", TILE_OPC_MULHLA_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhla_ss.sn", TILEPRO_OPC_MULHLA_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_su", TILE_OPC_MULHLA_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhla_su", TILEPRO_OPC_MULHLA_SU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_su.sn", TILE_OPC_MULHLA_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhla_su.sn", TILEPRO_OPC_MULHLA_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_us", TILE_OPC_MULHLA_US, 0x1, 3, TREG_ZERO, 1,
+  { "mulhla_us", TILEPRO_OPC_MULHLA_US, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_us.sn", TILE_OPC_MULHLA_US_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhla_us.sn", TILEPRO_OPC_MULHLA_US_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_uu", TILE_OPC_MULHLA_UU, 0x1, 3, TREG_ZERO, 1,
+  { "mulhla_uu", TILEPRO_OPC_MULHLA_UU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_uu.sn", TILE_OPC_MULHLA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhla_uu.sn", TILEPRO_OPC_MULHLA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhlsa_uu", TILE_OPC_MULHLSA_UU, 0x5, 3, TREG_ZERO, 1,
+  { "mulhlsa_uu", TILEPRO_OPC_MULHLSA_UU, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhlsa_uu.sn", TILE_OPC_MULHLSA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulhlsa_uu.sn", TILEPRO_OPC_MULHLSA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_ss", TILE_OPC_MULLL_SS, 0x5, 3, TREG_ZERO, 1,
+  { "mulll_ss", TILEPRO_OPC_MULLL_SS, 0x5, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulll_ss.sn", TILE_OPC_MULLL_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mulll_ss.sn", TILEPRO_OPC_MULLL_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_su", TILE_OPC_MULLL_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mulll_su", TILEPRO_OPC_MULLL_SU, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_su.sn", TILE_OPC_MULLL_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulll_su.sn", TILEPRO_OPC_MULLL_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_uu", TILE_OPC_MULLL_UU, 0x5, 3, TREG_ZERO, 1,
+  { "mulll_uu", TILEPRO_OPC_MULLL_UU, 0x5, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulll_uu.sn", TILE_OPC_MULLL_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulll_uu.sn", TILEPRO_OPC_MULLL_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_ss", TILE_OPC_MULLLA_SS, 0x5, 3, TREG_ZERO, 1,
+  { "mullla_ss", TILEPRO_OPC_MULLLA_SS, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mullla_ss.sn", TILE_OPC_MULLLA_SS_SN, 0x1, 3, TREG_SN, 1,
+  { "mullla_ss.sn", TILEPRO_OPC_MULLLA_SS_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_su", TILE_OPC_MULLLA_SU, 0x1, 3, TREG_ZERO, 1,
+  { "mullla_su", TILEPRO_OPC_MULLLA_SU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_su.sn", TILE_OPC_MULLLA_SU_SN, 0x1, 3, TREG_SN, 1,
+  { "mullla_su.sn", TILEPRO_OPC_MULLLA_SU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_uu", TILE_OPC_MULLLA_UU, 0x5, 3, TREG_ZERO, 1,
+  { "mullla_uu", TILEPRO_OPC_MULLLA_UU, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mullla_uu.sn", TILE_OPC_MULLLA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mullla_uu.sn", TILEPRO_OPC_MULLLA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulllsa_uu", TILE_OPC_MULLLSA_UU, 0x1, 3, TREG_ZERO, 1,
+  { "mulllsa_uu", TILEPRO_OPC_MULLLSA_UU, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulllsa_uu.sn", TILE_OPC_MULLLSA_UU_SN, 0x1, 3, TREG_SN, 1,
+  { "mulllsa_uu.sn", TILEPRO_OPC_MULLLSA_UU_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mvnz", TILE_OPC_MVNZ, 0x5, 3, TREG_ZERO, 1,
+  { "mvnz", TILEPRO_OPC_MVNZ, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mvnz.sn", TILE_OPC_MVNZ_SN, 0x1, 3, TREG_SN, 1,
+  { "mvnz.sn", TILEPRO_OPC_MVNZ_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mvz", TILE_OPC_MVZ, 0x5, 3, TREG_ZERO, 1,
+  { "mvz", TILEPRO_OPC_MVZ, 0x5, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mvz.sn", TILE_OPC_MVZ_SN, 0x1, 3, TREG_SN, 1,
+  { "mvz.sn", TILEPRO_OPC_MVZ_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mz", TILE_OPC_MZ, 0xf, 3, TREG_ZERO, 1,
+  { "mz", TILEPRO_OPC_MZ, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "mz.sn", TILE_OPC_MZ_SN, 0x3, 3, TREG_SN, 1,
+  { "mz.sn", TILEPRO_OPC_MZ_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzb", TILE_OPC_MZB, 0x3, 3, TREG_ZERO, 1,
+  { "mzb", TILEPRO_OPC_MZB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzb.sn", TILE_OPC_MZB_SN, 0x3, 3, TREG_SN, 1,
+  { "mzb.sn", TILEPRO_OPC_MZB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzh", TILE_OPC_MZH, 0x3, 3, TREG_ZERO, 1,
+  { "mzh", TILEPRO_OPC_MZH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzh.sn", TILE_OPC_MZH_SN, 0x3, 3, TREG_SN, 1,
+  { "mzh.sn", TILEPRO_OPC_MZH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "nap", TILE_OPC_NAP, 0x2, 0, TREG_ZERO, 0,
+  { "nap", TILEPRO_OPC_NAP, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "nop", TILE_OPC_NOP, 0xf, 0, TREG_ZERO, 1,
+  { "nop", TILEPRO_OPC_NOP, 0xf, 0, TREG_ZERO, 1,
     { {  }, {  }, {  }, {  }, { 0, } },
   },
-  { "nor", TILE_OPC_NOR, 0xf, 3, TREG_ZERO, 1,
+  { "nor", TILEPRO_OPC_NOR, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "nor.sn", TILE_OPC_NOR_SN, 0x3, 3, TREG_SN, 1,
+  { "nor.sn", TILEPRO_OPC_NOR_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "or", TILE_OPC_OR, 0xf, 3, TREG_ZERO, 1,
+  { "or", TILEPRO_OPC_OR, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "or.sn", TILE_OPC_OR_SN, 0x3, 3, TREG_SN, 1,
+  { "or.sn", TILEPRO_OPC_OR_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "ori", TILE_OPC_ORI, 0xf, 3, TREG_ZERO, 1,
+  { "ori", TILEPRO_OPC_ORI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "ori.sn", TILE_OPC_ORI_SN, 0x3, 3, TREG_SN, 1,
+  { "ori.sn", TILEPRO_OPC_ORI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packbs_u", TILE_OPC_PACKBS_U, 0x3, 3, TREG_ZERO, 1,
+  { "packbs_u", TILEPRO_OPC_PACKBS_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packbs_u.sn", TILE_OPC_PACKBS_U_SN, 0x3, 3, TREG_SN, 1,
+  { "packbs_u.sn", TILEPRO_OPC_PACKBS_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhb", TILE_OPC_PACKHB, 0x3, 3, TREG_ZERO, 1,
+  { "packhb", TILEPRO_OPC_PACKHB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhb.sn", TILE_OPC_PACKHB_SN, 0x3, 3, TREG_SN, 1,
+  { "packhb.sn", TILEPRO_OPC_PACKHB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhs", TILE_OPC_PACKHS, 0x3, 3, TREG_ZERO, 1,
+  { "packhs", TILEPRO_OPC_PACKHS, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhs.sn", TILE_OPC_PACKHS_SN, 0x3, 3, TREG_SN, 1,
+  { "packhs.sn", TILEPRO_OPC_PACKHS_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packlb", TILE_OPC_PACKLB, 0x3, 3, TREG_ZERO, 1,
+  { "packlb", TILEPRO_OPC_PACKLB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packlb.sn", TILE_OPC_PACKLB_SN, 0x3, 3, TREG_SN, 1,
+  { "packlb.sn", TILEPRO_OPC_PACKLB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "pcnt", TILE_OPC_PCNT, 0x5, 2, TREG_ZERO, 1,
+  { "pcnt", TILEPRO_OPC_PCNT, 0x5, 2, TREG_ZERO, 1,
     { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "pcnt.sn", TILE_OPC_PCNT_SN, 0x1, 2, TREG_SN, 1,
+  { "pcnt.sn", TILEPRO_OPC_PCNT_SN, 0x1, 2, TREG_SN, 1,
     { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "rl", TILE_OPC_RL, 0xf, 3, TREG_ZERO, 1,
+  { "rl", TILEPRO_OPC_RL, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "rl.sn", TILE_OPC_RL_SN, 0x3, 3, TREG_SN, 1,
+  { "rl.sn", TILEPRO_OPC_RL_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "rli", TILE_OPC_RLI, 0xf, 3, TREG_ZERO, 1,
+  { "rli", TILEPRO_OPC_RLI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "rli.sn", TILE_OPC_RLI_SN, 0x3, 3, TREG_SN, 1,
+  { "rli.sn", TILEPRO_OPC_RLI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s1a", TILE_OPC_S1A, 0xf, 3, TREG_ZERO, 1,
+  { "s1a", TILEPRO_OPC_S1A, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "s1a.sn", TILE_OPC_S1A_SN, 0x3, 3, TREG_SN, 1,
+  { "s1a.sn", TILEPRO_OPC_S1A_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s2a", TILE_OPC_S2A, 0xf, 3, TREG_ZERO, 1,
+  { "s2a", TILEPRO_OPC_S2A, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "s2a.sn", TILE_OPC_S2A_SN, 0x3, 3, TREG_SN, 1,
+  { "s2a.sn", TILEPRO_OPC_S2A_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s3a", TILE_OPC_S3A, 0xf, 3, TREG_ZERO, 1,
+  { "s3a", TILEPRO_OPC_S3A, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "s3a.sn", TILE_OPC_S3A_SN, 0x3, 3, TREG_SN, 1,
+  { "s3a.sn", TILEPRO_OPC_S3A_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadab_u", TILE_OPC_SADAB_U, 0x1, 3, TREG_ZERO, 1,
+  { "sadab_u", TILEPRO_OPC_SADAB_U, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadab_u.sn", TILE_OPC_SADAB_U_SN, 0x1, 3, TREG_SN, 1,
+  { "sadab_u.sn", TILEPRO_OPC_SADAB_U_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah", TILE_OPC_SADAH, 0x1, 3, TREG_ZERO, 1,
+  { "sadah", TILEPRO_OPC_SADAH, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah.sn", TILE_OPC_SADAH_SN, 0x1, 3, TREG_SN, 1,
+  { "sadah.sn", TILEPRO_OPC_SADAH_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah_u", TILE_OPC_SADAH_U, 0x1, 3, TREG_ZERO, 1,
+  { "sadah_u", TILEPRO_OPC_SADAH_U, 0x1, 3, TREG_ZERO, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah_u.sn", TILE_OPC_SADAH_U_SN, 0x1, 3, TREG_SN, 1,
+  { "sadah_u.sn", TILEPRO_OPC_SADAH_U_SN, 0x1, 3, TREG_SN, 1,
     { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadb_u", TILE_OPC_SADB_U, 0x1, 3, TREG_ZERO, 1,
+  { "sadb_u", TILEPRO_OPC_SADB_U, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadb_u.sn", TILE_OPC_SADB_U_SN, 0x1, 3, TREG_SN, 1,
+  { "sadb_u.sn", TILEPRO_OPC_SADB_U_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh", TILE_OPC_SADH, 0x1, 3, TREG_ZERO, 1,
+  { "sadh", TILEPRO_OPC_SADH, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh.sn", TILE_OPC_SADH_SN, 0x1, 3, TREG_SN, 1,
+  { "sadh.sn", TILEPRO_OPC_SADH_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh_u", TILE_OPC_SADH_U, 0x1, 3, TREG_ZERO, 1,
+  { "sadh_u", TILEPRO_OPC_SADH_U, 0x1, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh_u.sn", TILE_OPC_SADH_U_SN, 0x1, 3, TREG_SN, 1,
+  { "sadh_u.sn", TILEPRO_OPC_SADH_U_SN, 0x1, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sb", TILE_OPC_SB, 0x12, 2, TREG_ZERO, 1,
+  { "sb", TILEPRO_OPC_SB, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "sbadd", TILE_OPC_SBADD, 0x2, 3, TREG_ZERO, 1,
+  { "sbadd", TILEPRO_OPC_SBADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seq", TILE_OPC_SEQ, 0xf, 3, TREG_ZERO, 1,
+  { "seq", TILEPRO_OPC_SEQ, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "seq.sn", TILE_OPC_SEQ_SN, 0x3, 3, TREG_SN, 1,
+  { "seq.sn", TILEPRO_OPC_SEQ_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqb", TILE_OPC_SEQB, 0x3, 3, TREG_ZERO, 1,
+  { "seqb", TILEPRO_OPC_SEQB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqb.sn", TILE_OPC_SEQB_SN, 0x3, 3, TREG_SN, 1,
+  { "seqb.sn", TILEPRO_OPC_SEQB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqh", TILE_OPC_SEQH, 0x3, 3, TREG_ZERO, 1,
+  { "seqh", TILEPRO_OPC_SEQH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqh.sn", TILE_OPC_SEQH_SN, 0x3, 3, TREG_SN, 1,
+  { "seqh.sn", TILEPRO_OPC_SEQH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqi", TILE_OPC_SEQI, 0xf, 3, TREG_ZERO, 1,
+  { "seqi", TILEPRO_OPC_SEQI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "seqi.sn", TILE_OPC_SEQI_SN, 0x3, 3, TREG_SN, 1,
+  { "seqi.sn", TILEPRO_OPC_SEQI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqib", TILE_OPC_SEQIB, 0x3, 3, TREG_ZERO, 1,
+  { "seqib", TILEPRO_OPC_SEQIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqib.sn", TILE_OPC_SEQIB_SN, 0x3, 3, TREG_SN, 1,
+  { "seqib.sn", TILEPRO_OPC_SEQIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqih", TILE_OPC_SEQIH, 0x3, 3, TREG_ZERO, 1,
+  { "seqih", TILEPRO_OPC_SEQIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqih.sn", TILE_OPC_SEQIH_SN, 0x3, 3, TREG_SN, 1,
+  { "seqih.sn", TILEPRO_OPC_SEQIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sh", TILE_OPC_SH, 0x12, 2, TREG_ZERO, 1,
+  { "sh", TILEPRO_OPC_SH, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "shadd", TILE_OPC_SHADD, 0x2, 3, TREG_ZERO, 1,
+  { "shadd", TILEPRO_OPC_SHADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shl", TILE_OPC_SHL, 0xf, 3, TREG_ZERO, 1,
+  { "shl", TILEPRO_OPC_SHL, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "shl.sn", TILE_OPC_SHL_SN, 0x3, 3, TREG_SN, 1,
+  { "shl.sn", TILEPRO_OPC_SHL_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlb", TILE_OPC_SHLB, 0x3, 3, TREG_ZERO, 1,
+  { "shlb", TILEPRO_OPC_SHLB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlb.sn", TILE_OPC_SHLB_SN, 0x3, 3, TREG_SN, 1,
+  { "shlb.sn", TILEPRO_OPC_SHLB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlh", TILE_OPC_SHLH, 0x3, 3, TREG_ZERO, 1,
+  { "shlh", TILEPRO_OPC_SHLH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlh.sn", TILE_OPC_SHLH_SN, 0x3, 3, TREG_SN, 1,
+  { "shlh.sn", TILEPRO_OPC_SHLH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shli", TILE_OPC_SHLI, 0xf, 3, TREG_ZERO, 1,
+  { "shli", TILEPRO_OPC_SHLI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "shli.sn", TILE_OPC_SHLI_SN, 0x3, 3, TREG_SN, 1,
+  { "shli.sn", TILEPRO_OPC_SHLI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlib", TILE_OPC_SHLIB, 0x3, 3, TREG_ZERO, 1,
+  { "shlib", TILEPRO_OPC_SHLIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlib.sn", TILE_OPC_SHLIB_SN, 0x3, 3, TREG_SN, 1,
+  { "shlib.sn", TILEPRO_OPC_SHLIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlih", TILE_OPC_SHLIH, 0x3, 3, TREG_ZERO, 1,
+  { "shlih", TILEPRO_OPC_SHLIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlih.sn", TILE_OPC_SHLIH_SN, 0x3, 3, TREG_SN, 1,
+  { "shlih.sn", TILEPRO_OPC_SHLIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shr", TILE_OPC_SHR, 0xf, 3, TREG_ZERO, 1,
+  { "shr", TILEPRO_OPC_SHR, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "shr.sn", TILE_OPC_SHR_SN, 0x3, 3, TREG_SN, 1,
+  { "shr.sn", TILEPRO_OPC_SHR_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrb", TILE_OPC_SHRB, 0x3, 3, TREG_ZERO, 1,
+  { "shrb", TILEPRO_OPC_SHRB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrb.sn", TILE_OPC_SHRB_SN, 0x3, 3, TREG_SN, 1,
+  { "shrb.sn", TILEPRO_OPC_SHRB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrh", TILE_OPC_SHRH, 0x3, 3, TREG_ZERO, 1,
+  { "shrh", TILEPRO_OPC_SHRH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrh.sn", TILE_OPC_SHRH_SN, 0x3, 3, TREG_SN, 1,
+  { "shrh.sn", TILEPRO_OPC_SHRH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shri", TILE_OPC_SHRI, 0xf, 3, TREG_ZERO, 1,
+  { "shri", TILEPRO_OPC_SHRI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "shri.sn", TILE_OPC_SHRI_SN, 0x3, 3, TREG_SN, 1,
+  { "shri.sn", TILEPRO_OPC_SHRI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrib", TILE_OPC_SHRIB, 0x3, 3, TREG_ZERO, 1,
+  { "shrib", TILEPRO_OPC_SHRIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrib.sn", TILE_OPC_SHRIB_SN, 0x3, 3, TREG_SN, 1,
+  { "shrib.sn", TILEPRO_OPC_SHRIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrih", TILE_OPC_SHRIH, 0x3, 3, TREG_ZERO, 1,
+  { "shrih", TILEPRO_OPC_SHRIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrih.sn", TILE_OPC_SHRIH_SN, 0x3, 3, TREG_SN, 1,
+  { "shrih.sn", TILEPRO_OPC_SHRIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slt", TILE_OPC_SLT, 0xf, 3, TREG_ZERO, 1,
+  { "slt", TILEPRO_OPC_SLT, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slt.sn", TILE_OPC_SLT_SN, 0x3, 3, TREG_SN, 1,
+  { "slt.sn", TILEPRO_OPC_SLT_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slt_u", TILE_OPC_SLT_U, 0xf, 3, TREG_ZERO, 1,
+  { "slt_u", TILEPRO_OPC_SLT_U, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slt_u.sn", TILE_OPC_SLT_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slt_u.sn", TILEPRO_OPC_SLT_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb", TILE_OPC_SLTB, 0x3, 3, TREG_ZERO, 1,
+  { "sltb", TILEPRO_OPC_SLTB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb.sn", TILE_OPC_SLTB_SN, 0x3, 3, TREG_SN, 1,
+  { "sltb.sn", TILEPRO_OPC_SLTB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb_u", TILE_OPC_SLTB_U, 0x3, 3, TREG_ZERO, 1,
+  { "sltb_u", TILEPRO_OPC_SLTB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb_u.sn", TILE_OPC_SLTB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "sltb_u.sn", TILEPRO_OPC_SLTB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slte", TILE_OPC_SLTE, 0xf, 3, TREG_ZERO, 1,
+  { "slte", TILEPRO_OPC_SLTE, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slte.sn", TILE_OPC_SLTE_SN, 0x3, 3, TREG_SN, 1,
+  { "slte.sn", TILEPRO_OPC_SLTE_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slte_u", TILE_OPC_SLTE_U, 0xf, 3, TREG_ZERO, 1,
+  { "slte_u", TILEPRO_OPC_SLTE_U, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slte_u.sn", TILE_OPC_SLTE_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slte_u.sn", TILEPRO_OPC_SLTE_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb", TILE_OPC_SLTEB, 0x3, 3, TREG_ZERO, 1,
+  { "slteb", TILEPRO_OPC_SLTEB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb.sn", TILE_OPC_SLTEB_SN, 0x3, 3, TREG_SN, 1,
+  { "slteb.sn", TILEPRO_OPC_SLTEB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb_u", TILE_OPC_SLTEB_U, 0x3, 3, TREG_ZERO, 1,
+  { "slteb_u", TILEPRO_OPC_SLTEB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb_u.sn", TILE_OPC_SLTEB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slteb_u.sn", TILEPRO_OPC_SLTEB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh", TILE_OPC_SLTEH, 0x3, 3, TREG_ZERO, 1,
+  { "slteh", TILEPRO_OPC_SLTEH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh.sn", TILE_OPC_SLTEH_SN, 0x3, 3, TREG_SN, 1,
+  { "slteh.sn", TILEPRO_OPC_SLTEH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh_u", TILE_OPC_SLTEH_U, 0x3, 3, TREG_ZERO, 1,
+  { "slteh_u", TILEPRO_OPC_SLTEH_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh_u.sn", TILE_OPC_SLTEH_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slteh_u.sn", TILEPRO_OPC_SLTEH_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth", TILE_OPC_SLTH, 0x3, 3, TREG_ZERO, 1,
+  { "slth", TILEPRO_OPC_SLTH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth.sn", TILE_OPC_SLTH_SN, 0x3, 3, TREG_SN, 1,
+  { "slth.sn", TILEPRO_OPC_SLTH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth_u", TILE_OPC_SLTH_U, 0x3, 3, TREG_ZERO, 1,
+  { "slth_u", TILEPRO_OPC_SLTH_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth_u.sn", TILE_OPC_SLTH_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slth_u.sn", TILEPRO_OPC_SLTH_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slti", TILE_OPC_SLTI, 0xf, 3, TREG_ZERO, 1,
+  { "slti", TILEPRO_OPC_SLTI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "slti.sn", TILE_OPC_SLTI_SN, 0x3, 3, TREG_SN, 1,
+  { "slti.sn", TILEPRO_OPC_SLTI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slti_u", TILE_OPC_SLTI_U, 0xf, 3, TREG_ZERO, 1,
+  { "slti_u", TILEPRO_OPC_SLTI_U, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "slti_u.sn", TILE_OPC_SLTI_U_SN, 0x3, 3, TREG_SN, 1,
+  { "slti_u.sn", TILEPRO_OPC_SLTI_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib", TILE_OPC_SLTIB, 0x3, 3, TREG_ZERO, 1,
+  { "sltib", TILEPRO_OPC_SLTIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib.sn", TILE_OPC_SLTIB_SN, 0x3, 3, TREG_SN, 1,
+  { "sltib.sn", TILEPRO_OPC_SLTIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib_u", TILE_OPC_SLTIB_U, 0x3, 3, TREG_ZERO, 1,
+  { "sltib_u", TILEPRO_OPC_SLTIB_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib_u.sn", TILE_OPC_SLTIB_U_SN, 0x3, 3, TREG_SN, 1,
+  { "sltib_u.sn", TILEPRO_OPC_SLTIB_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih", TILE_OPC_SLTIH, 0x3, 3, TREG_ZERO, 1,
+  { "sltih", TILEPRO_OPC_SLTIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih.sn", TILE_OPC_SLTIH_SN, 0x3, 3, TREG_SN, 1,
+  { "sltih.sn", TILEPRO_OPC_SLTIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih_u", TILE_OPC_SLTIH_U, 0x3, 3, TREG_ZERO, 1,
+  { "sltih_u", TILEPRO_OPC_SLTIH_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih_u.sn", TILE_OPC_SLTIH_U_SN, 0x3, 3, TREG_SN, 1,
+  { "sltih_u.sn", TILEPRO_OPC_SLTIH_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sne", TILE_OPC_SNE, 0xf, 3, TREG_ZERO, 1,
+  { "sne", TILEPRO_OPC_SNE, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sne.sn", TILE_OPC_SNE_SN, 0x3, 3, TREG_SN, 1,
+  { "sne.sn", TILEPRO_OPC_SNE_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneb", TILE_OPC_SNEB, 0x3, 3, TREG_ZERO, 1,
+  { "sneb", TILEPRO_OPC_SNEB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneb.sn", TILE_OPC_SNEB_SN, 0x3, 3, TREG_SN, 1,
+  { "sneb.sn", TILEPRO_OPC_SNEB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneh", TILE_OPC_SNEH, 0x3, 3, TREG_ZERO, 1,
+  { "sneh", TILEPRO_OPC_SNEH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneh.sn", TILE_OPC_SNEH_SN, 0x3, 3, TREG_SN, 1,
+  { "sneh.sn", TILEPRO_OPC_SNEH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sra", TILE_OPC_SRA, 0xf, 3, TREG_ZERO, 1,
+  { "sra", TILEPRO_OPC_SRA, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sra.sn", TILE_OPC_SRA_SN, 0x3, 3, TREG_SN, 1,
+  { "sra.sn", TILEPRO_OPC_SRA_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srab", TILE_OPC_SRAB, 0x3, 3, TREG_ZERO, 1,
+  { "srab", TILEPRO_OPC_SRAB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srab.sn", TILE_OPC_SRAB_SN, 0x3, 3, TREG_SN, 1,
+  { "srab.sn", TILEPRO_OPC_SRAB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srah", TILE_OPC_SRAH, 0x3, 3, TREG_ZERO, 1,
+  { "srah", TILEPRO_OPC_SRAH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srah.sn", TILE_OPC_SRAH_SN, 0x3, 3, TREG_SN, 1,
+  { "srah.sn", TILEPRO_OPC_SRAH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srai", TILE_OPC_SRAI, 0xf, 3, TREG_ZERO, 1,
+  { "srai", TILEPRO_OPC_SRAI, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "srai.sn", TILE_OPC_SRAI_SN, 0x3, 3, TREG_SN, 1,
+  { "srai.sn", TILEPRO_OPC_SRAI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraib", TILE_OPC_SRAIB, 0x3, 3, TREG_ZERO, 1,
+  { "sraib", TILEPRO_OPC_SRAIB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraib.sn", TILE_OPC_SRAIB_SN, 0x3, 3, TREG_SN, 1,
+  { "sraib.sn", TILEPRO_OPC_SRAIB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraih", TILE_OPC_SRAIH, 0x3, 3, TREG_ZERO, 1,
+  { "sraih", TILEPRO_OPC_SRAIH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraih.sn", TILE_OPC_SRAIH_SN, 0x3, 3, TREG_SN, 1,
+  { "sraih.sn", TILEPRO_OPC_SRAIH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sub", TILE_OPC_SUB, 0xf, 3, TREG_ZERO, 1,
+  { "sub", TILEPRO_OPC_SUB, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sub.sn", TILE_OPC_SUB_SN, 0x3, 3, TREG_SN, 1,
+  { "sub.sn", TILEPRO_OPC_SUB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subb", TILE_OPC_SUBB, 0x3, 3, TREG_ZERO, 1,
+  { "subb", TILEPRO_OPC_SUBB, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subb.sn", TILE_OPC_SUBB_SN, 0x3, 3, TREG_SN, 1,
+  { "subb.sn", TILEPRO_OPC_SUBB_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subbs_u", TILE_OPC_SUBBS_U, 0x3, 3, TREG_ZERO, 1,
+  { "subbs_u", TILEPRO_OPC_SUBBS_U, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subbs_u.sn", TILE_OPC_SUBBS_U_SN, 0x3, 3, TREG_SN, 1,
+  { "subbs_u.sn", TILEPRO_OPC_SUBBS_U_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subh", TILE_OPC_SUBH, 0x3, 3, TREG_ZERO, 1,
+  { "subh", TILEPRO_OPC_SUBH, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subh.sn", TILE_OPC_SUBH_SN, 0x3, 3, TREG_SN, 1,
+  { "subh.sn", TILEPRO_OPC_SUBH_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subhs", TILE_OPC_SUBHS, 0x3, 3, TREG_ZERO, 1,
+  { "subhs", TILEPRO_OPC_SUBHS, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subhs.sn", TILE_OPC_SUBHS_SN, 0x3, 3, TREG_SN, 1,
+  { "subhs.sn", TILEPRO_OPC_SUBHS_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subs", TILE_OPC_SUBS, 0x3, 3, TREG_ZERO, 1,
+  { "subs", TILEPRO_OPC_SUBS, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subs.sn", TILE_OPC_SUBS_SN, 0x3, 3, TREG_SN, 1,
+  { "subs.sn", TILEPRO_OPC_SUBS_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sw", TILE_OPC_SW, 0x12, 2, TREG_ZERO, 1,
+  { "sw", TILEPRO_OPC_SW, 0x12, 2, TREG_ZERO, 1,
     { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "swadd", TILE_OPC_SWADD, 0x2, 3, TREG_ZERO, 1,
+  { "swadd", TILEPRO_OPC_SWADD, 0x2, 3, TREG_ZERO, 1,
     { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint0", TILE_OPC_SWINT0, 0x2, 0, TREG_ZERO, 0,
+  { "swint0", TILEPRO_OPC_SWINT0, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint1", TILE_OPC_SWINT1, 0x2, 0, TREG_ZERO, 0,
+  { "swint1", TILEPRO_OPC_SWINT1, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint2", TILE_OPC_SWINT2, 0x2, 0, TREG_ZERO, 0,
+  { "swint2", TILEPRO_OPC_SWINT2, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint3", TILE_OPC_SWINT3, 0x2, 0, TREG_ZERO, 0,
+  { "swint3", TILEPRO_OPC_SWINT3, 0x2, 0, TREG_ZERO, 0,
     { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb0", TILE_OPC_TBLIDXB0, 0x5, 2, TREG_ZERO, 1,
+  { "tblidxb0", TILEPRO_OPC_TBLIDXB0, 0x5, 2, TREG_ZERO, 1,
     { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb0.sn", TILE_OPC_TBLIDXB0_SN, 0x1, 2, TREG_SN, 1,
+  { "tblidxb0.sn", TILEPRO_OPC_TBLIDXB0_SN, 0x1, 2, TREG_SN, 1,
     { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb1", TILE_OPC_TBLIDXB1, 0x5, 2, TREG_ZERO, 1,
+  { "tblidxb1", TILEPRO_OPC_TBLIDXB1, 0x5, 2, TREG_ZERO, 1,
     { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb1.sn", TILE_OPC_TBLIDXB1_SN, 0x1, 2, TREG_SN, 1,
+  { "tblidxb1.sn", TILEPRO_OPC_TBLIDXB1_SN, 0x1, 2, TREG_SN, 1,
     { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb2", TILE_OPC_TBLIDXB2, 0x5, 2, TREG_ZERO, 1,
+  { "tblidxb2", TILEPRO_OPC_TBLIDXB2, 0x5, 2, TREG_ZERO, 1,
     { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb2.sn", TILE_OPC_TBLIDXB2_SN, 0x1, 2, TREG_SN, 1,
+  { "tblidxb2.sn", TILEPRO_OPC_TBLIDXB2_SN, 0x1, 2, TREG_SN, 1,
     { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb3", TILE_OPC_TBLIDXB3, 0x5, 2, TREG_ZERO, 1,
+  { "tblidxb3", TILEPRO_OPC_TBLIDXB3, 0x5, 2, TREG_ZERO, 1,
     { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb3.sn", TILE_OPC_TBLIDXB3_SN, 0x1, 2, TREG_SN, 1,
+  { "tblidxb3.sn", TILEPRO_OPC_TBLIDXB3_SN, 0x1, 2, TREG_SN, 1,
     { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tns", TILE_OPC_TNS, 0x2, 2, TREG_ZERO, 1,
+  { "tns", TILEPRO_OPC_TNS, 0x2, 2, TREG_ZERO, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "tns.sn", TILE_OPC_TNS_SN, 0x2, 2, TREG_SN, 1,
+  { "tns.sn", TILEPRO_OPC_TNS_SN, 0x2, 2, TREG_SN, 1,
     { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "wh64", TILE_OPC_WH64, 0x2, 1, TREG_ZERO, 1,
+  { "wh64", TILEPRO_OPC_WH64, 0x2, 1, TREG_ZERO, 1,
     { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xor", TILE_OPC_XOR, 0xf, 3, TREG_ZERO, 1,
+  { "xor", TILEPRO_OPC_XOR, 0xf, 3, TREG_ZERO, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "xor.sn", TILE_OPC_XOR_SN, 0x3, 3, TREG_SN, 1,
+  { "xor.sn", TILEPRO_OPC_XOR_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xori", TILE_OPC_XORI, 0x3, 3, TREG_ZERO, 1,
+  { "xori", TILEPRO_OPC_XORI, 0x3, 3, TREG_ZERO, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xori.sn", TILE_OPC_XORI_SN, 0x3, 3, TREG_SN, 1,
+  { "xori.sn", TILEPRO_OPC_XORI_SN, 0x3, 3, TREG_SN, 1,
     { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { NULL, TILE_OPC_NONE, 0, 0, TREG_ZERO, 0, { { 0, } },
+  { NULL, TILEPRO_OPC_NONE, 0, 0, TREG_ZERO, 0, { { 0, } },
   }
 };
 #define BITFIELD(start, size) ((start) | (((1 << (size)) - 1) << 6))
-#define CHILD(array_index) (TILE_OPC_NONE + (array_index))
+#define CHILD(array_index) (TILEPRO_OPC_NONE + (array_index))
 
 static const unsigned short decode_X0_fsm[1153] =
 {
   BITFIELD(22, 9) /* index 0 */,
   CHILD(513), CHILD(530), CHILD(547), CHILD(564), CHILD(596), CHILD(613),
-  CHILD(630), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, CHILD(663), CHILD(680), CHILD(697), CHILD(714), CHILD(746),
-  CHILD(763), CHILD(780), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, CHILD(813), CHILD(813), CHILD(813),
+  CHILD(630), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(663), CHILD(680), CHILD(697),
+  CHILD(714), CHILD(746), CHILD(763), CHILD(780), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
@@ -1227,7 +1247,8 @@ static const unsigned short decode_X0_fsm[1153] =
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
   CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(813),
-  CHILD(813), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
+  CHILD(813), CHILD(813), CHILD(813), CHILD(813), CHILD(828), CHILD(828),
+  CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
@@ -1237,7 +1258,7 @@ static const unsigned short decode_X0_fsm[1153] =
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
   CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828),
-  CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(828), CHILD(843),
+  CHILD(828), CHILD(828), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
@@ -1248,333 +1269,371 @@ static const unsigned short decode_X0_fsm[1153] =
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
-  CHILD(843), CHILD(843), CHILD(843), CHILD(873), CHILD(878), CHILD(883),
-  CHILD(903), CHILD(908), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(913),
-  CHILD(918), CHILD(923), CHILD(943), CHILD(948), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, CHILD(953), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(988), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, CHILD(993),
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, CHILD(1076), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(873), CHILD(878), CHILD(883), CHILD(903), CHILD(908),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(913),
+  CHILD(918), CHILD(923), CHILD(943), CHILD(948), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(953), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(988), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, CHILD(993), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(1076), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(18, 4) /* index 513 */,
-  TILE_OPC_NONE, TILE_OPC_ADDB, TILE_OPC_ADDH, TILE_OPC_ADD,
-  TILE_OPC_ADIFFB_U, TILE_OPC_ADIFFH, TILE_OPC_AND, TILE_OPC_AVGB_U,
-  TILE_OPC_AVGH, TILE_OPC_CRC32_32, TILE_OPC_CRC32_8, TILE_OPC_INTHB,
-  TILE_OPC_INTHH, TILE_OPC_INTLB, TILE_OPC_INTLH, TILE_OPC_MAXB_U,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDB, TILEPRO_OPC_ADDH, TILEPRO_OPC_ADD,
+  TILEPRO_OPC_ADIFFB_U, TILEPRO_OPC_ADIFFH, TILEPRO_OPC_AND,
+  TILEPRO_OPC_AVGB_U, TILEPRO_OPC_AVGH, TILEPRO_OPC_CRC32_32,
+  TILEPRO_OPC_CRC32_8, TILEPRO_OPC_INTHB, TILEPRO_OPC_INTHH,
+  TILEPRO_OPC_INTLB, TILEPRO_OPC_INTLH, TILEPRO_OPC_MAXB_U,
   BITFIELD(18, 4) /* index 530 */,
-  TILE_OPC_MAXH, TILE_OPC_MINB_U, TILE_OPC_MINH, TILE_OPC_MNZB, TILE_OPC_MNZH,
-  TILE_OPC_MNZ, TILE_OPC_MULHHA_SS, TILE_OPC_MULHHA_SU, TILE_OPC_MULHHA_UU,
-  TILE_OPC_MULHHSA_UU, TILE_OPC_MULHH_SS, TILE_OPC_MULHH_SU,
-  TILE_OPC_MULHH_UU, TILE_OPC_MULHLA_SS, TILE_OPC_MULHLA_SU,
-  TILE_OPC_MULHLA_US,
+  TILEPRO_OPC_MAXH, TILEPRO_OPC_MINB_U, TILEPRO_OPC_MINH, TILEPRO_OPC_MNZB,
+  TILEPRO_OPC_MNZH, TILEPRO_OPC_MNZ, TILEPRO_OPC_MULHHA_SS,
+  TILEPRO_OPC_MULHHA_SU, TILEPRO_OPC_MULHHA_UU, TILEPRO_OPC_MULHHSA_UU,
+  TILEPRO_OPC_MULHH_SS, TILEPRO_OPC_MULHH_SU, TILEPRO_OPC_MULHH_UU,
+  TILEPRO_OPC_MULHLA_SS, TILEPRO_OPC_MULHLA_SU, TILEPRO_OPC_MULHLA_US,
   BITFIELD(18, 4) /* index 547 */,
-  TILE_OPC_MULHLA_UU, TILE_OPC_MULHLSA_UU, TILE_OPC_MULHL_SS,
-  TILE_OPC_MULHL_SU, TILE_OPC_MULHL_US, TILE_OPC_MULHL_UU, TILE_OPC_MULLLA_SS,
-  TILE_OPC_MULLLA_SU, TILE_OPC_MULLLA_UU, TILE_OPC_MULLLSA_UU,
-  TILE_OPC_MULLL_SS, TILE_OPC_MULLL_SU, TILE_OPC_MULLL_UU, TILE_OPC_MVNZ,
-  TILE_OPC_MVZ, TILE_OPC_MZB,
+  TILEPRO_OPC_MULHLA_UU, TILEPRO_OPC_MULHLSA_UU, TILEPRO_OPC_MULHL_SS,
+  TILEPRO_OPC_MULHL_SU, TILEPRO_OPC_MULHL_US, TILEPRO_OPC_MULHL_UU,
+  TILEPRO_OPC_MULLLA_SS, TILEPRO_OPC_MULLLA_SU, TILEPRO_OPC_MULLLA_UU,
+  TILEPRO_OPC_MULLLSA_UU, TILEPRO_OPC_MULLL_SS, TILEPRO_OPC_MULLL_SU,
+  TILEPRO_OPC_MULLL_UU, TILEPRO_OPC_MVNZ, TILEPRO_OPC_MVZ, TILEPRO_OPC_MZB,
   BITFIELD(18, 4) /* index 564 */,
-  TILE_OPC_MZH, TILE_OPC_MZ, TILE_OPC_NOR, CHILD(581), TILE_OPC_PACKHB,
-  TILE_OPC_PACKLB, TILE_OPC_RL, TILE_OPC_S1A, TILE_OPC_S2A, TILE_OPC_S3A,
-  TILE_OPC_SADAB_U, TILE_OPC_SADAH, TILE_OPC_SADAH_U, TILE_OPC_SADB_U,
-  TILE_OPC_SADH, TILE_OPC_SADH_U,
+  TILEPRO_OPC_MZH, TILEPRO_OPC_MZ, TILEPRO_OPC_NOR, CHILD(581),
+  TILEPRO_OPC_PACKHB, TILEPRO_OPC_PACKLB, TILEPRO_OPC_RL, TILEPRO_OPC_S1A,
+  TILEPRO_OPC_S2A, TILEPRO_OPC_S3A, TILEPRO_OPC_SADAB_U, TILEPRO_OPC_SADAH,
+  TILEPRO_OPC_SADAH_U, TILEPRO_OPC_SADB_U, TILEPRO_OPC_SADH,
+  TILEPRO_OPC_SADH_U,
   BITFIELD(12, 2) /* index 581 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(586),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(586),
   BITFIELD(14, 2) /* index 586 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(591),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(591),
   BITFIELD(16, 2) /* index 591 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_MOVE,
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_MOVE,
   BITFIELD(18, 4) /* index 596 */,
-  TILE_OPC_SEQB, TILE_OPC_SEQH, TILE_OPC_SEQ, TILE_OPC_SHLB, TILE_OPC_SHLH,
-  TILE_OPC_SHL, TILE_OPC_SHRB, TILE_OPC_SHRH, TILE_OPC_SHR, TILE_OPC_SLTB,
-  TILE_OPC_SLTB_U, TILE_OPC_SLTEB, TILE_OPC_SLTEB_U, TILE_OPC_SLTEH,
-  TILE_OPC_SLTEH_U, TILE_OPC_SLTE,
+  TILEPRO_OPC_SEQB, TILEPRO_OPC_SEQH, TILEPRO_OPC_SEQ, TILEPRO_OPC_SHLB,
+  TILEPRO_OPC_SHLH, TILEPRO_OPC_SHL, TILEPRO_OPC_SHRB, TILEPRO_OPC_SHRH,
+  TILEPRO_OPC_SHR, TILEPRO_OPC_SLTB, TILEPRO_OPC_SLTB_U, TILEPRO_OPC_SLTEB,
+  TILEPRO_OPC_SLTEB_U, TILEPRO_OPC_SLTEH, TILEPRO_OPC_SLTEH_U,
+  TILEPRO_OPC_SLTE,
   BITFIELD(18, 4) /* index 613 */,
-  TILE_OPC_SLTE_U, TILE_OPC_SLTH, TILE_OPC_SLTH_U, TILE_OPC_SLT,
-  TILE_OPC_SLT_U, TILE_OPC_SNEB, TILE_OPC_SNEH, TILE_OPC_SNE, TILE_OPC_SRAB,
-  TILE_OPC_SRAH, TILE_OPC_SRA, TILE_OPC_SUBB, TILE_OPC_SUBH, TILE_OPC_SUB,
-  TILE_OPC_XOR, TILE_OPC_DWORD_ALIGN,
+  TILEPRO_OPC_SLTE_U, TILEPRO_OPC_SLTH, TILEPRO_OPC_SLTH_U, TILEPRO_OPC_SLT,
+  TILEPRO_OPC_SLT_U, TILEPRO_OPC_SNEB, TILEPRO_OPC_SNEH, TILEPRO_OPC_SNE,
+  TILEPRO_OPC_SRAB, TILEPRO_OPC_SRAH, TILEPRO_OPC_SRA, TILEPRO_OPC_SUBB,
+  TILEPRO_OPC_SUBH, TILEPRO_OPC_SUB, TILEPRO_OPC_XOR, TILEPRO_OPC_DWORD_ALIGN,
   BITFIELD(18, 3) /* index 630 */,
   CHILD(639), CHILD(642), CHILD(645), CHILD(648), CHILD(651), CHILD(654),
   CHILD(657), CHILD(660),
   BITFIELD(21, 1) /* index 639 */,
-  TILE_OPC_ADDS, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDS, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 642 */,
-  TILE_OPC_SUBS, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBS, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 645 */,
-  TILE_OPC_ADDBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDBS_U, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 648 */,
-  TILE_OPC_ADDHS, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDHS, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 651 */,
-  TILE_OPC_SUBBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBBS_U, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 654 */,
-  TILE_OPC_SUBHS, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBHS, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 657 */,
-  TILE_OPC_PACKHS, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKHS, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 660 */,
-  TILE_OPC_PACKBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKBS_U, TILEPRO_OPC_NONE,
   BITFIELD(18, 4) /* index 663 */,
-  TILE_OPC_NONE, TILE_OPC_ADDB_SN, TILE_OPC_ADDH_SN, TILE_OPC_ADD_SN,
-  TILE_OPC_ADIFFB_U_SN, TILE_OPC_ADIFFH_SN, TILE_OPC_AND_SN,
-  TILE_OPC_AVGB_U_SN, TILE_OPC_AVGH_SN, TILE_OPC_CRC32_32_SN,
-  TILE_OPC_CRC32_8_SN, TILE_OPC_INTHB_SN, TILE_OPC_INTHH_SN,
-  TILE_OPC_INTLB_SN, TILE_OPC_INTLH_SN, TILE_OPC_MAXB_U_SN,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDB_SN, TILEPRO_OPC_ADDH_SN,
+  TILEPRO_OPC_ADD_SN, TILEPRO_OPC_ADIFFB_U_SN, TILEPRO_OPC_ADIFFH_SN,
+  TILEPRO_OPC_AND_SN, TILEPRO_OPC_AVGB_U_SN, TILEPRO_OPC_AVGH_SN,
+  TILEPRO_OPC_CRC32_32_SN, TILEPRO_OPC_CRC32_8_SN, TILEPRO_OPC_INTHB_SN,
+  TILEPRO_OPC_INTHH_SN, TILEPRO_OPC_INTLB_SN, TILEPRO_OPC_INTLH_SN,
+  TILEPRO_OPC_MAXB_U_SN,
   BITFIELD(18, 4) /* index 680 */,
-  TILE_OPC_MAXH_SN, TILE_OPC_MINB_U_SN, TILE_OPC_MINH_SN, TILE_OPC_MNZB_SN,
-  TILE_OPC_MNZH_SN, TILE_OPC_MNZ_SN, TILE_OPC_MULHHA_SS_SN,
-  TILE_OPC_MULHHA_SU_SN, TILE_OPC_MULHHA_UU_SN, TILE_OPC_MULHHSA_UU_SN,
-  TILE_OPC_MULHH_SS_SN, TILE_OPC_MULHH_SU_SN, TILE_OPC_MULHH_UU_SN,
-  TILE_OPC_MULHLA_SS_SN, TILE_OPC_MULHLA_SU_SN, TILE_OPC_MULHLA_US_SN,
+  TILEPRO_OPC_MAXH_SN, TILEPRO_OPC_MINB_U_SN, TILEPRO_OPC_MINH_SN,
+  TILEPRO_OPC_MNZB_SN, TILEPRO_OPC_MNZH_SN, TILEPRO_OPC_MNZ_SN,
+  TILEPRO_OPC_MULHHA_SS_SN, TILEPRO_OPC_MULHHA_SU_SN,
+  TILEPRO_OPC_MULHHA_UU_SN, TILEPRO_OPC_MULHHSA_UU_SN,
+  TILEPRO_OPC_MULHH_SS_SN, TILEPRO_OPC_MULHH_SU_SN, TILEPRO_OPC_MULHH_UU_SN,
+  TILEPRO_OPC_MULHLA_SS_SN, TILEPRO_OPC_MULHLA_SU_SN,
+  TILEPRO_OPC_MULHLA_US_SN,
   BITFIELD(18, 4) /* index 697 */,
-  TILE_OPC_MULHLA_UU_SN, TILE_OPC_MULHLSA_UU_SN, TILE_OPC_MULHL_SS_SN,
-  TILE_OPC_MULHL_SU_SN, TILE_OPC_MULHL_US_SN, TILE_OPC_MULHL_UU_SN,
-  TILE_OPC_MULLLA_SS_SN, TILE_OPC_MULLLA_SU_SN, TILE_OPC_MULLLA_UU_SN,
-  TILE_OPC_MULLLSA_UU_SN, TILE_OPC_MULLL_SS_SN, TILE_OPC_MULLL_SU_SN,
-  TILE_OPC_MULLL_UU_SN, TILE_OPC_MVNZ_SN, TILE_OPC_MVZ_SN, TILE_OPC_MZB_SN,
+  TILEPRO_OPC_MULHLA_UU_SN, TILEPRO_OPC_MULHLSA_UU_SN,
+  TILEPRO_OPC_MULHL_SS_SN, TILEPRO_OPC_MULHL_SU_SN, TILEPRO_OPC_MULHL_US_SN,
+  TILEPRO_OPC_MULHL_UU_SN, TILEPRO_OPC_MULLLA_SS_SN, TILEPRO_OPC_MULLLA_SU_SN,
+  TILEPRO_OPC_MULLLA_UU_SN, TILEPRO_OPC_MULLLSA_UU_SN,
+  TILEPRO_OPC_MULLL_SS_SN, TILEPRO_OPC_MULLL_SU_SN, TILEPRO_OPC_MULLL_UU_SN,
+  TILEPRO_OPC_MVNZ_SN, TILEPRO_OPC_MVZ_SN, TILEPRO_OPC_MZB_SN,
   BITFIELD(18, 4) /* index 714 */,
-  TILE_OPC_MZH_SN, TILE_OPC_MZ_SN, TILE_OPC_NOR_SN, CHILD(731),
-  TILE_OPC_PACKHB_SN, TILE_OPC_PACKLB_SN, TILE_OPC_RL_SN, TILE_OPC_S1A_SN,
-  TILE_OPC_S2A_SN, TILE_OPC_S3A_SN, TILE_OPC_SADAB_U_SN, TILE_OPC_SADAH_SN,
-  TILE_OPC_SADAH_U_SN, TILE_OPC_SADB_U_SN, TILE_OPC_SADH_SN,
-  TILE_OPC_SADH_U_SN,
+  TILEPRO_OPC_MZH_SN, TILEPRO_OPC_MZ_SN, TILEPRO_OPC_NOR_SN, CHILD(731),
+  TILEPRO_OPC_PACKHB_SN, TILEPRO_OPC_PACKLB_SN, TILEPRO_OPC_RL_SN,
+  TILEPRO_OPC_S1A_SN, TILEPRO_OPC_S2A_SN, TILEPRO_OPC_S3A_SN,
+  TILEPRO_OPC_SADAB_U_SN, TILEPRO_OPC_SADAH_SN, TILEPRO_OPC_SADAH_U_SN,
+  TILEPRO_OPC_SADB_U_SN, TILEPRO_OPC_SADH_SN, TILEPRO_OPC_SADH_U_SN,
   BITFIELD(12, 2) /* index 731 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, CHILD(736),
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, CHILD(736),
   BITFIELD(14, 2) /* index 736 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, CHILD(741),
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, CHILD(741),
   BITFIELD(16, 2) /* index 741 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_MOVE_SN,
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN,
+  TILEPRO_OPC_MOVE_SN,
   BITFIELD(18, 4) /* index 746 */,
-  TILE_OPC_SEQB_SN, TILE_OPC_SEQH_SN, TILE_OPC_SEQ_SN, TILE_OPC_SHLB_SN,
-  TILE_OPC_SHLH_SN, TILE_OPC_SHL_SN, TILE_OPC_SHRB_SN, TILE_OPC_SHRH_SN,
-  TILE_OPC_SHR_SN, TILE_OPC_SLTB_SN, TILE_OPC_SLTB_U_SN, TILE_OPC_SLTEB_SN,
-  TILE_OPC_SLTEB_U_SN, TILE_OPC_SLTEH_SN, TILE_OPC_SLTEH_U_SN,
-  TILE_OPC_SLTE_SN,
+  TILEPRO_OPC_SEQB_SN, TILEPRO_OPC_SEQH_SN, TILEPRO_OPC_SEQ_SN,
+  TILEPRO_OPC_SHLB_SN, TILEPRO_OPC_SHLH_SN, TILEPRO_OPC_SHL_SN,
+  TILEPRO_OPC_SHRB_SN, TILEPRO_OPC_SHRH_SN, TILEPRO_OPC_SHR_SN,
+  TILEPRO_OPC_SLTB_SN, TILEPRO_OPC_SLTB_U_SN, TILEPRO_OPC_SLTEB_SN,
+  TILEPRO_OPC_SLTEB_U_SN, TILEPRO_OPC_SLTEH_SN, TILEPRO_OPC_SLTEH_U_SN,
+  TILEPRO_OPC_SLTE_SN,
   BITFIELD(18, 4) /* index 763 */,
-  TILE_OPC_SLTE_U_SN, TILE_OPC_SLTH_SN, TILE_OPC_SLTH_U_SN, TILE_OPC_SLT_SN,
-  TILE_OPC_SLT_U_SN, TILE_OPC_SNEB_SN, TILE_OPC_SNEH_SN, TILE_OPC_SNE_SN,
-  TILE_OPC_SRAB_SN, TILE_OPC_SRAH_SN, TILE_OPC_SRA_SN, TILE_OPC_SUBB_SN,
-  TILE_OPC_SUBH_SN, TILE_OPC_SUB_SN, TILE_OPC_XOR_SN, TILE_OPC_DWORD_ALIGN_SN,
+  TILEPRO_OPC_SLTE_U_SN, TILEPRO_OPC_SLTH_SN, TILEPRO_OPC_SLTH_U_SN,
+  TILEPRO_OPC_SLT_SN, TILEPRO_OPC_SLT_U_SN, TILEPRO_OPC_SNEB_SN,
+  TILEPRO_OPC_SNEH_SN, TILEPRO_OPC_SNE_SN, TILEPRO_OPC_SRAB_SN,
+  TILEPRO_OPC_SRAH_SN, TILEPRO_OPC_SRA_SN, TILEPRO_OPC_SUBB_SN,
+  TILEPRO_OPC_SUBH_SN, TILEPRO_OPC_SUB_SN, TILEPRO_OPC_XOR_SN,
+  TILEPRO_OPC_DWORD_ALIGN_SN,
   BITFIELD(18, 3) /* index 780 */,
   CHILD(789), CHILD(792), CHILD(795), CHILD(798), CHILD(801), CHILD(804),
   CHILD(807), CHILD(810),
   BITFIELD(21, 1) /* index 789 */,
-  TILE_OPC_ADDS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDS_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 792 */,
-  TILE_OPC_SUBS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBS_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 795 */,
-  TILE_OPC_ADDBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 798 */,
-  TILE_OPC_ADDHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 801 */,
-  TILE_OPC_SUBBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 804 */,
-  TILE_OPC_SUBHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 807 */,
-  TILE_OPC_PACKHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(21, 1) /* index 810 */,
-  TILE_OPC_PACKBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(6, 2) /* index 813 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, CHILD(818),
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  CHILD(818),
   BITFIELD(8, 2) /* index 818 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, CHILD(823),
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  CHILD(823),
   BITFIELD(10, 2) /* index 823 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_MOVELI_SN,
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  TILEPRO_OPC_MOVELI_SN,
   BITFIELD(6, 2) /* index 828 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, CHILD(833),
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, CHILD(833),
   BITFIELD(8, 2) /* index 833 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, CHILD(838),
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, CHILD(838),
   BITFIELD(10, 2) /* index 838 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_MOVELI,
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_MOVELI,
   BITFIELD(0, 2) /* index 843 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(848),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(848),
   BITFIELD(2, 2) /* index 848 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(853),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(853),
   BITFIELD(4, 2) /* index 853 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(858),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(858),
   BITFIELD(6, 2) /* index 858 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(863),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(863),
   BITFIELD(8, 2) /* index 863 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(868),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(868),
   BITFIELD(10, 2) /* index 868 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_INFOL,
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_INFOL,
   BITFIELD(20, 2) /* index 873 */,
-  TILE_OPC_NONE, TILE_OPC_ADDIB, TILE_OPC_ADDIH, TILE_OPC_ADDI,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDIB, TILEPRO_OPC_ADDIH, TILEPRO_OPC_ADDI,
   BITFIELD(20, 2) /* index 878 */,
-  TILE_OPC_MAXIB_U, TILE_OPC_MAXIH, TILE_OPC_MINIB_U, TILE_OPC_MINIH,
+  TILEPRO_OPC_MAXIB_U, TILEPRO_OPC_MAXIH, TILEPRO_OPC_MINIB_U,
+  TILEPRO_OPC_MINIH,
   BITFIELD(20, 2) /* index 883 */,
-  CHILD(888), TILE_OPC_SEQIB, TILE_OPC_SEQIH, TILE_OPC_SEQI,
+  CHILD(888), TILEPRO_OPC_SEQIB, TILEPRO_OPC_SEQIH, TILEPRO_OPC_SEQI,
   BITFIELD(6, 2) /* index 888 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(893),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(893),
   BITFIELD(8, 2) /* index 893 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(898),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(898),
   BITFIELD(10, 2) /* index 898 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_MOVEI,
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_MOVEI,
   BITFIELD(20, 2) /* index 903 */,
-  TILE_OPC_SLTIB, TILE_OPC_SLTIB_U, TILE_OPC_SLTIH, TILE_OPC_SLTIH_U,
+  TILEPRO_OPC_SLTIB, TILEPRO_OPC_SLTIB_U, TILEPRO_OPC_SLTIH,
+  TILEPRO_OPC_SLTIH_U,
   BITFIELD(20, 2) /* index 908 */,
-  TILE_OPC_SLTI, TILE_OPC_SLTI_U, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_SLTI, TILEPRO_OPC_SLTI_U, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(20, 2) /* index 913 */,
-  TILE_OPC_NONE, TILE_OPC_ADDIB_SN, TILE_OPC_ADDIH_SN, TILE_OPC_ADDI_SN,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDIB_SN, TILEPRO_OPC_ADDIH_SN,
+  TILEPRO_OPC_ADDI_SN,
   BITFIELD(20, 2) /* index 918 */,
-  TILE_OPC_MAXIB_U_SN, TILE_OPC_MAXIH_SN, TILE_OPC_MINIB_U_SN,
-  TILE_OPC_MINIH_SN,
+  TILEPRO_OPC_MAXIB_U_SN, TILEPRO_OPC_MAXIH_SN, TILEPRO_OPC_MINIB_U_SN,
+  TILEPRO_OPC_MINIH_SN,
   BITFIELD(20, 2) /* index 923 */,
-  CHILD(928), TILE_OPC_SEQIB_SN, TILE_OPC_SEQIH_SN, TILE_OPC_SEQI_SN,
+  CHILD(928), TILEPRO_OPC_SEQIB_SN, TILEPRO_OPC_SEQIH_SN, TILEPRO_OPC_SEQI_SN,
   BITFIELD(6, 2) /* index 928 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, CHILD(933),
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, CHILD(933),
   BITFIELD(8, 2) /* index 933 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, CHILD(938),
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, CHILD(938),
   BITFIELD(10, 2) /* index 938 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_MOVEI_SN,
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN,
+  TILEPRO_OPC_MOVEI_SN,
   BITFIELD(20, 2) /* index 943 */,
-  TILE_OPC_SLTIB_SN, TILE_OPC_SLTIB_U_SN, TILE_OPC_SLTIH_SN,
-  TILE_OPC_SLTIH_U_SN,
+  TILEPRO_OPC_SLTIB_SN, TILEPRO_OPC_SLTIB_U_SN, TILEPRO_OPC_SLTIH_SN,
+  TILEPRO_OPC_SLTIH_U_SN,
   BITFIELD(20, 2) /* index 948 */,
-  TILE_OPC_SLTI_SN, TILE_OPC_SLTI_U_SN, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_SLTI_SN, TILEPRO_OPC_SLTI_U_SN, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE,
   BITFIELD(20, 2) /* index 953 */,
-  TILE_OPC_NONE, CHILD(958), TILE_OPC_XORI, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, CHILD(958), TILEPRO_OPC_XORI, TILEPRO_OPC_NONE,
   BITFIELD(0, 2) /* index 958 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(963),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(963),
   BITFIELD(2, 2) /* index 963 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(968),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(968),
   BITFIELD(4, 2) /* index 968 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(973),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(973),
   BITFIELD(6, 2) /* index 973 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(978),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(978),
   BITFIELD(8, 2) /* index 978 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(983),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(983),
   BITFIELD(10, 2) /* index 983 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_INFO,
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_INFO,
   BITFIELD(20, 2) /* index 988 */,
-  TILE_OPC_NONE, TILE_OPC_ANDI_SN, TILE_OPC_XORI_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ANDI_SN, TILEPRO_OPC_XORI_SN,
+  TILEPRO_OPC_NONE,
   BITFIELD(17, 5) /* index 993 */,
-  TILE_OPC_NONE, TILE_OPC_RLI, TILE_OPC_SHLIB, TILE_OPC_SHLIH, TILE_OPC_SHLI,
-  TILE_OPC_SHRIB, TILE_OPC_SHRIH, TILE_OPC_SHRI, TILE_OPC_SRAIB,
-  TILE_OPC_SRAIH, TILE_OPC_SRAI, CHILD(1026), TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_RLI, TILEPRO_OPC_SHLIB, TILEPRO_OPC_SHLIH,
+  TILEPRO_OPC_SHLI, TILEPRO_OPC_SHRIB, TILEPRO_OPC_SHRIH, TILEPRO_OPC_SHRI,
+  TILEPRO_OPC_SRAIB, TILEPRO_OPC_SRAIH, TILEPRO_OPC_SRAI, CHILD(1026),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(12, 4) /* index 1026 */,
-  TILE_OPC_NONE, CHILD(1043), CHILD(1046), CHILD(1049), CHILD(1052),
+  TILEPRO_OPC_NONE, CHILD(1043), CHILD(1046), CHILD(1049), CHILD(1052),
   CHILD(1055), CHILD(1058), CHILD(1061), CHILD(1064), CHILD(1067),
-  CHILD(1070), CHILD(1073), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE,
+  CHILD(1070), CHILD(1073), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1043 */,
-  TILE_OPC_BITX, TILE_OPC_NONE,
+  TILEPRO_OPC_BITX, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1046 */,
-  TILE_OPC_BYTEX, TILE_OPC_NONE,
+  TILEPRO_OPC_BYTEX, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1049 */,
-  TILE_OPC_CLZ, TILE_OPC_NONE,
+  TILEPRO_OPC_CLZ, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1052 */,
-  TILE_OPC_CTZ, TILE_OPC_NONE,
+  TILEPRO_OPC_CTZ, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1055 */,
-  TILE_OPC_FNOP, TILE_OPC_NONE,
+  TILEPRO_OPC_FNOP, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1058 */,
-  TILE_OPC_NOP, TILE_OPC_NONE,
+  TILEPRO_OPC_NOP, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1061 */,
-  TILE_OPC_PCNT, TILE_OPC_NONE,
+  TILEPRO_OPC_PCNT, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1064 */,
-  TILE_OPC_TBLIDXB0, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB0, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1067 */,
-  TILE_OPC_TBLIDXB1, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB1, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1070 */,
-  TILE_OPC_TBLIDXB2, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB2, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1073 */,
-  TILE_OPC_TBLIDXB3, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB3, TILEPRO_OPC_NONE,
   BITFIELD(17, 5) /* index 1076 */,
-  TILE_OPC_NONE, TILE_OPC_RLI_SN, TILE_OPC_SHLIB_SN, TILE_OPC_SHLIH_SN,
-  TILE_OPC_SHLI_SN, TILE_OPC_SHRIB_SN, TILE_OPC_SHRIH_SN, TILE_OPC_SHRI_SN,
-  TILE_OPC_SRAIB_SN, TILE_OPC_SRAIH_SN, TILE_OPC_SRAI_SN, CHILD(1109),
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_RLI_SN, TILEPRO_OPC_SHLIB_SN,
+  TILEPRO_OPC_SHLIH_SN, TILEPRO_OPC_SHLI_SN, TILEPRO_OPC_SHRIB_SN,
+  TILEPRO_OPC_SHRIH_SN, TILEPRO_OPC_SHRI_SN, TILEPRO_OPC_SRAIB_SN,
+  TILEPRO_OPC_SRAIH_SN, TILEPRO_OPC_SRAI_SN, CHILD(1109), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(12, 4) /* index 1109 */,
-  TILE_OPC_NONE, CHILD(1126), CHILD(1129), CHILD(1132), CHILD(1135),
+  TILEPRO_OPC_NONE, CHILD(1126), CHILD(1129), CHILD(1132), CHILD(1135),
   CHILD(1055), CHILD(1058), CHILD(1138), CHILD(1141), CHILD(1144),
-  CHILD(1147), CHILD(1150), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE,
+  CHILD(1147), CHILD(1150), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1126 */,
-  TILE_OPC_BITX_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_BITX_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1129 */,
-  TILE_OPC_BYTEX_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_BYTEX_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1132 */,
-  TILE_OPC_CLZ_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_CLZ_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1135 */,
-  TILE_OPC_CTZ_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_CTZ_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1138 */,
-  TILE_OPC_PCNT_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_PCNT_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1141 */,
-  TILE_OPC_TBLIDXB0_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB0_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1144 */,
-  TILE_OPC_TBLIDXB1_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB1_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1147 */,
-  TILE_OPC_TBLIDXB2_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB2_SN, TILEPRO_OPC_NONE,
   BITFIELD(16, 1) /* index 1150 */,
-  TILE_OPC_TBLIDXB3_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB3_SN, TILEPRO_OPC_NONE,
 };
 
 static const unsigned short decode_X1_fsm[1540] =
 {
   BITFIELD(54, 9) /* index 0 */,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, CHILD(513), CHILD(561), CHILD(594),
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(641), CHILD(689),
-  CHILD(722), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(766),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  CHILD(513), CHILD(561), CHILD(594), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(641),
+  CHILD(689), CHILD(722), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(766),
   CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766),
   CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766),
   CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766), CHILD(766),
@@ -1596,594 +1655,641 @@ static const unsigned short decode_X1_fsm[1540] =
   CHILD(826), CHILD(826), CHILD(826), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
   CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843), CHILD(843),
-  CHILD(843), CHILD(860), CHILD(899), CHILD(923), CHILD(932), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, CHILD(941), CHILD(950), CHILD(974), CHILD(983),
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM,
-  TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, TILE_OPC_MM, CHILD(992),
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  CHILD(1334), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J, TILE_OPC_J,
-  TILE_OPC_J, TILE_OPC_J, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL, TILE_OPC_JAL,
-  TILE_OPC_JAL, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(843), CHILD(860), CHILD(899), CHILD(923), CHILD(932),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  CHILD(941), CHILD(950), CHILD(974), CHILD(983), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM,
+  TILEPRO_OPC_MM, TILEPRO_OPC_MM, TILEPRO_OPC_MM, CHILD(992),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, CHILD(1334),
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J,
+  TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_J, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL,
+  TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_JAL, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(49, 5) /* index 513 */,
-  TILE_OPC_NONE, TILE_OPC_ADDB, TILE_OPC_ADDH, TILE_OPC_ADD, TILE_OPC_AND,
-  TILE_OPC_INTHB, TILE_OPC_INTHH, TILE_OPC_INTLB, TILE_OPC_INTLH,
-  TILE_OPC_JALRP, TILE_OPC_JALR, TILE_OPC_JRP, TILE_OPC_JR, TILE_OPC_LNK,
-  TILE_OPC_MAXB_U, TILE_OPC_MAXH, TILE_OPC_MINB_U, TILE_OPC_MINH,
-  TILE_OPC_MNZB, TILE_OPC_MNZH, TILE_OPC_MNZ, TILE_OPC_MZB, TILE_OPC_MZH,
-  TILE_OPC_MZ, TILE_OPC_NOR, CHILD(546), TILE_OPC_PACKHB, TILE_OPC_PACKLB,
-  TILE_OPC_RL, TILE_OPC_S1A, TILE_OPC_S2A, TILE_OPC_S3A,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDB, TILEPRO_OPC_ADDH, TILEPRO_OPC_ADD,
+  TILEPRO_OPC_AND, TILEPRO_OPC_INTHB, TILEPRO_OPC_INTHH, TILEPRO_OPC_INTLB,
+  TILEPRO_OPC_INTLH, TILEPRO_OPC_JALRP, TILEPRO_OPC_JALR, TILEPRO_OPC_JRP,
+  TILEPRO_OPC_JR, TILEPRO_OPC_LNK, TILEPRO_OPC_MAXB_U, TILEPRO_OPC_MAXH,
+  TILEPRO_OPC_MINB_U, TILEPRO_OPC_MINH, TILEPRO_OPC_MNZB, TILEPRO_OPC_MNZH,
+  TILEPRO_OPC_MNZ, TILEPRO_OPC_MZB, TILEPRO_OPC_MZH, TILEPRO_OPC_MZ,
+  TILEPRO_OPC_NOR, CHILD(546), TILEPRO_OPC_PACKHB, TILEPRO_OPC_PACKLB,
+  TILEPRO_OPC_RL, TILEPRO_OPC_S1A, TILEPRO_OPC_S2A, TILEPRO_OPC_S3A,
   BITFIELD(43, 2) /* index 546 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(551),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(551),
   BITFIELD(45, 2) /* index 551 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(556),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(556),
   BITFIELD(47, 2) /* index 556 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_MOVE,
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_MOVE,
   BITFIELD(49, 5) /* index 561 */,
-  TILE_OPC_SB, TILE_OPC_SEQB, TILE_OPC_SEQH, TILE_OPC_SEQ, TILE_OPC_SHLB,
-  TILE_OPC_SHLH, TILE_OPC_SHL, TILE_OPC_SHRB, TILE_OPC_SHRH, TILE_OPC_SHR,
-  TILE_OPC_SH, TILE_OPC_SLTB, TILE_OPC_SLTB_U, TILE_OPC_SLTEB,
-  TILE_OPC_SLTEB_U, TILE_OPC_SLTEH, TILE_OPC_SLTEH_U, TILE_OPC_SLTE,
-  TILE_OPC_SLTE_U, TILE_OPC_SLTH, TILE_OPC_SLTH_U, TILE_OPC_SLT,
-  TILE_OPC_SLT_U, TILE_OPC_SNEB, TILE_OPC_SNEH, TILE_OPC_SNE, TILE_OPC_SRAB,
-  TILE_OPC_SRAH, TILE_OPC_SRA, TILE_OPC_SUBB, TILE_OPC_SUBH, TILE_OPC_SUB,
+  TILEPRO_OPC_SB, TILEPRO_OPC_SEQB, TILEPRO_OPC_SEQH, TILEPRO_OPC_SEQ,
+  TILEPRO_OPC_SHLB, TILEPRO_OPC_SHLH, TILEPRO_OPC_SHL, TILEPRO_OPC_SHRB,
+  TILEPRO_OPC_SHRH, TILEPRO_OPC_SHR, TILEPRO_OPC_SH, TILEPRO_OPC_SLTB,
+  TILEPRO_OPC_SLTB_U, TILEPRO_OPC_SLTEB, TILEPRO_OPC_SLTEB_U,
+  TILEPRO_OPC_SLTEH, TILEPRO_OPC_SLTEH_U, TILEPRO_OPC_SLTE,
+  TILEPRO_OPC_SLTE_U, TILEPRO_OPC_SLTH, TILEPRO_OPC_SLTH_U, TILEPRO_OPC_SLT,
+  TILEPRO_OPC_SLT_U, TILEPRO_OPC_SNEB, TILEPRO_OPC_SNEH, TILEPRO_OPC_SNE,
+  TILEPRO_OPC_SRAB, TILEPRO_OPC_SRAH, TILEPRO_OPC_SRA, TILEPRO_OPC_SUBB,
+  TILEPRO_OPC_SUBH, TILEPRO_OPC_SUB,
   BITFIELD(49, 4) /* index 594 */,
   CHILD(611), CHILD(614), CHILD(617), CHILD(620), CHILD(623), CHILD(626),
-  CHILD(629), CHILD(632), CHILD(635), CHILD(638), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(629), CHILD(632), CHILD(635), CHILD(638), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 611 */,
-  TILE_OPC_SW, TILE_OPC_NONE,
+  TILEPRO_OPC_SW, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 614 */,
-  TILE_OPC_XOR, TILE_OPC_NONE,
+  TILEPRO_OPC_XOR, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 617 */,
-  TILE_OPC_ADDS, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 620 */,
-  TILE_OPC_SUBS, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 623 */,
-  TILE_OPC_ADDBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDBS_U, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 626 */,
-  TILE_OPC_ADDHS, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDHS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 629 */,
-  TILE_OPC_SUBBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBBS_U, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 632 */,
-  TILE_OPC_SUBHS, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBHS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 635 */,
-  TILE_OPC_PACKHS, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKHS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 638 */,
-  TILE_OPC_PACKBS_U, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKBS_U, TILEPRO_OPC_NONE,
   BITFIELD(49, 5) /* index 641 */,
-  TILE_OPC_NONE, TILE_OPC_ADDB_SN, TILE_OPC_ADDH_SN, TILE_OPC_ADD_SN,
-  TILE_OPC_AND_SN, TILE_OPC_INTHB_SN, TILE_OPC_INTHH_SN, TILE_OPC_INTLB_SN,
-  TILE_OPC_INTLH_SN, TILE_OPC_JALRP, TILE_OPC_JALR, TILE_OPC_JRP, TILE_OPC_JR,
-  TILE_OPC_LNK_SN, TILE_OPC_MAXB_U_SN, TILE_OPC_MAXH_SN, TILE_OPC_MINB_U_SN,
-  TILE_OPC_MINH_SN, TILE_OPC_MNZB_SN, TILE_OPC_MNZH_SN, TILE_OPC_MNZ_SN,
-  TILE_OPC_MZB_SN, TILE_OPC_MZH_SN, TILE_OPC_MZ_SN, TILE_OPC_NOR_SN,
-  CHILD(674), TILE_OPC_PACKHB_SN, TILE_OPC_PACKLB_SN, TILE_OPC_RL_SN,
-  TILE_OPC_S1A_SN, TILE_OPC_S2A_SN, TILE_OPC_S3A_SN,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDB_SN, TILEPRO_OPC_ADDH_SN,
+  TILEPRO_OPC_ADD_SN, TILEPRO_OPC_AND_SN, TILEPRO_OPC_INTHB_SN,
+  TILEPRO_OPC_INTHH_SN, TILEPRO_OPC_INTLB_SN, TILEPRO_OPC_INTLH_SN,
+  TILEPRO_OPC_JALRP, TILEPRO_OPC_JALR, TILEPRO_OPC_JRP, TILEPRO_OPC_JR,
+  TILEPRO_OPC_LNK_SN, TILEPRO_OPC_MAXB_U_SN, TILEPRO_OPC_MAXH_SN,
+  TILEPRO_OPC_MINB_U_SN, TILEPRO_OPC_MINH_SN, TILEPRO_OPC_MNZB_SN,
+  TILEPRO_OPC_MNZH_SN, TILEPRO_OPC_MNZ_SN, TILEPRO_OPC_MZB_SN,
+  TILEPRO_OPC_MZH_SN, TILEPRO_OPC_MZ_SN, TILEPRO_OPC_NOR_SN, CHILD(674),
+  TILEPRO_OPC_PACKHB_SN, TILEPRO_OPC_PACKLB_SN, TILEPRO_OPC_RL_SN,
+  TILEPRO_OPC_S1A_SN, TILEPRO_OPC_S2A_SN, TILEPRO_OPC_S3A_SN,
   BITFIELD(43, 2) /* index 674 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, CHILD(679),
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, CHILD(679),
   BITFIELD(45, 2) /* index 679 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, CHILD(684),
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, CHILD(684),
   BITFIELD(47, 2) /* index 684 */,
-  TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_OR_SN, TILE_OPC_MOVE_SN,
+  TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN, TILEPRO_OPC_OR_SN,
+  TILEPRO_OPC_MOVE_SN,
   BITFIELD(49, 5) /* index 689 */,
-  TILE_OPC_SB, TILE_OPC_SEQB_SN, TILE_OPC_SEQH_SN, TILE_OPC_SEQ_SN,
-  TILE_OPC_SHLB_SN, TILE_OPC_SHLH_SN, TILE_OPC_SHL_SN, TILE_OPC_SHRB_SN,
-  TILE_OPC_SHRH_SN, TILE_OPC_SHR_SN, TILE_OPC_SH, TILE_OPC_SLTB_SN,
-  TILE_OPC_SLTB_U_SN, TILE_OPC_SLTEB_SN, TILE_OPC_SLTEB_U_SN,
-  TILE_OPC_SLTEH_SN, TILE_OPC_SLTEH_U_SN, TILE_OPC_SLTE_SN,
-  TILE_OPC_SLTE_U_SN, TILE_OPC_SLTH_SN, TILE_OPC_SLTH_U_SN, TILE_OPC_SLT_SN,
-  TILE_OPC_SLT_U_SN, TILE_OPC_SNEB_SN, TILE_OPC_SNEH_SN, TILE_OPC_SNE_SN,
-  TILE_OPC_SRAB_SN, TILE_OPC_SRAH_SN, TILE_OPC_SRA_SN, TILE_OPC_SUBB_SN,
-  TILE_OPC_SUBH_SN, TILE_OPC_SUB_SN,
+  TILEPRO_OPC_SB, TILEPRO_OPC_SEQB_SN, TILEPRO_OPC_SEQH_SN,
+  TILEPRO_OPC_SEQ_SN, TILEPRO_OPC_SHLB_SN, TILEPRO_OPC_SHLH_SN,
+  TILEPRO_OPC_SHL_SN, TILEPRO_OPC_SHRB_SN, TILEPRO_OPC_SHRH_SN,
+  TILEPRO_OPC_SHR_SN, TILEPRO_OPC_SH, TILEPRO_OPC_SLTB_SN,
+  TILEPRO_OPC_SLTB_U_SN, TILEPRO_OPC_SLTEB_SN, TILEPRO_OPC_SLTEB_U_SN,
+  TILEPRO_OPC_SLTEH_SN, TILEPRO_OPC_SLTEH_U_SN, TILEPRO_OPC_SLTE_SN,
+  TILEPRO_OPC_SLTE_U_SN, TILEPRO_OPC_SLTH_SN, TILEPRO_OPC_SLTH_U_SN,
+  TILEPRO_OPC_SLT_SN, TILEPRO_OPC_SLT_U_SN, TILEPRO_OPC_SNEB_SN,
+  TILEPRO_OPC_SNEH_SN, TILEPRO_OPC_SNE_SN, TILEPRO_OPC_SRAB_SN,
+  TILEPRO_OPC_SRAH_SN, TILEPRO_OPC_SRA_SN, TILEPRO_OPC_SUBB_SN,
+  TILEPRO_OPC_SUBH_SN, TILEPRO_OPC_SUB_SN,
   BITFIELD(49, 4) /* index 722 */,
   CHILD(611), CHILD(739), CHILD(742), CHILD(745), CHILD(748), CHILD(751),
-  CHILD(754), CHILD(757), CHILD(760), CHILD(763), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(754), CHILD(757), CHILD(760), CHILD(763), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 739 */,
-  TILE_OPC_XOR_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_XOR_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 742 */,
-  TILE_OPC_ADDS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDS_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 745 */,
-  TILE_OPC_SUBS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBS_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 748 */,
-  TILE_OPC_ADDBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 751 */,
-  TILE_OPC_ADDHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_ADDHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 754 */,
-  TILE_OPC_SUBBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 757 */,
-  TILE_OPC_SUBHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SUBHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 760 */,
-  TILE_OPC_PACKHS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKHS_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 763 */,
-  TILE_OPC_PACKBS_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_PACKBS_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(37, 2) /* index 766 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, CHILD(771),
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  CHILD(771),
   BITFIELD(39, 2) /* index 771 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, CHILD(776),
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  CHILD(776),
   BITFIELD(41, 2) /* index 776 */,
-  TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_ADDLI_SN, TILE_OPC_MOVELI_SN,
+  TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN, TILEPRO_OPC_ADDLI_SN,
+  TILEPRO_OPC_MOVELI_SN,
   BITFIELD(37, 2) /* index 781 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, CHILD(786),
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, CHILD(786),
   BITFIELD(39, 2) /* index 786 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, CHILD(791),
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, CHILD(791),
   BITFIELD(41, 2) /* index 791 */,
-  TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_ADDLI, TILE_OPC_MOVELI,
+  TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_ADDLI, TILEPRO_OPC_MOVELI,
   BITFIELD(31, 2) /* index 796 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(801),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(801),
   BITFIELD(33, 2) /* index 801 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(806),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(806),
   BITFIELD(35, 2) /* index 806 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(811),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(811),
   BITFIELD(37, 2) /* index 811 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(816),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(816),
   BITFIELD(39, 2) /* index 816 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, CHILD(821),
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, CHILD(821),
   BITFIELD(41, 2) /* index 821 */,
-  TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_AULI, TILE_OPC_INFOL,
+  TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_AULI, TILEPRO_OPC_INFOL,
   BITFIELD(31, 4) /* index 826 */,
-  TILE_OPC_BZ, TILE_OPC_BZT, TILE_OPC_BNZ, TILE_OPC_BNZT, TILE_OPC_BGZ,
-  TILE_OPC_BGZT, TILE_OPC_BGEZ, TILE_OPC_BGEZT, TILE_OPC_BLZ, TILE_OPC_BLZT,
-  TILE_OPC_BLEZ, TILE_OPC_BLEZT, TILE_OPC_BBS, TILE_OPC_BBST, TILE_OPC_BBNS,
-  TILE_OPC_BBNST,
+  TILEPRO_OPC_BZ, TILEPRO_OPC_BZT, TILEPRO_OPC_BNZ, TILEPRO_OPC_BNZT,
+  TILEPRO_OPC_BGZ, TILEPRO_OPC_BGZT, TILEPRO_OPC_BGEZ, TILEPRO_OPC_BGEZT,
+  TILEPRO_OPC_BLZ, TILEPRO_OPC_BLZT, TILEPRO_OPC_BLEZ, TILEPRO_OPC_BLEZT,
+  TILEPRO_OPC_BBS, TILEPRO_OPC_BBST, TILEPRO_OPC_BBNS, TILEPRO_OPC_BBNST,
   BITFIELD(31, 4) /* index 843 */,
-  TILE_OPC_BZ_SN, TILE_OPC_BZT_SN, TILE_OPC_BNZ_SN, TILE_OPC_BNZT_SN,
-  TILE_OPC_BGZ_SN, TILE_OPC_BGZT_SN, TILE_OPC_BGEZ_SN, TILE_OPC_BGEZT_SN,
-  TILE_OPC_BLZ_SN, TILE_OPC_BLZT_SN, TILE_OPC_BLEZ_SN, TILE_OPC_BLEZT_SN,
-  TILE_OPC_BBS_SN, TILE_OPC_BBST_SN, TILE_OPC_BBNS_SN, TILE_OPC_BBNST_SN,
+  TILEPRO_OPC_BZ_SN, TILEPRO_OPC_BZT_SN, TILEPRO_OPC_BNZ_SN,
+  TILEPRO_OPC_BNZT_SN, TILEPRO_OPC_BGZ_SN, TILEPRO_OPC_BGZT_SN,
+  TILEPRO_OPC_BGEZ_SN, TILEPRO_OPC_BGEZT_SN, TILEPRO_OPC_BLZ_SN,
+  TILEPRO_OPC_BLZT_SN, TILEPRO_OPC_BLEZ_SN, TILEPRO_OPC_BLEZT_SN,
+  TILEPRO_OPC_BBS_SN, TILEPRO_OPC_BBST_SN, TILEPRO_OPC_BBNS_SN,
+  TILEPRO_OPC_BBNST_SN,
   BITFIELD(51, 3) /* index 860 */,
-  TILE_OPC_NONE, TILE_OPC_ADDIB, TILE_OPC_ADDIH, TILE_OPC_ADDI, CHILD(869),
-  TILE_OPC_MAXIB_U, TILE_OPC_MAXIH, TILE_OPC_MFSPR,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDIB, TILEPRO_OPC_ADDIH, TILEPRO_OPC_ADDI,
+  CHILD(869), TILEPRO_OPC_MAXIB_U, TILEPRO_OPC_MAXIH, TILEPRO_OPC_MFSPR,
   BITFIELD(31, 2) /* index 869 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(874),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(874),
   BITFIELD(33, 2) /* index 874 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(879),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(879),
   BITFIELD(35, 2) /* index 879 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(884),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(884),
   BITFIELD(37, 2) /* index 884 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(889),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(889),
   BITFIELD(39, 2) /* index 889 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(894),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(894),
   BITFIELD(41, 2) /* index 894 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_INFO,
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_INFO,
   BITFIELD(51, 3) /* index 899 */,
-  TILE_OPC_MINIB_U, TILE_OPC_MINIH, TILE_OPC_MTSPR, CHILD(908),
-  TILE_OPC_SEQIB, TILE_OPC_SEQIH, TILE_OPC_SEQI, TILE_OPC_SLTIB,
+  TILEPRO_OPC_MINIB_U, TILEPRO_OPC_MINIH, TILEPRO_OPC_MTSPR, CHILD(908),
+  TILEPRO_OPC_SEQIB, TILEPRO_OPC_SEQIH, TILEPRO_OPC_SEQI, TILEPRO_OPC_SLTIB,
   BITFIELD(37, 2) /* index 908 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(913),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(913),
   BITFIELD(39, 2) /* index 913 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(918),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(918),
   BITFIELD(41, 2) /* index 918 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_MOVEI,
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_MOVEI,
   BITFIELD(51, 3) /* index 923 */,
-  TILE_OPC_SLTIB_U, TILE_OPC_SLTIH, TILE_OPC_SLTIH_U, TILE_OPC_SLTI,
-  TILE_OPC_SLTI_U, TILE_OPC_XORI, TILE_OPC_LBADD, TILE_OPC_LBADD_U,
+  TILEPRO_OPC_SLTIB_U, TILEPRO_OPC_SLTIH, TILEPRO_OPC_SLTIH_U,
+  TILEPRO_OPC_SLTI, TILEPRO_OPC_SLTI_U, TILEPRO_OPC_XORI, TILEPRO_OPC_LBADD,
+  TILEPRO_OPC_LBADD_U,
   BITFIELD(51, 3) /* index 932 */,
-  TILE_OPC_LHADD, TILE_OPC_LHADD_U, TILE_OPC_LWADD, TILE_OPC_LWADD_NA,
-  TILE_OPC_SBADD, TILE_OPC_SHADD, TILE_OPC_SWADD, TILE_OPC_NONE,
+  TILEPRO_OPC_LHADD, TILEPRO_OPC_LHADD_U, TILEPRO_OPC_LWADD,
+  TILEPRO_OPC_LWADD_NA, TILEPRO_OPC_SBADD, TILEPRO_OPC_SHADD,
+  TILEPRO_OPC_SWADD, TILEPRO_OPC_NONE,
   BITFIELD(51, 3) /* index 941 */,
-  TILE_OPC_NONE, TILE_OPC_ADDIB_SN, TILE_OPC_ADDIH_SN, TILE_OPC_ADDI_SN,
-  TILE_OPC_ANDI_SN, TILE_OPC_MAXIB_U_SN, TILE_OPC_MAXIH_SN, TILE_OPC_MFSPR,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_ADDIB_SN, TILEPRO_OPC_ADDIH_SN,
+  TILEPRO_OPC_ADDI_SN, TILEPRO_OPC_ANDI_SN, TILEPRO_OPC_MAXIB_U_SN,
+  TILEPRO_OPC_MAXIH_SN, TILEPRO_OPC_MFSPR,
   BITFIELD(51, 3) /* index 950 */,
-  TILE_OPC_MINIB_U_SN, TILE_OPC_MINIH_SN, TILE_OPC_MTSPR, CHILD(959),
-  TILE_OPC_SEQIB_SN, TILE_OPC_SEQIH_SN, TILE_OPC_SEQI_SN, TILE_OPC_SLTIB_SN,
+  TILEPRO_OPC_MINIB_U_SN, TILEPRO_OPC_MINIH_SN, TILEPRO_OPC_MTSPR, CHILD(959),
+  TILEPRO_OPC_SEQIB_SN, TILEPRO_OPC_SEQIH_SN, TILEPRO_OPC_SEQI_SN,
+  TILEPRO_OPC_SLTIB_SN,
   BITFIELD(37, 2) /* index 959 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, CHILD(964),
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, CHILD(964),
   BITFIELD(39, 2) /* index 964 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, CHILD(969),
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, CHILD(969),
   BITFIELD(41, 2) /* index 969 */,
-  TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_ORI_SN, TILE_OPC_MOVEI_SN,
+  TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN, TILEPRO_OPC_ORI_SN,
+  TILEPRO_OPC_MOVEI_SN,
   BITFIELD(51, 3) /* index 974 */,
-  TILE_OPC_SLTIB_U_SN, TILE_OPC_SLTIH_SN, TILE_OPC_SLTIH_U_SN,
-  TILE_OPC_SLTI_SN, TILE_OPC_SLTI_U_SN, TILE_OPC_XORI_SN, TILE_OPC_LBADD_SN,
-  TILE_OPC_LBADD_U_SN,
+  TILEPRO_OPC_SLTIB_U_SN, TILEPRO_OPC_SLTIH_SN, TILEPRO_OPC_SLTIH_U_SN,
+  TILEPRO_OPC_SLTI_SN, TILEPRO_OPC_SLTI_U_SN, TILEPRO_OPC_XORI_SN,
+  TILEPRO_OPC_LBADD_SN, TILEPRO_OPC_LBADD_U_SN,
   BITFIELD(51, 3) /* index 983 */,
-  TILE_OPC_LHADD_SN, TILE_OPC_LHADD_U_SN, TILE_OPC_LWADD_SN,
-  TILE_OPC_LWADD_NA_SN, TILE_OPC_SBADD, TILE_OPC_SHADD, TILE_OPC_SWADD,
-  TILE_OPC_NONE,
+  TILEPRO_OPC_LHADD_SN, TILEPRO_OPC_LHADD_U_SN, TILEPRO_OPC_LWADD_SN,
+  TILEPRO_OPC_LWADD_NA_SN, TILEPRO_OPC_SBADD, TILEPRO_OPC_SHADD,
+  TILEPRO_OPC_SWADD, TILEPRO_OPC_NONE,
   BITFIELD(46, 7) /* index 992 */,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(1121),
-  CHILD(1121), CHILD(1121), CHILD(1121), CHILD(1124), CHILD(1124),
-  CHILD(1124), CHILD(1124), CHILD(1127), CHILD(1127), CHILD(1127),
-  CHILD(1127), CHILD(1130), CHILD(1130), CHILD(1130), CHILD(1130),
-  CHILD(1133), CHILD(1133), CHILD(1133), CHILD(1133), CHILD(1136),
-  CHILD(1136), CHILD(1136), CHILD(1136), CHILD(1139), CHILD(1139),
-  CHILD(1139), CHILD(1139), CHILD(1142), CHILD(1142), CHILD(1142),
-  CHILD(1142), CHILD(1145), CHILD(1145), CHILD(1145), CHILD(1145),
-  CHILD(1148), CHILD(1148), CHILD(1148), CHILD(1148), CHILD(1151),
-  CHILD(1242), CHILD(1290), CHILD(1323), TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  CHILD(1121), CHILD(1121), CHILD(1121), CHILD(1121), CHILD(1124),
+  CHILD(1124), CHILD(1124), CHILD(1124), CHILD(1127), CHILD(1127),
+  CHILD(1127), CHILD(1127), CHILD(1130), CHILD(1130), CHILD(1130),
+  CHILD(1130), CHILD(1133), CHILD(1133), CHILD(1133), CHILD(1133),
+  CHILD(1136), CHILD(1136), CHILD(1136), CHILD(1136), CHILD(1139),
+  CHILD(1139), CHILD(1139), CHILD(1139), CHILD(1142), CHILD(1142),
+  CHILD(1142), CHILD(1142), CHILD(1145), CHILD(1145), CHILD(1145),
+  CHILD(1145), CHILD(1148), CHILD(1148), CHILD(1148), CHILD(1148),
+  CHILD(1151), CHILD(1242), CHILD(1290), CHILD(1323), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1121 */,
-  TILE_OPC_RLI, TILE_OPC_NONE,
+  TILEPRO_OPC_RLI, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1124 */,
-  TILE_OPC_SHLIB, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLIB, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1127 */,
-  TILE_OPC_SHLIH, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLIH, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1130 */,
-  TILE_OPC_SHLI, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLI, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1133 */,
-  TILE_OPC_SHRIB, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRIB, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1136 */,
-  TILE_OPC_SHRIH, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRIH, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1139 */,
-  TILE_OPC_SHRI, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRI, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1142 */,
-  TILE_OPC_SRAIB, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAIB, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1145 */,
-  TILE_OPC_SRAIH, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAIH, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1148 */,
-  TILE_OPC_SRAI, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAI, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 1151 */,
-  TILE_OPC_NONE, CHILD(1160), CHILD(1163), CHILD(1166), CHILD(1169),
+  TILEPRO_OPC_NONE, CHILD(1160), CHILD(1163), CHILD(1166), CHILD(1169),
   CHILD(1172), CHILD(1175), CHILD(1178),
   BITFIELD(53, 1) /* index 1160 */,
-  TILE_OPC_DRAIN, TILE_OPC_NONE,
+  TILEPRO_OPC_DRAIN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1163 */,
-  TILE_OPC_DTLBPR, TILE_OPC_NONE,
+  TILEPRO_OPC_DTLBPR, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1166 */,
-  TILE_OPC_FINV, TILE_OPC_NONE,
+  TILEPRO_OPC_FINV, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1169 */,
-  TILE_OPC_FLUSH, TILE_OPC_NONE,
+  TILEPRO_OPC_FLUSH, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1172 */,
-  TILE_OPC_FNOP, TILE_OPC_NONE,
+  TILEPRO_OPC_FNOP, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1175 */,
-  TILE_OPC_ICOH, TILE_OPC_NONE,
+  TILEPRO_OPC_ICOH, TILEPRO_OPC_NONE,
   BITFIELD(31, 2) /* index 1178 */,
   CHILD(1183), CHILD(1211), CHILD(1239), CHILD(1239),
   BITFIELD(53, 1) /* index 1183 */,
-  CHILD(1186), TILE_OPC_NONE,
+  CHILD(1186), TILEPRO_OPC_NONE,
   BITFIELD(33, 2) /* index 1186 */,
-  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_ILL, CHILD(1191),
+  TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, CHILD(1191),
   BITFIELD(35, 2) /* index 1191 */,
-  TILE_OPC_ILL, CHILD(1196), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1196), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(37, 2) /* index 1196 */,
-  TILE_OPC_ILL, CHILD(1201), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1201), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(39, 2) /* index 1201 */,
-  TILE_OPC_ILL, CHILD(1206), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1206), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(41, 2) /* index 1206 */,
-  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_BPT, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, TILEPRO_OPC_BPT, TILEPRO_OPC_ILL,
   BITFIELD(53, 1) /* index 1211 */,
-  CHILD(1214), TILE_OPC_NONE,
+  CHILD(1214), TILEPRO_OPC_NONE,
   BITFIELD(33, 2) /* index 1214 */,
-  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_ILL, CHILD(1219),
+  TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, CHILD(1219),
   BITFIELD(35, 2) /* index 1219 */,
-  TILE_OPC_ILL, CHILD(1224), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1224), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(37, 2) /* index 1224 */,
-  TILE_OPC_ILL, CHILD(1229), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1229), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(39, 2) /* index 1229 */,
-  TILE_OPC_ILL, CHILD(1234), TILE_OPC_ILL, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, CHILD(1234), TILEPRO_OPC_ILL, TILEPRO_OPC_ILL,
   BITFIELD(41, 2) /* index 1234 */,
-  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_RAISE, TILE_OPC_ILL,
+  TILEPRO_OPC_ILL, TILEPRO_OPC_ILL, TILEPRO_OPC_RAISE, TILEPRO_OPC_ILL,
   BITFIELD(53, 1) /* index 1239 */,
-  TILE_OPC_ILL, TILE_OPC_NONE,
+  TILEPRO_OPC_ILL, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 1242 */,
   CHILD(1251), CHILD(1254), CHILD(1257), CHILD(1275), CHILD(1278),
   CHILD(1281), CHILD(1284), CHILD(1287),
   BITFIELD(53, 1) /* index 1251 */,
-  TILE_OPC_INV, TILE_OPC_NONE,
+  TILEPRO_OPC_INV, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1254 */,
-  TILE_OPC_IRET, TILE_OPC_NONE,
+  TILEPRO_OPC_IRET, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1257 */,
-  CHILD(1260), TILE_OPC_NONE,
+  CHILD(1260), TILEPRO_OPC_NONE,
   BITFIELD(31, 2) /* index 1260 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1265),
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, CHILD(1265),
   BITFIELD(33, 2) /* index 1265 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1270),
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, CHILD(1270),
   BITFIELD(35, 2) /* index 1270 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_PREFETCH,
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_PREFETCH,
   BITFIELD(53, 1) /* index 1275 */,
-  TILE_OPC_LB_U, TILE_OPC_NONE,
+  TILEPRO_OPC_LB_U, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1278 */,
-  TILE_OPC_LH, TILE_OPC_NONE,
+  TILEPRO_OPC_LH, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1281 */,
-  TILE_OPC_LH_U, TILE_OPC_NONE,
+  TILEPRO_OPC_LH_U, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1284 */,
-  TILE_OPC_LW, TILE_OPC_NONE,
+  TILEPRO_OPC_LW, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1287 */,
-  TILE_OPC_MF, TILE_OPC_NONE,
+  TILEPRO_OPC_MF, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 1290 */,
   CHILD(1299), CHILD(1302), CHILD(1305), CHILD(1308), CHILD(1311),
   CHILD(1314), CHILD(1317), CHILD(1320),
   BITFIELD(53, 1) /* index 1299 */,
-  TILE_OPC_NAP, TILE_OPC_NONE,
+  TILEPRO_OPC_NAP, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1302 */,
-  TILE_OPC_NOP, TILE_OPC_NONE,
+  TILEPRO_OPC_NOP, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1305 */,
-  TILE_OPC_SWINT0, TILE_OPC_NONE,
+  TILEPRO_OPC_SWINT0, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1308 */,
-  TILE_OPC_SWINT1, TILE_OPC_NONE,
+  TILEPRO_OPC_SWINT1, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1311 */,
-  TILE_OPC_SWINT2, TILE_OPC_NONE,
+  TILEPRO_OPC_SWINT2, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1314 */,
-  TILE_OPC_SWINT3, TILE_OPC_NONE,
+  TILEPRO_OPC_SWINT3, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1317 */,
-  TILE_OPC_TNS, TILE_OPC_NONE,
+  TILEPRO_OPC_TNS, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1320 */,
-  TILE_OPC_WH64, TILE_OPC_NONE,
+  TILEPRO_OPC_WH64, TILEPRO_OPC_NONE,
   BITFIELD(43, 2) /* index 1323 */,
-  CHILD(1328), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(1328), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(45, 1) /* index 1328 */,
-  CHILD(1331), TILE_OPC_NONE,
+  CHILD(1331), TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1331 */,
-  TILE_OPC_LW_NA, TILE_OPC_NONE,
+  TILEPRO_OPC_LW_NA, TILEPRO_OPC_NONE,
   BITFIELD(46, 7) /* index 1334 */,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(1463),
-  CHILD(1463), CHILD(1463), CHILD(1463), CHILD(1466), CHILD(1466),
-  CHILD(1466), CHILD(1466), CHILD(1469), CHILD(1469), CHILD(1469),
-  CHILD(1469), CHILD(1472), CHILD(1472), CHILD(1472), CHILD(1472),
-  CHILD(1475), CHILD(1475), CHILD(1475), CHILD(1475), CHILD(1478),
-  CHILD(1478), CHILD(1478), CHILD(1478), CHILD(1481), CHILD(1481),
-  CHILD(1481), CHILD(1481), CHILD(1484), CHILD(1484), CHILD(1484),
-  CHILD(1484), CHILD(1487), CHILD(1487), CHILD(1487), CHILD(1487),
-  CHILD(1490), CHILD(1490), CHILD(1490), CHILD(1490), CHILD(1151),
-  CHILD(1493), CHILD(1517), CHILD(1529), TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  CHILD(1463), CHILD(1463), CHILD(1463), CHILD(1463), CHILD(1466),
+  CHILD(1466), CHILD(1466), CHILD(1466), CHILD(1469), CHILD(1469),
+  CHILD(1469), CHILD(1469), CHILD(1472), CHILD(1472), CHILD(1472),
+  CHILD(1472), CHILD(1475), CHILD(1475), CHILD(1475), CHILD(1475),
+  CHILD(1478), CHILD(1478), CHILD(1478), CHILD(1478), CHILD(1481),
+  CHILD(1481), CHILD(1481), CHILD(1481), CHILD(1484), CHILD(1484),
+  CHILD(1484), CHILD(1484), CHILD(1487), CHILD(1487), CHILD(1487),
+  CHILD(1487), CHILD(1490), CHILD(1490), CHILD(1490), CHILD(1490),
+  CHILD(1151), CHILD(1493), CHILD(1517), CHILD(1529), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1463 */,
-  TILE_OPC_RLI_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_RLI_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1466 */,
-  TILE_OPC_SHLIB_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLIB_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1469 */,
-  TILE_OPC_SHLIH_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLIH_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1472 */,
-  TILE_OPC_SHLI_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHLI_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1475 */,
-  TILE_OPC_SHRIB_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRIB_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1478 */,
-  TILE_OPC_SHRIH_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRIH_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1481 */,
-  TILE_OPC_SHRI_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SHRI_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1484 */,
-  TILE_OPC_SRAIB_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAIB_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1487 */,
-  TILE_OPC_SRAIH_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAIH_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1490 */,
-  TILE_OPC_SRAI_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_SRAI_SN, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 1493 */,
   CHILD(1251), CHILD(1254), CHILD(1502), CHILD(1505), CHILD(1508),
   CHILD(1511), CHILD(1514), CHILD(1287),
   BITFIELD(53, 1) /* index 1502 */,
-  TILE_OPC_LB_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LB_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1505 */,
-  TILE_OPC_LB_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LB_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1508 */,
-  TILE_OPC_LH_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LH_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1511 */,
-  TILE_OPC_LH_U_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LH_U_SN, TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1514 */,
-  TILE_OPC_LW_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LW_SN, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 1517 */,
   CHILD(1299), CHILD(1302), CHILD(1305), CHILD(1308), CHILD(1311),
   CHILD(1314), CHILD(1526), CHILD(1320),
   BITFIELD(53, 1) /* index 1526 */,
-  TILE_OPC_TNS_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_TNS_SN, TILEPRO_OPC_NONE,
   BITFIELD(43, 2) /* index 1529 */,
-  CHILD(1534), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(1534), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(45, 1) /* index 1534 */,
-  CHILD(1537), TILE_OPC_NONE,
+  CHILD(1537), TILEPRO_OPC_NONE,
   BITFIELD(53, 1) /* index 1537 */,
-  TILE_OPC_LW_NA_SN, TILE_OPC_NONE,
+  TILEPRO_OPC_LW_NA_SN, TILEPRO_OPC_NONE,
 };
 
 static const unsigned short decode_Y0_fsm[168] =
 {
   BITFIELD(27, 4) /* index 0 */,
-  TILE_OPC_NONE, CHILD(17), CHILD(22), CHILD(27), CHILD(47), CHILD(52),
-  CHILD(57), CHILD(62), CHILD(67), TILE_OPC_ADDI, CHILD(72), CHILD(102),
-  TILE_OPC_SEQI, CHILD(117), TILE_OPC_SLTI, TILE_OPC_SLTI_U,
+  TILEPRO_OPC_NONE, CHILD(17), CHILD(22), CHILD(27), CHILD(47), CHILD(52),
+  CHILD(57), CHILD(62), CHILD(67), TILEPRO_OPC_ADDI, CHILD(72), CHILD(102),
+  TILEPRO_OPC_SEQI, CHILD(117), TILEPRO_OPC_SLTI, TILEPRO_OPC_SLTI_U,
   BITFIELD(18, 2) /* index 17 */,
-  TILE_OPC_ADD, TILE_OPC_S1A, TILE_OPC_S2A, TILE_OPC_SUB,
+  TILEPRO_OPC_ADD, TILEPRO_OPC_S1A, TILEPRO_OPC_S2A, TILEPRO_OPC_SUB,
   BITFIELD(18, 2) /* index 22 */,
-  TILE_OPC_MNZ, TILE_OPC_MVNZ, TILE_OPC_MVZ, TILE_OPC_MZ,
+  TILEPRO_OPC_MNZ, TILEPRO_OPC_MVNZ, TILEPRO_OPC_MVZ, TILEPRO_OPC_MZ,
   BITFIELD(18, 2) /* index 27 */,
-  TILE_OPC_AND, TILE_OPC_NOR, CHILD(32), TILE_OPC_XOR,
+  TILEPRO_OPC_AND, TILEPRO_OPC_NOR, CHILD(32), TILEPRO_OPC_XOR,
   BITFIELD(12, 2) /* index 32 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(37),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(37),
   BITFIELD(14, 2) /* index 37 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(42),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(42),
   BITFIELD(16, 2) /* index 42 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_MOVE,
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_MOVE,
   BITFIELD(18, 2) /* index 47 */,
-  TILE_OPC_RL, TILE_OPC_SHL, TILE_OPC_SHR, TILE_OPC_SRA,
+  TILEPRO_OPC_RL, TILEPRO_OPC_SHL, TILEPRO_OPC_SHR, TILEPRO_OPC_SRA,
   BITFIELD(18, 2) /* index 52 */,
-  TILE_OPC_SLTE, TILE_OPC_SLTE_U, TILE_OPC_SLT, TILE_OPC_SLT_U,
+  TILEPRO_OPC_SLTE, TILEPRO_OPC_SLTE_U, TILEPRO_OPC_SLT, TILEPRO_OPC_SLT_U,
   BITFIELD(18, 2) /* index 57 */,
-  TILE_OPC_MULHLSA_UU, TILE_OPC_S3A, TILE_OPC_SEQ, TILE_OPC_SNE,
+  TILEPRO_OPC_MULHLSA_UU, TILEPRO_OPC_S3A, TILEPRO_OPC_SEQ, TILEPRO_OPC_SNE,
   BITFIELD(18, 2) /* index 62 */,
-  TILE_OPC_MULHH_SS, TILE_OPC_MULHH_UU, TILE_OPC_MULLL_SS, TILE_OPC_MULLL_UU,
+  TILEPRO_OPC_MULHH_SS, TILEPRO_OPC_MULHH_UU, TILEPRO_OPC_MULLL_SS,
+  TILEPRO_OPC_MULLL_UU,
   BITFIELD(18, 2) /* index 67 */,
-  TILE_OPC_MULHHA_SS, TILE_OPC_MULHHA_UU, TILE_OPC_MULLLA_SS,
-  TILE_OPC_MULLLA_UU,
+  TILEPRO_OPC_MULHHA_SS, TILEPRO_OPC_MULHHA_UU, TILEPRO_OPC_MULLLA_SS,
+  TILEPRO_OPC_MULLLA_UU,
   BITFIELD(0, 2) /* index 72 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(77),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(77),
   BITFIELD(2, 2) /* index 77 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(82),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(82),
   BITFIELD(4, 2) /* index 82 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(87),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(87),
   BITFIELD(6, 2) /* index 87 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(92),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(92),
   BITFIELD(8, 2) /* index 92 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(97),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(97),
   BITFIELD(10, 2) /* index 97 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_INFO,
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_INFO,
   BITFIELD(6, 2) /* index 102 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(107),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(107),
   BITFIELD(8, 2) /* index 107 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(112),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(112),
   BITFIELD(10, 2) /* index 112 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_MOVEI,
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_MOVEI,
   BITFIELD(15, 5) /* index 117 */,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_RLI,
-  TILE_OPC_RLI, TILE_OPC_RLI, TILE_OPC_RLI, TILE_OPC_SHLI, TILE_OPC_SHLI,
-  TILE_OPC_SHLI, TILE_OPC_SHLI, TILE_OPC_SHRI, TILE_OPC_SHRI, TILE_OPC_SHRI,
-  TILE_OPC_SHRI, TILE_OPC_SRAI, TILE_OPC_SRAI, TILE_OPC_SRAI, TILE_OPC_SRAI,
-  CHILD(150), CHILD(159), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_RLI, TILEPRO_OPC_RLI, TILEPRO_OPC_RLI, TILEPRO_OPC_RLI,
+  TILEPRO_OPC_SHLI, TILEPRO_OPC_SHLI, TILEPRO_OPC_SHLI, TILEPRO_OPC_SHLI,
+  TILEPRO_OPC_SHRI, TILEPRO_OPC_SHRI, TILEPRO_OPC_SHRI, TILEPRO_OPC_SHRI,
+  TILEPRO_OPC_SRAI, TILEPRO_OPC_SRAI, TILEPRO_OPC_SRAI, TILEPRO_OPC_SRAI,
+  CHILD(150), CHILD(159), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(12, 3) /* index 150 */,
-  TILE_OPC_NONE, TILE_OPC_BITX, TILE_OPC_BYTEX, TILE_OPC_CLZ, TILE_OPC_CTZ,
-  TILE_OPC_FNOP, TILE_OPC_NOP, TILE_OPC_PCNT,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_BITX, TILEPRO_OPC_BYTEX, TILEPRO_OPC_CLZ,
+  TILEPRO_OPC_CTZ, TILEPRO_OPC_FNOP, TILEPRO_OPC_NOP, TILEPRO_OPC_PCNT,
   BITFIELD(12, 3) /* index 159 */,
-  TILE_OPC_TBLIDXB0, TILE_OPC_TBLIDXB1, TILE_OPC_TBLIDXB2, TILE_OPC_TBLIDXB3,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_TBLIDXB0, TILEPRO_OPC_TBLIDXB1, TILEPRO_OPC_TBLIDXB2,
+  TILEPRO_OPC_TBLIDXB3, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE,
 };
 
 static const unsigned short decode_Y1_fsm[140] =
 {
   BITFIELD(59, 4) /* index 0 */,
-  TILE_OPC_NONE, CHILD(17), CHILD(22), CHILD(27), CHILD(47), CHILD(52),
-  CHILD(57), TILE_OPC_ADDI, CHILD(62), CHILD(92), TILE_OPC_SEQI, CHILD(107),
-  TILE_OPC_SLTI, TILE_OPC_SLTI_U, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, CHILD(17), CHILD(22), CHILD(27), CHILD(47), CHILD(52),
+  CHILD(57), TILEPRO_OPC_ADDI, CHILD(62), CHILD(92), TILEPRO_OPC_SEQI,
+  CHILD(107), TILEPRO_OPC_SLTI, TILEPRO_OPC_SLTI_U, TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE,
   BITFIELD(49, 2) /* index 17 */,
-  TILE_OPC_ADD, TILE_OPC_S1A, TILE_OPC_S2A, TILE_OPC_SUB,
+  TILEPRO_OPC_ADD, TILEPRO_OPC_S1A, TILEPRO_OPC_S2A, TILEPRO_OPC_SUB,
   BITFIELD(49, 2) /* index 22 */,
-  TILE_OPC_NONE, TILE_OPC_MNZ, TILE_OPC_MZ, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_MNZ, TILEPRO_OPC_MZ, TILEPRO_OPC_NONE,
   BITFIELD(49, 2) /* index 27 */,
-  TILE_OPC_AND, TILE_OPC_NOR, CHILD(32), TILE_OPC_XOR,
+  TILEPRO_OPC_AND, TILEPRO_OPC_NOR, CHILD(32), TILEPRO_OPC_XOR,
   BITFIELD(43, 2) /* index 32 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(37),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(37),
   BITFIELD(45, 2) /* index 37 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, CHILD(42),
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, CHILD(42),
   BITFIELD(47, 2) /* index 42 */,
-  TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_OR, TILE_OPC_MOVE,
+  TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_OR, TILEPRO_OPC_MOVE,
   BITFIELD(49, 2) /* index 47 */,
-  TILE_OPC_RL, TILE_OPC_SHL, TILE_OPC_SHR, TILE_OPC_SRA,
+  TILEPRO_OPC_RL, TILEPRO_OPC_SHL, TILEPRO_OPC_SHR, TILEPRO_OPC_SRA,
   BITFIELD(49, 2) /* index 52 */,
-  TILE_OPC_SLTE, TILE_OPC_SLTE_U, TILE_OPC_SLT, TILE_OPC_SLT_U,
+  TILEPRO_OPC_SLTE, TILEPRO_OPC_SLTE_U, TILEPRO_OPC_SLT, TILEPRO_OPC_SLT_U,
   BITFIELD(49, 2) /* index 57 */,
-  TILE_OPC_NONE, TILE_OPC_S3A, TILE_OPC_SEQ, TILE_OPC_SNE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_S3A, TILEPRO_OPC_SEQ, TILEPRO_OPC_SNE,
   BITFIELD(31, 2) /* index 62 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(67),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(67),
   BITFIELD(33, 2) /* index 67 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(72),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(72),
   BITFIELD(35, 2) /* index 72 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(77),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(77),
   BITFIELD(37, 2) /* index 77 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(82),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(82),
   BITFIELD(39, 2) /* index 82 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, CHILD(87),
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, CHILD(87),
   BITFIELD(41, 2) /* index 87 */,
-  TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_ANDI, TILE_OPC_INFO,
+  TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_ANDI, TILEPRO_OPC_INFO,
   BITFIELD(37, 2) /* index 92 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(97),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(97),
   BITFIELD(39, 2) /* index 97 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, CHILD(102),
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, CHILD(102),
   BITFIELD(41, 2) /* index 102 */,
-  TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_ORI, TILE_OPC_MOVEI,
+  TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_ORI, TILEPRO_OPC_MOVEI,
   BITFIELD(48, 3) /* index 107 */,
-  TILE_OPC_NONE, TILE_OPC_RLI, TILE_OPC_SHLI, TILE_OPC_SHRI, TILE_OPC_SRAI,
-  CHILD(116), TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_RLI, TILEPRO_OPC_SHLI, TILEPRO_OPC_SHRI,
+  TILEPRO_OPC_SRAI, CHILD(116), TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(43, 3) /* index 116 */,
-  TILE_OPC_NONE, CHILD(125), CHILD(130), CHILD(135), TILE_OPC_NONE,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NONE, CHILD(125), CHILD(130), CHILD(135), TILEPRO_OPC_NONE,
+  TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(46, 2) /* index 125 */,
-  TILE_OPC_FNOP, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_FNOP, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(46, 2) /* index 130 */,
-  TILE_OPC_ILL, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_ILL, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
   BITFIELD(46, 2) /* index 135 */,
-  TILE_OPC_NOP, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  TILEPRO_OPC_NOP, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE, TILEPRO_OPC_NONE,
 };
 
 static const unsigned short decode_Y2_fsm[24] =
 {
   BITFIELD(56, 3) /* index 0 */,
-  CHILD(9), TILE_OPC_LB_U, TILE_OPC_LH, TILE_OPC_LH_U, TILE_OPC_LW,
-  TILE_OPC_SB, TILE_OPC_SH, TILE_OPC_SW,
+  CHILD(9), TILEPRO_OPC_LB_U, TILEPRO_OPC_LH, TILEPRO_OPC_LH_U,
+  TILEPRO_OPC_LW, TILEPRO_OPC_SB, TILEPRO_OPC_SH, TILEPRO_OPC_SW,
   BITFIELD(20, 2) /* index 9 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(14),
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, CHILD(14),
   BITFIELD(22, 2) /* index 14 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(19),
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, CHILD(19),
   BITFIELD(24, 2) /* index 19 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_PREFETCH,
+  TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_LB, TILEPRO_OPC_PREFETCH,
 };
 
 #undef BITFIELD
 #undef CHILD
 const unsigned short * const
-tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS] =
+tilepro_bundle_decoder_fsms[TILEPRO_NUM_PIPELINE_ENCODINGS] =
 {
   decode_X0_fsm,
   decode_X1_fsm,
@@ -2191,220 +2297,220 @@ tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS] =
   decode_Y1_fsm,
   decode_Y2_fsm
 };
-const struct tile_operand tile_operands[43] =
+const struct tilepro_operand tilepro_operands[43] =
 {
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_X0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM8_X0),
     8, 1, 0, 0, 0, 0,
     create_Imm8_X0, get_Imm8_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_X1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM8_X1),
     8, 1, 0, 0, 0, 0,
     create_Imm8_X1, get_Imm8_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_Y0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM8_Y0),
     8, 1, 0, 0, 0, 0,
     create_Imm8_Y0, get_Imm8_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_Y1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM8_Y1),
     8, 1, 0, 0, 0, 0,
     create_Imm8_Y1, get_Imm8_Y1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM16_X0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM16_X0),
     16, 1, 0, 0, 0, 0,
     create_Imm16_X0, get_Imm16_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM16_X1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_IMM16_X1),
     16, 1, 0, 0, 0, 0,
     create_Imm16_X1, get_Imm16_X1
   },
   {
-    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_JOFFLONG_X1),
-    29, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    TILEPRO_OP_TYPE_ADDRESS, BFD_RELOC(TILEPRO_JOFFLONG_X1),
+    29, 1, 0, 0, 1, TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
     create_JOffLong_X1, get_JOffLong_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 0, 1, 0, 0,
     create_Dest_X0, get_Dest_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcA_X0, get_SrcA_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 0, 1, 0, 0,
     create_Dest_X1, get_Dest_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcA_X1, get_SrcA_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 0, 1, 0, 0,
     create_Dest_Y0, get_Dest_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcA_Y0, get_SrcA_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 0, 1, 0, 0,
     create_Dest_Y1, get_Dest_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcA_Y1, get_SrcA_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcA_Y2, get_SrcA_Y2
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcB_X0, get_SrcB_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcB_X1, get_SrcB_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcB_Y0, get_SrcB_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcB_Y1, get_SrcB_Y1
   },
   {
-    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_BROFF_X1),
-    17, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    TILEPRO_OP_TYPE_ADDRESS, BFD_RELOC(TILEPRO_BROFF_X1),
+    17, 1, 0, 0, 1, TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
     create_BrOff_X1, get_BrOff_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 1, 0, 0,
     create_Dest_X0, get_Dest_X0
   },
   {
-    TILE_OP_TYPE_ADDRESS, BFD_RELOC(NONE),
-    28, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    TILEPRO_OP_TYPE_ADDRESS, BFD_RELOC(NONE),
+    28, 1, 0, 0, 1, TILEPRO_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
     create_JOff_X1, get_JOff_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 0, 1, 0, 0,
     create_SrcBDest_Y2, get_SrcBDest_Y2
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 1, 0, 0,
     create_SrcA_X1, get_SrcA_X1
   },
   {
-    TILE_OP_TYPE_SPR, BFD_RELOC(TILE_MF_IMM15_X1),
+    TILEPRO_OP_TYPE_SPR, BFD_RELOC(TILEPRO_MF_IMM15_X1),
     15, 0, 0, 0, 0, 0,
     create_MF_Imm15_X1, get_MF_Imm15_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMSTART_X0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_MMSTART_X0),
     5, 0, 0, 0, 0, 0,
     create_MMStart_X0, get_MMStart_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMEND_X0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_MMEND_X0),
     5, 0, 0, 0, 0, 0,
     create_MMEnd_X0, get_MMEnd_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMSTART_X1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_MMSTART_X1),
     5, 0, 0, 0, 0, 0,
     create_MMStart_X1, get_MMStart_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMEND_X1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_MMEND_X1),
     5, 0, 0, 0, 0, 0,
     create_MMEnd_X1, get_MMEnd_X1
   },
   {
-    TILE_OP_TYPE_SPR, BFD_RELOC(TILE_MT_IMM15_X1),
+    TILEPRO_OP_TYPE_SPR, BFD_RELOC(TILEPRO_MT_IMM15_X1),
     15, 0, 0, 0, 0, 0,
     create_MT_Imm15_X1, get_MT_Imm15_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 1, 0, 0,
     create_Dest_Y0, get_Dest_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_X0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_SHAMT_X0),
     5, 0, 0, 0, 0, 0,
     create_ShAmt_X0, get_ShAmt_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_X1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_SHAMT_X1),
     5, 0, 0, 0, 0, 0,
     create_ShAmt_X1, get_ShAmt_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_Y0),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_SHAMT_Y0),
     5, 0, 0, 0, 0, 0,
     create_ShAmt_Y0, get_ShAmt_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_Y1),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_SHAMT_Y1),
     5, 0, 0, 0, 0, 0,
     create_ShAmt_Y1, get_ShAmt_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     6, 0, 1, 0, 0, 0,
     create_SrcBDest_Y2, get_SrcBDest_Y2
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEPRO_DEST_IMM8_X1),
     8, 1, 0, 0, 0, 0,
     create_Dest_Imm8_X1, get_Dest_Imm8_X1
   },
   {
-    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_SN_BROFF),
-    10, 1, 0, 0, 1, TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES,
+    TILEPRO_OP_TYPE_ADDRESS, BFD_RELOC(NONE),
+    10, 1, 0, 0, 1, TILEPRO_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES,
     create_BrOff_SN, get_BrOff_SN
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SN_UIMM8),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
     8, 0, 0, 0, 0, 0,
     create_Imm8_SN, get_Imm8_SN
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SN_IMM8),
+    TILEPRO_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
     8, 1, 0, 0, 0, 0,
     create_Imm8_SN, get_Imm8_SN
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     2, 0, 0, 1, 0, 0,
     create_Dest_SN, get_Dest_SN
   },
   {
-    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    TILEPRO_OP_TYPE_REGISTER, BFD_RELOC(NONE),
     2, 0, 1, 0, 0, 0,
     create_Src_SN, get_Src_SN
   }
@@ -2416,10 +2522,10 @@ const struct tile_operand tile_operands[43] =
 /* Given a set of bundle bits and a specific pipe, returns which
  * instruction the bundle contains in that pipe.
  */
-const struct tile_opcode *
-find_opcode(tile_bundle_bits bits, tile_pipeline pipe)
+const struct tilepro_opcode *
+find_opcode(tilepro_bundle_bits bits, tilepro_pipeline pipe)
 {
-  const unsigned short *table = tile_bundle_decoder_fsms[pipe];
+  const unsigned short *table = tilepro_bundle_decoder_fsms[pipe];
   int index = 0;
 
   while (1)
@@ -2429,51 +2535,51 @@ find_opcode(tile_bundle_bits bits, tile_pipeline pipe)
       ((unsigned int)(bits >> (bitspec & 63))) & (bitspec >> 6);
 
     unsigned short next = table[index + 1 + bitfield];
-    if (next <= TILE_OPC_NONE)
-      return &tile_opcodes[next];
+    if (next <= TILEPRO_OPC_NONE)
+      return &tilepro_opcodes[next];
 
-    index = next - TILE_OPC_NONE;
+    index = next - TILEPRO_OPC_NONE;
   }
 }
 
 
 int
-parse_insn_tile(tile_bundle_bits bits,
-                unsigned int pc,
-                struct tile_decoded_instruction
-                decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE])
+parse_insn_tilepro(tilepro_bundle_bits bits,
+                   unsigned int pc,
+                   struct tilepro_decoded_instruction
+                   decoded[TILEPRO_MAX_INSTRUCTIONS_PER_BUNDLE])
 {
   int num_instructions = 0;
   int pipe;
 
   int min_pipe, max_pipe;
-  if ((bits & TILE_BUNDLE_Y_ENCODING_MASK) == 0)
+  if ((bits & TILEPRO_BUNDLE_Y_ENCODING_MASK) == 0)
   {
-    min_pipe = TILE_PIPELINE_X0;
-    max_pipe = TILE_PIPELINE_X1;
+    min_pipe = TILEPRO_PIPELINE_X0;
+    max_pipe = TILEPRO_PIPELINE_X1;
   }
   else
   {
-    min_pipe = TILE_PIPELINE_Y0;
-    max_pipe = TILE_PIPELINE_Y2;
+    min_pipe = TILEPRO_PIPELINE_Y0;
+    max_pipe = TILEPRO_PIPELINE_Y2;
   }
 
   /* For each pipe, find an instruction that fits. */
   for (pipe = min_pipe; pipe <= max_pipe; pipe++)
   {
-    const struct tile_opcode *opc;
-    struct tile_decoded_instruction *d;
+    const struct tilepro_opcode *opc;
+    struct tilepro_decoded_instruction *d;
     int i;
 
     d = &decoded[num_instructions++];
-    opc = find_opcode (bits, (tile_pipeline)pipe);
+    opc = find_opcode (bits, (tilepro_pipeline)pipe);
     d->opcode = opc;
 
     /* Decode each operand, sign extending, etc. as appropriate. */
     for (i = 0; i < opc->num_operands; i++)
     {
-      const struct tile_operand *op =
-        &tile_operands[opc->operands[pipe][i]];
+      const struct tilepro_operand *op =
+        &tilepro_operands[opc->operands[pipe][i]];
       int opval = op->extract (bits);
       if (op->is_signed)
       {
@@ -2483,9 +2589,9 @@ parse_insn_tile(tile_bundle_bits bits,
       }
 
       /* Adjust PC-relative scaled branch offsets. */
-      if (op->type == TILE_OP_TYPE_ADDRESS)
+      if (op->type == TILEPRO_OP_TYPE_ADDRESS)
       {
-        opval *= TILE_BUNDLE_SIZE_IN_BYTES;
+        opval *= TILEPRO_BUNDLE_SIZE_IN_BYTES;
         opval += (int)pc;
       }
 
diff --git a/arch/tile/kernel/tile-desc_64.c b/arch/tile/kernel/tile-desc_64.c
index d57007b..65b5f8a 100644
--- a/arch/tile/kernel/tile-desc_64.c
+++ b/arch/tile/kernel/tile-desc_64.c
@@ -1,3 +1,23 @@
+/* TILE-Gx opcode information.
+ *
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ *
+ *
+ *
+ *
+ */
+
 /* This define is BFD_RELOC_##x for real bfd, or -1 for everyone else. */
 #define BFD_RELOC(x) -1
 
@@ -6,10 +26,8 @@
 #define TREG_SN 56
 #define TREG_ZERO 63
 
-/* FIXME: Rename this. */
-#include <asm/opcode-tile_64.h>
-
 #include <linux/stddef.h>
+#include <asm/tile-desc.h>
 
 const struct tilegx_opcode tilegx_opcodes[334] =
 {
@@ -2040,12 +2058,12 @@ const struct tilegx_operand tilegx_operands[35] =
     create_BrOff_X1, get_BrOff_X1
   },
   {
-    TILEGX_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
+    TILEGX_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEGX_MMSTART_X0),
     6, 0, 0, 0, 0, 0,
     create_BFStart_X0, get_BFStart_X0
   },
   {
-    TILEGX_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
+    TILEGX_OP_TYPE_IMMEDIATE, BFD_RELOC(TILEGX_MMEND_X0),
     6, 0, 0, 0, 0, 0,
     create_BFEnd_X0, get_BFEnd_X0
   },
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index f9803df..4f47b8a 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -19,13 +19,12 @@
 #include <linux/reboot.h>
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
-#include <asm/opcode-tile.h>
-#include <asm/opcode_constants.h>
 #include <asm/stack.h>
 #include <asm/traps.h>
 
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
+#include <arch/opcode.h>
 
 void __init trap_init(void)
 {
@@ -135,7 +134,7 @@ static int special_ill(bundle_bits bundle, int *sigp, int *codep)
 	if (get_UnaryOpcodeExtension_X1(bundle) != ILL_UNARY_OPCODE_X1)
 		return 0;
 #else
-	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK)
+	if (bundle & TILEPRO_BUNDLE_Y_ENCODING_MASK)
 		return 0;
 	if (get_Opcode_X1(bundle) != SHUN_0_OPCODE_X1)
 		return 0;
-- 
1.6.5.2

