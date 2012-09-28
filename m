Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2I1Jlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:41:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59302 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757503Ab2I1JkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:22 -0400
X-AuditID: 9c930197-b7b6dae000000e70-70-5065708316a1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/12] perf tools: Convert to LIBPERL_SUPPORT
Date: Fri, 28 Sep 2012 18:32:04 +0900
Message-Id: <1348824728-14025-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without perf scripting, we can set NO_LIBPERL=1 as a
argument of make.  It then defines NO_LIBPERL macro for C code to do
the proper handling.  However it usually used in a negative semantics
- e.g. #ifndef - so we saw double negations which can be misleading.
Convert it to a positive form to make it more readable.

Also add _SUPPORT suffix for consistency and fix a few of indentation
in Makefile.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile                     | 19 ++++++++-----------
 tools/perf/builtin-script.c             |  2 +-
 tools/perf/util/trace-event-scripting.c | 10 +++++-----
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 31a07f95fd98..50d4e09a4eb4 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -606,20 +606,17 @@ ifndef NO_GTK2
 	endif
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
-       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
-       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
-       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+ifndef NO_LIBPERL
+	PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+	PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+	PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
 	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
+	ifeq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
+		BASIC_CFLAGS += -DLIBPERL_SUPPPORT
+		ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+		EXTLIBS += $(PERL_EMBED_LIBADD)
 		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
 		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 	endif
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 1be843aa1546..fcd5a68337e8 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1057,7 +1057,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
 			 lang_dirent.d_name);
-#ifdef NO_LIBPERL
+#ifndef LIBPERL_SUPPORT
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 8715a1006d00..e50040bffd67 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -156,16 +156,16 @@ static void register_perl_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPERL
+#ifdef LIBPERL_SUPPORT
+extern struct scripting_ops perl_scripting_ops;
+
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_unsupported_ops);
+	register_perl_scripting(&perl_scripting_ops);
 }
 #else
-extern struct scripting_ops perl_scripting_ops;
-
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_ops);
+	register_perl_scripting(&perl_scripting_unsupported_ops);
 }
 #endif
-- 
1.7.11.4

