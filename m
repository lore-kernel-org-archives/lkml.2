Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2ENHMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:12:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47334 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2ENHMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:12:09 -0400
X-AuditID: 9c93016f-b7cecae000000e00-d0-4fb0b046ea3b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] perf tools: Split out util/symbol-elf.c
Date: Mon, 14 May 2012 16:10:22 +0900
Message-Id: <1336979424-17206-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the dependency of ELF handling into separate
symbol-elf.c file. It is a preparation of building a
minimalistic version perf tools which doesn't depend on
the elfutils.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/Makefile          |    1 +
 tools/perf/util/symbol-elf.c |  691 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.c     |  704 +-----------------------------------------
 tools/perf/util/symbol.h     |   15 +
 4 files changed, 715 insertions(+), 696 deletions(-)
 create mode 100644 tools/perf/util/symbol-elf.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e98e14c88532..7198c6cbc006 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -334,6 +334,7 @@ LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
+LIB_OBJS += $(OUTPUT)util/symbol-elf.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
new file mode 100644
index 000000000000..d68d16f89549
--- /dev/null
+++ b/tools/perf/util/symbol-elf.c
@@ -0,0 +1,691 @@
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <inttypes.h>
+
+#include "symbol.h"
+#include "debug.h"
+
+#ifndef NT_GNU_BUILD_ID
+#define NT_GNU_BUILD_ID 3
+#endif
+
+/**
+ * elf_symtab__for_each_symbol - iterate thru all the symbols
+ *
+ * @syms: struct elf_symtab instance to iterate
+ * @idx: uint32_t idx
+ * @sym: GElf_Sym iterator
+ */
+#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
+	for (idx = 0, gelf_getsym(syms, idx, &sym);\
+	     idx < nr_syms; \
+	     idx++, gelf_getsym(syms, idx, &sym))
+
+static inline uint8_t elf_sym__type(const GElf_Sym *sym)
+{
+	return GELF_ST_TYPE(sym->st_info);
+}
+
+static inline int elf_sym__is_function(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_FUNC &&
+	       sym->st_name != 0 &&
+	       sym->st_shndx != SHN_UNDEF;
+}
+
+static inline bool elf_sym__is_object(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_OBJECT &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF;
+}
+
+static inline int elf_sym__is_label(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_NOTYPE &&
+		sym->st_name != 0 &&
+		sym->st_shndx != SHN_UNDEF &&
+		sym->st_shndx != SHN_ABS;
+}
+
+static inline const char *elf_sec__name(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return secstrs->d_buf + shdr->sh_name;
+}
+
+static inline int elf_sec__is_text(const GElf_Shdr *shdr,
+					const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
+}
+
+static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
+				    const Elf_Data *secstrs)
+{
+	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
+}
+
+static inline const char *elf_sym__name(const GElf_Sym *sym,
+					const Elf_Data *symstrs)
+{
+	return symstrs->d_buf + sym->st_name;
+}
+
+static bool elf_sym__is_a(GElf_Sym *sym, enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sym__is_function(sym);
+	case MAP__VARIABLE:
+		return elf_sym__is_object(sym);
+	default:
+		return false;
+	}
+}
+
+static bool elf_sec__is_a(GElf_Shdr *shdr, Elf_Data *secstrs,
+			  enum map_type type)
+{
+	switch (type) {
+	case MAP__FUNCTION:
+		return elf_sec__is_text(shdr, secstrs);
+	case MAP__VARIABLE:
+		return elf_sec__is_data(shdr, secstrs);
+	default:
+		return false;
+	}
+}
+
+static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
+{
+	Elf_Scn *sec = NULL;
+	GElf_Shdr shdr;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		gelf_getshdr(sec, &shdr);
+
+		if ((addr >= shdr.sh_addr) &&
+		    (addr < (shdr.sh_addr + shdr.sh_size)))
+			return cnt;
+
+		++cnt;
+	}
+
+	return -1;
+}
+
+static int elf_sym__binding(const GElf_Sym *sym)
+{
+	switch (GELF_ST_BIND(sym->st_info)) {
+	case STB_GLOBAL:
+		return SYMBIND_GLOBAL;
+	case STB_WEAK:
+		return SYMBIND_WEAK;
+	default:
+		return SYMBIND_LOCAL;
+	}
+}
+
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name,
+				    size_t *idx)
+{
+	Elf_Scn *sec = NULL;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str)) {
+			if (idx)
+				*idx = cnt;
+			break;
+		}
+		++cnt;
+	}
+
+	return sec;
+}
+
+#define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrel(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrel(reldata, idx, &pos_mem))
+
+#define elf_section__for_each_rela(reldata, pos, pos_mem, idx, nr_entries) \
+	for (idx = 0, pos = gelf_getrela(reldata, 0, &pos_mem); \
+	     idx < nr_entries; \
+	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
+
+/*
+ * We need to check if we have a .dynsym, so that we can handle the
+ * .plt, synthesizing its symbols, that aren't on the symtabs (be it
+ * .dynsym or .symtab).
+ * And always look at the original dso, not at debuginfo packages, that
+ * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
+ */
+int dso__synthesize_plt_symbols(struct dso *dso, struct map *map,
+				symbol_filter_t filter)
+{
+	uint32_t nr_rel_entries, idx;
+	GElf_Sym sym;
+	u64 plt_offset;
+	GElf_Shdr shdr_plt;
+	struct symbol *f;
+	GElf_Shdr shdr_rel_plt, shdr_dynsym;
+	Elf_Data *reldata, *syms, *symstrs;
+	Elf_Scn *scn_plt_rel, *scn_symstrs, *scn_dynsym;
+	size_t dynsym_idx;
+	GElf_Ehdr ehdr;
+	char sympltname[1024];
+	Elf *elf;
+	int nr = 0, symidx, fd, err = 0;
+	char name[PATH_MAX];
+
+	snprintf(name, sizeof(name), "%s%s",
+		 symbol_conf.symfs, dso->long_name);
+	fd = open(name, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL)
+		goto out_close;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		goto out_elf_end;
+
+	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
+					 ".dynsym", &dynsym_idx);
+	if (scn_dynsym == NULL)
+		goto out_elf_end;
+
+	scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
+					  ".rela.plt", NULL);
+	if (scn_plt_rel == NULL) {
+		scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
+						  ".rel.plt", NULL);
+		if (scn_plt_rel == NULL)
+			goto out_elf_end;
+	}
+
+	err = -1;
+
+	if (shdr_rel_plt.sh_link != dynsym_idx)
+		goto out_elf_end;
+
+	if (elf_section_by_name(elf, &ehdr, &shdr_plt, ".plt", NULL) == NULL)
+		goto out_elf_end;
+
+	/*
+	 * Fetch the relocation section to find the idxes to the GOT
+	 * and the symbols in the .dynsym they refer to.
+	 */
+	reldata = elf_getdata(scn_plt_rel, NULL);
+	if (reldata == NULL)
+		goto out_elf_end;
+
+	syms = elf_getdata(scn_dynsym, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	scn_symstrs = elf_getscn(elf, shdr_dynsym.sh_link);
+	if (scn_symstrs == NULL)
+		goto out_elf_end;
+
+	symstrs = elf_getdata(scn_symstrs, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
+	plt_offset = shdr_plt.sh_offset;
+
+	if (shdr_rel_plt.sh_type == SHT_RELA) {
+		GElf_Rela pos_mem, *pos;
+
+		elf_section__for_each_rela(reldata, pos, pos_mem, idx,
+					   nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					SYMBIND_GLOBAL, sympltname);
+			if (!f)
+				goto out_elf_end;
+
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				symbols__insert(&dso->symbols[map->type], f);
+				++nr;
+			}
+		}
+	} else if (shdr_rel_plt.sh_type == SHT_REL) {
+		GElf_Rel pos_mem, *pos;
+		elf_section__for_each_rel(reldata, pos, pos_mem, idx,
+					  nr_rel_entries) {
+			symidx = GELF_R_SYM(pos->r_info);
+			plt_offset += shdr_plt.sh_entsize;
+			gelf_getsym(syms, symidx, &sym);
+			snprintf(sympltname, sizeof(sympltname),
+				 "%s@plt", elf_sym__name(&sym, symstrs));
+
+			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
+					SYMBIND_GLOBAL, sympltname);
+			if (!f)
+				goto out_elf_end;
+
+			if (filter && filter(map, f))
+				symbol__delete(f);
+			else {
+				symbols__insert(&dso->symbols[map->type], f);
+				++nr;
+			}
+		}
+	}
+
+	err = 0;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+
+	if (err == 0)
+		return nr;
+out:
+	pr_debug("%s: problems reading %s PLT info.\n",
+		 __func__, dso->long_name);
+	return 0;
+}
+
+/*
+ * Align offset to 4 bytes as needed for note name and descriptor data.
+ */
+#define NOTE_ALIGN(n) (((n) + 3) & -4U)
+
+static int elf_read_build_id(Elf *elf, void *bf, size_t size)
+{
+	int err = -1;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *data;
+	Elf_Scn *sec;
+	Elf_Kind ek;
+	void *ptr;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	ek = elf_kind(elf);
+	if (ek != ELF_K_ELF)
+		goto out;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		pr_err("%s: cannot get elf header.\n", __func__);
+		goto out;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr,
+				  ".note.gnu.build-id", NULL);
+	if (sec == NULL) {
+		sec = elf_section_by_name(elf, &ehdr, &shdr,
+					  ".notes", NULL);
+		if (sec == NULL)
+			goto out;
+	}
+
+	data = elf_getdata(sec, NULL);
+	if (data == NULL)
+		goto out;
+
+	ptr = data->d_buf;
+	while (ptr < (data->d_buf + data->d_size)) {
+		GElf_Nhdr *nhdr = ptr;
+		size_t namesz = NOTE_ALIGN(nhdr->n_namesz),
+		       descsz = NOTE_ALIGN(nhdr->n_descsz);
+		const char *name;
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
+				err = descsz;
+				break;
+			}
+		}
+		ptr += descsz;
+	}
+
+out:
+	return err;
+}
+
+int filename__read_build_id(const char *filename, void *bf, size_t size)
+{
+	int fd, err = -1;
+	Elf *elf;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
+		goto out_close;
+	}
+
+	err = elf_read_build_id(elf, bf, size);
+
+	elf_end(elf);
+out_close:
+	close(fd);
+out:
+	return err;
+}
+
+int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
+{
+	int fd, err = -1;
+
+	if (size < BUILD_ID_SIZE)
+		goto out;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		goto out;
+
+	while (1) {
+		char bf[BUFSIZ];
+		GElf_Nhdr nhdr;
+		size_t namesz, descsz;
+
+		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
+			break;
+
+		namesz = NOTE_ALIGN(nhdr.n_namesz);
+		descsz = NOTE_ALIGN(nhdr.n_descsz);
+		if (nhdr.n_type == NT_GNU_BUILD_ID &&
+		    nhdr.n_namesz == sizeof("GNU")) {
+			if (read(fd, bf, namesz) != (ssize_t)namesz)
+				break;
+			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
+				size_t sz = min(descsz, size);
+				if (read(fd, build_id, sz) == (ssize_t)sz) {
+					memset(build_id + sz, 0, size - sz);
+					err = 0;
+					break;
+				}
+			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
+				break;
+		} else {
+			int n = namesz + descsz;
+			if (read(fd, bf, n) != n)
+				break;
+		}
+	}
+	close(fd);
+out:
+	return err;
+}
+
+int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
+		  symbol_filter_t filter, int kmodule, int want_symtab)
+{
+	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
+	struct map *curr_map = map;
+	struct dso *curr_dso = dso;
+	Elf_Data *symstrs, *secstrs;
+	uint32_t nr_syms;
+	int err = -1;
+	uint32_t idx;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr, opdshdr;
+	Elf_Data *syms, *opddata = NULL;
+	GElf_Sym sym;
+	Elf_Scn *sec, *sec_strndx, *opdsec;
+	Elf *elf;
+	int nr = 0;
+	size_t opdidx = 0;
+
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
+		goto out_close;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		pr_debug("%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	/* Always reject images with a mismatched build-id: */
+	if (dso->has_build_id) {
+		u8 build_id[BUILD_ID_SIZE];
+
+		if (elf_read_build_id(elf, build_id, BUILD_ID_SIZE) < 0)
+			goto out_elf_end;
+
+		if (!dso__build_id_equal(dso, build_id))
+			goto out_elf_end;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	if (sec == NULL) {
+		if (want_symtab)
+			goto out_elf_end;
+
+		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+		if (sec == NULL)
+			goto out_elf_end;
+	}
+
+	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
+	if (opdshdr.sh_type != SHT_PROGBITS)
+		opdsec = NULL;
+	if (opdsec)
+		opddata = elf_rawdata(opdsec, NULL);
+
+	syms = elf_getdata(sec, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	sec = elf_getscn(elf, shdr.sh_link);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	symstrs = elf_getdata(sec, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
+	if (sec_strndx == NULL)
+		goto out_elf_end;
+
+	secstrs = elf_getdata(sec_strndx, NULL);
+	if (secstrs == NULL)
+		goto out_elf_end;
+
+	nr_syms = shdr.sh_size / shdr.sh_entsize;
+
+	memset(&sym, 0, sizeof(sym));
+	if (dso->kernel == DSO_TYPE_USER) {
+		dso->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				elf_section_by_name(elf, &ehdr, &shdr,
+						     ".gnu.prelink_undo",
+						     NULL) != NULL);
+	} else {
+		dso->adjust_symbols = 0;
+	}
+	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
+		struct symbol *f;
+		const char *elf_name = elf_sym__name(&sym, symstrs);
+		char *demangled = NULL;
+		int is_label = elf_sym__is_label(&sym);
+		const char *section_name;
+
+		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
+		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
+			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
+
+		if (!is_label && !elf_sym__is_a(&sym, map->type))
+			continue;
+
+		/* Reject ARM ELF "mapping symbols": these aren't unique and
+		 * don't identify functions, so will confuse the profile
+		 * output: */
+		if (ehdr.e_machine == EM_ARM) {
+			if (!strcmp(elf_name, "$a") ||
+			    !strcmp(elf_name, "$d") ||
+			    !strcmp(elf_name, "$t"))
+				continue;
+		}
+
+		if (opdsec && sym.st_shndx == opdidx) {
+			u32 offset = sym.st_value - opdshdr.sh_addr;
+			u64 *opd = opddata->d_buf + offset;
+			sym.st_value = *opd;
+			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
+		}
+
+		sec = elf_getscn(elf, sym.st_shndx);
+		if (!sec)
+			goto out_elf_end;
+
+		gelf_getshdr(sec, &shdr);
+
+		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
+			continue;
+
+		section_name = elf_sec__name(&shdr, secstrs);
+
+		/* On ARM, symbols for thumb functions have 1 added to
+		 * the symbol address as a flag - remove it */
+		if ((ehdr.e_machine == EM_ARM) &&
+		    (map->type == MAP__FUNCTION) &&
+		    (sym.st_value & 1))
+			--sym.st_value;
+
+		if (dso->kernel != DSO_TYPE_USER || kmodule) {
+			char dso_name[PATH_MAX];
+
+			if (strcmp(section_name,
+				   (curr_dso->short_name +
+				    dso->short_name_len)) == 0)
+				goto new_symbol;
+
+			if (strcmp(section_name, ".text") == 0) {
+				curr_map = map;
+				curr_dso = dso;
+				goto new_symbol;
+			}
+
+			snprintf(dso_name, sizeof(dso_name),
+				 "%s%s", dso->short_name, section_name);
+
+			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
+			if (curr_map == NULL) {
+				u64 start = sym.st_value;
+
+				if (kmodule)
+					start += map->start + shdr.sh_offset;
+
+				curr_dso = dso__new(dso_name);
+				if (curr_dso == NULL)
+					goto out_elf_end;
+				curr_dso->kernel = dso->kernel;
+				curr_dso->long_name = dso->long_name;
+				curr_dso->long_name_len = dso->long_name_len;
+				curr_map = map__new2(start, curr_dso,
+						     map->type);
+				if (curr_map == NULL) {
+					dso__delete(curr_dso);
+					goto out_elf_end;
+				}
+				curr_map->map_ip = identity__map_ip;
+				curr_map->unmap_ip = identity__map_ip;
+				curr_dso->symtab_type = dso->symtab_type;
+				map_groups__insert(kmap->kmaps, curr_map);
+				dsos__add(&dso->node, curr_dso);
+				dso__set_loaded(curr_dso, map->type);
+			} else
+				curr_dso = curr_map->dso;
+
+			goto new_symbol;
+		}
+
+		if (curr_dso->adjust_symbols) {
+			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
+				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
+				  (u64)sym.st_value, (u64)shdr.sh_addr,
+				  (u64)shdr.sh_offset);
+			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+		}
+		/*
+		 * We need to figure out if the object was created from C++ sources
+		 * DWARF DW_compile_unit has this, but we don't always have access
+		 * to it...
+		 */
+		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
+		if (demangled != NULL)
+			elf_name = demangled;
+new_symbol:
+		f = symbol__new(sym.st_value, sym.st_size,
+				elf_sym__binding(&sym), elf_name);
+		free(demangled);
+		if (!f)
+			goto out_elf_end;
+
+		if (filter && filter(curr_map, f))
+			symbol__delete(f);
+		else {
+			symbols__insert(&curr_dso->symbols[curr_map->type], f);
+			nr++;
+		}
+	}
+
+	/*
+	 * For misannotated, zeroed, ASM function sizes.
+	 */
+	if (nr > 0) {
+		symbols__fixup_duplicate(&dso->symbols[map->type]);
+		symbols__fixup_end(&dso->symbols[map->type]);
+		if (kmap) {
+			/*
+			 * We need to fixup this here too because we create new
+			 * maps here, for things like vsyscall sections.
+			 */
+			__map_groups__fixup_end(kmap->kmaps, map->type);
+		}
+	}
+	err = nr;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	return err;
+}
+
+void symbol__elf_init(void)
+{
+	elf_version(EV_CURRENT);
+}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d4518a14edd8..462f91f1fe12 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -15,9 +15,6 @@
 #include "symbol.h"
 #include "strlist.h"
 
-#include <libelf.h>
-#include <gelf.h>
-#include <elf.h>
 #include <limits.h>
 #include <sys/utsname.h>
 
@@ -25,14 +22,7 @@
 #define KSYM_NAME_LEN 256
 #endif
 
-#ifndef NT_GNU_BUILD_ID
-#define NT_GNU_BUILD_ID 3
-#endif
 
-static bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
-static int elf_read_build_id(Elf *elf, void *bf, size_t size);
-static void dsos__add(struct list_head *head, struct dso *dso);
-static struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
 static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 				symbol_filter_t filter);
 static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
@@ -144,7 +134,7 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 		return SYMBOL_B;
 }
 
-static void symbols__fixup_duplicate(struct rb_root *symbols)
+void symbols__fixup_duplicate(struct rb_root *symbols)
 {
 	struct rb_node *nd;
 	struct symbol *curr, *next;
@@ -173,7 +163,7 @@ again:
 	}
 }
 
-static void symbols__fixup_end(struct rb_root *symbols)
+void symbols__fixup_end(struct rb_root *symbols)
 {
 	struct rb_node *nd, *prevnd = rb_first(symbols);
 	struct symbol *curr, *prev;
@@ -196,7 +186,7 @@ static void symbols__fixup_end(struct rb_root *symbols)
 		curr->end = roundup(curr->start, 4096);
 }
 
-static void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
+void __map_groups__fixup_end(struct map_groups *mg, enum map_type type)
 {
 	struct map *prev, *curr;
 	struct rb_node *nd, *prevnd = rb_first(&mg->maps[type]);
@@ -226,8 +216,7 @@ static void map_groups__fixup_end(struct map_groups *mg)
 		__map_groups__fixup_end(mg, i);
 }
 
-static struct symbol *symbol__new(u64 start, u64 len, u8 binding,
-				  const char *name)
+struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *sym = calloc(1, (symbol_conf.priv_size +
@@ -360,7 +349,7 @@ void dso__set_build_id(struct dso *dso, void *build_id)
 	dso->has_build_id = 1;
 }
 
-static void symbols__insert(struct rb_root *symbols, struct symbol *sym)
+void symbols__insert(struct rb_root *symbols, struct symbol *sym)
 {
 	struct rb_node **p = &symbols->rb_node;
 	struct rb_node *parent = NULL;
@@ -874,545 +863,7 @@ out_failure:
 	return -1;
 }
 
-/**
- * elf_symtab__for_each_symbol - iterate thru all the symbols
- *
- * @syms: struct elf_symtab instance to iterate
- * @idx: uint32_t idx
- * @sym: GElf_Sym iterator
- */
-#define elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) \
-	for (idx = 0, gelf_getsym(syms, idx, &sym);\
-	     idx < nr_syms; \
-	     idx++, gelf_getsym(syms, idx, &sym))
-
-static inline uint8_t elf_sym__type(const GElf_Sym *sym)
-{
-	return GELF_ST_TYPE(sym->st_info);
-}
-
-static inline int elf_sym__is_function(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_FUNC &&
-	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF;
-}
-
-static inline bool elf_sym__is_object(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_OBJECT &&
-		sym->st_name != 0 &&
-		sym->st_shndx != SHN_UNDEF;
-}
-
-static inline int elf_sym__is_label(const GElf_Sym *sym)
-{
-	return elf_sym__type(sym) == STT_NOTYPE &&
-		sym->st_name != 0 &&
-		sym->st_shndx != SHN_UNDEF &&
-		sym->st_shndx != SHN_ABS;
-}
-
-static inline const char *elf_sec__name(const GElf_Shdr *shdr,
-					const Elf_Data *secstrs)
-{
-	return secstrs->d_buf + shdr->sh_name;
-}
-
-static inline int elf_sec__is_text(const GElf_Shdr *shdr,
-					const Elf_Data *secstrs)
-{
-	return strstr(elf_sec__name(shdr, secstrs), "text") != NULL;
-}
-
-static inline bool elf_sec__is_data(const GElf_Shdr *shdr,
-				    const Elf_Data *secstrs)
-{
-	return strstr(elf_sec__name(shdr, secstrs), "data") != NULL;
-}
-
-static inline const char *elf_sym__name(const GElf_Sym *sym,
-					const Elf_Data *symstrs)
-{
-	return symstrs->d_buf + sym->st_name;
-}
-
-static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
-				    GElf_Shdr *shp, const char *name,
-				    size_t *idx)
-{
-	Elf_Scn *sec = NULL;
-	size_t cnt = 1;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		char *str;
-
-		gelf_getshdr(sec, shp);
-		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
-		if (!strcmp(name, str)) {
-			if (idx)
-				*idx = cnt;
-			break;
-		}
-		++cnt;
-	}
-
-	return sec;
-}
-
-#define elf_section__for_each_rel(reldata, pos, pos_mem, idx, nr_entries) \
-	for (idx = 0, pos = gelf_getrel(reldata, 0, &pos_mem); \
-	     idx < nr_entries; \
-	     ++idx, pos = gelf_getrel(reldata, idx, &pos_mem))
-
-#define elf_section__for_each_rela(reldata, pos, pos_mem, idx, nr_entries) \
-	for (idx = 0, pos = gelf_getrela(reldata, 0, &pos_mem); \
-	     idx < nr_entries; \
-	     ++idx, pos = gelf_getrela(reldata, idx, &pos_mem))
-
-/*
- * We need to check if we have a .dynsym, so that we can handle the
- * .plt, synthesizing its symbols, that aren't on the symtabs (be it
- * .dynsym or .symtab).
- * And always look at the original dso, not at debuginfo packages, that
- * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
- */
-static int dso__synthesize_plt_symbols(struct  dso *dso, struct map *map,
-				       symbol_filter_t filter)
-{
-	uint32_t nr_rel_entries, idx;
-	GElf_Sym sym;
-	u64 plt_offset;
-	GElf_Shdr shdr_plt;
-	struct symbol *f;
-	GElf_Shdr shdr_rel_plt, shdr_dynsym;
-	Elf_Data *reldata, *syms, *symstrs;
-	Elf_Scn *scn_plt_rel, *scn_symstrs, *scn_dynsym;
-	size_t dynsym_idx;
-	GElf_Ehdr ehdr;
-	char sympltname[1024];
-	Elf *elf;
-	int nr = 0, symidx, fd, err = 0;
-	char name[PATH_MAX];
-
-	snprintf(name, sizeof(name), "%s%s",
-		 symbol_conf.symfs, dso->long_name);
-	fd = open(name, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL)
-		goto out_close;
-
-	if (gelf_getehdr(elf, &ehdr) == NULL)
-		goto out_elf_end;
-
-	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
-					 ".dynsym", &dynsym_idx);
-	if (scn_dynsym == NULL)
-		goto out_elf_end;
-
-	scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
-					  ".rela.plt", NULL);
-	if (scn_plt_rel == NULL) {
-		scn_plt_rel = elf_section_by_name(elf, &ehdr, &shdr_rel_plt,
-						  ".rel.plt", NULL);
-		if (scn_plt_rel == NULL)
-			goto out_elf_end;
-	}
-
-	err = -1;
-
-	if (shdr_rel_plt.sh_link != dynsym_idx)
-		goto out_elf_end;
-
-	if (elf_section_by_name(elf, &ehdr, &shdr_plt, ".plt", NULL) == NULL)
-		goto out_elf_end;
-
-	/*
-	 * Fetch the relocation section to find the idxes to the GOT
-	 * and the symbols in the .dynsym they refer to.
-	 */
-	reldata = elf_getdata(scn_plt_rel, NULL);
-	if (reldata == NULL)
-		goto out_elf_end;
-
-	syms = elf_getdata(scn_dynsym, NULL);
-	if (syms == NULL)
-		goto out_elf_end;
-
-	scn_symstrs = elf_getscn(elf, shdr_dynsym.sh_link);
-	if (scn_symstrs == NULL)
-		goto out_elf_end;
-
-	symstrs = elf_getdata(scn_symstrs, NULL);
-	if (symstrs == NULL)
-		goto out_elf_end;
-
-	nr_rel_entries = shdr_rel_plt.sh_size / shdr_rel_plt.sh_entsize;
-	plt_offset = shdr_plt.sh_offset;
-
-	if (shdr_rel_plt.sh_type == SHT_RELA) {
-		GElf_Rela pos_mem, *pos;
-
-		elf_section__for_each_rela(reldata, pos, pos_mem, idx,
-					   nr_rel_entries) {
-			symidx = GELF_R_SYM(pos->r_info);
-			plt_offset += shdr_plt.sh_entsize;
-			gelf_getsym(syms, symidx, &sym);
-			snprintf(sympltname, sizeof(sympltname),
-				 "%s@plt", elf_sym__name(&sym, symstrs));
-
-			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					SYMBIND_GLOBAL, sympltname);
-			if (!f)
-				goto out_elf_end;
-
-			if (filter && filter(map, f))
-				symbol__delete(f);
-			else {
-				symbols__insert(&dso->symbols[map->type], f);
-				++nr;
-			}
-		}
-	} else if (shdr_rel_plt.sh_type == SHT_REL) {
-		GElf_Rel pos_mem, *pos;
-		elf_section__for_each_rel(reldata, pos, pos_mem, idx,
-					  nr_rel_entries) {
-			symidx = GELF_R_SYM(pos->r_info);
-			plt_offset += shdr_plt.sh_entsize;
-			gelf_getsym(syms, symidx, &sym);
-			snprintf(sympltname, sizeof(sympltname),
-				 "%s@plt", elf_sym__name(&sym, symstrs));
-
-			f = symbol__new(plt_offset, shdr_plt.sh_entsize,
-					SYMBIND_GLOBAL, sympltname);
-			if (!f)
-				goto out_elf_end;
-
-			if (filter && filter(map, f))
-				symbol__delete(f);
-			else {
-				symbols__insert(&dso->symbols[map->type], f);
-				++nr;
-			}
-		}
-	}
-
-	err = 0;
-out_elf_end:
-	elf_end(elf);
-out_close:
-	close(fd);
-
-	if (err == 0)
-		return nr;
-out:
-	pr_debug("%s: problems reading %s PLT info.\n",
-		 __func__, dso->long_name);
-	return 0;
-}
-
-static bool elf_sym__is_a(GElf_Sym *sym, enum map_type type)
-{
-	switch (type) {
-	case MAP__FUNCTION:
-		return elf_sym__is_function(sym);
-	case MAP__VARIABLE:
-		return elf_sym__is_object(sym);
-	default:
-		return false;
-	}
-}
-
-static bool elf_sec__is_a(GElf_Shdr *shdr, Elf_Data *secstrs,
-			  enum map_type type)
-{
-	switch (type) {
-	case MAP__FUNCTION:
-		return elf_sec__is_text(shdr, secstrs);
-	case MAP__VARIABLE:
-		return elf_sec__is_data(shdr, secstrs);
-	default:
-		return false;
-	}
-}
-
-static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
-{
-	Elf_Scn *sec = NULL;
-	GElf_Shdr shdr;
-	size_t cnt = 1;
-
-	while ((sec = elf_nextscn(elf, sec)) != NULL) {
-		gelf_getshdr(sec, &shdr);
-
-		if ((addr >= shdr.sh_addr) &&
-		    (addr < (shdr.sh_addr + shdr.sh_size)))
-			return cnt;
-
-		++cnt;
-	}
-
-	return -1;
-}
-
-static int elf_sym__binding(const GElf_Sym *sym)
-{
-	switch (GELF_ST_BIND(sym->st_info)) {
-	case STB_GLOBAL:
-		return SYMBIND_GLOBAL;
-	case STB_WEAK:
-		return SYMBIND_WEAK;
-	default:
-		return SYMBIND_LOCAL;
-	}
-}
-
-static int dso__load_sym(struct dso *dso, struct map *map, const char *name,
-			 int fd, symbol_filter_t filter, int kmodule,
-			 int want_symtab)
-{
-	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
-	struct map *curr_map = map;
-	struct dso *curr_dso = dso;
-	Elf_Data *symstrs, *secstrs;
-	uint32_t nr_syms;
-	int err = -1;
-	uint32_t idx;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr, opdshdr;
-	Elf_Data *syms, *opddata = NULL;
-	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx, *opdsec;
-	Elf *elf;
-	int nr = 0;
-	size_t opdidx = 0;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
-		goto out_close;
-	}
-
-	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		pr_debug("%s: cannot get elf header.\n", __func__);
-		goto out_elf_end;
-	}
-
-	/* Always reject images with a mismatched build-id: */
-	if (dso->has_build_id) {
-		u8 build_id[BUILD_ID_SIZE];
-
-		if (elf_read_build_id(elf, build_id, BUILD_ID_SIZE) < 0)
-			goto out_elf_end;
-
-		if (!dso__build_id_equal(dso, build_id))
-			goto out_elf_end;
-	}
-
-	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
-	if (sec == NULL) {
-		if (want_symtab)
-			goto out_elf_end;
-
-		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
-		if (sec == NULL)
-			goto out_elf_end;
-	}
-
-	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
-	if (opdshdr.sh_type != SHT_PROGBITS)
-		opdsec = NULL;
-	if (opdsec)
-		opddata = elf_rawdata(opdsec, NULL);
-
-	syms = elf_getdata(sec, NULL);
-	if (syms == NULL)
-		goto out_elf_end;
-
-	sec = elf_getscn(elf, shdr.sh_link);
-	if (sec == NULL)
-		goto out_elf_end;
-
-	symstrs = elf_getdata(sec, NULL);
-	if (symstrs == NULL)
-		goto out_elf_end;
-
-	sec_strndx = elf_getscn(elf, ehdr.e_shstrndx);
-	if (sec_strndx == NULL)
-		goto out_elf_end;
-
-	secstrs = elf_getdata(sec_strndx, NULL);
-	if (secstrs == NULL)
-		goto out_elf_end;
-
-	nr_syms = shdr.sh_size / shdr.sh_entsize;
-
-	memset(&sym, 0, sizeof(sym));
-	if (dso->kernel == DSO_TYPE_USER) {
-		dso->adjust_symbols = (ehdr.e_type == ET_EXEC ||
-				elf_section_by_name(elf, &ehdr, &shdr,
-						     ".gnu.prelink_undo",
-						     NULL) != NULL);
-	} else {
-		dso->adjust_symbols = 0;
-	}
-	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
-		struct symbol *f;
-		const char *elf_name = elf_sym__name(&sym, symstrs);
-		char *demangled = NULL;
-		int is_label = elf_sym__is_label(&sym);
-		const char *section_name;
-
-		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
-		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
-			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
-
-		if (!is_label && !elf_sym__is_a(&sym, map->type))
-			continue;
-
-		/* Reject ARM ELF "mapping symbols": these aren't unique and
-		 * don't identify functions, so will confuse the profile
-		 * output: */
-		if (ehdr.e_machine == EM_ARM) {
-			if (!strcmp(elf_name, "$a") ||
-			    !strcmp(elf_name, "$d") ||
-			    !strcmp(elf_name, "$t"))
-				continue;
-		}
-
-		if (opdsec && sym.st_shndx == opdidx) {
-			u32 offset = sym.st_value - opdshdr.sh_addr;
-			u64 *opd = opddata->d_buf + offset;
-			sym.st_value = *opd;
-			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
-		}
-
-		sec = elf_getscn(elf, sym.st_shndx);
-		if (!sec)
-			goto out_elf_end;
-
-		gelf_getshdr(sec, &shdr);
-
-		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
-			continue;
-
-		section_name = elf_sec__name(&shdr, secstrs);
-
-		/* On ARM, symbols for thumb functions have 1 added to
-		 * the symbol address as a flag - remove it */
-		if ((ehdr.e_machine == EM_ARM) &&
-		    (map->type == MAP__FUNCTION) &&
-		    (sym.st_value & 1))
-			--sym.st_value;
-
-		if (dso->kernel != DSO_TYPE_USER || kmodule) {
-			char dso_name[PATH_MAX];
-
-			if (strcmp(section_name,
-				   (curr_dso->short_name +
-				    dso->short_name_len)) == 0)
-				goto new_symbol;
-
-			if (strcmp(section_name, ".text") == 0) {
-				curr_map = map;
-				curr_dso = dso;
-				goto new_symbol;
-			}
-
-			snprintf(dso_name, sizeof(dso_name),
-				 "%s%s", dso->short_name, section_name);
-
-			curr_map = map_groups__find_by_name(kmap->kmaps, map->type, dso_name);
-			if (curr_map == NULL) {
-				u64 start = sym.st_value;
-
-				if (kmodule)
-					start += map->start + shdr.sh_offset;
-
-				curr_dso = dso__new(dso_name);
-				if (curr_dso == NULL)
-					goto out_elf_end;
-				curr_dso->kernel = dso->kernel;
-				curr_dso->long_name = dso->long_name;
-				curr_dso->long_name_len = dso->long_name_len;
-				curr_map = map__new2(start, curr_dso,
-						     map->type);
-				if (curr_map == NULL) {
-					dso__delete(curr_dso);
-					goto out_elf_end;
-				}
-				curr_map->map_ip = identity__map_ip;
-				curr_map->unmap_ip = identity__map_ip;
-				curr_dso->symtab_type = dso->symtab_type;
-				map_groups__insert(kmap->kmaps, curr_map);
-				dsos__add(&dso->node, curr_dso);
-				dso__set_loaded(curr_dso, map->type);
-			} else
-				curr_dso = curr_map->dso;
-
-			goto new_symbol;
-		}
-
-		if (curr_dso->adjust_symbols) {
-			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
-		}
-		/*
-		 * We need to figure out if the object was created from C++ sources
-		 * DWARF DW_compile_unit has this, but we don't always have access
-		 * to it...
-		 */
-		demangled = bfd_demangle(NULL, elf_name, DMGL_PARAMS | DMGL_ANSI);
-		if (demangled != NULL)
-			elf_name = demangled;
-new_symbol:
-		f = symbol__new(sym.st_value, sym.st_size,
-				elf_sym__binding(&sym), elf_name);
-		free(demangled);
-		if (!f)
-			goto out_elf_end;
-
-		if (filter && filter(curr_map, f))
-			symbol__delete(f);
-		else {
-			symbols__insert(&curr_dso->symbols[curr_map->type], f);
-			nr++;
-		}
-	}
-
-	/*
-	 * For misannotated, zeroed, ASM function sizes.
-	 */
-	if (nr > 0) {
-		symbols__fixup_duplicate(&dso->symbols[map->type]);
-		symbols__fixup_end(&dso->symbols[map->type]);
-		if (kmap) {
-			/*
-			 * We need to fixup this here too because we create new
-			 * maps here, for things like vsyscall sections.
-			 */
-			__map_groups__fixup_end(kmap->kmaps, map->type);
-		}
-	}
-	err = nr;
-out_elf_end:
-	elf_end(elf);
-out_close:
-	return err;
-}
-
-void symbol__elf_init(void)
-{
-	elf_version(EV_CURRENT);
-}
-
-static bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
+bool dso__build_id_equal(const struct dso *dso, u8 *build_id)
 {
 	return memcmp(dso->build_id, build_id, sizeof(dso->build_id)) == 0;
 }
@@ -1439,145 +890,6 @@ bool __dsos__read_build_ids(struct list_head *head, bool with_hits)
 	return have_build_id;
 }
 
-/*
- * Align offset to 4 bytes as needed for note name and descriptor data.
- */
-#define NOTE_ALIGN(n) (((n) + 3) & -4U)
-
-static int elf_read_build_id(Elf *elf, void *bf, size_t size)
-{
-	int err = -1;
-	GElf_Ehdr ehdr;
-	GElf_Shdr shdr;
-	Elf_Data *data;
-	Elf_Scn *sec;
-	Elf_Kind ek;
-	void *ptr;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	ek = elf_kind(elf);
-	if (ek != ELF_K_ELF)
-		goto out;
-
-	if (gelf_getehdr(elf, &ehdr) == NULL) {
-		pr_err("%s: cannot get elf header.\n", __func__);
-		goto out;
-	}
-
-	sec = elf_section_by_name(elf, &ehdr, &shdr,
-				  ".note.gnu.build-id", NULL);
-	if (sec == NULL) {
-		sec = elf_section_by_name(elf, &ehdr, &shdr,
-					  ".notes", NULL);
-		if (sec == NULL)
-			goto out;
-	}
-
-	data = elf_getdata(sec, NULL);
-	if (data == NULL)
-		goto out;
-
-	ptr = data->d_buf;
-	while (ptr < (data->d_buf + data->d_size)) {
-		GElf_Nhdr *nhdr = ptr;
-		size_t namesz = NOTE_ALIGN(nhdr->n_namesz),
-		       descsz = NOTE_ALIGN(nhdr->n_descsz);
-		const char *name;
-
-		ptr += sizeof(*nhdr);
-		name = ptr;
-		ptr += namesz;
-		if (nhdr->n_type == NT_GNU_BUILD_ID &&
-		    nhdr->n_namesz == sizeof("GNU")) {
-			if (memcmp(name, "GNU", sizeof("GNU")) == 0) {
-				size_t sz = min(size, descsz);
-				memcpy(bf, ptr, sz);
-				memset(bf + sz, 0, size - sz);
-				err = descsz;
-				break;
-			}
-		}
-		ptr += descsz;
-	}
-
-out:
-	return err;
-}
-
-int filename__read_build_id(const char *filename, void *bf, size_t size)
-{
-	int fd, err = -1;
-	Elf *elf;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL) {
-		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
-		goto out_close;
-	}
-
-	err = elf_read_build_id(elf, bf, size);
-
-	elf_end(elf);
-out_close:
-	close(fd);
-out:
-	return err;
-}
-
-int sysfs__read_build_id(const char *filename, void *build_id, size_t size)
-{
-	int fd, err = -1;
-
-	if (size < BUILD_ID_SIZE)
-		goto out;
-
-	fd = open(filename, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	while (1) {
-		char bf[BUFSIZ];
-		GElf_Nhdr nhdr;
-		size_t namesz, descsz;
-
-		if (read(fd, &nhdr, sizeof(nhdr)) != sizeof(nhdr))
-			break;
-
-		namesz = NOTE_ALIGN(nhdr.n_namesz);
-		descsz = NOTE_ALIGN(nhdr.n_descsz);
-		if (nhdr.n_type == NT_GNU_BUILD_ID &&
-		    nhdr.n_namesz == sizeof("GNU")) {
-			if (read(fd, bf, namesz) != (ssize_t)namesz)
-				break;
-			if (memcmp(bf, "GNU", sizeof("GNU")) == 0) {
-				size_t sz = min(descsz, size);
-				if (read(fd, build_id, sz) == (ssize_t)sz) {
-					memset(build_id + sz, 0, size - sz);
-					err = 0;
-					break;
-				}
-			} else if (read(fd, bf, descsz) != (ssize_t)descsz)
-				break;
-		} else {
-			int n = namesz + descsz;
-			if (read(fd, bf, n) != n)
-				break;
-		}
-	}
-	close(fd);
-out:
-	return err;
-}
-
 char dso__symtab_origin(const struct dso *dso)
 {
 	static const char origin[] = {
@@ -1889,7 +1201,7 @@ static int machine__set_modules_path(struct machine *machine)
  * they are loaded) and for vmlinux, where only after we load all the
  * symbols we'll know where it starts and ends.
  */
-static struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
+struct map *map__new2(u64 start, struct dso *dso, enum map_type type)
 {
 	struct map *map = calloc(1, (sizeof(*map) +
 				     (dso->kernel ? sizeof(struct kmap) : 0)));
@@ -2206,7 +1518,7 @@ out_try_fixup:
 	return err;
 }
 
-static void dsos__add(struct list_head *head, struct dso *dso)
+void dsos__add(struct list_head *head, struct dso *dso)
 {
 	list_add_tail(&dso->node, head);
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ea81399fa768..15c6738041fd 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -203,6 +203,7 @@ void dso__sort_by_name(struct dso *dso, enum map_type type);
 
 struct dso *__dsos__findnew(struct list_head *head, const char *name);
 
+void dsos__add(struct list_head *head, struct dso *dso);
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter);
@@ -254,11 +255,14 @@ struct symbol *dso__find_symbol_by_name(struct dso *dso, enum map_type type,
 int filename__read_build_id(const char *filename, void *bf, size_t size);
 int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 bool __dsos__read_build_ids(struct list_head *head, bool with_hits);
+bool dso__build_id_equal(const struct dso *dso, u8 *build_id);
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start, u64 end));
 
+struct map *map__new2(u64 start, struct dso *dso, enum map_type type);
+
 void machine__destroy_kernel_maps(struct machine *machine);
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel);
 int machine__create_kernel_maps(struct machine *machine);
@@ -270,6 +274,8 @@ void machines__destroy_guest_kernel_maps(struct rb_root *machines);
 int symbol__init(void);
 void symbol__exit(void);
 void symbol__elf_init(void);
+struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name);
+void symbols__insert(struct rb_root *symbols, struct symbol *sym);
 size_t symbol__fprintf_symname_offs(const struct symbol *sym,
 				    const struct addr_location *al, FILE *fp);
 size_t symbol__fprintf_symname(const struct symbol *sym, FILE *fp);
@@ -277,4 +283,13 @@ bool symbol_type__is_a(char symbol_type, enum map_type map_type);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
+void symbols__fixup_duplicate(struct rb_root *symbols);
+void symbols__fixup_end(struct rb_root *symbols);
+void __map_groups__fixup_end(struct map_groups *mg, enum map_type type);
+
+int dso__synthesize_plt_symbols(struct dso *dso, struct map *map,
+				symbol_filter_t filter);
+int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
+		  symbol_filter_t filter, int kmodule, int want_symtab);
+
 #endif /* __PERF_SYMBOL */
-- 
1.7.10.1

