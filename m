Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2DPRs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:48:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49696 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2DPRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:48:54 -0400
Date: Mon, 16 Apr 2012 19:48:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120416174848.GA14173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 6c7b8e82aab75a25581c4d446fc87f96634e9ef9 x86: Handle failures of parsing immediate operands in the instruction decoder

 Thanks,

	Ingo

------------------>
Chanho Park (1):
      perf archive: Correct cutting of symbolic link

Jiri Olsa (2):
      perf session: Skip event correctly for unknown id/machine
      perf tools: Fix parsers' rules to dependencies

Masami Hiramatsu (1):
      x86: Handle failures of parsing immediate operands in the instruction decoder

Namhyung Kim (1):
      perf tools: Ignore auto-generated bison/flex files

Stephane Eranian (1):
      perf tools: fix NO_GTK2 Makefile config error


 arch/x86/lib/insn.c        |   53 +++++++++++++++++++++++++++++--------------
 tools/perf/.gitignore      |    2 +
 tools/perf/Makefile        |   21 +++++++----------
 tools/perf/perf-archive.sh |    3 +-
 tools/perf/util/session.c  |    4 +-
 5 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 25feb1a..b1e6c4b 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -379,8 +379,8 @@ err_out:
 	return;
 }
 
-/* Decode moffset16/32/64 */
-static void __get_moffset(struct insn *insn)
+/* Decode moffset16/32/64. Return 0 if failed */
+static int __get_moffset(struct insn *insn)
 {
 	switch (insn->addr_bytes) {
 	case 2:
@@ -397,15 +397,19 @@ static void __get_moffset(struct insn *insn)
 		insn->moffset2.value = get_next(int, insn);
 		insn->moffset2.nbytes = 4;
 		break;
+	default:	/* opnd_bytes must be modified manually */
+		goto err_out;
 	}
 	insn->moffset1.got = insn->moffset2.got = 1;
 
+	return 1;
+
 err_out:
-	return;
+	return 0;
 }
 
-/* Decode imm v32(Iz) */
-static void __get_immv32(struct insn *insn)
+/* Decode imm v32(Iz). Return 0 if failed */
+static int __get_immv32(struct insn *insn)
 {
 	switch (insn->opnd_bytes) {
 	case 2:
@@ -417,14 +421,18 @@ static void __get_immv32(struct insn *insn)
 		insn->immediate.value = get_next(int, insn);
 		insn->immediate.nbytes = 4;
 		break;
+	default:	/* opnd_bytes must be modified manually */
+		goto err_out;
 	}
 
+	return 1;
+
 err_out:
-	return;
+	return 0;
 }
 
-/* Decode imm v64(Iv/Ov) */
-static void __get_immv(struct insn *insn)
+/* Decode imm v64(Iv/Ov), Return 0 if failed */
+static int __get_immv(struct insn *insn)
 {
 	switch (insn->opnd_bytes) {
 	case 2:
@@ -441,15 +449,18 @@ static void __get_immv(struct insn *insn)
 		insn->immediate2.value = get_next(int, insn);
 		insn->immediate2.nbytes = 4;
 		break;
+	default:	/* opnd_bytes must be modified manually */
+		goto err_out;
 	}
 	insn->immediate1.got = insn->immediate2.got = 1;
 
+	return 1;
 err_out:
-	return;
+	return 0;
 }
 
 /* Decode ptr16:16/32(Ap) */
-static void __get_immptr(struct insn *insn)
+static int __get_immptr(struct insn *insn)
 {
 	switch (insn->opnd_bytes) {
 	case 2:
@@ -462,14 +473,17 @@ static void __get_immptr(struct insn *insn)
 		break;
 	case 8:
 		/* ptr16:64 is not exist (no segment) */
-		return;
+		return 0;
+	default:	/* opnd_bytes must be modified manually */
+		goto err_out;
 	}
 	insn->immediate2.value = get_next(unsigned short, insn);
 	insn->immediate2.nbytes = 2;
 	insn->immediate1.got = insn->immediate2.got = 1;
 
+	return 1;
 err_out:
-	return;
+	return 0;
 }
 
 /**
@@ -489,7 +503,8 @@ void insn_get_immediate(struct insn *insn)
 		insn_get_displacement(insn);
 
 	if (inat_has_moffset(insn->attr)) {
-		__get_moffset(insn);
+		if (!__get_moffset(insn))
+			goto err_out;
 		goto done;
 	}
 
@@ -517,16 +532,20 @@ void insn_get_immediate(struct insn *insn)
 		insn->immediate2.nbytes = 4;
 		break;
 	case INAT_IMM_PTR:
-		__get_immptr(insn);
+		if (!__get_immptr(insn))
+			goto err_out;
 		break;
 	case INAT_IMM_VWORD32:
-		__get_immv32(insn);
+		if (!__get_immv32(insn))
+			goto err_out;
 		break;
 	case INAT_IMM_VWORD:
-		__get_immv(insn);
+		if (!__get_immv(insn))
+			goto err_out;
 		break;
 	default:
-		break;
+		/* Here, insn must have an immediate, but failed */
+		goto err_out;
 	}
 	if (inat_has_second_immediate(insn->attr)) {
 		insn->immediate2.value = get_next(char, insn);
diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 416684b..26b823b 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -19,3 +19,5 @@ TAGS
 cscope*
 config.mak
 config.mak.autogen
+*-bison.*
+*-flex.*
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..03059e7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -237,21 +237,20 @@ export PERL_PATH
 FLEX = $(CROSS_COMPILE)flex
 BISON= $(CROSS_COMPILE)bison
 
-event-parser:
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
 
-$(OUTPUT)util/parse-events-flex.c: event-parser
-$(OUTPUT)util/parse-events-bison.c: event-parser
+$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
+	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d -o $(OUTPUT)util/parse-events-bison.c
 
-pmu-parser:
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
+$(OUTPUT)util/pmu-flex.c: util/pmu.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/pmu-flex.h -t util/pmu.l > $(OUTPUT)util/pmu-flex.c
 
-$(OUTPUT)util/pmu-flex.c: pmu-parser
-$(OUTPUT)util/pmu-bison.c: pmu-parser
+$(OUTPUT)util/pmu-bison.c: util/pmu.y
+	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c
 
-$(OUTPUT)util/parse-events.o: event-parser pmu-parser
+$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
 
 LIB_FILE=$(OUTPUT)libperf.a
 
@@ -527,7 +526,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
@@ -852,8 +851,6 @@ help:
 	@echo '  html		- make html documentation'
 	@echo '  info		- make GNU info documentation (access with info <foo>)'
 	@echo '  pdf		- make pdf documentation'
-	@echo '  event-parser	- make event parser code'
-	@echo '  pmu-parser	- make pmu format parser code'
 	@echo '  TAGS		- use etags to make tag information for source browsing'
 	@echo '  tags		- use ctags to make tag information for source browsing'
 	@echo '  cscope	- use cscope to make interactive browsing database'
diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 677e59d..95b6f8b 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -29,13 +29,14 @@ if [ ! -s $BUILDIDS ] ; then
 fi
 
 MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
+PERF_BUILDID_LINKDIR=$(readlink -f $PERF_BUILDID_DIR)/
 
 cut -d ' ' -f 1 $BUILDIDS | \
 while read build_id ; do
 	linkname=$PERF_BUILDID_DIR.build-id/${build_id:0:2}/${build_id:2}
 	filename=$(readlink -f $linkname)
 	echo ${linkname#$PERF_BUILDID_DIR} >> $MANIFEST
-	echo ${filename#$PERF_BUILDID_DIR} >> $MANIFEST
+	echo ${filename#$PERF_BUILDID_LINKDIR} >> $MANIFEST
 done
 
 tar cfj $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 00923cd..1efd3be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -876,11 +876,11 @@ static int perf_session_deliver_event(struct perf_session *session,
 		dump_sample(session, event, sample);
 		if (evsel == NULL) {
 			++session->hists.stats.nr_unknown_id;
-			return -1;
+			return 0;
 		}
 		if (machine == NULL) {
 			++session->hists.stats.nr_unprocessable_samples;
-			return -1;
+			return 0;
 		}
 		return tool->sample(tool, event, sample, evsel, machine);
 	case PERF_RECORD_MMAP:
