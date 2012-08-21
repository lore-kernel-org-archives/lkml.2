Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2HUQKL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:10:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60742 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2HUQKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:10:09 -0400
Date: Tue, 21 Aug 2012 09:09:47 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-261360b6e90a782f0a63d8f61a67683c376c88cf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-16-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-16-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Convert dso__load_syms to take 2 symsrc's
Git-Commit-ID: 261360b6e90a782f0a63d8f61a67683c376c88cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:09:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  261360b6e90a782f0a63d8f61a67683c376c88cf
Gitweb:     http://git.kernel.org/tip/261360b6e90a782f0a63d8f61a67683c376c88cf
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:23:01 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:41:33 -0300

perf symbols: Convert dso__load_syms to take 2 symsrc's

To properly handle platforms with an opd section, both a runtime image
(which contains the opd section but possibly lacks symbols) and a symbol
image (which probably lacks an opd section but has symbols).

The next patch ("perf symbol: use both runtime and debug images")
adjusts the callsite in dso__load() to take advantage of being able to
pass both runtime & debug images.

Assumptions made here:

 - The opd section, if it exists in the runtime image, has headers in
   both the runtime image and the debug/syms image.

 - The index of the opd section (again, only if it exists in the runtime
   image) is the same in both the runtime and debug/symbols image.

Both of these are true on RHEL, but it is unclear how accurate they are
in general (on platforms with function descriptors in opd sections).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-16-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     |   47 +++++++++++++++++++------------------
 tools/perf/util/symbol-minimal.c |    1 +
 tools/perf/util/symbol.c         |    4 +-
 tools/perf/util/symbol.h         |    5 ++-
 4 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 492ebec..36e4a45 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -619,7 +619,8 @@ out_close:
 	return err;
 }
 
-int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
+int dso__load_sym(struct dso *dso, struct map *map,
+		  struct symsrc *syms_ss, struct symsrc *runtime_ss,
 		  symbol_filter_t filter, int kmodule)
 {
 	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
@@ -630,31 +631,27 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 	int err = -1;
 	uint32_t idx;
 	GElf_Ehdr ehdr;
-	GElf_Shdr shdr, opdshdr;
+	GElf_Shdr shdr;
 	Elf_Data *syms, *opddata = NULL;
 	GElf_Sym sym;
-	Elf_Scn *sec, *sec_strndx, *opdsec;
+	Elf_Scn *sec, *sec_strndx;
 	Elf *elf;
 	int nr = 0;
-	size_t opdidx = 0;
 
-	dso->symtab_type = ss->type;
+	dso->symtab_type = syms_ss->type;
 
-	if (!ss->symtab) {
-		ss->symtab  = ss->dynsym;
-		ss->symshdr = ss->dynshdr;
+	if (!syms_ss->symtab) {
+		syms_ss->symtab  = syms_ss->dynsym;
+		syms_ss->symshdr = syms_ss->dynshdr;
 	}
 
-	elf = ss->elf;
-	ehdr = ss->ehdr;
-	sec = ss->symtab;
-	shdr = ss->symshdr;
+	elf = syms_ss->elf;
+	ehdr = syms_ss->ehdr;
+	sec = syms_ss->symtab;
+	shdr = syms_ss->symshdr;
 
-	opdsec = ss->opdsec;
-	opdshdr = ss->opdshdr;
-	opdidx  = ss->opdidx;
-	if (opdsec)
-		opddata = elf_rawdata(opdsec, NULL);
+	if (runtime_ss->opdsec)
+		opddata = elf_rawdata(runtime_ss->opdsec, NULL);
 
 	syms = elf_getdata(sec, NULL);
 	if (syms == NULL)
@@ -679,13 +676,14 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-	dso->adjust_symbols = ss->adjust_symbols;
+	dso->adjust_symbols = runtime_ss->adjust_symbols;
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
 		const char *elf_name = elf_sym__name(&sym, symstrs);
 		char *demangled = NULL;
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
+		bool used_opd = false;
 
 		if (kmap && kmap->ref_reloc_sym && kmap->ref_reloc_sym->name &&
 		    strcmp(elf_name, kmap->ref_reloc_sym->name) == 0)
@@ -704,14 +702,16 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 				continue;
 		}
 
-		if (opdsec && sym.st_shndx == opdidx) {
-			u32 offset = sym.st_value - opdshdr.sh_addr;
+		if (runtime_ss->opdsec && sym.st_shndx == runtime_ss->opdidx) {
+			u32 offset = sym.st_value - syms_ss->opdshdr.sh_addr;
 			u64 *opd = opddata->d_buf + offset;
 			sym.st_value = DSO__SWAP(dso, u64, *opd);
-			sym.st_shndx = elf_addr_to_index(elf, sym.st_value);
+			sym.st_shndx = elf_addr_to_index(runtime_ss->elf,
+					sym.st_value);
+			used_opd = true;
 		}
 
-		sec = elf_getscn(elf, sym.st_shndx);
+		sec = elf_getscn(runtime_ss->elf, sym.st_shndx);
 		if (!sec)
 			goto out_elf_end;
 
@@ -777,7 +777,8 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 			goto new_symbol;
 		}
 
-		if (curr_dso->adjust_symbols && sym.st_value) {
+		if ((used_opd && runtime_ss->adjust_symbols)
+				|| (!used_opd && syms_ss->adjust_symbols)) {
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
 				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
 				  (u64)sym.st_value, (u64)shdr.sh_addr,
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 11c2c60..7747ea6 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -280,6 +280,7 @@ int dso__synthesize_plt_symbols(struct dso *dso __used,
 }
 
 int dso__load_sym(struct dso *dso, struct map *map __used, struct symsrc *ss,
+		  struct symsrc *runtime_ss __used,
 		  symbol_filter_t filter __used, int kmodule __used)
 {
 	unsigned char *build_id[BUILD_ID_SIZE];
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8e7d74f..739e5a3 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1094,7 +1094,7 @@ restart:
 			continue;
 		}
 
-		ret = dso__load_sym(dso, map, &ss, filter, 0);
+		ret = dso__load_sym(dso, map, &ss, &ss, filter, 0);
 
 		/*
 		 * Some people seem to have debuginfo files _WITHOUT_ debug
@@ -1380,7 +1380,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
 		return -1;
 
-	err = dso__load_sym(dso, map, &ss, filter, 0);
+	err = dso__load_sym(dso, map, &ss, &ss, filter, 0);
 	symsrc__destroy(&ss);
 
 	if (err > 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index fa9f6b1..1f3eed2 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -369,8 +369,9 @@ ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
 int dso__test_data(void);
-int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
-		  symbol_filter_t filter, int kmodule);
+int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
+		  struct symsrc *runtime_ss, symbol_filter_t filter,
+		  int kmodule);
 int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss,
 				struct map *map, symbol_filter_t filter);
 
