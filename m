Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0FYVLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:11:09 -0400
Received: from king.tilera.com ([72.1.168.226]:44209 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab0FYVK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:10:59 -0400
Message-Id: <201006252110.o5PLArSJ010771@farm-0002.internal.tilera.com>
To: linux-kernel@vger.kernel.org
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Jun 2010 17:02:05 -0400
Subject: [PATCH] arch/tile: Shrink the tile-opcode files considerably.
X-OriginalArrivalTime: 25 Jun 2010 21:10:53.0501 (UTC) FILETIME=[E5591ED0:01CB14AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C file (tile-desc_{32,64}.c) was about 300KB before this change,
and is now shrunk down to 100K.  The original file included support
for BFD in the binutils toolchain, which is not necessary in the
kernel; the kernel version only needs to include enough support to
enable the single-stepper and backtracer.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/opcode-tile_32.h |   93 +-
 arch/tile/include/asm/opcode-tile_64.h |   93 +-
 arch/tile/kernel/tile-desc_32.c        |14144 ++++----------------------------
 3 files changed, 1410 insertions(+), 12920 deletions(-)

diff --git a/arch/tile/include/asm/opcode-tile_32.h b/arch/tile/include/asm/opcode-tile_32.h
index 90f8dd3..eda60ec 100644
--- a/arch/tile/include/asm/opcode-tile_32.h
+++ b/arch/tile/include/asm/opcode-tile_32.h
@@ -28,6 +28,7 @@ typedef enum
   TILE_OPC_MOVELI_SN,
   TILE_OPC_MOVELIS,
   TILE_OPC_PREFETCH,
+  TILE_OPC_RAISE,
   TILE_OPC_ADD,
   TILE_OPC_ADD_SN,
   TILE_OPC_ADDB,
@@ -419,43 +420,6 @@ typedef enum
 
 #define TILE_ELF_NAME "elf32-tilepro"
 
-enum
-{
-  TILE_SN_MAX_OPERANDS = 6 /* route */
-};
-
-typedef enum
-{
-  TILE_SN_OPC_BZ,
-  TILE_SN_OPC_BNZ,
-  TILE_SN_OPC_JRR,
-  TILE_SN_OPC_FNOP,
-  TILE_SN_OPC_BLZ,
-  TILE_SN_OPC_NOP,
-  TILE_SN_OPC_MOVEI,
-  TILE_SN_OPC_MOVE,
-  TILE_SN_OPC_BGEZ,
-  TILE_SN_OPC_JR,
-  TILE_SN_OPC_BLEZ,
-  TILE_SN_OPC_BBNS,
-  TILE_SN_OPC_JALRR,
-  TILE_SN_OPC_BPT,
-  TILE_SN_OPC_JALR,
-  TILE_SN_OPC_SHR1,
-  TILE_SN_OPC_BGZ,
-  TILE_SN_OPC_BBS,
-  TILE_SN_OPC_SHL8II,
-  TILE_SN_OPC_ADDI,
-  TILE_SN_OPC_HALT,
-  TILE_SN_OPC_ROUTE,
-  TILE_SN_OPC_NONE
-} tile_sn_mnemonic;
-
-extern const unsigned char tile_sn_route_encode[6 * 6 * 6];
-extern const signed char tile_sn_route_decode[256][3];
-extern const char tile_sn_direction_names[6][5];
-extern const signed char tile_sn_dest_map[6][6];
-
 
 static __inline unsigned int
 get_BrOff_SN(tile_bundle_bits num)
@@ -1387,8 +1351,6 @@ create_UnShOpcodeExtension_Y1(int num)
 }
 
 
-typedef unsigned short tile_sn_instruction_bits;
-
 
 typedef enum
 {
@@ -1519,41 +1481,10 @@ struct tile_opcode
    * index into the tile_operands[] table. */
   unsigned char operands[TILE_NUM_PIPELINE_ENCODINGS][TILE_MAX_OPERANDS];
 
-  /* A mask of which bits have predefined values for each pipeline.
-   * This is useful for disassembly. */
-  tile_bundle_bits fixed_bit_masks[TILE_NUM_PIPELINE_ENCODINGS];
-
-  /* For each bit set in fixed_bit_masks, what the value is for this
-   * instruction. */
-  tile_bundle_bits fixed_bit_values[TILE_NUM_PIPELINE_ENCODINGS];
 };
 
 extern const struct tile_opcode tile_opcodes[];
 
-struct tile_sn_opcode
-{
-  /* The opcode mnemonic, e.g. "add" */
-  const char *name;
-
-  /* The enum value for this mnemonic. */
-  tile_sn_mnemonic mnemonic;
-
-  /* How many operands are there? */
-  unsigned char num_operands;
-
-  /* The description of the operands. Each of these is an
-   * index into the tile_operands[] table. */
-  unsigned char operands[TILE_SN_MAX_OPERANDS];
-
-  /* A mask of which bits have predefined values.
-   * This is useful for disassembly. */
-  tile_sn_instruction_bits fixed_bit_mask;
-
-  /* For each bit set in fixed_bit_masks, what its value is. */
-  tile_sn_instruction_bits fixed_bit_values;
-};
-
-extern const struct tile_sn_opcode tile_sn_opcodes[];
 
 /* Used for non-textual disassembly into structs. */
 struct tile_decoded_instruction
@@ -1571,27 +1502,5 @@ extern int parse_insn_tile(tile_bundle_bits bits,
                            decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
 
 
-/* Canonical names of all the registers. */
-/* ISSUE: This table lives in "tile-dis.c" */
-extern const char * const tile_register_names[];
-
-/* Descriptor for a special-purpose register. */
-struct tile_spr
-{
-  /* The number */
-  int number;
-
-  /* The name */
-  const char *name;
-};
-
-/* List of all the SPRs; ordered by increasing number. */
-extern const struct tile_spr tile_sprs[];
-
-/* Number of special-purpose registers. */
-extern const int tile_num_sprs;
-
-extern const char *
-get_tile_spr_name (int num);
 
 #endif /* opcode_tile_h */
diff --git a/arch/tile/include/asm/opcode-tile_64.h b/arch/tile/include/asm/opcode-tile_64.h
index 90f8dd3..eda60ec 100644
--- a/arch/tile/include/asm/opcode-tile_64.h
+++ b/arch/tile/include/asm/opcode-tile_64.h
@@ -28,6 +28,7 @@ typedef enum
   TILE_OPC_MOVELI_SN,
   TILE_OPC_MOVELIS,
   TILE_OPC_PREFETCH,
+  TILE_OPC_RAISE,
   TILE_OPC_ADD,
   TILE_OPC_ADD_SN,
   TILE_OPC_ADDB,
@@ -419,43 +420,6 @@ typedef enum
 
 #define TILE_ELF_NAME "elf32-tilepro"
 
-enum
-{
-  TILE_SN_MAX_OPERANDS = 6 /* route */
-};
-
-typedef enum
-{
-  TILE_SN_OPC_BZ,
-  TILE_SN_OPC_BNZ,
-  TILE_SN_OPC_JRR,
-  TILE_SN_OPC_FNOP,
-  TILE_SN_OPC_BLZ,
-  TILE_SN_OPC_NOP,
-  TILE_SN_OPC_MOVEI,
-  TILE_SN_OPC_MOVE,
-  TILE_SN_OPC_BGEZ,
-  TILE_SN_OPC_JR,
-  TILE_SN_OPC_BLEZ,
-  TILE_SN_OPC_BBNS,
-  TILE_SN_OPC_JALRR,
-  TILE_SN_OPC_BPT,
-  TILE_SN_OPC_JALR,
-  TILE_SN_OPC_SHR1,
-  TILE_SN_OPC_BGZ,
-  TILE_SN_OPC_BBS,
-  TILE_SN_OPC_SHL8II,
-  TILE_SN_OPC_ADDI,
-  TILE_SN_OPC_HALT,
-  TILE_SN_OPC_ROUTE,
-  TILE_SN_OPC_NONE
-} tile_sn_mnemonic;
-
-extern const unsigned char tile_sn_route_encode[6 * 6 * 6];
-extern const signed char tile_sn_route_decode[256][3];
-extern const char tile_sn_direction_names[6][5];
-extern const signed char tile_sn_dest_map[6][6];
-
 
 static __inline unsigned int
 get_BrOff_SN(tile_bundle_bits num)
@@ -1387,8 +1351,6 @@ create_UnShOpcodeExtension_Y1(int num)
 }
 
 
-typedef unsigned short tile_sn_instruction_bits;
-
 
 typedef enum
 {
@@ -1519,41 +1481,10 @@ struct tile_opcode
    * index into the tile_operands[] table. */
   unsigned char operands[TILE_NUM_PIPELINE_ENCODINGS][TILE_MAX_OPERANDS];
 
-  /* A mask of which bits have predefined values for each pipeline.
-   * This is useful for disassembly. */
-  tile_bundle_bits fixed_bit_masks[TILE_NUM_PIPELINE_ENCODINGS];
-
-  /* For each bit set in fixed_bit_masks, what the value is for this
-   * instruction. */
-  tile_bundle_bits fixed_bit_values[TILE_NUM_PIPELINE_ENCODINGS];
 };
 
 extern const struct tile_opcode tile_opcodes[];
 
-struct tile_sn_opcode
-{
-  /* The opcode mnemonic, e.g. "add" */
-  const char *name;
-
-  /* The enum value for this mnemonic. */
-  tile_sn_mnemonic mnemonic;
-
-  /* How many operands are there? */
-  unsigned char num_operands;
-
-  /* The description of the operands. Each of these is an
-   * index into the tile_operands[] table. */
-  unsigned char operands[TILE_SN_MAX_OPERANDS];
-
-  /* A mask of which bits have predefined values.
-   * This is useful for disassembly. */
-  tile_sn_instruction_bits fixed_bit_mask;
-
-  /* For each bit set in fixed_bit_masks, what its value is. */
-  tile_sn_instruction_bits fixed_bit_values;
-};
-
-extern const struct tile_sn_opcode tile_sn_opcodes[];
 
 /* Used for non-textual disassembly into structs. */
 struct tile_decoded_instruction
@@ -1571,27 +1502,5 @@ extern int parse_insn_tile(tile_bundle_bits bits,
                            decoded[TILE_MAX_INSTRUCTIONS_PER_BUNDLE]);
 
 
-/* Canonical names of all the registers. */
-/* ISSUE: This table lives in "tile-dis.c" */
-extern const char * const tile_register_names[];
-
-/* Descriptor for a special-purpose register. */
-struct tile_spr
-{
-  /* The number */
-  int number;
-
-  /* The name */
-  const char *name;
-};
-
-/* List of all the SPRs; ordered by increasing number. */
-extern const struct tile_spr tile_sprs[];
-
-/* Number of special-purpose registers. */
-extern const int tile_num_sprs;
-
-extern const char *
-get_tile_spr_name (int num);
 
 #endif /* opcode_tile_h */
diff --git a/arch/tile/kernel/tile-desc_32.c b/arch/tile/kernel/tile-desc_32.c
index 3b78369..69af0e1 100644
--- a/arch/tile/kernel/tile-desc_32.c
+++ b/arch/tile/kernel/tile-desc_32.c
@@ -1,12 +1,5 @@
-/* Define to include "bfd.h" and get actual BFD relocations below. */
-/* #define WANT_BFD_RELOCS */
-
-#ifdef WANT_BFD_RELOCS
-#include "bfd.h"
-#define MAYBE_BFD_RELOC(X) (X)
-#else
-#define MAYBE_BFD_RELOC(X) -1
-#endif
+/* This define is BFD_RELOC_##x for real bfd, or -1 for everyone else. */
+#define BFD_RELOC(x) -1
 
 /* Special registers. */
 #define TREG_LR 55
@@ -16,11014 +9,1193 @@
 /* FIXME: Rename this. */
 #include <asm/opcode-tile.h>
 
+#include <linux/stddef.h>
 
-const struct tile_opcode tile_opcodes[394] =
+const struct tile_opcode tile_opcodes[395] =
 {
- { "bpt", TILE_OPC_BPT, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbffffff80000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b3cae00000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+ { "bpt", TILE_OPC_BPT, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "info", TILE_OPC_INFO, 0xf /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0 },
-      { 1 },
-      { 2 },
-      { 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00fffULL,
-      0xfff807ff80000000ULL,
-      0x8000000078000fffULL,
-      0xf80007ff80000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000050100fffULL,
-      0x302007ff80000000ULL,
-      0x8000000050000fffULL,
-      0xc00007ff80000000ULL,
-      -1ULL
-    }
+  { "info", TILE_OPC_INFO, 0xf, 1, TREG_ZERO, 1,
+    { { 0 }, { 1 }, { 2 }, { 3 }, { 0, } },
   },
-  { "infol", TILE_OPC_INFOL, 0x3 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 4 },
-      { 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000fffULL,
-      0xf80007ff80000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000030000fffULL,
-      0x200007ff80000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "infol", TILE_OPC_INFOL, 0x3, 1, TREG_ZERO, 1,
+    { { 4 }, { 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "j", TILE_OPC_J, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 6 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf000000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x5000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "j", TILE_OPC_J, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 6 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jal", TILE_OPC_JAL, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_LR, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 6 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf000000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x6000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jal", TILE_OPC_JAL, 0x2, 1, TREG_LR, 1,
+    { { 0, }, { 6 }, { 0, }, { 0, }, { 0, } },
   },
-  { "move", TILE_OPC_MOVE, 0xf /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 9, 10 },
-      { 11, 12 },
-      { 13, 14 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0xfffff80000000000ULL,
-      0x80000000780ff000ULL,
-      0xf807f80000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000cff000ULL,
-      0x0833f80000000000ULL,
-      0x80000000180bf000ULL,
-      0x9805f80000000000ULL,
-      -1ULL
-    }
+  { "move", TILE_OPC_MOVE, 0xf, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 9, 10 }, { 11, 12 }, { 13, 14 }, { 0, } },
   },
-  { "move.sn", TILE_OPC_MOVE_SN, 0x3 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008cff000ULL,
-      0x0c33f80000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "move.sn", TILE_OPC_MOVE_SN, 0x3, 2, TREG_SN, 1,
+    { { 7, 8 }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "movei", TILE_OPC_MOVEI, 0xf /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 0 },
-      { 9, 1 },
-      { 11, 2 },
-      { 13, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00fc0ULL,
-      0xfff807e000000000ULL,
-      0x8000000078000fc0ULL,
-      0xf80007e000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040800fc0ULL,
-      0x305807e000000000ULL,
-      0x8000000058000fc0ULL,
-      0xc80007e000000000ULL,
-      -1ULL
-    }
+  { "movei", TILE_OPC_MOVEI, 0xf, 2, TREG_ZERO, 1,
+    { { 7, 0 }, { 9, 1 }, { 11, 2 }, { 13, 3 }, { 0, } },
   },
-  { "movei.sn", TILE_OPC_MOVEI_SN, 0x3 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 0 },
-      { 9, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00fc0ULL,
-      0xfff807e000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048800fc0ULL,
-      0x345807e000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "movei.sn", TILE_OPC_MOVEI_SN, 0x3, 2, TREG_SN, 1,
+    { { 7, 0 }, { 9, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "moveli", TILE_OPC_MOVELI, 0x3 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 4 },
-      { 9, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000fc0ULL,
-      0xf80007e000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000020000fc0ULL,
-      0x180007e000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "moveli", TILE_OPC_MOVELI, 0x3, 2, TREG_ZERO, 1,
+    { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "moveli.sn", TILE_OPC_MOVELI_SN, 0x3 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 4 },
-      { 9, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000fc0ULL,
-      0xf80007e000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000010000fc0ULL,
-      0x100007e000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "moveli.sn", TILE_OPC_MOVELI_SN, 0x3, 2, TREG_SN, 1,
+    { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "movelis", TILE_OPC_MOVELIS, 0x3 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 4 },
-      { 9, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000fc0ULL,
-      0xf80007e000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000010000fc0ULL,
-      0x100007e000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "movelis", TILE_OPC_MOVELIS, 0x3, 2, TREG_SN, 1,
+    { { 7, 4 }, { 9, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "prefetch", TILE_OPC_PREFETCH, 0x12 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff81f80000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000003f00000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b501f80000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8000000003f00000ULL
-    }
+  { "prefetch", TILE_OPC_PREFETCH, 0x12, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 15 } },
   },
-  { "add", TILE_OPC_ADD, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000000c0000ULL,
-      0x0806000000000000ULL,
-      0x8000000008000000ULL,
-      0x8800000000000000ULL,
-      -1ULL
-    }
+  { "raise", TILE_OPC_RAISE, 0x2, 0, TREG_ZERO, 1,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "add.sn", TILE_OPC_ADD_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000080c0000ULL,
-      0x0c06000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "add", TILE_OPC_ADD, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "addb", TILE_OPC_ADDB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000040000ULL,
-      0x0802000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "add.sn", TILE_OPC_ADD_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addb.sn", TILE_OPC_ADDB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008040000ULL,
-      0x0c02000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addb", TILE_OPC_ADDB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addbs_u", TILE_OPC_ADDBS_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001880000ULL,
-      0x0888000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addb.sn", TILE_OPC_ADDB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addbs_u.sn", TILE_OPC_ADDBS_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009880000ULL,
-      0x0c88000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addbs_u", TILE_OPC_ADDBS_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addh", TILE_OPC_ADDH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000080000ULL,
-      0x0804000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addbs_u.sn", TILE_OPC_ADDBS_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addh.sn", TILE_OPC_ADDH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008080000ULL,
-      0x0c04000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addh", TILE_OPC_ADDH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addhs", TILE_OPC_ADDHS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000018c0000ULL,
-      0x088a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addh.sn", TILE_OPC_ADDH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addhs.sn", TILE_OPC_ADDHS_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000098c0000ULL,
-      0x0c8a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addhs", TILE_OPC_ADDHS, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addi", TILE_OPC_ADDI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040300000ULL,
-      0x3018000000000000ULL,
-      0x8000000048000000ULL,
-      0xb800000000000000ULL,
-      -1ULL
-    }
+  { "addhs.sn", TILE_OPC_ADDHS_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addi.sn", TILE_OPC_ADDI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048300000ULL,
-      0x3418000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addi", TILE_OPC_ADDI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "addib", TILE_OPC_ADDIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040100000ULL,
-      0x3008000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addi.sn", TILE_OPC_ADDI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addib.sn", TILE_OPC_ADDIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048100000ULL,
-      0x3408000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addib", TILE_OPC_ADDIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addih", TILE_OPC_ADDIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040200000ULL,
-      0x3010000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addib.sn", TILE_OPC_ADDIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addih.sn", TILE_OPC_ADDIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048200000ULL,
-      0x3410000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addih", TILE_OPC_ADDIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addli", TILE_OPC_ADDLI, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 4 },
-      { 9, 10, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000000ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000020000000ULL,
-      0x1800000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addih.sn", TILE_OPC_ADDIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addli.sn", TILE_OPC_ADDLI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 4 },
-      { 9, 10, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000000ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000010000000ULL,
-      0x1000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addli", TILE_OPC_ADDLI, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "addlis", TILE_OPC_ADDLIS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 4 },
-      { 9, 10, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000000ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000010000000ULL,
-      0x1000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addli.sn", TILE_OPC_ADDLI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adds", TILE_OPC_ADDS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001800000ULL,
-      0x0884000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "addlis", TILE_OPC_ADDLIS, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adds.sn", TILE_OPC_ADDS_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009800000ULL,
-      0x0c84000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "adds", TILE_OPC_ADDS, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffb_u", TILE_OPC_ADIFFB_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000100000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "adds.sn", TILE_OPC_ADDS_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffb_u.sn", TILE_OPC_ADIFFB_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008100000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "adiffb_u", TILE_OPC_ADIFFB_U, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffh", TILE_OPC_ADIFFH, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000140000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "adiffb_u.sn", TILE_OPC_ADIFFB_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "adiffh.sn", TILE_OPC_ADIFFH_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008140000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "adiffh", TILE_OPC_ADIFFH, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "and", TILE_OPC_AND, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000180000ULL,
-      0x0808000000000000ULL,
-      0x8000000018000000ULL,
-      0x9800000000000000ULL,
-      -1ULL
-    }
+  { "adiffh.sn", TILE_OPC_ADIFFH_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "and.sn", TILE_OPC_AND_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008180000ULL,
-      0x0c08000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "and", TILE_OPC_AND, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "andi", TILE_OPC_ANDI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000050100000ULL,
-      0x3020000000000000ULL,
-      0x8000000050000000ULL,
-      0xc000000000000000ULL,
-      -1ULL
-    }
+  { "and.sn", TILE_OPC_AND_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "andi.sn", TILE_OPC_ANDI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000058100000ULL,
-      0x3420000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "andi", TILE_OPC_ANDI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "auli", TILE_OPC_AULI, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 4 },
-      { 9, 10, 5 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000000ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000030000000ULL,
-      0x2000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "andi.sn", TILE_OPC_ANDI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgb_u", TILE_OPC_AVGB_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000001c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "auli", TILE_OPC_AULI, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 4 }, { 9, 10, 5 }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgb_u.sn", TILE_OPC_AVGB_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000081c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "avgb_u", TILE_OPC_AVGB_U, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgh", TILE_OPC_AVGH, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000200000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "avgb_u.sn", TILE_OPC_AVGB_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "avgh.sn", TILE_OPC_AVGH_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008200000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "avgh", TILE_OPC_AVGH, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbns", TILE_OPC_BBNS, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000700000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "avgh.sn", TILE_OPC_AVGH_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbns.sn", TILE_OPC_BBNS_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000700000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbns", TILE_OPC_BBNS, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbnst", TILE_OPC_BBNST, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000780000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbns.sn", TILE_OPC_BBNS_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbnst.sn", TILE_OPC_BBNST_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000780000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbnst", TILE_OPC_BBNST, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbs", TILE_OPC_BBS, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000600000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbnst.sn", TILE_OPC_BBNST_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbs.sn", TILE_OPC_BBS_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000600000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbs", TILE_OPC_BBS, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbst", TILE_OPC_BBST, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000680000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbs.sn", TILE_OPC_BBS_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bbst.sn", TILE_OPC_BBST_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000680000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbst", TILE_OPC_BBST, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgez", TILE_OPC_BGEZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000300000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bbst.sn", TILE_OPC_BBST_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgez.sn", TILE_OPC_BGEZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000300000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgez", TILE_OPC_BGEZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgezt", TILE_OPC_BGEZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000380000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgez.sn", TILE_OPC_BGEZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgezt.sn", TILE_OPC_BGEZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000380000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgezt", TILE_OPC_BGEZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgz", TILE_OPC_BGZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000200000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgezt.sn", TILE_OPC_BGEZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgz.sn", TILE_OPC_BGZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000200000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgz", TILE_OPC_BGZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgzt", TILE_OPC_BGZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000280000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgz.sn", TILE_OPC_BGZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bgzt.sn", TILE_OPC_BGZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000280000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgzt", TILE_OPC_BGZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bitx", TILE_OPC_BITX, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 11, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070161000ULL,
-      -1ULL,
-      0x80000000680a1000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bgzt.sn", TILE_OPC_BGZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bitx.sn", TILE_OPC_BITX_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078161000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bitx", TILE_OPC_BITX, 0x5, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "blez", TILE_OPC_BLEZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000500000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bitx.sn", TILE_OPC_BITX_SN, 0x1, 2, TREG_SN, 1,
+    { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "blez.sn", TILE_OPC_BLEZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000500000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blez", TILE_OPC_BLEZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blezt", TILE_OPC_BLEZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000580000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blez.sn", TILE_OPC_BLEZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blezt.sn", TILE_OPC_BLEZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000580000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blezt", TILE_OPC_BLEZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blz", TILE_OPC_BLZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000400000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blezt.sn", TILE_OPC_BLEZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blz.sn", TILE_OPC_BLZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000400000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blz", TILE_OPC_BLZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blzt", TILE_OPC_BLZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000480000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blz.sn", TILE_OPC_BLZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "blzt.sn", TILE_OPC_BLZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000480000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blzt", TILE_OPC_BLZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnz", TILE_OPC_BNZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000100000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "blzt.sn", TILE_OPC_BLZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnz.sn", TILE_OPC_BNZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000100000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bnz", TILE_OPC_BNZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnzt", TILE_OPC_BNZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000180000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bnz.sn", TILE_OPC_BNZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bnzt.sn", TILE_OPC_BNZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000180000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bnzt", TILE_OPC_BNZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bytex", TILE_OPC_BYTEX, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 11, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070162000ULL,
-      -1ULL,
-      0x80000000680a2000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bnzt.sn", TILE_OPC_BNZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bytex.sn", TILE_OPC_BYTEX_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078162000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bytex", TILE_OPC_BYTEX, 0x5, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "bz", TILE_OPC_BZ, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bytex.sn", TILE_OPC_BYTEX_SN, 0x1, 2, TREG_SN, 1,
+    { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "bz.sn", TILE_OPC_BZ_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bz", TILE_OPC_BZ, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bzt", TILE_OPC_BZT, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2800000080000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bz.sn", TILE_OPC_BZ_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "bzt.sn", TILE_OPC_BZT_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 20 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfc00000780000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x2c00000080000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bzt", TILE_OPC_BZT, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "clz", TILE_OPC_CLZ, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 11, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070163000ULL,
-      -1ULL,
-      0x80000000680a3000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "bzt.sn", TILE_OPC_BZT_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 10, 20 }, { 0, }, { 0, }, { 0, } },
   },
-  { "clz.sn", TILE_OPC_CLZ_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078163000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "clz", TILE_OPC_CLZ, 0x5, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "crc32_32", TILE_OPC_CRC32_32, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000240000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "clz.sn", TILE_OPC_CLZ_SN, 0x1, 2, TREG_SN, 1,
+    { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_32.sn", TILE_OPC_CRC32_32_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008240000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "crc32_32", TILE_OPC_CRC32_32, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_8", TILE_OPC_CRC32_8, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000280000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "crc32_32.sn", TILE_OPC_CRC32_32_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "crc32_8.sn", TILE_OPC_CRC32_8_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008280000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "crc32_8", TILE_OPC_CRC32_8, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "ctz", TILE_OPC_CTZ, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 11, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070164000ULL,
-      -1ULL,
-      0x80000000680a4000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "crc32_8.sn", TILE_OPC_CRC32_8_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "ctz.sn", TILE_OPC_CTZ_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078164000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "ctz", TILE_OPC_CTZ, 0x5, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "drain", TILE_OPC_DRAIN, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b080000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "ctz.sn", TILE_OPC_CTZ_SN, 0x1, 2, TREG_SN, 1,
+    { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "dtlbpr", TILE_OPC_DTLBPR, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b100000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "drain", TILE_OPC_DRAIN, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "dword_align", TILE_OPC_DWORD_ALIGN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000017c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "dtlbpr", TILE_OPC_DTLBPR, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "dword_align.sn", TILE_OPC_DWORD_ALIGN_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000097c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "dword_align", TILE_OPC_DWORD_ALIGN, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "finv", TILE_OPC_FINV, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b180000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "dword_align.sn", TILE_OPC_DWORD_ALIGN_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "flush", TILE_OPC_FLUSH, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b200000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "finv", TILE_OPC_FINV, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "fnop", TILE_OPC_FNOP, 0xf /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      {  },
-      {  },
-      {  },
-      {  },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000077fff000ULL,
-      0xfbfff80000000000ULL,
-      0x80000000780ff000ULL,
-      0xf807f80000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070165000ULL,
-      0x400b280000000000ULL,
-      0x80000000680a5000ULL,
-      0xd805080000000000ULL,
-      -1ULL
-    }
+  { "flush", TILE_OPC_FLUSH, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "icoh", TILE_OPC_ICOH, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b300000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "fnop", TILE_OPC_FNOP, 0xf, 0, TREG_ZERO, 1,
+    { {  }, {  }, {  }, {  }, { 0, } },
   },
-  { "ill", TILE_OPC_ILL, 0xa /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      {  },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0xf807f80000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b380000000000ULL,
-      -1ULL,
-      0xd805100000000000ULL,
-      -1ULL
-    }
+  { "icoh", TILE_OPC_ICOH, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthb", TILE_OPC_INTHB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000002c0000ULL,
-      0x080a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "ill", TILE_OPC_ILL, 0xa, 0, TREG_ZERO, 1,
+    { { 0, }, {  }, { 0, }, {  }, { 0, } },
   },
-  { "inthb.sn", TILE_OPC_INTHB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000082c0000ULL,
-      0x0c0a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "inthb", TILE_OPC_INTHB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthh", TILE_OPC_INTHH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000300000ULL,
-      0x080c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "inthb.sn", TILE_OPC_INTHB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inthh.sn", TILE_OPC_INTHH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008300000ULL,
-      0x0c0c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "inthh", TILE_OPC_INTHH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlb", TILE_OPC_INTLB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000340000ULL,
-      0x080e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "inthh.sn", TILE_OPC_INTHH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlb.sn", TILE_OPC_INTLB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008340000ULL,
-      0x0c0e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "intlb", TILE_OPC_INTLB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlh", TILE_OPC_INTLH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000380000ULL,
-      0x0810000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "intlb.sn", TILE_OPC_INTLB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "intlh.sn", TILE_OPC_INTLH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008380000ULL,
-      0x0c10000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "intlh", TILE_OPC_INTLH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "inv", TILE_OPC_INV, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b400000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "intlh.sn", TILE_OPC_INTLH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "iret", TILE_OPC_IRET, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b480000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "inv", TILE_OPC_INV, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalb", TILE_OPC_JALB, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_LR, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 22 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x6800000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "iret", TILE_OPC_IRET, 0x2, 0, TREG_ZERO, 1,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalf", TILE_OPC_JALF, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_LR, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 22 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x6000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jalb", TILE_OPC_JALB, 0x2, 1, TREG_LR, 1,
+    { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalr", TILE_OPC_JALR, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_LR, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0814000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jalf", TILE_OPC_JALF, 0x2, 1, TREG_LR, 1,
+    { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jalrp", TILE_OPC_JALRP, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_LR, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0812000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jalr", TILE_OPC_JALR, 0x2, 1, TREG_LR, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jb", TILE_OPC_JB, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 22 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x5800000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jalrp", TILE_OPC_JALRP, 0x2, 1, TREG_LR, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jf", TILE_OPC_JF, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 22 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x5000000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jb", TILE_OPC_JB, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jr", TILE_OPC_JR, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0818000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jf", TILE_OPC_JF, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 22 }, { 0, }, { 0, }, { 0, } },
   },
-  { "jrp", TILE_OPC_JRP, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0816000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "jr", TILE_OPC_JR, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lb", TILE_OPC_LB, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 23, 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b500000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8000000000000000ULL
-    }
+  { "jrp", TILE_OPC_JRP, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lb.sn", TILE_OPC_LB_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440b500000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lb", TILE_OPC_LB, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lb_u", TILE_OPC_LB_U, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 23, 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b580000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8100000000000000ULL
-    }
+  { "lb.sn", TILE_OPC_LB_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lb_u.sn", TILE_OPC_LB_U_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440b580000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lb_u", TILE_OPC_LB_U, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lbadd", TILE_OPC_LBADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30b0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lb_u.sn", TILE_OPC_LB_U_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd.sn", TILE_OPC_LBADD_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34b0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lbadd", TILE_OPC_LBADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd_u", TILE_OPC_LBADD_U, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30b8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lbadd.sn", TILE_OPC_LBADD_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lbadd_u.sn", TILE_OPC_LBADD_U_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34b8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lbadd_u", TILE_OPC_LBADD_U, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lh", TILE_OPC_LH, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 23, 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b600000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8200000000000000ULL
-    }
+  { "lbadd_u.sn", TILE_OPC_LBADD_U_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lh.sn", TILE_OPC_LH_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440b600000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lh", TILE_OPC_LH, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lh_u", TILE_OPC_LH_U, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 23, 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b680000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8300000000000000ULL
-    }
+  { "lh.sn", TILE_OPC_LH_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lh_u.sn", TILE_OPC_LH_U_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440b680000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lh_u", TILE_OPC_LH_U, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lhadd", TILE_OPC_LHADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30c0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lh_u.sn", TILE_OPC_LH_U_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd.sn", TILE_OPC_LHADD_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34c0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lhadd", TILE_OPC_LHADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd_u", TILE_OPC_LHADD_U, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30c8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lhadd.sn", TILE_OPC_LHADD_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lhadd_u.sn", TILE_OPC_LHADD_U_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34c8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lhadd_u", TILE_OPC_LHADD_U, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lnk", TILE_OPC_LNK, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x081a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lhadd_u.sn", TILE_OPC_LHADD_U_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lnk.sn", TILE_OPC_LNK_SN, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0c1a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lnk", TILE_OPC_LNK, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 9 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw", TILE_OPC_LW, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 23, 15 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b700000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8400000000000000ULL
-    }
+  { "lnk.sn", TILE_OPC_LNK_SN, 0x2, 1, TREG_SN, 1,
+    { { 0, }, { 9 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw.sn", TILE_OPC_LW_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440b700000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lw", TILE_OPC_LW, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 23, 15 } },
   },
-  { "lw_na", TILE_OPC_LW_NA, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400bc00000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lw.sn", TILE_OPC_LW_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lw_na.sn", TILE_OPC_LW_NA_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440bc00000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lw_na", TILE_OPC_LW_NA, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd", TILE_OPC_LWADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30d0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lw_na.sn", TILE_OPC_LW_NA_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd.sn", TILE_OPC_LWADD_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34d0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lwadd", TILE_OPC_LWADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd_na", TILE_OPC_LWADD_NA, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30d8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lwadd.sn", TILE_OPC_LWADD_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "lwadd_na.sn", TILE_OPC_LWADD_NA_SN, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 24, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x34d8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lwadd_na", TILE_OPC_LWADD_NA, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxb_u", TILE_OPC_MAXB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000003c0000ULL,
-      0x081c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "lwadd_na.sn", TILE_OPC_LWADD_NA_SN, 0x2, 3, TREG_SN, 1,
+    { { 0, }, { 9, 24, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxb_u.sn", TILE_OPC_MAXB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000083c0000ULL,
-      0x0c1c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxb_u", TILE_OPC_MAXB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxh", TILE_OPC_MAXH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000400000ULL,
-      0x081e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxb_u.sn", TILE_OPC_MAXB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxh.sn", TILE_OPC_MAXH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008400000ULL,
-      0x0c1e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxh", TILE_OPC_MAXH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxib_u", TILE_OPC_MAXIB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040400000ULL,
-      0x3028000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxh.sn", TILE_OPC_MAXH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxib_u.sn", TILE_OPC_MAXIB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048400000ULL,
-      0x3428000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxib_u", TILE_OPC_MAXIB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxih", TILE_OPC_MAXIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040500000ULL,
-      0x3030000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxib_u.sn", TILE_OPC_MAXIB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "maxih.sn", TILE_OPC_MAXIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048500000ULL,
-      0x3430000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxih", TILE_OPC_MAXIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mf", TILE_OPC_MF, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b780000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "maxih.sn", TILE_OPC_MAXIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mfspr", TILE_OPC_MFSPR, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 25 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbf8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x3038000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mf", TILE_OPC_MF, 0x2, 0, TREG_ZERO, 1,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "minb_u", TILE_OPC_MINB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000440000ULL,
-      0x0820000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mfspr", TILE_OPC_MFSPR, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 25 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minb_u.sn", TILE_OPC_MINB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008440000ULL,
-      0x0c20000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minb_u", TILE_OPC_MINB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minh", TILE_OPC_MINH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000480000ULL,
-      0x0822000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minb_u.sn", TILE_OPC_MINB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minh.sn", TILE_OPC_MINH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008480000ULL,
-      0x0c22000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minh", TILE_OPC_MINH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minib_u", TILE_OPC_MINIB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040600000ULL,
-      0x3040000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minh.sn", TILE_OPC_MINH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minib_u.sn", TILE_OPC_MINIB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048600000ULL,
-      0x3440000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minib_u", TILE_OPC_MINIB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minih", TILE_OPC_MINIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040700000ULL,
-      0x3048000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minib_u.sn", TILE_OPC_MINIB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "minih.sn", TILE_OPC_MINIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048700000ULL,
-      0x3448000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minih", TILE_OPC_MINIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mm", TILE_OPC_MM, 0x3 /* pipes */, 5 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16, 26, 27 },
-      { 9, 10, 17, 28, 29 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000070000000ULL,
-      0xf800000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000060000000ULL,
-      0x3800000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "minih.sn", TILE_OPC_MINIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnz", TILE_OPC_MNZ, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000540000ULL,
-      0x0828000000000000ULL,
-      0x8000000010000000ULL,
-      0x9002000000000000ULL,
-      -1ULL
-    }
+  { "mm", TILE_OPC_MM, 0x3, 5, TREG_ZERO, 1,
+    { { 7, 8, 16, 26, 27 }, { 9, 10, 17, 28, 29 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnz.sn", TILE_OPC_MNZ_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008540000ULL,
-      0x0c28000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnz", TILE_OPC_MNZ, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "mnzb", TILE_OPC_MNZB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000004c0000ULL,
-      0x0824000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnz.sn", TILE_OPC_MNZ_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzb.sn", TILE_OPC_MNZB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000084c0000ULL,
-      0x0c24000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnzb", TILE_OPC_MNZB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzh", TILE_OPC_MNZH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000500000ULL,
-      0x0826000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnzb.sn", TILE_OPC_MNZB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mnzh.sn", TILE_OPC_MNZH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008500000ULL,
-      0x0c26000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnzh", TILE_OPC_MNZH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mtspr", TILE_OPC_MTSPR, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 30, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbf8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x3050000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mnzh.sn", TILE_OPC_MNZH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_ss", TILE_OPC_MULHH_SS, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 11, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000680000ULL,
-      -1ULL,
-      0x8000000038000000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mtspr", TILE_OPC_MTSPR, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 30, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_ss.sn", TILE_OPC_MULHH_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008680000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_ss", TILE_OPC_MULHH_SS, 0x5, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhh_su", TILE_OPC_MULHH_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000006c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_ss.sn", TILE_OPC_MULHH_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_su.sn", TILE_OPC_MULHH_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000086c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_su", TILE_OPC_MULHH_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_uu", TILE_OPC_MULHH_UU, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 11, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000700000ULL,
-      -1ULL,
-      0x8000000038040000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_su.sn", TILE_OPC_MULHH_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhh_uu.sn", TILE_OPC_MULHH_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008700000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_uu", TILE_OPC_MULHH_UU, 0x5, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhha_ss", TILE_OPC_MULHHA_SS, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000580000ULL,
-      -1ULL,
-      0x8000000040000000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhh_uu.sn", TILE_OPC_MULHH_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_ss.sn", TILE_OPC_MULHHA_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008580000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_ss", TILE_OPC_MULHHA_SS, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhha_su", TILE_OPC_MULHHA_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000005c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_ss.sn", TILE_OPC_MULHHA_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_su.sn", TILE_OPC_MULHHA_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000085c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_su", TILE_OPC_MULHHA_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_uu", TILE_OPC_MULHHA_UU, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000600000ULL,
-      -1ULL,
-      0x8000000040040000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_su.sn", TILE_OPC_MULHHA_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhha_uu.sn", TILE_OPC_MULHHA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008600000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_uu", TILE_OPC_MULHHA_UU, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulhhsa_uu", TILE_OPC_MULHHSA_UU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000640000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhha_uu.sn", TILE_OPC_MULHHA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhhsa_uu.sn", TILE_OPC_MULHHSA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008640000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhhsa_uu", TILE_OPC_MULHHSA_UU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_ss", TILE_OPC_MULHL_SS, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000880000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhhsa_uu.sn", TILE_OPC_MULHHSA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_ss.sn", TILE_OPC_MULHL_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008880000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_ss", TILE_OPC_MULHL_SS, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_su", TILE_OPC_MULHL_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000008c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_ss.sn", TILE_OPC_MULHL_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_su.sn", TILE_OPC_MULHL_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000088c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_su", TILE_OPC_MULHL_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_us", TILE_OPC_MULHL_US, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000900000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_su.sn", TILE_OPC_MULHL_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_us.sn", TILE_OPC_MULHL_US_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008900000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_us", TILE_OPC_MULHL_US, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_uu", TILE_OPC_MULHL_UU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000940000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_us.sn", TILE_OPC_MULHL_US_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhl_uu.sn", TILE_OPC_MULHL_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008940000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_uu", TILE_OPC_MULHL_UU, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_ss", TILE_OPC_MULHLA_SS, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000740000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhl_uu.sn", TILE_OPC_MULHL_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_ss.sn", TILE_OPC_MULHLA_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008740000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_ss", TILE_OPC_MULHLA_SS, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_su", TILE_OPC_MULHLA_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000780000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_ss.sn", TILE_OPC_MULHLA_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_su.sn", TILE_OPC_MULHLA_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008780000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_su", TILE_OPC_MULHLA_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_us", TILE_OPC_MULHLA_US, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000007c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_su.sn", TILE_OPC_MULHLA_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_us.sn", TILE_OPC_MULHLA_US_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000087c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_us", TILE_OPC_MULHLA_US, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_uu", TILE_OPC_MULHLA_UU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000800000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_us.sn", TILE_OPC_MULHLA_US_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhla_uu.sn", TILE_OPC_MULHLA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008800000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_uu", TILE_OPC_MULHLA_UU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhlsa_uu", TILE_OPC_MULHLSA_UU, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000840000ULL,
-      -1ULL,
-      0x8000000030000000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhla_uu.sn", TILE_OPC_MULHLA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulhlsa_uu.sn", TILE_OPC_MULHLSA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008840000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhlsa_uu", TILE_OPC_MULHLSA_UU, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulll_ss", TILE_OPC_MULLL_SS, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 11, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000a80000ULL,
-      -1ULL,
-      0x8000000038080000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulhlsa_uu.sn", TILE_OPC_MULHLSA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_ss.sn", TILE_OPC_MULLL_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008a80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_ss", TILE_OPC_MULLL_SS, 0x5, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulll_su", TILE_OPC_MULLL_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000ac0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_ss.sn", TILE_OPC_MULLL_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_su.sn", TILE_OPC_MULLL_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008ac0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_su", TILE_OPC_MULLL_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_uu", TILE_OPC_MULLL_UU, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 11, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000b00000ULL,
-      -1ULL,
-      0x80000000380c0000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_su.sn", TILE_OPC_MULLL_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulll_uu.sn", TILE_OPC_MULLL_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008b00000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_uu", TILE_OPC_MULLL_UU, 0x5, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 11, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mullla_ss", TILE_OPC_MULLLA_SS, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000980000ULL,
-      -1ULL,
-      0x8000000040080000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulll_uu.sn", TILE_OPC_MULLL_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_ss.sn", TILE_OPC_MULLLA_SS_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008980000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_ss", TILE_OPC_MULLLA_SS, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mullla_su", TILE_OPC_MULLLA_SU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000009c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_ss.sn", TILE_OPC_MULLLA_SS_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_su.sn", TILE_OPC_MULLLA_SU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000089c0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_su", TILE_OPC_MULLLA_SU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_uu", TILE_OPC_MULLLA_UU, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000a00000ULL,
-      -1ULL,
-      0x80000000400c0000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_su.sn", TILE_OPC_MULLLA_SU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mullla_uu.sn", TILE_OPC_MULLLA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008a00000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_uu", TILE_OPC_MULLLA_UU, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mulllsa_uu", TILE_OPC_MULLLSA_UU, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000a40000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mullla_uu.sn", TILE_OPC_MULLLA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mulllsa_uu.sn", TILE_OPC_MULLLSA_UU_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008a40000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulllsa_uu", TILE_OPC_MULLLSA_UU, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mvnz", TILE_OPC_MVNZ, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000b40000ULL,
-      -1ULL,
-      0x8000000010040000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mulllsa_uu.sn", TILE_OPC_MULLLSA_UU_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mvnz.sn", TILE_OPC_MVNZ_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008b40000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mvnz", TILE_OPC_MVNZ, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mvz", TILE_OPC_MVZ, 0x5 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 31, 12, 18 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0x80000000780c0000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000b80000ULL,
-      -1ULL,
-      0x8000000010080000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mvnz.sn", TILE_OPC_MVNZ_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mvz.sn", TILE_OPC_MVZ_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008b80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mvz", TILE_OPC_MVZ, 0x5, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 31, 12, 18 }, { 0, }, { 0, } },
   },
-  { "mz", TILE_OPC_MZ, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000c40000ULL,
-      0x082e000000000000ULL,
-      0x80000000100c0000ULL,
-      0x9004000000000000ULL,
-      -1ULL
-    }
+  { "mvz.sn", TILE_OPC_MVZ_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "mz.sn", TILE_OPC_MZ_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008c40000ULL,
-      0x0c2e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mz", TILE_OPC_MZ, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "mzb", TILE_OPC_MZB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000bc0000ULL,
-      0x082a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mz.sn", TILE_OPC_MZ_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzb.sn", TILE_OPC_MZB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008bc0000ULL,
-      0x0c2a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mzb", TILE_OPC_MZB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzh", TILE_OPC_MZH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000c00000ULL,
-      0x082c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mzb.sn", TILE_OPC_MZB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "mzh.sn", TILE_OPC_MZH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008c00000ULL,
-      0x0c2c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mzh", TILE_OPC_MZH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "nap", TILE_OPC_NAP, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b800000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "mzh.sn", TILE_OPC_MZH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "nop", TILE_OPC_NOP, 0xf /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      {  },
-      {  },
-      {  },
-      {  },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x8000000077fff000ULL,
-      0xfbfff80000000000ULL,
-      0x80000000780ff000ULL,
-      0xf807f80000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070166000ULL,
-      0x400b880000000000ULL,
-      0x80000000680a6000ULL,
-      0xd805180000000000ULL,
-      -1ULL
-    }
+  { "nap", TILE_OPC_NAP, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "nor", TILE_OPC_NOR, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000c80000ULL,
-      0x0830000000000000ULL,
-      0x8000000018040000ULL,
-      0x9802000000000000ULL,
-      -1ULL
-    }
+  { "nop", TILE_OPC_NOP, 0xf, 0, TREG_ZERO, 1,
+    { {  }, {  }, {  }, {  }, { 0, } },
   },
-  { "nor.sn", TILE_OPC_NOR_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008c80000ULL,
-      0x0c30000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "nor", TILE_OPC_NOR, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "or", TILE_OPC_OR, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000cc0000ULL,
-      0x0832000000000000ULL,
-      0x8000000018080000ULL,
-      0x9804000000000000ULL,
-      -1ULL
-    }
+  { "nor.sn", TILE_OPC_NOR_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "or.sn", TILE_OPC_OR_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008cc0000ULL,
-      0x0c32000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "or", TILE_OPC_OR, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "ori", TILE_OPC_ORI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040800000ULL,
-      0x3058000000000000ULL,
-      0x8000000058000000ULL,
-      0xc800000000000000ULL,
-      -1ULL
-    }
+  { "or.sn", TILE_OPC_OR_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "ori.sn", TILE_OPC_ORI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048800000ULL,
-      0x3458000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "ori", TILE_OPC_ORI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "packbs_u", TILE_OPC_PACKBS_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000019c0000ULL,
-      0x0892000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "ori.sn", TILE_OPC_ORI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packbs_u.sn", TILE_OPC_PACKBS_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000099c0000ULL,
-      0x0c92000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packbs_u", TILE_OPC_PACKBS_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhb", TILE_OPC_PACKHB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000d00000ULL,
-      0x0834000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packbs_u.sn", TILE_OPC_PACKBS_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhb.sn", TILE_OPC_PACKHB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008d00000ULL,
-      0x0c34000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packhb", TILE_OPC_PACKHB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhs", TILE_OPC_PACKHS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001980000ULL,
-      0x0890000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packhb.sn", TILE_OPC_PACKHB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packhs.sn", TILE_OPC_PACKHS_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009980000ULL,
-      0x0c90000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packhs", TILE_OPC_PACKHS, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packlb", TILE_OPC_PACKLB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000d40000ULL,
-      0x0836000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packhs.sn", TILE_OPC_PACKHS_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "packlb.sn", TILE_OPC_PACKLB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008d40000ULL,
-      0x0c36000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packlb", TILE_OPC_PACKLB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "pcnt", TILE_OPC_PCNT, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 11, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070167000ULL,
-      -1ULL,
-      0x80000000680a7000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "packlb.sn", TILE_OPC_PACKLB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "pcnt.sn", TILE_OPC_PCNT_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078167000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "pcnt", TILE_OPC_PCNT, 0x5, 2, TREG_ZERO, 1,
+    { { 7, 8 }, { 0, }, { 11, 12 }, { 0, }, { 0, } },
   },
-  { "rl", TILE_OPC_RL, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000d80000ULL,
-      0x0838000000000000ULL,
-      0x8000000020000000ULL,
-      0xa000000000000000ULL,
-      -1ULL
-    }
+  { "pcnt.sn", TILE_OPC_PCNT_SN, 0x1, 2, TREG_SN, 1,
+    { { 7, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "rl.sn", TILE_OPC_RL_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008d80000ULL,
-      0x0c38000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "rl", TILE_OPC_RL, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "rli", TILE_OPC_RLI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 11, 12, 34 },
-      { 13, 14, 35 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0x80000000780e0000ULL,
-      0xf807000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070020000ULL,
-      0x4001000000000000ULL,
-      0x8000000068020000ULL,
-      0xd801000000000000ULL,
-      -1ULL
-    }
+  { "rl.sn", TILE_OPC_RL_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "rli.sn", TILE_OPC_RLI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078020000ULL,
-      0x4401000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "rli", TILE_OPC_RLI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "s1a", TILE_OPC_S1A, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000dc0000ULL,
-      0x083a000000000000ULL,
-      0x8000000008040000ULL,
-      0x8802000000000000ULL,
-      -1ULL
-    }
+  { "rli.sn", TILE_OPC_RLI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s1a.sn", TILE_OPC_S1A_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008dc0000ULL,
-      0x0c3a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "s1a", TILE_OPC_S1A, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "s2a", TILE_OPC_S2A, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000e00000ULL,
-      0x083c000000000000ULL,
-      0x8000000008080000ULL,
-      0x8804000000000000ULL,
-      -1ULL
-    }
+  { "s1a.sn", TILE_OPC_S1A_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s2a.sn", TILE_OPC_S2A_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008e00000ULL,
-      0x0c3c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "s2a", TILE_OPC_S2A, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "s3a", TILE_OPC_S3A, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000e40000ULL,
-      0x083e000000000000ULL,
-      0x8000000030040000ULL,
-      0xb002000000000000ULL,
-      -1ULL
-    }
+  { "s2a.sn", TILE_OPC_S2A_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "s3a.sn", TILE_OPC_S3A_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008e40000ULL,
-      0x0c3e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "s3a", TILE_OPC_S3A, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sadab_u", TILE_OPC_SADAB_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000e80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "s3a.sn", TILE_OPC_S3A_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadab_u.sn", TILE_OPC_SADAB_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008e80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadab_u", TILE_OPC_SADAB_U, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah", TILE_OPC_SADAH, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000ec0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadab_u.sn", TILE_OPC_SADAB_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah.sn", TILE_OPC_SADAH_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008ec0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadah", TILE_OPC_SADAH, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah_u", TILE_OPC_SADAH_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000f00000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadah.sn", TILE_OPC_SADAH_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadah_u.sn", TILE_OPC_SADAH_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008f00000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadah_u", TILE_OPC_SADAH_U, 0x1, 3, TREG_ZERO, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadb_u", TILE_OPC_SADB_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000f40000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadah_u.sn", TILE_OPC_SADAH_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 21, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadb_u.sn", TILE_OPC_SADB_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008f40000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadb_u", TILE_OPC_SADB_U, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh", TILE_OPC_SADH, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000f80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadb_u.sn", TILE_OPC_SADB_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh.sn", TILE_OPC_SADH_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008f80000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadh", TILE_OPC_SADH, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh_u", TILE_OPC_SADH_U, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000000fc0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadh.sn", TILE_OPC_SADH_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sadh_u.sn", TILE_OPC_SADH_U_SN, 0x1 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000008fc0000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sadh_u", TILE_OPC_SADH_U, 0x1, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sb", TILE_OPC_SB, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 17 },
-      { 0, },
-      { 0, },
-      { 15, 36 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0840000000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8500000000000000ULL
-    }
+  { "sadh_u.sn", TILE_OPC_SADH_U_SN, 0x1, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "sbadd", TILE_OPC_SBADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 24, 17, 37 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbf8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30e0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sb", TILE_OPC_SB, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "seq", TILE_OPC_SEQ, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001080000ULL,
-      0x0846000000000000ULL,
-      0x8000000030080000ULL,
-      0xb004000000000000ULL,
-      -1ULL
-    }
+  { "sbadd", TILE_OPC_SBADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seq.sn", TILE_OPC_SEQ_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009080000ULL,
-      0x0c46000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seq", TILE_OPC_SEQ, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "seqb", TILE_OPC_SEQB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001000000ULL,
-      0x0842000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seq.sn", TILE_OPC_SEQ_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqb.sn", TILE_OPC_SEQB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009000000ULL,
-      0x0c42000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqb", TILE_OPC_SEQB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqh", TILE_OPC_SEQH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001040000ULL,
-      0x0844000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqb.sn", TILE_OPC_SEQB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqh.sn", TILE_OPC_SEQH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009040000ULL,
-      0x0c44000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqh", TILE_OPC_SEQH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqi", TILE_OPC_SEQI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040b00000ULL,
-      0x3070000000000000ULL,
-      0x8000000060000000ULL,
-      0xd000000000000000ULL,
-      -1ULL
-    }
+  { "seqh.sn", TILE_OPC_SEQH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqi.sn", TILE_OPC_SEQI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048b00000ULL,
-      0x3470000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqi", TILE_OPC_SEQI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "seqib", TILE_OPC_SEQIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040900000ULL,
-      0x3060000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqi.sn", TILE_OPC_SEQI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqib.sn", TILE_OPC_SEQIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048900000ULL,
-      0x3460000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqib", TILE_OPC_SEQIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqih", TILE_OPC_SEQIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040a00000ULL,
-      0x3068000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqib.sn", TILE_OPC_SEQIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "seqih.sn", TILE_OPC_SEQIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048a00000ULL,
-      0x3468000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "seqih", TILE_OPC_SEQIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sh", TILE_OPC_SH, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 17 },
-      { 0, },
-      { 0, },
-      { 15, 36 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0854000000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8600000000000000ULL
-    }
+  { "seqih.sn", TILE_OPC_SEQIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shadd", TILE_OPC_SHADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 24, 17, 37 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbf8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30e8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sh", TILE_OPC_SH, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "shl", TILE_OPC_SHL, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001140000ULL,
-      0x084c000000000000ULL,
-      0x8000000020040000ULL,
-      0xa002000000000000ULL,
-      -1ULL
-    }
+  { "shadd", TILE_OPC_SHADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shl.sn", TILE_OPC_SHL_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009140000ULL,
-      0x0c4c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shl", TILE_OPC_SHL, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "shlb", TILE_OPC_SHLB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000010c0000ULL,
-      0x0848000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shl.sn", TILE_OPC_SHL_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlb.sn", TILE_OPC_SHLB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000090c0000ULL,
-      0x0c48000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlb", TILE_OPC_SHLB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlh", TILE_OPC_SHLH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001100000ULL,
-      0x084a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlb.sn", TILE_OPC_SHLB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlh.sn", TILE_OPC_SHLH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009100000ULL,
-      0x0c4a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlh", TILE_OPC_SHLH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shli", TILE_OPC_SHLI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 11, 12, 34 },
-      { 13, 14, 35 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0x80000000780e0000ULL,
-      0xf807000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070080000ULL,
-      0x4004000000000000ULL,
-      0x8000000068040000ULL,
-      0xd802000000000000ULL,
-      -1ULL
-    }
+  { "shlh.sn", TILE_OPC_SHLH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shli.sn", TILE_OPC_SHLI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078080000ULL,
-      0x4404000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shli", TILE_OPC_SHLI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "shlib", TILE_OPC_SHLIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070040000ULL,
-      0x4002000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shli.sn", TILE_OPC_SHLI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlib.sn", TILE_OPC_SHLIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078040000ULL,
-      0x4402000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlib", TILE_OPC_SHLIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlih", TILE_OPC_SHLIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070060000ULL,
-      0x4003000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlib.sn", TILE_OPC_SHLIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shlih.sn", TILE_OPC_SHLIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078060000ULL,
-      0x4403000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shlih", TILE_OPC_SHLIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shr", TILE_OPC_SHR, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001200000ULL,
-      0x0852000000000000ULL,
-      0x8000000020080000ULL,
-      0xa004000000000000ULL,
-      -1ULL
-    }
+  { "shlih.sn", TILE_OPC_SHLIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shr.sn", TILE_OPC_SHR_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009200000ULL,
-      0x0c52000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shr", TILE_OPC_SHR, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "shrb", TILE_OPC_SHRB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001180000ULL,
-      0x084e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shr.sn", TILE_OPC_SHR_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrb.sn", TILE_OPC_SHRB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009180000ULL,
-      0x0c4e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrb", TILE_OPC_SHRB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrh", TILE_OPC_SHRH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000011c0000ULL,
-      0x0850000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrb.sn", TILE_OPC_SHRB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrh.sn", TILE_OPC_SHRH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000091c0000ULL,
-      0x0c50000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrh", TILE_OPC_SHRH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shri", TILE_OPC_SHRI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 11, 12, 34 },
-      { 13, 14, 35 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0x80000000780e0000ULL,
-      0xf807000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000700e0000ULL,
-      0x4007000000000000ULL,
-      0x8000000068060000ULL,
-      0xd803000000000000ULL,
-      -1ULL
-    }
+  { "shrh.sn", TILE_OPC_SHRH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shri.sn", TILE_OPC_SHRI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000780e0000ULL,
-      0x4407000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shri", TILE_OPC_SHRI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "shrib", TILE_OPC_SHRIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000700a0000ULL,
-      0x4005000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shri.sn", TILE_OPC_SHRI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrib.sn", TILE_OPC_SHRIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000780a0000ULL,
-      0x4405000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrib", TILE_OPC_SHRIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrih", TILE_OPC_SHRIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000700c0000ULL,
-      0x4006000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrib.sn", TILE_OPC_SHRIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "shrih.sn", TILE_OPC_SHRIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000780c0000ULL,
-      0x4406000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "shrih", TILE_OPC_SHRIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slt", TILE_OPC_SLT, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000014c0000ULL,
-      0x086a000000000000ULL,
-      0x8000000028080000ULL,
-      0xa804000000000000ULL,
-      -1ULL
-    }
+  { "shrih.sn", TILE_OPC_SHRIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slt.sn", TILE_OPC_SLT_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000094c0000ULL,
-      0x0c6a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slt", TILE_OPC_SLT, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slt_u", TILE_OPC_SLT_U, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001500000ULL,
-      0x086c000000000000ULL,
-      0x80000000280c0000ULL,
-      0xa806000000000000ULL,
-      -1ULL
-    }
+  { "slt.sn", TILE_OPC_SLT_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slt_u.sn", TILE_OPC_SLT_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009500000ULL,
-      0x0c6c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slt_u", TILE_OPC_SLT_U, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sltb", TILE_OPC_SLTB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001240000ULL,
-      0x0856000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slt_u.sn", TILE_OPC_SLT_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb.sn", TILE_OPC_SLTB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009240000ULL,
-      0x0c56000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltb", TILE_OPC_SLTB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb_u", TILE_OPC_SLTB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001280000ULL,
-      0x0858000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltb.sn", TILE_OPC_SLTB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltb_u.sn", TILE_OPC_SLTB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009280000ULL,
-      0x0c58000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltb_u", TILE_OPC_SLTB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slte", TILE_OPC_SLTE, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000013c0000ULL,
-      0x0862000000000000ULL,
-      0x8000000028000000ULL,
-      0xa800000000000000ULL,
-      -1ULL
-    }
+  { "sltb_u.sn", TILE_OPC_SLTB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slte.sn", TILE_OPC_SLTE_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000093c0000ULL,
-      0x0c62000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slte", TILE_OPC_SLTE, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slte_u", TILE_OPC_SLTE_U, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001400000ULL,
-      0x0864000000000000ULL,
-      0x8000000028040000ULL,
-      0xa802000000000000ULL,
-      -1ULL
-    }
+  { "slte.sn", TILE_OPC_SLTE_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slte_u.sn", TILE_OPC_SLTE_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009400000ULL,
-      0x0c64000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slte_u", TILE_OPC_SLTE_U, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "slteb", TILE_OPC_SLTEB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000012c0000ULL,
-      0x085a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slte_u.sn", TILE_OPC_SLTE_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb.sn", TILE_OPC_SLTEB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000092c0000ULL,
-      0x0c5a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteb", TILE_OPC_SLTEB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb_u", TILE_OPC_SLTEB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001300000ULL,
-      0x085c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteb.sn", TILE_OPC_SLTEB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteb_u.sn", TILE_OPC_SLTEB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009300000ULL,
-      0x0c5c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteb_u", TILE_OPC_SLTEB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh", TILE_OPC_SLTEH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001340000ULL,
-      0x085e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteb_u.sn", TILE_OPC_SLTEB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh.sn", TILE_OPC_SLTEH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009340000ULL,
-      0x0c5e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteh", TILE_OPC_SLTEH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh_u", TILE_OPC_SLTEH_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001380000ULL,
-      0x0860000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteh.sn", TILE_OPC_SLTEH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slteh_u.sn", TILE_OPC_SLTEH_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009380000ULL,
-      0x0c60000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteh_u", TILE_OPC_SLTEH_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth", TILE_OPC_SLTH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001440000ULL,
-      0x0866000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slteh_u.sn", TILE_OPC_SLTEH_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth.sn", TILE_OPC_SLTH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009440000ULL,
-      0x0c66000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slth", TILE_OPC_SLTH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth_u", TILE_OPC_SLTH_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001480000ULL,
-      0x0868000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slth.sn", TILE_OPC_SLTH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slth_u.sn", TILE_OPC_SLTH_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009480000ULL,
-      0x0c68000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slth_u", TILE_OPC_SLTH_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slti", TILE_OPC_SLTI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000041000000ULL,
-      0x3098000000000000ULL,
-      0x8000000070000000ULL,
-      0xe000000000000000ULL,
-      -1ULL
-    }
+  { "slth_u.sn", TILE_OPC_SLTH_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slti.sn", TILE_OPC_SLTI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000049000000ULL,
-      0x3498000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slti", TILE_OPC_SLTI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "slti_u", TILE_OPC_SLTI_U, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 11, 12, 2 },
-      { 13, 14, 3 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0x8000000078000000ULL,
-      0xf800000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000041100000ULL,
-      0x30a0000000000000ULL,
-      0x8000000078000000ULL,
-      0xe800000000000000ULL,
-      -1ULL
-    }
+  { "slti.sn", TILE_OPC_SLTI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "slti_u.sn", TILE_OPC_SLTI_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000049100000ULL,
-      0x34a0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slti_u", TILE_OPC_SLTI_U, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 11, 12, 2 }, { 13, 14, 3 }, { 0, } },
   },
-  { "sltib", TILE_OPC_SLTIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040c00000ULL,
-      0x3078000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "slti_u.sn", TILE_OPC_SLTI_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib.sn", TILE_OPC_SLTIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048c00000ULL,
-      0x3478000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltib", TILE_OPC_SLTIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib_u", TILE_OPC_SLTIB_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040d00000ULL,
-      0x3080000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltib.sn", TILE_OPC_SLTIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltib_u.sn", TILE_OPC_SLTIB_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048d00000ULL,
-      0x3480000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltib_u", TILE_OPC_SLTIB_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih", TILE_OPC_SLTIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040e00000ULL,
-      0x3088000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltib_u.sn", TILE_OPC_SLTIB_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih.sn", TILE_OPC_SLTIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048e00000ULL,
-      0x3488000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltih", TILE_OPC_SLTIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih_u", TILE_OPC_SLTIH_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000040f00000ULL,
-      0x3090000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltih.sn", TILE_OPC_SLTIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sltih_u.sn", TILE_OPC_SLTIH_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000048f00000ULL,
-      0x3490000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sltih_u", TILE_OPC_SLTIH_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sne", TILE_OPC_SNE, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000015c0000ULL,
-      0x0872000000000000ULL,
-      0x80000000300c0000ULL,
-      0xb006000000000000ULL,
-      -1ULL
-    }
+  { "sltih_u.sn", TILE_OPC_SLTIH_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sne.sn", TILE_OPC_SNE_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000095c0000ULL,
-      0x0c72000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sne", TILE_OPC_SNE, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "sneb", TILE_OPC_SNEB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001540000ULL,
-      0x086e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sne.sn", TILE_OPC_SNE_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneb.sn", TILE_OPC_SNEB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009540000ULL,
-      0x0c6e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sneb", TILE_OPC_SNEB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneh", TILE_OPC_SNEH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001580000ULL,
-      0x0870000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sneb.sn", TILE_OPC_SNEB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sneh.sn", TILE_OPC_SNEH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009580000ULL,
-      0x0c70000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sneh", TILE_OPC_SNEH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sra", TILE_OPC_SRA, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001680000ULL,
-      0x0878000000000000ULL,
-      0x80000000200c0000ULL,
-      0xa006000000000000ULL,
-      -1ULL
-    }
+  { "sneh.sn", TILE_OPC_SNEH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sra.sn", TILE_OPC_SRA_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009680000ULL,
-      0x0c78000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sra", TILE_OPC_SRA, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "srab", TILE_OPC_SRAB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001600000ULL,
-      0x0874000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sra.sn", TILE_OPC_SRA_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srab.sn", TILE_OPC_SRAB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009600000ULL,
-      0x0c74000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "srab", TILE_OPC_SRAB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srah", TILE_OPC_SRAH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001640000ULL,
-      0x0876000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "srab.sn", TILE_OPC_SRAB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srah.sn", TILE_OPC_SRAH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009640000ULL,
-      0x0c76000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "srah", TILE_OPC_SRAH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srai", TILE_OPC_SRAI, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 11, 12, 34 },
-      { 13, 14, 35 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0x80000000780e0000ULL,
-      0xf807000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070140000ULL,
-      0x400a000000000000ULL,
-      0x8000000068080000ULL,
-      0xd804000000000000ULL,
-      -1ULL
-    }
+  { "srah.sn", TILE_OPC_SRAH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "srai.sn", TILE_OPC_SRAI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078140000ULL,
-      0x440a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "srai", TILE_OPC_SRAI, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 11, 12, 34 }, { 13, 14, 35 }, { 0, } },
   },
-  { "sraib", TILE_OPC_SRAIB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070100000ULL,
-      0x4008000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "srai.sn", TILE_OPC_SRAI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraib.sn", TILE_OPC_SRAIB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078100000ULL,
-      0x4408000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sraib", TILE_OPC_SRAIB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraih", TILE_OPC_SRAIH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070120000ULL,
-      0x4009000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sraib.sn", TILE_OPC_SRAIB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sraih.sn", TILE_OPC_SRAIH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 32 },
-      { 9, 10, 33 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffe0000ULL,
-      0xffff000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078120000ULL,
-      0x4409000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sraih", TILE_OPC_SRAIH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sub", TILE_OPC_SUB, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001740000ULL,
-      0x087e000000000000ULL,
-      0x80000000080c0000ULL,
-      0x8806000000000000ULL,
-      -1ULL
-    }
+  { "sraih.sn", TILE_OPC_SRAIH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 32 }, { 9, 10, 33 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sub.sn", TILE_OPC_SUB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009740000ULL,
-      0x0c7e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sub", TILE_OPC_SUB, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "subb", TILE_OPC_SUBB, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000016c0000ULL,
-      0x087a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sub.sn", TILE_OPC_SUB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subb.sn", TILE_OPC_SUBB_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x00000000096c0000ULL,
-      0x0c7a000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subb", TILE_OPC_SUBB, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subbs_u", TILE_OPC_SUBBS_U, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001900000ULL,
-      0x088c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subb.sn", TILE_OPC_SUBB_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subbs_u.sn", TILE_OPC_SUBBS_U_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009900000ULL,
-      0x0c8c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subbs_u", TILE_OPC_SUBBS_U, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subh", TILE_OPC_SUBH, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001700000ULL,
-      0x087c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subbs_u.sn", TILE_OPC_SUBBS_U_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subh.sn", TILE_OPC_SUBH_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009700000ULL,
-      0x0c7c000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subh", TILE_OPC_SUBH, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subhs", TILE_OPC_SUBHS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001940000ULL,
-      0x088e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subh.sn", TILE_OPC_SUBH_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subhs.sn", TILE_OPC_SUBHS_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009940000ULL,
-      0x0c8e000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subhs", TILE_OPC_SUBHS, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subs", TILE_OPC_SUBS, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001840000ULL,
-      0x0886000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subhs.sn", TILE_OPC_SUBHS_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "subs.sn", TILE_OPC_SUBS_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009840000ULL,
-      0x0c86000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "subs", TILE_OPC_SUBS, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "sw", TILE_OPC_SW, 0x12 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10, 17 },
-      { 0, },
-      { 0, },
-      { 15, 36 }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfe000000000000ULL,
-      0ULL,
-      0ULL,
-      0x8700000000000000ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x0880000000000000ULL,
-      -1ULL,
-      -1ULL,
-      0x8700000000000000ULL
-    }
+  { "subs.sn", TILE_OPC_SUBS_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "swadd", TILE_OPC_SWADD, 0x2 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 24, 17, 37 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbf8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x30f0000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "sw", TILE_OPC_SW, 0x12, 2, TREG_ZERO, 1,
+    { { 0, }, { 10, 17 }, { 0, }, { 0, }, { 15, 36 } },
   },
-  { "swint0", TILE_OPC_SWINT0, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b900000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "swadd", TILE_OPC_SWADD, 0x2, 3, TREG_ZERO, 1,
+    { { 0, }, { 24, 17, 37 }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint1", TILE_OPC_SWINT1, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400b980000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "swint0", TILE_OPC_SWINT0, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint2", TILE_OPC_SWINT2, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400ba00000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "swint1", TILE_OPC_SWINT1, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "swint3", TILE_OPC_SWINT3, 0x2 /* pipes */, 0 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    0, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      {  },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400ba80000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "swint2", TILE_OPC_SWINT2, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb0", TILE_OPC_TBLIDXB0, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 31, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070168000ULL,
-      -1ULL,
-      0x80000000680a8000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "swint3", TILE_OPC_SWINT3, 0x2, 0, TREG_ZERO, 0,
+    { { 0, }, {  }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb0.sn", TILE_OPC_TBLIDXB0_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078168000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb0", TILE_OPC_TBLIDXB0, 0x5, 2, TREG_ZERO, 1,
+    { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb1", TILE_OPC_TBLIDXB1, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 31, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000070169000ULL,
-      -1ULL,
-      0x80000000680a9000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb0.sn", TILE_OPC_TBLIDXB0_SN, 0x1, 2, TREG_SN, 1,
+    { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb1.sn", TILE_OPC_TBLIDXB1_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000078169000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb1", TILE_OPC_TBLIDXB1, 0x5, 2, TREG_ZERO, 1,
+    { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb2", TILE_OPC_TBLIDXB2, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 31, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x000000007016a000ULL,
-      -1ULL,
-      0x80000000680aa000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb1.sn", TILE_OPC_TBLIDXB1_SN, 0x1, 2, TREG_SN, 1,
+    { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb2.sn", TILE_OPC_TBLIDXB2_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x000000007816a000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb2", TILE_OPC_TBLIDXB2, 0x5, 2, TREG_ZERO, 1,
+    { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tblidxb3", TILE_OPC_TBLIDXB3, 0x5 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 31, 12 },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0x80000000780ff000ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x000000007016b000ULL,
-      -1ULL,
-      0x80000000680ab000ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb2.sn", TILE_OPC_TBLIDXB2_SN, 0x1, 2, TREG_SN, 1,
+    { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tblidxb3.sn", TILE_OPC_TBLIDXB3_SN, 0x1 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 21, 8 },
-      { 0, },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffff000ULL,
-      0ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x000000007816b000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb3", TILE_OPC_TBLIDXB3, 0x5, 2, TREG_ZERO, 1,
+    { { 21, 8 }, { 0, }, { 31, 12 }, { 0, }, { 0, } },
   },
-  { "tns", TILE_OPC_TNS, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400bb00000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tblidxb3.sn", TILE_OPC_TBLIDXB3_SN, 0x1, 2, TREG_SN, 1,
+    { { 21, 8 }, { 0, }, { 0, }, { 0, }, { 0, } },
   },
-  { "tns.sn", TILE_OPC_TNS_SN, 0x2 /* pipes */, 2 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 9, 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfffff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x440bb00000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tns", TILE_OPC_TNS, 0x2, 2, TREG_ZERO, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "wh64", TILE_OPC_WH64, 0x2 /* pipes */, 1 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 0, },
-      { 10 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0ULL,
-      0xfbfff80000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      -1ULL,
-      0x400bb80000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "tns.sn", TILE_OPC_TNS_SN, 0x2, 2, TREG_SN, 1,
+    { { 0, }, { 9, 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xor", TILE_OPC_XOR, 0xf /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 11, 12, 18 },
-      { 13, 14, 19 },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0x80000000780c0000ULL,
-      0xf806000000000000ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000001780000ULL,
-      0x0882000000000000ULL,
-      0x80000000180c0000ULL,
-      0x9806000000000000ULL,
-      -1ULL
-    }
+  { "wh64", TILE_OPC_WH64, 0x2, 1, TREG_ZERO, 1,
+    { { 0, }, { 10 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xor.sn", TILE_OPC_XOR_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 16 },
-      { 9, 10, 17 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ffc0000ULL,
-      0xfffe000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000009780000ULL,
-      0x0c82000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "xor", TILE_OPC_XOR, 0xf, 3, TREG_ZERO, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 11, 12, 18 }, { 13, 14, 19 }, { 0, } },
   },
-  { "xori", TILE_OPC_XORI, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_ZERO, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000050200000ULL,
-      0x30a8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "xor.sn", TILE_OPC_XOR_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 16 }, { 9, 10, 17 }, { 0, }, { 0, }, { 0, } },
   },
-  { "xori.sn", TILE_OPC_XORI_SN, 0x3 /* pipes */, 3 /* num_operands */,
-    TREG_SN, /* implicitly_written_register */
-    1, /* can_bundle */
-    {
-      /* operands */
-      { 7, 8, 0 },
-      { 9, 10, 1 },
-      { 0, },
-      { 0, },
-      { 0, }
-    },
-    {
-      /* fixed_bit_masks */
-      0x800000007ff00000ULL,
-      0xfff8000000000000ULL,
-      0ULL,
-      0ULL,
-      0ULL
-    },
-    {
-      /* fixed_bit_values */
-      0x0000000058200000ULL,
-      0x34a8000000000000ULL,
-      -1ULL,
-      -1ULL,
-      -1ULL
-    }
+  { "xori", TILE_OPC_XORI, 0x3, 3, TREG_ZERO, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
+  },
+  { "xori.sn", TILE_OPC_XORI_SN, 0x3, 3, TREG_SN, 1,
+    { { 7, 8, 0 }, { 9, 10, 1 }, { 0, }, { 0, }, { 0, } },
   },
-  { 0, TILE_OPC_NONE, 0, 0, 0, TREG_ZERO, { { 0, } }, { 0, }, { 0, }
+  { NULL, TILE_OPC_NONE, 0, 0, TREG_ZERO, 0, { { 0, } },
   }
 };
 #define BITFIELD(start, size) ((start) | (((1 << (size)) - 1) << 6))
@@ -11387,7 +1559,7 @@ static const unsigned short decode_X0_fsm[1153] =
   TILE_OPC_TBLIDXB3_SN, TILE_OPC_NONE,
 };
 
-static const unsigned short decode_X1_fsm[1509] =
+static const unsigned short decode_X1_fsm[1540] =
 {
   BITFIELD(54, 9) /* index 0 */,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
@@ -11440,7 +1612,7 @@ static const unsigned short decode_X1_fsm[1509] =
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  CHILD(1303), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(1334), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
@@ -11673,7 +1845,7 @@ static const unsigned short decode_X1_fsm[1509] =
   CHILD(1139), CHILD(1139), CHILD(1142), CHILD(1142), CHILD(1142),
   CHILD(1142), CHILD(1145), CHILD(1145), CHILD(1145), CHILD(1145),
   CHILD(1148), CHILD(1148), CHILD(1148), CHILD(1148), CHILD(1151),
-  CHILD(1211), CHILD(1259), CHILD(1292), TILE_OPC_NONE, TILE_OPC_NONE,
+  CHILD(1242), CHILD(1290), CHILD(1323), TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
@@ -11725,10 +1897,10 @@ static const unsigned short decode_X1_fsm[1509] =
   TILE_OPC_FNOP, TILE_OPC_NONE,
   BITFIELD(53, 1) /* index 1175 */,
   TILE_OPC_ICOH, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1178 */,
-  CHILD(1181), TILE_OPC_NONE,
-  BITFIELD(31, 2) /* index 1181 */,
-  CHILD(1186), TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_ILL,
+  BITFIELD(31, 2) /* index 1178 */,
+  CHILD(1183), CHILD(1211), CHILD(1239), CHILD(1239),
+  BITFIELD(53, 1) /* index 1183 */,
+  CHILD(1186), TILE_OPC_NONE,
   BITFIELD(33, 2) /* index 1186 */,
   TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_ILL, CHILD(1191),
   BITFIELD(35, 2) /* index 1191 */,
@@ -11739,67 +1911,81 @@ static const unsigned short decode_X1_fsm[1509] =
   TILE_OPC_ILL, CHILD(1206), TILE_OPC_ILL, TILE_OPC_ILL,
   BITFIELD(41, 2) /* index 1206 */,
   TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_BPT, TILE_OPC_ILL,
-  BITFIELD(43, 3) /* index 1211 */,
-  CHILD(1220), CHILD(1223), CHILD(1226), CHILD(1244), CHILD(1247),
-  CHILD(1250), CHILD(1253), CHILD(1256),
-  BITFIELD(53, 1) /* index 1220 */,
+  BITFIELD(53, 1) /* index 1211 */,
+  CHILD(1214), TILE_OPC_NONE,
+  BITFIELD(33, 2) /* index 1214 */,
+  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_ILL, CHILD(1219),
+  BITFIELD(35, 2) /* index 1219 */,
+  TILE_OPC_ILL, CHILD(1224), TILE_OPC_ILL, TILE_OPC_ILL,
+  BITFIELD(37, 2) /* index 1224 */,
+  TILE_OPC_ILL, CHILD(1229), TILE_OPC_ILL, TILE_OPC_ILL,
+  BITFIELD(39, 2) /* index 1229 */,
+  TILE_OPC_ILL, CHILD(1234), TILE_OPC_ILL, TILE_OPC_ILL,
+  BITFIELD(41, 2) /* index 1234 */,
+  TILE_OPC_ILL, TILE_OPC_ILL, TILE_OPC_RAISE, TILE_OPC_ILL,
+  BITFIELD(53, 1) /* index 1239 */,
+  TILE_OPC_ILL, TILE_OPC_NONE,
+  BITFIELD(43, 3) /* index 1242 */,
+  CHILD(1251), CHILD(1254), CHILD(1257), CHILD(1275), CHILD(1278),
+  CHILD(1281), CHILD(1284), CHILD(1287),
+  BITFIELD(53, 1) /* index 1251 */,
   TILE_OPC_INV, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1223 */,
+  BITFIELD(53, 1) /* index 1254 */,
   TILE_OPC_IRET, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1226 */,
-  CHILD(1229), TILE_OPC_NONE,
-  BITFIELD(31, 2) /* index 1229 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1234),
-  BITFIELD(33, 2) /* index 1234 */,
-  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1239),
-  BITFIELD(35, 2) /* index 1239 */,
+  BITFIELD(53, 1) /* index 1257 */,
+  CHILD(1260), TILE_OPC_NONE,
+  BITFIELD(31, 2) /* index 1260 */,
+  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1265),
+  BITFIELD(33, 2) /* index 1265 */,
+  TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, CHILD(1270),
+  BITFIELD(35, 2) /* index 1270 */,
   TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_LB, TILE_OPC_PREFETCH,
-  BITFIELD(53, 1) /* index 1244 */,
+  BITFIELD(53, 1) /* index 1275 */,
   TILE_OPC_LB_U, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1247 */,
+  BITFIELD(53, 1) /* index 1278 */,
   TILE_OPC_LH, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1250 */,
+  BITFIELD(53, 1) /* index 1281 */,
   TILE_OPC_LH_U, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1253 */,
+  BITFIELD(53, 1) /* index 1284 */,
   TILE_OPC_LW, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1256 */,
+  BITFIELD(53, 1) /* index 1287 */,
   TILE_OPC_MF, TILE_OPC_NONE,
-  BITFIELD(43, 3) /* index 1259 */,
-  CHILD(1268), CHILD(1271), CHILD(1274), CHILD(1277), CHILD(1280),
-  CHILD(1283), CHILD(1286), CHILD(1289),
-  BITFIELD(53, 1) /* index 1268 */,
+  BITFIELD(43, 3) /* index 1290 */,
+  CHILD(1299), CHILD(1302), CHILD(1305), CHILD(1308), CHILD(1311),
+  CHILD(1314), CHILD(1317), CHILD(1320),
+  BITFIELD(53, 1) /* index 1299 */,
   TILE_OPC_NAP, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1271 */,
+  BITFIELD(53, 1) /* index 1302 */,
   TILE_OPC_NOP, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1274 */,
+  BITFIELD(53, 1) /* index 1305 */,
   TILE_OPC_SWINT0, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1277 */,
+  BITFIELD(53, 1) /* index 1308 */,
   TILE_OPC_SWINT1, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1280 */,
+  BITFIELD(53, 1) /* index 1311 */,
   TILE_OPC_SWINT2, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1283 */,
+  BITFIELD(53, 1) /* index 1314 */,
   TILE_OPC_SWINT3, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1286 */,
+  BITFIELD(53, 1) /* index 1317 */,
   TILE_OPC_TNS, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1289 */,
+  BITFIELD(53, 1) /* index 1320 */,
   TILE_OPC_WH64, TILE_OPC_NONE,
-  BITFIELD(43, 2) /* index 1292 */,
-  CHILD(1297), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  BITFIELD(45, 1) /* index 1297 */,
-  CHILD(1300), TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1300 */,
+  BITFIELD(43, 2) /* index 1323 */,
+  CHILD(1328), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  BITFIELD(45, 1) /* index 1328 */,
+  CHILD(1331), TILE_OPC_NONE,
+  BITFIELD(53, 1) /* index 1331 */,
   TILE_OPC_LW_NA, TILE_OPC_NONE,
-  BITFIELD(46, 7) /* index 1303 */,
-  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(1432),
-  CHILD(1432), CHILD(1432), CHILD(1432), CHILD(1435), CHILD(1435),
-  CHILD(1435), CHILD(1435), CHILD(1438), CHILD(1438), CHILD(1438),
-  CHILD(1438), CHILD(1441), CHILD(1441), CHILD(1441), CHILD(1441),
-  CHILD(1444), CHILD(1444), CHILD(1444), CHILD(1444), CHILD(1447),
-  CHILD(1447), CHILD(1447), CHILD(1447), CHILD(1450), CHILD(1450),
-  CHILD(1450), CHILD(1450), CHILD(1453), CHILD(1453), CHILD(1453),
-  CHILD(1453), CHILD(1456), CHILD(1456), CHILD(1456), CHILD(1456),
-  CHILD(1459), CHILD(1459), CHILD(1459), CHILD(1459), CHILD(1151),
-  CHILD(1462), CHILD(1486), CHILD(1498), TILE_OPC_NONE, TILE_OPC_NONE,
+  BITFIELD(46, 7) /* index 1334 */,
+  TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, CHILD(1463),
+  CHILD(1463), CHILD(1463), CHILD(1463), CHILD(1466), CHILD(1466),
+  CHILD(1466), CHILD(1466), CHILD(1469), CHILD(1469), CHILD(1469),
+  CHILD(1469), CHILD(1472), CHILD(1472), CHILD(1472), CHILD(1472),
+  CHILD(1475), CHILD(1475), CHILD(1475), CHILD(1475), CHILD(1478),
+  CHILD(1478), CHILD(1478), CHILD(1478), CHILD(1481), CHILD(1481),
+  CHILD(1481), CHILD(1481), CHILD(1484), CHILD(1484), CHILD(1484),
+  CHILD(1484), CHILD(1487), CHILD(1487), CHILD(1487), CHILD(1487),
+  CHILD(1490), CHILD(1490), CHILD(1490), CHILD(1490), CHILD(1151),
+  CHILD(1493), CHILD(1517), CHILD(1529), TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
@@ -11816,49 +2002,49 @@ static const unsigned short decode_X1_fsm[1509] =
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
   TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1432 */,
+  BITFIELD(53, 1) /* index 1463 */,
   TILE_OPC_RLI_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1435 */,
+  BITFIELD(53, 1) /* index 1466 */,
   TILE_OPC_SHLIB_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1438 */,
+  BITFIELD(53, 1) /* index 1469 */,
   TILE_OPC_SHLIH_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1441 */,
+  BITFIELD(53, 1) /* index 1472 */,
   TILE_OPC_SHLI_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1444 */,
+  BITFIELD(53, 1) /* index 1475 */,
   TILE_OPC_SHRIB_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1447 */,
+  BITFIELD(53, 1) /* index 1478 */,
   TILE_OPC_SHRIH_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1450 */,
+  BITFIELD(53, 1) /* index 1481 */,
   TILE_OPC_SHRI_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1453 */,
+  BITFIELD(53, 1) /* index 1484 */,
   TILE_OPC_SRAIB_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1456 */,
+  BITFIELD(53, 1) /* index 1487 */,
   TILE_OPC_SRAIH_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1459 */,
+  BITFIELD(53, 1) /* index 1490 */,
   TILE_OPC_SRAI_SN, TILE_OPC_NONE,
-  BITFIELD(43, 3) /* index 1462 */,
-  CHILD(1220), CHILD(1223), CHILD(1471), CHILD(1474), CHILD(1477),
-  CHILD(1480), CHILD(1483), CHILD(1256),
-  BITFIELD(53, 1) /* index 1471 */,
+  BITFIELD(43, 3) /* index 1493 */,
+  CHILD(1251), CHILD(1254), CHILD(1502), CHILD(1505), CHILD(1508),
+  CHILD(1511), CHILD(1514), CHILD(1287),
+  BITFIELD(53, 1) /* index 1502 */,
   TILE_OPC_LB_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1474 */,
+  BITFIELD(53, 1) /* index 1505 */,
   TILE_OPC_LB_U_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1477 */,
+  BITFIELD(53, 1) /* index 1508 */,
   TILE_OPC_LH_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1480 */,
+  BITFIELD(53, 1) /* index 1511 */,
   TILE_OPC_LH_U_SN, TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1483 */,
+  BITFIELD(53, 1) /* index 1514 */,
   TILE_OPC_LW_SN, TILE_OPC_NONE,
-  BITFIELD(43, 3) /* index 1486 */,
-  CHILD(1268), CHILD(1271), CHILD(1274), CHILD(1277), CHILD(1280),
-  CHILD(1283), CHILD(1495), CHILD(1289),
-  BITFIELD(53, 1) /* index 1495 */,
+  BITFIELD(43, 3) /* index 1517 */,
+  CHILD(1299), CHILD(1302), CHILD(1305), CHILD(1308), CHILD(1311),
+  CHILD(1314), CHILD(1526), CHILD(1320),
+  BITFIELD(53, 1) /* index 1526 */,
   TILE_OPC_TNS_SN, TILE_OPC_NONE,
-  BITFIELD(43, 2) /* index 1498 */,
-  CHILD(1503), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
-  BITFIELD(45, 1) /* index 1503 */,
-  CHILD(1506), TILE_OPC_NONE,
-  BITFIELD(53, 1) /* index 1506 */,
+  BITFIELD(43, 2) /* index 1529 */,
+  CHILD(1534), TILE_OPC_NONE, TILE_OPC_NONE, TILE_OPC_NONE,
+  BITFIELD(45, 1) /* index 1534 */,
+  CHILD(1537), TILE_OPC_NONE,
+  BITFIELD(53, 1) /* index 1537 */,
   TILE_OPC_LW_NA_SN, TILE_OPC_NONE,
 };
 
@@ -12005,1741 +2191,227 @@ tile_bundle_decoder_fsms[TILE_NUM_PIPELINE_ENCODINGS] =
   decode_Y1_fsm,
   decode_Y2_fsm
 };
-const struct tile_sn_opcode tile_sn_opcodes[23] =
-{
- { "bz", TILE_SN_OPC_BZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xe000
-  },
-  { "bnz", TILE_SN_OPC_BNZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xe400
-  },
-  { "jrr", TILE_SN_OPC_JRR,
-    1 /* num_operands */,
-    /* operands */
-    { 39 },
-    /* fixed_bit_mask */
-    0xff00,
-    /* fixed_bit_value */
-    0x0600
-  },
-  { "fnop", TILE_SN_OPC_FNOP,
-    0 /* num_operands */,
-    /* operands */
-    { 0, },
-    /* fixed_bit_mask */
-    0xffff,
-    /* fixed_bit_value */
-    0x0003
-  },
-  { "blz", TILE_SN_OPC_BLZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xf000
-  },
-  { "nop", TILE_SN_OPC_NOP,
-    0 /* num_operands */,
-    /* operands */
-    { 0, },
-    /* fixed_bit_mask */
-    0xffff,
-    /* fixed_bit_value */
-    0x0002
-  },
-  { "movei", TILE_SN_OPC_MOVEI,
-    1 /* num_operands */,
-    /* operands */
-    { 40 },
-    /* fixed_bit_mask */
-    0xff00,
-    /* fixed_bit_value */
-    0x0400
-  },
-  { "move", TILE_SN_OPC_MOVE,
-    2 /* num_operands */,
-    /* operands */
-    { 41, 42 },
-    /* fixed_bit_mask */
-    0xfff0,
-    /* fixed_bit_value */
-    0x0080
-  },
-  { "bgez", TILE_SN_OPC_BGEZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xf400
-  },
-  { "jr", TILE_SN_OPC_JR,
-    1 /* num_operands */,
-    /* operands */
-    { 42 },
-    /* fixed_bit_mask */
-    0xfff0,
-    /* fixed_bit_value */
-    0x0040
-  },
-  { "blez", TILE_SN_OPC_BLEZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xec00
-  },
-  { "bbns", TILE_SN_OPC_BBNS,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xfc00
-  },
-  { "jalrr", TILE_SN_OPC_JALRR,
-    1 /* num_operands */,
-    /* operands */
-    { 39 },
-    /* fixed_bit_mask */
-    0xff00,
-    /* fixed_bit_value */
-    0x0700
-  },
-  { "bpt", TILE_SN_OPC_BPT,
-    0 /* num_operands */,
-    /* operands */
-    { 0, },
-    /* fixed_bit_mask */
-    0xffff,
-    /* fixed_bit_value */
-    0x0001
-  },
-  { "jalr", TILE_SN_OPC_JALR,
-    1 /* num_operands */,
-    /* operands */
-    { 42 },
-    /* fixed_bit_mask */
-    0xfff0,
-    /* fixed_bit_value */
-    0x0050
-  },
-  { "shr1", TILE_SN_OPC_SHR1,
-    2 /* num_operands */,
-    /* operands */
-    { 41, 42 },
-    /* fixed_bit_mask */
-    0xfff0,
-    /* fixed_bit_value */
-    0x0090
-  },
-  { "bgz", TILE_SN_OPC_BGZ,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xe800
-  },
-  { "bbs", TILE_SN_OPC_BBS,
-    1 /* num_operands */,
-    /* operands */
-    { 38 },
-    /* fixed_bit_mask */
-    0xfc00,
-    /* fixed_bit_value */
-    0xf800
-  },
-  { "shl8ii", TILE_SN_OPC_SHL8II,
-    1 /* num_operands */,
-    /* operands */
-    { 39 },
-    /* fixed_bit_mask */
-    0xff00,
-    /* fixed_bit_value */
-    0x0300
-  },
-  { "addi", TILE_SN_OPC_ADDI,
-    1 /* num_operands */,
-    /* operands */
-    { 40 },
-    /* fixed_bit_mask */
-    0xff00,
-    /* fixed_bit_value */
-    0x0500
-  },
-  { "halt", TILE_SN_OPC_HALT,
-    0 /* num_operands */,
-    /* operands */
-    { 0, },
-    /* fixed_bit_mask */
-    0xffff,
-    /* fixed_bit_value */
-    0x0000
-  },
-  { "route", TILE_SN_OPC_ROUTE, 0, { 0, }, 0, 0,
-  },
-  { 0, TILE_SN_OPC_NONE, 0, { 0, }, 0, 0,
-  }
-};
-const unsigned char tile_sn_route_encode[6 * 6 * 6] =
-{
-  0xdf,
-  0xde,
-  0xdd,
-  0xdc,
-  0xdb,
-  0xda,
-  0xb9,
-  0xb8,
-  0xa1,
-  0xa0,
-  0x11,
-  0x10,
-  0x9f,
-  0x9e,
-  0x9d,
-  0x9c,
-  0x9b,
-  0x9a,
-  0x79,
-  0x78,
-  0x61,
-  0x60,
-  0xb,
-  0xa,
-  0x5f,
-  0x5e,
-  0x5d,
-  0x5c,
-  0x5b,
-  0x5a,
-  0x1f,
-  0x1e,
-  0x1d,
-  0x1c,
-  0x1b,
-  0x1a,
-  0xd7,
-  0xd6,
-  0xd5,
-  0xd4,
-  0xd3,
-  0xd2,
-  0xa7,
-  0xa6,
-  0xb1,
-  0xb0,
-  0x13,
-  0x12,
-  0x97,
-  0x96,
-  0x95,
-  0x94,
-  0x93,
-  0x92,
-  0x67,
-  0x66,
-  0x71,
-  0x70,
-  0x9,
-  0x8,
-  0x57,
-  0x56,
-  0x55,
-  0x54,
-  0x53,
-  0x52,
-  0x17,
-  0x16,
-  0x15,
-  0x14,
-  0x19,
-  0x18,
-  0xcf,
-  0xce,
-  0xcd,
-  0xcc,
-  0xcb,
-  0xca,
-  0xaf,
-  0xae,
-  0xad,
-  0xac,
-  0xab,
-  0xaa,
-  0x8f,
-  0x8e,
-  0x8d,
-  0x8c,
-  0x8b,
-  0x8a,
-  0x6f,
-  0x6e,
-  0x6d,
-  0x6c,
-  0x6b,
-  0x6a,
-  0x4f,
-  0x4e,
-  0x4d,
-  0x4c,
-  0x4b,
-  0x4a,
-  0x2f,
-  0x2e,
-  0x2d,
-  0x2c,
-  0x2b,
-  0x2a,
-  0xc9,
-  0xc8,
-  0xc5,
-  0xc4,
-  0xc3,
-  0xc2,
-  0xa9,
-  0xa8,
-  0xa5,
-  0xa4,
-  0xa3,
-  0xa2,
-  0x89,
-  0x88,
-  0x85,
-  0x84,
-  0x83,
-  0x82,
-  0x69,
-  0x68,
-  0x65,
-  0x64,
-  0x63,
-  0x62,
-  0x47,
-  0x46,
-  0x45,
-  0x44,
-  0x43,
-  0x42,
-  0x27,
-  0x26,
-  0x25,
-  0x24,
-  0x23,
-  0x22,
-  0xd9,
-  0xd8,
-  0xc1,
-  0xc0,
-  0x3b,
-  0x3a,
-  0xbf,
-  0xbe,
-  0xbd,
-  0xbc,
-  0xbb,
-  0xba,
-  0x99,
-  0x98,
-  0x81,
-  0x80,
-  0x31,
-  0x30,
-  0x7f,
-  0x7e,
-  0x7d,
-  0x7c,
-  0x7b,
-  0x7a,
-  0x59,
-  0x58,
-  0x3d,
-  0x3c,
-  0x49,
-  0x48,
-  0xf,
-  0xe,
-  0xd,
-  0xc,
-  0x29,
-  0x28,
-  0xc7,
-  0xc6,
-  0xd1,
-  0xd0,
-  0x39,
-  0x38,
-  0xb7,
-  0xb6,
-  0xb5,
-  0xb4,
-  0xb3,
-  0xb2,
-  0x87,
-  0x86,
-  0x91,
-  0x90,
-  0x33,
-  0x32,
-  0x77,
-  0x76,
-  0x75,
-  0x74,
-  0x73,
-  0x72,
-  0x3f,
-  0x3e,
-  0x51,
-  0x50,
-  0x41,
-  0x40,
-  0x37,
-  0x36,
-  0x35,
-  0x34,
-  0x21,
-  0x20
-};
-
-const signed char tile_sn_route_decode[256][3] =
-{
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { 5, 3, 1 },
-  { 4, 3, 1 },
-  { 5, 3, 0 },
-  { 4, 3, 0 },
-  { 3, 5, 4 },
-  { 2, 5, 4 },
-  { 1, 5, 4 },
-  { 0, 5, 4 },
-  { 5, 1, 0 },
-  { 4, 1, 0 },
-  { 5, 1, 1 },
-  { 4, 1, 1 },
-  { 3, 5, 1 },
-  { 2, 5, 1 },
-  { 1, 5, 1 },
-  { 0, 5, 1 },
-  { 5, 5, 1 },
-  { 4, 5, 1 },
-  { 5, 5, 0 },
-  { 4, 5, 0 },
-  { 3, 5, 0 },
-  { 2, 5, 0 },
-  { 1, 5, 0 },
-  { 0, 5, 0 },
-  { 5, 5, 5 },
-  { 4, 5, 5 },
-  { 5, 5, 3 },
-  { 4, 5, 3 },
-  { 3, 5, 3 },
-  { 2, 5, 3 },
-  { 1, 5, 3 },
-  { 0, 5, 3 },
-  { 5, 5, 4 },
-  { 4, 5, 4 },
-  { 5, 5, 2 },
-  { 4, 5, 2 },
-  { 3, 5, 2 },
-  { 2, 5, 2 },
-  { 1, 5, 2 },
-  { 0, 5, 2 },
-  { 5, 2, 4 },
-  { 4, 2, 4 },
-  { 5, 2, 5 },
-  { 4, 2, 5 },
-  { 3, 5, 5 },
-  { 2, 5, 5 },
-  { 1, 5, 5 },
-  { 0, 5, 5 },
-  { 5, 0, 5 },
-  { 4, 0, 5 },
-  { 5, 0, 4 },
-  { 4, 0, 4 },
-  { 3, 4, 4 },
-  { 2, 4, 4 },
-  { 1, 4, 5 },
-  { 0, 4, 5 },
-  { 5, 4, 5 },
-  { 4, 4, 5 },
-  { 5, 4, 3 },
-  { 4, 4, 3 },
-  { 3, 4, 3 },
-  { 2, 4, 3 },
-  { 1, 4, 3 },
-  { 0, 4, 3 },
-  { 5, 4, 4 },
-  { 4, 4, 4 },
-  { 5, 4, 2 },
-  { 4, 4, 2 },
-  { 3, 4, 2 },
-  { 2, 4, 2 },
-  { 1, 4, 2 },
-  { 0, 4, 2 },
-  { 3, 4, 5 },
-  { 2, 4, 5 },
-  { 5, 4, 1 },
-  { 4, 4, 1 },
-  { 3, 4, 1 },
-  { 2, 4, 1 },
-  { 1, 4, 1 },
-  { 0, 4, 1 },
-  { 1, 4, 4 },
-  { 0, 4, 4 },
-  { 5, 4, 0 },
-  { 4, 4, 0 },
-  { 3, 4, 0 },
-  { 2, 4, 0 },
-  { 1, 4, 0 },
-  { 0, 4, 0 },
-  { 3, 3, 0 },
-  { 2, 3, 0 },
-  { 5, 3, 3 },
-  { 4, 3, 3 },
-  { 3, 3, 3 },
-  { 2, 3, 3 },
-  { 1, 3, 1 },
-  { 0, 3, 1 },
-  { 1, 3, 3 },
-  { 0, 3, 3 },
-  { 5, 3, 2 },
-  { 4, 3, 2 },
-  { 3, 3, 2 },
-  { 2, 3, 2 },
-  { 1, 3, 2 },
-  { 0, 3, 2 },
-  { 3, 3, 1 },
-  { 2, 3, 1 },
-  { 5, 3, 5 },
-  { 4, 3, 5 },
-  { 3, 3, 5 },
-  { 2, 3, 5 },
-  { 1, 3, 5 },
-  { 0, 3, 5 },
-  { 1, 3, 0 },
-  { 0, 3, 0 },
-  { 5, 3, 4 },
-  { 4, 3, 4 },
-  { 3, 3, 4 },
-  { 2, 3, 4 },
-  { 1, 3, 4 },
-  { 0, 3, 4 },
-  { 3, 2, 4 },
-  { 2, 2, 4 },
-  { 5, 2, 3 },
-  { 4, 2, 3 },
-  { 3, 2, 3 },
-  { 2, 2, 3 },
-  { 1, 2, 5 },
-  { 0, 2, 5 },
-  { 1, 2, 3 },
-  { 0, 2, 3 },
-  { 5, 2, 2 },
-  { 4, 2, 2 },
-  { 3, 2, 2 },
-  { 2, 2, 2 },
-  { 1, 2, 2 },
-  { 0, 2, 2 },
-  { 3, 2, 5 },
-  { 2, 2, 5 },
-  { 5, 2, 1 },
-  { 4, 2, 1 },
-  { 3, 2, 1 },
-  { 2, 2, 1 },
-  { 1, 2, 1 },
-  { 0, 2, 1 },
-  { 1, 2, 4 },
-  { 0, 2, 4 },
-  { 5, 2, 0 },
-  { 4, 2, 0 },
-  { 3, 2, 0 },
-  { 2, 2, 0 },
-  { 1, 2, 0 },
-  { 0, 2, 0 },
-  { 3, 1, 0 },
-  { 2, 1, 0 },
-  { 5, 1, 3 },
-  { 4, 1, 3 },
-  { 3, 1, 3 },
-  { 2, 1, 3 },
-  { 1, 1, 1 },
-  { 0, 1, 1 },
-  { 1, 1, 3 },
-  { 0, 1, 3 },
-  { 5, 1, 2 },
-  { 4, 1, 2 },
-  { 3, 1, 2 },
-  { 2, 1, 2 },
-  { 1, 1, 2 },
-  { 0, 1, 2 },
-  { 3, 1, 1 },
-  { 2, 1, 1 },
-  { 5, 1, 5 },
-  { 4, 1, 5 },
-  { 3, 1, 5 },
-  { 2, 1, 5 },
-  { 1, 1, 5 },
-  { 0, 1, 5 },
-  { 1, 1, 0 },
-  { 0, 1, 0 },
-  { 5, 1, 4 },
-  { 4, 1, 4 },
-  { 3, 1, 4 },
-  { 2, 1, 4 },
-  { 1, 1, 4 },
-  { 0, 1, 4 },
-  { 3, 0, 4 },
-  { 2, 0, 4 },
-  { 5, 0, 3 },
-  { 4, 0, 3 },
-  { 3, 0, 3 },
-  { 2, 0, 3 },
-  { 1, 0, 5 },
-  { 0, 0, 5 },
-  { 1, 0, 3 },
-  { 0, 0, 3 },
-  { 5, 0, 2 },
-  { 4, 0, 2 },
-  { 3, 0, 2 },
-  { 2, 0, 2 },
-  { 1, 0, 2 },
-  { 0, 0, 2 },
-  { 3, 0, 5 },
-  { 2, 0, 5 },
-  { 5, 0, 1 },
-  { 4, 0, 1 },
-  { 3, 0, 1 },
-  { 2, 0, 1 },
-  { 1, 0, 1 },
-  { 0, 0, 1 },
-  { 1, 0, 4 },
-  { 0, 0, 4 },
-  { 5, 0, 0 },
-  { 4, 0, 0 },
-  { 3, 0, 0 },
-  { 2, 0, 0 },
-  { 1, 0, 0 },
-  { 0, 0, 0 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 },
-  { -1, -1, -1 }
-};
-
-const char tile_sn_direction_names[6][5] =
-{
-  "w",
-  "c",
-  "acc",
-  "n",
-  "e",
-  "s"
-};
-
-const signed char tile_sn_dest_map[6][6] = {
-  { -1, 3, 4, 5, 1, 2 } /* val -> w */,
-  { -1, 3, 4, 5, 0, 2 } /* val -> c */,
-  { -1, 3, 4, 5, 0, 1 } /* val -> acc */,
-  { -1, 4, 5, 0, 1, 2 } /* val -> n */,
-  { -1, 3, 5, 0, 1, 2 } /* val -> e */,
-  { -1, 3, 4, 0, 1, 2 } /* val -> s */
-};
-
 const struct tile_operand tile_operands[43] =
 {
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM8_X0), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_X0, /* insert */
-    get_Imm8_X0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_X0),
+    8, 1, 0, 0, 0, 0,
+    create_Imm8_X0, get_Imm8_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM8_X1), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_X1, /* insert */
-    get_Imm8_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_X1),
+    8, 1, 0, 0, 0, 0,
+    create_Imm8_X1, get_Imm8_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM8_Y0), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_Y0, /* insert */
-    get_Imm8_Y0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_Y0),
+    8, 1, 0, 0, 0, 0,
+    create_Imm8_Y0, get_Imm8_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM8_Y1), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_Y1, /* insert */
-    get_Imm8_Y1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM8_Y1),
+    8, 1, 0, 0, 0, 0,
+    create_Imm8_Y1, get_Imm8_Y1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM16_X0), /* default_reloc */
-    16, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm16_X0, /* insert */
-    get_Imm16_X0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM16_X0),
+    16, 1, 0, 0, 0, 0,
+    create_Imm16_X0, get_Imm16_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_IMM16_X1), /* default_reloc */
-    16, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm16_X1, /* insert */
-    get_Imm16_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_IMM16_X1),
+    16, 1, 0, 0, 0, 0,
+    create_Imm16_X1, get_Imm16_X1
   },
   {
-    TILE_OP_TYPE_ADDRESS, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_JOFFLONG_X1), /* default_reloc */
-    29, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    1, /* is_pc_relative */
-    TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES, /* rightshift */
-    create_JOffLong_X1, /* insert */
-    get_JOffLong_X1  /* extract */
+    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_JOFFLONG_X1),
+    29, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    create_JOffLong_X1, get_JOffLong_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_X0, /* insert */
-    get_Dest_X0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 0, 1, 0, 0,
+    create_Dest_X0, get_Dest_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_X0, /* insert */
-    get_SrcA_X0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcA_X0, get_SrcA_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_X1, /* insert */
-    get_Dest_X1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 0, 1, 0, 0,
+    create_Dest_X1, get_Dest_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_X1, /* insert */
-    get_SrcA_X1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcA_X1, get_SrcA_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_Y0, /* insert */
-    get_Dest_Y0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 0, 1, 0, 0,
+    create_Dest_Y0, get_Dest_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_Y0, /* insert */
-    get_SrcA_Y0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcA_Y0, get_SrcA_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_Y1, /* insert */
-    get_Dest_Y1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 0, 1, 0, 0,
+    create_Dest_Y1, get_Dest_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_Y1, /* insert */
-    get_SrcA_Y1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcA_Y1, get_SrcA_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_Y2, /* insert */
-    get_SrcA_Y2  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcA_Y2, get_SrcA_Y2
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcB_X0, /* insert */
-    get_SrcB_X0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcB_X0, get_SrcB_X0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcB_X1, /* insert */
-    get_SrcB_X1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcB_X1, get_SrcB_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcB_Y0, /* insert */
-    get_SrcB_Y0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcB_Y0, get_SrcB_Y0
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcB_Y1, /* insert */
-    get_SrcB_Y1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcB_Y1, get_SrcB_Y1
   },
   {
-    TILE_OP_TYPE_ADDRESS, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_BROFF_X1), /* default_reloc */
-    17, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    1, /* is_pc_relative */
-    TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES, /* rightshift */
-    create_BrOff_X1, /* insert */
-    get_BrOff_X1  /* extract */
+    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_BROFF_X1),
+    17, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    create_BrOff_X1, get_BrOff_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_X0, /* insert */
-    get_Dest_X0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 1, 0, 0,
+    create_Dest_X0, get_Dest_X0
   },
   {
-    TILE_OP_TYPE_ADDRESS, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    28, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    1, /* is_pc_relative */
-    TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES, /* rightshift */
-    create_JOff_X1, /* insert */
-    get_JOff_X1  /* extract */
+    TILE_OP_TYPE_ADDRESS, BFD_RELOC(NONE),
+    28, 1, 0, 0, 1, TILE_LOG2_BUNDLE_ALIGNMENT_IN_BYTES,
+    create_JOff_X1, get_JOff_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcBDest_Y2, /* insert */
-    get_SrcBDest_Y2  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 0, 1, 0, 0,
+    create_SrcBDest_Y2, get_SrcBDest_Y2
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcA_X1, /* insert */
-    get_SrcA_X1  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 1, 0, 0,
+    create_SrcA_X1, get_SrcA_X1
   },
   {
-    TILE_OP_TYPE_SPR, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MF_IMM15_X1), /* default_reloc */
-    15, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MF_Imm15_X1, /* insert */
-    get_MF_Imm15_X1  /* extract */
+    TILE_OP_TYPE_SPR, BFD_RELOC(TILE_MF_IMM15_X1),
+    15, 0, 0, 0, 0, 0,
+    create_MF_Imm15_X1, get_MF_Imm15_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MMSTART_X0), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MMStart_X0, /* insert */
-    get_MMStart_X0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMSTART_X0),
+    5, 0, 0, 0, 0, 0,
+    create_MMStart_X0, get_MMStart_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MMEND_X0), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MMEnd_X0, /* insert */
-    get_MMEnd_X0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMEND_X0),
+    5, 0, 0, 0, 0, 0,
+    create_MMEnd_X0, get_MMEnd_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MMSTART_X1), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MMStart_X1, /* insert */
-    get_MMStart_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMSTART_X1),
+    5, 0, 0, 0, 0, 0,
+    create_MMStart_X1, get_MMStart_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MMEND_X1), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MMEnd_X1, /* insert */
-    get_MMEnd_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_MMEND_X1),
+    5, 0, 0, 0, 0, 0,
+    create_MMEnd_X1, get_MMEnd_X1
   },
   {
-    TILE_OP_TYPE_SPR, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_MT_IMM15_X1), /* default_reloc */
-    15, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_MT_Imm15_X1, /* insert */
-    get_MT_Imm15_X1  /* extract */
+    TILE_OP_TYPE_SPR, BFD_RELOC(TILE_MT_IMM15_X1),
+    15, 0, 0, 0, 0, 0,
+    create_MT_Imm15_X1, get_MT_Imm15_X1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_Y0, /* insert */
-    get_Dest_Y0  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 1, 0, 0,
+    create_Dest_Y0, get_Dest_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SHAMT_X0), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_ShAmt_X0, /* insert */
-    get_ShAmt_X0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_X0),
+    5, 0, 0, 0, 0, 0,
+    create_ShAmt_X0, get_ShAmt_X0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SHAMT_X1), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_ShAmt_X1, /* insert */
-    get_ShAmt_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_X1),
+    5, 0, 0, 0, 0, 0,
+    create_ShAmt_X1, get_ShAmt_X1
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SHAMT_Y0), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_ShAmt_Y0, /* insert */
-    get_ShAmt_Y0  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_Y0),
+    5, 0, 0, 0, 0, 0,
+    create_ShAmt_Y0, get_ShAmt_Y0
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SHAMT_Y1), /* default_reloc */
-    5, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_ShAmt_Y1, /* insert */
-    get_ShAmt_Y1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SHAMT_Y1),
+    5, 0, 0, 0, 0, 0,
+    create_ShAmt_Y1, get_ShAmt_Y1
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    6, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_SrcBDest_Y2, /* insert */
-    get_SrcBDest_Y2  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    6, 0, 1, 0, 0, 0,
+    create_SrcBDest_Y2, get_SrcBDest_Y2
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_Imm8_X1, /* insert */
-    get_Dest_Imm8_X1  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(NONE),
+    8, 1, 0, 0, 0, 0,
+    create_Dest_Imm8_X1, get_Dest_Imm8_X1
   },
   {
-    TILE_OP_TYPE_ADDRESS, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SN_BROFF), /* default_reloc */
-    10, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    1, /* is_pc_relative */
-    TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES, /* rightshift */
-    create_BrOff_SN, /* insert */
-    get_BrOff_SN  /* extract */
+    TILE_OP_TYPE_ADDRESS, BFD_RELOC(TILE_SN_BROFF),
+    10, 1, 0, 0, 1, TILE_LOG2_SN_INSTRUCTION_SIZE_IN_BYTES,
+    create_BrOff_SN, get_BrOff_SN
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SN_UIMM8), /* default_reloc */
-    8, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_SN, /* insert */
-    get_Imm8_SN  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SN_UIMM8),
+    8, 0, 0, 0, 0, 0,
+    create_Imm8_SN, get_Imm8_SN
   },
   {
-    TILE_OP_TYPE_IMMEDIATE, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_TILE_SN_IMM8), /* default_reloc */
-    8, /* num_bits */
-    1, /* is_signed */
-    0, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Imm8_SN, /* insert */
-    get_Imm8_SN  /* extract */
+    TILE_OP_TYPE_IMMEDIATE, BFD_RELOC(TILE_SN_IMM8),
+    8, 1, 0, 0, 0, 0,
+    create_Imm8_SN, get_Imm8_SN
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    2, /* num_bits */
-    0, /* is_signed */
-    0, /* is_src_reg */
-    1, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Dest_SN, /* insert */
-    get_Dest_SN  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    2, 0, 0, 1, 0, 0,
+    create_Dest_SN, get_Dest_SN
   },
   {
-    TILE_OP_TYPE_REGISTER, /* type */
-    MAYBE_BFD_RELOC(BFD_RELOC_NONE), /* default_reloc */
-    2, /* num_bits */
-    0, /* is_signed */
-    1, /* is_src_reg */
-    0, /* is_dest_reg */
-    0, /* is_pc_relative */
-    0, /* rightshift */
-    create_Src_SN, /* insert */
-    get_Src_SN  /* extract */
+    TILE_OP_TYPE_REGISTER, BFD_RELOC(NONE),
+    2, 0, 1, 0, 0, 0,
+    create_Src_SN, get_Src_SN
   }
 };
 
-const struct tile_spr tile_sprs[] = {
-  { 0, "MPL_ITLB_MISS_SET_0" },
-  { 1, "MPL_ITLB_MISS_SET_1" },
-  { 2, "MPL_ITLB_MISS_SET_2" },
-  { 3, "MPL_ITLB_MISS_SET_3" },
-  { 4, "MPL_ITLB_MISS" },
-  { 256, "ITLB_CURRENT_0" },
-  { 257, "ITLB_CURRENT_1" },
-  { 258, "ITLB_CURRENT_2" },
-  { 259, "ITLB_CURRENT_3" },
-  { 260, "ITLB_INDEX" },
-  { 261, "ITLB_MATCH_0" },
-  { 262, "ITLB_PR" },
-  { 263, "NUMBER_ITLB" },
-  { 264, "REPLACEMENT_ITLB" },
-  { 265, "WIRED_ITLB" },
-  { 266, "ITLB_PERF" },
-  { 512, "MPL_MEM_ERROR_SET_0" },
-  { 513, "MPL_MEM_ERROR_SET_1" },
-  { 514, "MPL_MEM_ERROR_SET_2" },
-  { 515, "MPL_MEM_ERROR_SET_3" },
-  { 516, "MPL_MEM_ERROR" },
-  { 517, "L1_I_ERROR" },
-  { 518, "MEM_ERROR_CBOX_ADDR" },
-  { 519, "MEM_ERROR_CBOX_STATUS" },
-  { 520, "MEM_ERROR_ENABLE" },
-  { 521, "MEM_ERROR_MBOX_ADDR" },
-  { 522, "MEM_ERROR_MBOX_STATUS" },
-  { 523, "SNIC_ERROR_LOG_STATUS" },
-  { 524, "SNIC_ERROR_LOG_VA" },
-  { 525, "XDN_DEMUX_ERROR" },
-  { 1024, "MPL_ILL_SET_0" },
-  { 1025, "MPL_ILL_SET_1" },
-  { 1026, "MPL_ILL_SET_2" },
-  { 1027, "MPL_ILL_SET_3" },
-  { 1028, "MPL_ILL" },
-  { 1536, "MPL_GPV_SET_0" },
-  { 1537, "MPL_GPV_SET_1" },
-  { 1538, "MPL_GPV_SET_2" },
-  { 1539, "MPL_GPV_SET_3" },
-  { 1540, "MPL_GPV" },
-  { 1541, "GPV_REASON" },
-  { 2048, "MPL_SN_ACCESS_SET_0" },
-  { 2049, "MPL_SN_ACCESS_SET_1" },
-  { 2050, "MPL_SN_ACCESS_SET_2" },
-  { 2051, "MPL_SN_ACCESS_SET_3" },
-  { 2052, "MPL_SN_ACCESS" },
-  { 2053, "SNCTL" },
-  { 2054, "SNFIFO_DATA" },
-  { 2055, "SNFIFO_SEL" },
-  { 2056, "SNIC_INVADDR" },
-  { 2057, "SNISTATE" },
-  { 2058, "SNOSTATE" },
-  { 2059, "SNPC" },
-  { 2060, "SNSTATIC" },
-  { 2304, "SN_DATA_AVAIL" },
-  { 2560, "MPL_IDN_ACCESS_SET_0" },
-  { 2561, "MPL_IDN_ACCESS_SET_1" },
-  { 2562, "MPL_IDN_ACCESS_SET_2" },
-  { 2563, "MPL_IDN_ACCESS_SET_3" },
-  { 2564, "MPL_IDN_ACCESS" },
-  { 2565, "IDN_DEMUX_CA_COUNT" },
-  { 2566, "IDN_DEMUX_COUNT_0" },
-  { 2567, "IDN_DEMUX_COUNT_1" },
-  { 2568, "IDN_DEMUX_CTL" },
-  { 2569, "IDN_DEMUX_CURR_TAG" },
-  { 2570, "IDN_DEMUX_QUEUE_SEL" },
-  { 2571, "IDN_DEMUX_STATUS" },
-  { 2572, "IDN_DEMUX_WRITE_FIFO" },
-  { 2573, "IDN_DEMUX_WRITE_QUEUE" },
-  { 2574, "IDN_PENDING" },
-  { 2575, "IDN_SP_FIFO_DATA" },
-  { 2576, "IDN_SP_FIFO_SEL" },
-  { 2577, "IDN_SP_FREEZE" },
-  { 2578, "IDN_SP_STATE" },
-  { 2579, "IDN_TAG_0" },
-  { 2580, "IDN_TAG_1" },
-  { 2581, "IDN_TAG_VALID" },
-  { 2582, "IDN_TILE_COORD" },
-  { 2816, "IDN_CA_DATA" },
-  { 2817, "IDN_CA_REM" },
-  { 2818, "IDN_CA_TAG" },
-  { 2819, "IDN_DATA_AVAIL" },
-  { 3072, "MPL_UDN_ACCESS_SET_0" },
-  { 3073, "MPL_UDN_ACCESS_SET_1" },
-  { 3074, "MPL_UDN_ACCESS_SET_2" },
-  { 3075, "MPL_UDN_ACCESS_SET_3" },
-  { 3076, "MPL_UDN_ACCESS" },
-  { 3077, "UDN_DEMUX_CA_COUNT" },
-  { 3078, "UDN_DEMUX_COUNT_0" },
-  { 3079, "UDN_DEMUX_COUNT_1" },
-  { 3080, "UDN_DEMUX_COUNT_2" },
-  { 3081, "UDN_DEMUX_COUNT_3" },
-  { 3082, "UDN_DEMUX_CTL" },
-  { 3083, "UDN_DEMUX_CURR_TAG" },
-  { 3084, "UDN_DEMUX_QUEUE_SEL" },
-  { 3085, "UDN_DEMUX_STATUS" },
-  { 3086, "UDN_DEMUX_WRITE_FIFO" },
-  { 3087, "UDN_DEMUX_WRITE_QUEUE" },
-  { 3088, "UDN_PENDING" },
-  { 3089, "UDN_SP_FIFO_DATA" },
-  { 3090, "UDN_SP_FIFO_SEL" },
-  { 3091, "UDN_SP_FREEZE" },
-  { 3092, "UDN_SP_STATE" },
-  { 3093, "UDN_TAG_0" },
-  { 3094, "UDN_TAG_1" },
-  { 3095, "UDN_TAG_2" },
-  { 3096, "UDN_TAG_3" },
-  { 3097, "UDN_TAG_VALID" },
-  { 3098, "UDN_TILE_COORD" },
-  { 3328, "UDN_CA_DATA" },
-  { 3329, "UDN_CA_REM" },
-  { 3330, "UDN_CA_TAG" },
-  { 3331, "UDN_DATA_AVAIL" },
-  { 3584, "MPL_IDN_REFILL_SET_0" },
-  { 3585, "MPL_IDN_REFILL_SET_1" },
-  { 3586, "MPL_IDN_REFILL_SET_2" },
-  { 3587, "MPL_IDN_REFILL_SET_3" },
-  { 3588, "MPL_IDN_REFILL" },
-  { 3589, "IDN_REFILL_EN" },
-  { 4096, "MPL_UDN_REFILL_SET_0" },
-  { 4097, "MPL_UDN_REFILL_SET_1" },
-  { 4098, "MPL_UDN_REFILL_SET_2" },
-  { 4099, "MPL_UDN_REFILL_SET_3" },
-  { 4100, "MPL_UDN_REFILL" },
-  { 4101, "UDN_REFILL_EN" },
-  { 4608, "MPL_IDN_COMPLETE_SET_0" },
-  { 4609, "MPL_IDN_COMPLETE_SET_1" },
-  { 4610, "MPL_IDN_COMPLETE_SET_2" },
-  { 4611, "MPL_IDN_COMPLETE_SET_3" },
-  { 4612, "MPL_IDN_COMPLETE" },
-  { 4613, "IDN_REMAINING" },
-  { 5120, "MPL_UDN_COMPLETE_SET_0" },
-  { 5121, "MPL_UDN_COMPLETE_SET_1" },
-  { 5122, "MPL_UDN_COMPLETE_SET_2" },
-  { 5123, "MPL_UDN_COMPLETE_SET_3" },
-  { 5124, "MPL_UDN_COMPLETE" },
-  { 5125, "UDN_REMAINING" },
-  { 5632, "MPL_SWINT_3_SET_0" },
-  { 5633, "MPL_SWINT_3_SET_1" },
-  { 5634, "MPL_SWINT_3_SET_2" },
-  { 5635, "MPL_SWINT_3_SET_3" },
-  { 5636, "MPL_SWINT_3" },
-  { 6144, "MPL_SWINT_2_SET_0" },
-  { 6145, "MPL_SWINT_2_SET_1" },
-  { 6146, "MPL_SWINT_2_SET_2" },
-  { 6147, "MPL_SWINT_2_SET_3" },
-  { 6148, "MPL_SWINT_2" },
-  { 6656, "MPL_SWINT_1_SET_0" },
-  { 6657, "MPL_SWINT_1_SET_1" },
-  { 6658, "MPL_SWINT_1_SET_2" },
-  { 6659, "MPL_SWINT_1_SET_3" },
-  { 6660, "MPL_SWINT_1" },
-  { 7168, "MPL_SWINT_0_SET_0" },
-  { 7169, "MPL_SWINT_0_SET_1" },
-  { 7170, "MPL_SWINT_0_SET_2" },
-  { 7171, "MPL_SWINT_0_SET_3" },
-  { 7172, "MPL_SWINT_0" },
-  { 7680, "MPL_UNALIGN_DATA_SET_0" },
-  { 7681, "MPL_UNALIGN_DATA_SET_1" },
-  { 7682, "MPL_UNALIGN_DATA_SET_2" },
-  { 7683, "MPL_UNALIGN_DATA_SET_3" },
-  { 7684, "MPL_UNALIGN_DATA" },
-  { 8192, "MPL_DTLB_MISS_SET_0" },
-  { 8193, "MPL_DTLB_MISS_SET_1" },
-  { 8194, "MPL_DTLB_MISS_SET_2" },
-  { 8195, "MPL_DTLB_MISS_SET_3" },
-  { 8196, "MPL_DTLB_MISS" },
-  { 8448, "AER_0" },
-  { 8449, "AER_1" },
-  { 8450, "DTLB_BAD_ADDR" },
-  { 8451, "DTLB_BAD_ADDR_REASON" },
-  { 8452, "DTLB_CURRENT_0" },
-  { 8453, "DTLB_CURRENT_1" },
-  { 8454, "DTLB_CURRENT_2" },
-  { 8455, "DTLB_CURRENT_3" },
-  { 8456, "DTLB_INDEX" },
-  { 8457, "DTLB_MATCH_0" },
-  { 8458, "NUMBER_DTLB" },
-  { 8459, "PHYSICAL_MEMORY_MODE" },
-  { 8460, "REPLACEMENT_DTLB" },
-  { 8461, "WIRED_DTLB" },
-  { 8462, "CACHE_RED_WAY_OVERRIDDEN" },
-  { 8463, "DTLB_PERF" },
-  { 8704, "MPL_DTLB_ACCESS_SET_0" },
-  { 8705, "MPL_DTLB_ACCESS_SET_1" },
-  { 8706, "MPL_DTLB_ACCESS_SET_2" },
-  { 8707, "MPL_DTLB_ACCESS_SET_3" },
-  { 8708, "MPL_DTLB_ACCESS" },
-  { 9216, "MPL_DMATLB_MISS_SET_0" },
-  { 9217, "MPL_DMATLB_MISS_SET_1" },
-  { 9218, "MPL_DMATLB_MISS_SET_2" },
-  { 9219, "MPL_DMATLB_MISS_SET_3" },
-  { 9220, "MPL_DMATLB_MISS" },
-  { 9472, "DMA_BAD_ADDR" },
-  { 9473, "DMA_STATUS" },
-  { 9728, "MPL_DMATLB_ACCESS_SET_0" },
-  { 9729, "MPL_DMATLB_ACCESS_SET_1" },
-  { 9730, "MPL_DMATLB_ACCESS_SET_2" },
-  { 9731, "MPL_DMATLB_ACCESS_SET_3" },
-  { 9732, "MPL_DMATLB_ACCESS" },
-  { 10240, "MPL_SNITLB_MISS_SET_0" },
-  { 10241, "MPL_SNITLB_MISS_SET_1" },
-  { 10242, "MPL_SNITLB_MISS_SET_2" },
-  { 10243, "MPL_SNITLB_MISS_SET_3" },
-  { 10244, "MPL_SNITLB_MISS" },
-  { 10245, "NUMBER_SNITLB" },
-  { 10246, "REPLACEMENT_SNITLB" },
-  { 10247, "SNITLB_CURRENT_0" },
-  { 10248, "SNITLB_CURRENT_1" },
-  { 10249, "SNITLB_CURRENT_2" },
-  { 10250, "SNITLB_CURRENT_3" },
-  { 10251, "SNITLB_INDEX" },
-  { 10252, "SNITLB_MATCH_0" },
-  { 10253, "SNITLB_PR" },
-  { 10254, "WIRED_SNITLB" },
-  { 10255, "SNITLB_STATUS" },
-  { 10752, "MPL_SN_NOTIFY_SET_0" },
-  { 10753, "MPL_SN_NOTIFY_SET_1" },
-  { 10754, "MPL_SN_NOTIFY_SET_2" },
-  { 10755, "MPL_SN_NOTIFY_SET_3" },
-  { 10756, "MPL_SN_NOTIFY" },
-  { 10757, "SN_NOTIFY_STATUS" },
-  { 11264, "MPL_SN_FIREWALL_SET_0" },
-  { 11265, "MPL_SN_FIREWALL_SET_1" },
-  { 11266, "MPL_SN_FIREWALL_SET_2" },
-  { 11267, "MPL_SN_FIREWALL_SET_3" },
-  { 11268, "MPL_SN_FIREWALL" },
-  { 11269, "SN_DIRECTION_PROTECT" },
-  { 11776, "MPL_IDN_FIREWALL_SET_0" },
-  { 11777, "MPL_IDN_FIREWALL_SET_1" },
-  { 11778, "MPL_IDN_FIREWALL_SET_2" },
-  { 11779, "MPL_IDN_FIREWALL_SET_3" },
-  { 11780, "MPL_IDN_FIREWALL" },
-  { 11781, "IDN_DIRECTION_PROTECT" },
-  { 12288, "MPL_UDN_FIREWALL_SET_0" },
-  { 12289, "MPL_UDN_FIREWALL_SET_1" },
-  { 12290, "MPL_UDN_FIREWALL_SET_2" },
-  { 12291, "MPL_UDN_FIREWALL_SET_3" },
-  { 12292, "MPL_UDN_FIREWALL" },
-  { 12293, "UDN_DIRECTION_PROTECT" },
-  { 12800, "MPL_TILE_TIMER_SET_0" },
-  { 12801, "MPL_TILE_TIMER_SET_1" },
-  { 12802, "MPL_TILE_TIMER_SET_2" },
-  { 12803, "MPL_TILE_TIMER_SET_3" },
-  { 12804, "MPL_TILE_TIMER" },
-  { 12805, "TILE_TIMER_CONTROL" },
-  { 13312, "MPL_IDN_TIMER_SET_0" },
-  { 13313, "MPL_IDN_TIMER_SET_1" },
-  { 13314, "MPL_IDN_TIMER_SET_2" },
-  { 13315, "MPL_IDN_TIMER_SET_3" },
-  { 13316, "MPL_IDN_TIMER" },
-  { 13317, "IDN_DEADLOCK_COUNT" },
-  { 13318, "IDN_DEADLOCK_TIMEOUT" },
-  { 13824, "MPL_UDN_TIMER_SET_0" },
-  { 13825, "MPL_UDN_TIMER_SET_1" },
-  { 13826, "MPL_UDN_TIMER_SET_2" },
-  { 13827, "MPL_UDN_TIMER_SET_3" },
-  { 13828, "MPL_UDN_TIMER" },
-  { 13829, "UDN_DEADLOCK_COUNT" },
-  { 13830, "UDN_DEADLOCK_TIMEOUT" },
-  { 14336, "MPL_DMA_NOTIFY_SET_0" },
-  { 14337, "MPL_DMA_NOTIFY_SET_1" },
-  { 14338, "MPL_DMA_NOTIFY_SET_2" },
-  { 14339, "MPL_DMA_NOTIFY_SET_3" },
-  { 14340, "MPL_DMA_NOTIFY" },
-  { 14592, "DMA_BYTE" },
-  { 14593, "DMA_CHUNK_SIZE" },
-  { 14594, "DMA_CTR" },
-  { 14595, "DMA_DST_ADDR" },
-  { 14596, "DMA_DST_CHUNK_ADDR" },
-  { 14597, "DMA_SRC_ADDR" },
-  { 14598, "DMA_SRC_CHUNK_ADDR" },
-  { 14599, "DMA_STRIDE" },
-  { 14600, "DMA_USER_STATUS" },
-  { 14848, "MPL_IDN_CA_SET_0" },
-  { 14849, "MPL_IDN_CA_SET_1" },
-  { 14850, "MPL_IDN_CA_SET_2" },
-  { 14851, "MPL_IDN_CA_SET_3" },
-  { 14852, "MPL_IDN_CA" },
-  { 15360, "MPL_UDN_CA_SET_0" },
-  { 15361, "MPL_UDN_CA_SET_1" },
-  { 15362, "MPL_UDN_CA_SET_2" },
-  { 15363, "MPL_UDN_CA_SET_3" },
-  { 15364, "MPL_UDN_CA" },
-  { 15872, "MPL_IDN_AVAIL_SET_0" },
-  { 15873, "MPL_IDN_AVAIL_SET_1" },
-  { 15874, "MPL_IDN_AVAIL_SET_2" },
-  { 15875, "MPL_IDN_AVAIL_SET_3" },
-  { 15876, "MPL_IDN_AVAIL" },
-  { 15877, "IDN_AVAIL_EN" },
-  { 16384, "MPL_UDN_AVAIL_SET_0" },
-  { 16385, "MPL_UDN_AVAIL_SET_1" },
-  { 16386, "MPL_UDN_AVAIL_SET_2" },
-  { 16387, "MPL_UDN_AVAIL_SET_3" },
-  { 16388, "MPL_UDN_AVAIL" },
-  { 16389, "UDN_AVAIL_EN" },
-  { 16896, "MPL_PERF_COUNT_SET_0" },
-  { 16897, "MPL_PERF_COUNT_SET_1" },
-  { 16898, "MPL_PERF_COUNT_SET_2" },
-  { 16899, "MPL_PERF_COUNT_SET_3" },
-  { 16900, "MPL_PERF_COUNT" },
-  { 16901, "PERF_COUNT_0" },
-  { 16902, "PERF_COUNT_1" },
-  { 16903, "PERF_COUNT_CTL" },
-  { 16904, "PERF_COUNT_STS" },
-  { 16905, "WATCH_CTL" },
-  { 16906, "WATCH_MASK" },
-  { 16907, "WATCH_VAL" },
-  { 16912, "PERF_COUNT_DN_CTL" },
-  { 17408, "MPL_INTCTRL_3_SET_0" },
-  { 17409, "MPL_INTCTRL_3_SET_1" },
-  { 17410, "MPL_INTCTRL_3_SET_2" },
-  { 17411, "MPL_INTCTRL_3_SET_3" },
-  { 17412, "MPL_INTCTRL_3" },
-  { 17413, "EX_CONTEXT_3_0" },
-  { 17414, "EX_CONTEXT_3_1" },
-  { 17415, "INTERRUPT_MASK_3_0" },
-  { 17416, "INTERRUPT_MASK_3_1" },
-  { 17417, "INTERRUPT_MASK_RESET_3_0" },
-  { 17418, "INTERRUPT_MASK_RESET_3_1" },
-  { 17419, "INTERRUPT_MASK_SET_3_0" },
-  { 17420, "INTERRUPT_MASK_SET_3_1" },
-  { 17432, "INTCTRL_3_STATUS" },
-  { 17664, "SYSTEM_SAVE_3_0" },
-  { 17665, "SYSTEM_SAVE_3_1" },
-  { 17666, "SYSTEM_SAVE_3_2" },
-  { 17667, "SYSTEM_SAVE_3_3" },
-  { 17920, "MPL_INTCTRL_2_SET_0" },
-  { 17921, "MPL_INTCTRL_2_SET_1" },
-  { 17922, "MPL_INTCTRL_2_SET_2" },
-  { 17923, "MPL_INTCTRL_2_SET_3" },
-  { 17924, "MPL_INTCTRL_2" },
-  { 17925, "EX_CONTEXT_2_0" },
-  { 17926, "EX_CONTEXT_2_1" },
-  { 17927, "INTCTRL_2_STATUS" },
-  { 17928, "INTERRUPT_MASK_2_0" },
-  { 17929, "INTERRUPT_MASK_2_1" },
-  { 17930, "INTERRUPT_MASK_RESET_2_0" },
-  { 17931, "INTERRUPT_MASK_RESET_2_1" },
-  { 17932, "INTERRUPT_MASK_SET_2_0" },
-  { 17933, "INTERRUPT_MASK_SET_2_1" },
-  { 18176, "SYSTEM_SAVE_2_0" },
-  { 18177, "SYSTEM_SAVE_2_1" },
-  { 18178, "SYSTEM_SAVE_2_2" },
-  { 18179, "SYSTEM_SAVE_2_3" },
-  { 18432, "MPL_INTCTRL_1_SET_0" },
-  { 18433, "MPL_INTCTRL_1_SET_1" },
-  { 18434, "MPL_INTCTRL_1_SET_2" },
-  { 18435, "MPL_INTCTRL_1_SET_3" },
-  { 18436, "MPL_INTCTRL_1" },
-  { 18437, "EX_CONTEXT_1_0" },
-  { 18438, "EX_CONTEXT_1_1" },
-  { 18439, "INTCTRL_1_STATUS" },
-  { 18440, "INTCTRL_3_STATUS_REV0" },
-  { 18441, "INTERRUPT_MASK_1_0" },
-  { 18442, "INTERRUPT_MASK_1_1" },
-  { 18443, "INTERRUPT_MASK_RESET_1_0" },
-  { 18444, "INTERRUPT_MASK_RESET_1_1" },
-  { 18445, "INTERRUPT_MASK_SET_1_0" },
-  { 18446, "INTERRUPT_MASK_SET_1_1" },
-  { 18688, "SYSTEM_SAVE_1_0" },
-  { 18689, "SYSTEM_SAVE_1_1" },
-  { 18690, "SYSTEM_SAVE_1_2" },
-  { 18691, "SYSTEM_SAVE_1_3" },
-  { 18944, "MPL_INTCTRL_0_SET_0" },
-  { 18945, "MPL_INTCTRL_0_SET_1" },
-  { 18946, "MPL_INTCTRL_0_SET_2" },
-  { 18947, "MPL_INTCTRL_0_SET_3" },
-  { 18948, "MPL_INTCTRL_0" },
-  { 18949, "EX_CONTEXT_0_0" },
-  { 18950, "EX_CONTEXT_0_1" },
-  { 18951, "INTCTRL_0_STATUS" },
-  { 18952, "INTERRUPT_MASK_0_0" },
-  { 18953, "INTERRUPT_MASK_0_1" },
-  { 18954, "INTERRUPT_MASK_RESET_0_0" },
-  { 18955, "INTERRUPT_MASK_RESET_0_1" },
-  { 18956, "INTERRUPT_MASK_SET_0_0" },
-  { 18957, "INTERRUPT_MASK_SET_0_1" },
-  { 19200, "SYSTEM_SAVE_0_0" },
-  { 19201, "SYSTEM_SAVE_0_1" },
-  { 19202, "SYSTEM_SAVE_0_2" },
-  { 19203, "SYSTEM_SAVE_0_3" },
-  { 19456, "MPL_BOOT_ACCESS_SET_0" },
-  { 19457, "MPL_BOOT_ACCESS_SET_1" },
-  { 19458, "MPL_BOOT_ACCESS_SET_2" },
-  { 19459, "MPL_BOOT_ACCESS_SET_3" },
-  { 19460, "MPL_BOOT_ACCESS" },
-  { 19461, "CBOX_CACHEASRAM_CONFIG" },
-  { 19462, "CBOX_CACHE_CONFIG" },
-  { 19463, "CBOX_MMAP_0" },
-  { 19464, "CBOX_MMAP_1" },
-  { 19465, "CBOX_MMAP_2" },
-  { 19466, "CBOX_MMAP_3" },
-  { 19467, "CBOX_MSR" },
-  { 19468, "CBOX_SRC_ID" },
-  { 19469, "CYCLE_HIGH_MODIFY" },
-  { 19470, "CYCLE_LOW_MODIFY" },
-  { 19471, "DIAG_BCST_CTL" },
-  { 19472, "DIAG_BCST_MASK" },
-  { 19473, "DIAG_BCST_TRIGGER" },
-  { 19474, "DIAG_MUX_CTL" },
-  { 19475, "DIAG_TRACE_CTL" },
-  { 19476, "DIAG_TRACE_STS" },
-  { 19477, "IDN_DEMUX_BUF_THRESH" },
-  { 19478, "SBOX_CONFIG" },
-  { 19479, "TILE_COORD" },
-  { 19480, "UDN_DEMUX_BUF_THRESH" },
-  { 19481, "CBOX_HOME_MAP_ADDR" },
-  { 19482, "CBOX_HOME_MAP_DATA" },
-  { 19483, "CBOX_MSR1" },
-  { 19484, "BIG_ENDIAN_CONFIG" },
-  { 19485, "MEM_STRIPE_CONFIG" },
-  { 19486, "DIAG_TRACE_WAY" },
-  { 19487, "VDN_SNOOP_SHIM_CTL" },
-  { 19488, "PERF_COUNT_PLS" },
-  { 19489, "DIAG_TRACE_DATA" },
-  { 19712, "I_AER_0" },
-  { 19713, "I_AER_1" },
-  { 19714, "I_PHYSICAL_MEMORY_MODE" },
-  { 19968, "MPL_WORLD_ACCESS_SET_0" },
-  { 19969, "MPL_WORLD_ACCESS_SET_1" },
-  { 19970, "MPL_WORLD_ACCESS_SET_2" },
-  { 19971, "MPL_WORLD_ACCESS_SET_3" },
-  { 19972, "MPL_WORLD_ACCESS" },
-  { 19973, "SIM_SOCKET" },
-  { 19974, "CYCLE_HIGH" },
-  { 19975, "CYCLE_LOW" },
-  { 19976, "DONE" },
-  { 19977, "FAIL" },
-  { 19978, "INTERRUPT_CRITICAL_SECTION" },
-  { 19979, "PASS" },
-  { 19980, "SIM_CONTROL" },
-  { 19981, "EVENT_BEGIN" },
-  { 19982, "EVENT_END" },
-  { 19983, "TILE_WRITE_PENDING" },
-  { 19984, "TILE_RTF_HWM" },
-  { 20224, "PROC_STATUS" },
-  { 20225, "STATUS_SATURATE" },
-  { 20480, "MPL_I_ASID_SET_0" },
-  { 20481, "MPL_I_ASID_SET_1" },
-  { 20482, "MPL_I_ASID_SET_2" },
-  { 20483, "MPL_I_ASID_SET_3" },
-  { 20484, "MPL_I_ASID" },
-  { 20485, "I_ASID" },
-  { 20992, "MPL_D_ASID_SET_0" },
-  { 20993, "MPL_D_ASID_SET_1" },
-  { 20994, "MPL_D_ASID_SET_2" },
-  { 20995, "MPL_D_ASID_SET_3" },
-  { 20996, "MPL_D_ASID" },
-  { 20997, "D_ASID" },
-  { 21504, "MPL_DMA_ASID_SET_0" },
-  { 21505, "MPL_DMA_ASID_SET_1" },
-  { 21506, "MPL_DMA_ASID_SET_2" },
-  { 21507, "MPL_DMA_ASID_SET_3" },
-  { 21508, "MPL_DMA_ASID" },
-  { 21509, "DMA_ASID" },
-  { 22016, "MPL_SNI_ASID_SET_0" },
-  { 22017, "MPL_SNI_ASID_SET_1" },
-  { 22018, "MPL_SNI_ASID_SET_2" },
-  { 22019, "MPL_SNI_ASID_SET_3" },
-  { 22020, "MPL_SNI_ASID" },
-  { 22021, "SNI_ASID" },
-  { 22528, "MPL_DMA_CPL_SET_0" },
-  { 22529, "MPL_DMA_CPL_SET_1" },
-  { 22530, "MPL_DMA_CPL_SET_2" },
-  { 22531, "MPL_DMA_CPL_SET_3" },
-  { 22532, "MPL_DMA_CPL" },
-  { 23040, "MPL_SN_CPL_SET_0" },
-  { 23041, "MPL_SN_CPL_SET_1" },
-  { 23042, "MPL_SN_CPL_SET_2" },
-  { 23043, "MPL_SN_CPL_SET_3" },
-  { 23044, "MPL_SN_CPL" },
-  { 23552, "MPL_DOUBLE_FAULT_SET_0" },
-  { 23553, "MPL_DOUBLE_FAULT_SET_1" },
-  { 23554, "MPL_DOUBLE_FAULT_SET_2" },
-  { 23555, "MPL_DOUBLE_FAULT_SET_3" },
-  { 23556, "MPL_DOUBLE_FAULT" },
-  { 23557, "LAST_INTERRUPT_REASON" },
-  { 24064, "MPL_SN_STATIC_ACCESS_SET_0" },
-  { 24065, "MPL_SN_STATIC_ACCESS_SET_1" },
-  { 24066, "MPL_SN_STATIC_ACCESS_SET_2" },
-  { 24067, "MPL_SN_STATIC_ACCESS_SET_3" },
-  { 24068, "MPL_SN_STATIC_ACCESS" },
-  { 24069, "SN_STATIC_CTL" },
-  { 24070, "SN_STATIC_FIFO_DATA" },
-  { 24071, "SN_STATIC_FIFO_SEL" },
-  { 24073, "SN_STATIC_ISTATE" },
-  { 24074, "SN_STATIC_OSTATE" },
-  { 24076, "SN_STATIC_STATIC" },
-  { 24320, "SN_STATIC_DATA_AVAIL" },
-  { 24576, "MPL_AUX_PERF_COUNT_SET_0" },
-  { 24577, "MPL_AUX_PERF_COUNT_SET_1" },
-  { 24578, "MPL_AUX_PERF_COUNT_SET_2" },
-  { 24579, "MPL_AUX_PERF_COUNT_SET_3" },
-  { 24580, "MPL_AUX_PERF_COUNT" },
-  { 24581, "AUX_PERF_COUNT_0" },
-  { 24582, "AUX_PERF_COUNT_1" },
-  { 24583, "AUX_PERF_COUNT_CTL" },
-  { 24584, "AUX_PERF_COUNT_STS" },
-};
-
-const int tile_num_sprs = 499;
-
-
 
 
-/* Canonical name of each register. */
-const char *const tile_register_names[] =
-{
-  "r0",   "r1",  "r2",  "r3",  "r4",  "r5",  "r6",  "r7",
-  "r8",   "r9",  "r10", "r11", "r12", "r13", "r14", "r15",
-  "r16",  "r17", "r18", "r19", "r20", "r21", "r22", "r23",
-  "r24",  "r25", "r26", "r27", "r28", "r29", "r30", "r31",
-  "r32",  "r33", "r34", "r35", "r36", "r37", "r38", "r39",
-  "r40",  "r41", "r42", "r43", "r44", "r45", "r46", "r47",
-  "r48",  "r49", "r50", "r51", "r52", "tp",  "sp",  "lr",
-  "sn",  "idn0", "idn1", "udn0", "udn1", "udn2", "udn3", "zero"
-};
-
 
 /* Given a set of bundle bits and the lookup FSM for a specific pipe,
  * returns which instruction the bundle contains in that pipe.
-- 
1.6.5.2

