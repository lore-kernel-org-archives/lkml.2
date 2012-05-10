Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab2EJXnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007Ab2EJXnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:43:17 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/29] MODSIGN: Sign modules during the build process [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:43:04 +0100
Message-ID: <20120510234304.4137.40157.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_MODULE_SIG is set, then this patch will cause the module to get a
signature installed.  The following steps will occur:

 (1) The module will be linked to foo.ko.unsigned instead of foo.ko

 (2) The module's signable content will be extracted to foo.ko.digest by the
     mod-extract program.

 (3) The signature will be generated on foo.ko.digest by gpg and placed in
     foo.ko.digest.sig

 (4) The signature will be encapsulated into an ELF note and placed into a file
     called foo.ko.note.o using the output from modsign-note.sh piped into the
     assembler.

 (5) The unsigned module from (1) and the signature ELF note from (4) will be
     linked together to produce foo.ko

Step (3) requires private and public keys to be available.  By default these
are expected to be found in PGP keyring files called modsign.sec (the secret
key) and modsign.pub (the public key) in the build root.

If the secret key is not found then signing will be skipped and the unsigned
module from (1) will just be copied to foo.ko.

If signing occurs, lines like the following will be seen:

	LD [M]  fs/foo/foo.ko.unsigned
	SIGN [M] fs/foo/foo.ko

will appear in the build log.  If it is skipped, the following will be seen:

	LD [M]  fs/foo/foo.ko.unsigned
	NO SIGN [M] fs/foo/foo.ko

Signed-off-by: David Howells <dhowells@redhat.com>
---

 scripts/Makefile.modpost    |   87 ++++
 scripts/mod/Makefile        |    2 
 scripts/mod/mod-extract.c   |  913 +++++++++++++++++++++++++++++++++++++++++++
 scripts/mod/modsign-note.sh |   16 +
 4 files changed, 1016 insertions(+), 2 deletions(-)
 create mode 100644 scripts/mod/mod-extract.c
 create mode 100644 scripts/mod/modsign-note.sh


diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..17465d8 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -14,7 +14,8 @@
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
 # 5) compile all <module>.mod.c files
-# 6) final link of the module to a <module.ko> file
+# 6) final link of the module to a <module.ko> (or <module.unsigned>) file
+# 7) signs the modules to a <module.ko> file
 
 # Step 3 is used to place certain information in the module's ELF
 # section, including information such as:
@@ -32,6 +33,8 @@
 # Step 4 is solely used to allow module versioning in external modules,
 # where the CRC of each module is retrieved from the Module.symvers file.
 
+# Step 7 is dependent on CONFIG_MODULE_SIG being enabled.
+
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
 # symbols in the final module linking stage
 # KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
@@ -116,6 +119,7 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
+ifneq ($(CONFIG_MODULE_SIG),y)
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o = $(LD) -r $(LDFLAGS)                                 \
                              $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE) \
@@ -125,7 +129,88 @@ $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
 
 targets += $(modules)
+else
+quiet_cmd_ld_ko_unsigned_o = LD [M]  $@
+      cmd_ld_ko_unsigned_o =						\
+		$(LD) -r $(LDFLAGS)					\
+			 $(KBUILD_LDFLAGS_MODULE) $(LDFLAGS_MODULE)	\
+			 -o $@ $(filter-out FORCE,$^)			\
+		$(if $(AFTER_LINK),; $(AFTER_LINK))
+
+$(modules:.ko=.ko.unsigned): %.ko.unsigned :%.o %.mod.o FORCE
+	$(call if_changed,ld_ko_unsigned_o)
+
+targets += $(modules:.ko=.ko.unsigned)
+
+# Step 7), sign the modules
+MODSECKEY = ./modsign.sec
+MODPUBKEY = ./modsign.pub
+KEYFLAGS = --no-default-keyring --secret-keyring $(MODSECKEY) --keyring $(MODPUBKEY) --no-default-keyring --homedir . --no-options --no-auto-check-trustdb --no-permission-warning
+
+ifdef CONFIG_MODULE_SIG_SHA1
+KEYFLAGS += --digest-algo=SHA1
+else
+ifdef CONFIG_MODULE_SIG_SHA224
+KEYFLAGS += --digest-algo=SHA224
+else
+ifdef CONFIG_MODULE_SIG_SHA256
+KEYFLAGS += --digest-algo=SHA256
+else
+ifdef CONFIG_MODULE_SIG_SHA384
+KEYFLAGS += --digest-algo=SHA384
+else
+ifdef CONFIG_MODULE_SIG_SHA512
+KEYFLAGS += --digest-algo=SHA512
+else
+endif
+endif
+endif
+endif
+endif
+
+ifdef MODKEYNAME
+KEYFLAGS += --default-key $(MODKEYNAME)
+endif
 
+ifeq ($(wildcard $(MODSECKEY))+$(wildcard $(MODPUBKEY)),$(MODSECKEY)+$(MODPUBKEY))
+ifeq ($(KBUILD_SRC),)
+	# no O= is being used
+	SCRIPTS_DIR := scripts
+else
+	SCRIPTS_DIR := $(KBUILD_SRC)/scripts
+endif
+SIGN_MODULES := 1
+else
+SIGN_MODULES := 0
+endif
+
+# only sign if it's an in-tree module
+ifneq ($(KBUILD_EXTMOD),)
+SIGN_MODULES := 0
+endif
+
+ifeq ($(SIGN_MODULES),1)
+KEYRING_DEP := modsign.sec modsign.pub
+quiet_cmd_sign_ko_ko_unsigned = SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		scripts/mod/mod-extract $< $@.digest && \
+		rm -f $@.digest.sig && \
+		gpg --batch --no-greeting $(KEYFLAGS) -b $@.digest && \
+		sh $(SCRIPTS_DIR)/mod/modsign-note.sh $@.digest.sig | \
+		  $(CC) -x assembler-with-cpp $(c_flags) $(CFLAGS_MODULE) -c -o $@.note.o - && \
+		$(LD) -r $(LDFLAGS) -o $@ $< $@.note.o
+else
+KEYRING_DEP :=
+quiet_cmd_sign_ko_ko_unsigned = NO SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		cp $< $@
+endif
+
+$(modules): %.ko :%.ko.unsigned $(KEYRING_DEP) FORCE
+	$(call if_changed,sign_ko_ko_unsigned)
+
+targets += $(modules)
+endif
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index ff954f8..4654e3b 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,4 +1,4 @@
-hostprogs-y	:= modpost mk_elfconfig
+hostprogs-y	:= modpost mk_elfconfig mod-extract
 always		:= $(hostprogs-y) empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o
diff --git a/scripts/mod/mod-extract.c b/scripts/mod/mod-extract.c
new file mode 100644
index 0000000..0c0e3e3
--- /dev/null
+++ b/scripts/mod/mod-extract.c
@@ -0,0 +1,913 @@
+/* mod-extract.c: module extractor for signing
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdarg.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <elf.h>
+#include <asm/byteorder.h>
+
+static void extract_elf64(void *buffer, size_t size, Elf64_Ehdr *hdr);
+static void extract_elf32(void *buffer, size_t size, Elf32_Ehdr *hdr);
+
+struct byteorder {
+	uint16_t (*get16)(const uint16_t *);
+	uint32_t (*get32)(const uint32_t *);
+	uint64_t (*get64)(const uint64_t *);
+	void (*set16)(uint16_t *, uint16_t);
+	void (*set32)(uint32_t *, uint32_t);
+	void (*set64)(uint64_t *, uint64_t);
+};
+
+static uint16_t get16_le(const uint16_t *p) { return __le16_to_cpu(*p); }
+static uint32_t get32_le(const uint32_t *p) { return __le32_to_cpu(*p); }
+static uint64_t get64_le(const uint64_t *p) { return __le64_to_cpu(*p); }
+static uint16_t get16_be(const uint16_t *p) { return __be16_to_cpu(*p); }
+static uint32_t get32_be(const uint32_t *p) { return __be32_to_cpu(*p); }
+static uint64_t get64_be(const uint64_t *p) { return __be64_to_cpu(*p); }
+
+static void set16_le(uint16_t *p, uint16_t n) { *p = __cpu_to_le16(n); }
+static void set32_le(uint32_t *p, uint32_t n) { *p = __cpu_to_le32(n); }
+static void set64_le(uint64_t *p, uint64_t n) { *p = __cpu_to_le64(n); }
+static void set16_be(uint16_t *p, uint16_t n) { *p = __cpu_to_be16(n); }
+static void set32_be(uint32_t *p, uint32_t n) { *p = __cpu_to_be32(n); }
+static void set64_be(uint64_t *p, uint64_t n) { *p = __cpu_to_be64(n); }
+
+static const struct byteorder byteorder_le = {
+	get16_le, get32_le, get64_le,
+	set16_le, set32_le, set64_le
+};
+static const struct byteorder byteorder_be = {
+	get16_be, get32_be, get64_be,
+	set16_be, set32_be, set64_be
+};
+static const struct byteorder *order;
+
+static inline uint16_t get16(const uint16_t *p) { return order->get16(p); }
+static inline uint32_t get32(const uint32_t *p) { return order->get32(p); }
+static inline uint64_t get64(const uint64_t *p) { return order->get64(p); }
+static inline void set16(uint16_t *p, uint16_t n) { order->set16(p, n); }
+static inline void set32(uint32_t *p, uint32_t n) { order->set32(p, n); }
+static inline void set64(uint64_t *p, uint64_t n) { order->set64(p, n); }
+
+static FILE *outfd;
+static uint8_t csum, xcsum;
+
+static void write_out(const void *data, size_t size)
+{
+	const uint8_t *p = data;
+	size_t loop;
+
+	for (loop = 0; loop < size; loop++) {
+		csum += p[loop];
+		xcsum += p[loop];
+	}
+
+	if (fwrite(data, 1, size, outfd) != size) {
+		perror("write");
+		exit(1);
+	}
+}
+
+#define write_out_val(VAL) write_out(&(VAL), sizeof(VAL))
+
+static int is_verbose;
+
+static __attribute__((format(printf, 1, 2)))
+void verbose(const char *fmt, ...)
+{
+	va_list va;
+
+	if (is_verbose) {
+		va_start(va, fmt);
+		vprintf(fmt, va);
+		va_end(va);
+	}
+}
+
+static __attribute__((noreturn))
+void usage(void)
+{
+	fprintf(stderr, "Usage: mod-extract [-v] <modulefile> <extractfile>\n");
+	exit(2);
+}
+
+/*
+ *
+ */
+int main(int argc, char **argv)
+{
+	struct stat st;
+	Elf32_Ehdr *hdr32;
+	Elf64_Ehdr *hdr64;
+	size_t len;
+	void *buffer;
+	int fd, be, b64;
+
+	while (argc > 1 && strcmp("-v", argv[1]) == 0) {
+		argv++;
+		argc--;
+		is_verbose++;
+	}
+
+	if (argc != 3)
+		usage();
+
+	/* map the module into memory */
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open input");
+		exit(1);
+	}
+
+	if (fstat(fd, &st) < 0) {
+		perror("fstat");
+		exit(1);
+	}
+
+	len = st.st_size;
+
+	buffer = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (buffer == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	if (close(fd) < 0) {
+		perror("close input");
+		exit(1);
+	}
+
+	/* check it's an ELF object */
+	hdr32 = buffer;
+	hdr64 = buffer;
+
+	if (hdr32->e_ident[EI_MAG0] != ELFMAG0 ||
+	    hdr32->e_ident[EI_MAG1] != ELFMAG1 ||
+	    hdr32->e_ident[EI_MAG2] != ELFMAG2 ||
+	    hdr32->e_ident[EI_MAG3] != ELFMAG3
+	    ) {
+		fprintf(stderr, "Module does not appear to be ELF\n");
+		exit(3);
+	}
+
+	/* determine endianness and word size */
+	b64 = (hdr32->e_ident[EI_CLASS] == ELFCLASS64);
+	be = (hdr32->e_ident[EI_DATA] == ELFDATA2MSB);
+	order = be ? &byteorder_be : &byteorder_le;
+
+	verbose("Module is %s-bit %s-endian\n",
+		b64 ? "64" : "32",
+		be ? "big" : "little");
+
+	/* open the output file */
+	outfd = fopen(argv[2], "w");
+	if (!outfd) {
+		perror("open output");
+		exit(1);
+	}
+
+	/* perform the extraction */
+	if (b64)
+		extract_elf64(buffer, len, hdr64);
+	else
+		extract_elf32(buffer, len, hdr32);
+
+	/* done */
+	if (fclose(outfd) == EOF) {
+		perror("close output");
+		exit(1);
+	}
+
+	return 0;
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf64_rela(const void *buffer, int secix, int targetix,
+			       const Elf64_Rela *relatab, size_t nrels,
+			       const Elf64_Sym *symbols, size_t nsyms,
+			       const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+			       const char *strings, size_t nstrings,
+			       const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %zx in relocation %zu\n",
+				(size_t)ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf64_rel(const void *buffer, int secix, int targetix,
+			      const Elf64_Rel *relatab, size_t nrels,
+			      const Elf64_Sym *symbols, size_t nsyms,
+			      const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+			      const char *strings, size_t nstrings,
+			      const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %zx in relocation %zu\n",
+				(size_t)ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 64-bit module
+ */
+static void extract_elf64(void *buffer, size_t len, Elf64_Ehdr *hdr)
+{
+	const Elf64_Sym *symbols;
+	Elf64_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get64(&hdr->e_shoff);
+	secstrings = buffer + get64(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[loop].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[loop].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf64_Off   sh_offset	= get64(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+		else if ((sh_type == SHT_REL || sh_type == SHT_RELA) &&
+			 get64(&sections[sh_info].sh_flags) & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf64_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while (changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("CAN FILE POS CS SECT NAME\n");
+	verbose("=== ======== == ==== ==============================\n");
+
+	for (loop = 0; loop < canon; loop++) {
+		int sect = canonlist[loop];
+		const char *sh_name = secstrings + get32(&sections[sect].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[sect].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[sect].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[sect].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[sect].sh_info);
+		Elf64_Off   sh_offset	= get64(&sections[sect].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			Elf32_Word canon_sh_info;
+
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			set32(&canon_sh_info, canonmap[sh_info]);
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+			write_out_val(canon_sh_info);
+
+			if (sh_type == SHT_RELA)
+				extract_elf64_rela(buffer, sect, sh_info,
+						   data, sh_size / sizeof(Elf64_Rela),
+						   symbols, nsyms,
+						   sections, shnum, canonmap,
+						   strings, nstrings,
+						   sh_name);
+			else
+				extract_elf64_rel(buffer, sect, sh_info,
+						  data, sh_size / sizeof(Elf64_Rel),
+						  symbols, nsyms,
+						  sections, shnum, canonmap,
+						  strings, nstrings,
+						  sh_name);
+			continue;
+		}
+
+		/* include the headers of BSS sections */
+		if (sh_type == SHT_NOBITS && sh_flags & SHF_ALLOC) {
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+
+			verbose("%02x %4d %s\n", csum, sect, sh_name);
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%3u %08lx ", loop, ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[sect].sh_type);
+		write_out_val(sections[sect].sh_flags);
+		write_out_val(sections[sect].sh_size);
+		write_out_val(sections[sect].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, sect, sh_name);
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf32_rela(const void *buffer, int secix, int targetix,
+			       const Elf32_Rela *relatab, size_t nrels,
+			       const Elf32_Sym *symbols, size_t nsyms,
+			       const Elf32_Shdr *sections, size_t nsects,
+			       int *canonmap,
+			       const char *strings, size_t nstrings,
+			       const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static void extract_elf32_rel(const void *buffer, int secix, int targetix,
+			      const Elf32_Rel *relatab, size_t nrels,
+			      const Elf32_Sym *symbols, size_t nsyms,
+			      const Elf32_Shdr *sections, size_t nsects,
+			      int *canonmap,
+			      const char *strings, size_t nstrings,
+			      const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 32-bit module
+ */
+static void extract_elf32(void *buffer, size_t len, Elf32_Ehdr *hdr)
+{
+	const Elf32_Sym *symbols;
+	Elf32_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get32(&hdr->e_shoff);
+	secstrings = buffer + get32(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[loop].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[loop].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf32_Off   sh_offset	= get32(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+		else if ((sh_type == SHT_REL || sh_type == SHT_RELA) &&
+			 get32(&sections[sh_info].sh_flags) & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf32_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while (changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("CAN FILE POS CS SECT NAME\n");
+	verbose("=== ======== == ==== ==============================\n");
+
+	for (loop = 0; loop < canon; loop++) {
+		int sect = canonlist[loop];
+		const char *sh_name = secstrings + get32(&sections[sect].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[sect].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[sect].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[sect].sh_flags);
+		Elf32_Word  sh_info	= get32(&sections[sect].sh_info);
+		Elf32_Off   sh_offset	= get32(&sections[sect].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			Elf32_Word canon_sh_info;
+
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			set32(&canon_sh_info, canonmap[sh_info]);
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+			write_out_val(canon_sh_info);
+
+			if (sh_type == SHT_RELA)
+				extract_elf32_rela(buffer, sect, sh_info,
+						   data, sh_size / sizeof(Elf32_Rela),
+						   symbols, nsyms,
+						   sections, shnum, canonmap,
+						   strings, nstrings,
+						   sh_name);
+			else
+				extract_elf32_rel(buffer, sect, sh_info,
+						  data, sh_size / sizeof(Elf32_Rel),
+						  symbols, nsyms,
+						  sections, shnum, canonmap,
+						  strings, nstrings,
+						  sh_name);
+			continue;
+		}
+
+		/* include the headers of BSS sections */
+		if (sh_type == SHT_NOBITS && sh_flags & SHF_ALLOC) {
+			verbose("%3u %08lx ", loop, ftell(outfd));
+
+			/* write out selected portions of the section header */
+			write_out(sh_name, strlen(sh_name));
+			write_out_val(sections[sect].sh_type);
+			write_out_val(sections[sect].sh_flags);
+			write_out_val(sections[sect].sh_size);
+			write_out_val(sections[sect].sh_addralign);
+
+			verbose("%02x %4d %s\n", csum, sect, sh_name);
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%3u %08lx ", loop, ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[sect].sh_type);
+		write_out_val(sections[sect].sh_flags);
+		write_out_val(sections[sect].sh_size);
+		write_out_val(sections[sect].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, sect, sh_name);
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
diff --git a/scripts/mod/modsign-note.sh b/scripts/mod/modsign-note.sh
new file mode 100644
index 0000000..bca67c0
--- /dev/null
+++ b/scripts/mod/modsign-note.sh
@@ -0,0 +1,16 @@
+#!/bin/sh
+#
+# Generate a module signature note source file
+#
+# mod-sign.sh <sig-file> ><note-src-file>
+#
+
+SIG=$1
+
+cat <<EOF
+#include <linux/modsign.h>
+
+ELFNOTE(MODSIGN_NOTE_NAME, MODSIGN_NOTE_TYPE, .incbin "$SIG")
+EOF
+
+exit 0

