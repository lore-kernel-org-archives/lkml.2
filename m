Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2DTVaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:30:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62736 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2DTVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:30:07 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <mingo@redhat.com>, <masami.hiramatsu.pt@hitachi.com>,
        <rusty@rustcorp.com.au>
Subject: [RFC PATCH 3/8] readelf: emit simple to parse line .debug_line data
Date: Fri, 20 Apr 2012 16:29:49 -0500
Message-ID: <1334957394-12086-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quiet option was added so as to emit only the following data when
running readelf.  Example:

scripts/readelf -q --debug-dump=line vmlinux
[...]
sched.c:45 0xffffffff81011e79
sched.c:49 0xffffffff81011e80

It is important to leave the original printfs behind as they are
required in order to debug problems related to parsing the debug line
data.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 scripts/readelf.c |  218 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 164 insertions(+), 54 deletions(-)

diff --git a/scripts/readelf.c b/scripts/readelf.c
index 6ed944f..228de30 100644
--- a/scripts/readelf.c
+++ b/scripts/readelf.c
@@ -236,6 +236,7 @@ Elf_Internal_Shdr *section_headers;
 Elf_Internal_Shdr *symtab_shndx_hdr;
 int show_name;
 int do_dump;
+int do_quiet;
 int do_wide;
 int do_debug_lines;
 int is_32bit_elf;
@@ -605,6 +606,7 @@ usage ()
   fprintf (stdout, " Options are:\n\
   --debug-dump=line      Display the contents of DWARF2 debug sections\n");
   fprintf (stdout, "\
+  -q                     Only emit line number data\n\
   -W --wide              Allow output width to exceed 80 characters\n\
   -H --help              Display this information\n");
 
@@ -653,7 +655,7 @@ parse_args (argc, argv)
     usage ();
 
   while ((c = getopt_long
-	  (argc, argv, "WH", options, NULL)) != EOF)
+	  (argc, argv, "qWH", options, NULL)) != EOF)
     {
 
       switch (c)
@@ -665,6 +667,10 @@ parse_args (argc, argv)
 	  usage ();
 	  break;
 
+	case 'q':
+	  do_quiet = 1;
+	  break;
+
 	case OPTION_DEBUG_DUMP:
 	  do_dump++;
 	    {
@@ -1006,6 +1012,7 @@ process_extended_line_op (data, is_stmt, pointer_size)
   unsigned int len;
   unsigned char *name;
   unsigned long adr;
+  unsigned long val;
 
   len = read_leb128 (data, & bytes_read, 0);
   data += bytes_read;
@@ -1019,38 +1026,55 @@ process_extended_line_op (data, is_stmt, pointer_size)
   len += bytes_read;
   op_code = *data++;
 
-  printf ("  Extended opcode %d: ", op_code);
+  if (!do_quiet)
+    printf ("  Extended opcode %d: ", op_code);
 
   switch (op_code)
     {
     case DW_LNE_end_sequence:
-      printf ("End of Sequence\n\n");
+	  if (!do_quiet)
+		printf ("End of Sequence\n\n");
       reset_state_machine (is_stmt);
       break;
 
     case DW_LNE_set_address:
       adr = byte_get (data, pointer_size);
-      printf ("set Address to 0x%lx\n", adr);
+	  if (!do_quiet)
+		printf ("set Address to 0x%lx\n", adr);
       state_machine_regs.address = adr;
       break;
 
     case DW_LNE_define_file:
-      printf ("  define new File Table entry\n");
-      printf ("  Entry\tDir\tTime\tSize\tName\n");
+	  if (!do_quiet)
+	    {
+		  printf ("  define new File Table entry\n");
+		  printf ("  Entry\tDir\tTime\tSize\tName\n");
+		}
 
-      printf ("   %d\t", ++state_machine_regs.last_file_entry);
+	  ++state_machine_regs.last_file_entry;
+	  if (!do_quiet)
+		printf ("   %d\t", state_machine_regs.last_file_entry);
       name = data;
       data += strlen ((char *) data) + 1;
-      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
+	  val = read_leb128 (data, & bytes_read, 0);
+	  if (!do_quiet)
+		printf ("%lu\t", val);
       data += bytes_read;
-      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
+	  val = read_leb128 (data, & bytes_read, 0);
+	  if (!do_quiet)
+		printf ("%lu\t", val);
       data += bytes_read;
-      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
-      printf ("%s\n\n", name);
+	  val = read_leb128 (data, & bytes_read, 0);
+	  if (!do_quiet)
+	    {
+		  printf ("%lu\t", val);
+		  printf ("%s\n\n", name);
+		}
       break;
 
     default:
-      printf ("UNKNOWN: length %d\n", len - bytes_read);
+	  if (!do_quiet)
+		printf ("UNKNOWN: length %d\n", len - bytes_read);
       break;
     }
 
@@ -1074,11 +1098,15 @@ display_debug_lines (section, start, file)
   unsigned char *data = start;
   unsigned char *end = start + section->sh_size;
   unsigned char *end_of_sequence;
+  unsigned int max_ftable = 0;
+  unsigned char **ftable = NULL;
+
   int i;
   int offset_size;
   int initial_length_size;
 
-  printf ("\nDump of debug contents of section %s:\n\n",
+  if (!do_quiet)
+    printf ("\nDump of debug contents of section %s:\n\n",
 	  SECTION_NAME (section));
 
   while (data < end)
@@ -1136,14 +1164,17 @@ display_debug_lines (section, start, file)
       info.li_line_base <<= 24;
       info.li_line_base >>= 24;
 
-      printf ("  Length:                      %ld\n", info.li_length);
-      printf ("  DWARF Version:               %d\n", info.li_version);
-      printf ("  Prologue Length:             %d\n", info.li_prologue_length);
-      printf ("  Minimum Instruction Length:  %d\n", info.li_min_insn_length);
-      printf ("  Initial value of 'is_stmt':  %d\n", info.li_default_is_stmt);
-      printf ("  Line Base:                   %d\n", info.li_line_base);
-      printf ("  Line Range:                  %d\n", info.li_line_range);
-      printf ("  Opcode Base:                 %d\n", info.li_opcode_base);
+      if (!do_quiet)
+        {
+	  printf ("  Length:                      %ld\n", info.li_length);
+	  printf ("  DWARF Version:               %d\n", info.li_version);
+	  printf ("  Prologue Length:             %d\n", info.li_prologue_length);
+	  printf ("  Minimum Instruction Length:  %d\n", info.li_min_insn_length);
+	  printf ("  Initial value of 'is_stmt':  %d\n", info.li_default_is_stmt);
+	  printf ("  Line Base:                   %d\n", info.li_line_base);
+	  printf ("  Line Range:                  %d\n", info.li_line_range);
+	  printf ("  Opcode Base:                 %d\n", info.li_opcode_base);
+	}
 
       end_of_sequence = data + info.li_length + initial_length_size;
 
@@ -1152,23 +1183,30 @@ display_debug_lines (section, start, file)
       /* Display the contents of the Opcodes table.  */
       standard_opcodes = hdrptr;
 
-      printf ("\n Opcodes:\n");
+      if (!do_quiet) {
+	printf ("\n Opcodes:\n");
 
-      for (i = 1; i < info.li_opcode_base; i++)
-	printf ("  Opcode %d has %d args\n", i, standard_opcodes[i - 1]);
+        for (i = 1; i < info.li_opcode_base; i++)
+	  printf ("  Opcode %d has %d args\n", i, standard_opcodes[i - 1]);
+      }
 
       /* Display the contents of the Directory table.  */
       data = standard_opcodes + info.li_opcode_base - 1;
 
       if (*data == 0)
-	printf ("\n The Directory Table is empty.\n");
+        {
+	  if (!do_quiet)
+	    printf ("\n The Directory Table is empty.\n");
+        }
       else
 	{
-	  printf ("\n The Directory Table:\n");
+	  if (!do_quiet)
+	    printf ("\n The Directory Table:\n");
 
 	  while (*data != 0)
 	    {
-	      printf ("  %s\n", data);
+	      if (!do_quiet)
+	        printf ("  %s\n", data);
 
 	      data += strlen ((char *) data) + 1;
 	    }
@@ -1177,31 +1215,81 @@ display_debug_lines (section, start, file)
       /* Skip the NUL at the end of the table.  */
       data++;
 
+      if (ftable)
+        {
+	  while (max_ftable)
+	    {
+	      max_ftable--;
+	      free(ftable[max_ftable]);
+	    }
+	  free(ftable);
+	  ftable = NULL;
+	}
+      max_ftable = 0;
       /* Display the contents of the File Name table.  */
       if (*data == 0)
-	printf ("\n The File Name Table is empty.\n");
+        {
+	  if (!do_quiet)
+	    printf ("\n The File Name Table is empty.\n");
+	}
       else
 	{
-	  printf ("\n The File Name Table:\n");
-	  printf ("  Entry\tDir\tTime\tSize\tName\n");
+	  unsigned char *data_reset = data;
+	  if (!do_quiet)
+	    {
+	      printf ("\n The File Name Table:\n");
+	      printf ("  Entry\tDir\tTime\tSize\tName\n");
+	    }
 
 	  while (*data != 0)
 	    {
 	      unsigned char *name;
 	      int bytes_read;
+	      unsigned long ret;
 
-	      printf ("  %d\t", ++state_machine_regs.last_file_entry);
+	      max_ftable++;
+	      if (!do_quiet)
+	        printf ("  %d\t", ++state_machine_regs.last_file_entry);
 	      name = data;
 
 	      data += strlen ((char *) data) + 1;
 
-	      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
+	      ret =  read_leb128 (data, & bytes_read, 0);
+	      if (!do_quiet)
+	        printf ("%lu\t", ret);
+	      data += bytes_read;
+	      ret =  read_leb128 (data, & bytes_read, 0);
+	      if (!do_quiet)
+	        printf ("%lu\t", ret);
+	      data += bytes_read;
+	      ret =  read_leb128 (data, & bytes_read, 0);
+	      if (!do_quiet)
+	        printf ("%lu\t", ret);
+	      data += bytes_read;
+	      if (!do_quiet)
+	        printf ("%s\n", name);
+	    }
+	  /* Allocate file table array */
+	  ftable = malloc(sizeof(char *) * max_ftable);
+	  data = data_reset;
+	  max_ftable = 0;
+	  while (*data != 0)
+	    {
+	      int bytes_read;
+
+	      ftable[max_ftable] = (unsigned char *)strdup((char *)data);
+	      if (!ftable[max_ftable])
+		abort();
+	      max_ftable++;
+
+	      data += strlen ((char *) data) + 1;
+
+	      read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
+	      read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("%lu\t", read_leb128 (data, & bytes_read, 0));
+	      read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("%s\n", name);
 	    }
 	}
 
@@ -1209,7 +1297,8 @@ display_debug_lines (section, start, file)
       data++;
 
       /* Now display the statements.  */
-      printf ("\n Line Number Statements:\n");
+      if (!do_quiet)
+        printf ("\n Line Number Statements:\n");
 
 
       while (data < end_of_sequence)
@@ -1225,12 +1314,17 @@ display_debug_lines (section, start, file)
 	      op_code -= info.li_opcode_base;
 	      adv      = (op_code / info.li_line_range) * info.li_min_insn_length;
 	      state_machine_regs.address += adv;
-	      printf ("  Special opcode %d: advance Address by %d to 0x%lx",
+	      if (!do_quiet)
+	        printf ("  Special opcode %d: advance Address by %d to 0x%lx",
 		      op_code, adv, state_machine_regs.address);
 	      adv = (op_code % info.li_line_range) + info.li_line_base;
 	      state_machine_regs.line += adv;
-	      printf (" and Line by %d to %d\n",
+	      if (!do_quiet)
+	        printf (" and Line by %d to %d\n",
 		      adv, state_machine_regs.line);
+	      if (do_quiet)
+		printf("%s:%u 0x%lx\n", ftable[state_machine_regs.file - 1],
+state_machine_regs.line, state_machine_regs.address);
 	    }
 	  else switch (op_code)
 	    {
@@ -1240,14 +1334,16 @@ display_debug_lines (section, start, file)
 	      break;
 
 	    case DW_LNS_copy:
-	      printf ("  Copy\n");
+	      if (!do_quiet)
+	        printf ("  Copy\n");
 	      break;
 
 	    case DW_LNS_advance_pc:
 	      adv = info.li_min_insn_length * read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
 	      state_machine_regs.address += adv;
-	      printf ("  Advance PC by %d to %lx\n", adv,
+	      if (!do_quiet)
+	        printf ("  Advance PC by %d to %lx\n", adv,
 		      state_machine_regs.address);
 	      break;
 
@@ -1255,14 +1351,16 @@ display_debug_lines (section, start, file)
 	      adv = read_leb128 (data, & bytes_read, 1);
 	      data += bytes_read;
 	      state_machine_regs.line += adv;
-	      printf ("  Advance Line by %d to %d\n", adv,
+	      if (!do_quiet)
+	        printf ("  Advance Line by %d to %d\n", adv,
 		      state_machine_regs.line);
 	      break;
 
 	    case DW_LNS_set_file:
 	      adv = read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("  Set File Name to entry %d in the File Name Table\n",
+	      if (!do_quiet)
+	        printf ("  Set File Name to entry %d in the File Name Table\n",
 		      adv);
 	      state_machine_regs.file = adv;
 	      break;
@@ -1270,19 +1368,22 @@ display_debug_lines (section, start, file)
 	    case DW_LNS_set_column:
 	      adv = read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("  Set column to %d\n", adv);
+	      if (!do_quiet)
+	        printf ("  Set column to %d\n", adv);
 	      state_machine_regs.column = adv;
 	      break;
 
 	    case DW_LNS_negate_stmt:
 	      adv = state_machine_regs.is_stmt;
 	      adv = ! adv;
-	      printf ("  Set is_stmt to %d\n", adv);
+	      if (!do_quiet)
+	        printf ("  Set is_stmt to %d\n", adv);
 	      state_machine_regs.is_stmt = adv;
 	      break;
 
 	    case DW_LNS_set_basic_block:
-	      printf ("  Set basic block\n");
+	      if (!do_quiet)
+	        printf ("  Set basic block\n");
 	      state_machine_regs.basic_block = 1;
 	      break;
 
@@ -1290,7 +1391,8 @@ display_debug_lines (section, start, file)
 	      adv = (((255 - info.li_opcode_base) / info.li_line_range)
 		     * info.li_min_insn_length);
 	      state_machine_regs.address += adv;
-	      printf ("  Advance PC by constant %d to 0x%lx\n", adv,
+	      if (!do_quiet)
+	        printf ("  Advance PC by constant %d to 0x%lx\n", adv,
 		      state_machine_regs.address);
 	      break;
 
@@ -1298,40 +1400,48 @@ display_debug_lines (section, start, file)
 	      adv = byte_get (data, 2);
 	      data += 2;
 	      state_machine_regs.address += adv;
-	      printf ("  Advance PC by fixed size amount %d to 0x%lx\n",
+	      if (!do_quiet)
+	        printf ("  Advance PC by fixed size amount %d to 0x%lx\n",
 		      adv, state_machine_regs.address);
 	      break;
 
 	    case DW_LNS_set_prologue_end:
-	      printf ("  Set prologue_end to true\n");
+	      if (!do_quiet)
+	        printf ("  Set prologue_end to true\n");
 	      break;
 
 	    case DW_LNS_set_epilogue_begin:
-	      printf ("  Set epilogue_begin to true\n");
+	      if (!do_quiet)
+	        printf ("  Set epilogue_begin to true\n");
 	      break;
 
 	    case DW_LNS_set_isa:
 	      adv = read_leb128 (data, & bytes_read, 0);
 	      data += bytes_read;
-	      printf ("  Set ISA to %d\n", adv);
+	      if (!do_quiet)
+	        printf ("  Set ISA to %d\n", adv);
 	      break;
 
 	    default:
-	      printf ("  Unknown opcode %d with operands: ", op_code);
+	      if (!do_quiet)
+	        printf ("  Unknown opcode %d with operands: ", op_code);
 	      {
 		int i;
 		for (i = standard_opcodes[op_code - 1]; i > 0 ; --i)
 		  {
-		    printf ("0x%lx%s", read_leb128 (data, &bytes_read, 0),
+		    if (!do_quiet)
+		      printf ("0x%lx%s", read_leb128 (data, &bytes_read, 0),
 			    i == 1 ? "" : ", ");
 		    data += bytes_read;
 		  }
-		putchar ('\n');
+		if (!do_quiet)
+		  putchar ('\n');
 	      }
 	      break;
 	    }
 	}
-      putchar ('\n');
+      if (!do_quiet)
+        putchar ('\n');
     }
 
   return 1;
-- 
1.7.10

