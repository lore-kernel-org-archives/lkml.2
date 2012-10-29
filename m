Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab2J2PJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:09:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab2J2PJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:09:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/14] perf tools: Move BUILD_ID_SIZE into build-id object
Date: Mon, 29 Oct 2012 13:09:02 -0200
Message-Id: <1351523353-27982-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351523353-27982-1-git-send-email-acme@infradead.org>
References: <1351523353-27982-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving BUILD_ID_SIZE define into build-id object, plus include related
changes.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351372712-21104-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c |    1 +
 tools/perf/util/annotate.c         |    1 +
 tools/perf/util/build-id.h         |    6 +++++-
 tools/perf/util/event.h            |    3 +--
 tools/perf/util/symbol.h           |    3 +--
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index edb26ea..fae8b25 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/strlist.h"
 #include "util/build-id.h"
+#include "util/symbol.h"
 
 static int build_id_cache__add_file(const char *filename, const char *debugdir)
 {
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index f0a9103..7a34dd1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "annotate.h"
 #include <pthread.h>
+#include <linux/bitops.h>
 
 const char 	*disassembler_style;
 const char	*objdump_path;
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index f6d9ff9..a811f5c 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -1,9 +1,13 @@
 #ifndef PERF_BUILD_ID_H_
 #define PERF_BUILD_ID_H_ 1
 
-#include "session.h"
+#define BUILD_ID_SIZE 20
+
+#include "tool.h"
+#include "types.h"
 
 extern struct perf_tool build_id__mark_dso_hit_ops;
+struct dso;
 
 int build_id__sprintf(const u8 *build_id, int len, char *bf);
 char *dso__build_id_filename(struct dso *self, char *bf, size_t size);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index da97aff..0d573ff 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -6,6 +6,7 @@
 
 #include "../perf.h"
 #include "map.h"
+#include "build-id.h"
 
 /*
  * PERF_SAMPLE_IP | PERF_SAMPLE_TID | *
@@ -96,8 +97,6 @@ struct perf_sample {
 	struct stack_dump user_stack;
 };
 
-#define BUILD_ID_SIZE 20
-
 struct build_id_event {
 	struct perf_event_header header;
 	pid_t			 pid;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d70f676..6eb7d3b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <byteswap.h>
 #include <libgen.h>
+#include "build-id.h"
 
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
@@ -57,8 +58,6 @@ char *strxfrchar(char *s, char from, char to);
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
 
-#define BUILD_ID_SIZE 20
-
 /** struct symbol - symtab entry
  *
  * @ignore - resolvable but tools ignore it (e.g. idle routines)
-- 
1.7.9.2.358.g22243

