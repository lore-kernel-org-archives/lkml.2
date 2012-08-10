Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335Ab2HJW0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:26:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42586 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760234Ab2HJWXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:40 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 14/16] perf symbol: factor want_symtab out of dso__load_sym()
Date: Fri, 10 Aug 2012 15:23:00 -0700
Message-Id: <1344637382-22789-15-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-5930-0000-0000-00000ABD98CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only one callsite of dso__load_sym() uses the want_symtab functionality,
so place the logic at the callsite instead of within dso__load_sym().

This sets us up for removal of want_symtab completely once we keep
multiple elf handles (within symsrc's) around.

Setup for the later patch
"perf symbol: use both runtime and debug images"

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c     | 21 ++++++++++-----------
 tools/perf/util/symbol-minimal.c |  8 ++++++--
 tools/perf/util/symbol.c         | 10 +++++++---
 tools/perf/util/symbol.h         |  3 ++-
 4 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 5915947..492ebec 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -525,6 +525,10 @@ static int dso__swap_init(struct dso *dso, unsigned char eidata)
 	return 0;
 }
 
+bool symsrc__has_symtab(struct symsrc *ss)
+{
+	return ss->symtab != NULL;
+}
 
 void symsrc__destroy(struct symsrc *ss)
 {
@@ -616,7 +620,7 @@ out_close:
 }
 
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
-		  symbol_filter_t filter, int kmodule, int want_symtab)
+		  symbol_filter_t filter, int kmodule)
 {
 	struct kmap *kmap = dso->kernel ? map__kmap(map) : NULL;
 	struct map *curr_map = map;
@@ -636,21 +640,16 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
 
 	dso->symtab_type = ss->type;
 
+	if (!ss->symtab) {
+		ss->symtab  = ss->dynsym;
+		ss->symshdr = ss->dynshdr;
+	}
+
 	elf = ss->elf;
 	ehdr = ss->ehdr;
 	sec = ss->symtab;
 	shdr = ss->symshdr;
 
-	if (sec == NULL) {
-		if (want_symtab)
-			goto out_elf_end;
-
-		sec  = ss->dynsym;
-		shdr = ss->dynshdr;
-		if (sec == NULL)
-			goto out_elf_end;
-	}
-
 	opdsec = ss->opdsec;
 	opdshdr = ss->opdshdr;
 	opdidx  = ss->opdidx;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 2f1584b..3290f04 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -260,6 +260,11 @@ out_close:
 	return -1;
 }
 
+bool symsrc__has_symtab(struct symsrc *ss __used)
+{
+	return false;
+}
+
 void symsrc__destroy(struct symsrc *ss)
 {
 	free(ss->name);
@@ -275,8 +280,7 @@ int dso__synthesize_plt_symbols(struct dso *dso __used,
 }
 
 int dso__load_sym(struct dso *dso, struct map *map __used, struct symsrc *ss,
-		  symbol_filter_t filter __used, int kmodule __used,
-		  int want_symtab __used)
+		  symbol_filter_t filter __used, int kmodule __used)
 {
 	unsigned char *build_id[BUILD_ID_SIZE];
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f8a3068..8e7d74f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1089,8 +1089,12 @@ restart:
 		if (symsrc__init(&ss, dso, name, symtab_type) < 0)
 			continue;
 
-		ret = dso__load_sym(dso, map, &ss, filter, 0,
-				    want_symtab);
+		if (want_symtab && !symsrc__has_symtab(&ss)) {
+			symsrc__destroy(&ss);
+			continue;
+		}
+
+		ret = dso__load_sym(dso, map, &ss, filter, 0);
 
 		/*
 		 * Some people seem to have debuginfo files _WITHOUT_ debug
@@ -1376,7 +1380,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
 		return -1;
 
-	err = dso__load_sym(dso, map, &ss, filter, 0, 0);
+	err = dso__load_sym(dso, map, &ss, filter, 0);
 	symsrc__destroy(&ss);
 
 	if (err > 0) {
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 95b3996..c73f4f2 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -252,6 +252,7 @@ struct symsrc {
 void symsrc__destroy(struct symsrc *ss);
 int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		 enum dso_binary_type type);
+bool symsrc__has_symtab(struct symsrc *ss);
 
 #define DSO__SWAP(dso, type, val)			\
 ({							\
@@ -369,7 +370,7 @@ ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    u8 *data, ssize_t size);
 int dso__test_data(void);
 int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *ss,
-		  symbol_filter_t filter, int kmodule, int want_symtab);
+		  symbol_filter_t filter, int kmodule);
 int dso__synthesize_plt_symbols(struct dso *dso, struct symsrc *ss,
 				struct map *map, symbol_filter_t filter);
 
-- 
1.7.11.3

