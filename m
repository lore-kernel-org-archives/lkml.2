Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab2HMSnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:43:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2HMSht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/38] perf symbols: Factor want_symtab out of dso__load_sym()
Date: Mon, 13 Aug 2012 15:37:16 -0300
Message-Id: <1344883039-13495-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Only one callsite of dso__load_sym() uses the want_symtab functionality,
so place the logic at the callsite instead of within dso__load_sym().

This sets us up for removal of want_symtab completely once we keep
multiple elf handles (within symsrc's) around.

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
Link: http://lkml.kernel.org/r/1344637382-22789-15-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     |   21 ++++++++++-----------
 tools/perf/util/symbol-minimal.c |    8 ++++++--
 tools/perf/util/symbol.c         |   10 +++++++---
 tools/perf/util/symbol.h         |    3 ++-
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
index cc580c0..11c2c60 100644
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
index 2981513..fa9f6b1 100644
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
1.7.1

