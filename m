Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2ENHMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:12:14 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47334 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2ENHML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:11 -0400
X-AuditID: 9c93016f-b7cecae000000e00-e6-4fb0b047e656
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] perf symbols: Implement poor man's ELF parser
Date: Mon, 14 May 2012 16:10:24 +0900
Message-Id: <1336979424-17206-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement minimalistic elf parser for getting build-id.
A couple of structs needed are copied from elf.h and
the parser only looks for PT_NOTE program header to
check build-id.
---
 tools/perf/util/elf-minimal.h    |  153 ++++++++++++++++++++++++
 tools/perf/util/symbol-minimal.c |  244 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 388 insertions(+), 9 deletions(-)
 create mode 100644 tools/perf/util/elf-minimal.h

diff --git a/tools/perf/util/elf-minimal.h b/tools/perf/util/elf-minimal.h
new file mode 100644
index 000000000000..26540b5718a1
--- /dev/null
+++ b/tools/perf/util/elf-minimal.h
@@ -0,0 +1,153 @@
+/*
+ * Minimal ELF definitions for parsing build-id.
+ */
+/* This file defines standard ELF types, structures, and macros.
+   Copyright (C) 1995-2003,2004,2005,2006,2007,2008,2009,2010,2011
+	Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library; if not, write to the Free
+   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+   02111-1307 USA.  */
+
+#ifndef _ELF_MINIMAL_H
+#define	_ELF_MINIMAL_H 1
+
+/* Standard ELF types.  */
+
+#include <stdint.h>
+
+/* Type for a 16-bit quantity.  */
+typedef uint16_t Elf32_Half;
+typedef uint16_t Elf64_Half;
+
+/* Types for signed and unsigned 32-bit quantities.  */
+typedef uint32_t Elf32_Word;
+typedef	int32_t  Elf32_Sword;
+typedef uint32_t Elf64_Word;
+typedef	int32_t  Elf64_Sword;
+
+/* Types for signed and unsigned 64-bit quantities.  */
+typedef uint64_t Elf32_Xword;
+typedef	int64_t  Elf32_Sxword;
+typedef uint64_t Elf64_Xword;
+typedef	int64_t  Elf64_Sxword;
+
+/* Type of addresses.  */
+typedef uint32_t Elf32_Addr;
+typedef uint64_t Elf64_Addr;
+
+/* Type of file offsets.  */
+typedef uint32_t Elf32_Off;
+typedef uint64_t Elf64_Off;
+
+
+/* The ELF file header.  This appears at the start of every ELF file.  */
+
+#define EI_NIDENT (16)
+
+typedef struct
+{
+  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */
+  Elf32_Half	e_type;			/* Object file type */
+  Elf32_Half	e_machine;		/* Architecture */
+  Elf32_Word	e_version;		/* Object file version */
+  Elf32_Addr	e_entry;		/* Entry point virtual address */
+  Elf32_Off	e_phoff;		/* Program header table file offset */
+  Elf32_Off	e_shoff;		/* Section header table file offset */
+  Elf32_Word	e_flags;		/* Processor-specific flags */
+  Elf32_Half	e_ehsize;		/* ELF header size in bytes */
+  Elf32_Half	e_phentsize;		/* Program header table entry size */
+  Elf32_Half	e_phnum;		/* Program header table entry count */
+  Elf32_Half	e_shentsize;		/* Section header table entry size */
+  Elf32_Half	e_shnum;		/* Section header table entry count */
+  Elf32_Half	e_shstrndx;		/* Section header string table index */
+} Elf32_Ehdr;
+
+typedef struct
+{
+  unsigned char	e_ident[EI_NIDENT];	/* Magic number and other info */
+  Elf64_Half	e_type;			/* Object file type */
+  Elf64_Half	e_machine;		/* Architecture */
+  Elf64_Word	e_version;		/* Object file version */
+  Elf64_Addr	e_entry;		/* Entry point virtual address */
+  Elf64_Off	e_phoff;		/* Program header table file offset */
+  Elf64_Off	e_shoff;		/* Section header table file offset */
+  Elf64_Word	e_flags;		/* Processor-specific flags */
+  Elf64_Half	e_ehsize;		/* ELF header size in bytes */
+  Elf64_Half	e_phentsize;		/* Program header table entry size */
+  Elf64_Half	e_phnum;		/* Program header table entry count */
+  Elf64_Half	e_shentsize;		/* Section header table entry size */
+  Elf64_Half	e_shnum;		/* Section header table entry count */
+  Elf64_Half	e_shstrndx;		/* Section header string table index */
+} Elf64_Ehdr;
+
+/* Conglomeration of the identification bytes, for easy testing as a word.  */
+#define	ELFMAG		"\177ELF"
+#define	SELFMAG		4
+
+#define EI_CLASS	4		/* File class byte index */
+#define ELFCLASSNONE	0		/* Invalid class */
+#define ELFCLASS32	1		/* 32-bit objects */
+#define ELFCLASS64	2		/* 64-bit objects */
+#define ELFCLASSNUM	3
+
+#define EI_DATA		5		/* Data encoding byte index */
+#define ELFDATANONE	0		/* Invalid data encoding */
+#define ELFDATA2LSB	1		/* 2's complement, little endian */
+#define ELFDATA2MSB	2		/* 2's complement, big endian */
+#define ELFDATANUM	3
+
+#define EI_VERSION	6		/* File version byte index */
+					/* Value must be EV_CURRENT */
+
+/* Legal values for e_version (version).  */
+
+#define EV_NONE		0		/* Invalid ELF version */
+#define EV_CURRENT	1		/* Current version */
+#define EV_NUM		2
+
+#define EI_PAD		9		/* Byte index of padding bytes */
+
+/* Program segment header.  */
+
+typedef struct
+{
+  Elf32_Word	p_type;			/* Segment type */
+  Elf32_Off	p_offset;		/* Segment file offset */
+  Elf32_Addr	p_vaddr;		/* Segment virtual address */
+  Elf32_Addr	p_paddr;		/* Segment physical address */
+  Elf32_Word	p_filesz;		/* Segment size in file */
+  Elf32_Word	p_memsz;		/* Segment size in memory */
+  Elf32_Word	p_flags;		/* Segment flags */
+  Elf32_Word	p_align;		/* Segment alignment */
+} Elf32_Phdr;
+
+typedef struct
+{
+  Elf64_Word	p_type;			/* Segment type */
+  Elf64_Word	p_flags;		/* Segment flags */
+  Elf64_Off	p_offset;		/* Segment file offset */
+  Elf64_Addr	p_vaddr;		/* Segment virtual address */
+  Elf64_Addr	p_paddr;		/* Segment physical address */
+  Elf64_Xword	p_filesz;		/* Segment size in file */
+  Elf64_Xword	p_memsz;		/* Segment size in memory */
+  Elf64_Xword	p_align;		/* Segment alignment */
+} Elf64_Phdr;
+
+/* Legal values for p_type (segment type).  */
+
+#define PT_NOTE		4		/* Auxiliary information */
+
+#endif	/* _ELF_MINIMAL_H */
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 2917ede1d5ba..dfef571abc9b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,29 +1,255 @@
 #include "symbol.h"
+#include "elf-minimal.h"
 
+#include <stdio.h>
+#include <fcntl.h>
+#include <string.h>
+#include <byteswap.h>
+#include <sys/stat.h>
 
-int filename__read_build_id(const char *filename __used, void *bf __used,
-			    size_t size __used)
+static bool check_need_swap(int file_endian)
 {
-	return -1;
+	const int data = 1;
+	u8 *check = (u8 *)&data;
+	int host_endian;
+
+	if (check[0] == 1)
+		host_endian = ELFDATA2LSB;
+	else
+		host_endian = ELFDATA2MSB;
+
+	return host_endian != file_endian;
 }
 
-int sysfs__read_build_id(const char *filename __used, void *build_id __used,
-			 size_t size __used)
+#define NOTE_ALIGN(sz) (((sz) + 3) & ~3)
+
+#define NT_GNU_BUILD_ID	3
+
+static int read_build_id(void *note_data, size_t note_len, void *bf,
+			 size_t size, bool need_swap)
 {
+	struct {
+		u32 n_namesz;
+		u32 n_descsz;
+		u32 n_type;
+	} *nhdr;
+	void *ptr;
+
+	ptr = note_data;
+	while (ptr < (note_data + note_len)) {
+		const char *name;
+		size_t namesz, descsz;
+
+		nhdr = ptr;
+		if (need_swap) {
+			nhdr->n_namesz = bswap_32(nhdr->n_namesz);
+			nhdr->n_descsz = bswap_32(nhdr->n_descsz);
+			nhdr->n_type = bswap_32(nhdr->n_type);
+		}
+
+		namesz = NOTE_ALIGN(nhdr->n_namesz);
+		descsz = NOTE_ALIGN(nhdr->n_descsz);
+
+		ptr += sizeof(*nhdr);
+		name = ptr;
+		ptr += namesz;
+		if (nhdr->n_type == NT_GNU_BUILD_ID &&
+		    nhdr->n_namesz == sizeof("GNU")) {
+			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
+				size_t sz = min(size, descsz);
+				memcpy(bf, ptr, sz);
+				memset(bf + sz, 0, size - sz);
+				return 0;
+			}
+		}
+		ptr += descsz;
+	}
+
 	return -1;
 }
 
+/*
+ * Just try PT_NOTE header otherwise fails
+ */
+int filename__read_build_id(const char *filename, void *bf, size_t size)
+{
+	FILE *fp;
+	int ret = -1;
+	bool need_swap = false;
+	u8 e_ident[EI_NIDENT];
+	size_t buf_size;
+	void *buf;
+	int i;
+
+	fp = fopen(filename, "r");
+	if (fp == NULL)
+		return -1;
+
+	if (fread(e_ident, sizeof(e_ident), 1, fp) != 1)
+		goto out;
+
+	if (memcmp(e_ident, ELFMAG, SELFMAG) ||
+	    e_ident[EI_VERSION] != EV_CURRENT)
+		goto out;
+
+	need_swap = check_need_swap(e_ident[EI_DATA]);
+
+	/* for simplicity */
+	fseek(fp, 0, SEEK_SET);
+
+	if (e_ident[EI_CLASS] == ELFCLASS32) {
+		Elf32_Ehdr ehdr;
+		Elf32_Phdr *phdr;
+
+		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
+			goto out;
+
+		if (need_swap) {
+			ehdr.e_phoff = bswap_32(ehdr.e_phoff);
+			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
+			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+		}
+
+		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
+		buf = malloc(buf_size);
+		if (buf == NULL)
+			goto out;
+
+		fseek(fp, ehdr.e_phoff, SEEK_SET);
+		if (fread(buf, buf_size, 1, fp) != 1)
+			goto out_free;
+
+		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
+			void *tmp;
+
+			if (need_swap) {
+				phdr->p_type = bswap_32(phdr->p_type);
+				phdr->p_offset = bswap_32(phdr->p_offset);
+				phdr->p_filesz = bswap_32(phdr->p_filesz);
+			}
+
+			if (phdr->p_type != PT_NOTE)
+				continue;
+
+			buf_size = phdr->p_filesz;
+			tmp = realloc(buf, buf_size);
+			if (tmp == NULL)
+				goto out_free;
+
+			buf = tmp;
+			fseek(fp, phdr->p_offset, SEEK_SET);
+			if (fread(buf, buf_size, 1, fp) != 1)
+				goto out_free;
+
+			ret = read_build_id(buf, buf_size, bf, size, need_swap);
+			if (ret == 0)
+				ret = size;
+			break;
+		}
+	} else {
+		Elf64_Ehdr ehdr;
+		Elf64_Phdr *phdr;
+
+		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
+			goto out;
+
+		if (need_swap) {
+			ehdr.e_phoff = bswap_64(ehdr.e_phoff);
+			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
+			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+		}
+
+		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
+		buf = malloc(buf_size);
+		if (buf == NULL)
+			goto out;
+
+		fseek(fp, ehdr.e_phoff, SEEK_SET);
+		if (fread(buf, buf_size, 1, fp) != 1)
+			goto out_free;
+
+		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
+			void *tmp;
+
+			if (need_swap) {
+				phdr->p_type = bswap_32(phdr->p_type);
+				phdr->p_offset = bswap_64(phdr->p_offset);
+				phdr->p_filesz = bswap_64(phdr->p_filesz);
+			}
+
+			if (phdr->p_type != PT_NOTE)
+				continue;
+
+			buf_size = phdr->p_filesz;
+			tmp = realloc(buf, buf_size);
+			if (tmp == NULL)
+				goto out_free;
+
+			buf = tmp;
+			fseek(fp, phdr->p_offset, SEEK_SET);
+			if (fread(buf, buf_size, 1, fp) != 1)
+				goto out_free;
+
+			ret = read_build_id(buf, buf_size, bf, size, need_swap);
+			if (ret == 0)
+				ret = size;
+			break;
+		}
+	}
+out_free:
+	free(buf);
+out:
+	fclose(fp);
+	return ret;
+}
+
+int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
+{
+	int fd;
+	int ret = -1;
+	struct stat stbuf;
+	size_t buf_size;
+	void *buf;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	if (fstat(fd, &stbuf) < 0)
+		goto out;
+
+	buf_size = stbuf.st_size;
+	buf = malloc(buf_size);
+	if (buf == NULL)
+		goto out;
+
+	if (read(fd, buf, buf_size) != (ssize_t) buf_size)
+		goto out_free;
+
+	ret = read_build_id(buf, buf_size, build_id, size, false);
+out_free:
+	free(buf);
+out:
+	close(fd);
+	return ret;
+}
+
 int dso__synthesize_plt_symbols(struct dso *dso __used, struct map *map __used,
 				symbol_filter_t filter __used)
 {
 	return 0;
 }
 
-int dso__load_sym(struct dso *dso __used, struct map *map __used,
-		  const char *name __used, int fd __used,
-		  symbol_filter_t filter __used, int kmodule __used,
-		  int want_symtab __used)
+int dso__load_sym(struct dso *dso, struct map *map __used, const char *name,
+		  int fd __used, symbol_filter_t filter __used,
+		  int kmodule __used, int want_symtab __used)
 {
+	unsigned char *build_id[BUILD_ID_SIZE];
+
+	if (filename__read_build_id(name, build_id, BUILD_ID_SIZE) > 0) {
+		dso__set_build_id(dso, build_id);
+		return 1;
+	}
 	return 0;
 }
 
-- 
1.7.10.1

