Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2HUQHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:07:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2HUQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:07:31 -0400
Date: Tue, 21 Aug 2012 09:06:08 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-b68e2f919c6d3a0422239c98673c35ff503e52fb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Introduce symsrc structure.
Git-Commit-ID: b68e2f919c6d3a0422239c98673c35ff503e52fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:06:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b68e2f919c6d3a0422239c98673c35ff503e52fb
Gitweb:     http://git.kernel.org/tip/b68e2f919c6d3a0422239c98673c35ff503e52fb
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:57 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:31:44 -0300

perf symbols: Introduce symsrc structure.

Factors opening of certain sections & tracking certain elf info into an
external structure.

The goal here is to keep multiple elfs (and their looked up
sections/indexes) around during the symbol generation process (in
dso__load()).

We need this to properly resolve symbols on PPC due to the use of
function descriptors & the .opd section (ie: symbols which are functions
don't point to their actual location, they point to their function
descriptor in .opd which contains their actual location.

It would be possible to just keep the (Elf *) around, but then we'd end
up with duplicate code for looking up the same sections and checking for
the existence of an important section wouldn't be as clean (and we need
to keep the Elf stuff confined to symtab-elf.c).

Utilized by the later patch
"perf symbols: Use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-12-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     |  119 ++++++++++++++++++++++++++++---------
 tools/perf/util/symbol-minimal.c |   30 +++++++++-
 tools/perf/util/symbol.c         |   22 ++++----
 tools/perf/util/symbol.h         |   36 +++++++++++-
 4 files changed, 163 insertions(+), 44 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a9a194d..6974b2a 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -536,24 +536,25 @@ static int dso__swap_init(struct dso *dso, unsigned char eidata)
 	return 0;
 }
 
-int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
-		  symbol_filter_t filter, int kmodule, int want_symtab)
+
+void symsrc__destroy(struct symsrc *ss)
+{
+	free(ss->name);
+	elf_end(ss->elf);
+	close(ss->fd);
+}
+
+int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
+		 enum dso_binary_type type)
 {
-	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
-	struct map *curr_map = map;
-	struct dso *curr_dso = dso;
-	Elf_Data *symstrs, *secstrs;
-	uint32_t nr_syms;
 	int err = -1;
-	uint32_t idx;
 	GElf_Ehdr ehdr;
-	GElf_Shdr shdr, opdshdr;
-	Elf_Data *syms, *opddata = NULL;
-	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx, *opdsec;
 	Elf *elf;
-	int nr = 0;
-	size_t opdidx = 0;
+	int fd;
+
+	fd = open(name, O_RDONLY);
+	if (fd < 0)
+		return -1;
 
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
@@ -580,19 +581,88 @@ int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
 			goto out_elf_end;
 	}
 
-	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	ss->symtab = elf_section_by_name(elf, &ehdr, &ss->symshdr, ".symtab",
+			NULL);
+	if (ss->symshdr.sh_type != SHT_SYMTAB)
+		ss->symtab = NULL;
+
+	ss->dynsym_idx = 0;
+	ss->dynsym = elf_section_by_name(elf, &ehdr, &ss->dynshdr, ".dynsym",
+			&ss->dynsym_idx);
+	if (ss->dynshdr.sh_type != SHT_DYNSYM)
+		ss->dynsym = NULL;
+
+	ss->opdidx = 0;
+	ss->opdsec = elf_section_by_name(elf, &ehdr, &ss->opdshdr, ".opd",
+			&ss->opdidx);
+	if (ss->opdshdr.sh_type != SHT_PROGBITS)
+		ss->opdsec = NULL;
+
+	if (dso->kernel == DSO_TYPE_USER) {
+		GElf_Shdr shdr;
+		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
+				elf_section_by_name(elf, &ehdr, &shdr,
+						     ".gnu.prelink_undo",
+						     NULL) != NULL);
+	} else {
+		ss->adjust_symbols = 0;
+	}
+
+	ss->name   = strdup(name);
+	if (!ss->name)
+		goto out_elf_end;
+
+	ss->elf    = elf;
+	ss->fd     = fd;
+	ss->ehdr   = ehdr;
+	ss->type   = type;
+
+	return 0;
+
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+	return err;
+}
+
+int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
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
+	elf = ss->elf;
+	ehdr = ss->ehdr;
+	sec = ss->symtab;
+	shdr = ss->symshdr;
+
 	if (sec == NULL) {
 		if (want_symtab)
 			goto out_elf_end;
 
-		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+		sec  = ss->dynsym;
+		shdr = ss->dynshdr;
 		if (sec == NULL)
 			goto out_elf_end;
 	}
 
-	opdsec = elf_section_by_name(elf, &ehdr, &opdshdr, ".opd", &opdidx);
-	if (opdshdr.sh_type != SHT_PROGBITS)
-		opdsec = NULL;
+	opdsec = ss->opdsec;
+	opdshdr = ss->opdshdr;
+	opdidx  = ss->opdidx;
 	if (opdsec)
 		opddata = elf_rawdata(opdsec, NULL);
 
@@ -619,14 +689,7 @@ int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	if (dso->kernel == DSO_TYPE_USER) {
-		dso->adjust_symbols = (ehdr.e_type == ET_EXEC ||
-				elf_section_by_name(elf, &ehdr, &shdr,
-						     ".gnu.prelink_undo",
-						     NULL) != NULL);
-	} else {
-		dso->adjust_symbols = 0;
-	}
+	dso->adjust_symbols = ss->adjust_symbols;
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name = elf_sym__name(&sym, symstrs);
@@ -770,8 +833,6 @@ new_symbol:
 	}
 	err = nr;
 out_elf_end:
-	elf_end(elf);
-out_close:
 	return err;
 }
 
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index bd8720b..1b16c27 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -241,6 +241,31 @@ out:
 	return ret;
 }
 
+int symsrc__init(struct symsrc *ss, struct dso *dso __used, const char *name,
+	         enum dso_binary_type type)
+{
+	int fd = open(name, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	ss->name = strdup(name);
+	if (!ss->name)
+		goto out_close;
+
+	ss->type = type;
+
+	return 0;
+out_close:
+	close(fd);
+	return -1;
+}
+
+void symsrc__destroy(struct symsrc *ss)
+{
+	free(ss->name);
+	close(ss->fd);
+}
+
 int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
 				struct map *map __used,
 				symbol_filter_t filter __used)
@@ -248,14 +273,13 @@ int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
 	return 0;
 }
 
-int dso__load_sym(struct dso *dso, struct map *map __used,
-		  const char *name, int fd __used,
+int dso__load_sym(struct dso *dso, struct map *map __used, struct symsrc *ss,
 		  symbol_filter_t filter __used, int kmodule __used,
 		  int want_symtab __used)
 {
 	unsigned char *build_id[BUILD_ID_SIZE];
 
-	if (filename__read_build_id(name, build_id, BUILD_ID_SIZE) > 0) {
+	if (filename__read_build_id(ss->name, build_id, BUILD_ID_SIZE) > 0) {
 		dso__set_build_id(dso, build_id);
 		return 1;
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8f5cabbf..afec3f0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1026,7 +1026,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	char *name;
 	int ret = -1;
-	int fd;
+	struct symsrc ss;
 	u_int i;
 	struct machine *machine;
 	char *root_dir = (char *) "";
@@ -1086,13 +1086,12 @@ restart:
 			continue;
 
 		/* Name is now the name of the next image to try */
-		fd = open(name, O_RDONLY);
-		if (fd < 0)
+		if (symsrc__init(&ss, dso, name, dso->symtab_type) < 0)
 			continue;
 
-		ret = dso__load_sym(dso, map, name, fd, filter, 0,
+		ret = dso__load_sym(dso, map, &ss, filter, 0,
 				    want_symtab);
-		close(fd);
+		symsrc__destroy(&ss);
 
 		/*
 		 * Some people seem to have debuginfo files _WITHOUT_ debug
@@ -1359,22 +1358,23 @@ out_failure:
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, symbol_filter_t filter)
 {
-	int err = -1, fd;
+	int err = -1;
+	struct symsrc ss;
 	char symfs_vmlinux[PATH_MAX];
 
 	snprintf(symfs_vmlinux, sizeof(symfs_vmlinux), "%s%s",
 		 symbol_conf.symfs, vmlinux);
-	fd = open(symfs_vmlinux, O_RDONLY);
-	if (fd < 0)
-		return -1;
 
 	if (dso->kernel == DSO_TYPE_GUEST_KERNEL)
 		dso->symtab_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 	else
 		dso->symtab_type = DSO_BINARY_TYPE__VMLINUX;
 
-	err = dso__load_sym(dso, map, symfs_vmlinux, fd, filter, 0, 0);
-	close(fd);
+	if (symsrc__init(&ss, dso, symfs_vmlinux, dso->symtab_type))
+		return -1;
+
+	err = dso__load_sym(dso, map, &ss, filter, 0, 0);
+	symsrc__destroy(&ss);
 
 	if (err > 0) {
 		dso__set_long_name(dso, (char *)vmlinux);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 37f1ea1..dd9e867 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -11,6 +11,12 @@
 #include <stdio.h>
 #include <byteswap.h>
 
+#ifndef NO_LIBELF_SUPPORT
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+#endif
+
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
@@ -219,6 +225,34 @@ struct dso {
 	char		 name[0];
 };
 
+struct symsrc {
+	char *name;
+	int fd;
+	enum dso_binary_type type;
+
+#ifndef NO_LIBELF_SUPPORT
+	Elf *elf;
+	GElf_Ehdr ehdr;
+
+	Elf_Scn *opdsec;
+	size_t opdidx;
+	GElf_Shdr opdshdr;
+
+	Elf_Scn *symtab;
+	GElf_Shdr symshdr;
+
+	Elf_Scn *dynsym;
+	size_t dynsym_idx;
+	GElf_Shdr dynshdr;
+
+	bool adjust_symbols;
+#endif
+};
+
+void symsrc__destroy(struct symsrc *ss);
+int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
+		 enum dso_binary_type type);
+
 #define DSO__SWAP(dso, type, val)			\
 ({							\
 	type ____r = val;				\
@@ -334,7 +368,7 @@ ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
 int dso__test_data(void);
-int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
+int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 		  symbol_filter_t filter, int kmodule, int want_symtab);
 int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
 				symbol_filter_t filter);
