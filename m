Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949Ab0J1OGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:06:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51536 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843Ab0J1OF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:05:56 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=4IZcv9SPaIoA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=WPyIoOwQAAAA:8 a=meVymXHHAAAA:8 a=UrgIz8PCEjCC9hhl-1oA:9 a=EL6MFwSKViYiMEiW4EQA:7 a=1lSuG8_G6_fTbZjTeJAwH_RBYsAA:4 a=MSl-tDqOz04A:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=uyK05fF-toTcyvqE:21 a=YCwRkgOoeSXKLgD_:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101028140554.306709027@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 28 Oct 2010 10:05:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 2/3] ftrace/MIPS: Add module support for C version of recordmcount
References: <20101028140512.441043850@goodmis.org>
Content-Disposition: inline; filename=0002-ftrace-MIPS-Add-module-support-for-C-version-of-reco.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

Since MIPS modules' address space differs from the core kernel space, to access
the _mcount in the core kernel, the kernel functions in modules must use long
call (-mlong-calls): load the _mcount address into one register and jump to the
address stored by the register:

 c:  3c030000        lui     v1,0x0  <-------->  b label
           c: R_MIPS_HI16  _mcount
           c: R_MIPS_NONE  *ABS*
           c: R_MIPS_NONE  *ABS*
10:  64630000        daddiu  v1,v1,0
          10: R_MIPS_LO16 _mcount
          10: R_MIPS_NONE *ABS*
          10: R_MIPS_NONE *ABS*
14:	03e0082d 	move	at,ra
18:	0060f809 	jalr	v1
label:

In the old Perl version of recordmcount, we only need to record the position of
the 1st R_MIPS_HI16 type of _mcount, and later, in ftrace_make_nop(), replace
the instruction in this position by a "b label" and in ftrace_make_call(),
replace it back.

But, the default C version of recordmcount records all of the _mcount symbols,
so, we must filter the 2nd _mcount like the Perl version of recordmcount does.

The C version of recordmcount copes with the symbols before they are linked, So
It doesn't know the type of the symbols and therefore can not filter the
symbols as the Perl version of recordmcount does. But as we can see above, the
2nd _mcount symbols of the long call alawys follows the 1st _mcount symbol of
the same long call, which means the offset from the 1st to the 2nd is fixed, it
is 0x10-0xc = 4 here, 4 is the length of the 1st load instruciton, for MIPS has
fixed length of instructions, this offset is always 4.

And as we know, the _mcount is inserted into the entry of every kernel
function, the offset between the other _mcount's is expected to be always
bigger than 4. So, to filter the 2ns _mcount symbol of the long call, we can
simply check the offset between two _mcount symbols, If it is 4, then, filter
the 2nd _mcount symbol.

To avoid touching too much code, an 'empty' function fn_is_fake_mcount() is
added for all of the archs, and the specific archs can override it via chaning
the function pointer: is_fake_mcount in do_file() with the e_machine. e.g. This
patch adds MIPS_is_fake_mcount() to override the default fn_is_fake_mcount()
pointed by is_fake_mcount.

This fn_is_fake_mcount() checks if the _mcount symbol is fake, e.g. the 2nd
_mcount symbol of the long call is fake, for there are 2 _mcount symbols mapped
to one real mcount call, so, one of them is fake and must be filtered.

This fn_is_fake_mcount() is called in sift_rel_mcount() after finding the
_mcount symbols and before adding the _mcount symbol into mrelp, so, it can
prevent the fake mcount symbol going into the last __mcount_loc table.

Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
LKML-Reference: <b866f0138224340a132d31861fa3f9300dee30ac.1288176026.git.wuzhangjin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c |    5 +++-
 scripts/recordmcount.h |   56 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 2d32b9c..f2f32ee 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -325,8 +325,10 @@ do_file(char const *const fname)
 		}
 		if (EM_S390 == w2(ehdr->e_machine))
 			reltype = R_390_32;
-		if (EM_MIPS == w2(ehdr->e_machine))
+		if (EM_MIPS == w2(ehdr->e_machine)) {
 			reltype = R_MIPS_32;
+			is_fake_mcount32 = MIPS32_is_fake_mcount;
+		}
 		do32(ehdr, fname, reltype);
 	} break;
 	case ELFCLASS64: {
@@ -343,6 +345,7 @@ do_file(char const *const fname)
 			reltype = R_MIPS_64;
 			Elf64_r_sym = MIPS64_r_sym;
 			Elf64_r_info = MIPS64_r_info;
+			is_fake_mcount64 = MIPS64_is_fake_mcount;
 		}
 		do64(ghdr, fname, reltype);
 	} break;
diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 190fd18..58e933a 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -19,12 +19,16 @@
  * Licensed under the GNU General Public License, version 2 (GPLv2).
  */
 #undef append_func
+#undef is_fake_mcount
+#undef fn_is_fake_mcount
+#undef MIPS_is_fake_mcount
 #undef sift_rel_mcount
 #undef find_secsym_ndx
 #undef __has_rel_mcount
 #undef has_rel_mcount
 #undef tot_relsize
 #undef do_func
+#undef Elf_Addr
 #undef Elf_Ehdr
 #undef Elf_Shdr
 #undef Elf_Rel
@@ -50,6 +54,10 @@
 # define has_rel_mcount		has64_rel_mcount
 # define tot_relsize		tot64_relsize
 # define do_func		do64
+# define is_fake_mcount		is_fake_mcount64
+# define fn_is_fake_mcount	fn_is_fake_mcount64
+# define MIPS_is_fake_mcount	MIPS64_is_fake_mcount
+# define Elf_Addr		Elf64_Addr
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
 # define Elf_Rel		Elf64_Rel
@@ -74,6 +82,10 @@
 # define has_rel_mcount		has32_rel_mcount
 # define tot_relsize		tot32_relsize
 # define do_func		do32
+# define is_fake_mcount		is_fake_mcount32
+# define fn_is_fake_mcount	fn_is_fake_mcount32
+# define MIPS_is_fake_mcount	MIPS32_is_fake_mcount
+# define Elf_Addr		Elf32_Addr
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
 # define Elf_Rel		Elf32_Rel
@@ -92,7 +104,13 @@
 # define _size			4
 #endif
 
-/* Functions and pointers that 64-bit EM_MIPS can override. */
+/* Functions and pointers that do_file() may override for specific e_machine. */
+static int fn_is_fake_mcount(Elf_Rel const *rp)
+{
+	return 0;
+}
+static int (*is_fake_mcount)(Elf_Rel const *rp) = fn_is_fake_mcount;
+
 static uint_t fn_ELF_R_SYM(Elf_Rel const *rp)
 {
 	return ELF_R_SYM(_w(rp->r_info));
@@ -105,6 +123,39 @@ static void fn_ELF_R_INFO(Elf_Rel *const rp, unsigned sym, unsigned type)
 }
 static void (*Elf_r_info)(Elf_Rel *const rp, unsigned sym, unsigned type) = fn_ELF_R_INFO;
 
+/*
+ * MIPS mcount long call has 2 _mcount symbols, only the position of the 1st
+ * _mcount symbol is needed for dynamic function tracer, with it, to disable
+ * tracing(ftrace_make_nop), the instruction in the position is replaced with
+ * the "b label" instruction, to enable tracing(ftrace_make_call), replace the
+ * instruction back. So, here, we set the 2nd one as fake and filter it.
+ *
+ * c:	3c030000	lui	v1,0x0		<-->	b	label
+ *		c: R_MIPS_HI16	_mcount
+ *		c: R_MIPS_NONE	*ABS*
+ *		c: R_MIPS_NONE	*ABS*
+ * 10:	64630000	daddiu	v1,v1,0
+ *		10: R_MIPS_LO16	_mcount
+ *		10: R_MIPS_NONE	*ABS*
+ *		10: R_MIPS_NONE	*ABS*
+ * 14:	03e0082d	move	at,ra
+ * 18:	0060f809	jalr	v1
+ * label:
+ */
+#define MIPS_FAKEMCOUNT_OFFSET	4
+
+static int MIPS_is_fake_mcount(Elf_Rel const *rp)
+{
+	static Elf_Addr old_r_offset;
+	Elf_Addr current_r_offset = _w(rp->r_offset);
+	int is_fake;
+
+	is_fake = old_r_offset &&
+		(current_r_offset - old_r_offset == MIPS_FAKEMCOUNT_OFFSET);
+	old_r_offset = current_r_offset;
+
+	return is_fake;
+}
 
 /* Append the new shstrtab, Elf_Shdr[], __mcount_loc and its relocations. */
 static void append_func(Elf_Ehdr *const ehdr,
@@ -183,7 +234,6 @@ static void append_func(Elf_Ehdr *const ehdr,
 	uwrite(fd_map, ehdr, sizeof(*ehdr));
 }
 
-
 /*
  * Look at the relocations in order to find the calls to mcount.
  * Accumulate the section offsets that are found, and their relocation info,
@@ -233,7 +283,7 @@ static uint_t *sift_rel_mcount(uint_t *mlocp,
 				mcountsym = Elf_r_sym(relp);
 		}
 
-		if (mcountsym == Elf_r_sym(relp)) {
+		if (mcountsym == Elf_r_sym(relp) && !is_fake_mcount(relp)) {
 			uint_t const addend = _w(_w(relp->r_offset) - recval);
 
 			mrelp->r_offset = _w(offbase
-- 
1.7.1


