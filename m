Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2HUQJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2HUQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:09:02 -0400
Date: Tue, 21 Aug 2012 09:07:57 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-a44f605b2f6eadb771a052aa3a5eefb342b38a39@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-14-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-14-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Switch dso__synthesize_plt_symbols()
  to use symsrc
Git-Commit-ID: a44f605b2f6eadb771a052aa3a5eefb342b38a39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:08:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a44f605b2f6eadb771a052aa3a5eefb342b38a39
Gitweb:     http://git.kernel.org/tip/a44f605b2f6eadb771a052aa3a5eefb342b38a39
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:59 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:34:36 -0300

perf symbols: Switch dso__synthesize_plt_symbols() to use symsrc

Previously dso__synthesize_plt_symbols() was reopening the elf file to
obtain dynsyms from it. Rather than reopen the file, use the already
opened reference within the symsrc to access it.

Setup for the later patch

"perf symbols: Use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-14-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     |   25 +++++++------------------
 tools/perf/util/symbol-minimal.c |    3 ++-
 tools/perf/util/symbol.c         |    8 +++++---
 tools/perf/util/symbol.h         |    4 ++--
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
index 1b16c27..cc580c0 100644
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
index dd9e867..2981513 100644
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
