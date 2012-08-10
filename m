Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab2HJWZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:25:04 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46402 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760251Ab2HJWXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:43 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 16/16] perf symbol: use both runtime and debug images
Date: Fri, 10 Aug 2012 15:23:02 -0700
Message-Id: <1344637382-22789-17-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-6078-0000-0000-00000E20A6A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We keep both a 'runtime' elf image as well as a 'debug' elf image around
and generate symbols by looking at both of these.

This eliminates the need for the want_symtab/goto restart mechanism
combined with iterating over and reopening the elf images a second time.

Also give dso__synthsize_plt_symbols() the runtime image (which has
dynsyms) instead of the symbol image (which may only have a symtab and
no dynsyms).

Previously if a debug image was found all runtime images were ignored.

This fixes 2 issues:

 - Symbol resolution to failure on PowerPC systems with debug symbols
   installed, as the debug images lack a '.opd' section which contains
   function descriptors.

 - On all archs, plt synthesis failed when a debug image was loaded and
   that debug image lacks a dynsym section while a runtime image has a
   dynsym section.

Assumptions:

 - If a .opd section exists, it is contained in the highest priority
   image with a dynsym section.

 - This generally implies that the debug image lacks a dynsym section
   (ie: it is marked as NO_BITS).

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c     |  5 +++
 tools/perf/util/symbol-minimal.c |  6 ++++
 tools/perf/util/symbol.c         | 77 +++++++++++++++++++++++-----------------
 tools/perf/util/symbol.h         |  1 +
 4 files changed, 56 insertions(+), 33 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 36e4a45..5b37e13 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -525,6 +525,11 @@ static int dso__swap_init(struct dso *dso, unsigned char eidata)
 	return 0;
 }
 
+bool symsrc__possibly_runtime(struct symsrc *ss)
+{
+	return ss->dynsym || ss->opdsec;
+}
+
 bool symsrc__has_symtab(struct symsrc *ss)
 {
 	return ss->symtab != NULL;
diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c0377a9..133a591 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -260,6 +260,12 @@ out_close:
 	return -1;
 }
 
+bool symsrc__possibly_runtime(struct symsrc *ss __used)
+{
+	/* Assume all sym sources could be a runtime image. */
+	return true;
+}
+
 bool symsrc__has_symtab(struct symsrc *ss __used)
 {
 	return false;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 739e5a3..2aa871a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1026,11 +1026,12 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	char *name;
 	int ret = -1;
-	struct symsrc ss;
 	u_int i;
 	struct machine *machine;
 	char *root_dir = (char *) "";
-	int want_symtab;
+	int ss_pos = 0;
+	struct symsrc ss_[2];
+	struct symsrc *syms_ss = NULL, *runtime_ss = NULL;
 
 	dso__set_loaded(dso, map->type);
 
@@ -1072,12 +1073,12 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		root_dir = machine->root_dir;
 
 	/* Iterate over candidate debug images.
-	 * On the first pass, only load images if they have a full symtab.
-	 * Failing that, do a second pass where we accept .dynsym also
+	 * Keep track of "interesting" ones (those which have a symtab, dynsym,
+	 * and/or opd section) for processing.
 	 */
-	want_symtab = 1;
-restart:
 	for (i = 0; i < DSO_BINARY_TYPE__SYMTAB_CNT; i++) {
+		struct symsrc *ss = &ss_[ss_pos];
+		bool next_slot = false;
 
 		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
@@ -1086,45 +1087,55 @@ restart:
 			continue;
 
 		/* Name is now the name of the next image to try */
-		if (symsrc__init(&ss, dso, name, symtab_type) < 0)
+		if (symsrc__init(ss, dso, name, symtab_type) < 0)
 			continue;
 
-		if (want_symtab && !symsrc__has_symtab(&ss)) {
-			symsrc__destroy(&ss);
-			continue;
+		if (!syms_ss && symsrc__has_symtab(ss)) {
+			syms_ss = ss;
+			next_slot = true;
 		}
 
-		ret = dso__load_sym(dso, map, &ss, &ss, filter, 0);
-
-		/*
-		 * Some people seem to have debuginfo files _WITHOUT_ debug
-		 * info!?!?
-		 */
-		if (!ret) {
-			symsrc__destroy(&ss);
-			continue;
+		if (!runtime_ss && symsrc__possibly_runtime(ss)) {
+			runtime_ss = ss;
+			next_slot = true;
 		}
 
-		if (ret > 0) {
-			int nr_plt;
+		if (next_slot) {
+			ss_pos++;
 
-			nr_plt = dso__synthesize_plt_symbols(dso, &ss, map, filter);
-			if (nr_plt > 0)
-				ret += nr_plt;
-			symsrc__destroy(&ss);
-			break;
+			if (syms_ss && runtime_ss)
+				break;
 		}
+
 	}
 
-	/*
-	 * If we wanted a full symtab but no image had one,
-	 * relax our requirements and repeat the search.
-	 */
-	if (ret <= 0 && want_symtab) {
-		want_symtab = 0;
-		goto restart;
+	if (!runtime_ss && !syms_ss)
+		goto out_free;
+
+	if (runtime_ss && !syms_ss) {
+		syms_ss = runtime_ss;
+	}
+
+	/* We'll have to hope for the best */
+	if (!runtime_ss && syms_ss)
+		runtime_ss = syms_ss;
+
+	if (syms_ss)
+		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, 0);
+	else
+		ret = -1;
+
+	if (ret > 0 && runtime_ss->dynsym) {
+		int nr_plt;
+
+		nr_plt = dso__synthesize_plt_symbols(dso, runtime_ss, map, filter);
+		if (nr_plt > 0)
+			ret += nr_plt;
 	}
 
+	for (; ss_pos > 0; ss_pos--)
+		symsrc__destroy(&ss_[ss_pos-1]);
+out_free:
 	free(name);
 	if (ret < 0 && strstr(dso->name, " (deleted)") != NULL)
 		return 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d55635d..cf011a8 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -253,6 +253,7 @@ void symsrc__destroy(struct symsrc *ss);
 int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		 enum dso_binary_type type);
 bool symsrc__has_symtab(struct symsrc *ss);
+bool symsrc__possibly_runtime(struct symsrc *ss);
 
 #define DSO__SWAP(dso, type, val)			\
 ({							\
-- 
1.7.11.3

