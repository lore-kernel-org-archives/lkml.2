Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2A0UVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:21:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2A0UUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:34 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=QqPOx2SMvfcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=SyI_GHdlAAAA:8 a=AG9L10Q6iO9lC6xWtjQA:9 a=6RAX9AyVc8XVU4euxr4A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=UQxMgyrMzRwA:10 a=0SQZ1hSLvzvcf6rTmG8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127202031.960582194@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] jump labels: Add infrastructure to update jump labels at compile
 time
References: <20120127201442.080360013@goodmis.org>
Content-Disposition: inline; filename=0004-jump-labels-Add-infrastructure-to-update-jump-labels.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add the infrastructure to allow architectures to modify the jump label
locations at compile time. This is mainly for x86, where the jmps may
be either 2 bytes or 5 bytes. Instead of wasting 5 bytes for all jump label=
s,
this code will let x86 put in a jmp instead of a 5 byte nop. Then the
assembler will make either a 2 byte or 5 byte jmp depending on where
the target is.

At compile time, this code will replace the jmps with either a 2 byte
or 5 byte nop depending on the size of the jmp that was added.

Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Makefile                    |    7 +
 arch/Kconfig                |    6 +
 scripts/Makefile            |    1 +
 scripts/Makefile.build      |   15 ++-
 scripts/update_jump_label.c |  335 +++++++++++++++++++++++++++++++++++++++=
++++
 scripts/update_jump_label.h |  208 +++++++++++++++++++++++++++
 6 files changed, 570 insertions(+), 2 deletions(-)
 create mode 100644 scripts/update_jump_label.c
 create mode 100644 scripts/update_jump_label.h

diff --git a/Makefile b/Makefile
index adddd11..2b3fdf3 100644
--- a/Makefile
+++ b/Makefile
@@ -611,6 +611,13 @@ ifdef CONFIG_DYNAMIC_FTRACE
 endif
 endif
=20
+ifdef CONFIG_JUMP_LABEL
+	ifdef CONFIG_HAVE_BUILD_TIME_JUMP_LABEL
+		BUILD_UPDATE_JUMP_LABEL :=3D y
+		export BUILD_UPDATE_JUMP_LABEL
+	endif
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS +=3D $(call cc-option, -fno-inline-functions-called-once)
diff --git a/arch/Kconfig b/arch/Kconfig
index 4b0669c..8fa6934 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -169,6 +169,12 @@ config HAVE_PERF_EVENTS_NMI
 	  subsystem.  Also has support for calculating CPU cycle events
 	  to determine how many clock cycles in a given period.
=20
+config HAVE_BUILD_TIME_JUMP_LABEL
+       bool
+       help
+	If an arch uses scripts/update_jump_label to patch in jump nops
+	at build time, then it must enable this option.
+
 config HAVE_ARCH_JUMP_LABEL
 	bool
=20
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..738b65c 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -13,6 +13,7 @@ hostprogs-$(CONFIG_LOGO)         +=3D pnmtologo
 hostprogs-$(CONFIG_VT)           +=3D conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     +=3D bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) +=3D recordmcount
+hostprogs-$(BUILD_UPDATE_JUMP_LABEL) +=3D update_jump_label
=20
 always		:=3D $(hostprogs-y) $(hostprogs-m)
=20
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d2b366c..8a84b80 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -258,6 +258,15 @@ cmd_modversions =3D								\
 	fi;
 endif
=20
+ifdef BUILD_UPDATE_JUMP_LABEL
+update_jump_label_source :=3D $(srctree)/scripts/update_jump_label.c \
+			$(srctree)/scripts/update_jump_label.h
+cmd_update_jump_label =3D						\
+	if [ $(@) !=3D "scripts/mod/empty.o" ]; then		\
+		$(objtree)/scripts/update_jump_label "$(@)";	\
+	fi;
+endif
+
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
 ifeq ("$(origin RECORDMCOUNT_WARN)", "command line")
@@ -294,6 +303,7 @@ define rule_cc_o_c
 	$(cmd_modversions)						  \
 	$(call echo-cmd,record_mcount)					  \
 	$(cmd_record_mcount)						  \
+	$(cmd_update_jump_label)					  \
 	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
 	                                              $(dot-target).tmp;  \
 	rm -f $(depfile);						  \
@@ -301,13 +311,14 @@ define rule_cc_o_c
 endef
=20
 # Built-in and composite module parts
-$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(obj)/%.o: $(src)/%.c $(recordmcount_source) $(update_jump_label_source) =
FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
=20
 # Single-part modules are special since we need to mark them in $(MODVERDI=
R)
=20
-$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
+$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) \
+		  $(update_jump_label_source) FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 	@{ echo $(@:.o=3D.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=3D.mod)
diff --git a/scripts/update_jump_label.c b/scripts/update_jump_label.c
new file mode 100644
index 0000000..d114b74
--- /dev/null
+++ b/scripts/update_jump_label.c
@@ -0,0 +1,335 @@
+/*
+ * update_jump_label.c: replace jmps with nops at compile time.
+ * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ *  Parsing of the elf file was influenced by recordmcount.c
+ *  originally written by and copyright to John F. Reiser <jreiser@BitWago=
n.com>.
+ */
+
+/*
+ * Note, this code is originally designed for x86, but may be used by
+ * other archs to do the nop updates at compile time instead of at boot ti=
me.
+ * X86 uses this as an optimization, as jmps can be either 2 bytes or 5 by=
tes.
+ * Inserting a 2 byte where possible helps with both CPU performance and
+ * icache strain.
+ */
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <getopt.h>
+#include <elf.h>
+#include <fcntl.h>
+#include <setjmp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdarg.h>
+#include <string.h>
+#include <unistd.h>
+
+static int fd_map;	/* File descriptor for file being modified. */
+static struct stat sb;	/* Remember .st_size, etc. */
+static int mmap_failed; /* Boolean flag. */
+
+static void die(const char *err, const char *fmt, ...)
+{
+	va_list ap;
+
+	if (err)
+		perror(err);
+
+	if (fmt) {
+		va_start(ap, fmt);
+		fprintf(stderr, "Fatal error:  ");
+		vfprintf(stderr, fmt, ap);
+		fprintf(stderr, "\n");
+		va_end(ap);
+	}
+
+	exit(1);
+}
+
+static void usage(char **argv)
+{
+	char *arg =3D argv[0];
+	char *p =3D arg + strlen(arg);
+
+	while (p >=3D arg && *p !=3D '/')
+		p--;
+	p++;
+
+	printf("usage: %s file\n"
+	       "\n", p);
+	exit(-1);
+}
+
+/* w8rev, w8nat, ...: Handle endianness. */
+
+static uint64_t w8rev(uint64_t const x)
+{
+	return   ((0xff & (x >> (0 * 8))) << (7 * 8))
+	       | ((0xff & (x >> (1 * 8))) << (6 * 8))
+	       | ((0xff & (x >> (2 * 8))) << (5 * 8))
+	       | ((0xff & (x >> (3 * 8))) << (4 * 8))
+	       | ((0xff & (x >> (4 * 8))) << (3 * 8))
+	       | ((0xff & (x >> (5 * 8))) << (2 * 8))
+	       | ((0xff & (x >> (6 * 8))) << (1 * 8))
+	       | ((0xff & (x >> (7 * 8))) << (0 * 8));
+}
+
+static uint32_t w4rev(uint32_t const x)
+{
+	return   ((0xff & (x >> (0 * 8))) << (3 * 8))
+	       | ((0xff & (x >> (1 * 8))) << (2 * 8))
+	       | ((0xff & (x >> (2 * 8))) << (1 * 8))
+	       | ((0xff & (x >> (3 * 8))) << (0 * 8));
+}
+
+static uint32_t w2rev(uint16_t const x)
+{
+	return   ((0xff & (x >> (0 * 8))) << (1 * 8))
+	       | ((0xff & (x >> (1 * 8))) << (0 * 8));
+}
+
+static uint64_t w8nat(uint64_t const x)
+{
+	return x;
+}
+
+static uint32_t w4nat(uint32_t const x)
+{
+	return x;
+}
+
+static uint32_t w2nat(uint16_t const x)
+{
+	return x;
+}
+
+static uint64_t (*w8)(uint64_t);
+static uint32_t (*w)(uint32_t);
+static uint32_t (*w2)(uint16_t);
+
+/* ulseek, uread, ...:  Check return value for errors. */
+
+static off_t
+ulseek(int const fd, off_t const offset, int const whence)
+{
+	off_t const w =3D lseek(fd, offset, whence);
+	if (w =3D=3D (off_t)-1)
+		die("lseek", NULL);
+
+	return w;
+}
+
+static size_t
+uread(int const fd, void *const buf, size_t const count)
+{
+	size_t const n =3D read(fd, buf, count);
+	if (n !=3D count)
+		die("read", NULL);
+
+	return n;
+}
+
+static size_t
+uwrite(int const fd, void const *const buf, size_t const count)
+{
+	size_t const n =3D write(fd, buf, count);
+	if (n !=3D count)
+		die("write", NULL);
+
+	return n;
+}
+
+static void *
+umalloc(size_t size)
+{
+	void *const addr =3D malloc(size);
+	if (addr =3D=3D 0)
+		die("malloc", "malloc failed: %zu bytes\n", size);
+
+	return addr;
+}
+
+/*
+ * Get the whole file as a programming convenience in order to avoid
+ * malloc+lseek+read+free of many pieces.  If successful, then mmap
+ * avoids copying unused pieces; else just read the whole file.
+ * Open for both read and write; new info will be appended to the file.
+ * Use MAP_PRIVATE so that a few changes to the in-memory ElfXX_Ehdr
+ * do not propagate to the file until an explicit overwrite at the last.
+ * This preserves most aspects of consistency (all except .st_size)
+ * for simultaneous readers of the file while we are appending to it.
+ * However, multiple writers still are bad.  We choose not to use
+ * locking because it is expensive and the use case of kernel build
+ * makes multiple writers unlikely.
+ */
+static void *mmap_file(char const *fname)
+{
+	void *addr;
+
+	fd_map =3D open(fname, O_RDWR);
+	if (fd_map < 0 || fstat(fd_map, &sb) < 0)
+		die(fname, "failed to open file");
+
+	if (!S_ISREG(sb.st_mode))
+		die(NULL, "not a regular file: %s\n", fname);
+
+	addr =3D mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE,
+		    fd_map, 0);
+
+	mmap_failed =3D 0;
+	if (addr =3D=3D MAP_FAILED) {
+		mmap_failed =3D 1;
+		addr =3D umalloc(sb.st_size);
+		uread(fd_map, addr, sb.st_size);
+	}
+	return addr;
+}
+
+static void munmap_file(void *addr)
+{
+	if (!mmap_failed)
+		munmap(addr, sb.st_size);
+	else
+		free(addr);
+	close(fd_map);
+}
+
+static unsigned char ideal_nop5_x86_64[5] =3D { 0x0f, 0x1f, 0x44, 0x00, 0x=
00 };
+static unsigned char ideal_nop5_x86_32[5] =3D { 0x3e, 0x8d, 0x74, 0x26, 0x=
00 };
+static unsigned char ideal_nop2_x86[2] =3D { 0x66, 0x90 };
+static unsigned char *ideal_nop;
+
+static int (*make_nop)(void *map, size_t const offset);
+
+static int make_nop_x86(void *map, size_t const offset)
+{
+	unsigned char *op;
+	unsigned char *nop;
+	int size;
+
+	/* Determine which type of jmp this is 2 byte or 5. */
+	op =3D map + offset;
+	switch (*op) {
+	case 0xeb: /* 2 byte */
+		size =3D 2;
+		nop =3D ideal_nop2_x86;
+		break;
+	case 0xe9: /* 5 byte */
+		size =3D 5;
+		nop =3D ideal_nop;
+		break;
+	default:
+		die(NULL, "Bad jump label section (bad op %x)\n", *op);
+		__builtin_unreachable();
+	}
+
+	/* convert to nop */
+	ulseek(fd_map, offset, SEEK_SET);
+	uwrite(fd_map, nop, size);
+	return 0;
+}
+
+/* 32 bit and 64 bit are very similar */
+#include "update_jump_label.h"
+#define UPDATE_JUMP_LABEL_64
+#include "update_jump_label.h"
+
+static int do_file(const char *fname)
+{
+	Elf32_Ehdr *const ehdr =3D mmap_file(fname);
+	unsigned int reltype =3D 0;
+
+	w =3D w4nat;
+	w2 =3D w2nat;
+	w8 =3D w8nat;
+	switch (ehdr->e_ident[EI_DATA]) {
+		static unsigned int const endian =3D 1;
+	default:
+		die(NULL, "unrecognized ELF data encoding %d: %s\n",
+			ehdr->e_ident[EI_DATA], fname);
+		break;
+	case ELFDATA2LSB:
+		if (*(unsigned char const *)&endian !=3D 1) {
+			/* main() is big endian, file.o is little endian. */
+			w =3D w4rev;
+			w2 =3D w2rev;
+			w8 =3D w8rev;
+		}
+		break;
+	case ELFDATA2MSB:
+		if (*(unsigned char const *)&endian !=3D 0) {
+			/* main() is little endian, file.o is big endian. */
+			w =3D w4rev;
+			w2 =3D w2rev;
+			w8 =3D w8rev;
+		}
+		break;
+	}  /* end switch */
+
+	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) !=3D 0 ||
+	    w2(ehdr->e_type) !=3D ET_REL ||
+	    ehdr->e_ident[EI_VERSION] !=3D EV_CURRENT)
+		die(NULL, "unrecognized ET_REL file %s\n", fname);
+
+	switch (w2(ehdr->e_machine)) {
+	default:
+		die(NULL, "unrecognized e_machine %d %s\n",
+		    w2(ehdr->e_machine), fname);
+		break;
+	case EM_386:
+		reltype =3D R_386_32;
+		make_nop =3D make_nop_x86;
+		ideal_nop =3D ideal_nop5_x86_32;
+		break;
+	case EM_ARM:	 reltype =3D R_ARM_ABS32;
+			 break;
+	case EM_IA_64:	 reltype =3D R_IA64_IMM64; break;
+	case EM_MIPS:	 /* reltype: e_class    */ break;
+	case EM_PPC:	 reltype =3D R_PPC_ADDR32;   break;
+	case EM_PPC64:	 reltype =3D R_PPC64_ADDR64; break;
+	case EM_S390:    /* reltype: e_class    */ break;
+	case EM_SH:	 reltype =3D R_SH_DIR32;                 break;
+	case EM_SPARCV9: reltype =3D R_SPARC_64;     break;
+	case EM_X86_64:
+		make_nop =3D make_nop_x86;
+		ideal_nop =3D ideal_nop5_x86_64;
+		reltype =3D R_X86_64_64;
+		break;
+	}  /* end switch */
+
+	switch (ehdr->e_ident[EI_CLASS]) {
+	default:
+		die(NULL, "unrecognized ELF class %d %s\n",
+		    ehdr->e_ident[EI_CLASS], fname);
+		break;
+	case ELFCLASS32:
+		if (w2(ehdr->e_ehsize) !=3D sizeof(Elf32_Ehdr)
+		||  w2(ehdr->e_shentsize) !=3D sizeof(Elf32_Shdr))
+			die(NULL, "unrecognized ET_REL file: %s\n", fname);
+
+		do_func32(ehdr, fname, reltype);
+		break;
+	case ELFCLASS64: {
+		Elf64_Ehdr *const ghdr =3D (Elf64_Ehdr *)ehdr;
+		if (w2(ghdr->e_ehsize) !=3D sizeof(Elf64_Ehdr)
+		||  w2(ghdr->e_shentsize) !=3D sizeof(Elf64_Shdr))
+			die(NULL, "unrecognized ET_REL file: %s\n", fname);
+
+		do_func64(ghdr, fname, reltype);
+		break;
+	}
+	}  /* end switch */
+
+	munmap_file(ehdr);
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	if (argc !=3D 2)
+		usage(argv);
+
+	return do_file(argv[1]);
+}
+
diff --git a/scripts/update_jump_label.h b/scripts/update_jump_label.h
new file mode 100644
index 0000000..181bd5b
--- /dev/null
+++ b/scripts/update_jump_label.h
@@ -0,0 +1,208 @@
+/*
+ * update_jump_label.h
+ *
+ * This code was based off of code from recordmcount.c written by
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reser=
ved.
+ *
+ * The original code had the same algorithms for both 32bit
+ * and 64bit ELF files, but the code was duplicated to support
+ * the difference in structures that were used. This
+ * file creates a macro of everything that is different between
+ * the 64 and 32 bit code, such that by including this header
+ * twice we can create both sets of functions by including this
+ * header once with UPDATE_JUMP_LABEL_64 undefined, and again with
+ * it defined.
+ *
+ * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ *
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ */
+
+#undef EBITS
+#undef _w
+
+#ifdef UPDATE_JUMP_LABEL_64
+# define EBITS			64
+# define _w			w8
+#else
+# define EBITS			32
+# define _w			w
+#endif
+
+#define _FBITS(x, e)	x##e
+#define FBITS(x, e)	_FBITS(x, e)
+#define FUNC(x)		FBITS(x, EBITS)
+
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Rel
+#undef Elf_Rela
+#undef Elf_Sym
+#undef ELF_R_SYM
+#undef ELF_R_TYPE
+
+#define __ATTACH(x, y, z)	x##y##z
+#define ATTACH(x, y, z)		__ATTACH(x, y, z)
+
+#define Elf_Ehdr	ATTACH(Elf, EBITS, _Ehdr)
+#define Elf_Shdr	ATTACH(Elf, EBITS, _Shdr)
+#define Elf_Rel		ATTACH(Elf, EBITS, _Rel)
+#define Elf_Rela	ATTACH(Elf, EBITS, _Rela)
+#define Elf_Sym		ATTACH(Elf, EBITS, _Sym)
+#define uint_t		ATTACH(uint, EBITS, _t)
+#define ELF_R_SYM	ATTACH(ELF, EBITS, _R_SYM)
+#define ELF_R_TYPE	ATTACH(ELF, EBITS, _R_TYPE)
+
+#undef get_shdr
+#define get_shdr(ehdr) ((Elf_Shdr *)(_w((ehdr)->e_shoff) + (void *)(ehdr)))
+
+#undef get_section_loc
+#define get_section_loc(ehdr, shdr)(_w((shdr)->sh_offset) + (void *)(ehdr))
+
+/* Find relocation section hdr for a given section */
+static const Elf_Shdr *
+FUNC(find_relhdr)(const Elf_Ehdr *ehdr, const Elf_Shdr *shdr)
+{
+	const Elf_Shdr *shdr0 =3D get_shdr(ehdr);
+	int nhdr =3D w2(ehdr->e_shnum);
+	const Elf_Shdr *hdr;
+	int i;
+
+	for (hdr =3D shdr0, i =3D 0; i < nhdr; hdr =3D &shdr0[++i]) {
+		if (w(hdr->sh_type) !=3D SHT_REL &&
+		    w(hdr->sh_type) !=3D SHT_RELA)
+			continue;
+
+		/*
+		 * The relocation section's info field holds
+		 * the section index that it represents.
+		 */
+		if (shdr =3D=3D &shdr0[w(hdr->sh_info)])
+			return hdr;
+	}
+	return NULL;
+}
+
+/* Find a section headr based on name and type */
+static const Elf_Shdr *
+FUNC(find_shdr)(const Elf_Ehdr *ehdr, const char *name, uint_t type)
+{
+	const Elf_Shdr *shdr0 =3D get_shdr(ehdr);
+	const Elf_Shdr *shstr =3D &shdr0[w2(ehdr->e_shstrndx)];
+	const char *shstrtab =3D (char *)get_section_loc(ehdr, shstr);
+	int nhdr =3D w2(ehdr->e_shnum);
+	const Elf_Shdr *hdr;
+	const char *hdrname;
+	int i;
+
+	for (hdr =3D shdr0, i =3D 0; i < nhdr; hdr =3D &shdr0[++i]) {
+		if (w(hdr->sh_type) !=3D type)
+			continue;
+
+		/* If we are just looking for a section by type (ie. SYMTAB) */
+		if (!name)
+			return hdr;
+
+		hdrname =3D &shstrtab[w(hdr->sh_name)];
+		if (strcmp(hdrname, name) =3D=3D 0)
+			return hdr;
+	}
+	return NULL;
+}
+
+static void
+FUNC(section_update)(const Elf_Ehdr *ehdr, const Elf_Shdr *symhdr,
+		     unsigned shtype, const Elf_Rel *rel, void *data)
+{
+	const Elf_Shdr *shdr0 =3D get_shdr(ehdr);
+	const Elf_Shdr *targethdr;
+	const Elf_Rela *rela;
+	const Elf_Sym *syment;
+	uint_t offset =3D _w(rel->r_offset);
+	uint_t info =3D _w(rel->r_info);
+	uint_t sym =3D ELF_R_SYM(info);
+	uint_t type =3D ELF_R_TYPE(info);
+	uint_t addend;
+	uint_t targetloc;
+
+	if (shtype =3D=3D SHT_RELA) {
+		rela =3D (const Elf_Rela *)rel;
+		addend =3D _w(rela->r_addend);
+	} else
+		addend =3D _w(*(int *)(data + offset));
+
+	syment =3D (const Elf_Sym *)get_section_loc(ehdr, symhdr);
+	targethdr =3D &shdr0[w2(syment[sym].st_shndx)];
+	targetloc =3D _w(targethdr->sh_offset);
+
+	/* TODO, need a separate function for all archs */
+	if (type !=3D R_386_32)
+		die(NULL, "Arch relocation type %d not supported", type);
+
+	targetloc +=3D addend;
+
+	*(uint_t *)(data + offset) =3D targetloc;
+}
+
+/* Overall supervision for Elf32 ET_REL file. */
+static void
+FUNC(do_func)(Elf_Ehdr *ehdr, char const *const fname, unsigned const relt=
ype)
+{
+	const Elf_Shdr *jlshdr;
+	const Elf_Shdr *jlrhdr;
+	const Elf_Shdr *symhdr;
+	const Elf_Rel *rel;
+	unsigned size;
+	unsigned cnt;
+	unsigned i;
+	uint_t type;
+	void *jdata;
+	void *data;
+
+	jlshdr =3D FUNC(find_shdr)(ehdr, "__jump_table", SHT_PROGBITS);
+	if (!jlshdr)
+		return;
+
+	jlrhdr =3D FUNC(find_relhdr)(ehdr, jlshdr);
+	if (!jlrhdr)
+		return;
+
+	/*
+	 * Create and fill in the __jump_table section and use it to
+	 * find the offsets into the text that we want to update.
+	 * We create it so that we do not depend on the order of the
+	 * relocations, and use the table directly, as it is broken
+	 * up into sections.
+	 */
+	size =3D _w(jlshdr->sh_size);
+	data =3D umalloc(size);
+
+	jdata =3D (void *)get_section_loc(ehdr, jlshdr);
+	memcpy(data, jdata, size);
+
+	cnt =3D _w(jlrhdr->sh_size) / w(jlrhdr->sh_entsize);
+
+	rel =3D (const Elf_Rel *)get_section_loc(ehdr, jlrhdr);
+
+	/* Is this as Rel or Rela? */
+	type =3D w(jlrhdr->sh_type);
+
+	symhdr =3D FUNC(find_shdr)(ehdr, NULL, SHT_SYMTAB);
+
+	for (i =3D 0; i < cnt; i++) {
+		FUNC(section_update)(ehdr, symhdr, type, rel, data);
+		rel =3D (void *)rel + w(jlrhdr->sh_entsize);
+	}
+
+	/*
+	 * This is specific to x86. The jump_table is stored in three
+	 * long words. The first is the location of the jmp target we
+	 * must update.
+	 */
+	cnt =3D size / sizeof(uint_t);
+
+	for (i =3D 0; i < cnt; i +=3D 3)
+		make_nop((void *)ehdr, *(uint_t *)(data + i * sizeof(uint_t)));
+
+	free(data);
+}
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPIwcQAAoJEIy3vGnGbaoAihgQAOXt2zDt3v977WUAXVDWj2xW
NcN7gqRPdZpzilN7B6AsQceExrKw1sm5UZe1Ne4ur90IacJ+89q8mGKX8J6u2wOV
Mau66q5uoNq08vzjsmo/UVgX7WpgcxzlUwH+IaDxVrgWVJvJ1+aafhHl9ULxheYA
LgpaYt1Y2jfJQ/2AYu2+DdgccT0vM74LMUx6yukBszJpdC1kFUG0XDtaQ5JrI1hT
jZL56syP/mhkP9ei3BMukKC6AdDbEtI3TiHdawOP7p0HMWXuj3rPkmREWsUS2udS
E+6g60XHJ9z95dbBaNxewvsWeTCSsJh01Oz4RRrVX7Mln1wFjalKSFzMDov0rOoi
4S/sL9LOM6OJ7WZtkt54cSuGDUhx4NA4yxN1ROSkoPkhptqgV0MGLIwXv4QI80li
ZUjHsjasXCqlqqTX/tH1u3lMDCpEbPGsf23C2cqcHpkTCyjCUnxlFnsd4HqVs5Cp
ip5FZpul4F2MJLzn1KEzV28ui95QLy3xQzw/6ZniJEQtruytZa42Gs7hyxrFY1pV
jFlG4yZ75zjlcs91PdBm+jCZhNMielbc0BfR4O68eqXvWgXjn5QNc6eo21AOyhPu
I6RP9+vwosokrssroW48GmlkGxasI6S0HLmk7LyvQDplnuWWjlZRUAs2LTj5bAJz
POXJmlGi/V1ZTRvvL64Q
=D0D1
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
