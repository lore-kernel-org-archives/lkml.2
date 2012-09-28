Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab2I1Jli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:41:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47736 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2I1JkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:40:23 -0400
X-AuditID: 9c930197-b7b6dae000000e70-74-5065708388e9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/12] perf tools: Convert to LIBPYTHON_SUPPORT
Date: Fri, 28 Sep 2012 18:32:05 +0900
Message-Id: <1348824728-14025-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
References: <1348824728-14025-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For building perf without python scripting, we can set NO_LIBPYTHON=1
as a argument of make.  It then defines NO_LIBPYTHON macro for C code
to do the proper handling.  However it usually used in a negative
semantics - e.g. #ifndef - so we saw double negations which can be
misleading.  Convert it to a positive form to make it more readable.
Also add _SUPPORT suffix for consistency.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile                     |  2 +-
 tools/perf/builtin-script.c             |  2 +-
 tools/perf/util/trace-event-scripting.c | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 50d4e09a4eb4..45f8920bab2b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -624,7 +624,6 @@ endif
 
 disable-python = $(eval $(disable-python_code))
 define disable-python_code
-  BASIC_CFLAGS += -DNO_LIBPYTHON
   $(if $(1),$(warning No $(1) was found))
   $(warning Python support won't be built)
 endef
@@ -684,6 +683,7 @@ else
           $(warning $(and ,))
           $(error   $(and ,))
         else
+          BASIC_CFLAGS += -DLIBPYTHON_SUPPORT
           ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
           EXTLIBS += $(PYTHON_EMBED_LIBADD)
           LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fcd5a68337e8..141c62f9ae73 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1061,7 +1061,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
-#ifdef NO_LIBPYTHON
+#ifndef LIBPYTHON_SUPPORT
 		if (strstr(lang_path, "python"))
 			continue;
 #endif
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index e50040bffd67..625f5a3ac5bf 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -93,17 +93,17 @@ static void register_python_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPYTHON
+#ifdef LIBPYTHON_SUPPORT
+extern struct scripting_ops python_scripting_ops;
+
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_unsupported_ops);
+	register_python_scripting(&python_scripting_ops);
 }
 #else
-extern struct scripting_ops python_scripting_ops;
-
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_ops);
+	register_python_scripting(&python_scripting_unsupported_ops);
 }
 #endif
 
-- 
1.7.11.4

