Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2DTAUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:20:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2DTAUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:20:50 -0400
Date: Thu, 19 Apr 2012 17:20:36 -0700
From: tip-bot for David Daney <david.daney@cavium.com>
Message-ID: <tip-a79f248b9b309ebb5f34ca6a8fd1eb9e18db5720@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com>
References: <1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] scripts: Add sortextable to sort the kernel'
 s exception table.
Git-Commit-ID: a79f248b9b309ebb5f34ca6a8fd1eb9e18db5720
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:20:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a79f248b9b309ebb5f34ca6a8fd1eb9e18db5720
Gitweb:     http://git.kernel.org/tip/a79f248b9b309ebb5f34ca6a8fd1eb9e18db5720
Author:     David Daney <david.daney@cavium.com>
AuthorDate: Thu, 19 Apr 2012 14:59:55 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 15:06:55 -0700

scripts: Add sortextable to sort the kernel's exception table.

Using this build-time sort saves time booting as we don't have to burn
cycles sorting the exception table.

Signed-off-by: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/1334872799-14589-2-git-send-email-ddaney.cavm@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/.gitignore    |    1 +
 scripts/Makefile      |    1 +
 scripts/sortextable.c |  271 +++++++++++++++++++++++++++++++++++++++++++++++++
 scripts/sortextable.h |  168 ++++++++++++++++++++++++++++++
 4 files changed, 441 insertions(+), 0 deletions(-)

diff --git a/scripts/.gitignore b/scripts/.gitignore
index 105b21f..65f362d 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -9,3 +9,4 @@ unifdef
 ihex2fw
 recordmcount
 docproc
+sortextable
diff --git a/scripts/Makefile b/scripts/Makefile
index df7678f..43e19b9 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -13,6 +13,7 @@ hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
+hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
new file mode 100644
index 0000000..f51f1d4
--- /dev/null
+++ b/scripts/sortextable.c
@@ -0,0 +1,271 @@
+/*
+ * sortextable.c: Sort the kernel's exception table
+ *
+ * Copyright 2011 Cavium, Inc.
+ *
+ * Based on code taken from recortmcount.c which is:
+ *
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reserved.
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ *
+ * Restructured to fit Linux format, as well as other updates:
+ *  Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ */
+
+/*
+ * Strategy: alter the vmlinux file in-place.
+ */
+
+#include <sys/types.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <getopt.h>
+#include <elf.h>
+#include <fcntl.h>
+#include <setjmp.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+static int fd_map;	/* File descriptor for file being modified. */
+static int mmap_failed; /* Boolean flag. */
+static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
+static struct stat sb;	/* Remember .st_size, etc. */
+static jmp_buf jmpenv;	/* setjmp/longjmp per-file error escape */
+
+/* setjmp() return values */
+enum {
+	SJ_SETJMP = 0,  /* hardwired first return */
+	SJ_FAIL,
+	SJ_SUCCEED
+};
+
+/* Per-file resource cleanup when multiple files. */
+static void
+cleanup(void)
+{
+	if (!mmap_failed)
+		munmap(ehdr_curr, sb.st_size);
+	close(fd_map);
+}
+
+static void __attribute__((noreturn))
+fail_file(void)
+{
+	cleanup();
+	longjmp(jmpenv, SJ_FAIL);
+}
+
+static void __attribute__((noreturn))
+succeed_file(void)
+{
+	cleanup();
+	longjmp(jmpenv, SJ_SUCCEED);
+}
+
+
+/*
+ * Get the whole file as a programming convenience in order to avoid
+ * malloc+lseek+read+free of many pieces.  If successful, then mmap
+ * avoids copying unused pieces; else just read the whole file.
+ * Open for both read and write.
+ */
+static void *mmap_file(char const *fname)
+{
+	void *addr;
+
+	fd_map = open(fname, O_RDWR);
+	if (fd_map < 0 || fstat(fd_map, &sb) < 0) {
+		perror(fname);
+		fail_file();
+	}
+	if (!S_ISREG(sb.st_mode)) {
+		fprintf(stderr, "not a regular file: %s\n", fname);
+		fail_file();
+	}
+	addr = mmap(0, sb.st_size, PROT_READ|PROT_WRITE, MAP_SHARED,
+		    fd_map, 0);
+	if (addr == MAP_FAILED) {
+		mmap_failed = 1;
+		fprintf(stderr, "Could not mmap file: %s\n", fname);
+		fail_file();
+	}
+	return addr;
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
+
+/* 32 bit and 64 bit are very similar */
+#include "sortextable.h"
+#define SORTEXTABLE_64
+#include "sortextable.h"
+
+
+static void
+do_file(char const *const fname)
+{
+	Elf32_Ehdr *const ehdr = mmap_file(fname);
+
+	ehdr_curr = ehdr;
+	w = w4nat;
+	w2 = w2nat;
+	w8 = w8nat;
+	switch (ehdr->e_ident[EI_DATA]) {
+		static unsigned int const endian = 1;
+	default:
+		fprintf(stderr, "unrecognized ELF data encoding %d: %s\n",
+			ehdr->e_ident[EI_DATA], fname);
+		fail_file();
+		break;
+	case ELFDATA2LSB:
+		if (*(unsigned char const *)&endian != 1) {
+			/* main() is big endian, file.o is little endian. */
+			w = w4rev;
+			w2 = w2rev;
+			w8 = w8rev;
+		}
+		break;
+	case ELFDATA2MSB:
+		if (*(unsigned char const *)&endian != 0) {
+			/* main() is little endian, file.o is big endian. */
+			w = w4rev;
+			w2 = w2rev;
+			w8 = w8rev;
+		}
+		break;
+	}  /* end switch */
+	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
+	||  w2(ehdr->e_type) != ET_EXEC
+	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
+		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
+		fail_file();
+	}
+
+	switch (w2(ehdr->e_machine)) {
+	default:
+		fprintf(stderr, "unrecognized e_machine %d %s\n",
+			w2(ehdr->e_machine), fname);
+		fail_file();
+		break;
+	case EM_386:
+	case EM_MIPS:
+	case EM_X86_64:
+		break;
+	}  /* end switch */
+
+	switch (ehdr->e_ident[EI_CLASS]) {
+	default:
+		fprintf(stderr, "unrecognized ELF class %d %s\n",
+			ehdr->e_ident[EI_CLASS], fname);
+		fail_file();
+		break;
+	case ELFCLASS32:
+		if (w2(ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
+		||  w2(ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
+			fprintf(stderr,
+				"unrecognized ET_EXEC file: %s\n", fname);
+			fail_file();
+		}
+		do32(ehdr, fname);
+		break;
+	case ELFCLASS64: {
+		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
+		if (w2(ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
+		||  w2(ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
+			fprintf(stderr,
+				"unrecognized ET_EXEC file: %s\n", fname);
+			fail_file();
+		}
+		do64(ghdr, fname);
+		break;
+	}
+	}  /* end switch */
+
+	cleanup();
+}
+
+int
+main(int argc, char *argv[])
+{
+	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
+	int i;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: sortextable vmlinux...\n");
+		return 0;
+	}
+
+	/* Process each file in turn, allowing deep failure. */
+	for (i = 1; i < argc; i++) {
+		char *file = argv[i];
+		int const sjval = setjmp(jmpenv);
+
+		switch (sjval) {
+		default:
+			fprintf(stderr, "internal error: %s\n", file);
+			exit(1);
+			break;
+		case SJ_SETJMP:    /* normal sequence */
+			/* Avoid problems if early cleanup() */
+			fd_map = -1;
+			ehdr_curr = NULL;
+			mmap_failed = 1;
+			do_file(file);
+			break;
+		case SJ_FAIL:    /* error in do_file or below */
+			++n_error;
+			break;
+		case SJ_SUCCEED:    /* premature success */
+			/* do nothing */
+			break;
+		}  /* end switch */
+	}
+	return !!n_error;
+}
diff --git a/scripts/sortextable.h b/scripts/sortextable.h
new file mode 100644
index 0000000..bb6aaf1
--- /dev/null
+++ b/scripts/sortextable.h
@@ -0,0 +1,168 @@
+/*
+ * sortextable.h
+ *
+ * Copyright 2011 Cavium, Inc.
+ *
+ * Some of this code was taken out of recordmcount.h written by:
+ *
+ * Copyright 2009 John F. Reiser <jreiser@BitWagon.com>.  All rights reserved.
+ * Copyright 2010 Steven Rostedt <srostedt@redhat.com>, Red Hat Inc.
+ *
+ *
+ * Licensed under the GNU General Public License, version 2 (GPLv2).
+ */
+
+#undef extable_ent_size
+#undef compare_extable
+#undef do_func
+#undef Elf_Addr
+#undef Elf_Ehdr
+#undef Elf_Shdr
+#undef Elf_Rel
+#undef Elf_Rela
+#undef Elf_Sym
+#undef ELF_R_SYM
+#undef Elf_r_sym
+#undef ELF_R_INFO
+#undef Elf_r_info
+#undef ELF_ST_BIND
+#undef ELF_ST_TYPE
+#undef fn_ELF_R_SYM
+#undef fn_ELF_R_INFO
+#undef uint_t
+#undef _w
+
+#ifdef SORTEXTABLE_64
+# define extable_ent_size	16
+# define compare_extable	compare_extable_64
+# define do_func		do64
+# define Elf_Addr		Elf64_Addr
+# define Elf_Ehdr		Elf64_Ehdr
+# define Elf_Shdr		Elf64_Shdr
+# define Elf_Rel		Elf64_Rel
+# define Elf_Rela		Elf64_Rela
+# define Elf_Sym		Elf64_Sym
+# define ELF_R_SYM		ELF64_R_SYM
+# define Elf_r_sym		Elf64_r_sym
+# define ELF_R_INFO		ELF64_R_INFO
+# define Elf_r_info		Elf64_r_info
+# define ELF_ST_BIND		ELF64_ST_BIND
+# define ELF_ST_TYPE		ELF64_ST_TYPE
+# define fn_ELF_R_SYM		fn_ELF64_R_SYM
+# define fn_ELF_R_INFO		fn_ELF64_R_INFO
+# define uint_t			uint64_t
+# define _w			w8
+#else
+# define extable_ent_size	8
+# define compare_extable	compare_extable_32
+# define do_func		do32
+# define Elf_Addr		Elf32_Addr
+# define Elf_Ehdr		Elf32_Ehdr
+# define Elf_Shdr		Elf32_Shdr
+# define Elf_Rel		Elf32_Rel
+# define Elf_Rela		Elf32_Rela
+# define Elf_Sym		Elf32_Sym
+# define ELF_R_SYM		ELF32_R_SYM
+# define Elf_r_sym		Elf32_r_sym
+# define ELF_R_INFO		ELF32_R_INFO
+# define Elf_r_info		Elf32_r_info
+# define ELF_ST_BIND		ELF32_ST_BIND
+# define ELF_ST_TYPE		ELF32_ST_TYPE
+# define fn_ELF_R_SYM		fn_ELF32_R_SYM
+# define fn_ELF_R_INFO		fn_ELF32_R_INFO
+# define uint_t			uint32_t
+# define _w			w
+#endif
+
+static int compare_extable(const void *a, const void *b)
+{
+	const uint_t *aa = a;
+	const uint_t *bb = b;
+
+	if (_w(*aa) < _w(*bb))
+		return -1;
+	if (_w(*aa) > _w(*bb))
+		return 1;
+	return 0;
+}
+
+static void
+do_func(Elf_Ehdr *const ehdr, char const *const fname)
+{
+	Elf_Shdr *shdr;
+	Elf_Shdr *shstrtab_sec;
+	Elf_Shdr *strtab_sec = NULL;
+	Elf_Shdr *symtab_sec = NULL;
+	Elf_Shdr *extab_sec = NULL;
+	Elf_Sym *sym;
+	Elf_Sym *sort_needed_sym;
+	Elf_Shdr *sort_needed_sec;
+	uint32_t *sort_done_location;
+	const char *secstrtab;
+	const char *strtab;
+	int i;
+	int idx;
+
+	shdr = (Elf_Shdr *)((void *)ehdr + _w(ehdr->e_shoff));
+	shstrtab_sec = shdr + w2(ehdr->e_shstrndx);
+	secstrtab = (const char *)ehdr + _w(shstrtab_sec->sh_offset);
+	for (i = 0; i < w2(ehdr->e_shnum); i++) {
+		idx = w(shdr[i].sh_name);
+		if (strcmp(secstrtab + idx, "__ex_table") == 0)
+			extab_sec = shdr + i;
+		if (strcmp(secstrtab + idx, ".symtab") == 0)
+			symtab_sec = shdr + i;
+		if (strcmp(secstrtab + idx, ".strtab") == 0)
+			strtab_sec = shdr + i;
+	}
+	if (strtab_sec == NULL) {
+		fprintf(stderr,	"no .strtab in  file: %s\n", fname);
+		fail_file();
+	}
+	if (symtab_sec == NULL) {
+		fprintf(stderr,	"no .symtab in  file: %s\n", fname);
+		fail_file();
+	}
+	if (extab_sec == NULL) {
+		fprintf(stderr,	"no __ex_table in  file: %s\n", fname);
+		fail_file();
+	}
+	strtab = (const char *)ehdr + _w(strtab_sec->sh_offset);
+
+	/* Sort the table in place */
+	qsort((void *)ehdr + _w(extab_sec->sh_offset),
+	      (_w(extab_sec->sh_size) / extable_ent_size),
+	      extable_ent_size, compare_extable);
+
+	/* find main_extable_sort_needed */
+	sort_needed_sym = NULL;
+	for (i = 0; i < _w(symtab_sec->sh_size) / sizeof(Elf_Sym); i++) {
+		sym = (void *)ehdr + _w(symtab_sec->sh_offset);
+		sym += i;
+		if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
+			continue;
+		idx = w(sym->st_name);
+		if (strcmp(strtab + idx, "main_extable_sort_needed") == 0) {
+			sort_needed_sym = sym;
+			break;
+		}
+	}
+	if (sort_needed_sym == NULL) {
+		fprintf(stderr,
+			"no main_extable_sort_needed symbol in  file: %s\n",
+			fname);
+		fail_file();
+	}
+	sort_needed_sec = &shdr[w2(sort_needed_sym->st_shndx)];
+	sort_done_location = (void *)ehdr +
+		_w(sort_needed_sec->sh_offset) +
+		_w(sort_needed_sym->st_value) -
+		_w(sort_needed_sec->sh_addr);
+
+	printf("sort done marker at %lx\n",
+		(unsigned long) (_w(sort_needed_sec->sh_offset) +
+				 _w(sort_needed_sym->st_value) -
+				 _w(sort_needed_sec->sh_addr)));
+	/* We sorted it, clear the flag. */
+	*sort_done_location = 0;
+}
