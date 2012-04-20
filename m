Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2DTVaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:30:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:35354 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2DTVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:08 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 4/8] readelf: Fix dumping a 64 bit elf file on a 32 bit host
Date: Fri, 20 Apr 2012 16:29:50 -0500
Message-ID: <1334957394-12086-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want a 32bit or 64bit host to be able to process a 32bit or 64bit
elf file.  On a 32 bit host reading a 64 bit elf file, the set address
function in process_extended_line_op() was using the correct word size
but the storage variable was not properly sized.  The simple fix is to
just use bfd_vma.

After changing the size of the address, all the printf statements
needed to change to using the correctly typed format string on a 64 vs
32 bit host.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 scripts/readelf.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/scripts/readelf.c b/scripts/readelf.c
index 228de30..a21fcf7 100644
--- a/scripts/readelf.c
+++ b/scripts/readelf.c
@@ -64,10 +64,12 @@
 typedef unsigned long long bfd_vma;
 typedef unsigned long long bfd_size_type;
 typedef long long bfd_signed_vma;
+#define LSTR "0x%llx"
 #else
 typedef unsigned long bfd_vma;
 typedef unsigned long bfd_size_type;
 typedef long bfd_signed_vma;
+#define LSTR "0x%lx"
 #endif
 typedef bfd_signed_vma file_ptr;
 
@@ -971,7 +973,7 @@ read_leb128 (data, length_return, sign)
 
 typedef struct State_Machine_Registers
 {
-  unsigned long address;
+  bfd_vma address;
   unsigned int file;
   unsigned int line;
   unsigned int column;
@@ -1011,7 +1013,7 @@ process_extended_line_op (data, is_stmt, pointer_size)
   int bytes_read;
   unsigned int len;
   unsigned char *name;
-  unsigned long adr;
+  bfd_vma adr;
   unsigned long val;
 
   len = read_leb128 (data, & bytes_read, 0);
@@ -1040,7 +1042,7 @@ process_extended_line_op (data, is_stmt, pointer_size)
     case DW_LNE_set_address:
       adr = byte_get (data, pointer_size);
 	  if (!do_quiet)
-		printf ("set Address to 0x%lx\n", adr);
+		printf ("set Address to " LSTR "\n", adr);
       state_machine_regs.address = adr;
       break;
 
@@ -1315,7 +1317,7 @@ display_debug_lines (section, start, file)
 	      adv      = (op_code / info.li_line_range) * info.li_min_insn_length;
 	      state_machine_regs.address += adv;
 	      if (!do_quiet)
-	        printf ("  Special opcode %d: advance Address by %d to 0x%lx",
+	        printf ("  Special opcode %d: advance Address by %d to " LSTR,
 		      op_code, adv, state_machine_regs.address);
 	      adv = (op_code % info.li_line_range) + info.li_line_base;
 	      state_machine_regs.line += adv;
@@ -1323,7 +1325,7 @@ display_debug_lines (section, start, file)
 	        printf (" and Line by %d to %d\n",
 		      adv, state_machine_regs.line);
 	      if (do_quiet)
-		printf("%s:%u 0x%lx\n", ftable[state_machine_regs.file - 1],
+		printf("%s:%u " LSTR "\n", ftable[state_machine_regs.file - 1],
 state_machine_regs.line, state_machine_regs.address);
 	    }
 	  else switch (op_code)
@@ -1343,7 +1345,7 @@ state_machine_regs.line, state_machine_regs.address);
 	      data += bytes_read;
 	      state_machine_regs.address += adv;
 	      if (!do_quiet)
-	        printf ("  Advance PC by %d to %lx\n", adv,
+	        printf ("  Advance PC by %d to " LSTR "\n", adv,
 		      state_machine_regs.address);
 	      break;
 
@@ -1392,7 +1394,7 @@ state_machine_regs.line, state_machine_regs.address);
 		     * info.li_min_insn_length);
 	      state_machine_regs.address += adv;
 	      if (!do_quiet)
-	        printf ("  Advance PC by constant %d to 0x%lx\n", adv,
+	        printf ("  Advance PC by constant %d to " LSTR "\n", adv,
 		      state_machine_regs.address);
 	      break;
 
@@ -1401,7 +1403,7 @@ state_machine_regs.line, state_machine_regs.address);
 	      data += 2;
 	      state_machine_regs.address += adv;
 	      if (!do_quiet)
-	        printf ("  Advance PC by fixed size amount %d to 0x%lx\n",
+	        printf ("  Advance PC by fixed size amount %d to " LSTR "\n",
 		      adv, state_machine_regs.address);
 	      break;
 
-- 
1.7.10

