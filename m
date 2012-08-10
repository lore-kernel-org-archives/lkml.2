Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2HJWXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:23:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37732 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760231Ab2HJWXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:38 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 13/16] perf symbol: switch dso__synthesize_plt_symbols() to use symsrc
Date: Fri, 10 Aug 2012 15:22:59 -0700
Message-Id: <1344637382-22789-14-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-1976-0000-0000-000010120862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously dso__synthesize_plt_symbols() was reopening the elf file to
obtain dynsyms from it. Rather than reopen the file, use the already
opened reference within the symsrc to access it.

Setup for the later patch
"perf symbol: use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c     | 25 +++++++------------------
 tools/perf/util/symbol-minimal.c |  3 ++-
 tools/perf/util/symbol.c         |  8 +++++---
 tools/perf/util/symbol.h         |  4 ++--
 4 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3a9c38a..5915947 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -166,7 +166,7 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
  * And always look at the original dso, not at debuginfo packages, that
  * have the PLT data stripped out (shdr_rel_plt.sh_type == SHT_NOBITS).
  */
-int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
+int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss, struct map *map,
 				symbol_filter_t filter)
 {
 	uint32_t nr_rel_entries, idx;
@@ -181,21 +181,15 @@ int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
 	GElf_Ehdr ehdr;
 	char sympltname[1024];
 	Elf *elf;
-	int nr = 0, symidx, fd, err = 0;
+	int nr = 0, symidx, err = 0;
 
-	fd = open(name, O_RDONLY);
-	if (fd < 0)
-		goto out;
-
-	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
-	if (elf == NULL)
-		goto out_close;
+	elf = ss->elf;
+	ehdr = ss->ehdr;
 
-	if (gelf_getehdr(elf, &ehdr) == NULL)
-		goto out_elf_end;
+	scn_dynsym = ss->dynsym;
+	shdr_dynsym = ss->dynshdr;
+	dynsym_idx = ss->dynsym_idx;
 
-	scn_dynsym = elf_section_by_name(elf, &ehdr, &shdr_dynsym,
-					 ".dynsym", &dynsym_idx);
 	if (scn_dynsym == NULL)
 		goto out_elf_end;
 
@@ -291,13 +285,8 @@ int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
 
 	err = 0;
 out_elf_end:
-	elf_end(elf);
-out_close:
-	close(fd);
-
 	if (err == 0)
 		return nr;
-out:
 	pr_debug("%s: problems reading %s PLT info.\n",
 		 __func__, dso->long_name);
 	return 0;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index f8b5764..2f1584b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -266,7 +266,8 @@ void symsrc__destroy(struct symsrc *ss)
 	close(ss->fd);
 }
 
-int dso__synthesize_plt_symbols(struct dso *dso __used, char *name __used,
+int dso__synthesize_plt_symbols(struct dso *dso __used,
+				struct symsrc *ss __used,
 				struct map *map __used,
 				symbol_filter_t filter __used)
 {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2b3495a..f8a3068 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1091,21 +1091,23 @@ restart:
 
 		ret = dso__load_sym(dso, map, &ss, filter, 0,
 				    want_symtab);
-		symsrc__destroy(&ss);
 
 		/*
 		 * Some people seem to have debuginfo files _WITHOUT_ debug
 		 * info!?!?
 		 */
-		if (!ret)
+		if (!ret) {
+			symsrc__destroy(&ss);
 			continue;
+		}
 
 		if (ret > 0) {
 			int nr_plt;
 
-			nr_plt = dso__synthesize_plt_symbols(dso, name, map, filter);
+			nr_plt = dso__synthesize_plt_symbols(dso, &ss, map, filter);
 			if (nr_plt > 0)
 				ret += nr_plt;
+			symsrc__destroy(&ss);
 			break;
 		}
 	}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5e55f98..95b3996 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -370,8 +370,8 @@ ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 int dso__test_data(void);
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 		  symbol_filter_t filter, int kmodule, int want_symtab);
-int dso__synthesize_plt_symbols(struct dso *dso, char *name, struct map *map,
-				symbol_filter_t filter);
+int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss,
+				struct map *map, symbol_filter_t filter);
 
 void symbols__insert(struct rb_root *symbols, struct symbol *sym);
 void symbols__fixup_duplicate(struct rb_root *symbols);
-- 
1.7.11.3

