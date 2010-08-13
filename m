Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423Ab0HMJ1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:27:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57859 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab0HMJ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:27:46 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, kernel-team@lists.ubuntu.com,
        Will Deacon <Will.Deacon@arm.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: [PATCH v3] perf symbols: fix symbol offset breakage with separated debug
Date: Fri, 13 Aug 2010 10:27:33 +0100
Message-Id: <1281691653-7346-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281619173-14004-1-git-send-email-dave.martin@linaro.org>
References: <1281619173-14004-1-git-send-email-dave.martin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a minor error in v2 where a check was erronueously done
twice.

Original commit message follows:

Applies to 2.6.35
(git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6.git
perf/core branch)

The new patch loads the ELF section headers from a separate
file if necessary, to avoid getting confused by the different
section file offsets seen in debug images.  Invalid section
headers are detected by checking for the presence of non-
writable SHT_NOBITS sections, which don't make sense under
normal circumstances.

In particular, this allows symbols in ET_EXEC images to get
fixed up correctly in the presence of separated debug images.

The image search loop is also tidied up to fix a minor bug
which would perform the same image load attempt more than
once in some situations.

For non-separated images, the headers should get loaded from
the same image as the symbols, in the usual way.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
---
 tools/perf/util/symbol.c |  182 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 170 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1a36773..8328b60 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,4 +1,5 @@
 #define _GNU_SOURCE
+#include <assert.h>
 #include <ctype.h>
 #include <dirent.h>
 #include <errno.h>
@@ -978,8 +979,106 @@ static size_t elf_addr_to_index(Elf *elf, GElf_Addr addr)
 	return -1;
 }
 
+/**
+ * Read all section headers, copying them into a separate array so they survive
+ * elf_end.
+ *
+ * @elf: the libelf instance to operate on.
+ * @ehdr: the elf header: this must already have been read with gelf_getehdr().
+ * @count: the number of headers read is assigned to *count on successful
+ *	return.  count must not be NULL.
+ *
+ * Returns a pointer to the allocated headers, which should be deallocated with
+ * free() when no longer needed.
+ */
+static GElf_Shdr *elf_get_all_shdrs(Elf *elf, GElf_Ehdr const *ehdr,
+				    unsigned *count)
+{
+	GElf_Shdr *shdrs;
+	Elf_Scn *scn;
+	unsigned max_index = 0;
+	unsigned i;
+
+	shdrs = malloc(ehdr->e_shnum * sizeof *shdrs);
+	if (!shdrs)
+		return NULL;
+
+	for (i = 0; i < ehdr->e_shnum; i++)
+		shdrs[i].sh_type = SHT_NULL;
+
+	for (scn = NULL; (scn = elf_nextscn(elf, scn)); ) {
+		size_t j;
+
+		/*
+		 * Just assuming we get section 0, 1, ... in sequence may lead
+		 * to wrong section indices.  Check the index explicitly:
+		 */
+		j = elf_ndxscn(scn);
+		assert(j < ehdr->e_shnum);
+
+		if (j > max_index)
+			max_index = j;
+
+		if (!gelf_getshdr(scn, &shdrs[j]))
+			goto error;
+	}
+
+	*count = max_index + 1;
+	return shdrs;
+
+error:
+	free(shdrs);
+	return NULL;
+}
+
+/**
+ * Check that the section headers @shdrs reflect accurately the file data
+ * layout of the image that was loaded during perf record.  This is generally
+ * not true for separated debug images generated with e.g.,
+ * objcopy --only-keep-debug.
+ *
+ * We identify invalid files by checking for non-empty sections which are
+ * declared as having no file data (SHT_NOBITS) but are not writable.
+ *
+ * @shdrs: the full set of section headers, as loaded by elf_get_all_shdrs().
+ * @count: the number of headers present in @shdrs.
+ *
+ * Returns 1 for valid headers, 0 otherwise.
+ */
+static int elf_check_shdrs_valid(GElf_Shdr const *shdrs, unsigned count)
+{
+	unsigned i;
+
+	for (i = 0; i < count; i++) {
+		if (shdrs[i].sh_type == SHT_NOBITS &&
+		    !(shdrs[i].sh_flags & SHF_WRITE) &&
+		    shdrs[i].sh_size != 0)
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Notes:
+ *
+ * If saved_shdrs is non-NULL, the section headers will be read if found, and
+ * will be used for address fixups.  saved_shdrs_count must also be non-NULL in
+ * this case.  This may be needed for separated debug images, since the section
+ * headers and symbols may need to come from separate images in that case.
+ *
+ * Note: irrespective of whether this function returns successfully,
+ * *saved_shdrs may get initialised if saved_shdrs is non-NULL.  It is the
+ * caller's responsibility to free() it when non longer needed.
+ *
+ * If want_symtab == 1, this function will only load symbols from .symtab
+ * sections.  Otherwise (want_symtab == 0), .dynsym or .symtab symbols are
+ * loaded.  This feature is used by dso__load() to search for the best image
+ * to load.
+ */
 static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			 int fd, symbol_filter_t filter, int kmodule,
+			 GElf_Shdr **saved_shdrs, unsigned *saved_shdrs_count,
 			 int want_symtab)
 {
 	struct kmap *kmap = self->kernel ? map__kmap(map) : NULL;
@@ -998,6 +1097,9 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 	int nr = 0;
 	size_t opdidx = 0;
 
+	if (saved_shdrs != NULL)
+		assert(saved_shdrs_count != NULL);
+
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		pr_debug("%s: cannot read %s ELF file.\n", __func__, name);
@@ -1021,6 +1123,34 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			goto out_elf_end;
 	}
 
+	/*
+	 * Copy all section headers from the image if requested and if not
+	 * already loaded.
+	 */
+	if (saved_shdrs != NULL && *saved_shdrs == NULL) {
+		GElf_Shdr *shdrs;
+		unsigned count;
+
+		shdrs = elf_get_all_shdrs(elf, &ehdr, &count);
+		if (shdrs == NULL)
+			goto out_elf_end;
+
+		/*
+		 * Only keep the headers if they reflect the actual run-time
+		 * image's file layout:
+		 */
+		if (elf_check_shdrs_valid(shdrs, count)) {
+			*saved_shdrs = shdrs;
+			*saved_shdrs_count = count;
+		} else
+			free(shdrs);
+	}
+
+	/* If no genuine ELF headers are available yet, give up: we can't
+	 * adjust symbols correctly in that case: */
+	if (saved_shdrs != NULL && *saved_shdrs == NULL)
+		goto out_elf_end;
+
 	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
 	if (sec == NULL) {
 		if (want_symtab)
@@ -1153,12 +1283,25 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 			goto new_symbol;
 		}
 
+		/*
+		 * Currently, symbols for shared objects and PIE executables
+		 * (i.e., ET_DYN) do not seem to get adjusted.  This might need
+		 * to change if file offset == virtual address is not actually
+		 * guaranteed for these images.  ELF doesn't provide this
+		 * guarantee natively.
+		 */
 		if (curr_dso->adjust_symbols) {
 			pr_debug4("%s: adjusting symbol: st_value: %#Lx "
 				  "sh_addr: %#Lx sh_offset: %#Lx\n", __func__,
 				  (u64)sym.st_value, (u64)shdr.sh_addr,
 				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+			if (saved_shdrs && *saved_shdrs &&
+			    sym.st_shndx < *saved_shdrs_count)
+				sym.st_value -=
+					(*saved_shdrs)[sym.st_shndx].sh_addr -
+					(*saved_shdrs)[sym.st_shndx].sh_offset;
+			else
+				sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 		}
 		/*
 		 * We need to figure out if the object was created from C++ sources
@@ -1395,6 +1538,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	struct machine *machine;
 	const char *root_dir;
 	int want_symtab;
+	GElf_Shdr *saved_shdrs = NULL;
+	unsigned saved_shdrs_count;
 
 	dso__set_loaded(self, map->type);
 
@@ -1425,13 +1570,13 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->origin = DSO__ORIG_BUILD_ID_CACHE, want_symtab = 1;
-	     self->origin != DSO__ORIG_NOT_FOUND;
-	     self->origin++) {
+	self->origin = DSO__ORIG_BUILD_ID_CACHE;
+	want_symtab = 1;
+	while (1) {
 		switch (self->origin) {
 		case DSO__ORIG_BUILD_ID_CACHE:
 			if (dso__build_id_filename(self, name, size) == NULL)
-				continue;
+				goto continue_next;
 			break;
 		case DSO__ORIG_FEDORA:
 			snprintf(name, size, "/usr/lib/debug%s.debug",
@@ -1445,7 +1590,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 
 			if (!self->has_build_id)
-				continue;
+				goto continue_next;
 
 			build_id__sprintf(self->build_id,
 					  sizeof(self->build_id),
@@ -1469,21 +1614,24 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		default:
 			/*
 			 * If we wanted a full symtab but no image had one,
-			 * relax our requirements and repeat the search.
+			 * relax our requirements and repeat the search,
+			 * providing we saw some valid section headers:
 			 */
-			if (want_symtab) {
+			if (want_symtab && saved_shdrs != NULL) {
 				want_symtab = 0;
 				self->origin = DSO__ORIG_BUILD_ID_CACHE;
-			} else
 				continue;
+			} else
+				goto done;
 		}
 
 		/* Name is now the name of the next image to try */
 		fd = open(name, O_RDONLY);
 		if (fd < 0)
-			continue;
+			goto continue_next;
 
 		ret = dso__load_sym(self, map, name, fd, filter, 0,
+				    &saved_shdrs, &saved_shdrs_count,
 				    want_symtab);
 		close(fd);
 
@@ -1492,7 +1640,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		 * info!?!?
 		 */
 		if (!ret)
-			continue;
+			goto continue_next;
 
 		if (ret > 0) {
 			int nr_plt = dso__synthesize_plt_symbols(self, map, filter);
@@ -1500,9 +1648,18 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 				ret += nr_plt;
 			break;
 		}
+
+continue_next:
+		self->origin++;
+		continue;
 	}
 
+done:
 	free(name);
+
+	if (saved_shdrs)
+		free(saved_shdrs);
+
 	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
 		return 0;
 	return ret;
@@ -1768,7 +1925,8 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 		return -1;
 
 	dso__set_loaded(self, map->type);
-	err = dso__load_sym(self, map, vmlinux, fd, filter, 0, 0);
+	err = dso__load_sym(self, map, vmlinux, fd, filter, 0,
+			    NULL, NULL, 0);
 	close(fd);
 
 	if (err > 0)
-- 
1.7.0.4

