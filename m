Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2HUQLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:11:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60759 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab2HUQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:11:04 -0400
Date: Tue, 21 Aug 2012 09:10:44 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-3aafe5ae08f2aed378e06d78b207883879d25cbe@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-17-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-17-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Use both runtime and debug images
Git-Commit-ID: 3aafe5ae08f2aed378e06d78b207883879d25cbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:10:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aafe5ae08f2aed378e06d78b207883879d25cbe
Gitweb:     http://git.kernel.org/tip/3aafe5ae08f2aed378e06d78b207883879d25cbe
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:23:02 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 14:46:55 -0300

perf symbols: Use both runtime and debug images

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
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-17-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c     |    5 ++
 tools/perf/util/symbol-minimal.c |    6 +++
 tools/perf/util/symbol.c         |   77 +++++++++++++++++++++----------------
 tools/perf/util/symbol.h         |    1 +
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
index 7747ea6..6738ea1 100644
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
index 739e5a3..2293a4a 100644
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
+		symsrc__destroy(&ss_[ss_pos - 1]);
+out_free:
 	free(name);
 	if (ret < 0 && strstr(dso->name, " (deleted)") != NULL)
 		return 0;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1f3eed2..fc4b1e6 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -253,6 +253,7 @@ void symsrc__destroy(struct symsrc *ss);
 int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		 enum dso_binary_type type);
 bool symsrc__has_symtab(struct symsrc *ss);
+bool symsrc__possibly_runtime(struct symsrc *ss);
 
 #define DSO__SWAP(dso, type, val)			\
 ({							\
