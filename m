Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab2DTWlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:41:32 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48586 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2DTWla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:41:30 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] scripts: Make sortextable handle relocations.
Date: Fri, 20 Apr 2012 15:41:19 -0700
Message-Id: <1334961679-14562-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

If there are relocations on the __ex_table section, they must be fixed
up after the table is sorted.

Also use the unaligned safe accessors from tools/{be,le}_byteshift.h

Signed-off-by: David Daney <david.daney@cavium.com>
---

This should address HPA's concerns about the i386 relocations.  The
i386 kernel still boots after the sort, but I don't know how to test
the relocations, but they sure do look nice!  My MIPS64 kernels still
boot too, so that is also good.

 scripts/Makefile      |    2 +
 scripts/sortextable.c |  123 +++++++++++++++++++++++--------------------
 scripts/sortextable.h |  138 +++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 178 insertions(+), 85 deletions(-)

diff --git a/scripts/Makefile b/scripts/Makefile
index 43e19b9..9eace52 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -15,6 +15,8 @@ hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 
+HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
+
 always		:= $(hostprogs-y) $(hostprogs-m)
 
 # The following hostprogs-y programs are only build on demand
diff --git a/scripts/sortextable.c b/scripts/sortextable.c
index 6546785..d876045 100644
--- a/scripts/sortextable.c
+++ b/scripts/sortextable.c
@@ -1,7 +1,7 @@
 /*
  * sortextable.c: Sort the kernel's exception table
  *
- * Copyright 2011 Cavium, Inc.
+ * Copyright 2011 - 2012 Cavium, Inc.
  *
  * Based on code taken from recortmcount.c which is:
  *
@@ -28,6 +28,9 @@
 #include <string.h>
 #include <unistd.h>
 
+#include <tools/be_byteshift.h>
+#include <tools/le_byteshift.h>
+
 static int fd_map;	/* File descriptor for file being modified. */
 static int mmap_failed; /* Boolean flag. */
 static void *ehdr_curr; /* current ElfXX_Ehdr *  for resource cleanup */
@@ -94,52 +97,62 @@ static void *mmap_file(char const *fname)
 	return addr;
 }
 
-/* w8rev, w8nat, ...: Handle endianness. */
-
-static uint64_t w8rev(uint64_t const x)
+static uint64_t r8be(const uint64_t *x)
 {
-	return   ((0xff & (x >> (0 * 8))) << (7 * 8))
-	       | ((0xff & (x >> (1 * 8))) << (6 * 8))
-	       | ((0xff & (x >> (2 * 8))) << (5 * 8))
-	       | ((0xff & (x >> (3 * 8))) << (4 * 8))
-	       | ((0xff & (x >> (4 * 8))) << (3 * 8))
-	       | ((0xff & (x >> (5 * 8))) << (2 * 8))
-	       | ((0xff & (x >> (6 * 8))) << (1 * 8))
-	       | ((0xff & (x >> (7 * 8))) << (0 * 8));
+	return get_unaligned_be64(x);
 }
-
-static uint32_t w4rev(uint32_t const x)
+static uint32_t rbe(const uint32_t *x)
 {
-	return   ((0xff & (x >> (0 * 8))) << (3 * 8))
-	       | ((0xff & (x >> (1 * 8))) << (2 * 8))
-	       | ((0xff & (x >> (2 * 8))) << (1 * 8))
-	       | ((0xff & (x >> (3 * 8))) << (0 * 8));
+	return get_unaligned_be32(x);
 }
-
-static uint32_t w2rev(uint16_t const x)
+static uint16_t r2be(const uint16_t *x)
 {
-	return   ((0xff & (x >> (0 * 8))) << (1 * 8))
-	       | ((0xff & (x >> (1 * 8))) << (0 * 8));
+	return get_unaligned_be16(x);
 }
-
-static uint64_t w8nat(uint64_t const x)
+static uint64_t r8le(const uint64_t *x)
 {
-	return x;
+	return get_unaligned_le64(x);
 }
-
-static uint32_t w4nat(uint32_t const x)
+static uint32_t rle(const uint32_t *x)
+{
+	return get_unaligned_le32(x);
+}
+static uint16_t r2le(const uint16_t *x)
 {
-	return x;
+	return get_unaligned_le16(x);
 }
 
-static uint32_t w2nat(uint16_t const x)
+static void w8be(uint64_t val, uint64_t *x)
+{
+	put_unaligned_be64(val, x);
+}
+static void wbe(uint32_t val, uint32_t *x)
 {
-	return x;
+	put_unaligned_be32(val, x);
+}
+static void w2be(uint16_t val, uint16_t *x)
+{
+	put_unaligned_be16(val, x);
+}
+static void w8le(uint64_t val, uint64_t *x)
+{
+	put_unaligned_le64(val, x);
+}
+static void wle(uint32_t val, uint32_t *x)
+{
+	put_unaligned_le32(val, x);
+}
+static void w2le(uint16_t val, uint16_t *x)
+{
+	put_unaligned_le16(val, x);
 }
 
-static uint64_t (*w8)(uint64_t);
-static uint32_t (*w)(uint32_t);
-static uint32_t (*w2)(uint16_t);
+static uint64_t (*r8)(const uint64_t *);
+static uint32_t (*r)(const uint32_t *);
+static uint16_t (*r2)(const uint16_t *);
+static void (*w8)(uint64_t, uint64_t *);
+static void (*w)(uint32_t, uint32_t *);
+static void (*w2)(uint16_t, uint16_t *);
 
 
 /* 32 bit and 64 bit are very similar */
@@ -151,47 +164,43 @@ static uint32_t (*w2)(uint16_t);
 static void
 do_file(char const *const fname)
 {
-	Elf32_Ehdr *const ehdr = mmap_file(fname);
+	Elf32_Ehdr *ehdr = mmap_file(fname);
 
 	ehdr_curr = ehdr;
-	w = w4nat;
-	w2 = w2nat;
-	w8 = w8nat;
 	switch (ehdr->e_ident[EI_DATA]) {
-		static unsigned int const endian = 1;
 	default:
 		fprintf(stderr, "unrecognized ELF data encoding %d: %s\n",
 			ehdr->e_ident[EI_DATA], fname);
 		fail_file();
 		break;
 	case ELFDATA2LSB:
-		if (*(unsigned char const *)&endian != 1) {
-			/* main() is big endian, file.o is little endian. */
-			w = w4rev;
-			w2 = w2rev;
-			w8 = w8rev;
-		}
+		r = rle;
+		r2 = r2le;
+		r8 = r8le;
+		w = wle;
+		w2 = w2le;
+		w8 = w8le;
 		break;
 	case ELFDATA2MSB:
-		if (*(unsigned char const *)&endian != 0) {
-			/* main() is little endian, file.o is big endian. */
-			w = w4rev;
-			w2 = w2rev;
-			w8 = w8rev;
-		}
+		r = rbe;
+		r2 = r2be;
+		r8 = r8be;
+		w = wbe;
+		w2 = w2be;
+		w8 = w8be;
 		break;
 	}  /* end switch */
 	if (memcmp(ELFMAG, ehdr->e_ident, SELFMAG) != 0
-	||  w2(ehdr->e_type) != ET_EXEC
+	||  r2(&ehdr->e_type) != ET_EXEC
 	||  ehdr->e_ident[EI_VERSION] != EV_CURRENT) {
 		fprintf(stderr, "unrecognized ET_EXEC file %s\n", fname);
 		fail_file();
 	}
 
-	switch (w2(ehdr->e_machine)) {
+	switch (r2(&ehdr->e_machine)) {
 	default:
 		fprintf(stderr, "unrecognized e_machine %d %s\n",
-			w2(ehdr->e_machine), fname);
+			r2(&ehdr->e_machine), fname);
 		fail_file();
 		break;
 	case EM_386:
@@ -207,8 +216,8 @@ do_file(char const *const fname)
 		fail_file();
 		break;
 	case ELFCLASS32:
-		if (w2(ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
-		||  w2(ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
+		if (r2(&ehdr->e_ehsize) != sizeof(Elf32_Ehdr)
+		||  r2(&ehdr->e_shentsize) != sizeof(Elf32_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_EXEC file: %s\n", fname);
 			fail_file();
@@ -217,8 +226,8 @@ do_file(char const *const fname)
 		break;
 	case ELFCLASS64: {
 		Elf64_Ehdr *const ghdr = (Elf64_Ehdr *)ehdr;
-		if (w2(ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
-		||  w2(ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
+		if (r2(&ghdr->e_ehsize) != sizeof(Elf64_Ehdr)
+		||  r2(&ghdr->e_shentsize) != sizeof(Elf64_Shdr)) {
 			fprintf(stderr,
 				"unrecognized ET_EXEC file: %s\n", fname);
 			fail_file();
diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index bb6aaf1..27b1439 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -1,7 +1,7 @@
 /*
  * sortextable.h
  *
- * Copyright 2011 Cavium, Inc.
+ * Copyright 2011 - 2012 Cavium, Inc.
  *
  * Some of this code was taken out of recordmcount.h written by:
  *
@@ -14,7 +14,10 @@
 
 #undef extable_ent_size
 #undef compare_extable
+#undef work_struct
+#undef relocs_struct
 #undef do_func
+#undef find_reloc
 #undef Elf_Addr
 #undef Elf_Ehdr
 #undef Elf_Shdr
@@ -30,12 +33,16 @@
 #undef fn_ELF_R_SYM
 #undef fn_ELF_R_INFO
 #undef uint_t
+#undef _r
 #undef _w
 
 #ifdef SORTEXTABLE_64
 # define extable_ent_size	16
 # define compare_extable	compare_extable_64
+# define work_struct		work_struct_64
+# define relocs_struct		relocs_struc_64
 # define do_func		do64
+# define find_reloc		find_reloc64
 # define Elf_Addr		Elf64_Addr
 # define Elf_Ehdr		Elf64_Ehdr
 # define Elf_Shdr		Elf64_Shdr
@@ -51,11 +58,15 @@
 # define fn_ELF_R_SYM		fn_ELF64_R_SYM
 # define fn_ELF_R_INFO		fn_ELF64_R_INFO
 # define uint_t			uint64_t
+# define _r			r8
 # define _w			w8
 #else
 # define extable_ent_size	8
 # define compare_extable	compare_extable_32
+# define work_struct		work_struct_32
+# define relocs_struct		relocs_struc_32
 # define do_func		do32
+# define find_reloc		find_reloc32
 # define Elf_Addr		Elf32_Addr
 # define Elf_Ehdr		Elf32_Ehdr
 # define Elf_Shdr		Elf32_Shdr
@@ -71,23 +82,48 @@
 # define fn_ELF_R_SYM		fn_ELF32_R_SYM
 # define fn_ELF_R_INFO		fn_ELF32_R_INFO
 # define uint_t			uint32_t
+# define _r			r
 # define _w			w
 #endif
 
+struct work_struct {
+	/* Literal copy of the entry. */
+	char ent[extable_ent_size];
+	/* Original position of the entry. */
+	int ex_table_idx;
+	/* Position of the relocations. */
+	int rel_idx0;
+	int rel_idx1;
+};
+
+struct relocs_struct {
+	Elf_Rel *relocs;
+	int size;
+};
+
 static int compare_extable(const void *a, const void *b)
 {
-	const uint_t *aa = a;
-	const uint_t *bb = b;
+	const struct work_struct *aa = a;
+	const struct work_struct *bb = b;
 
-	if (_w(*aa) < _w(*bb))
+	if (_r((Elf_Addr *)(aa->ent)) < _r((Elf_Addr *)(bb->ent)))
 		return -1;
-	if (_w(*aa) > _w(*bb))
+	if (_r((Elf_Addr *)(aa->ent)) > _r((Elf_Addr *)(bb->ent)))
 		return 1;
 	return 0;
 }
+static int find_reloc(struct relocs_struct *relocs, Elf_Addr target)
+{
+	int i;
+
+	for (i = 0; i < relocs->size; i++)
+		if (_r(&relocs->relocs[i].r_offset) == target)
+			return i;
+	return -1;
+}
 
 static void
-do_func(Elf_Ehdr *const ehdr, char const *const fname)
+do_func(Elf_Ehdr *ehdr, char const *const fname)
 {
 	Elf_Shdr *shdr;
 	Elf_Shdr *shstrtab_sec;
@@ -100,16 +136,29 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname)
 	uint32_t *sort_done_location;
 	const char *secstrtab;
 	const char *strtab;
+	struct work_struct *work_array;
+	struct relocs_struct relocs = {NULL, 0};
+	char *extab_image;
+	Elf_Addr extab_virt;
+	int extab_index = 0;
+	int num_entries;
 	int i;
 	int idx;
 
-	shdr = (Elf_Shdr *)((void *)ehdr + _w(ehdr->e_shoff));
-	shstrtab_sec = shdr + w2(ehdr->e_shstrndx);
-	secstrtab = (const char *)ehdr + _w(shstrtab_sec->sh_offset);
-	for (i = 0; i < w2(ehdr->e_shnum); i++) {
-		idx = w(shdr[i].sh_name);
-		if (strcmp(secstrtab + idx, "__ex_table") == 0)
+	shdr = (Elf_Shdr *)((void *)ehdr + _r(&ehdr->e_shoff));
+	shstrtab_sec = shdr + r2(&ehdr->e_shstrndx);
+	secstrtab = (const char *)ehdr + _r(&shstrtab_sec->sh_offset);
+	for (i = 0; i < r2(&ehdr->e_shnum); i++) {
+		idx = r(&shdr[i].sh_name);
+		if (strcmp(secstrtab + idx, "__ex_table") == 0) {
 			extab_sec = shdr + i;
+			extab_index = i;
+		}
+		if (r(&shdr[i].sh_type) == SHT_REL &&
+		    r(&shdr[i].sh_info) == extab_index) {
+			relocs.relocs = (void *)ehdr + _r(&shdr[i].sh_offset);
+			relocs.size = _r(&shdr[i].sh_size) / sizeof(Elf_Rel);
+		}
 		if (strcmp(secstrtab + idx, ".symtab") == 0)
 			symtab_sec = shdr + i;
 		if (strcmp(secstrtab + idx, ".strtab") == 0)
@@ -127,21 +176,56 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname)
 		fprintf(stderr,	"no __ex_table in  file: %s\n", fname);
 		fail_file();
 	}
-	strtab = (const char *)ehdr + _w(strtab_sec->sh_offset);
+	strtab = (const char *)ehdr + _r(&strtab_sec->sh_offset);
 
-	/* Sort the table in place */
-	qsort((void *)ehdr + _w(extab_sec->sh_offset),
-	      (_w(extab_sec->sh_size) / extable_ent_size),
-	      extable_ent_size, compare_extable);
+	num_entries = _r(&extab_sec->sh_size) / extable_ent_size;
+	work_array = calloc(num_entries, sizeof(*work_array));
+	if (work_array == NULL) {
+		fprintf(stderr,	"Failed to allocate work_array\n");
+		fail_file();
+	}
+	extab_image = (void *)ehdr + _r(&extab_sec->sh_offset);
+	extab_virt = _r(&extab_sec->sh_addr);
+
+
+	/* Copy into the work_array. */
+	for (i = 0; i < num_entries; i++) {
+		memcpy(work_array[i].ent,
+		       extab_image + (i * extable_ent_size), extable_ent_size);
+		work_array[i].ex_table_idx = i;
+		work_array[i].rel_idx0 = find_reloc(&relocs,
+						    extab_virt + (i * extable_ent_size));
+		work_array[i].rel_idx1 = find_reloc(&relocs,
+						    extab_virt + (i * extable_ent_size) + sizeof(Elf_Addr));
+	}
+
+	/* Sort the work_array */
+	qsort(work_array, num_entries, sizeof(*work_array), compare_extable);
+
+	/* Copy it back out. */
+	for (i = 0; i < num_entries; i++) {
+		memcpy(extab_image + (i * extable_ent_size),
+		       work_array[i].ent, extable_ent_size);
+		/* Patch up the relocs */
+		if (work_array[i].rel_idx0 >= 0) {
+			Elf_Addr t = extab_virt + (i * extable_ent_size);
+			_w(t, &relocs.relocs[work_array[i].rel_idx0].r_offset);
+		}
+		if (work_array[i].rel_idx1 >= 0) {
+			Elf_Addr t = extab_virt + (i * extable_ent_size) + sizeof(Elf_Addr);
+			_w(t, &relocs.relocs[work_array[i].rel_idx1].r_offset);
+		}
+
+	}
 
 	/* find main_extable_sort_needed */
 	sort_needed_sym = NULL;
-	for (i = 0; i < _w(symtab_sec->sh_size) / sizeof(Elf_Sym); i++) {
-		sym = (void *)ehdr + _w(symtab_sec->sh_offset);
+	for (i = 0; i < _r(&symtab_sec->sh_size) / sizeof(Elf_Sym); i++) {
+		sym = (void *)ehdr + _r(&symtab_sec->sh_offset);
 		sym += i;
 		if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
 			continue;
-		idx = w(sym->st_name);
+		idx = r(&sym->st_name);
 		if (strcmp(strtab + idx, "main_extable_sort_needed") == 0) {
 			sort_needed_sym = sym;
 			break;
@@ -153,16 +237,14 @@ do_func(Elf_Ehdr *const ehdr, char const *const fname)
 			fname);
 		fail_file();
 	}
-	sort_needed_sec = &shdr[w2(sort_needed_sym->st_shndx)];
+	sort_needed_sec = &shdr[r2(&sort_needed_sym->st_shndx)];
 	sort_done_location = (void *)ehdr +
-		_w(sort_needed_sec->sh_offset) +
-		_w(sort_needed_sym->st_value) -
-		_w(sort_needed_sec->sh_addr);
+		_r(&sort_needed_sec->sh_offset) +
+		_r(&sort_needed_sym->st_value) -
+		_r(&sort_needed_sec->sh_addr);
 
 	printf("sort done marker at %lx\n",
-		(unsigned long) (_w(sort_needed_sec->sh_offset) +
-				 _w(sort_needed_sym->st_value) -
-				 _w(sort_needed_sec->sh_addr)));
+	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
 	/* We sorted it, clear the flag. */
-	*sort_done_location = 0;
+	w(0, sort_done_location);
 }
-- 
1.7.2.3

